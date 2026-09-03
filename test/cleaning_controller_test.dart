import 'dart:math';

import 'package:cleanroll/controllers/cleaning_controller.dart';
import 'package:cleanroll/models/album_info.dart';
import 'package:cleanroll/models/order_mode.dart';
import 'package:cleanroll/models/photo_item.dart';
import 'package:flutter_test/flutter_test.dart';

AlbumInfo get _album =>
    const AlbumInfo(id: 'album', name: 'Camera', assetCount: 3);

List<PhotoItem> _photos() => [
  PhotoItem(id: 'a', createdAt: DateTime(2024, 1, 1)),
  PhotoItem(id: 'b', createdAt: DateTime(2024, 2, 1)),
  PhotoItem(id: 'c', createdAt: DateTime(2024, 3, 1)),
];

void main() {
  test('keep advances and does not add to deletion set', () {
    final controller = CleaningController(
      album: _album,
      orderMode: OrderMode.oldestFirst,
      photos: _photos(),
    );

    final first = controller.currentPhoto!;
    controller.keep();

    expect(controller.currentIndex, 1);
    expect(controller.isSelectedForDeletion(first.id), isFalse);
    expect(controller.selectedForDeletionCount, 0);
  });

  test(
    'mark for deletion adds to set and advances without finishing deletion',
    () {
      final controller = CleaningController(
        album: _album,
        orderMode: OrderMode.oldestFirst,
        photos: _photos(),
      );

      final first = controller.currentPhoto!;
      controller.markForDeletion();

      expect(controller.currentIndex, 1);
      expect(controller.isSelectedForDeletion(first.id), isTrue);
      expect(controller.photosToDelete.map((p) => p.id), ['a']);
    },
  );

  test('undo restores previous decision', () {
    final controller = CleaningController(
      album: _album,
      orderMode: OrderMode.oldestFirst,
      photos: _photos(),
    );

    controller.markForDeletion();
    expect(controller.selectedForDeletionCount, 1);

    controller.undo();
    expect(controller.currentIndex, 0);
    expect(controller.selectedForDeletionCount, 0);
    expect(controller.canUndo, isFalse);
  });

  test('undo can reverse multiple decisions up to five', () {
    final photos = List.generate(
      8,
      (i) => PhotoItem(id: 'p$i', createdAt: DateTime(2024, 1, i + 1)),
    );
    final controller = CleaningController(
      album: const AlbumInfo(id: 'album', name: 'Camera', assetCount: 8),
      orderMode: OrderMode.oldestFirst,
      photos: photos,
    );

    controller.keep();
    controller.markForDeletion();
    controller.keep();
    controller.markForDeletion();
    controller.keep();
    expect(controller.undoCount, 5);
    expect(controller.currentIndex, 5);

    controller.undo();
    expect(controller.currentIndex, 4);
    expect(controller.isSelectedForDeletion('p3'), isTrue);

    controller.undo(); // undo mark-delete of p3
    expect(controller.currentIndex, 3);
    expect(controller.isSelectedForDeletion('p3'), isFalse);

    controller.undo();
    controller.undo();
    controller.undo();
    expect(controller.currentIndex, 0);
    expect(controller.canUndo, isFalse);
    expect(controller.selectedForDeletionCount, 0);
  });

  test('undo stack keeps only the last five decisions', () {
    final photos = List.generate(
      8,
      (i) => PhotoItem(id: 'p$i', createdAt: DateTime(2024, 1, i + 1)),
    );
    final controller = CleaningController(
      album: const AlbumInfo(id: 'album', name: 'Camera', assetCount: 8),
      orderMode: OrderMode.oldestFirst,
      photos: photos,
    );

    for (var i = 0; i < 6; i++) {
      controller.keep();
    }
    expect(controller.undoCount, CleaningController.maxUndoSteps);
    expect(controller.currentIndex, 6);

    // Oldest of the six keeps is no longer undoable.
    for (var i = 0; i < 5; i++) {
      controller.undo();
    }
    expect(controller.currentIndex, 1);
    expect(controller.canUndo, isFalse);
  });

  test('deselect removes photo from deletion set', () {
    final controller = CleaningController(
      album: _album,
      orderMode: OrderMode.oldestFirst,
      photos: _photos(),
    );

    controller.markForDeletion();
    controller.deselect('a');
    expect(controller.selectedForDeletionCount, 0);
    expect(controller.hasDeletionCandidates, isFalse);
  });

  test('mid-session state preserves index after decisions', () {
    final controller = CleaningController(
      album: _album,
      orderMode: OrderMode.oldestFirst,
      photos: _photos(),
    );

    controller.keep();
    controller.markForDeletion();
    expect(controller.currentIndex, 2);
    expect(controller.canContinueCleaning, isTrue);
    expect(controller.selectedForDeletionCount, 1);
  });

  test('newest first orders by createdAt descending', () {
    final controller = CleaningController(
      album: _album,
      orderMode: OrderMode.newestFirst,
      photos: _photos(),
    );

    expect(controller.photos.map((p) => p.id).toList(), ['c', 'b', 'a']);
  });

  test('random shuffles once with seeded random', () {
    final controller = CleaningController(
      album: _album,
      orderMode: OrderMode.random,
      photos: _photos(),
      random: Random(42),
    );

    final ids = controller.photos.map((p) => p.id).toList();
    expect(ids.toSet(), {'a', 'b', 'c'});
    expect(ids, isNot(equals(['a', 'b', 'c'])));
  });

  test('session finishes after last photo', () {
    final controller = CleaningController(
      album: _album,
      orderMode: OrderMode.oldestFirst,
      photos: _photos(),
    );

    controller.keep();
    controller.keep();
    controller.keep();
    expect(controller.isFinished, isTrue);
    expect(controller.canContinueCleaning, isFalse);
    expect(controller.currentPhoto, isNull);
  });
}
