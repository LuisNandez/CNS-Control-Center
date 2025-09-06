// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Centro de Control CNS';

  @override
  String appTitleWithVersion(Object version) {
    return 'Custom Nanosuit System $version';
  }

  @override
  String get settings => 'Ajustes';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageDesc => 'Choose the application language';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsAboutDesc => 'Information about the application';

  @override
  String get settingsPathsAndTools => 'Paths & Tools';

  @override
  String get settingsGameFolder => 'Game Folder';

  @override
  String get settingsGameFolderDesc =>
      'The root folder of your Stellar Blade installation.';

  @override
  String get settings7zipPath => '7-Zip Path';

  @override
  String get settings7zipPathDesc =>
      'The location of the 7z.exe file for extracting mods.';

  @override
  String get settings7zipPathAuto => 'Automatic search';

  @override
  String get settingsRepairMods => 'Repair Legacy Mods';

  @override
  String get settingsRepairModsDesc =>
      'Scans and creates info files for old mods using the local database. Requires API key.';

  @override
  String get settingsConnectivity => 'Connectivity & Updates';

  @override
  String get settingsApiKey => 'Nexus Mods API Key';

  @override
  String get settingsApiKeyDesc => 'Required for checking mod updates.';

  @override
  String get settingsApiKeySet => 'Set';

  @override
  String get settingsApiKeyNotSet => 'Not set';

  @override
  String get settingsSkippedVersions => 'Manage Skipped Versions';

  @override
  String get settingsSkippedVersionsDesc =>
      'Manage mod versions you have chosen to skip.';

  @override
  String settingsSkippedVersionsCount(Object count) {
    return '$count versions skipped';
  }

  @override
  String get dialogTitleSkippedVersions => 'Skipped Mod Versions';

  @override
  String get dialogNoSkippedVersions =>
      'You have not skipped any mod versions.';

  @override
  String get dialogSkippedVersions => 'Skipped Version';

  @override
  String get dialogTitleRepairMods => 'Run Legacy Mod Repair?';

  @override
  String get dialogContentRepairMods =>
      'Warning: This feature is in development and may not be perfect.\n\nIt will scan mods without a \'nexus_info.json\' file and, if found in your local database, create one for them. It will also attempt to rename the mod\'s folder to include the found version (e.g., \'My Mod\' -> \'My Mod v1.2\').\n\nVersion Priority:\n1. From the folder name.\n2. From the mod\'s description field.\n3. From the latest version on Nexus Mods (requires API).\n\nDo you want to continue?';

  @override
  String get dialogActionRunRepair => 'Run Repair';

  @override
  String get snackBarGamePathInvalid =>
      'The selected folder does not appear to be a valid game folder.';

  @override
  String get snackBar7zipPathInvalid =>
      'The selected file must be named 7z.exe.';

  @override
  String get snackBarRepairStarted =>
      'Legacy mod repair process has started...';

  @override
  String snackBarRepairComplete(Object count) {
    return 'Repair complete. $count mod(s) were updated.';
  }

  @override
  String get snackBarRepairNoMods =>
      'No legacy mods were found that needed repairing.';

  @override
  String get errorApiRequiredForRepair =>
      'API Key is required to find the latest version for mods without a local version.';

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
  String get refreshList => 'Refrescar lista';

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
    return 'Carpeta \"$folderName\" seleccionada. Lista para instalar.';
  }

  @override
  String statusArchiveLoaded(Object count, Object fileName) {
    return 'Archivo \"$fileName\" cargado. $count archivo(s) listos para instalar.';
  }

  @override
  String get statusSelectionCancelled =>
      'Selección cancelada. Elige un nuevo mod para instalar.';

  @override
  String get statusUpdateComplete => 'Actualización completada.';

  @override
  String get statusInstallationComplete => 'Instalación completada.';

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
      '7-Zip aún no ha sido detectado. Por favor, asegúrate de que esté instalado en la ruta por defecto y vuelve a intentarlo.';

  @override
  String get dialogTitleCNSUpdate =>
      'Actualización del Sistema Principal Detectada';

  @override
  String get dialogContentCNSUpdate =>
      'Se ha detectado una actualización para el \"Custom Nanosuit System\".\n\nEsto reemplazará archivos en la carpeta principal del juego (StellarBlade\\SB). ¿Deseas continuar?';

  @override
  String get dialogTitleMultipleJsons => 'Múltiples Archivos .json Detectados';

  @override
  String dialogContentMultipleJsons(Object count) {
    return 'Se han detectado $count archivos .json. Podría ser un mod con múltiples componentes.\n\n¿Quieres instalarlos todos juntos en una única carpeta de mod?';
  }

  @override
  String get dialogTitleModExists => 'El Mod ya Existe';

  @override
  String dialogContentModExists(Object modName) {
    return 'Un mod llamado \"$modName\" ya está instalado.\n\n¿Quieres actualizarlo? Los archivos antiguos se borrarán antes de instalar los nuevos.';
  }

  @override
  String dialogContentModUpdate(Object newModName, Object oldModName) {
    return 'Se encontró una versión más antigua \'$oldModName\'.\n\n¿Quieres eliminarla y actualizar a \'$newModName\'?';
  }

  @override
  String get dialogTitleDeleteMod => '¿Eliminar Permanentemente?';

  @override
  String dialogContentDeleteMod(Object modName) {
    return 'Estás a punto de eliminar permanentemente el mod \"$modName\". Esta acción no se puede deshacer.\n\n¿Estás seguro?';
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
    return 'Instalación por lotes completada. Éxito: $successCount, Fallidos: $failedCount.';
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
  String get snackBarApiKeySaved => 'Clave de API guardada correctamente.';

  @override
  String get snackBarGamePathSaved => 'Game path saved successfully.';

  @override
  String get snackBar7zipPathSaved => '7-Zip path saved successfully.';

  @override
  String get snackBarSkippedVersionRemoved => 'Skipped version removed.';

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
    return 'Error al seleccionar archivos: $error';
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
  String get aboutLinkText => 'Visita el perfil de mi creador';

  @override
  String get creatorProfileUrl =>
      'https://next.nexusmods.com/profile/LuisNandez?gameId=7804';

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
  String get dialogTitleApiKey => 'Clave de API de Nexus Mods';

  @override
  String get dialogContentApiKey =>
      'Para buscar actualizaciones de mods, necesitas una clave de API personal de Nexus Mods.';

  @override
  String get dialogContentApiKeyInstructions =>
      '1. Ve a Nexus Mods e inicia sesión.\n2. Haz clic en tu avatar y ve a \'Site preferences\'.\n3. Ve a la pestaña \'API\'.\n4. Haz clic en \'Generate a new API key\'.\n5. Copia la clave y pégala aquí.';

  @override
  String get apiKey => 'Clave de API';

  @override
  String get apiKeyHintText => 'Pega tu clave de API aquí';

  @override
  String get dialogActionSave => 'Guardar';

  @override
  String get apiKeyRemoved => 'Clave de API eliminada.';

  @override
  String get invalidApiKeyError => 'Clave de API inválida.';

  @override
  String get validatingApiKey => 'Validando...';

  @override
  String get errorApiKeyMissing =>
      'La clave de API de Nexus Mods no está configurada. Por favor, añádela a través del icono de la llave en la barra superior.';

  @override
  String get statusCheckingUpdates => 'Buscando actualizaciones de mods...';

  @override
  String statusUpdatesFound(Object count) {
    return '¡Se encontraron $count actualización(es)!';
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
  String get noImagesFound =>
      'No se encontraron imágenes para este mod, o la clave de API no ha sido introducida. Por favor, introduce la clave y busca actualizaciones después.';

  @override
  String errorFetchingImages(Object error) {
    return 'Error al obtener las imágenes: $error';
  }

  @override
  String get imageMod => 'Imagen del Mod';

  @override
  String get dialogContentUpdateOptions => '¿Qué te gustaría hacer?';

  @override
  String get dialogActionIgnoreVersion => 'Ignorar';

  @override
  String get dialogActionSkipVersion => 'Skip Version';

  @override
  String get dialogActionGoToDownloadPage => 'Ir a Descargar';

  @override
  String get installedMods => 'Mods Instalados';

  @override
  String get filterBy => 'Filtrar:';

  @override
  String get sortBy => 'Ordenar por:';

  @override
  String get filterAll => 'Todos';

  @override
  String get filterEnabled => 'Activados';

  @override
  String get filterDisabled => 'Desactivados';

  @override
  String get filterRepaired => 'Repaired';

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
      'Se ha detectado la herramienta UE4SS. ¿Quieres instalarla en \'StellarBlade\\SB\\Binaries\\Win64\'?\n\nEsto es necesario para que muchos mods funcionen.';

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

  @override
  String get dialogTitleAlternativeVersion => 'Versión Alternativa Detectada';

  @override
  String dialogContentAlternativeVersion(
    String oldModName,
    String baseModName,
    String newModName,
  ) {
    return 'Ya hay instalada una versión alternativa de este mod: \'$oldModName\'.\n\nEstás a punto de instalar una alternativa diferente llamada \'$newModName\'.';
  }

  @override
  String get dialogActionReplace => 'Reemplazar';

  @override
  String get dialogActionInstallAsNew => 'Instalar como Nuevo';

  @override
  String get dialogTitleUpdate => 'Actualización Disponible';

  @override
  String dialogContentUpdate(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return 'Estás a punto de actualizar el mod \'$modName\'.\n\nVersión instalada: $oldVersion\nNueva versión: $newVersion';
  }

  @override
  String get dialogTitleDowngrade => 'Versión Anterior Detectada';

  @override
  String dialogContentDowngrade(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return 'Advertencia: Estás a punto de instalar una versión más antigua del mod \'$modName\'.\n\nVersión instalada: $oldVersion\nVersión a instalar: $newVersion';
  }

  @override
  String get dialogActionDowngrade => 'Degradar';

  @override
  String get dialogTitleReinstall => 'Reinstalar Mod';

  @override
  String dialogContentReinstall(Object modName, Object version) {
    return 'Estás a punto de reinstalar la versión \'$version\' del mod \'$modName\'.';
  }

  @override
  String get dialogActionReinstall => 'Reinstalar';

  @override
  String get editModNameTooltip => 'Edit mod name';

  @override
  String get dialogTitleEditModName => 'Edit Mod Name';

  @override
  String get dialogLabelNewName => 'New name';

  @override
  String errorModNameExists(Object modName) {
    return 'A mod named \"$modName\" already exists.';
  }

  @override
  String get dialogTitleRepairedModWarning => 'Repaired Mod Warning';

  @override
  String get dialogContentRepairedModWarning =>
      'This mod might not have the correct version information. Reinstalling the latest version is recommended to ensure compatibility.';

  @override
  String get repairedModTooltip => 'Information about repaired mod';
}
