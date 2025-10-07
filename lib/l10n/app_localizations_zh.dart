// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'CNS Control Center';

  @override
  String appTitleWithVersion(Object version) {
    return 'Custom Nanosuit System $version';
  }

  @override
  String get settings => '设置';

  @override
  String get settingsGeneral => '常规';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsLanguageDesc => '选择应用程序语言';

  @override
  String get settingsAbout => '关于';

  @override
  String get settingsAboutDesc => '有关应用程序的信息';

  @override
  String get settingsPathsAndTools => '路径和工具';

  @override
  String get settingsGameFolder => '游戏文件夹';

  @override
  String get settingsGameFolderDesc => '您的 Stellar Blade 安装的根文件夹。';

  @override
  String get settings7zipPath => '7-Zip 路径';

  @override
  String get settings7zipPathDesc => '用于提取模组的 7z.exe 文件的位置。';

  @override
  String get settings7zipPathAuto => '自动搜索';

  @override
  String get settingsRepairMods => '修复旧版模组';

  @override
  String get settingsRepairModsDesc => '使用本地数据库扫描并为旧模组创建信息文件。需要 API 密钥。';

  @override
  String get settingsConnectivity => '连接和更新';

  @override
  String get settingsApiKey => 'Nexus Mods API 密钥';

  @override
  String get settingsApiKeyDesc => '检查模组更新所必需。';

  @override
  String get settingsApiKeySet => '已设置';

  @override
  String get settingsApiKeyNotSet => '未设置';

  @override
  String get settingsSkippedVersions => '管理跳过的版本';

  @override
  String get settingsSkippedVersionsDesc => '管理您选择跳过的模组版本。';

  @override
  String settingsSkippedVersionsCount(Object count) {
    return '已跳过 $count 个版本';
  }

  @override
  String get dialogTitleSkippedVersions => '跳过的模组版本';

  @override
  String get dialogNoSkippedVersions => '您没有跳过任何模组版本。';

  @override
  String get dialogSkippedVersions => '跳过的版本';

  @override
  String get dialogTitleRepairMods => '运行旧版模组修复？';

  @override
  String get dialogContentRepairMods =>
      '警告：此功能正在开发中，可能不完美。\n\n它将扫描没有 \'nexus_info.json\' 文件的模组，如果在您的本地数据库中找到，将为它们创建一个。它还会尝试重命名模组的文件夹以包含找到的版本（例如，“我的模组” -> “我的模组 v1.2”）。\n\n版本优先级：\n1. 根据文件夹名称。\n2. 根据模组的描述字段。\n3. 根据 Nexus Mods 上的最新版本（需要 API）。\n\n您想继续吗？';

  @override
  String get dialogActionRunRepair => '运行修复';

  @override
  String get snackBarGamePathInvalid => '所选文件夹似乎不是有效的游戏文件夹。';

  @override
  String get snackBar7zipPathInvalid => '所选文件必须命名为 7z.exe。';

  @override
  String get snackBarRepairStarted => '旧版模组修复过程已开始...';

  @override
  String snackBarRepairComplete(Object count) {
    return '修复完成。$count 个模组已更新。';
  }

  @override
  String get snackBarRepairNoMods => '未找到需要修复的旧版模组。';

  @override
  String get errorApiRequiredForRepair => '需要 API 密钥才能为没有本地版本的模组查找最新版本。';

  @override
  String get installNewMod => '安装新模组';

  @override
  String get selectFiles => '选择文件';

  @override
  String get selectFolder => '选择文件夹';

  @override
  String get installSelectedMod => '安装所选模组';

  @override
  String get filesToInstall => '要安装的文件：';

  @override
  String get cancelSelection => '取消选择';

  @override
  String get searchMods => '搜索模组...';

  @override
  String get enabledMods => '已启用的模组';

  @override
  String get disabledMods => '已禁用的模组';

  @override
  String get refreshList => '刷新列表';

  @override
  String get noEnabledMods => '没有已启用的模组。';

  @override
  String get noDisabledMods => '没有已禁用的模组。';

  @override
  String get showInFolder => '在文件夹中显示';

  @override
  String get disableMod => '禁用模组';

  @override
  String get enableMod => '启用模组';

  @override
  String get deletePermanently => '永久删除';

  @override
  String get language => '语言';

  @override
  String get selectLanguage => '选择一种语言';

  @override
  String get statusSearchingGame => '正在搜索 Stellar Blade 安装...';

  @override
  String get statusGamePathFound => '游戏路径已找到！';

  @override
  String get statusGamePathNotFound => '无法自动找到游戏路径。';

  @override
  String statusErrorFindingGame(Object error) {
    return '搜索游戏时出错：$error';
  }

  @override
  String statusModsFound(Object disabledCount, Object enabledCount) {
    return '$enabledCount 个模组已启用，$disabledCount 个已禁用。';
  }

  @override
  String statusErrorReadingMods(Object error) {
    return '读取已安装的模组时出错：$error';
  }

  @override
  String statusFilesSelected(Object count) {
    return '已选择 $count 个文件。准备安装。';
  }

  @override
  String statusFolderSelected(Object folderName) {
    return '已选择文件夹“$folderName”。准备安装。';
  }

  @override
  String statusArchiveLoaded(Object count, Object fileName) {
    return '文件“$fileName”已加载。$count 个文件准备安装。';
  }

  @override
  String get statusSelectionCancelled => '选择已取消。请选择一个新模组进行安装。';

  @override
  String get statusUpdateComplete => '更新完成。';

  @override
  String get statusInstallationComplete => '安装完成。';

  @override
  String statusError(Object error) {
    return '错误：$error';
  }

  @override
  String get dialogTitle7zip => '需要 7-Zip';

  @override
  String get dialogContent7zip => '要解压缩此文件，应用程序需要 7-Zip。\n\n请从其官方页面安装，然后按“确认”。';

  @override
  String get dialogContent7zipNotFound => '尚未检测到 7-Zip。请确保它已安装在默认路径中，然后重试。';

  @override
  String get dialogTitleCNSUpdate => '检测到主系统更新';

  @override
  String get dialogContentCNSUpdate =>
      '检测到“自定义纳米服系统”的更新。\n\n这将替换主游戏文件夹（StellarBlade\\SB）中的文件。您希望继续吗？';

  @override
  String get dialogTitleMultipleJsons => '检测到多个 .json 文件';

  @override
  String dialogContentMultipleJsons(Object count) {
    return '检测到 $count 个 .json 文件。这可能是一个包含多个组件的模组。\n\n您想将它们全部安装在一个模组文件夹中吗？';
  }

  @override
  String get dialogTitleModExists => '模组已存在';

  @override
  String dialogContentModExists(Object modName) {
    return '名为“$modName”的模组已安装。\n\n您想更新它吗？旧文件将在安装新文件之前被删除。';
  }

  @override
  String dialogContentModUpdate(Object newModName, Object oldModName) {
    return '找到了一个旧版本“$oldModName”。\n\n您想移除它并更新到“$newModName”吗？';
  }

  @override
  String get dialogTitleDeleteMod => '永久删除？';

  @override
  String dialogContentDeleteMod(Object modName) {
    return '您将永久删除模组“$modName”。此操作无法撤销。\n\n您确定吗？';
  }

  @override
  String get dialogActionCancel => '取消';

  @override
  String get dialogActionGoToDownload => '转到下载页面';

  @override
  String get dialogActionConfirmInstallation => '确认安装';

  @override
  String get dialogActionUpdateSystem => '更新系统';

  @override
  String get dialogActionInstallAnyway => '仍然安装';

  @override
  String get dialogActionUpdate => '更新';

  @override
  String get dialogActionDelete => '删除';

  @override
  String get dialogActionClose => '关闭';

  @override
  String snackBarBatchInstallComplete(Object failedCount, Object successCount) {
    return '批量安装完成。成功：$successCount，失败：$failedCount。';
  }

  @override
  String snackBarModInstalled(Object modName) {
    return '模组“$modName”安装成功。';
  }

  @override
  String snackBarModEnabled(Object modName) {
    return '模组“$modName”已启用。';
  }

  @override
  String snackBarModDisabled(Object modName) {
    return '模组“$modName”已禁用。';
  }

  @override
  String snackBarModDeleted(Object modName) {
    return '模组“$modName”已永久删除。';
  }

  @override
  String get snackBarCNSUpdated => '自定义纳米服系统更新成功。';

  @override
  String get snackBarApiKeySaved => 'API 密钥保存成功。';

  @override
  String get snackBarGamePathSaved => '游戏路径保存成功。';

  @override
  String get snackBar7zipPathSaved => '7-Zip 路径保存成功。';

  @override
  String get snackBarSkippedVersionRemoved => '已跳过的版本已移除。';

  @override
  String get dropTargetOverlay => '将模组拖放到此处';

  @override
  String get pathSelectionTitle => '未找到 Stellar Blade 路径';

  @override
  String get pathSelectionButtonManual => '手动选择游戏文件夹';

  @override
  String get pathSelectionButtonRetry => '重试';

  @override
  String errorFolderSelection(Object error) {
    return '选择文件夹时出错：$error';
  }

  @override
  String errorFileSelection(Object error) {
    return '选择文件时出错：$error';
  }

  @override
  String errorDecompressing(Object error) {
    return '解压缩文件时出错：$error';
  }

  @override
  String errorProcessingArchive(Object error) {
    return '处理文件时出错：$error';
  }

  @override
  String errorUnsupportedFormat(Object extension) {
    return '不支持的文件格式：$extension';
  }

  @override
  String get error7zipRequired => '操作已取消：需要 7-Zip。';

  @override
  String get errorGamePathUndefined => '未定义游戏路径。';

  @override
  String get errorDestinationNotFound => '游戏的目标文件夹不存在。';

  @override
  String errorUpdateSystem(Object error) {
    return '更新系统时出错：$error';
  }

  @override
  String get errorInstallNoSelection => '您没有选择任何要安装的内容。';

  @override
  String get errorInstallModExists => '安装已取消：模组已存在。';

  @override
  String get errorNoJsonFound => '每个模组必须至少包含一个 .json 文件。';

  @override
  String errorInvalidJsonFormat(Object fileName) {
    return '文件 $fileName 的 JSON 格式无效。';
  }

  @override
  String errorNoDisplayName(Object fileName) {
    return '文件 $fileName 似乎不是自定义纳米服系统模组（缺少“DisplayName”）。';
  }

  @override
  String get errorNoValidDisplayName => '在 .json 文件中未找到有效的“DisplayName”。';

  @override
  String errorEnableMod(Object error) {
    return '启用模组时出错：$error';
  }

  @override
  String errorDisableMod(Object error) {
    return '禁用模组时出错：$error';
  }

  @override
  String errorDeleteMod(Object error) {
    return '删除模组时出错：$error';
  }

  @override
  String errorOpenFolder(Object path) {
    return '无法打开文件夹：$path';
  }

  @override
  String get statusUpdateSystemCancelled => '系统更新已取消。';

  @override
  String get statusUpdatingCNS => '正在更新自定义纳米服系统...';

  @override
  String statusExtractingFile(Object fileName) {
    return '正在提取 $fileName...';
  }

  @override
  String get statusInstallationCancelledByUser => '用户已取消安装。';

  @override
  String get errorNoCompatibleFilesInFolder => '所选文件夹不包含兼容的模组文件。';

  @override
  String get errorNoCompatibleFilesInArchive => '压缩文件不包含兼容的模组文件。';

  @override
  String get errorNoJsonInSelection => '所选内容不包含有效的模组 .json 文件。';

  @override
  String get aboutTitle => '关于 CNS 控制中心';

  @override
  String get aboutContent =>
      '此应用程序是 Stellar Blade 的模组管理器，旨在与自定义纳米服系统（CNS）配合使用。\n\n要求：要完全使用 .rar 和 .7z 文件的功能，您的系统必须安装 7-Zip。';

  @override
  String get aboutLinkText => '访问我的创作者个人资料';

  @override
  String get creatorProfileUrl =>
      'https://next.nexusmods.com/profile/LuisNandez?gameId=7804';

  @override
  String aboutVersion(Object version) {
    return '版本：$version';
  }

  @override
  String get openModsFolder => '打开模组文件夹';

  @override
  String get openInNexusMods => '在 Nexus Mods 中打开';

  @override
  String get checkForUpdates => '检查更新';

  @override
  String updateAvailable(Object version) {
    return '有可用更新：v$version';
  }

  @override
  String get dialogTitleApiKey => 'Nexus Mods API 密钥';

  @override
  String get dialogContentApiKey => '要检查模组更新，您需要一个来自 Nexus Mods 的个人 API 密钥。';

  @override
  String get dialogContentApiKeyInstructions =>
      '1. 前往 Nexus Mods 并登录。\n2. 单击您的头像并转到“网站偏好设置”。\n3. 转到“API”选项卡。\n4. 单击“生成新的 API 密钥”。\n5. 复制密钥并将其粘贴到此处。';

  @override
  String get apiKey => 'API 密钥';

  @override
  String get apiKeyHintText => '在此处粘贴您的 API 密钥';

  @override
  String get dialogActionSave => '保存';

  @override
  String get apiKeyRemoved => 'API 密钥已移除。';

  @override
  String get invalidApiKeyError => '无效的 API 密钥。';

  @override
  String get validatingApiKey => '正在验证...';

  @override
  String get errorApiKeyMissing => '未配置 Nexus Mods API 密钥。请通过顶部栏中的密钥图标添加它。';

  @override
  String get statusCheckingUpdates => '正在检查模组更新...';

  @override
  String statusUpdatesFound(Object count) {
    return '找到 $count 个更新！';
  }

  @override
  String get statusNoUpdates => '所有模组都是最新的。';

  @override
  String get selectModArchive => '选择模组存档';

  @override
  String get viewImageGallery => '查看图片';

  @override
  String get imageGallery => '图片库';

  @override
  String get noImagesFound => '未找到此模组的图片，或者未输入 API 密钥。请输入 API 密钥，然后再检查更新。';

  @override
  String errorFetchingImages(Object error) {
    return '获取图片时出错：$error';
  }

  @override
  String get imageMod => '模组图片';

  @override
  String get modEnabledBadge => '已启用';

  @override
  String get modDisabledBadge => '已禁用';

  @override
  String get modCategoryOther => '未指定';

  @override
  String get dialogContentUpdateOptions => '您想做什么？';

  @override
  String get dialogActionIgnoreVersion => '忽略';

  @override
  String get dialogActionSkipVersion => '跳过版本';

  @override
  String get dialogActionGoToDownloadPage => '转到下载';

  @override
  String get installedMods => '已安装的模组';

  @override
  String get filterBy => '筛选：';

  @override
  String get sortBy => '排序方式：';

  @override
  String get filterAll => '全部';

  @override
  String get filterEnabled => '已启用';

  @override
  String get filterDisabled => '已禁用';

  @override
  String get filterRepaired => '已修复';

  @override
  String get sortByName => '名称';

  @override
  String get sortByDate => '日期';

  @override
  String get noModsFound => '未找到模组。';

  @override
  String get viewTypeGrid => '网格视图';

  @override
  String get viewTypeList => '列表视图';

  @override
  String statusExtractingMultipleFiles(
    Object count,
    Object fileName,
    Object total,
  ) {
    return '正在提取 $total 个中的第 $count 个：$fileName';
  }

  @override
  String get previewInstallTitle => '将要安装的模组：';

  @override
  String get dialogTitleUE4SS => '检测到 UE4SS 安装';

  @override
  String get dialogContentUE4SS =>
      '已检测到 UE4SS 工具。您想将其安装到“StellarBlade\\SB\\Binaries\\Win64”吗？\n\n许多模组需要此工具才能正常工作。';

  @override
  String get dialogActionInstallTool => '安装工具';

  @override
  String get statusUE4SSInstallCancelled => 'UE4SS 安装已取消。';

  @override
  String get statusInstallingUE4SS => '正在安装 UE4SS...';

  @override
  String get snackBarUE4SSInstalled => 'UE4SS 安装成功。';

  @override
  String error7zipDecompression(Object error) {
    return '解压缩期间出现 7-Zip 错误：$error';
  }

  @override
  String get statusUE4SSInstallComplete => 'UE4SS 安装完成。';

  @override
  String get dialogTitleAlternativeVersion => '检测到备用版本';

  @override
  String dialogContentAlternativeVersion(
    String oldModName,
    String baseModName,
    String newModName,
  ) {
    return '此模组的备用版本已安装：\'$oldModName\'。\n\n您即将安装名为 \'$newModName\' 的不同备用版本。';
  }

  @override
  String get dialogActionReplace => '替换';

  @override
  String get dialogActionInstallAsNew => '作为新模组安装';

  @override
  String get dialogTitleUpdate => '有可用更新';

  @override
  String dialogContentUpdate(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return '您即将更新模组“$modName”。\n\n已安装版本：$oldVersion\n新版本：$newVersion';
  }

  @override
  String get dialogTitleDowngrade => '检测到旧版本';

  @override
  String dialogContentDowngrade(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return '警告：您即将安装模组“$modName”的旧版本。\n\n已安装版本：$oldVersion\n要安装的版本：$newVersion';
  }

  @override
  String get dialogActionDowngrade => '降级';

  @override
  String get dialogTitleReinstall => '重新安装模组';

  @override
  String dialogContentReinstall(Object modName, Object version) {
    return '您即将重新安装模组“$modName”的版本“$version”。';
  }

  @override
  String get dialogActionReinstall => '重新安装';

  @override
  String get editModNameTooltip => '编辑模组名称';

  @override
  String get setCoverTooltip => '设置自定义封面图片';

  @override
  String get setCoverText => '设置封面';

  @override
  String get restoreOriginalCoverText => '恢复原始封面';

  @override
  String errorSavingCoverText(Object error) {
    return '保存封面图片时出错：$error';
  }

  @override
  String errorRestoringCoverText(Object error) {
    return '恢复原始封面图片时出错：$error';
  }

  @override
  String get editVersionText => '编辑版本';

  @override
  String get customVersionText => '自定义版本';

  @override
  String get editTagText => '编辑标签';

  @override
  String get customTagText => '自定义标签';

  @override
  String get dialogTitleEditModName => '编辑模组名称';

  @override
  String get dialogActionResetToDefault => '重置为默认值';

  @override
  String get dialogLabelNewName => '新名称';

  @override
  String errorModNameExists(Object modName) {
    return '名为“$modName”的模组已存在。';
  }

  @override
  String get dialogTitleRepairedModWarning => '已修复模组警告';

  @override
  String get dialogContentRepairedModWarning =>
      '此模组可能没有正确的版本信息。建议重新安装最新版本以确保兼容性。';

  @override
  String get repairedModTooltip => '有关已修复模组的信息';

  @override
  String get disableAllModsTooltip => '禁用所有模组';

  @override
  String get deleteAllModsTooltip => '删除所有已禁用的模组';

  @override
  String get dialogTitleDisableAll => '禁用所有模组？';

  @override
  String dialogContentDisableAll(int count) {
    return '您确定要禁用所有 $count 个已启用的模组吗？它们将被移动到备份文件夹。';
  }

  @override
  String get dialogTitleDeleteAll => '删除已禁用的模组？';

  @override
  String dialogContentDeleteAll(int count) {
    return '您将永久删除所有 $count 个已禁用的模组。此操作无法撤销。\n\n您确定吗？';
  }

  @override
  String snackBarAllModsDisabled(int count) {
    return '所有 $count 个已启用的模组都已被禁用。';
  }

  @override
  String snackBarAllModsDeleted(int count) {
    return '所有 $count 个已禁用的模组都已被永久删除。';
  }

  @override
  String get snackBarNoModsToDisable => '没有要禁用的已启用模组。';

  @override
  String get snackBarNoModsToDelete => '没有要删除的禁用模组。';

  @override
  String get enableAllModsTooltip => '启用所有模组';

  @override
  String get dialogTitleEnableAll => '启用所有模组？';

  @override
  String dialogContentEnableAll(int count) {
    return '您确定要启用所有 $count 个已禁用的模组吗？它们将被移动到主模组文件夹。';
  }

  @override
  String snackBarAllModsEnabled(int count) {
    return '所有 $count 个已禁用的模组都已被启用。';
  }

  @override
  String get snackBarNoModsToEnable => '没有要启用的禁用模组。';

  @override
  String get editNotes => '编辑笔记';

  @override
  String get notesHintText => '在此处添加您的个人笔记...';

  @override
  String get modAuthor => '作者';

  @override
  String get modDescription => '描述';

  @override
  String get noDescriptionAvailable => '无可用描述。';

  @override
  String get personalNotes => '个人笔记';

  @override
  String get noNotesAvailable => '尚未添加笔记。';

  @override
  String get modDetailsTitle => '模组详情';

  @override
  String get modVersion => '版本';

  @override
  String get modCategory => '类别';

  @override
  String get dialogTitleAddUrl => '添加模组链接';

  @override
  String get dialogLabelUrl => '模组 URL';

  @override
  String get errorInvalidUrl => '请输入有效的 URL。';

  @override
  String get addLinkTooltip => '为此模组添加下载链接';

  @override
  String get addLinkButtonText => '添加链接';

  @override
  String get openLinkButtonText => '打开链接';

  @override
  String get editModTitle => '编辑模组详情';

  @override
  String get modNameLabel => '模组名称';

  @override
  String get authorLabel => '作者';

  @override
  String get summaryLabel => '描述/摘要';

  @override
  String get notesLabel => '个人笔记';

  @override
  String get urlLabel => '下载 URL';

  @override
  String get changeCoverButton => '更改封面图片';

  @override
  String get editButtonTooltip => '编辑模组';

  @override
  String get errorSavingNotes => '保存笔记时出错';

  @override
  String get errorSavingUrl => '保存 URL 时出错';

  @override
  String get errorSavingChanges => '保存更改时出错';

  @override
  String get errorTranslation => '无法翻译描述';

  @override
  String get translateDescription => '翻译描述';

  @override
  String get dialogTitleUE4SSReinstall => 'Reinstall UE4SS';

  @override
  String get dialogContentUE4SSReinstall =>
      'UE4SS already seems to be installed. Do you want to overwrite the existing installation? This can be useful if you suspect corrupt files.';

  @override
  String get dialogTitleCNSReinstall => 'Reinstall CNS System';

  @override
  String get dialogContentCNSReinstall =>
      'The main CNS system already seems to be installed. Do you want to reinstall it? Your existing mods will not be affected.';

  @override
  String dialogTitleUninstall(Object componentName) {
    return 'Uninstall $componentName';
  }

  @override
  String dialogContentUninstall(Object componentName) {
    return 'Are you sure you want to uninstall $componentName? This action will remove the core component files but will not affect your installed mods.';
  }

  @override
  String get dialogActionUninstall => 'Yes, uninstall';

  @override
  String statusUninstalling(Object componentName) {
    return 'Uninstalling $componentName...';
  }

  @override
  String snackBarUninstalled(Object componentName) {
    return '$componentName uninstalled successfully';
  }

  @override
  String errorUninstalling(Object componentName) {
    return 'Error uninstalling $componentName';
  }

  @override
  String get settingsCoreComponents => 'Core Components';

  @override
  String get installedStatus => 'Installed';

  @override
  String get notInstalledStatus => 'Not detected';

  @override
  String get uninstallButton => 'Uninstall';

  @override
  String get cnsCoreSystem => 'Custom Nanosuit System';

  @override
  String get ue4ssInstallationDetected =>
      'Instalación de UE4SS existente detectada y adoptada';

  @override
  String get cnsInstallationDetected =>
      'Instalación de CNS Principal existente detectada y adoptada';

  @override
  String get ue4ssRequiredTitle => 'UE4SS Required';

  @override
  String get ue4ssRequiredContent =>
      'To install the Main CNS System, you must first install UE4SS. You can download it from the following link:';

  @override
  String get uninstallDependencyTitle => 'Dependency Detected';

  @override
  String get uninstallDependencyContent =>
      'You must uninstall the Main CNS System before you can uninstall UE4SS, as CNS depends on it.';

  @override
  String get dialogActionUnderstood => 'Understood';
}
