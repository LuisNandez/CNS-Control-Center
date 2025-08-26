// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'CNS Control Center';

  @override
  String appTitleWithVersion(Object version) {
    return 'Custom Nanosuit System $version';
  }

  @override
  String get installNewMod => 'Instalar Nuevo Mod';

  @override
  String get selectFiles => 'Seleccionar Archivos';

  @override
  String get selectFolder => 'Seleccionar Carpeta';

  @override
  String get installSelectedMod => 'Instalar Mod Seleccionado';

  @override
  String get filesToInstall => 'Archivos a Instalar:';

  @override
  String get cancelSelection => 'Cancelar Selección';

  @override
  String get searchMods => 'Buscar mods...';

  @override
  String get enabledMods => 'Mods Activados';

  @override
  String get disabledMods => 'Mods Desactivados';

  @override
  String get refreshList => 'Actualizar lista';

  @override
  String get noEnabledMods => 'No hay mods activados.';

  @override
  String get noDisabledMods => 'No hay mods desactivados.';

  @override
  String get showInFolder => 'Mostrar en carpeta';

  @override
  String get disableMod => 'Desactivar mod';

  @override
  String get enableMod => 'Activar mod';

  @override
  String get deletePermanently => 'Eliminar permanentemente';

  @override
  String get settings => 'Configuración';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Selecciona un idioma';

  @override
  String get statusSearchingGame =>
      'Buscando la instalación de Stellar Blade...';

  @override
  String get statusGamePathFound => '¡Ruta del juego encontrada!';

  @override
  String get statusGamePathNotFound =>
      'No se pudo encontrar la ruta del juego automáticamente.';

  @override
  String statusErrorFindingGame(Object error) {
    return 'Ocurrió un error al buscar el juego: $error';
  }

  @override
  String statusModsFound(Object disabledCount, Object enabledCount) {
    return '$enabledCount mod(s) activado(s), $disabledCount desactivado(s).';
  }

  @override
  String statusErrorReadingMods(Object error) {
    return 'Error al leer los mods instalados: $error';
  }

  @override
  String statusFilesSelected(Object count) {
    return '$count archivo(s) seleccionado(s). Listo para instalar.';
  }

  @override
  String statusFolderSelected(Object folderName) {
    return 'Carpeta \"$folderName\" seleccionada.\nListo para instalar.';
  }

  @override
  String statusArchiveLoaded(Object count, Object fileName) {
    return 'Archivo \"$fileName\" cargado.\n$count archivo(s) listos para instalar.';
  }

  @override
  String get statusSelectionCancelled =>
      'Selección cancelada.\nElige un nuevo mod para instalar.';

  @override
  String get statusUpdateComplete => 'Actualización completa.';

  @override
  String get statusInstallationComplete => 'Instalación completa.';

  @override
  String statusError(Object error) {
    return 'Error: $error';
  }

  @override
  String get dialogTitle7zip => 'Se Requiere 7-Zip';

  @override
  String get dialogContent7zip =>
      'Para descomprimir este archivo, la aplicación necesita 7-Zip.\n\nPor favor, instálalo desde su página oficial y luego presiona \"Confirmar\".';

  @override
  String get dialogContent7zipNotFound =>
      '7-Zip no ha sido detectado aún.\nAsegúrate de que esté instalado en la ruta por defecto e inténtalo de nuevo.';

  @override
  String get dialogTitleCNSUpdate =>
      'Actualización del Sistema Principal Detectada';

  @override
  String get dialogContentCNSUpdate =>
      'Se ha detectado una actualización para el \"Custom Nanosuit System\".\n\nEsto reemplazará archivos en la carpeta principal del juego (StellarBlade\\SB).\n¿Deseas continuar?';

  @override
  String get dialogTitleMultipleJsons => 'Múltiples Archivos .json Detectados';

  @override
  String dialogContentMultipleJsons(Object count) {
    return 'Se han detectado $count archivos .json.\nPuede tratarse de un mod con múltiples componentes.\n\n¿Quieres instalarlos todos juntos en una única carpeta de mod?';
  }

  @override
  String get dialogTitleModExists => 'El Mod ya Existe';

  @override
  String dialogContentModExists(Object modName) {
    return 'Un mod llamado \"$modName\" ya está instalado.\n\n¿Deseas actualizarlo?\nLos archivos antiguos se eliminarán antes de instalar los nuevos.';
  }

  @override
  String dialogContentModUpdate(Object newModName, Object oldModName) {
    return 'Se encontró una versión anterior \'$oldModName\'.\n\n¿Quieres eliminarla y actualizar a \'$newModName\'?';
  }

  @override
  String get dialogTitleDeleteMod => '¿Eliminar Permanentemente?';

  @override
  String dialogContentDeleteMod(Object modName) {
    return 'Estás a punto de eliminar permanentemente el mod \"$modName\".\nEsta acción no se puede deshacer.\n\n¿Estás seguro?';
  }

  @override
  String get dialogActionCancel => 'Cancelar';

  @override
  String get dialogActionGoToDownload => 'Ir a la Página de Descarga';

  @override
  String get dialogActionConfirmInstallation => 'Confirmar Instalación';

  @override
  String get dialogActionUpdateSystem => 'Actualizar Sistema';

  @override
  String get dialogActionInstallAnyway => 'Instalar de Todos Modos';

  @override
  String get dialogActionUpdate => 'Actualizar';

  @override
  String get dialogActionDelete => 'Eliminar';

  @override
  String get dialogActionClose => 'Cerrar';

  @override
  String snackBarBatchInstallComplete(Object failedCount, Object successCount) {
    return 'Instalación por lotes completa.\nÉxito: $successCount, Fallidos: $failedCount.';
  }

  @override
  String snackBarModInstalled(Object modName) {
    return 'Mod \"$modName\" instalado correctamente.';
  }

  @override
  String snackBarModEnabled(Object modName) {
    return 'Mod \"$modName\" activado.';
  }

  @override
  String snackBarModDisabled(Object modName) {
    return 'Mod \"$modName\" desactivado.';
  }

  @override
  String snackBarModDeleted(Object modName) {
    return 'Mod \"$modName\" eliminado permanentemente.';
  }

  @override
  String get snackBarCNSUpdated =>
      'Custom Nanosuit System actualizado correctamente.';

  @override
  String get dropTargetOverlay => 'Arrastra los mods aquí';

  @override
  String get pathSelectionTitle => 'Ruta de Stellar Blade No Encontrada';

  @override
  String get pathSelectionButtonManual =>
      'Seleccionar Carpeta del Juego Manualmente';

  @override
  String get pathSelectionButtonRetry => 'Intentar de Nuevo';

  @override
  String errorFolderSelection(Object error) {
    return 'Error al seleccionar la carpeta: $error';
  }

  @override
  String errorFileSelection(Object error) {
    return 'Error al seleccionar los archivos: $error';
  }

  @override
  String errorDecompressing(Object error) {
    return 'Error al descomprimir el archivo: $error';
  }

  @override
  String errorProcessingArchive(Object error) {
    return 'Error al procesar el archivo: $error';
  }

  @override
  String errorUnsupportedFormat(Object extension) {
    return 'Formato de archivo no soportado: $extension';
  }

  @override
  String get error7zipRequired => 'Operación cancelada: Se requiere 7-Zip.';

  @override
  String get errorGamePathUndefined => 'La ruta del juego no está definida.';

  @override
  String get errorDestinationNotFound =>
      'La carpeta de destino del juego no existe.';

  @override
  String errorUpdateSystem(Object error) {
    return 'Error al actualizar el sistema: $error';
  }

  @override
  String get errorInstallNoSelection =>
      'No has seleccionado nada para instalar.';

  @override
  String get errorInstallModExists =>
      'Instalación cancelada: El mod ya existe.';

  @override
  String get errorNoJsonFound =>
      'Cada mod debe contener al menos un archivo .json.';

  @override
  String errorInvalidJsonFormat(Object fileName) {
    return 'El archivo $fileName tiene un formato JSON inválido.';
  }

  @override
  String errorNoDisplayName(Object fileName) {
    return 'El archivo $fileName no parece ser un mod de Custom Nanosuit System (falta \"DisplayName\").';
  }

  @override
  String get errorNoValidDisplayName =>
      'No se encontró un \"DisplayName\" válido en los archivos .json.';

  @override
  String errorEnableMod(Object error) {
    return 'Error al activar el mod: $error';
  }

  @override
  String errorDisableMod(Object error) {
    return 'Error al desactivar el mod: $error';
  }

  @override
  String errorDeleteMod(Object error) {
    return 'Error al eliminar el mod: $error';
  }

  @override
  String errorOpenFolder(Object path) {
    return 'No se pudo abrir la carpeta: $path';
  }

  @override
  String get statusUpdateSystemCancelled =>
      'Actualización del sistema cancelada.';

  @override
  String get statusUpdatingCNS => 'Actualizando Custom Nanosuit System...';

  @override
  String statusExtractingFile(Object fileName) {
    return 'Extrayendo $fileName...';
  }

  @override
  String get statusInstallationCancelledByUser =>
      'Instalación cancelada por el usuario.';

  @override
  String get errorNoCompatibleFilesInFolder =>
      'La carpeta seleccionada no contiene archivos de mod compatibles.';

  @override
  String get errorNoCompatibleFilesInArchive =>
      'El archivo comprimido no contiene archivos de mod compatibles.';

  @override
  String get errorNoJsonInSelection =>
      'La selección no contiene un archivo .json de mod válido.';

  @override
  String get aboutTitle => 'Acerca de CNS Control Center';

  @override
  String get aboutContent =>
      'Esta aplicación es un gestor de mods para Stellar Blade, diseñado para funcionar con el Custom Nanosuit System (CNS).\n\nRequisito: Para una funcionalidad completa con archivos .rar y .7z, 7-Zip debe estar instalado en tu sistema.';

  @override
  String get aboutLinkText => 'Visita mi perfil de creador';

  @override
  String get creatorProfileUrl =>
      'https://www.nexusmods.com/users/your-user-id';

  @override
  String aboutVersion(Object version) {
    return 'Versión: $version';
  }

  @override
  String get openModsFolder => 'Abrir Carpeta de Mods';

  @override
  String get openInNexusMods => 'Abrir en Nexus Mods';

  @override
  String get checkForUpdates => 'Buscar actualizaciones';

  @override
  String updateAvailable(Object version) {
    return 'Actualización disponible: v$version';
  }

  @override
  String get dialogTitleApiKey => 'Clave API de Nexus Mods';

  @override
  String get dialogContentApiKey =>
      'Para buscar actualizaciones de mods, necesitas una clave API personal de Nexus Mods.\nPuedes generar una en la configuración de tu perfil en su sitio web.';

  @override
  String get apiKey => 'Clave API';

  @override
  String get dialogActionSave => 'Guardar';

  @override
  String get snackBarApiKeySaved => 'Clave API guardada correctamente.';

  @override
  String get errorApiKeyMissing =>
      'La clave API de Nexus Mods no está configurada.\nPor favor, añádela en la configuración.';

  @override
  String get statusCheckingUpdates => 'Buscando actualizaciones de mods...';

  @override
  String statusUpdatesFound(Object count) {
    return '¡$count actualización(es) encontrada(s)!';
  }

  @override
  String get statusNoUpdates => 'Todos los mods están actualizados.';

  @override
  String get selectModArchive => 'Seleccionar Archivo de Mod';

  @override
  String get viewImageGallery => 'Ver Imagen';

  @override
  String get imageGallery => 'Galería de Imágenes';

  @override
  String get noImagesFound => 'No se encontraron imágenes para este mod.';

  @override
  String errorFetchingImages(Object error) {
    return 'Error al obtener las imágenes: $error';
  }

  @override
  String get imageMod => 'Imagen del Mod';

  @override
  String get dialogContentUpdateOptions => '¿Qué te gustaría hacer?';

  @override
  String get dialogActionIgnoreVersion => 'Ignorar Versión';

  @override
  String get dialogActionGoToDownloadPage => 'Ir a la Descarga';

  @override
  String get installedMods => 'Mods Instalados';

  @override
  String get filterBy => 'Filtrar por:';

  @override
  String get sortBy => 'Ordenar por:';

  @override
  String get filterAll => 'Todos';

  @override
  String get filterEnabled => 'Activados';

  @override
  String get filterDisabled => 'Desactivados';

  @override
  String get sortByName => 'Nombre';

  @override
  String get sortByDate => 'Fecha';

  @override
  String get noModsFound => 'No se encontraron mods.';

  @override
  String statusExtractingMultipleFiles(
    Object count,
    Object fileName,
    Object total,
  ) {
    return 'Extrayendo $count de $total: $fileName';
  }

  @override
  String get previewInstallTitle => 'Mods a Instalar:';

  @override
  String get dialogTitleUE4SS => 'Instalación de UE4SS Detectada';

  @override
  String get dialogContentUE4SS =>
      'Se ha detectado la herramienta UE4SS. ¿Deseas instalarla en \'StellarBlade\\SB\\Binaries\\Win64\'?\n\nEsto es necesario para que muchos mods funcionen.';

  @override
  String get dialogActionInstallTool => 'Instalar Herramienta';

  @override
  String get statusUE4SSInstallCancelled => 'Instalación de UE4SS cancelada.';

  @override
  String get statusInstallingUE4SS => 'Instalando UE4SS...';

  @override
  String get snackBarUE4SSInstalled => 'UE4SS instalado correctamente.';

  @override
  String error7zipDecompression(Object error) {
    return 'Error de 7-Zip durante la descompresión: $error';
  }

  @override
  String get statusUE4SSInstallComplete => 'Instalación de UE4SS completada.';
}
