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
  String get settings => 'Ajustes';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageDesc => 'Elige el idioma de la aplicación';

  @override
  String get settingsAbout => 'Acerca de';

  @override
  String get settingsAboutDesc => 'Información sobre la aplicación';

  @override
  String get settingsPathsAndTools => 'Rutas y Herramientas';

  @override
  String get settingsGameFolder => 'Carpeta del Juego';

  @override
  String get settingsGameFolderDesc =>
      'La carpeta raíz de tu instalación de Stellar Blade.';

  @override
  String get settings7zipPath => 'Ruta de 7-Zip';

  @override
  String get settings7zipPathDesc =>
      'La ubicación del archivo 7z.exe para extraer mods.';

  @override
  String get settings7zipPathAuto => 'Búsqueda automática';

  @override
  String get settingsRepairMods => 'Reparar Mods Heredados';

  @override
  String get settingsRepairModsDesc =>
      'Escanea y crea archivos de información para mods antiguos usando la base de datos local. Requiere clave de API.';

  @override
  String get settingsConnectivity => 'Conectividad y Actualizaciones';

  @override
  String get settingsApiKey => 'Clave de API de Nexus Mods';

  @override
  String get settingsApiKeyDesc =>
      'Requerida para comprobar las actualizaciones de los mods.';

  @override
  String get settingsApiKeySet => 'Establecida';

  @override
  String get settingsApiKeyNotSet => 'No establecida';

  @override
  String get settingsSkippedVersions => 'Gestionar Versiones Omitidas';

  @override
  String get settingsSkippedVersionsDesc =>
      'Gestiona las versiones de mods que has decidido omitir.';

  @override
  String settingsSkippedVersionsCount(Object count) {
    return '$count versiones omitidas';
  }

  @override
  String get dialogTitleSkippedVersions => 'Versiones de Mod Omitidas';

  @override
  String get dialogNoSkippedVersions =>
      'No has omitido ninguna versión de mod.';

  @override
  String get dialogSkippedVersions => 'Versión Omitida';

  @override
  String get dialogTitleRepairMods => '¿Ejecutar Reparación de Mods Heredados?';

  @override
  String get dialogContentRepairMods =>
      'Advertencia: Esta función está en desarrollo y puede no ser perfecta.\n\nEscaneará los mods sin un archivo \'nexus_info.json\' y, si se encuentran en tu base de datos local, creará uno para ellos. También intentará renombrar la carpeta del mod para incluir la versión encontrada (ej., \'Mi Mod\' -> \'Mi Mod v1.2\').\n\nPrioridad de Versión:\n1. Del nombre de la carpeta.\n2. Del campo de descripción del mod.\n3. De la última versión en Nexus Mods (requiere API).\n\n¿Deseas continuar?';

  @override
  String get dialogActionRunRepair => 'Ejecutar Reparación';

  @override
  String get snackBarGamePathInvalid =>
      'La carpeta seleccionada no parece ser una carpeta de juego válida.';

  @override
  String get snackBar7zipPathInvalid =>
      'El archivo seleccionado debe llamarse 7z.exe.';

  @override
  String get snackBarRepairStarted =>
      'El proceso de reparación de mods heredados ha comenzado...';

  @override
  String snackBarRepairComplete(Object count) {
    return 'Reparación completa. $count mod(s) fueron actualizados.';
  }

  @override
  String get snackBarRepairNoMods =>
      'No se encontraron mods heredados que necesitaran reparación.';

  @override
  String get errorApiRequiredForRepair =>
      'Se requiere una clave de API para encontrar la última versión de los mods sin una versión local.';

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
      '7-Zip aún no ha sido detectado. Por favor, asegúrate de que esté instalado en la ruta predeterminada e inténtalo de nuevo.';

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
    return 'Se han detectado $count archivos .json. Esto podría ser un mod con múltiples componentes.\n\n¿Quieres instalarlos todos juntos en una única carpeta de mod?';
  }

  @override
  String get dialogTitleModExists => 'El Mod ya Existe';

  @override
  String dialogContentModExists(Object modName) {
    return 'Ya existe un mod llamado \"$modName\".\n\n¿Quieres actualizarlo? Los archivos antiguos se eliminarán antes de instalar los nuevos.';
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
    return 'Instalación por lotes completa. Éxito: $successCount, Fallidos: $failedCount.';
  }

  @override
  String snackBarModInstalled(Object modName) {
    return 'Mod \"$modName\" instalado con éxito.';
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
      'Custom Nanosuit System actualizado con éxito.';

  @override
  String get snackBarApiKeySaved => 'Clave de API guardada con éxito.';

  @override
  String get snackBarGamePathSaved => 'Ruta del juego guardada con éxito.';

  @override
  String get snackBar7zipPathSaved => 'Ruta de 7-Zip guardada con éxito.';

  @override
  String get snackBarSkippedVersionRemoved => 'Versión omitida eliminada.';

  @override
  String get dropTargetOverlay => 'Suelta los mods aquí';

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
    return 'Formato de archivo no compatible: $extension';
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
  String get noImagesFound =>
      'No se encontraron imágenes para este mod, o la clave de API no ha sido introducida. Por favor, introduce la clave de API y busca actualizaciones después.';

  @override
  String errorFetchingImages(Object error) {
    return 'Error al obtener las imágenes: $error';
  }

  @override
  String get imageMod => 'Imagen del Mod';

  @override
  String get modEnabledBadge => 'Enabled';

  @override
  String get modDisabledBadge => 'Disabled';

  @override
  String get modCategoryOther => 'Other';

  @override
  String get dialogContentUpdateOptions => '¿Qué te gustaría hacer?';

  @override
  String get dialogActionIgnoreVersion => 'Ignorar';

  @override
  String get dialogActionSkipVersion => 'Omitir Versión';

  @override
  String get dialogActionGoToDownloadPage => 'Ir a Descargar';

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
  String get filterRepaired => 'Reparados';

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
  String get previewInstallTitle => 'Mods a ser Instalados:';

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
  String get snackBarUE4SSInstalled => 'UE4SS instalado con éxito.';

  @override
  String error7zipDecompression(Object error) {
    return 'Error de 7-Zip durante la descompresión: $error';
  }

  @override
  String get statusUE4SSInstallComplete => 'Instalación de UE4SS completa.';

  @override
  String get dialogTitleAlternativeVersion => 'Versión Alternativa Detectada';

  @override
  String dialogContentAlternativeVersion(
    String oldModName,
    String baseModName,
    String newModName,
  ) {
    return 'Ya está instalada una versión alternativa de este mod: \'$oldModName\'.\n\nEstás a punto de instalar una alternativa diferente llamada \'$newModName\'.';
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
    return 'Advertencia: Estás a punto de instalar una versión anterior del mod \'$modName\'.\n\nVersión instalada: $oldVersion\nVersión a instalar: $newVersion';
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
  String get editModNameTooltip => 'Editar nombre del mod';

  @override
  String get dialogTitleEditModName => 'Editar Nombre del Mod';

  @override
  String get dialogActionResetToDefault => 'Reset to Default';

  @override
  String get dialogLabelNewName => 'Nuevo nombre';

  @override
  String errorModNameExists(Object modName) {
    return 'Ya existe un mod llamado \"$modName\".';
  }

  @override
  String get dialogTitleRepairedModWarning => 'Advertencia de Mod Reparado';

  @override
  String get dialogContentRepairedModWarning =>
      'Este mod podría no tener la información de versión correcta. Se recomienda reinstalar la última versión para asegurar la compatibilidad.';

  @override
  String get repairedModTooltip => 'Información sobre el mod reparado';

  @override
  String get disableAllModsTooltip => 'Disable all mods';

  @override
  String get deleteAllModsTooltip => 'Delete all disabled mods';

  @override
  String get dialogTitleDisableAll => 'Disable All Mods?';

  @override
  String dialogContentDisableAll(int count) {
    return 'Are you sure you want to disable all $count enabled mods? They will be moved to the backup folder.';
  }

  @override
  String get dialogTitleDeleteAll => 'Delete Disabled Mods?';

  @override
  String dialogContentDeleteAll(int count) {
    return 'You are about to permanently delete all $count disabled mods. This action cannot be undone.\n\nAre you sure?';
  }

  @override
  String snackBarAllModsDisabled(int count) {
    return 'All $count enabled mods have been disabled.';
  }

  @override
  String snackBarAllModsDeleted(int count) {
    return 'All $count disabled mods have been permanently deleted.';
  }

  @override
  String get snackBarNoModsToDisable => 'There are no enabled mods to disable.';

  @override
  String get snackBarNoModsToDelete => 'There are no disabled mods to delete.';

  @override
  String get enableAllModsTooltip => 'Enable all mods';

  @override
  String get dialogTitleEnableAll => 'Enable All Mods?';

  @override
  String dialogContentEnableAll(int count) {
    return 'Are you sure you want to enable all $count disabled mods? They will be moved to the main mods folder.';
  }

  @override
  String snackBarAllModsEnabled(int count) {
    return 'All $count disabled mods have been enabled.';
  }

  @override
  String get snackBarNoModsToEnable => 'There are no disabled mods to enable.';
}
