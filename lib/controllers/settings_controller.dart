import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_locale_mode.dart';

class SettingsController extends ChangeNotifier {
  SettingsController({SharedPreferences? prefs}) : _prefsOverride = prefs;

  static const _themeKey = 'theme_mode';
  static const _localeKey = 'locale_mode';

  final SharedPreferences? _prefsOverride;
  SharedPreferences? _prefs;

  ThemeMode _themeMode = ThemeMode.system;
  AppLocaleMode _localeMode = AppLocaleMode.system;
  bool _loaded = false;

  ThemeMode get themeMode => _themeMode;
  AppLocaleMode get localeMode => _localeMode;
  bool get isLoaded => _loaded;

  /// Null means follow the device locale.
  Locale? get locale {
    switch (_localeMode) {
      case AppLocaleMode.system:
        return null;
      case AppLocaleMode.en:
        return const Locale('en');
      case AppLocaleMode.es:
        return const Locale('es');
      case AppLocaleMode.ca:
        return const Locale('ca');
    }
  }

  Future<void> load() async {
    _prefs = _prefsOverride ?? await SharedPreferences.getInstance();
    _themeMode = _themeModeFromStorage(_prefs!.getString(_themeKey));
    _localeMode = AppLocaleModeX.fromStorage(_prefs!.getString(_localeKey));
    _loaded = true;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    await _prefs?.setString(_themeKey, _themeModeToStorage(mode));
  }

  Future<void> setLocaleMode(AppLocaleMode mode) async {
    if (_localeMode == mode) return;
    _localeMode = mode;
    notifyListeners();
    await _prefs?.setString(_localeKey, mode.storageValue);
  }

  static ThemeMode _themeModeFromStorage(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  static String _themeModeToStorage(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
