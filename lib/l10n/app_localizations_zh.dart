// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'CNS 控制中心';

  @override
  String appTitleWithVersion(Object version) {
    return '自定义纳米服系统 $version';
  }

  @override
  String get settings => '设置';

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
  String get installNewMod => '安装新模组';

  @override
  String get selectFiles => '选择文件';

  @override
  String get selectFolder => '选择文件夹';

  @override
  String get installSelectedMod => '安装选定的模组';

  @override
  String get filesToInstall => '待安装文件:';

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
    return '搜索游戏时出错: $error';
  }

  @override
  String statusModsFound(Object disabledCount, Object enabledCount) {
    return '$enabledCount 个模组已启用，$disabledCount 个已禁用。';
  }

  @override
  String statusErrorReadingMods(Object error) {
    return '读取已安装的模组时出错: $error';
  }

  @override
  String statusFilesSelected(Object count) {
    return '已选择 $count 个文件。准备安装。';
  }

  @override
  String statusFolderSelected(Object folderName) {
    return '文件夹“$folderName”已选择。准备安装。';
  }

  @override
  String statusArchiveLoaded(Object count, Object fileName) {
    return '文件“$fileName”已加载。$count 个文件准备安装。';
  }

  @override
  String get statusSelectionCancelled => '选择已取消。请选择新模组进行安装。';

  @override
  String get statusUpdateComplete => '更新完成。';

  @override
  String get statusInstallationComplete => '安装完成。';

  @override
  String statusError(Object error) {
    return '错误: $error';
  }

  @override
  String get dialogTitle7zip => '需要 7-Zip';

  @override
  String get dialogContent7zip => '要解压此文件，应用程序需要 7-Zip。\n\n请从其官方页面安装，然后按“确认”。';

  @override
  String get dialogContent7zipNotFound => '尚未检测到 7-Zip。请确保它已安装在默认路径中，然后重试。';

  @override
  String get dialogTitleCNSUpdate => '检测到主系统更新';

  @override
  String get dialogContentCNSUpdate =>
      '检测到“自定义纳米服系统”的更新。\n\n这将在主游戏文件夹 (StellarBlade\\SB) 中替换文件。您想继续吗？';

  @override
  String get dialogTitleMultipleJsons => '检测到多个 .json 文件';

  @override
  String dialogContentMultipleJsons(Object count) {
    return '检测到 $count 个 .json 文件。这可能是一个包含多个组件的模组。\n\n您想将它们全部安装到一个模组文件夹中吗？';
  }

  @override
  String get dialogTitleModExists => '模组已存在';

  @override
  String dialogContentModExists(Object modName) {
    return '名为“$modName”的模组已安装。\n\n您想更新它吗？旧文件将在安装新文件之前被删除。';
  }

  @override
  String dialogContentModUpdate(Object newModName, Object oldModName) {
    return '找到了旧版本\'$oldModName\'。\n\n您想删除它并更新到\'$newModName\'吗？';
  }

  @override
  String get dialogTitleDeleteMod => '永久删除？';

  @override
  String dialogContentDeleteMod(Object modName) {
    return '您即将永久删除模组“$modName”。此操作无法撤销。\n\n您确定吗？';
  }

  @override
  String get dialogActionCancel => '取消';

  @override
  String get dialogActionGoToDownload => '前往下载页面';

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
    return '模组“$modName”已成功安装。';
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
  String get snackBarCNSUpdated => '自定义纳米服系统已成功更新。';

  @override
  String get snackBarApiKeySaved => 'API 密钥已成功保存。';

  @override
  String get snackBarGamePathSaved => 'Game path saved successfully.';

  @override
  String get snackBar7zipPathSaved => '7-Zip path saved successfully.';

  @override
  String get snackBarSkippedVersionRemoved => 'Skipped version removed.';

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
    return '选择文件夹时出错: $error';
  }

  @override
  String errorFileSelection(Object error) {
    return '选择文件时出错: $error';
  }

  @override
  String errorDecompressing(Object error) {
    return '解压文件时出错: $error';
  }

  @override
  String errorProcessingArchive(Object error) {
    return '处理存档时出错: $error';
  }

  @override
  String errorUnsupportedFormat(Object extension) {
    return '不支持的文件格式: $extension';
  }

  @override
  String get error7zipRequired => '操作已取消：需要 7-Zip。';

  @override
  String get errorGamePathUndefined => '未定义游戏路径。';

  @override
  String get errorDestinationNotFound => '游戏的目标文件夹不存在。';

  @override
  String errorUpdateSystem(Object error) {
    return '更新系统时出错: $error';
  }

  @override
  String get errorInstallNoSelection => '您没有选择任何要安装的项目。';

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
    return '启用模组时出错: $error';
  }

  @override
  String errorDisableMod(Object error) {
    return '禁用模组时出错: $error';
  }

  @override
  String errorDeleteMod(Object error) {
    return '删除模组时出错: $error';
  }

  @override
  String errorOpenFolder(Object path) {
    return '无法打开文件夹: $path';
  }

  @override
  String get statusUpdateSystemCancelled => '系统更新已取消。';

  @override
  String get statusUpdatingCNS => '正在更新自定义纳米服系统...';

  @override
  String statusExtractingFile(Object fileName) {
    return '正在解压 $fileName...';
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
      '此应用程序是 Stellar Blade 的模组管理器，旨在与自定义纳米服系统 (CNS) 配合使用。\n\n要求：要完全使用 .rar 和 .7z 文件功能，您的系统上必须安装 7-Zip。';

  @override
  String get aboutLinkText => '访问我的创作者资料';

  @override
  String get creatorProfileUrl =>
      'https://next.nexusmods.com/profile/LuisNandez?gameId=7804';

  @override
  String aboutVersion(Object version) {
    return '版本: $version';
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
  String get dialogContentApiKey => '要检查模组更新，您需要来自 Nexus Mods 的个人 API 密钥。';

  @override
  String get dialogContentApiKeyInstructions =>
      '1. 前往 Nexus Mods 并登录。\n2. 点击您的头像，然后转到“网站偏好设置”。\n3. 转到“API”选项卡。\n4. 点击“生成新的 API 密钥”。\n5. 复制密钥并在此处粘贴。';

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
  String get validatingApiKey => '验证中...';

  @override
  String get errorApiKeyMissing => 'Nexus Mods API 密钥未配置。请通过顶部栏中的密钥图标添加它。';

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
  String get noImagesFound => '未找到此模组的图片，或者未输入 API 密钥。请输入 API 密钥，然后检查更新。';

  @override
  String errorFetchingImages(Object error) {
    return '获取图片时出错: $error';
  }

  @override
  String get imageMod => '模组图片';

  @override
  String get dialogContentUpdateOptions => '您想做什么？';

  @override
  String get dialogActionIgnoreVersion => '忽略版本';

  @override
  String get dialogActionSkipVersion => 'Skip Version';

  @override
  String get dialogActionGoToDownloadPage => '前往下载';

  @override
  String get installedMods => '已安装的模组';

  @override
  String get filterBy => '筛选:';

  @override
  String get sortBy => '排序方式:';

  @override
  String get filterAll => '全部';

  @override
  String get filterEnabled => '已启用';

  @override
  String get filterDisabled => '已禁用';

  @override
  String get filterRepaired => 'Repaired';

  @override
  String get sortByName => '名称';

  @override
  String get sortByDate => '日期';

  @override
  String get noModsFound => '未找到模组。';

  @override
  String statusExtractingMultipleFiles(
    Object count,
    Object fileName,
    Object total,
  ) {
    return '正在解压 $count / $total: $fileName';
  }

  @override
  String get previewInstallTitle => '待安装的模组:';

  @override
  String get dialogTitleUE4SS => '检测到 UE4SS 安装';

  @override
  String get dialogContentUE4SS =>
      '已检测到 UE4SS 工具。您想将其安装到“StellarBlade\\SB\\Binaries\\Win64”吗？\n\n许多模组需要此工具才能工作。';

  @override
  String get dialogActionInstallTool => '安装工具';

  @override
  String get statusUE4SSInstallCancelled => 'UE4SS 安装已取消。';

  @override
  String get statusInstallingUE4SS => '正在安装 UE4SS...';

  @override
  String get snackBarUE4SSInstalled => 'UE4SS 已成功安装。';

  @override
  String error7zipDecompression(Object error) {
    return '7-Zip 解压时出错: $error';
  }

  @override
  String get statusUE4SSInstallComplete => 'UE4SS 安装完成。';

  @override
  String get dialogTitleAlternativeVersion => '检测到替代版本';

  @override
  String dialogContentAlternativeVersion(
    String oldModName,
    String baseModName,
    String newModName,
  ) {
    return '此模组的替代版本已安装：\'$oldModName\'。\n\n您即将安装一个名为\'$newModName\'的不同替代版本。';
  }

  @override
  String get dialogActionReplace => '替换';

  @override
  String get dialogActionInstallAsNew => '安装为新的';

  @override
  String get dialogTitleUpdate => '有可用更新';

  @override
  String dialogContentUpdate(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return '您即将更新模组\'$modName\'。\n\n已安装版本: $oldVersion\n新版本: $newVersion';
  }

  @override
  String get dialogTitleDowngrade => '检测到旧版本';

  @override
  String dialogContentDowngrade(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return '警告：您即将安装模组\'$modName\'的旧版本。\n\n已安装版本: $oldVersion\n要安装的版本: $newVersion';
  }

  @override
  String get dialogActionDowngrade => '降级';

  @override
  String get dialogTitleReinstall => '重新安装模组';

  @override
  String dialogContentReinstall(Object modName, Object version) {
    return '您即将重新安装模组\'$modName\'的版本\'$version\'。';
  }

  @override
  String get dialogActionReinstall => '重新安装';

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
