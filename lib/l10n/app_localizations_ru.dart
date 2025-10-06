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
    return 'Пропущено версий: $count';
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
      'Внимание: Эта функция находится в разработке и может работать неидеально.\n\nОна просканирует моды без файла \'nexus_info.json\' и, если найдет их в вашей локальной базе данных, создаст для них этот файл. Также будет предпринята попытка переименовать папку мода, чтобы включить найденную версию (например, \'Мой Мод\' -> \'Мой Мод v1.2\').\n\nПриоритет версии:\n1. Из имени папки.\n2. Из поля описания мода.\n3. Из последней версии на Nexus Mods (требуется API).\n\nПродолжить?';

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
    return 'Восстановление завершено. Обновлено модов: $count.';
  }

  @override
  String get snackBarRepairNoMods =>
      'Не найдено устаревших модов, требующих восстановления.';

  @override
  String get errorApiRequiredForRepair =>
      'Ключ API требуется для поиска последней версии модов без локальной версии.';

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
    return 'Включено модов: $enabledCount, отключено: $disabledCount.';
  }

  @override
  String statusErrorReadingMods(Object error) {
    return 'Ошибка чтения установленных модов: $error';
  }

  @override
  String statusFilesSelected(Object count) {
    return 'Выбрано файлов: $count. Готово к установке.';
  }

  @override
  String statusFolderSelected(Object folderName) {
    return 'Папка \"$folderName\" выбрана. Готова к установке.';
  }

  @override
  String statusArchiveLoaded(Object count, Object fileName) {
    return 'Файл \"$fileName\" загружен. Готово к установке файлов: $count.';
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
      'Для распаковки этого файла приложению требуется 7-Zip.\n\nПожалуйста, установите его с официального сайта и нажмите \"Подтвердить\".';

  @override
  String get dialogContent7zipNotFound =>
      '7-Zip не был обнаружен. Убедитесь, что он установлен в стандартную директорию, и попробуйте снова.';

  @override
  String get dialogTitleCNSUpdate => 'Обнаружено обновление основной системы';

  @override
  String get dialogContentCNSUpdate =>
      'Обнаружено обновление для \"Пользовательской системы нанокостюма\".\n\nЭто приведет к замене файлов в основной папке игры (StellarBlade\\SB). Продолжить?';

  @override
  String get dialogTitleMultipleJsons => 'Обнаружено несколько .json файлов';

  @override
  String dialogContentMultipleJsons(Object count) {
    return 'Обнаружено $count .json файлов. Это может быть мод с несколькими компонентами.\n\nВы хотите установить их все вместе в одну папку мода?';
  }

  @override
  String get dialogTitleModExists => 'Мод уже существует';

  @override
  String dialogContentModExists(Object modName) {
    return 'Мод с именем \"$modName\" уже установлен.\n\nХотите обновить его? Старые файлы будут удалены перед установкой новых.';
  }

  @override
  String dialogContentModUpdate(Object newModName, Object oldModName) {
    return 'Найдена более старая версия \'$oldModName\'.\n\nХотите удалить ее и обновиться до \'$newModName\'?';
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
  String get dialogActionUpdate => 'Обновить';

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
  String get snackBarCNSUpdated =>
      'Пользовательская система нанокостюма успешно обновлена.';

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
      'Каждый мод должен содержать хотя бы один .json файл.';

  @override
  String errorInvalidJsonFormat(Object fileName) {
    return 'Файл $fileName имеет неверный формат JSON.';
  }

  @override
  String errorNoDisplayName(Object fileName) {
    return 'Файл $fileName не является модом для Custom Nanosuit System (отсутствует \"DisplayName\").';
  }

  @override
  String get errorNoValidDisplayName =>
      'В .json файлах не найдено действительного \"DisplayName\".';

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
  String get statusUpdatingCNS =>
      'Обновление Пользовательской системы нанокостюма...';

  @override
  String statusExtractingFile(Object fileName) {
    return 'Извлечение $fileName...';
  }

  @override
  String get statusInstallationCancelledByUser =>
      'Установка отменена пользователем.';

  @override
  String get errorNoCompatibleFilesInFolder =>
      'Выбранная папка не содержит совместимых файлов модов.';

  @override
  String get errorNoCompatibleFilesInArchive =>
      'Сжатый файл не содержит совместимых файлов модов.';

  @override
  String get errorNoJsonInSelection =>
      'Выбор не содержит действительного .json файла мода.';

  @override
  String get aboutTitle => 'О Центре управления CNS';

  @override
  String get aboutContent =>
      'Это приложение - менеджер модов для Stellar Blade, разработанный для работы с Пользовательской системой нанокостюма (CNS).\n\nТребование: Для полной функциональности с файлами .rar и .7z на вашей системе должен быть установлен 7-Zip.';

  @override
  String get aboutLinkText => 'Посетить мой профиль создателя';

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
      'Для проверки обновлений модов вам понадобится личный ключ API от Nexus Mods.';

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
      'Ключ API Nexus Mods не настроен. Пожалуйста, добавьте его через иконку ключа на верхней панели.';

  @override
  String get statusCheckingUpdates => 'Проверка обновлений модов...';

  @override
  String statusUpdatesFound(Object count) {
    return 'Найдено обновлений: $count!';
  }

  @override
  String get statusNoUpdates => 'Все моды обновлены.';

  @override
  String get selectModArchive => 'Выбрать архив с модом';

  @override
  String get viewImageGallery => 'Посмотреть изображение';

  @override
  String get imageGallery => 'Галерея изображений';

  @override
  String get noImagesFound =>
      'Для этого мода не найдено изображений, или ключ API не был введен. Пожалуйста, введите ключ API и проверьте обновления после этого.';

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
  String get dialogContentUpdateOptions => 'Что вы хотите сделать?';

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
    return 'Альтернативная версия этого мода уже установлена: \'$oldModName\'.\n\nВы собираетесь установить другую альтернативную версию с именем \'$newModName\'.';
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
    return 'Внимание: Вы собираетесь установить более старую версию мода \'$modName\'.\n\nУстановленная версия: $oldVersion\nУстанавливаемая версия: $newVersion';
  }

  @override
  String get dialogActionDowngrade => 'Понизить версию';

  @override
  String get dialogTitleReinstall => 'Переустановить мод';

  @override
  String dialogContentReinstall(Object modName, Object version) {
    return 'Вы собираетесь переустановить версию \'$version\' мода \'$modName\'.';
  }

  @override
  String get dialogActionReinstall => 'Переустановить';

  @override
  String get editModNameTooltip => 'Изменить имя мода';

  @override
  String get setCoverTooltip => 'Установить пользовательскую обложку';

  @override
  String get setCoverText => 'Установить обложку';

  @override
  String get restoreOriginalCoverText => 'Восстановить исходную обложку';

  @override
  String errorSavingCoverText(Object error) {
    return 'Ошибка сохранения обложки: $error';
  }

  @override
  String errorRestoringCoverText(Object error) {
    return 'Ошибка восстановления исходной обложки: $error';
  }

  @override
  String get editVersionText => 'Изменить версию';

  @override
  String get customVersionText => 'Пользовательская версия';

  @override
  String get editTagText => 'Изменить тег';

  @override
  String get customTagText => 'Пользовательский тег';

  @override
  String get dialogTitleEditModName => 'Изменить имя мода';

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
      'У этого мода может быть неверная информация о версии. Для обеспечения совместимости рекомендуется переустановить последнюю версию.';

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
    return 'Вы уверены, что хотите отключить все $count включенных модов? Они будут перемещены в резервную папку.';
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
    return 'Все $count отключенных модов были навсегда удалены.';
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
    return 'Вы уверены, что хотите включить все $count отключенных модов? Они будут перемещены в основную папку с модами.';
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
  String get modDescription => 'Описание';

  @override
  String get noDescriptionAvailable => 'Описание недоступно.';

  @override
  String get personalNotes => 'Личные заметки';

  @override
  String get noNotesAvailable => 'Заметок пока нет.';

  @override
  String get modDetailsTitle => 'Сведения о моде';

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
  String get editModTitle => 'Редактировать сведения о моде';

  @override
  String get modNameLabel => 'Название мода';

  @override
  String get authorLabel => 'Автор';

  @override
  String get summaryLabel => 'Описание / Сводка';

  @override
  String get notesLabel => 'Личные заметки';

  @override
  String get urlLabel => 'URL для скачивания';

  @override
  String get changeCoverButton => 'Изменить обложку';

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
  String get translateDescription => 'Перевести описание';
}
