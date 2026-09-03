// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'CleanRoll';

  @override
  String get appTagline => 'Limpia tu galería foto a foto.';

  @override
  String get allowAccess => 'Permitir acceso';

  @override
  String get openSettings => 'Abrir ajustes';

  @override
  String get permissionNeeded =>
      'CleanRoll necesita acceso a tus fotos para que puedas elegir cuáles guardar o eliminar.';

  @override
  String get permissionPermanentlyDenied =>
      'El acceso a las fotos está desactivado. Actívalo en los ajustes del sistema para limpiar tu galería.';

  @override
  String get couldNotLoadAlbums => 'No se pudieron cargar los álbumes';

  @override
  String get checkPhotoPermissions =>
      'Comprueba los permisos de fotos e inténtalo de nuevo.';

  @override
  String get tryAgain => 'Reintentar';

  @override
  String get noPhotosToReview => 'No hay fotos para revisar';

  @override
  String get noAccessiblePhotos => 'No hay fotos accesibles para limpiar.';

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
  String get albumEmpty =>
      'Este álbum no tiene fotos disponibles para revisar.';

  @override
  String get albumLoadFailed =>
      'No se pudieron cargar las fotos de este álbum. Inténtalo de nuevo.';

  @override
  String get chooseOrder => 'Elige un orden';

  @override
  String get orderNewestTitle => 'Más recientes primero';

  @override
  String get orderNewestSubtitle => 'Empieza por tus fotos más nuevas';

  @override
  String get orderOldestTitle => 'Más antiguas primero';

  @override
  String get orderOldestSubtitle => 'Empieza por tus fotos más viejas';

  @override
  String get orderRandomTitle => 'Aleatorio';

  @override
  String get orderRandomSubtitle => 'Baraja el álbum una vez y revisa';

  @override
  String get settings => 'Ajustes';

  @override
  String get appearance => 'Apariencia';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get language => 'Idioma';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageCatalan => 'Catalán';

  @override
  String get languageSystem => 'Sistema';

  @override
  String get openMenu => 'Abrir menú';

  @override
  String get closeMenu => 'Cerrar menú';

  @override
  String get delete => 'Eliminar';

  @override
  String get keep => 'Guardar';

  @override
  String get review => 'Revisar';

  @override
  String get undo => 'Deshacer';

  @override
  String markedCount(int count) {
    return '$count marcadas';
  }

  @override
  String get swipeKeep => 'GUARDAR';

  @override
  String get swipeDelete => 'ELIMINAR';

  @override
  String get nothingSelected => 'Nada seleccionado';

  @override
  String get nothingToDelete => 'Nada que eliminar';

  @override
  String photosSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotos seleccionadas',
      one: '1 foto seleccionada',
    );
    return '$_temp0';
  }

  @override
  String get reviewHintContinue =>
      'Marca fotos para eliminar mientras limpias y revísalas aquí.';

  @override
  String get reviewKeptAll => 'Has guardado todas las fotos de esta sesión.';

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
  String get startNewSession => 'Nueva sesión';

  @override
  String get continueCleaning => 'Continuar';

  @override
  String get noPhotosDeleted => 'No se eliminó ninguna foto.';

  @override
  String get deleteFailedKeepSelection =>
      'Algunas fotos no se pudieron eliminar. Siguen en tu selección.';

  @override
  String get closePreview => 'Cerrar vista previa';

  @override
  String get allDone => '¡Listo!';

  @override
  String get partlyDone => 'Hecho en parte';

  @override
  String get nothingWasDeleted => 'No se eliminó nada';

  @override
  String photosRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotos eliminadas.',
      one: '1 foto eliminada.',
    );
    return '$_temp0';
  }

  @override
  String photosCouldNotBeRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotos no se pudieron eliminar.',
      one: '1 foto no se pudo eliminar.',
    );
    return '$_temp0';
  }

  @override
  String partialDeletionSummary(int deleted, int failed) {
    return '$deleted eliminadas. $failed no se pudieron quitar.';
  }

  @override
  String get done => 'Listo';
}
