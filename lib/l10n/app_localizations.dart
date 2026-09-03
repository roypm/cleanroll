import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ca.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ca'),
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'CleanRoll'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Clean your gallery one photo at a time.'**
  String get appTagline;

  /// No description provided for @allowAccess.
  ///
  /// In en, this message translates to:
  /// **'Allow access'**
  String get allowAccess;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @permissionNeeded.
  ///
  /// In en, this message translates to:
  /// **'CleanRoll needs access to your photos so you can choose which ones to keep or remove.'**
  String get permissionNeeded;

  /// No description provided for @permissionPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Photo access is turned off. Enable it in system settings to clean your gallery.'**
  String get permissionPermanentlyDenied;

  /// No description provided for @couldNotLoadAlbums.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t load albums'**
  String get couldNotLoadAlbums;

  /// No description provided for @checkPhotoPermissions.
  ///
  /// In en, this message translates to:
  /// **'Please check your photo permissions and try again.'**
  String get checkPhotoPermissions;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @noPhotosToReview.
  ///
  /// In en, this message translates to:
  /// **'No photos to review'**
  String get noPhotosToReview;

  /// No description provided for @noAccessiblePhotos.
  ///
  /// In en, this message translates to:
  /// **'There are no accessible photos available to clean.'**
  String get noAccessiblePhotos;

  /// No description provided for @photoCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 photo} other{{count} photos}}'**
  String photoCount(int count);

  /// No description provided for @albumEmpty.
  ///
  /// In en, this message translates to:
  /// **'This album has no photos available to review.'**
  String get albumEmpty;

  /// No description provided for @albumLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t load photos from this album. Please try again.'**
  String get albumLoadFailed;

  /// No description provided for @chooseOrder.
  ///
  /// In en, this message translates to:
  /// **'Choose an order'**
  String get chooseOrder;

  /// No description provided for @orderNewestTitle.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get orderNewestTitle;

  /// No description provided for @orderNewestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start with your most recent photos'**
  String get orderNewestSubtitle;

  /// No description provided for @orderOldestTitle.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get orderOldestTitle;

  /// No description provided for @orderOldestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start with your oldest photos'**
  String get orderOldestSubtitle;

  /// No description provided for @orderRandomTitle.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get orderRandomTitle;

  /// No description provided for @orderRandomSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shuffle the album once and review'**
  String get orderRandomSubtitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get languageSpanish;

  /// No description provided for @languageCatalan.
  ///
  /// In en, this message translates to:
  /// **'Catalan'**
  String get languageCatalan;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @openMenu.
  ///
  /// In en, this message translates to:
  /// **'Open menu'**
  String get openMenu;

  /// No description provided for @closeMenu.
  ///
  /// In en, this message translates to:
  /// **'Close menu'**
  String get closeMenu;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @keep.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get keep;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @markedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} marked'**
  String markedCount(int count);

  /// No description provided for @swipeKeep.
  ///
  /// In en, this message translates to:
  /// **'KEEP'**
  String get swipeKeep;

  /// No description provided for @swipeDelete.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get swipeDelete;

  /// No description provided for @nothingSelected.
  ///
  /// In en, this message translates to:
  /// **'Nothing selected'**
  String get nothingSelected;

  /// No description provided for @nothingToDelete.
  ///
  /// In en, this message translates to:
  /// **'Nothing to delete'**
  String get nothingToDelete;

  /// No description provided for @photosSelected.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 photo selected} other{{count} photos selected}}'**
  String photosSelected(int count);

  /// No description provided for @reviewHintContinue.
  ///
  /// In en, this message translates to:
  /// **'Mark photos for deletion while cleaning, then review them here.'**
  String get reviewHintContinue;

  /// No description provided for @reviewKeptAll.
  ///
  /// In en, this message translates to:
  /// **'You kept all the photos in this session.'**
  String get reviewKeptAll;

  /// No description provided for @deletePhotos.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete 1 photo} other{Delete {count} photos}}'**
  String deletePhotos(int count);

  /// No description provided for @startNewSession.
  ///
  /// In en, this message translates to:
  /// **'Start new session'**
  String get startNewSession;

  /// No description provided for @continueCleaning.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueCleaning;

  /// No description provided for @noPhotosDeleted.
  ///
  /// In en, this message translates to:
  /// **'No photos were deleted.'**
  String get noPhotosDeleted;

  /// No description provided for @deleteFailedKeepSelection.
  ///
  /// In en, this message translates to:
  /// **'Some photos couldn’t be deleted. They have not been removed from your selection.'**
  String get deleteFailedKeepSelection;

  /// No description provided for @closePreview.
  ///
  /// In en, this message translates to:
  /// **'Close preview'**
  String get closePreview;

  /// No description provided for @allDone.
  ///
  /// In en, this message translates to:
  /// **'All done!'**
  String get allDone;

  /// No description provided for @partlyDone.
  ///
  /// In en, this message translates to:
  /// **'Partly done'**
  String get partlyDone;

  /// No description provided for @nothingWasDeleted.
  ///
  /// In en, this message translates to:
  /// **'Nothing was deleted'**
  String get nothingWasDeleted;

  /// No description provided for @photosRemoved.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 photo removed.} other{{count} photos removed.}}'**
  String photosRemoved(int count);

  /// No description provided for @photosCouldNotBeRemoved.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 photo could not be removed.} other{{count} photos could not be removed.}}'**
  String photosCouldNotBeRemoved(int count);

  /// No description provided for @partialDeletionSummary.
  ///
  /// In en, this message translates to:
  /// **'{deleted} deleted. {failed} could not be removed.'**
  String partialDeletionSummary(int deleted, int failed);

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ca', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca':
      return AppLocalizationsCa();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
