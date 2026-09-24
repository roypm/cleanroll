import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';

import '../controllers/cleaning_controller.dart';
import '../models/album_info.dart';
import '../models/deletion_result.dart';
import '../models/order_mode.dart';
import '../models/photo_item.dart';
import '../models/photo_permission.dart';
import 'thumbnail_cache.dart';

/// First page of a cleaning session, or the full list when order is random.
class AlbumLoad {
  const AlbumLoad({
    required this.photos,
    required this.totalCount,
    required this.catalogComplete,
  });

  final List<PhotoItem> photos;
  final int totalCount;
  final bool catalogComplete;

  static const empty = AlbumLoad(
    photos: <PhotoItem>[],
    totalCount: 0,
    catalogComplete: true,
  );
}

class PhotoService {
  static const int albumFetchBatchSize = 6;
  static const int photoPageSize = 40;

  final Map<String, AssetPathEntity> _pathsById = {};
  final ThumbnailCache _thumbnails = ThumbnailCache();
  final Map<String, Future<Uint8List?>> _thumbnailLoads = {};

  int _pagingGeneration = 0;
  AssetPathEntity? _pagingPath;

  PhotoPermission _mapPermission(PermissionState state) {
    switch (state) {
      case PermissionState.authorized:
        return PhotoPermission.granted;
      case PermissionState.limited:
        return PhotoPermission.limited;
      case PermissionState.denied:
        return PhotoPermission.denied;
      case PermissionState.restricted:
        return PhotoPermission.permanentlyDenied;
      case PermissionState.notDetermined:
        return PhotoPermission.unknown;
    }
  }

  Future<PhotoPermission> currentPermission() async {
    final state = await PhotoManager.getPermissionState(
      requestOption: const PermissionRequestOption(),
    );
    return _mapPermission(state);
  }

  Future<PhotoPermission> requestPermission() async {
    final state = await PhotoManager.requestPermissionExtend();
    return _mapPermission(state);
  }

  Future<void> openSettings() => PhotoManager.openSetting();

  Future<List<AlbumInfo>> getAlbums() async {
    final paths = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: false,
      filterOption: _imageFilter(null),
    );
    _rememberPaths(paths);

