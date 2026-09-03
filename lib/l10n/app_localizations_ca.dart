// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get appTitle => 'CleanRoll';

  @override
  String get appTagline => 'Neteja la galeria foto a foto.';

  @override
  String get allowAccess => 'Permetre l’accés';

  @override
  String get openSettings => 'Obrir la configuració';

  @override
  String get permissionNeeded =>
      'CleanRoll necessita accés a les teves fotos perquè puguis triar quines conservar o eliminar.';

  @override
  String get permissionPermanentlyDenied =>
      'L’accés a les fotos està desactivat. Activa’l a la configuració del sistema per netejar la galeria.';

  @override
  String get couldNotLoadAlbums => 'No s’han pogut carregar els àlbums';

  @override
  String get checkPhotoPermissions =>
      'Comprova els permisos de fotos i torna-ho a provar.';

  @override
  String get tryAgain => 'Tornar-ho a provar';

  @override
  String get noPhotosToReview => 'No hi ha fotos per revisar';

  @override
  String get noAccessiblePhotos => 'No hi ha fotos accessibles per netejar.';

  @override
  String photoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotos',
      one: '1 foto',
    );
    return '$_temp0';
  }

  @override
  String get albumEmpty => 'Aquest àlbum no té fotos disponibles per revisar.';

  @override
  String get albumLoadFailed =>
      'No s’han pogut carregar les fotos d’aquest àlbum. Torna-ho a provar.';

  @override
  String get chooseOrder => 'Tria un ordre';

  @override
  String get orderNewestTitle => 'Més recents primer';

  @override
  String get orderNewestSubtitle => 'Comença per les fotos més noves';

  @override
  String get orderOldestTitle => 'Més antigues primer';

  @override
  String get orderOldestSubtitle => 'Comença per les fotos més velles';

  @override
  String get orderRandomTitle => 'Aleatori';

  @override
  String get orderRandomSubtitle => 'Barreja l’àlbum un cop i revisa';

  @override
  String get settings => 'Configuració';

  @override
  String get appearance => 'Aparença';

  @override
  String get themeLight => 'Clar';

  @override
  String get themeDark => 'Fosc';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get language => 'Idioma';

  @override
  String get languageEnglish => 'Anglès';

  @override
  String get languageSpanish => 'Espanyol';

  @override
  String get languageCatalan => 'Català';

  @override
  String get languageSystem => 'Sistema';

  @override
  String get openMenu => 'Obrir el menú';

  @override
  String get closeMenu => 'Tancar el menú';

  @override
  String get delete => 'Eliminar';

  @override
  String get keep => 'Conservar';

  @override
  String get review => 'Revisar';

  @override
  String get undo => 'Desfer';

  @override
  String markedCount(int count) {
    return '$count marcades';
  }

  @override
  String get swipeKeep => 'CONSERVAR';

  @override
  String get swipeDelete => 'ELIMINAR';

  @override
  String get nothingSelected => 'Res seleccionat';

  @override
  String get nothingToDelete => 'Res a eliminar';

  @override
  String photosSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotos seleccionades',
      one: '1 foto seleccionada',
    );
    return '$_temp0';
  }

  @override
  String get reviewHintContinue =>
      'Marca fotos per eliminar mentre neteges i revisa-les aquí.';

  @override
  String get reviewKeptAll => 'Has conservat totes les fotos d’aquesta sessió.';

  @override
  String deletePhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Eliminar $count fotos',
      one: 'Eliminar 1 foto',
    );
    return '$_temp0';
  }

  @override
  String get startNewSession => 'Sessió nova';

  @override
  String get continueCleaning => 'Continuar';

  @override
  String get noPhotosDeleted => 'No s’ha eliminat cap foto.';

  @override
  String get deleteFailedKeepSelection =>
      'Algunes fotos no s’han pogut eliminar. Continuen a la selecció.';

  @override
  String get closePreview => 'Tancar la previsualització';

  @override
  String get allDone => 'Fet!';

  @override
  String get partlyDone => 'Fet en part';

  @override
  String get nothingWasDeleted => 'No s’ha eliminat res';

  @override
  String photosRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotos eliminades.',
      one: '1 foto eliminada.',
    );
    return '$_temp0';
  }

  @override
  String photosCouldNotBeRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotos no s’han pogut eliminar.',
      one: '1 foto no s’ha pogut eliminar.',
    );
    return '$_temp0';
  }

  @override
  String partialDeletionSummary(int deleted, int failed) {
    return '$deleted eliminades. $failed no s’han pogut treure.';
  }

  @override
  String get done => 'Fet';
}
