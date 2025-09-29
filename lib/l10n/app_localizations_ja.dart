// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'CNS Control Center';

  @override
  String appTitleWithVersion(Object version) {
    return 'Custom Nanosuit System $version';
  }

  @override
  String get settings => '設定';

  @override
  String get settingsGeneral => '一般';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsLanguageDesc => 'アプリケーションの言語を選択してください';

  @override
  String get settingsAbout => '概要';

  @override
  String get settingsAboutDesc => 'アプリケーションに関する情報';

  @override
  String get settingsPathsAndTools => 'パスとツール';

  @override
  String get settingsGameFolder => 'ゲームフォルダ';

  @override
  String get settingsGameFolderDesc => 'Stellar Bladeインストールのルートフォルダ。';

  @override
  String get settings7zipPath => '7-Zipのパス';

  @override
  String get settings7zipPathDesc => 'MODを解凍するための7z.exeファイルの場所。';

  @override
  String get settings7zipPathAuto => '自動検索';

  @override
  String get settingsRepairMods => 'レガシーMODを修復';

  @override
  String get settingsRepairModsDesc =>
      'ローカルデータベースを使用して古いMODの情報ファイルをスキャンして作成します。APIキーが必要です。';

  @override
  String get settingsConnectivity => '接続とアップデート';

  @override
  String get settingsApiKey => 'Nexus Mods APIキー';

  @override
  String get settingsApiKeyDesc => 'MODのアップデートを確認するために必要です。';

  @override
  String get settingsApiKeySet => '設定済み';

  @override
  String get settingsApiKeyNotSet => '未設定';

  @override
  String get settingsSkippedVersions => 'スキップしたバージョンを管理';

  @override
  String get settingsSkippedVersionsDesc => 'スキップすることを選択したMODのバージョンを管理します。';

  @override
  String settingsSkippedVersionsCount(Object count) {
    return '$countバージョンがスキップされました';
  }

  @override
  String get dialogTitleSkippedVersions => 'スキップされたMODバージョン';

  @override
  String get dialogNoSkippedVersions => 'スキップしたMODバージョンはありません。';

  @override
  String get dialogSkippedVersions => 'スキップされたバージョン';

  @override
  String get dialogTitleRepairMods => 'レガシーMODの修復を実行しますか？';

  @override
  String get dialogContentRepairMods =>
      '警告：この機能は開発中であり、完全ではない可能性があります。\n\n「nexus_info.json」ファイルのないMODをスキャンし、ローカルデータベースで見つかった場合は作成します。また、見つかったバージョンを含むようにMODのフォルダ名を変更しようとします（例：「My Mod」->「My Mod v1.2」）。\n\nバージョンの優先順位：\n1. フォルダ名から。\n2. MODの説明フィールドから。\n3. Nexus Modsの最新バージョンから（APIが必要）。\n\n続行しますか？';

  @override
  String get dialogActionRunRepair => '修復を実行';

  @override
  String get snackBarGamePathInvalid => '選択したフォルダは有効なゲームフォルダではないようです。';

  @override
  String get snackBar7zipPathInvalid => '選択したファイルは7z.exeという名前である必要があります。';

  @override
  String get snackBarRepairStarted => 'レガシーMODの修復プロセスが開始されました...';

  @override
  String snackBarRepairComplete(Object count) {
    return '修復が完了しました。$count個のMODが更新されました。';
  }

  @override
  String get snackBarRepairNoMods => '修復が必要なレガシーMODは見つかりませんでした。';

  @override
  String get errorApiRequiredForRepair =>
      'ローカルバージョンがないMODの最新バージョンを見つけるにはAPIキーが必要です。';

  @override
  String get installNewMod => '新しいMODをインストール';

  @override
  String get selectFiles => 'ファイルを選択';

  @override
  String get selectFolder => 'フォルダを選択';

  @override
  String get installSelectedMod => '選択したMODをインストール';

  @override
  String get filesToInstall => 'インストールするファイル：';

  @override
  String get cancelSelection => '選択をキャンセル';

  @override
  String get searchMods => 'MODを検索...';

  @override
  String get enabledMods => '有効なMOD';

  @override
  String get disabledMods => '無効なMOD';

  @override
  String get refreshList => 'リストを更新';

  @override
  String get noEnabledMods => '有効なMODはありません。';

  @override
  String get noDisabledMods => '無効なMODはありません。';

  @override
  String get showInFolder => 'フォルダに表示';

  @override
  String get disableMod => 'MODを無効にする';

  @override
  String get enableMod => 'MODを有効にする';

  @override
  String get deletePermanently => '完全に削除';

  @override
  String get language => '言語';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get statusSearchingGame => 'Stellar Bladeのインストールを検索中...';

  @override
  String get statusGamePathFound => 'ゲームパスが見つかりました！';

  @override
  String get statusGamePathNotFound => 'ゲームパスを自動的に見つけることができませんでした。';

  @override
  String statusErrorFindingGame(Object error) {
    return 'ゲームの検索中にエラーが発生しました：$error';
  }

  @override
  String statusModsFound(Object disabledCount, Object enabledCount) {
    return '$enabledCount個のMODが有効、$disabledCount個が無効です。';
  }

  @override
  String statusErrorReadingMods(Object error) {
    return 'インストールされているMODの読み取り中にエラーが発生しました：$error';
  }

  @override
  String statusFilesSelected(Object count) {
    return '$count個のファイルが選択されました。インストール準備完了。';
  }

  @override
  String statusFolderSelected(Object folderName) {
    return 'フォルダ「$folderName」が選択されました。インストール準備完了。';
  }

  @override
  String statusArchiveLoaded(Object count, Object fileName) {
    return 'ファイル「$fileName」が読み込まれました。$count個のファイルがインストール準備完了。';
  }

  @override
  String get statusSelectionCancelled =>
      '選択がキャンセルされました。インストールする新しいMODを選択してください。';

  @override
  String get statusUpdateComplete => 'アップデートが完了しました。';

  @override
  String get statusInstallationComplete => 'インストールが完了しました。';

  @override
  String statusError(Object error) {
    return 'エラー：$error';
  }

  @override
  String get dialogTitle7zip => '7-Zipが必要です';

  @override
  String get dialogContent7zip =>
      'このファイルを解凍するには、アプリケーションに7-Zipが必要です。\n\n公式ページからインストールしてから、「確認」を押してください。';

  @override
  String get dialogContent7zipNotFound =>
      '7-Zipはまだ検出されていません。デフォルトパスにインストールされていることを確認してから、もう一度お試しください。';

  @override
  String get dialogTitleCNSUpdate => 'メインシステムのアップデートが検出されました';

  @override
  String get dialogContentCNSUpdate =>
      '「カスタムナノスーツシステム」のアップデートが検出されました。\n\nこれにより、メインゲームフォルダ（StellarBlade\\SB）のファイルが置き換えられます。続行しますか？';

  @override
  String get dialogTitleMultipleJsons => '複数の.jsonファイルが検出されました';

  @override
  String dialogContentMultipleJsons(Object count) {
    return '$count個の.jsonファイルが検出されました。これは複数のコンポーネントを持つMODである可能性があります。\n\nそれらをすべて1つのMODフォルダにまとめてインストールしますか？';
  }

  @override
  String get dialogTitleModExists => 'MODはすでに存在します';

  @override
  String dialogContentModExists(Object modName) {
    return '「$modName」という名前のMODはすでにインストールされています。\n\n更新しますか？新しいファイルをインストールする前に、古いファイルは削除されます。';
  }

  @override
  String dialogContentModUpdate(Object newModName, Object oldModName) {
    return '古いバージョン「$oldModName」が見つかりました。\n\nそれを削除して「$newModName」に更新しますか？';
  }

  @override
  String get dialogTitleDeleteMod => '完全に削除しますか？';

  @override
  String dialogContentDeleteMod(Object modName) {
    return 'MOD「$modName」を完全に削除しようとしています。この操作は元に戻せません。\n\nよろしいですか？';
  }

  @override
  String get dialogActionCancel => 'キャンセル';

  @override
  String get dialogActionGoToDownload => 'ダウンロードページに移動';

  @override
  String get dialogActionConfirmInstallation => 'インストールを確認';

  @override
  String get dialogActionUpdateSystem => 'システムを更新';

  @override
  String get dialogActionInstallAnyway => 'とにかくインストール';

  @override
  String get dialogActionUpdate => '更新';

  @override
  String get dialogActionDelete => '削除';

  @override
  String get dialogActionClose => '閉じる';

  @override
  String snackBarBatchInstallComplete(Object failedCount, Object successCount) {
    return '一括インストールが完了しました。成功：$successCount、失敗：$failedCount。';
  }

  @override
  String snackBarModInstalled(Object modName) {
    return 'MOD「$modName」が正常にインストールされました。';
  }

  @override
  String snackBarModEnabled(Object modName) {
    return 'MOD「$modName」が有効になりました。';
  }

  @override
  String snackBarModDisabled(Object modName) {
    return 'MOD「$modName」が無効になりました。';
  }

  @override
  String snackBarModDeleted(Object modName) {
    return 'MOD「$modName」が完全に削除されました。';
  }

  @override
  String get snackBarCNSUpdated => 'カスタムナノスーツシステムが正常に更新されました。';

  @override
  String get snackBarApiKeySaved => 'APIキーが正常に保存されました。';

  @override
  String get snackBarGamePathSaved => 'ゲームパスが正常に保存されました。';

  @override
  String get snackBar7zipPathSaved => '7-Zipパスが正常に保存されました。';

  @override
  String get snackBarSkippedVersionRemoved => 'スキップされたバージョンが削除されました。';

  @override
  String get dropTargetOverlay => 'ここにMODをドロップ';

  @override
  String get pathSelectionTitle => 'Stellar Bladeのパスが見つかりません';

  @override
  String get pathSelectionButtonManual => 'ゲームフォルダを手動で選択';

  @override
  String get pathSelectionButtonRetry => '再試行';

  @override
  String errorFolderSelection(Object error) {
    return 'フォルダの選択中にエラーが発生しました：$error';
  }

  @override
  String errorFileSelection(Object error) {
    return 'ファイルの選択中にエラーが発生しました：$error';
  }

  @override
  String errorDecompressing(Object error) {
    return 'ファイルの解凍中にエラーが発生しました：$error';
  }

  @override
  String errorProcessingArchive(Object error) {
    return 'ファイルの処理中にエラーが発生しました：$error';
  }

  @override
  String errorUnsupportedFormat(Object extension) {
    return 'サポートされていないファイル形式：$extension';
  }

  @override
  String get error7zipRequired => '操作がキャンセルされました：7-Zipが必要です。';

  @override
  String get errorGamePathUndefined => 'ゲームパスが定義されていません。';

  @override
  String get errorDestinationNotFound => 'ゲームの宛先フォルダが存在しません。';

  @override
  String errorUpdateSystem(Object error) {
    return 'システムの更新中にエラーが発生しました：$error';
  }

  @override
  String get errorInstallNoSelection => 'インストールするものを何も選択していません。';

  @override
  String get errorInstallModExists => 'インストールがキャンセルされました：MODはすでに存在します。';

  @override
  String get errorNoJsonFound => '各MODには少なくとも1つの.jsonファイルが含まれている必要があります。';

  @override
  String errorInvalidJsonFormat(Object fileName) {
    return 'ファイル$fileNameのJSON形式が無効です。';
  }

  @override
  String errorNoDisplayName(Object fileName) {
    return 'ファイル$fileNameはカスタムナノスーツシステムのMODではないようです（「DisplayName」がありません）。';
  }

  @override
  String get errorNoValidDisplayName =>
      '.jsonファイルに有効な「DisplayName」が見つかりませんでした。';

  @override
  String errorEnableMod(Object error) {
    return 'MODの有効化中にエラーが発生しました：$error';
  }

  @override
  String errorDisableMod(Object error) {
    return 'MODの無効化中にエラーが発生しました：$error';
  }

  @override
  String errorDeleteMod(Object error) {
    return 'MODの削除中にエラーが発生しました：$error';
  }

  @override
  String errorOpenFolder(Object path) {
    return 'フォルダを開けませんでした：$path';
  }

  @override
  String get statusUpdateSystemCancelled => 'システムの更新がキャンセルされました。';

  @override
  String get statusUpdatingCNS => 'カスタムナノスーツシステムを更新中...';

  @override
  String statusExtractingFile(Object fileName) {
    return '$fileNameを解凍中...';
  }

  @override
  String get statusInstallationCancelledByUser => 'ユーザーによってインストールがキャンセルされました。';

  @override
  String get errorNoCompatibleFilesInFolder =>
      '選択したフォルダには互換性のあるMODファイルが含まれていません。';

  @override
  String get errorNoCompatibleFilesInArchive =>
      '圧縮ファイルには互換性のあるMODファイルが含まれていません。';

  @override
  String get errorNoJsonInSelection => '選択範囲に有効なMOD.jsonファイルが含まれていません。';

  @override
  String get aboutTitle => 'CNSコントロールセンターについて';

  @override
  String get aboutContent =>
      'このアプリケーションは、カスタムナノスーツシステム（CNS）で動作するように設計されたStellar BladeのMODマネージャーです。\n\n要件：.rarおよび.7zファイルで完全に機能するには、システムに7-Zipがインストールされている必要があります。';

  @override
  String get aboutLinkText => 'クリエイタープロフィールにアクセス';

  @override
  String get creatorProfileUrl =>
      'https://next.nexusmods.com/profile/LuisNandez?gameId=7804';

  @override
  String aboutVersion(Object version) {
    return 'バージョン：$version';
  }

  @override
  String get openModsFolder => 'MODフォルダを開く';

  @override
  String get openInNexusMods => 'Nexus Modsで開く';

  @override
  String get checkForUpdates => 'アップデートを確認';

  @override
  String updateAvailable(Object version) {
    return 'アップデートが利用可能です：v$version';
  }

  @override
  String get dialogTitleApiKey => 'Nexus Mods APIキー';

  @override
  String get dialogContentApiKey =>
      'MODのアップデートを確認するには、Nexus Modsの個人APIキーが必要です。';

  @override
  String get dialogContentApiKeyInstructions =>
      '1. Nexus Modsにアクセスしてログインします。\n2.アバターをクリックして「サイトの設定」に移動します。\n3.「API」タブに移動します。\n4.「新しいAPIキーを生成」をクリックします。\n5.キーをコピーしてここに貼り付けます。';

  @override
  String get apiKey => 'APIキー';

  @override
  String get apiKeyHintText => 'APIキーをここに貼り付けます';

  @override
  String get dialogActionSave => '保存';

  @override
  String get apiKeyRemoved => 'APIキーが削除されました。';

  @override
  String get invalidApiKeyError => 'APIキーが無効です。';

  @override
  String get validatingApiKey => '検証中...';

  @override
  String get errorApiKeyMissing =>
      'Nexus Mods APIキーが設定されていません。トップバーのキーアイコンから追加してください。';

  @override
  String get statusCheckingUpdates => 'MODのアップデートを確認中...';

  @override
  String statusUpdatesFound(Object count) {
    return '$count個のアップデートが見つかりました！';
  }

  @override
  String get statusNoUpdates => 'すべてのMODは最新です。';

  @override
  String get selectModArchive => 'MODアーカイブを選択';

  @override
  String get viewImageGallery => '画像を表示';

  @override
  String get imageGallery => '画像ギャラリー';

  @override
  String get noImagesFound =>
      'このMODの画像は見つかりませんでした。またはAPIキーが入力されていません。APIキーを入力してからアップデートを確認してください。';

  @override
  String errorFetchingImages(Object error) {
    return '画像の取得中にエラーが発生しました：$error';
  }

  @override
  String get imageMod => 'MOD画像';

  @override
  String get modEnabledBadge => '有効';

  @override
  String get modDisabledBadge => '無効';

  @override
  String get modCategoryOther => '未指定';

  @override
  String get dialogContentUpdateOptions => 'どうしますか？';

  @override
  String get dialogActionIgnoreVersion => '無視';

  @override
  String get dialogActionSkipVersion => 'バージョンをスキップ';

  @override
  String get dialogActionGoToDownloadPage => 'ダウンロードに移動';

  @override
  String get installedMods => 'インストール済みMOD';

  @override
  String get filterBy => 'フィルター：';

  @override
  String get sortBy => '並べ替え：';

  @override
  String get filterAll => 'すべて';

  @override
  String get filterEnabled => '有効';

  @override
  String get filterDisabled => '無効';

  @override
  String get filterRepaired => '修復済み';

  @override
  String get sortByName => '名前';

  @override
  String get sortByDate => '日付';

  @override
  String get noModsFound => 'MODが見つかりません。';

  @override
  String get viewTypeGrid => 'グリッドビュー';

  @override
  String get viewTypeList => 'リストビュー';

  @override
  String statusExtractingMultipleFiles(
    Object count,
    Object fileName,
    Object total,
  ) {
    return '$total個中$count個を解凍中：$fileName';
  }

  @override
  String get previewInstallTitle => 'インストールするMOD：';

  @override
  String get dialogTitleUE4SS => 'UE4SSのインストールが検出されました';

  @override
  String get dialogContentUE4SS =>
      'UE4SSツールが検出されました。「StellarBlade\\SB\\Binaries\\Win64」にインストールしますか？\n\n多くのMODが動作するためにこれが必要です。';

  @override
  String get dialogActionInstallTool => 'ツールをインストール';

  @override
  String get statusUE4SSInstallCancelled => 'UE4SSのインストールがキャンセルされました。';

  @override
  String get statusInstallingUE4SS => 'UE4SSをインストール中...';

  @override
  String get snackBarUE4SSInstalled => 'UE4SSが正常にインストールされました。';

  @override
  String error7zipDecompression(Object error) {
    return '解凍中の7-Zipエラー：$error';
  }

  @override
  String get statusUE4SSInstallComplete => 'UE4SSのインストールが完了しました。';

  @override
  String get dialogTitleAlternativeVersion => '代替バージョンが検出されました';

  @override
  String dialogContentAlternativeVersion(
    String oldModName,
    String baseModName,
    String newModName,
  ) {
    return 'このMODの代替バージョンはすでにインストールされています：「$oldModName」。\n\n「$newModName」という名前の別の代替バージョンをインストールしようとしています。';
  }

  @override
  String get dialogActionReplace => '置換';

  @override
  String get dialogActionInstallAsNew => '新規としてインストール';

  @override
  String get dialogTitleUpdate => 'アップデートが利用可能です';

  @override
  String dialogContentUpdate(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return 'MOD「$modName」を更新しようとしています。\n\nインストール済みバージョン：$oldVersion\n新しいバージョン：$newVersion';
  }

  @override
  String get dialogTitleDowngrade => '古いバージョンが検出されました';

  @override
  String dialogContentDowngrade(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return '警告：MOD「$modName」の古いバージョンをインストールしようとしています。\n\nインストール済みバージョン：$oldVersion\nインストールするバージョン：$newVersion';
  }

  @override
  String get dialogActionDowngrade => 'ダウングレード';

  @override
  String get dialogTitleReinstall => 'MODを再インストール';

  @override
  String dialogContentReinstall(Object modName, Object version) {
    return 'MOD「$modName」のバージョン「$version」を再インストールしようとしています。';
  }

  @override
  String get dialogActionReinstall => '再インストール';

  @override
  String get editModNameTooltip => 'MOD名を編集';

  @override
  String get setCoverTooltip => 'Set custom cover image';

  @override
  String get setCoverText => 'Set Cover';

  @override
  String get restoreOriginalCoverText => 'Restore Original Cover';

  @override
  String errorSavingCoverText(Object error) {
    return 'Error saving cover image: $error';
  }

  @override
  String errorRestoringCoverText(Object error) {
    return 'Error restoring original cover image: $error';
  }

  @override
  String get dialogTitleEditModName => 'MOD名を編集';

  @override
  String get dialogActionResetToDefault => 'デフォルトにリセット';

  @override
  String get dialogLabelNewName => '新しい名前';

  @override
  String errorModNameExists(Object modName) {
    return '「$modName」という名前のMODはすでに存在します。';
  }

  @override
  String get dialogTitleRepairedModWarning => '修復されたMODの警告';

  @override
  String get dialogContentRepairedModWarning =>
      'このMODには正しいバージョン情報がない可能性があります。互換性を確保するために、最新バージョンを再インストールすることをお勧めします。';

  @override
  String get repairedModTooltip => '修復されたMODに関する情報';

  @override
  String get disableAllModsTooltip => 'すべてのMODを無効にする';

  @override
  String get deleteAllModsTooltip => 'すべての無効なMODを削除';

  @override
  String get dialogTitleDisableAll => 'すべてのMODを無効にしますか？';

  @override
  String dialogContentDisableAll(int count) {
    return '有効になっている$count個のMODをすべて無効にしますか？それらはバックアップフォルダに移動されます。';
  }

  @override
  String get dialogTitleDeleteAll => '無効なMODを削除しますか？';

  @override
  String dialogContentDeleteAll(int count) {
    return '無効になっている$count個のMODをすべて完全に削除しようとしています。この操作は元に戻せません。\n\nよろしいですか？';
  }

  @override
  String snackBarAllModsDisabled(int count) {
    return '有効になっている$count個のMODがすべて無効になりました。';
  }

  @override
  String snackBarAllModsDeleted(int count) {
    return '無効になっている$count個のMODがすべて完全に削除されました。';
  }

  @override
  String get snackBarNoModsToDisable => '無効にする有効なMODはありません。';

  @override
  String get snackBarNoModsToDelete => '削除する無効なMODはありません。';

  @override
  String get enableAllModsTooltip => 'すべてのMODを有効にする';

  @override
  String get dialogTitleEnableAll => 'すべてのMODを有効にしますか？';

  @override
  String dialogContentEnableAll(int count) {
    return '無効になっている$count個のMODをすべて有効にしますか？それらはメインのMODフォルダに移動されます。';
  }

  @override
  String snackBarAllModsEnabled(int count) {
    return '無効になっている$count個のMODがすべて有効になりました。';
  }

  @override
  String get snackBarNoModsToEnable => '有効にする無効なMODはありません。';
}
