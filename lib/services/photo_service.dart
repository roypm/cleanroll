import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';

import '../models/album_info.dart';
import '../models/deletion_result.dart';
import '../models/photo_item.dart';
import '../models/photo_permission.dart';

class PhotoService {
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
      filterOption: FilterOptionGroup(
        imageOption: const FilterOption(
          sizeConstraint: SizeConstraint(ignoreSize: true),
        ),
      ),
    );

    final albums = <AlbumInfo>[];
    for (final path in paths) {
      final count = await path.assetCountAsync;
      if (count <= 0) continue;

      String? coverAssetId;
      final coverAssets = await path.getAssetListRange(start: 0, end: 1);
      if (coverAssets.isNotEmpty) {
        coverAssetId = coverAssets.first.id;
      }

      albums.add(
        AlbumInfo(
          id: path.id,
          name: path.name,
          assetCount: count,
          coverAssetId: coverAssetId,
        ),
      );
    }
    return albums;
  }

  Future<List<PhotoItem>> getPhotosForAlbum(String albumId) async {
    final paths = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: false,
      filterOption: FilterOptionGroup(
        imageOption: const FilterOption(
          sizeConstraint: SizeConstraint(ignoreSize: true),
        ),
      ),
    );

    AssetPathEntity? path;
    for (final candidate in paths) {
      if (candidate.id == albumId) {
        path = candidate;
        break;
      }
    }
    if (path == null) return const [];

    final count = await path.assetCountAsync;
    if (count == 0) return const [];

    final entities = await path.getAssetListRange(start: 0, end: count);
    return entities
        .map(
          (entity) =>
              PhotoItem(id: entity.id, createdAt: entity.createDateTime),
        )
        .toList(growable: false);
  }

  Future<Uint8List?> thumbnailBytes(String assetId, {int size = 400}) async {
    final entity = await AssetEntity.fromId(assetId);
    if (entity == null) return null;
    return entity.thumbnailDataWithSize(ThumbnailSize.square(size));
  }

  Future<Uint8List?> previewBytes(String assetId) async {
    final entity = await AssetEntity.fromId(assetId);
    if (entity == null) return null;
    return entity.thumbnailDataWithSize(const ThumbnailSize(1200, 1200));
  }

  /// Permanently deletes via the platform photo API.
  /// Call only from Review after the user taps Delete.
  /// The platform may show its own confirmation UI.
  Future<DeletionResult> deletePhotos(List<PhotoItem> photos) async {
    if (photos.isEmpty) {
      return const DeletionResult(successfulPhotos: [], failedPhotos: []);
    }

    final ids = photos.map((p) => p.id).toList(growable: false);
    final deletedIds = await PhotoManager.editor.deleteWithIds(ids);
    final deletedSet = deletedIds.toSet();

    final successful = photos.where((p) => deletedSet.contains(p.id)).toList();
    final failed = photos.where((p) => !deletedSet.contains(p.id)).toList();

    return DeletionResult(
      successfulPhotos: successful,
      failedPhotos: failed,
      cancelled: successful.isEmpty && failed.length == photos.length,
    );
  }
}
