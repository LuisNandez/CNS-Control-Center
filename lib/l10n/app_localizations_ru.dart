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
  String get settings => 'Настройки';

  @override
  String get settingsGeneral => 'Общие';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsLanguageDesc => 'Выберите язык приложения';

  @override
  String get settingsAbout => 'О программе';

  @override
  String get settingsAboutDesc => 'Информация о приложении';

  @override
  String get settingsPathsAndTools => 'Пути и инструменты';

  @override
  String get settingsGameFolder => 'Папка с игрой';

  @override
  String get settingsGameFolderDesc =>
      'Корневая папка вашей установки Stellar Blade.';

  @override
  String get settings7zipPath => 'Путь к 7-Zip';

  @override
  String get settings7zipPathDesc =>
      'Расположение файла 7z.exe для извлечения модов.';

  @override
  String get settings7zipPathAuto => 'Автоматический поиск';

  @override
  String get settingsRepairMods => 'Восстановить устаревшие моды';

  @override
  String get settingsRepairModsDesc =>
      'Сканирует и создает информационные файлы для старых модов, используя локальную базу данных. Требуется ключ API.';

  @override
  String get settingsConnectivity => 'Подключение и обновления';

  @override
  String get settingsApiKey => 'Ключ API Nexus Mods';

  @override
  String get settingsApiKeyDesc => 'Требуется для проверки обновлений модов.';

  @override
  String get settingsApiKeySet => 'Установлен';

  @override
  String get settingsApiKeyNotSet => 'Не установлен';

  @override
  String get settingsSkippedVersions => 'Управление пропущенными версиями';

  @override
  String get settingsSkippedVersionsDesc =>
      'Управляйте версиями модов, которые вы решили пропустить.';

  @override
  String settingsSkippedVersionsCount(Object count) {
    return '$count пропущенных версий';
  }

  @override
  String get dialogTitleSkippedVersions => 'Пропущенные версии модов';

  @override
  String get dialogNoSkippedVersions => 'У вас нет пропущенных версий модов.';

  @override
  String get dialogSkippedVersions => 'Пропущенная версия';

  @override
  String get dialogTitleRepairMods =>
      'Запустить восстановление устаревших модов?';

  @override
  String get dialogContentRepairMods =>
      'Внимание: Эта функция находится в разработке и может работать неидеально.\n\nОна просканирует моды без файла \'nexus_info.json\' и, если найдет их в вашей локальной базе данных, создаст для них этот файл. Также будет предпринята попытка переименовать папку мода, чтобы включить найденную версию (например, \'My Mod\' -> \'My Mod v1.2\').\n\nПриоритет версии:\n1. Из названия папки.\n2. Из поля описания мода.\n3. Из последней версии на Nexus Mods (требуется API).\n\nВы хотите продолжить?';

  @override
  String get dialogActionRunRepair => 'Запустить восстановление';

  @override
  String get snackBarGamePathInvalid =>
      'Выбранная папка не является действительной папкой с игрой.';

  @override
  String get snackBar7zipPathInvalid =>
      'Выбранный файл должен называться 7z.exe.';

  @override
  String get snackBarRepairStarted =>
      'Процесс восстановления устаревших модов запущен...';

  @override
  String snackBarRepairComplete(Object count) {
    return 'Восстановление завершено. Обновлено $count мод(ов).';
  }

  @override
  String get snackBarRepairNoMods =>
      'Устаревшие моды, требующие восстановления, не найдены.';

  @override
  String get errorApiRequiredForRepair =>
      'Ключ API необходим для поиска последней версии модов без локальной версии.';

  @override
  String get installNewMod => 'Установить мод';

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
    return 'Папка \"$folderName\" выбрана. Готово к установке.';
  }

  @override
  String statusArchiveLoaded(Object count, Object fileName) {
    return 'Файл \"$fileName\" загружен. $count файл(ов) готово к установке.';
  }

  @override
  String get statusSelectionCancelled =>
      'Выбор отменен. Выберите новый мод для установки.';

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
      'Для распаковки этого файла приложению требуется 7-Zip.\n\nПожалуйста, установите его с официального сайта, а затем нажмите \"Подтвердить\".';

  @override
  String get dialogContent7zipNotFound =>
      '7-Zip еще не обнаружен. Убедитесь, что он установлен по стандартному пути, и попробуйте снова.';

  @override
  String get dialogTitleMultipleJsons => 'Обнаружено несколько файлов .json';

  @override
  String dialogContentMultipleJsons(Object count) {
    return 'Обнаружено $count .json файлов. Это может быть мод с несколькими компонентами.\n\nХотите установить их все вместе в одну папку мода?';
  }

  @override
  String get dialogTitleModExists => 'Мод уже существует';

  @override
  String dialogContentModExists(Object modName) {
    return 'Мод с названием \"$modName\" уже установлен.\n\nХотите его обновить? Старые файлы будут удалены перед установкой новых.';
  }

  @override
  String dialogContentModUpdate(Object newModName, Object oldModName) {
    return 'Найдена старая версия \'$oldModName\'.\n\nХотите удалить ее и обновиться до \'$newModName\'?';
  }

  @override
  String get dialogTitleDeleteMod => 'Удалить навсегда?';

  @override
  String dialogContentDeleteMod(Object modName) {
    return 'Вы собираетесь навсегда удалить мод \"$modName\". Это действие нельзя отменить.\n\nВы уверены?';
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
  String get dialogActionDelete => 'Удалить';

  @override
  String get dialogActionClose => 'Закрыть';

  @override
  String snackBarBatchInstallComplete(Object failedCount, Object successCount) {
    return 'Пакетная установка завершена. Успешно: $successCount, Неудачно: $failedCount.';
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
    return 'Мод \"$modName\" удален навсегда.';
  }

  @override
  String get snackBarCNSUpdated => 'Custom Nanosuit System успешно обновлена.';

  @override
  String get snackBarApiKeySaved => 'Ключ API успешно сохранен.';

  @override
  String get snackBarGamePathSaved => 'Путь к игре успешно сохранен.';

  @override
  String get snackBar7zipPathSaved => 'Путь к 7-Zip успешно сохранен.';

  @override
  String get snackBarSkippedVersionRemoved => 'Пропущенная версия удалена.';

  @override
  String get dropTargetOverlay => 'Перетащите моды сюда';

  @override
  String get pathSelectionTitle => 'Путь к Stellar Blade не найден';

  @override
  String get pathSelectionButtonManual => 'Выбрать папку с игрой вручную';

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
  String get errorInstallModExists => 'Установка отменена: мод уже существует.';

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
      'Выбор не содержит действительного .json файла мода.';

  @override
  String get aboutTitle => 'О Центре управления CNS';

  @override
  String get aboutContent =>
      'Это приложение - менеджер модов для Stellar Blade, разработанный для работы с Custom Nanosuit System (CNS).\n\nТребование: Для полной функциональности с файлами .rar и .7z на вашей системе должен быть установлен 7-Zip.';

  @override
  String get aboutLinkText => 'Посетите мой профиль создателя';

  @override
  String get creatorProfileUrl =>
      'https://next.nexusmods.com/profile/LuisNandez?gameId=7804';

  @override
  String aboutVersion(Object version) {
    return 'Версия: $version';
  }

  @override
  String get openModsFolder => 'Открыть папку с модами';

  @override
  String get openInNexusMods => 'Открыть в Nexus Mods';

  @override
  String get checkForUpdates => 'Проверить обновления';

  @override
  String updateAvailable(Object version) {
    return 'Доступно обновление: v$version';
  }

  @override
  String get dialogTitleApiKey => 'Ключ API Nexus Mods';

  @override
  String get dialogContentApiKey =>
      'Для проверки обновлений модов вам нужен личный ключ API от Nexus Mods.';

  @override
  String get dialogContentApiKeyInstructions =>
      '1. Перейдите на Nexus Mods и войдите в систему.\n2. Нажмите на свой аватар и перейдите в \'Настройки сайта\'.\n3. Перейдите на вкладку \'API\'.\n4. Нажмите \'Сгенерировать новый ключ API\'.\n5. Скопируйте ключ и вставьте его сюда.';

  @override
  String get apiKey => 'Ключ API';

  @override
  String get apiKeyHintText => 'Вставьте ваш ключ API сюда';

  @override
  String get dialogActionSave => 'Сохранить';

  @override
  String get apiKeyRemoved => 'Ключ API удален.';

  @override
  String get invalidApiKeyError => 'Неверный ключ API.';

  @override
  String get validatingApiKey => 'Проверка...';

  @override
  String get errorApiKeyMissing =>
      'Ключ API Nexus Mods не настроен. Пожалуйста, добавьте его через значок ключа в верхней панели.';

  @override
  String get statusCheckingUpdates => 'Проверка обновлений модов...';

  @override
  String statusUpdatesFound(Object count) {
    return 'Найдено $count обновлений!';
  }

  @override
  String get statusNoUpdates => 'Все моды обновлены до последней версии.';

  @override
  String get selectModArchive => 'Выбрать архив мода';

  @override
  String get viewImageGallery => 'Просмотр галереи изображений';

  @override
  String get imageGallery => 'Галерея изображений';

  @override
  String get noImagesFound =>
      'Изображения для этого мода не найдены, или ключ API не был введен. Пожалуйста, введите ключ API и проверьте обновления после этого.';

  @override
  String errorFetchingImages(Object error) {
    return 'Ошибка при загрузке изображений: $error';
  }

  @override
  String get imageMod => 'Изображение мода';

  @override
  String get modEnabledBadge => 'Включен';

  @override
  String get modDisabledBadge => 'Отключен';

  @override
  String get modCategoryOther => 'Не указано';

  @override
  String get dialogContentUpdateOptions => 'Что бы вы хотели сделать?';

  @override
  String get dialogActionIgnoreVersion => 'Игнорировать';

  @override
  String get dialogActionSkipVersion => 'Пропустить версию';

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
  String get filterRepaired => 'Восстановленные';

  @override
  String get sortByName => 'Имя';

  @override
  String get sortByDate => 'Дата';

  @override
  String get noModsFound => 'Моды не найдены.';

  @override
  String get viewTypeGrid => 'Вид сеткой';

  @override
  String get viewTypeList => 'Вид списком';

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
  String get dialogTitleUE4SS => 'Обнаружена установка UE4SS';

  @override
  String get dialogContentUE4SS =>
      'Обнаружен инструмент UE4SS. Хотите установить его в \'StellarBlade\\SB\\Binaries\\Win64\'?\n\nЭто необходимо для работы многих модов.';

  @override
  String get dialogActionInstallTool => 'Установить инструмент';

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

  @override
  String get dialogTitleAlternativeVersion =>
      'Обнаружена альтернативная версия';

  @override
  String dialogContentAlternativeVersion(
    String oldModName,
    String baseModName,
    String newModName,
  ) {
    return 'Альтернативная версия этого мода уже установлена: \'$oldModName\'.\n\nВы собираетесь установить другую альтернативу под названием \'$newModName\'.';
  }

  @override
  String get dialogActionReplace => 'Заменить';

  @override
  String get dialogActionInstallAsNew => 'Установить как новый';

  @override
  String get dialogTitleUpdate => 'Доступно обновление';

  @override
  String dialogContentUpdate(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return 'Вы собираетесь обновить мод \'$modName\'.\n\nУстановленная версия: $oldVersion\nНовая версия: $newVersion';
  }

  @override
  String get dialogTitleDowngrade => 'Обнаружена более старая версия';

  @override
  String dialogContentDowngrade(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return 'Внимание: вы собираетесь установить более старую версию мода \'$modName\'.\n\nУстановленная версия: $oldVersion\nВерсия для установки: $newVersion';
  }

  @override
  String get dialogTitleReinstall => 'Переустановить мод';

  @override
  String dialogContentReinstall(Object modName, Object version) {
    return 'Вы собираетесь переустановить версию \'$version\' мода \'$modName\'.';
  }

  @override
  String get dialogActionReinstall => 'Переустановить';

  @override
  String get editModNameTooltip => 'Редактировать имя мода';

  @override
  String get setCoverTooltip =>
      'Установить пользовательское изображение обложки';

  @override
  String get setCoverText => 'Установить обложку';

  @override
  String get restoreOriginalCoverText => 'Восстановить исходную обложку';

  @override
  String errorSavingCoverText(Object error) {
    return 'Ошибка сохранения изображения обложки: $error';
  }

  @override
  String errorRestoringCoverText(Object error) {
    return 'Ошибка восстановления исходного изображения обложки: $error';
  }

  @override
  String get editVersionText => 'Редактировать версию';

  @override
  String get customVersionText => 'Пользовательская версия';

  @override
  String get editTagText => 'Редактировать тег';

  @override
  String get customTagText => 'Пользовательский тег';

  @override
  String get dialogTitleEditModName => 'Редактировать имя мода';

  @override
  String get dialogActionResetToDefault => 'Сбросить по умолчанию';

  @override
  String get dialogLabelNewName => 'Новое имя';

  @override
  String errorModNameExists(Object modName) {
    return 'Мод с именем \"$modName\" уже существует.';
  }

  @override
  String get dialogTitleRepairedModWarning =>
      'Предупреждение о восстановленном моде';

  @override
  String get dialogContentRepairedModWarning =>
      'Этот мод может не содержать правильной информации о версии. Рекомендуется переустановить последнюю версию для обеспечения совместимости.';

  @override
  String get repairedModTooltip => 'Информация о восстановленном моде';

  @override
  String get disableAllModsTooltip => 'Отключить все моды';

  @override
  String get deleteAllModsTooltip => 'Удалить все отключенные моды';

  @override
  String get dialogTitleDisableAll => 'Отключить все моды?';

  @override
  String dialogContentDisableAll(int count) {
    return 'Вы уверены, что хотите отключить все $count включенных модов? Они будут перемещены в папку резервных копий.';
  }

  @override
  String get dialogTitleDeleteAll => 'Удалить отключенные моды?';

  @override
  String dialogContentDeleteAll(int count) {
    return 'Вы собираетесь навсегда удалить все $count отключенных модов. Это действие нельзя отменить.\n\nВы уверены?';
  }

  @override
  String snackBarAllModsDisabled(int count) {
    return 'Все $count включенных модов были отключены.';
  }

  @override
  String snackBarAllModsDeleted(int count) {
    return 'Все $count отключенных модов были удалены навсегда.';
  }

  @override
  String get snackBarNoModsToDisable => 'Нет включенных модов для отключения.';

  @override
  String get snackBarNoModsToDelete => 'Нет отключенных модов для удаления.';

  @override
  String get enableAllModsTooltip => 'Включить все моды';

  @override
  String get dialogTitleEnableAll => 'Включить все моды?';

  @override
  String dialogContentEnableAll(int count) {
    return 'Вы уверены, что хотите включить все $count отключенных модов? Они будут перемещены в основную папку модов.';
  }

  @override
  String snackBarAllModsEnabled(int count) {
    return 'Все $count отключенных модов были включены.';
  }

  @override
  String get snackBarNoModsToEnable => 'Нет отключенных модов для включения.';

  @override
  String get editNotes => 'Редактировать заметки';

  @override
  String get notesHintText => 'Добавьте свои личные заметки здесь...';

  @override
  String get modAuthor => 'Автор';

  @override
  String get modSummary => 'Summary';

  @override
  String get modDescription => 'Описание';

  @override
  String get noDescriptionAvailable => 'Описание отсутствует.';

  @override
  String get personalNotes => 'Личные заметки';

  @override
  String get noNotesAvailable => 'Заметок пока нет.';

  @override
  String get modDetailsTitle => 'Детали мода';

  @override
  String get modVersion => 'Версия';

  @override
  String get modCategory => 'Категория';

  @override
  String get dialogTitleAddUrl => 'Добавить ссылку на мод';

  @override
  String get dialogLabelUrl => 'URL мода';

  @override
  String get errorInvalidUrl => 'Пожалуйста, введите действительный URL.';

  @override
  String get addLinkTooltip => 'Добавить ссылку для скачивания этого мода';

  @override
  String get addLinkButtonText => 'Добавить ссылку';

  @override
  String get openLinkButtonText => 'Открыть ссылку';

  @override
  String get editModTitle => 'Редактировать детали мода';

  @override
  String get modNameLabel => 'Имя мода';

  @override
  String get authorLabel => 'Автор';

  @override
  String get summaryLabel => 'Описание / Сводка';

  @override
  String get notesLabel => 'Личные заметки';

  @override
  String get urlLabel => 'URL для скачивания';

  @override
  String get changeCoverButton => 'Изменить изображение обложки';

  @override
  String get editButtonTooltip => 'Редактировать мод';

  @override
  String get errorSavingNotes => 'Ошибка сохранения заметок';

  @override
  String get errorSavingUrl => 'Ошибка сохранения URL';

  @override
  String get errorSavingChanges => 'Ошибка сохранения изменений';

  @override
  String get errorTranslation => 'Не удалось перевести описание';

  @override
  String get translateSummary => 'Translate summary';

  @override
  String get translateDescription => 'Перевести описание';

  @override
  String get dialogTitleUE4SSReinstall => 'Переустановить UE4SS';

  @override
  String get dialogContentUE4SSReinstall =>
      'UE4SS, похоже, уже установлен. Хотите перезаписать существующую установку? Это может быть полезно, если вы подозреваете повреждение файлов.';

  @override
  String get dialogTitleCNSReinstall => 'Переустановить систему CNS';

  @override
  String get dialogContentCNSReinstall =>
      'Основная система CNS, похоже, уже установлена. Хотите переустановить ее? Ваши существующие моды не будут затронуты.';

  @override
  String dialogTitleUninstall(Object componentName) {
    return 'Удалить $componentName';
  }

  @override
  String dialogContentUninstall(Object componentName) {
    return 'Вы уверены, что хотите удалить $componentName? Это действие удалит основные файлы компонента, но не затронет ваши установленные моды.';
  }

  @override
  String get dialogActionUninstall => 'Да, удалить';

  @override
  String statusUninstalling(Object componentName) {
    return 'Удаление $componentName...';
  }

  @override
  String snackBarUninstalled(Object componentName) {
    return '$componentName успешно удален';
  }

  @override
  String errorUninstalling(Object componentName) {
    return 'Ошибка удаления $componentName';
  }

  @override
  String get settingsCoreComponents => 'Основные компоненты';

  @override
  String get installedStatus => 'Установлено';

  @override
  String get notInstalledStatus => 'Не обнаружено';

  @override
  String get uninstallButton => 'Удалить';

  @override
  String get cnsCoreSystem => 'Custom Nanosuit System';

  @override
  String get ue4ssInstallationDetected =>
      'Обнаружена и принята существующая установка UE4SS';

  @override
  String get cnsInstallationDetected =>
      'Обнаружена и принята существующая основная установка CNS';

  @override
  String get ue4ssRequiredTitle => 'Требуется UE4SS';

  @override
  String get ue4ssRequiredContent =>
      'Чтобы установить основную систему CNS, сначала необходимо установить UE4SS. Вы можете скачать его по следующей ссылке:';

  @override
  String get uninstallDependencyTitle => 'Обнаружена зависимость';

  @override
  String get uninstallDependencyContent =>
      'Вы должны удалить основную систему CNS, прежде чем сможете удалить UE4SS, так как CNS зависит от него.';

  @override
  String get dialogActionUnderstood => 'Понятно';

  @override
  String get appTitleNoCns => 'Custom Nanosuit System (Не установлено)';

  @override
  String get dialogTitleCNSUpdate => 'Обновить основную систему CNS';

  @override
  String dialogContentCNSUpdate(Object oldVersion, Object newVersion) {
    return 'Вы собираетесь обновить CNS с версии $oldVersion до новой версии $newVersion. Хотите продолжить?';
  }

  @override
  String get dialogTitleCNSDowngrade => 'Понизить версию CNS';

  @override
  String dialogContentCNSDowngrade(Object oldVersion, Object newVersion) {
    return 'Внимание! Вы собираетесь установить более старую версию CNS ($newVersion), чем ваша текущая ($oldVersion). Это может вызвать проблемы. Вы уверены?';
  }

  @override
  String dialogContentCNSReinstallVersion(Object version) {
    return 'У вас уже установлена версия $version CNS. Хотите все равно переустановить файлы?';
  }

  @override
  String get dialogActionUpdate => 'Обновить';

  @override
  String get dialogActionDowngrade => 'Понизить';

  @override
  String get dialogTitleCNSInstall => 'Установить основную систему CNS';

  @override
  String get dialogContentCNSInstall =>
      'Вы собираетесь установить базовую систему Custom Nanosuit System (CNS). Это необходимо для работы модов CNS. Хотите продолжить?';

  @override
  String get dialogActionInstall => 'Установить';

  @override
  String get settingsDeveloperOptions => 'Опции разработчика';

  @override
  String get devDeleteNexusInfoTitle => 'Удалить все файлы nexus_info.json';

  @override
  String get devDeleteNexusInfoDesc =>
      'Удаляет все файлы метаданных менеджера из каждого мода. Это полезно для принудительного полного восстановления.';

  @override
  String get devExtractIdsTitle => 'Извлечь идентификаторы';

  @override
  String get devExtractIdsDesc =>
      'Создает на вашем рабочем столе файл с именем \'ID Mods.json\', содержащий displayName и nexusId каждого мода.';

  @override
  String get devConfirmDeleteTitle => 'Подтвердить удаление';

  @override
  String get devConfirmDeleteDesc =>
      'Вы уверены, что хотите навсегда удалить все файлы nexus_info.json? Это приведет к удалению всех пользовательских имен, обложек и метаданных. Это действие нельзя отменить.';

  @override
  String get devDeleteSuccessTitle => 'Удаление завершено';

  @override
  String devDeleteSuccessDesc(Object count) {
    return 'Успешно удалено $count файлов nexus_info.json.';
  }

  @override
  String get devConfirmExtractTitle => 'Подтвердить извлечение';

  @override
  String get devConfirmExtractDesc =>
      'Это просканирует все ваши моды и создаст \'ID Mods.json\' на вашем рабочем столе. Это перезапишет любой существующий файл с тем же именем. Хотите продолжить?';

  @override
  String get devExtractAction => 'Извлечь';

  @override
  String get devExtractNoData =>
      'Не найдено модов с действительными идентификаторами для извлечения.';

  @override
  String get devExtractDesktopNotFound =>
      'Ошибка: Не удалось найти каталог рабочего стола.';

  @override
  String get devExtractSuccessTitle => 'Извлечение завершено';

  @override
  String devExtractSuccessDesc(Object path) {
    return 'Файл успешно создан по адресу: $path';
  }

  @override
  String get errorDialogTitle => 'Произошла ошибка';

  @override
  String get modDetailsCategory => 'Категория';

  @override
  String get modDetailsAuthor => 'Автор';

  @override
  String get modDetailsNexusId => 'Nexus ID';

  @override
  String get modDetailsInstalledOn => 'Установлено';

  @override
  String get unknownAuthor => 'Неизвестен';

  @override
  String get statusInstalling => 'Установка...';

  @override
  String statusInstallingMod(int index, int total, String modName) {
    return 'Установка $index/$total: $modName';
  }

  @override
  String byText(Object author) {
    return 'от $author';
  }

  @override
  String get filterUpdatesAvailable => 'Доступны обновления';

  @override
  String snackBarUpdateIgnored(String modName) {
    return 'Обновление для \'$modName\' проигнорировано в этом сеансе.';
  }

  @override
  String snackBarVersionSkipped(String modName, String version) {
    return 'Версия \'$version\' для \'$modName\' будет пропущена при будущих проверках.';
  }

  @override
  String statusUpdatingMetadata(String displayName, int arg1, int arg2) {
    return 'Обновление метаданных для \'$displayName\' ($arg1 из $arg2)...';
  }

  @override
  String genericModInstallTitle(String modName) {
    return 'Установлен общий мод: $modName';
  }

  @override
  String genericModInstallDesc(String path) {
    return 'Установлено в $path.\nЭтот мод не управляется приложением и должен быть удален вручную.';
  }

  @override
  String genericModInstallError(String modName) {
    return 'Не удалось установить общий мод: $modName';
  }

  @override
  String get modTypeCNS => 'CNS';

  @override
  String get modTypeGeneric => 'Общий';

  @override
  String get modTypeMovies => 'Видео';

  @override
  String get replacesOutfitTitle => 'Заменяет костюм';

  @override
  String get replacesOutfitClearTooltip => 'Очистить выбор костюма';

  @override
  String get replacesOutfitSelectTooltip => 'Выбрать костюм для замены';

  @override
  String get replacesOutfitNone => 'Костюм не выбран.\nТег будет \'Общий\'.';

  @override
  String get replacesOutfitSearchHint => 'Поиск костюмов...';

  @override
  String get modTypeReplacement => 'Замена';

  @override
  String get replacesOutfitHover =>
      'Наведите курсор на костюм, чтобы увидеть предварительный просмотр.';

  @override
  String get dialogTitleOutfitReplacement => 'Замена костюма?';

  @override
  String dialogContentOutfitReplacement(String modName) {
    return 'Мод \'$modName\' является заменой костюма?\n\nВыберите \'Да\', чтобы указать, какой костюм он заменяет, или \'Нет\', чтобы установить его как общий мод.';
  }

  @override
  String get dialogActionNo => 'Нет';

  @override
  String get dialogActionYes => 'Да';

  @override
  String get dialogTitleOutfitConflict => 'Обнаружен конфликт костюмов';

  @override
  String dialogContentOutfitConflict(String outfitName, String modName) {
    return 'Костюм \'$outfitName\' уже заменяется модом \'$modName\'.\n\nХотите отключить \'$modName\' и активировать этот мод?';
  }

  @override
  String get dialogActionActivateAndDisable => 'Отключить и Активировать';

  @override
  String get replacementModSwitchTitle => 'Мод-замена';

  @override
  String get replacementModSwitchDesc =>
      'Отметьте, если этот мод предназначен для замены костюма в игре.';

  @override
  String get settingsShowModTagsTitle => 'Показывать теги типов модов';

  @override
  String get settingsShowModTagsDesc =>
      'Отображать теги типов модов (например, CNS, Общий) на каждой карточке мода в списке.';

  @override
  String get modTypeLogic => 'Логика';

  @override
  String get patcherStarted => '=== StellarBlade Dart Patcher Запущен ===';

  @override
  String workingDirectory(String path) {
    return 'Рабочий каталог: $path';
  }

  @override
  String modsDirNotFound(String path) {
    return 'Каталог ~mods не существует по адресу: $path';
  }

  @override
  String warnCannotScanFolder(String path) {
    return '\n  ВНИМАНИЕ: Не удалось просканировать папку $path. Пропуск.';
  }

  @override
  String errorDetails(String error) {
    return '  Ошибка: $error\n';
  }

  @override
  String foundUtocFiles(int count) {
    return 'Найдено $count файлов .utoc';
  }

  @override
  String get noModsFound2 => 'Моды для обработки не найдены.';

  @override
  String get patcherSummaryTitle =>
      '\n=== Сводка патчера (Необработанные данные) ===';

  @override
  String processedMods(int count) {
    return 'Обработано $count модов.';
  }

  @override
  String fixedContainerIdConflicts(int count) {
    return 'Исправлено $count конфликтов Container ID.';
  }

  @override
  String foundPackageIdConflicts(int count) {
    return 'Найдено $count конфликтов Package ID.';
  }

  @override
  String get fatalErrorTitle => '\n=== КРИТИЧЕСКАЯ ОШИБКА ===';

  @override
  String patcherServiceError(String error) {
    return 'Ошибка в PatcherService: $error';
  }

  @override
  String analyzingFile(String fileName) {
    return '--- Анализ: $fileName ---';
  }

  @override
  String get warnUcasNotFound => '  ВНИМАНИЕ: Файл .ucas не найден. Пропуск.';

  @override
  String get warnCorruptHeader =>
      '  ВНИМАНИЕ: Поврежденный заголовок, размер записи превышает размер файла. Пропуск.';

  @override
  String conflictContainerIdDetected(int id) {
    return '  ОБНАРУЖЕН КОНФЛИКТ Container ID: $id';
  }

  @override
  String generatingNewId(int id) {
    return '  Генерация нового ID: $id';
  }

  @override
  String get utocFilePatched => '  Файл .utoc пропатчен.';

  @override
  String get patchingUcasFile => '  Установка патча для файла .ucas...';

  @override
  String ucasReplacementsSuccess(int count) {
    return '  Успешные замены в .ucas: $count';
  }

  @override
  String get patchComplete => '  Патч завершен!';

  @override
  String idRegisteredNoConflict(int id) {
    return '  ID $id зарегистрирован. Конфликтов нет.';
  }

  @override
  String errorProcessingFile(String fileName, String error) {
    return '  ОШИБКА при обработке $fileName: $error';
  }

  @override
  String get statusRunningPatcher => 'Запуск патчера конфликтов...';

  @override
  String summarySuccessContainerIds(int count) {
    return '✅ Успешно! Исправлено $count конфликтов Container ID, вызывающих сбои.';
  }

  @override
  String get summaryNoContainerIdConflicts =>
      '✅ Конфликтов Container ID (сбоев) не обнаружено.';

  @override
  String get summaryNoPackageIdConflicts =>
      '✅ Отличные новости! Серьезных конфликтов Package ID (перезаписи) не обнаружено.';

  @override
  String summaryFoundPackageIdConflicts(int count) {
    return '⚠️ Внимание! Найдено $count групп модов, которые не могут сосуществовать:';
  }

  @override
  String summaryConflictGroupDetails(int count) {
    return '  • Эта группа модов конкурирует за $count файлов:';
  }

  @override
  String get patcherSummaryDialogTitle => 'Сводка патчера';

  @override
  String get dialogActionShowFullLog => 'Показать полный журнал';

  @override
  String get fullLogDialogTitle => 'Журнал патчера конфликтов (Dart)';

  @override
  String get runConflictPatcherTitle => 'Запустить патчер конфликтов';

  @override
  String get runConflictPatcherSubtitlePython =>
      'Исправляет сбои Container_Id и Package_Id';

  @override
  String get processingCover => 'Обработка обложки...';

  @override
  String get apiKeyTooltip =>
      'Ключ API требуется для интеллектуального извлечения Nexus ID.';

  @override
  String dialogTitleSpecialModSelection(String nexusId) {
    return 'Параметры установки - Мод $nexusId';
  }

  @override
  String get dialogContentSpecialModSelection =>
      'Выберите опции, которые вы хотите установить. Необходимые основные файлы будут установлены автоматически.';

  @override
  String get snackBarSpecialModNoSelection =>
      'Выберите хотя бы одну опцию для продолжения.';

  @override
  String get dialogActionInstallSelection => 'Установить выбранное';
}
