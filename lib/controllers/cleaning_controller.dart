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
    Random? random,
  }) : _photos = List<PhotoItem>.from(photos),
       _random = random ?? Random() {
    _applyOrder();
  }

  final AlbumInfo album;
  final OrderMode orderMode;
  final Random _random;

  final List<PhotoItem> _photos;
  int _currentIndex = 0;
  final LinkedHashSet<String> _keptIds = LinkedHashSet<String>();
  final LinkedHashSet<String> _deleteIds = LinkedHashSet<String>();
  final List<SessionDecision> _undoStack = <SessionDecision>[];

  static const int maxUndoSteps = 5;

  List<PhotoItem> get photos => List.unmodifiable(_photos);
  int get currentIndex => _currentIndex;
  int get totalCount => _photos.length;
  bool get hasPhotos => _photos.isNotEmpty;
  bool get isFinished => _currentIndex >= _photos.length;
  bool get canUndo => _undoStack.isNotEmpty;
  int get undoCount => _undoStack.length;
  bool get canContinueCleaning => !isFinished;
  int get selectedForDeletionCount => _deleteIds.length;
  bool get hasDeletionCandidates => _deleteIds.isNotEmpty;

  /// 1-based progress for UI when a photo is on screen.
  int get displayIndex {
    if (!hasPhotos) return 0;
    if (isFinished) return totalCount;
    return _currentIndex + 1;
  }

  PhotoItem? get currentPhoto {
    if (isFinished || !hasPhotos) return null;
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
