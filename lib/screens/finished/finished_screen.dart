import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../controllers/settings_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../services/photo_service.dart';
import '../home/home_screen.dart';

class FinishedScreen extends StatelessWidget {
  const FinishedScreen({
    super.key,
    required this.deletedCount,
    required this.failedCount,
    required this.photoService,
    required this.settings,
  });

  final int deletedCount;
  final int failedCount;
  final PhotoService photoService;
  final SettingsController settings;

  void _goHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) =>
            HomeScreen(photoService: photoService, settings: settings),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final hasFailures = failedCount > 0;
    final hasSuccess = deletedCount > 0;

    final title = !hasSuccess && hasFailures
        ? l10n.nothingWasDeleted
        : hasFailures
        ? l10n.partlyDone
        : l10n.allDone;

    final body = !hasSuccess && hasFailures
        ? l10n.photosCouldNotBeRemoved(failedCount)
        : hasFailures
        ? l10n.partialDeletionSummary(deletedCount, failedCount)
        : l10n.photosRemoved(deletedCount);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(
                hasFailures ? Icons.info_outline : Icons.check_circle_outline,
                size: 72,
                color: hasFailures
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                body,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => _goHome(context),
                child: Text(l10n.done),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
