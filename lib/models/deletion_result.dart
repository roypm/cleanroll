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
