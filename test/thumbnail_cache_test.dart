import 'dart:typed_data';

import 'package:cleanroll/services/thumbnail_cache.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('putting the same thumbnail again does not grow the cache', () {
    final cache = ThumbnailCache(capacity: 2);
    cache.put('a', 100, Uint8List.fromList([1]));
    cache.put('a', 100, Uint8List.fromList([2]));

    expect(cache.length, 1);
    expect(cache.get('a', 100), Uint8List.fromList([2]));
  });

  test('the oldest thumbnail is dropped once the cache is full', () {
    final cache = ThumbnailCache(capacity: 2);
    cache.put('a', 100, Uint8List.fromList([1]));
    cache.put('b', 100, Uint8List.fromList([2]));
    cache.put('c', 100, Uint8List.fromList([3]));

    expect(cache.get('a', 100), isNull);
    expect(cache.get('b', 100), isNotNull);
    expect(cache.get('c', 100), isNotNull);
  });

  test('reading a thumbnail keeps it newer than unread ones', () {
    final cache = ThumbnailCache(capacity: 2);
    cache.put('a', 100, Uint8List.fromList([1]));
    cache.put('b', 100, Uint8List.fromList([2]));
    cache.get('a', 100);
    cache.put('c', 100, Uint8List.fromList([3]));

    expect(cache.get('b', 100), isNull);
    expect(cache.get('a', 100), isNotNull);
    expect(cache.get('c', 100), isNotNull);
  });
}
