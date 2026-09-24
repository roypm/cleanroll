import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/album_info.dart';
import '../models/order_mode.dart';
import '../models/photo_item.dart';
import '../models/session_decision.dart';

/// In-memory cleaning session. Decisions are marks only — never platform deletes.
class CleaningController extends ChangeNotifier {
  CleaningController({
    required this.album,
    required this.orderMode,
    required List<PhotoItem> photos,
    int? totalCount,
    bool catalogComplete = true,
    Random? random,
  }) : _photos = List<PhotoItem>.from(photos),
       _totalCount = totalCount ?? photos.length,
       _random = random ?? Random() {
    _catalogComplete = catalogComplete;
    if (_catalogComplete) {
      _applyOrder();
      _totalCount = _photos.length;
    } else if (_totalCount < _photos.length) {
      _totalCount = _photos.length;
    }
  }

  final AlbumInfo album;
  final OrderMode orderMode;
  final Random _random;

  final List<PhotoItem> _photos;
  int _currentIndex = 0;
  int _totalCount;
  bool _catalogComplete = true;
  bool _closed = false;
  final LinkedHashSet<String> _keptIds = LinkedHashSet<String>();
  final LinkedHashSet<String> _deleteIds = LinkedHashSet<String>();
  final List<SessionDecision> _undoStack = <SessionDecision>[];

  static const int maxUndoSteps = 5;

  List<PhotoItem> get photos => List.unmodifiable(_photos);
  int get currentIndex => _currentIndex;
  int get loadedCount => _photos.length;
  int get totalCount => _totalCount;
  bool get isCatalogComplete => _catalogComplete;
  bool get isClosed => _closed;
  bool get hasPhotos => _photos.isNotEmpty;

  /// True only after every photo has been loaded and reviewed.
  bool get isFinished => _catalogComplete && _currentIndex >= _photos.length;

  /// The user reached the loaded photos while later pages are still arriving.
  bool get isWaitingForMore =>
      !_catalogComplete && _currentIndex >= _photos.length;

  bool get canUndo => _undoStack.isNotEmpty;
  int get undoCount => _undoStack.length;
  bool get canContinueCleaning => !isFinished;
  int get selectedForDeletionCount => _deleteIds.length;
  bool get hasDeletionCandidates => _deleteIds.isNotEmpty;

  /// 1-based progress for UI when a photo is on screen.
  int get displayIndex {
    if (!hasPhotos) return 0;
    if (isFinished) return totalCount;
    final next = _currentIndex + 1;
    if (next > totalCount) return totalCount;
    return next;
  }

  PhotoItem? get currentPhoto {
    if (_currentIndex < 0 || _currentIndex >= _photos.length) return null;
    return _photos[_currentIndex];
  }

  List<PhotoItem> get photosToDelete {
    return _photos
        .where((p) => _deleteIds.contains(p.id))
        .toList(growable: false);
  }

  bool isSelectedForDeletion(String id) => _deleteIds.contains(id);

  void keep() {
    final photo = currentPhoto;
    if (photo == null) return;

    _keptIds.add(photo.id);
    _deleteIds.remove(photo.id);
    _pushUndo(
      SessionDecision(
        photo: photo,
        kind: DecisionKind.keep,
        index: _currentIndex,
      ),
    );
    _currentIndex += 1;
    notifyListeners();
  }

  void markForDeletion() {
    final photo = currentPhoto;
    if (photo == null) return;

    _deleteIds.add(photo.id);
    _keptIds.remove(photo.id);
    _pushUndo(
      SessionDecision(
        photo: photo,
        kind: DecisionKind.delete,
        index: _currentIndex,
      ),
    );
    _currentIndex += 1;
    notifyListeners();
  }

  void undo() {
    if (_undoStack.isEmpty) return;

    final last = _undoStack.removeLast();
    _currentIndex = last.index;
    switch (last.kind) {
      case DecisionKind.keep:
        _keptIds.remove(last.photo.id);
      case DecisionKind.delete:
        _deleteIds.remove(last.photo.id);
    }
    notifyListeners();
  }

  void _pushUndo(SessionDecision decision) {
    _undoStack.add(decision);
    if (_undoStack.length > maxUndoSteps) {
      _undoStack.removeAt(0);
    }
  }

  void deselect(String photoId) {
    if (!_deleteIds.remove(photoId)) return;
    notifyListeners();
  }

  /// Adds later pages at the end. Does not move [currentIndex].
  void appendPhotos(List<PhotoItem> more) {
    if (_closed || _catalogComplete || more.isEmpty) return;

    final existing = _photos.map((photo) => photo.id).toSet();
    var added = false;
    for (final photo in more) {
      if (existing.add(photo.id)) {
        _photos.add(photo);
        added = true;
      }
    }
    if (!added) return;
    notifyListeners();
  }

  /// Marks the album list as fully loaded.
  ///
  /// The progress total becomes the number of photos that actually arrived,
  /// so a short load does not leave the session waiting.
  void completeCatalog() {
    if (_closed || _catalogComplete) return;
    _catalogComplete = true;
    _totalCount = _photos.length;
    notifyListeners();
  }

  @override
  void dispose() {
    _closed = true;
    super.dispose();
  }

  void _applyOrder() {
    switch (orderMode) {
      case OrderMode.newestFirst:
        _photos.sort((a, b) {
          final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bDate.compareTo(aDate);
        });
      case OrderMode.oldestFirst:
        _photos.sort((a, b) {
          final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return aDate.compareTo(bDate);
        });
      case OrderMode.random:
        _photos.shuffle(_random);
    }
  }
}
