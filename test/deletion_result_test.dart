import 'package:cleanroll/models/deletion_result.dart';
import 'package:cleanroll/models/photo_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final requested = [
    const PhotoItem(id: 'a'),
    const PhotoItem(id: 'b'),
    const PhotoItem(id: 'c'),
  ];

  test('empty id list is a cancellation and not a failure', () {
    final result = interpretDeletion(requested: requested, deletedIds: []);

    expect(result.cancelled, isTrue);
    expect(result.successCount, 0);
    expect(result.failureCount, 0);
    expect(result.allFailed, isFalse);
  });

  test('a thrown error fails every photo and is not a cancellation', () {
    final result = interpretDeletion(
      requested: requested,
      error: StateError('delete failed'),
    );

    expect(result.cancelled, isFalse);
    expect(result.successCount, 0);
    expect(result.failureCount, 3);
    expect(result.allFailed, isTrue);
    expect(result.failedPhotos.map((photo) => photo.id), ['a', 'b', 'c']);
  });

  test('partial deletion keeps the ids the platform removed', () {
    final result = interpretDeletion(
      requested: requested,
      deletedIds: ['a', 'c'],
    );

    expect(result.cancelled, isFalse);
    expect(result.isPartial, isTrue);
    expect(result.successfulPhotos.map((photo) => photo.id), ['a', 'c']);
    expect(result.failedPhotos.map((photo) => photo.id), ['b']);
  });

  test('all returned ids are a full success', () {
    final result = interpretDeletion(
      requested: requested,
      deletedIds: ['a', 'b', 'c'],
    );

    expect(result.cancelled, isFalse);
    expect(result.allSucceeded, isTrue);
    expect(result.failureCount, 0);
    expect(result.successCount, 3);
  });
}
