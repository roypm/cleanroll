import 'package:cleanroll/controllers/settings_controller.dart';
import 'package:cleanroll/models/app_locale_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('defaults to system theme and locale', () async {
    SharedPreferences.setMockInitialValues({});
    final settings = SettingsController();
    await settings.load();

    expect(settings.themeMode, ThemeMode.system);
    expect(settings.localeMode, AppLocaleMode.system);
    expect(settings.locale, isNull);
  });

  test('persists theme and locale mode', () async {
    SharedPreferences.setMockInitialValues({});
    final settings = SettingsController();
    await settings.load();

    await settings.setThemeMode(ThemeMode.dark);
    await settings.setLocaleMode(AppLocaleMode.es);

    final reloaded = SettingsController();
    await reloaded.load();
    expect(reloaded.themeMode, ThemeMode.dark);
    expect(reloaded.localeMode, AppLocaleMode.es);
    expect(reloaded.locale, const Locale('es'));
  });
}
