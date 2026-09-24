import 'photo_item.dart';

class DeletionResult {
  const DeletionResult({
    required this.successfulPhotos,
    required this.failedPhotos,
    this.cancelled = false,
  });

  final List<PhotoItem> successfulPhotos;
  final List<PhotoItem> failedPhotos;
  final bool cancelled;

  int get successCount => successfulPhotos.length;
  int get failureCount => failedPhotos.length;
  bool get allSucceeded =>
      !cancelled && failedPhotos.isEmpty && successfulPhotos.isNotEmpty;
  bool get allFailed =>
      !cancelled && successfulPhotos.isEmpty && failedPhotos.isNotEmpty;
  bool get isPartial => successCount > 0 && failureCount > 0;
}

/// Maps a platform delete call onto the four outcomes the UI can show.
///
/// An empty id list, with no thrown error, means the system dialog was
/// dismissed or nothing was removed. That is a cancellation, not a failure.
/// A thrown error means the delete did not run.
DeletionResult interpretDeletion({
  required List<PhotoItem> requested,
  List<String>? deletedIds,
  Object? error,
}) {
  if (requested.isEmpty) {
    return const DeletionResult(successfulPhotos: [], failedPhotos: []);
  }
  if (error != null) {
    return DeletionResult(
      successfulPhotos: const [],
      failedPhotos: List<PhotoItem>.unmodifiable(requested),
    );
  }

  final deleted = (deletedIds ?? const <String>[]).toSet();
  if (deleted.isEmpty) {
    return const DeletionResult(
      successfulPhotos: [],
      failedPhotos: [],
      cancelled: true,
    );
  }

  final successful = <PhotoItem>[];
  final failed = <PhotoItem>[];
  for (final photo in requested) {
    if (deleted.contains(photo.id)) {
      successful.add(photo);
    } else {
      failed.add(photo);
    }
  }
  return DeletionResult(
    successfulPhotos: List<PhotoItem>.unmodifiable(successful),
    failedPhotos: List<PhotoItem>.unmodifiable(failed),
  );
}
