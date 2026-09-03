import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../controllers/cleaning_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../services/photo_service.dart';
import '../../widgets/photo_thumbnail.dart';
import '../../widgets/swipeable_photo.dart';
import '../review/review_screen.dart';

class CleaningScreen extends StatefulWidget {
  const CleaningScreen({
    super.key,
    required this.controller,
    required this.photoService,
    required this.settings,
  });

  final CleaningController controller;
  final PhotoService photoService;
  final SettingsController settings;

  @override
  State<CleaningScreen> createState() => _CleaningScreenState();
}

class _CleaningScreenState extends State<CleaningScreen> {
  CleaningController get _controller => widget.controller;
  bool _handedOff = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSessionChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSessionChanged);
    if (!_handedOff) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onSessionChanged() {
    if (!mounted) return;
    if (_controller.isFinished) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_controller.isFinished) return;
        _openReview(replace: true);
      });
      return;
    }
    setState(() {});
  }

  Future<void> _openReview({bool replace = false}) async {
    final route = MaterialPageRoute<void>(
      builder: (_) => ReviewScreen(
        controller: _controller,
        photoService: widget.photoService,
        settings: widget.settings,
      ),
    );

    if (replace) {
      _handedOff = true;
      await Navigator.of(context).pushReplacement(route);
    } else {
      await Navigator.of(context).push(route);
      if (mounted) setState(() {});
    }
  }

  void _keep() => _controller.keep();
  void _delete() => _controller.markForDeletion();

  @override
  Widget build(BuildContext context) {
    final photo = _controller.currentPhoto;
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${_controller.displayIndex} / ${_controller.totalCount}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          if (_controller.selectedForDeletionCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: Center(
                child: Text(
                  l10n.markedCount(_controller.selectedForDeletionCount),
                  style: Theme.of(context).textTheme.labelLarge
                      ?.copyWith(color: scheme.error),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Column(
            children: [
              Expanded(
                child: photo == null
                    ? const Center(child: CircularProgressIndicator())
                    : SwipeablePhoto(
                        key: ValueKey(photo.id),
                        onKeep: _keep,
                        onDelete: _delete,
                        keepLabel: l10n.swipeKeep,
                        deleteLabel: l10n.swipeDelete,
                        child: ColoredBox(
                          color: scheme.surfaceContainerHighest,
                          child: PhotoThumbnail(
                            photoId: photo.id,
                            photoService: widget.photoService,
                            size: 900,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: photo == null ? null : _delete,
                      icon: const Icon(Icons.close),
                      label: Text(l10n.delete),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: scheme.error,
                        side: BorderSide(color: scheme.error),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => _openReview(),
                      child: Text(l10n.review),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: photo == null ? null : _keep,
                      icon: const Icon(Icons.check),
                      label: Text(l10n.keep),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton.icon(
                onPressed: _controller.canUndo ? _controller.undo : null,
                icon: const Icon(Icons.undo),
                label: Text(l10n.undo),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
