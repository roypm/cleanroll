// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'CleanRoll';

  @override
  String get appTagline => 'Clean your gallery one photo at a time.';

  @override
  String get allowAccess => 'Allow access';

  @override
  String get openSettings => 'Open settings';

  @override
  String get permissionNeeded =>
      'CleanRoll needs access to your photos so you can choose which ones to keep or remove.';

  @override
  String get permissionPermanentlyDenied =>
      'Photo access is turned off. Enable it in system settings to clean your gallery.';

  @override
  String get couldNotLoadAlbums => 'Couldn’t load albums';

  @override
  String get checkPhotoPermissions =>
      'Please check your photo permissions and try again.';

  @override
  String get tryAgain => 'Try again';

  @override
  String get noPhotosToReview => 'No photos to review';

  @override
  String get noAccessiblePhotos =>
      'There are no accessible photos available to clean.';

  @override
  String photoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos',
      one: '1 photo',
    );
    return '$_temp0';
  }

  @override
  String get albumEmpty => 'This album has no photos available to review.';

  @override
  String get albumLoadFailed =>
      'We couldn’t load photos from this album. Please try again.';

  @override
  String get chooseOrder => 'Choose an order';

  @override
  String get orderNewestTitle => 'Newest first';

  @override
  String get orderNewestSubtitle => 'Start with your most recent photos';

  @override
  String get orderOldestTitle => 'Oldest first';

  @override
  String get orderOldestSubtitle => 'Start with your oldest photos';

  @override
  String get orderRandomTitle => 'Random';

  @override
  String get orderRandomSubtitle => 'Shuffle the album once and review';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get languageCatalan => 'Catalan';

  @override
  String get languageSystem => 'System';

  @override
  String get openMenu => 'Open menu';

  @override
  String get closeMenu => 'Close menu';

  @override
  String get delete => 'Delete';

  @override
  String get keep => 'Keep';

  @override
  String get review => 'Review';

  @override
  String get undo => 'Undo';

  @override
  String markedCount(int count) {
    return '$count marked';
  }

  @override
  String get swipeKeep => 'KEEP';

  @override
  String get swipeDelete => 'DELETE';

  @override
  String get nothingSelected => 'Nothing selected';

  @override
  String get nothingToDelete => 'Nothing to delete';

  @override
  String photosSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos selected',
      one: '1 photo selected',
    );
    return '$_temp0';
  }

  @override
  String get reviewHintContinue =>
      'Mark photos for deletion while cleaning, then review them here.';

  @override
  String get reviewKeptAll => 'You kept all the photos in this session.';

  @override
  String deletePhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Delete $count photos',
      one: 'Delete 1 photo',
    );
    return '$_temp0';
  }

  @override
  String get startNewSession => 'Start new session';

  @override
  String get continueCleaning => 'Continue';

  @override
  String get noPhotosDeleted => 'No photos were deleted.';

  @override
  String get deleteFailedKeepSelection =>
      'Some photos couldn’t be deleted. They have not been removed from your selection.';

  @override
  String get closePreview => 'Close preview';

  @override
  String get allDone => 'All done!';

  @override
  String get partlyDone => 'Partly done';

  @override
  String get nothingWasDeleted => 'Nothing was deleted';

  @override
  String photosRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos removed.',
      one: '1 photo removed.',
    );
    return '$_temp0';
  }

  @override
  String photosCouldNotBeRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos could not be removed.',
      one: '1 photo could not be removed.',
    );
    return '$_temp0';
  }

  @override
  String partialDeletionSummary(int deleted, int failed) {
    return '$deleted deleted. $failed could not be removed.';
  }

  @override
  String get done => 'Done';
}
