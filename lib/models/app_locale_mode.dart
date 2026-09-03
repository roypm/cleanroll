enum AppLocaleMode { system, en, es, ca }

extension AppLocaleModeX on AppLocaleMode {
  String get storageValue => name;

  static AppLocaleMode fromStorage(String? value) {
    switch (value) {
      case 'en':
        return AppLocaleMode.en;
      case 'es':
        return AppLocaleMode.es;
      case 'ca':
        return AppLocaleMode.ca;
      case 'system':
      default:
        return AppLocaleMode.system;
    }
  }
}
