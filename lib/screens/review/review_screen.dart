import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../controllers/cleaning_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../models/photo_item.dart';
import '../../services/photo_service.dart';
import '../../widgets/photo_thumbnail.dart';
import '../finished/finished_screen.dart';
import '../home/home_screen.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({
    super.key,
    required this.controller,
    required this.photoService,
    required this.settings,
  });

  final CleaningController controller;
  final PhotoService photoService;
  final SettingsController settings;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  CleaningController get _controller => widget.controller;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_rebuild);
  }

  @override
  void dispose() {
    _controller.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  Future<void> _deleteSelected() async {
    final count = _controller.selectedForDeletionCount;
    if (count == 0 || _deleting) return;

    setState(() => _deleting = true);
    final selected = List<PhotoItem>.from(_controller.photosToDelete);
    final l10n = AppLocalizations.of(context);

    try {
      final result = await widget.photoService.deletePhotos(selected);
      if (!mounted) return;

      if (result.successCount == 0) {
        setState(() => _deleting = false);
        if (result.cancelled || result.failureCount > 0) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l10n.noPhotosDeleted)));
        }
        return;
      }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) => FinishedScreen(
            deletedCount: result.successCount,
            failedCount: result.failureCount,
            photoService: widget.photoService,
            settings: widget.settings,
          ),
        ),
        (route) => false,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _deleting = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.deleteFailedKeepSelection)));
    }
  }

  Future<void> _preview(PhotoItem photo) async {
    final l10n = AppLocalizations.of(context);
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: l10n.closePreview,
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (context, animation, secondaryAnimation) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).pop(),
          child: SafeArea(
            child: Center(
              child: PhotoThumbnail(
                photoId: photo.id,
                photoService: widget.photoService,
                size: 1200,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = _controller.photosToDelete;
    final count = selected.length;
    final canContinue = _controller.canContinueCleaning;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.review),
        automaticallyImplyLeading: canContinue,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: Text(
                count == 0
                    ? (canContinue
                          ? l10n.nothingSelected
                          : l10n.nothingToDelete)
                    : l10n.photosSelected(count),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Expanded(
              child: count == 0
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Text(
                          canContinue
                              ? l10n.reviewHintContinue
                              : l10n.reviewKeptAll,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 6,
                            crossAxisSpacing: 6,
                          ),
                      itemCount: selected.length,
                      itemBuilder: (context, index) {
                        final photo = selected[index];
                        return _ReviewTile(
                          photo: photo,
                          photoService: widget.photoService,
                          onOpen: () => _preview(photo),
                          onDeselect: () => _controller.deselect(photo.id),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  if (count > 0)
                    FilledButton(
                      onPressed: _deleting ? null : _deleteSelected,
                      child: _deleting
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.deletePhotos(count)),
                    )
                  else if (!canContinue)
                    FilledButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute<void>(
                            builder: (_) => HomeScreen(
                              photoService: widget.photoService,
                              settings: widget.settings,
                            ),
                          ),
                          (route) => false,
                        );
                      },
                      child: Text(l10n.startNewSession),
                    ),
                  if (canContinue) ...[
                    const SizedBox(height: AppSpacing.sm),
                    OutlinedButton(
                      onPressed: _deleting
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: Text(l10n.continueCleaning),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({
    required this.photo,
    required this.photoService,
    required this.onOpen,
    required this.onDeselect,
  });

  final PhotoItem photo;
  final PhotoService photoService;
  final VoidCallback onOpen;
  final VoidCallback onDeselect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Stack(
          fit: StackFit.expand,
          children: [
            PhotoThumbnail(
              photoId: photo.id,
              photoService: photoService,
              size: 300,
            ),
            Positioned(
              right: 4,
              top: 4,
              child: Material(
                color: scheme.error,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onDeselect,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(Icons.close, size: 14, color: scheme.onError),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
