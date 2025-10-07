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
  String get settingsGeneral => '全般';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsLanguageDesc => 'アプリケーションの言語を選択します';

  @override
  String get settingsAbout => '概要';

  @override
  String get settingsAboutDesc => 'アプリケーションに関する情報';

  @override
  String get settingsPathsAndTools => 'パスとツール';

  @override
  String get settingsGameFolder => 'ゲームフォルダ';

  @override
  String get settingsGameFolderDesc => 'Stellar Bladeのインストール先のルートフォルダ。';

  @override
  String get settings7zipPath => '7-Zipのパス';

  @override
  String get settings7zipPathDesc => 'MODを解凍するための7z.exeファイルの場所。';

  @override
  String get settings7zipPathAuto => '自動検索';

  @override
  String get settingsRepairMods => 'レガシーMODの修復';

  @override
  String get settingsRepairModsDesc =>
      'ローカルデータベースを使用して古いMODの情報ファイルをスキャンおよび作成します。APIキーが必要です。';

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
  String get settingsSkippedVersions => 'スキップされたバージョンを管理';

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
      '警告：この機能は開発中であり、完全ではない可能性があります。\n\n\'nexus_info.json\'ファイルがないMODをスキャンし、ローカルデータベースで見つかった場合、そのファイルを作成します。また、見つかったバージョンを含むようにMODのフォルダ名を変更しようとします（例：「マイMOD」→「マイMOD v1.2」）。\n\nバージョンの優先順位：\n1. フォルダ名から。\n2. MODの説明欄から。\n3. Nexus Modsの最新バージョンから（APIが必要）。\n\n続行しますか？';

  @override
  String get dialogActionRunRepair => '修復を実行';

  @override
  String get snackBarGamePathInvalid => '選択されたフォルダは有効なゲームフォルダではないようです。';

  @override
  String get snackBar7zipPathInvalid => '選択されたファイル名は7z.exeでなければなりません。';

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
  String get disableMod => 'MODを無効化';

  @override
  String get enableMod => 'MODを有効化';

  @override
  String get deletePermanently => '完全に削除';

  @override
  String get language => '言語';

  @override
  String get selectLanguage => '言語を選択してください';

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
    return '有効なMOD $enabledCount個、無効なMOD $disabledCount個。';
  }

  @override
  String statusErrorReadingMods(Object error) {
    return 'インストールされたMODの読み取り中にエラーが発生しました：$error';
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
    return 'ファイル「$fileName」が読み込まれました。$count個のファイルがインストール準備完了です。';
  }

  @override
  String get statusSelectionCancelled =>
      '選択がキャンセルされました。新しいMODを選択してインストールしてください。';

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
      'このファイルを解凍するには、アプリケーションに7-Zipが必要です。\n\n公式サイトからインストールし、「確認」を押してください。';

  @override
  String get dialogContent7zipNotFound =>
      '7-Zipがまだ検出されていません。デフォルトパスにインストールされていることを確認して、もう一度お試しください。';

  @override
  String get dialogTitleMultipleJsons => '複数の.jsonファイルが検出されました';

  @override
  String dialogContentMultipleJsons(Object count) {
    return '$count個の.jsonファイルが検出されました。これは複数のコンポーネントを持つMODである可能性があります。\n\nすべてのファイルを1つのMODフォルダにまとめてインストールしますか？';
  }

  @override
  String get dialogTitleModExists => 'MODはすでに存在します';

  @override
  String dialogContentModExists(Object modName) {
    return '「$modName」という名前のMODはすでにインストールされています。\n\n更新しますか？古いファイルは新しいファイルをインストールする前に削除されます。';
  }

  @override
  String dialogContentModUpdate(Object newModName, Object oldModName) {
    return '古いバージョン「$oldModName」が見つかりました。\n\n削除して「$newModName」に更新しますか？';
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
  String get dialogActionGoToDownload => 'ダウンロードページへ移動';

  @override
  String get dialogActionConfirmInstallation => 'インストールを確認';

  @override
  String get dialogActionUpdateSystem => 'システムを更新';

  @override
  String get dialogActionInstallAnyway => 'そのままインストール';

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
  String get snackBar7zipPathSaved => '7-Zipのパスが正常に保存されました。';

  @override
  String get snackBarSkippedVersionRemoved => 'スキップされたバージョンが削除されました。';

  @override
  String get dropTargetOverlay => 'ここにMODをドロップしてください';

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
    return 'サポートされていないファイル形式です：$extension';
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
  String get errorInstallNoSelection => 'インストールするものを選択していません。';

  @override
  String get errorInstallModExists => 'インストールがキャンセルされました：MODはすでに存在します。';

  @override
  String get errorNoJsonFound => '各MODには少なくとも1つの.jsonファイルが含まれている必要があります。';

  @override
  String errorInvalidJsonFormat(Object fileName) {
    return 'ファイル$fileNameは無効なJSON形式です。';
  }

  @override
  String errorNoDisplayName(Object fileName) {
    return 'ファイル$fileNameはカスタムナノスーツシステムのMODではないようです（\"DisplayName\"がありません）。';
  }

  @override
  String get errorNoValidDisplayName =>
      '.jsonファイルに有効な\"DisplayName\"が見つかりませんでした。';

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
    return '$fileNameを展開中...';
  }

  @override
  String get statusInstallationCancelledByUser => 'インストールはユーザーによってキャンセルされました。';

  @override
  String get errorNoCompatibleFilesInFolder =>
      '選択されたフォルダには互換性のあるMODファイルが含まれていません。';

  @override
  String get errorNoCompatibleFilesInArchive =>
      '圧縮ファイルには互換性のあるMODファイルが含まれていません。';

  @override
  String get errorNoJsonInSelection => '選択範囲に有効なMODの.jsonファイルが含まれていません。';

  @override
  String get aboutTitle => 'CNSコントロールセンターについて';

  @override
  String get aboutContent =>
      'このアプリケーションは、カスタムナノスーツシステム（CNS）と連携するように設計されたStellar Blade用のMODマネージャーです。\n\n要件：.rarおよび.7zファイルで全機能を利用するには、システムに7-Zipがインストールされている必要があります。';

  @override
  String get aboutLinkText => '私のクリエイタープロフィールを見る';

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
    return 'アップデート利用可能：v$version';
  }

  @override
  String get dialogTitleApiKey => 'Nexus Mods APIキー';

  @override
  String get dialogContentApiKey =>
      'MODのアップデートを確認するには、Nexus Modsの個人用APIキーが必要です。';

  @override
  String get dialogContentApiKeyInstructions =>
      '1. Nexus Modsにアクセスしてログインします。\n2. アバターをクリックして「サイト設定」に移動します。\n3. 「API」タブに移動します。\n4. 「新しいAPIキーを生成」をクリックします。\n5. キーをコピーしてここに貼り付けます。';

  @override
  String get apiKey => 'APIキー';

  @override
  String get apiKeyHintText => 'ここにAPIキーを貼り付けてください';

  @override
  String get dialogActionSave => '保存';

  @override
  String get apiKeyRemoved => 'APIキーが削除されました。';

  @override
  String get invalidApiKeyError => '無効なAPIキーです。';

  @override
  String get validatingApiKey => '検証中...';

  @override
  String get errorApiKeyMissing =>
      'Nexus ModsのAPIキーが設定されていません。上部バーのキーアイコンから追加してください。';

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
  String get viewImageGallery => '画像を見る';

  @override
  String get imageGallery => '画像ギャラリー';

  @override
  String get noImagesFound =>
      'このMODの画像が見つからないか、APIキーが入力されていません。APIキーを入力してからアップデートを確認してください。';

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
  String get dialogActionGoToDownloadPage => 'ダウンロードへ移動';

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
  String get viewTypeGrid => 'グリッド表示';

  @override
  String get viewTypeList => 'リスト表示';

  @override
  String statusExtractingMultipleFiles(
    Object count,
    Object fileName,
    Object total,
  ) {
    return '$total個中$count個を展開中：$fileName';
  }

  @override
  String get previewInstallTitle => 'インストールされるMOD：';

  @override
  String get dialogTitleUE4SS => 'UE4SSのインストールが検出されました';

  @override
  String get dialogContentUE4SS =>
      'UE4SSツールが検出されました。「StellarBlade\\SB\\Binaries\\Win64」にインストールしますか？\n\nこれは多くのMODが機能するために必要です。';

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
    return '展開中の7-Zipエラー：$error';
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
    return 'このMODの別のバージョンがすでにインストールされています：\'$oldModName\'。\n\n\'$newModName\'という名前の別のバージョンをインストールしようとしています。';
  }

  @override
  String get dialogActionReplace => '置換';

  @override
  String get dialogActionInstallAsNew => '新規としてインストール';

  @override
  String get dialogTitleUpdate => 'アップデート利用可能';

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
  String get setCoverTooltip => 'カスタムカバー画像を設定';

  @override
  String get setCoverText => 'カバーを設定';

  @override
  String get restoreOriginalCoverText => '元のカバーを復元';

  @override
  String errorSavingCoverText(Object error) {
    return 'カバー画像の保存中にエラーが発生しました：$error';
  }

  @override
  String errorRestoringCoverText(Object error) {
    return '元のカバー画像の復元中にエラーが発生しました：$error';
  }

  @override
  String get editVersionText => 'バージョンを編集';

  @override
  String get customVersionText => 'カスタムバージョン';

  @override
  String get editTagText => 'タグを編集';

  @override
  String get customTagText => 'カスタムタグ';

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
  String get dialogTitleRepairedModWarning => '修復済みMODの警告';

  @override
  String get dialogContentRepairedModWarning =>
      'このMODは正しいバージョン情報を持っていない可能性があります。互換性を確保するために、最新バージョンを再インストールすることをお勧めします。';

  @override
  String get repairedModTooltip => '修復済みMODに関する情報';

  @override
  String get disableAllModsTooltip => 'すべてのMODを無効化';

  @override
  String get deleteAllModsTooltip => 'すべての無効なMODを削除';

  @override
  String get dialogTitleDisableAll => 'すべてのMODを無効にしますか？';

  @override
  String dialogContentDisableAll(int count) {
    return '$count個の有効なMODをすべて無効にしてもよろしいですか？バックアップフォルダに移動されます。';
  }

  @override
  String get dialogTitleDeleteAll => '無効なMODを削除しますか？';

  @override
  String dialogContentDeleteAll(int count) {
    return '$count個の無効なMODをすべて完全に削除しようとしています。この操作は元に戻せません。\n\nよろしいですか？';
  }

  @override
  String snackBarAllModsDisabled(int count) {
    return '$count個の有効なMODがすべて無効になりました。';
  }

  @override
  String snackBarAllModsDeleted(int count) {
    return '$count個の無効なMODがすべて完全に削除されました。';
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
    return '$count個の無効なMODをすべて有効にしてもよろしいですか？メインのMODフォルダに移動されます。';
  }

  @override
  String snackBarAllModsEnabled(int count) {
    return '$count個の無効なMODがすべて有効になりました。';
  }

  @override
  String get snackBarNoModsToEnable => '有効にする無効なMODはありません。';

  @override
  String get editNotes => 'ノートを編集';

  @override
  String get notesHintText => 'ここに個人的なノートを追加...';

  @override
  String get modAuthor => '作者';

  @override
  String get modDescription => '説明';

  @override
  String get noDescriptionAvailable => '説明はありません。';

  @override
  String get personalNotes => '個人的なノート';

  @override
  String get noNotesAvailable => 'まだノートは追加されていません。';

  @override
  String get modDetailsTitle => 'MOD詳細';

  @override
  String get modVersion => 'バージョン';

  @override
  String get modCategory => 'カテゴリー';

  @override
  String get dialogTitleAddUrl => 'MODリンクを追加';

  @override
  String get dialogLabelUrl => 'MOD URL';

  @override
  String get errorInvalidUrl => '有効なURLを入力してください。';

  @override
  String get addLinkTooltip => 'このMODのダウンロードリンクを追加';

  @override
  String get addLinkButtonText => 'リンクを追加';

  @override
  String get openLinkButtonText => 'リンクを開く';

  @override
  String get editModTitle => 'MOD詳細を編集';

  @override
  String get modNameLabel => 'MOD名';

  @override
  String get authorLabel => '作者';

  @override
  String get summaryLabel => '説明/概要';

  @override
  String get notesLabel => '個人的なノート';

  @override
  String get urlLabel => 'ダウンロードURL';

  @override
  String get changeCoverButton => 'カバー画像を変更';

  @override
  String get editButtonTooltip => 'MODを編集';

  @override
  String get errorSavingNotes => 'ノートの保存中にエラーが発生しました';

  @override
  String get errorSavingUrl => 'URLの保存中にエラーが発生しました';

  @override
  String get errorSavingChanges => '変更の保存中にエラーが発生しました';

  @override
  String get errorTranslation => '説明を翻訳できませんでした';

  @override
  String get translateDescription => '説明を翻訳';

  @override
  String get dialogTitleUE4SSReinstall => 'Reinstall UE4SS';

  @override
  String get dialogContentUE4SSReinstall =>
      'UE4SS already seems to be installed.\nDo you want to overwrite the existing installation? This can be useful if you suspect corrupt files.';

  @override
  String get dialogTitleCNSReinstall => 'Reinstall CNS System';

  @override
  String get dialogContentCNSReinstall =>
      'The main CNS system already seems to be installed.\nDo you want to reinstall it? Your existing mods will not be affected.';

  @override
  String dialogTitleUninstall(Object componentName) {
    return 'Uninstall $componentName';
  }

  @override
  String dialogContentUninstall(Object componentName) {
    return 'Are you sure you want to uninstall $componentName?\nThis action will remove the core component files but will not affect your installed mods.';
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
      'To install the Main CNS System, you must first install UE4SS.\nYou can download it from the following link:';

  @override
  String get uninstallDependencyTitle => 'Dependency Detected';

  @override
  String get uninstallDependencyContent =>
      'You must uninstall the Main CNS System before you can uninstall UE4SS, as CNS depends on it.';

  @override
  String get dialogActionUnderstood => 'Understood';

  @override
  String get appTitleNoCns => 'Custom Nanosuit System (Not Installed)';

  @override
  String get dialogTitleCNSUpdate => 'Update Main CNS System';

  @override
  String dialogContentCNSUpdate(Object oldVersion, Object newVersion) {
    return 'You are about to update CNS from version $oldVersion to the new version $newVersion.\nDo you wish to continue?';
  }

  @override
  String get dialogTitleCNSDowngrade => 'Downgrade CNS Version';

  @override
  String dialogContentCNSDowngrade(Object oldVersion, Object newVersion) {
    return 'Warning!\nYou are about to install an older version of CNS ($newVersion) than your current one ($oldVersion). This may cause issues.\nAre you sure?';
  }

  @override
  String dialogContentCNSReinstallVersion(Object version) {
    return 'You already have version $version of CNS installed.\nDo you want to reinstall the files anyway?';
  }

  @override
  String get dialogActionUpdate => '更新';

  @override
  String get dialogActionDowngrade => 'ダウングレード';

  @override
  String get dialogTitleCNSInstall => 'Install Main CNS System';

  @override
  String get dialogContentCNSInstall =>
      'You are about to install the base Custom Nanosuit System (CNS).\nThis is required for CNS mods to work. Do you wish to continue?';

  @override
  String get dialogActionInstall => 'Install';

  @override
  String get settingsDeveloperOptions => 'Developer Options';

  @override
  String get devDeleteNexusInfoTitle => 'Delete All nexus_info.json Files';

  @override
  String get devDeleteNexusInfoDesc =>
      'Removes all manager metadata files from every mod. This is useful for forcing a full repair.';

  @override
  String get devExtractIdsTitle => 'Extract Identifiers';

  @override
  String get devExtractIdsDesc =>
      'Creates a file named \'ID Mods.json\' on your desktop containing the displayName and nexusId of each mod.';

  @override
  String get devConfirmDeleteTitle => 'Confirm Deletion';

  @override
  String get devConfirmDeleteDesc =>
      'Are you sure you want to permanently delete all nexus_info.json files? This will remove all custom names, covers, and metadata. This action cannot be undone.';

  @override
  String get devDeleteSuccessTitle => 'Deletion Complete';

  @override
  String devDeleteSuccessDesc(Object count) {
    return 'Successfully deleted $count nexus_info.json files.';
  }

  @override
  String get devConfirmExtractTitle => 'Confirm Extraction';

  @override
  String get devConfirmExtractDesc =>
      'This will scan all your mods and create \'ID Mods.json\' on your desktop. This will overwrite any existing file with the same name. Do you want to continue?';

  @override
  String get devExtractAction => 'Extract';

  @override
  String get devExtractNoData =>
      'No mods with valid identifiers were found to extract.';

  @override
  String get devExtractDesktopNotFound =>
      'Error: Could not find the Desktop directory.';

  @override
  String get devExtractSuccessTitle => 'Extraction Complete';

  @override
  String devExtractSuccessDesc(Object path) {
    return 'File successfully created at: $path';
  }

  @override
  String get errorDialogTitle => 'An Error Occurred';
}
