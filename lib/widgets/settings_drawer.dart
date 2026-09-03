import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../controllers/settings_controller.dart';
import '../l10n/app_localizations.dart';
import '../models/app_locale_mode.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key, required this.settings});

  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Drawer(
      child: SafeArea(
        child: ListenableBuilder(
          listenable: settings,
          builder: (context, _) {
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Text(
                    l10n.settings,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Text(
                    l10n.appearance,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                RadioGroup<ThemeMode>(
                  groupValue: settings.themeMode,
                  onChanged: (mode) {
                    if (mode == null) return;
                    settings.setThemeMode(mode);
                    Navigator.of(context).maybePop();
                  },
                  child: Column(
                    children: [
                      RadioListTile<ThemeMode>(
                        title: Text(l10n.themeLight),
                        value: ThemeMode.light,
                      ),
                      RadioListTile<ThemeMode>(
                        title: Text(l10n.themeDark),
                        value: ThemeMode.dark,
                      ),
                      RadioListTile<ThemeMode>(
                        title: Text(l10n.themeSystem),
                        value: ThemeMode.system,
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Text(
                    l10n.language,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                RadioGroup<AppLocaleMode>(
                  groupValue: settings.localeMode,
                  onChanged: (mode) {
                    if (mode == null) return;
                    settings.setLocaleMode(mode);
                    Navigator.of(context).maybePop();
                  },
                  child: Column(
                    children: [
                      RadioListTile<AppLocaleMode>(
                        title: Text(l10n.languageEnglish),
                        value: AppLocaleMode.en,
                      ),
                      RadioListTile<AppLocaleMode>(
                        title: Text(l10n.languageSpanish),
                        value: AppLocaleMode.es,
                      ),
                      RadioListTile<AppLocaleMode>(
                        title: Text(l10n.languageCatalan),
                        value: AppLocaleMode.ca,
                      ),
                      RadioListTile<AppLocaleMode>(
                        title: Text(l10n.languageSystem),
                        value: AppLocaleMode.system,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