    final albums = <AlbumInfo>[];
    for (var start = 0; start < paths.length; start += albumFetchBatchSize) {
      final end = start + albumFetchBatchSize;
      final batch = paths.sublist(
        start,
        end > paths.length ? paths.length : end,
      );
      final infos = await Future.wait(batch.map(_describeAlbum));
      for (final info in infos) {
        if (info != null) albums.add(info);
      }
    }
    return albums;
  }

  /// Loads enough photos to open Cleaning.
  ///
  /// Newest and oldest return the first page and keep the path so
  /// [loadRemainingPhotos] can append the rest. Random waits for the full
  /// list so the session can shuffle once.
  Future<AlbumLoad> loadAlbumStart(String albumId, OrderMode mode) async {
    final generation = ++_pagingGeneration;
    _pagingPath = null;

    final path = await _pathFor(albumId, mode);
    if (path == null || generation != _pagingGeneration) return AlbumLoad.empty;

    final count = await path.assetCountAsync;
    if (generation != _pagingGeneration) return AlbumLoad.empty;
    if (count <= 0) return AlbumLoad.empty;

    if (mode == OrderMode.random) {
      final photos = await _collectAll(path, generation);
      if (generation != _pagingGeneration) return AlbumLoad.empty;
      return AlbumLoad(
        photos: photos,
        totalCount: photos.length,
        catalogComplete: true,
      );
    }

    final first = await _fetchPage(path, 0);
    if (generation != _pagingGeneration) return AlbumLoad.empty;

    final shortPage = first.length < photoPageSize;
    final complete = shortPage || first.length >= count;
    if (!complete) _pagingPath = path;
    return AlbumLoad(
      photos: first,
      totalCount: complete ? first.length : count,
      catalogComplete: complete,
    );
  }

  /// Appends later pages into [controller] until the album is fully loaded.
  Future<void> loadRemainingPhotos(CleaningController controller) async {
    final path = _pagingPath;
    final generation = _pagingGeneration;
    if (path == null || controller.isCatalogComplete) return;

    try {
      var page = 1;
      while (generation == _pagingGeneration && !controller.isClosed) {
        final batch = await _fetchPage(path, page);
        if (generation != _pagingGeneration || controller.isClosed) return;

        final loadedBefore = controller.loadedCount;
        final shortPage = batch.length < photoPageSize;
        if (batch.isNotEmpty) controller.appendPhotos(batch);
        if (controller.isClosed) return;

        final addedNothing =
            batch.isNotEmpty && controller.loadedCount == loadedBefore;
        final reachedExpected = controller.loadedCount >= controller.totalCount;
        if (batch.isEmpty || shortPage || addedNothing || reachedExpected) {
          controller.completeCatalog();
          return;
        }
        page++;
      }
    } catch (_) {
      if (generation == _pagingGeneration && !controller.isClosed) {
        controller.completeCatalog();
      }
    }
  }

  /// Stops a background page load. Safe to call when the session is over.
  void cancelAlbumPaging() {
    _pagingGeneration++;
    _pagingPath = null;
  }

  Uint8List? cachedThumbnail(String assetId, {int size = 400}) {
    return _thumbnails.get(assetId, size);
  }

  void prefetchThumbnail(String assetId, {int size = 400}) {
    final key = '$size:$assetId';
    if (_thumbnails.get(assetId, size) != null ||
        _thumbnailLoads.containsKey(key)) {
      return;
    }
    thumbnailBytes(assetId, size: size);
  }

  Future<Uint8List?> thumbnailBytes(String assetId, {int size = 400}) {
    final cached = _thumbnails.get(assetId, size);
    if (cached != null) return Future<Uint8List?>.value(cached);

    final key = '$size:$assetId';
    final pending = _thumbnailLoads[key];
    if (pending != null) return pending;

    final future = _loadThumbnail(assetId, size);
    _thumbnailLoads[key] = future;
    future.whenComplete(() => _thumbnailLoads.remove(key));
    return future;
  }

  Future<Uint8List?> previewBytes(String assetId) {
    return thumbnailBytes(assetId, size: 1200);
  }

  /// Permanently deletes via the platform photo API.
  /// Call only from Review after the user taps Delete.
  /// The platform may show its own confirmation UI.
  Future<DeletionResult> deletePhotos(List<PhotoItem> photos) async {
    if (photos.isEmpty) {
      return const DeletionResult(successfulPhotos: [], failedPhotos: []);
    }

    try {
      final ids = photos.map((photo) => photo.id).toList(growable: false);
      final deletedIds = await PhotoManager.editor.deleteWithIds(ids);
      return interpretDeletion(requested: photos, deletedIds: deletedIds);
    } catch (error) {
      return interpretDeletion(requested: photos, error: error);
    }
  }

  Future<Uint8List?> _loadThumbnail(String assetId, int size) async {
    final entity = await AssetEntity.fromId(assetId);
    if (entity == null) return null;
    final bytes = await entity.thumbnailDataWithSize(
      ThumbnailSize.square(size),
    );
    if (bytes != null) _thumbnails.put(assetId, size, bytes);
    return bytes;
  }

  Future<AlbumInfo?> _describeAlbum(AssetPathEntity path) async {
    final results = await Future.wait<Object?>([
      path.assetCountAsync,
      path.getAssetListRange(start: 0, end: 1),
    ]);
    final count = results[0]! as int;
    if (count <= 0) return null;

    final covers = results[1]! as List<AssetEntity>;
    return AlbumInfo(
      id: path.id,
      name: path.name,
      assetCount: count,
      coverAssetId: covers.isEmpty ? null : covers.first.id,
    );
  }

  Future<AssetPathEntity?> _pathFor(String albumId, OrderMode mode) async {
    var path = _pathsById[albumId];
    if (path == null) {
      final paths = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: false,
        filterOption: _imageFilter(null),
      );
      _rememberPaths(paths);
      path = _pathsById[albumId];
    }
    if (path == null) return null;
    return path.copyWith(
      albumType: path.albumType,
      type: RequestType.image,
      filterOption: _imageFilter(mode),
    );
  }

  void _rememberPaths(List<AssetPathEntity> paths) {
    _pathsById
      ..clear()
      ..addEntries(paths.map((path) => MapEntry(path.id, path)));
  }

  Future<List<PhotoItem>> _collectAll(
    AssetPathEntity path,
    int generation,
  ) async {
    final photos = <PhotoItem>[];
    final seen = <String>{};
    var page = 0;
    while (generation == _pagingGeneration) {
      final batch = await _fetchPage(path, page);
      if (generation != _pagingGeneration) return const [];
      if (batch.isEmpty) break;
      for (final photo in batch) {
        if (seen.add(photo.id)) photos.add(photo);
      }
      if (batch.length < photoPageSize) break;
      page++;
    }
    if (generation != _pagingGeneration) return const [];
    return photos;
  }

  Future<List<PhotoItem>> _fetchPage(AssetPathEntity path, int page) async {
    final entities = await path.getAssetListPaged(
      page: page,
      size: photoPageSize,
    );
    return entities.map(_toPhoto).toList(growable: false);
  }

  PhotoItem _toPhoto(AssetEntity entity) {
    return PhotoItem(id: entity.id, createdAt: entity.createDateTime);
  }

  FilterOptionGroup _imageFilter(OrderMode? mode) {
    final group = FilterOptionGroup(
      imageOption: const FilterOption(
        sizeConstraint: SizeConstraint(ignoreSize: true),
      ),
    );
    switch (mode) {
      case OrderMode.newestFirst:
        group.addOrderOption(
          const OrderOption(type: OrderOptionType.createDate, asc: false),
        );
      case OrderMode.oldestFirst:
        group.addOrderOption(
          const OrderOption(type: OrderOptionType.createDate, asc: true),
        );
      case OrderMode.random:
      case null:
        break;
    }
    return group;
  }
}
