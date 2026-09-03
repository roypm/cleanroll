import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../controllers/settings_controller.dart';
import '../l10n/app_localizations.dart';
import '../screens/home/home_screen.dart';
import 'theme.dart';

class CleanRollApp extends StatelessWidget {
  const CleanRollApp({super.key, required this.settings});

  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) {
        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          debugShowCheckedModeBanner: false,
          theme: buildLightTheme(),
          darkTheme: buildDarkTheme(),
          themeMode: settings.themeMode,
          locale: settings.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: HomeScreen(settings: settings),
        );
      },
    );
  }
}
