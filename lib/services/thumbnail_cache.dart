import 'dart:typed_data';

/// Small in-memory LRU of thumbnail bytes, keyed by asset id and pixel size.
class ThumbnailCache {
  ThumbnailCache({this.capacity = 30});

  final int capacity;
  final Map<String, Uint8List> _entries = <String, Uint8List>{};

  int get length => _entries.length;

  static String _key(String assetId, int size) => '$size:$assetId';

  Uint8List? get(String assetId, int size) {
    final key = _key(assetId, size);
    final value = _entries.remove(key);
    if (value == null) return null;
    _entries[key] = value;
    return value;
  }

  void put(String assetId, int size, Uint8List bytes) {
    final key = _key(assetId, size);
    _entries.remove(key);
    _entries[key] = bytes;
    while (_entries.length > capacity) {
      _entries.remove(_entries.keys.first);
    }
  }
}
