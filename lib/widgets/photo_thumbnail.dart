import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../services/photo_service.dart';

class PhotoThumbnail extends StatefulWidget {
  const PhotoThumbnail({
    super.key,
    required this.photoId,
    required this.photoService,
    this.size = 400,
    this.fit = BoxFit.cover,
  });

  final String photoId;
  final PhotoService photoService;
  final int size;
  final BoxFit fit;

  @override
  State<PhotoThumbnail> createState() => _PhotoThumbnailState();
}

class _PhotoThumbnailState extends State<PhotoThumbnail> {
  late Future<Uint8List?> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.photoService.thumbnailBytes(
      widget.photoId,
      size: widget.size,
    );
  }

  @override
  void didUpdateWidget(covariant PhotoThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.photoId != widget.photoId || oldWidget.size != widget.size) {
      _future = widget.photoService.thumbnailBytes(
        widget.photoId,
        size: widget.size,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return ColoredBox(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        final bytes = snapshot.data;
        if (bytes == null) {
          return ColoredBox(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.broken_image_outlined,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          );
        }
        return Image.memory(bytes, fit: widget.fit, gaplessPlayback: true);
      },
    );
  }
}
