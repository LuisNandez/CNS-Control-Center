// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'CNS Control Center';

  @override
  String appTitleWithVersion(Object version) {
    return 'Custom Nanosuit System $version';
  }

  @override
  String get installNewMod => 'Установить новый мод';

  @override
  String get selectFiles => 'Выбрать файлы';

  @override
  String get selectFolder => 'Выбрать папку';

  @override
  String get installSelectedMod => 'Установить выбранный мод';

  @override
  String get filesToInstall => 'Файлы для установки:';

  @override
  String get cancelSelection => 'Отменить выбор';

  @override
  String get searchMods => 'Поиск модов...';

  @override
  String get enabledMods => 'Включенные моды';

  @override
  String get disabledMods => 'Отключенные моды';

  @override
  String get refreshList => 'Обновить список';

  @override
  String get noEnabledMods => 'Нет включенных модов.';

  @override
  String get noDisabledMods => 'Нет отключенных модов.';

  @override
  String get showInFolder => 'Показать в папке';

  @override
  String get disableMod => 'Отключить мод';

  @override
  String get enableMod => 'Включить мод';

  @override
  String get deletePermanently => 'Удалить навсегда';

  @override
  String get settings => 'Настройки';

  @override
  String get language => 'Язык';

  @override
  String get selectLanguage => 'Выберите язык';

  @override
  String get statusSearchingGame => 'Поиск установки Stellar Blade...';

  @override
  String get statusGamePathFound => 'Путь к игре найден!';

  @override
  String get statusGamePathNotFound =>
      'Не удалось автоматически найти путь к игре.';

  @override
  String statusErrorFindingGame(Object error) {
    return 'Произошла ошибка при поиске игры: $error';
  }

  @override
  String statusModsFound(Object disabledCount, Object enabledCount) {
    return '$enabledCount мод(ов) включено, $disabledCount отключено.';
  }

  @override
  String statusErrorReadingMods(Object error) {
    return 'Ошибка чтения установленных модов: $error';
  }

  @override
  String statusFilesSelected(Object count) {
    return 'Выбрано $count файл(ов). Готово к установке.';
  }

  @override
  String statusFolderSelected(Object folderName) {
    return 'Папка \"$folderName\" выбрана.\nГотово к установке.';
  }

  @override
  String statusArchiveLoaded(Object count, Object fileName) {
    return 'Файл \"$fileName\" загружен.\n$count файл(ов) готово к установке.';
  }

  @override
  String get statusSelectionCancelled =>
      'Выбор отменен.\nВыберите новый мод для установки.';

  @override
  String get statusUpdateComplete => 'Обновление завершено.';

  @override
  String get statusInstallationComplete => 'Установка завершена.';

  @override
  String statusError(Object error) {
    return 'Ошибка: $error';
  }

  @override
  String get dialogTitle7zip => 'Требуется 7-Zip';

  @override
  String get dialogContent7zip =>
      'Для распаковки этого файла приложению требуется 7-Zip.\n\nПожалуйста, установите его с официального сайта и нажмите \"Подтвердить\".';

  @override
  String get dialogContent7zipNotFound =>
      '7-Zip еще не обнаружен.\nУбедитесь, что он установлен по пути по умолчанию, и попробуйте снова.';

  @override
  String get dialogTitleCNSUpdate => 'Обнаружено обновление основной системы';

  @override
  String get dialogContentCNSUpdate =>
      'Обнаружено обновление для \"Custom Nanosuit System\".\n\nЭто заменит файлы в основной папке игры (StellarBlade\\SB).\nЖелаете продолжить?';

  @override
  String get dialogTitleMultipleJsons => 'Обнаружено несколько файлов .json';

  @override
  String dialogContentMultipleJsons(Object count) {
    return 'Обнаружено $count файлов .json.\nЭто может быть мод с несколькими компонентами.\n\nВы хотите установить их все вместе в одну папку мода?';
  }

  @override
  String get dialogTitleModExists => 'Мод уже существует';

  @override
  String dialogContentModExists(Object modName) {
    return 'Мод с именем \"$modName\" уже установлен.\n\nХотите обновить его?\nСтарые файлы будут удалены перед установкой новых.';
  }

  @override
  String dialogContentModUpdate(Object newModName, Object oldModName) {
    return 'Найдена более старая версия \'$oldModName\'.\n\nХотите удалить ее и обновиться до \'$newModName\'?';
  }

  @override
  String get dialogTitleDeleteMod => 'Удалить навсегда?';

  @override
  String dialogContentDeleteMod(Object modName) {
    return 'Вы собираетесь навсегда удалить мод \"$modName\".\nЭто действие нельзя отменить.\n\nВы уверены?';
  }

  @override
  String get dialogActionCancel => 'Отмена';

  @override
  String get dialogActionGoToDownload => 'Перейти на страницу загрузки';

  @override
  String get dialogActionConfirmInstallation => 'Подтвердить установку';

  @override
  String get dialogActionUpdateSystem => 'Обновить систему';

  @override
  String get dialogActionInstallAnyway => 'Все равно установить';

  @override
  String get dialogActionUpdate => 'Обновить';

  @override
  String get dialogActionDelete => 'Удалить';

  @override
  String get dialogActionClose => 'Закрыть';

  @override
  String snackBarBatchInstallComplete(Object failedCount, Object successCount) {
    return 'Пакетная установка завершена.\nУспешно: $successCount, Ошибок: $failedCount.';
  }

  @override
  String snackBarModInstalled(Object modName) {
    return 'Мод \"$modName\" успешно установлен.';
  }

  @override
  String snackBarModEnabled(Object modName) {
    return 'Мод \"$modName\" включен.';
  }

  @override
  String snackBarModDisabled(Object modName) {
    return 'Мод \"$modName\" отключен.';
  }

  @override
  String snackBarModDeleted(Object modName) {
    return 'Мод \"$modName\" навсегда удален.';
  }

  @override
  String get snackBarCNSUpdated => 'Custom Nanosuit System успешно обновлена.';

  @override
  String get dropTargetOverlay => 'Перетащите моды сюда';

  @override
  String get pathSelectionTitle => 'Путь к Stellar Blade не найден';

  @override
  String get pathSelectionButtonManual => 'Выбрать папку игры вручную';

  @override
  String get pathSelectionButtonRetry => 'Попробовать снова';

  @override
  String errorFolderSelection(Object error) {
    return 'Ошибка выбора папки: $error';
  }

  @override
  String errorFileSelection(Object error) {
    return 'Ошибка выбора файлов: $error';
  }

  @override
  String errorDecompressing(Object error) {
    return 'Ошибка распаковки файла: $error';
  }

  @override
  String errorProcessingArchive(Object error) {
    return 'Ошибка обработки файла: $error';
  }

  @override
  String errorUnsupportedFormat(Object extension) {
    return 'Неподдерживаемый формат файла: $extension';
  }

  @override
  String get error7zipRequired => 'Операция отменена: требуется 7-Zip.';

  @override
  String get errorGamePathUndefined => 'Путь к игре не определен.';

  @override
  String get errorDestinationNotFound => 'Папка назначения игры не существует.';

  @override
  String errorUpdateSystem(Object error) {
    return 'Ошибка обновления системы: $error';
  }

  @override
  String get errorInstallNoSelection => 'Вы ничего не выбрали для установки.';

  @override
  String get errorInstallModExists => 'Установка отменена: Мод уже существует.';

  @override
  String get errorNoJsonFound =>
      'Каждый мод должен содержать хотя бы один файл .json.';

  @override
  String errorInvalidJsonFormat(Object fileName) {
    return 'Файл $fileName имеет неверный формат JSON.';
  }

  @override
  String errorNoDisplayName(Object fileName) {
    return 'Файл $fileName не является модом Custom Nanosuit System (отсутствует \"DisplayName\").';
  }

  @override
  String get errorNoValidDisplayName =>
      'В файлах .json не найдено действительного \"DisplayName\".';

  @override
  String errorEnableMod(Object error) {
    return 'Ошибка включения мода: $error';
  }

  @override
  String errorDisableMod(Object error) {
    return 'Ошибка отключения мода: $error';
  }

  @override
  String errorDeleteMod(Object error) {
    return 'Ошибка удаления мода: $error';
  }

  @override
  String errorOpenFolder(Object path) {
    return 'Не удалось открыть папку: $path';
  }

  @override
  String get statusUpdateSystemCancelled => 'Обновление системы отменено.';

  @override
  String get statusUpdatingCNS => 'Обновление Custom Nanosuit System...';

  @override
  String statusExtractingFile(Object fileName) {
    return 'Извлечение $fileName...';
  }

  @override
  String get statusInstallationCancelledByUser =>
      'Установка отменена пользователем.';

  @override
  String get errorNoCompatibleFilesInFolder =>
      'Выбранная папка не содержит совместимых файлов мода.';

  @override
  String get errorNoCompatibleFilesInArchive =>
      'Сжатый файл не содержит совместимых файлов мода.';

  @override
  String get errorNoJsonInSelection =>
      'Выбор не содержит действительного файла .json мода.';

  @override
  String get aboutTitle => 'О CNS Control Center';

  @override
  String get aboutContent =>
      'Это приложение - менеджер модов для Stellar Blade, разработанный для работы с Custom Nanosuit System (CNS).\n\nТребование: Для полной функциональности с файлами .rar и .7z на вашей системе должен быть установлен 7-Zip.';

  @override
  String get aboutLinkText => 'Посетить профиль моего создателя';

  @override
  String get creatorProfileUrl =>
      'https://www.nexusmods.com/users/your-user-id';

  @override
  String aboutVersion(Object version) {
    return 'Версия: $version';
  }

  @override
  String get openModsFolder => 'Открыть папку модов';

  @override
  String get openInNexusMods => 'Открыть в Nexus Mods';

  @override
  String get checkForUpdates => 'Проверить обновления';

  @override
  String updateAvailable(Object version) {
    return 'Доступно обновление: v$version';
  }

  @override
  String get dialogTitleApiKey => 'API-ключ Nexus Mods';

  @override
  String get dialogContentApiKey =>
      'Для проверки обновлений модов вам нужен личный API-ключ от Nexus Mods.\nВы можете сгенерировать его в настройках своего профиля на их веб-сайте.';

  @override
  String get apiKey => 'API-ключ';

  @override
  String get dialogActionSave => 'Сохранить';

  @override
  String get snackBarApiKeySaved => 'API-ключ успешно сохранен.';

  @override
  String get errorApiKeyMissing =>
      'API-ключ Nexus Mods не настроен.\nПожалуйста, добавьте его в настройках.';

  @override
  String get statusCheckingUpdates => 'Проверка обновлений модов...';

  @override
  String statusUpdatesFound(Object count) {
    return 'Найдено $count обновление(й)!';
  }

  @override
  String get statusNoUpdates => 'Все моды обновлены.';

  @override
  String get selectModArchive => 'Выбрать архив мода';

  @override
  String get viewImageGallery => 'Просмотреть галерею изображений';

  @override
  String get imageGallery => 'Галерея изображений';

  @override
  String get noImagesFound => 'Изображения для этого мода не найдены.';

  @override
  String errorFetchingImages(Object error) {
    return 'Ошибка получения изображений: $error';
  }

  @override
  String get imageMod => 'Изображение мода';

  @override
  String get dialogContentUpdateOptions => 'Что бы вы хотели сделать?';

  @override
  String get dialogActionIgnoreVersion => 'Игнорировать версию';

  @override
  String get dialogActionGoToDownloadPage => 'Перейти к загрузке';

  @override
  String get installedMods => 'Установленные моды';

  @override
  String get filterBy => 'Фильтр:';

  @override
  String get sortBy => 'Сортировать по:';

  @override
  String get filterAll => 'Все';

  @override
  String get filterEnabled => 'Включенные';

  @override
  String get filterDisabled => 'Отключенные';

  @override
  String get sortByName => 'Имя';

  @override
  String get sortByDate => 'Дата';

  @override
  String get noModsFound => 'Моды не найдены.';

  @override
  String statusExtractingMultipleFiles(
    Object count,
    Object fileName,
    Object total,
  ) {
    return 'Извлечение $count из $total: $fileName';
  }

  @override
  String get previewInstallTitle => 'Моды для установки:';

  @override
  String get dialogTitleUE4SS => 'Обнаружена Установка UE4SS';

  @override
  String get dialogContentUE4SS =>
      'Обнаружен инструмент UE4SS. Хотите установить его в \'StellarBlade\\SB\\Binaries\\Win64\'?\n\nЭто необходимо для работы многих модов.';

  @override
  String get dialogActionInstallTool => 'Установить Инструмент';

  @override
  String get statusUE4SSInstallCancelled => 'Установка UE4SS отменена.';

  @override
  String get statusInstallingUE4SS => 'Установка UE4SS...';

  @override
  String get snackBarUE4SSInstalled => 'UE4SS успешно установлен.';

  @override
  String error7zipDecompression(Object error) {
    return 'Ошибка 7-Zip во время распаковки: $error';
  }

  @override
  String get statusUE4SSInstallComplete => 'Установка UE4SS завершена.';
}
