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
  String get settingsGameFolderDesc => 'Stellar Blade のインストール先のルートフォルダです。';

  @override
  String get settings7zipPath => '7-Zip のパス';

  @override
  String get settings7zipPathDesc => 'MOD を展開するための 7z.exe ファイルの場所です。';

  @override
  String get settings7zipPathAuto => '自動検索';

  @override
  String get settingsRepairMods => 'レガシー MOD の修復';

  @override
  String get settingsRepairModsDesc =>
      'ローカルデータベースを使用して古い MOD をスキャンし、情報ファイルを作成します。API キーが必要です。';

  @override
  String get settingsConnectivity => '接続とアップデート';

  @override
  String get settingsApiKey => 'Nexus Mods API キー';

  @override
  String get settingsApiKeyDesc => 'MOD のアップデートを確認するために必要です。';

  @override
  String get settingsApiKeySet => '設定済み';

  @override
  String get settingsApiKeyNotSet => '未設定';

  @override
  String get settingsSkippedVersions => 'スキップしたバージョンの管理';

  @override
  String get settingsSkippedVersionsDesc => 'スキップすることを選択した MOD のバージョンを管理します。';

  @override
  String settingsSkippedVersionsCount(Object count) {
    return '$count 個のバージョンをスキップしました';
  }

  @override
  String get dialogTitleSkippedVersions => 'スキップした MOD のバージョン';

  @override
  String get dialogNoSkippedVersions => 'スキップした MOD のバージョンはありません。';

  @override
  String get dialogSkippedVersions => 'スキップしたバージョン';

  @override
  String get dialogTitleRepairMods => 'レガシー MOD の修復を実行しますか？';

  @override
  String get dialogContentRepairMods =>
      '警告：この機能は開発中であり、完全ではない可能性があります。\n\n\'nexus_info.json\' ファイルのない MOD をスキャンし、ローカルデータベースで見つかった場合は、その MOD の情報ファイルを作成します。また、見つかったバージョンを含むように MOD のフォルダ名を変更しようとします（例：「My Mod」->「My Mod v1.2」）。\n\nバージョンの優先順位：\n1. フォルダ名から。\n2. MOD の説明欄から。\n3. Nexus Mods の最新バージョンから（API が必要です）。\n\n続行しますか？';

  @override
  String get dialogActionRunRepair => '修復を実行';

  @override
  String get snackBarGamePathInvalid => '選択したフォルダは有効なゲームフォルダではないようです。';

  @override
  String get snackBar7zipPathInvalid => '選択したファイル名は 7z.exe である必要があります。';

  @override
  String get snackBarRepairStarted => 'レガシー MOD の修復プロセスが開始されました...';

  @override
  String snackBarRepairComplete(Object count) {
    return '修復が完了しました。$count 個の MOD が更新されました。';
  }

  @override
  String get snackBarRepairNoMods => '修復が必要なレガシー MOD は見つかりませんでした。';

  @override
  String get errorApiRequiredForRepair =>
      'ローカルバージョンがない MOD の最新バージョンを見つけるには API キーが必要です。';

  @override
  String get installNewMod => '新しい MOD のインストール';

  @override
  String get selectFiles => 'ファイルの選択';

  @override
  String get selectFolder => 'フォルダの選択';

  @override
  String get installSelectedMod => '選択した MOD のインストール';

  @override
  String get filesToInstall => 'インストールするファイル：';

  @override
  String get cancelSelection => '選択をキャンセル';

  @override
  String get searchMods => 'MOD を検索...';

  @override
  String get enabledMods => '有効な MOD';

  @override
  String get disabledMods => '無効な MOD';

  @override
  String get refreshList => 'リストを更新';

  @override
  String get noEnabledMods => '有効な MOD はありません。';

  @override
  String get noDisabledMods => '無効な MOD はありません。';

  @override
  String get showInFolder => 'フォルダに表示';

  @override
  String get disableMod => 'MOD を無効化';

  @override
  String get enableMod => 'MOD を有効化';

  @override
  String get deletePermanently => '完全に削除';

  @override
  String get language => '言語';

  @override
  String get selectLanguage => '言語を選択してください';

  @override
  String get statusSearchingGame => 'Stellar Blade のインストールを検索中...';

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
    return '有効な MOD $enabledCount 個、無効な MOD $disabledCount 個。';
  }

  @override
  String statusErrorReadingMods(Object error) {
    return 'インストールされている MOD の読み取り中にエラーが発生しました：$error';
  }

  @override
  String statusFilesSelected(Object count) {
    return '$count 個のファイルが選択されました。インストール準備完了です。';
  }

  @override
  String statusFolderSelected(Object folderName) {
    return 'フォルダ「$folderName」が選択されました。インストール準備完了です。';
  }

  @override
  String statusArchiveLoaded(Object count, Object fileName) {
    return 'ファイル「$fileName」が読み込まれました。$count 個のファイルがインストール準備完了です。';
  }

  @override
  String get statusSelectionCancelled =>
      '選択がキャンセルされました。インストールする新しい MOD を選択してください。';

  @override
  String get statusUpdateComplete => 'アップデートが完了しました。';

  @override
  String get statusInstallationComplete => 'インストールが完了しました。';

  @override
  String statusError(Object error) {
    return 'エラー：$error';
  }

  @override
  String get dialogTitle7zip => '7-Zip が必要です';

  @override
  String get dialogContent7zip =>
      'このファイルを解凍するには、アプリケーションに 7-Zip が必要です。\n\n公式サイトからインストールしてから、「確認」を押してください。';

  @override
  String get dialogContent7zipNotFound =>
      '7-Zip がまだ検出されていません。デフォルトのパスにインストールされていることを確認してから、もう一度お試しください。';

  @override
  String get dialogTitleCNSUpdate => 'メインシステムのアップデートを検出しました';

  @override
  String get dialogContentCNSUpdate =>
      '「Custom Nanosuit System」のアップデートが検出されました。\n\nこれにより、メインゲームフォルダ（StellarBlade\\SB）内のファイルが置き換えられます。続行しますか？';

  @override
  String get dialogTitleMultipleJsons => '複数の .json ファイルが検出されました';

  @override
  String dialogContentMultipleJsons(Object count) {
    return '$count 個の .json ファイルが検出されました。これは複数のコンポーネントを持つ MOD である可能性があります。\n\nこれらすべてを単一の MOD フォルダにまとめてインストールしますか？';
  }

  @override
  String get dialogTitleModExists => 'MOD はすでに存在します';

  @override
  String dialogContentModExists(Object modName) {
    return '「$modName」という名前の MOD はすでにインストールされています。\n\n更新しますか？新しいファイルをインストールする前に、古いファイルは削除されます。';
  }

  @override
  String dialogContentModUpdate(Object newModName, Object oldModName) {
    return '古いバージョン \'$oldModName\' が見つかりました。\n\n削除して \'$newModName\' に更新しますか？';
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
  String get dialogActionInstallAnyway => ' comunque インストール';

  @override
  String get dialogActionUpdate => '更新';

  @override
  String get dialogActionDelete => '削除';

  @override
  String get dialogActionClose => '閉じる';

  @override
  String snackBarBatchInstallComplete(Object failedCount, Object successCount) {
    return 'バッチインストールが完了しました。成功：$successCount、失敗：$failedCount。';
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
  String get snackBarCNSUpdated => 'Custom Nanosuit System が正常に更新されました。';

  @override
  String get snackBarApiKeySaved => 'API キーが正常に保存されました。';

  @override
  String get snackBarGamePathSaved => 'ゲームパスが正常に保存されました。';

  @override
  String get snackBar7zipPathSaved => '7-Zip パスが正常に保存されました。';

  @override
  String get snackBarSkippedVersionRemoved => 'スキップしたバージョンが削除されました。';

  @override
  String get dropTargetOverlay => 'ここに MOD をドロップしてください';

  @override
  String get pathSelectionTitle => 'Stellar Blade のパスが見つかりません';

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
  String get error7zipRequired => '操作がキャンセルされました：7-Zip が必要です。';

  @override
  String get errorGamePathUndefined => 'ゲームパスが定義されていません。';

  @override
  String get errorDestinationNotFound => 'ゲームの宛先フォルダが存在しません。';

  @override
  String errorUpdateSystem(Object error) {
    return 'システムの更新中にエラーが発生しました：$error';
  }

  @override
  String get errorInstallNoSelection => 'インストールするものが選択されていません。';

  @override
  String get errorInstallModExists => 'インストールがキャンセルされました：MOD はすでに存在します。';

  @override
  String get errorNoJsonFound => '各 MOD には少なくとも 1 つの .json ファイルが含まれている必要があります。';

  @override
  String errorInvalidJsonFormat(Object fileName) {
    return 'ファイル $fileName の JSON 形式が無効です。';
  }

  @override
  String errorNoDisplayName(Object fileName) {
    return 'ファイル $fileName は Custom Nanosuit System の MOD ではないようです（「DisplayName」がありません）。';
  }

  @override
  String get errorNoValidDisplayName =>
      '.json ファイルに有効な「DisplayName」が見つかりませんでした。';

  @override
  String errorEnableMod(Object error) {
    return 'MOD の有効化中にエラーが発生しました：$error';
  }

  @override
  String errorDisableMod(Object error) {
    return 'MOD の無効化中にエラーが発生しました：$error';
  }

  @override
  String errorDeleteMod(Object error) {
    return 'MOD の削除中にエラーが発生しました：$error';
  }

  @override
  String errorOpenFolder(Object path) {
    return 'フォルダを開けませんでした：$path';
  }

  @override
  String get statusUpdateSystemCancelled => 'システムの更新がキャンセルされました。';

  @override
  String get statusUpdatingCNS => 'Custom Nanosuit System を更新中...';

  @override
  String statusExtractingFile(Object fileName) {
    return '$fileName を展開中...';
  }

  @override
  String get statusInstallationCancelledByUser => 'ユーザーによってインストールがキャンセルされました。';

  @override
  String get errorNoCompatibleFilesInFolder =>
      '選択したフォルダには互換性のある MOD ファイルが含まれていません。';

  @override
  String get errorNoCompatibleFilesInArchive =>
      '圧縮ファイルには互換性のある MOD ファイルが含まれていません。';

  @override
  String get errorNoJsonInSelection => '選択範囲に有効な MOD .json ファイルが含まれていません。';

  @override
  String get aboutTitle => 'CNS Control Center について';

  @override
  String get aboutContent =>
      'このアプリケーションは、Custom Nanosuit System (CNS) で動作するように設計された Stellar Blade の MOD マネージャーです。\n\n要件：.rar および .7z ファイルを完全に機能させるには、システムに 7-Zip をインストールする必要があります。';

  @override
  String get aboutLinkText => '私のクリエイタープロフィールにアクセス';

  @override
  String get creatorProfileUrl =>
      'https://next.nexusmods.com/profile/LuisNandez?gameId=7804';

  @override
  String aboutVersion(Object version) {
    return 'バージョン：$version';
  }

  @override
  String get openModsFolder => 'MOD フォルダを開く';

  @override
  String get openInNexusMods => 'Nexus Mods で開く';

  @override
  String get checkForUpdates => 'アップデートを確認';

  @override
  String updateAvailable(Object version) {
    return 'アップデートが利用可能です：v$version';
  }

  @override
  String get dialogTitleApiKey => 'Nexus Mods API キー';

  @override
  String get dialogContentApiKey =>
      'MOD のアップデートを確認するには、Nexus Mods の個人用 API キーが必要です。';

  @override
  String get dialogContentApiKeyInstructions =>
      '1. Nexus Mods にアクセスしてログインします。\n2. アバターをクリックして「Site preferences」に移動します。\n3. 「API」タブに移動します。\n4. 「Generate a new API key」をクリックします。\n5. キーをコピーしてここに貼り付けます。';

  @override
  String get apiKey => 'API キー';

  @override
  String get apiKeyHintText => 'ここに API キーを貼り付けてください';

  @override
  String get dialogActionSave => '保存';

  @override
  String get apiKeyRemoved => 'API キーが削除されました。';

  @override
  String get invalidApiKeyError => '無効な API キーです。';

  @override
  String get validatingApiKey => '検証中...';

  @override
  String get errorApiKeyMissing =>
      'Nexus Mods の API キーが設定されていません。上部バーのキーアイコンから追加してください。';

  @override
  String get statusCheckingUpdates => 'MOD のアップデートを確認中...';

  @override
  String statusUpdatesFound(Object count) {
    return '$count 件のアップデートが見つかりました！';
  }

  @override
  String get statusNoUpdates => 'すべての MOD は最新です。';

  @override
  String get selectModArchive => 'MOD アーカイブを選択';

  @override
  String get viewImageGallery => '画像を表示';

  @override
  String get imageGallery => '画像ギャラリー';

  @override
  String get noImagesFound =>
      'この MOD の画像が見つかりませんでした。または API キーが入力されていません。API キーを入力してからアップデートを確認してください。';

  @override
  String errorFetchingImages(Object error) {
    return '画像の取得中にエラーが発生しました：$error';
  }

  @override
  String get imageMod => 'MOD 画像';

  @override
  String get dialogContentUpdateOptions => 'どうしますか？';

  @override
  String get dialogActionIgnoreVersion => '無視';

  @override
  String get dialogActionSkipVersion => 'バージョンをスキップ';

  @override
  String get dialogActionGoToDownloadPage => 'ダウンロードに移動';

  @override
  String get installedMods => 'インストール済みの MOD';

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
  String get noModsFound => 'MOD が見つかりません。';

  @override
  String statusExtractingMultipleFiles(
    Object count,
    Object fileName,
    Object total,
  ) {
    return '$total 件中 $count 件を展開中：$fileName';
  }

  @override
  String get previewInstallTitle => 'インストールされる MOD：';

  @override
  String get dialogTitleUE4SS => 'UE4SS のインストールが検出されました';

  @override
  String get dialogContentUE4SS =>
      'UE4SS ツールが検出されました。「StellarBlade\\SB\\Binaries\\Win64」にインストールしますか？\n\nこれは多くの MOD が動作するために必要です。';

  @override
  String get dialogActionInstallTool => 'ツールをインストール';

  @override
  String get statusUE4SSInstallCancelled => 'UE4SS のインストールがキャンセルされました。';

  @override
  String get statusInstallingUE4SS => 'UE4SS をインストール中...';

  @override
  String get snackBarUE4SSInstalled => 'UE4SS が正常にインストールされました。';

  @override
  String error7zipDecompression(Object error) {
    return '解凍中の 7-Zip エラー：$error';
  }

  @override
  String get statusUE4SSInstallComplete => 'UE4SS のインストールが完了しました。';

  @override
  String get dialogTitleAlternativeVersion => '代替バージョンが検出されました';

  @override
  String dialogContentAlternativeVersion(
    String oldModName,
    String baseModName,
    String newModName,
  ) {
    return 'この MOD の代替バージョンがすでにインストールされています：「$oldModName」。\n\n「$newModName」という名前の別の代替バージョンをインストールしようとしています。';
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
  String get dialogTitleReinstall => 'MOD を再インストール';

  @override
  String dialogContentReinstall(Object modName, Object version) {
    return 'MOD「$modName」のバージョン「$version」を再インストールしようとしています。';
  }

  @override
  String get dialogActionReinstall => '再インストール';

  @override
  String get editModNameTooltip => 'MOD 名を編集';

  @override
  String get dialogTitleEditModName => 'MOD 名を編集';

  @override
  String get dialogActionResetToDefault => 'Reset to Default';

  @override
  String get dialogLabelNewName => '新しい名前';

  @override
  String errorModNameExists(Object modName) {
    return '「$modName」という名前の MOD はすでに存在します。';
  }

  @override
  String get dialogTitleRepairedModWarning => '修復された MOD に関する警告';

  @override
  String get dialogContentRepairedModWarning =>
      'この MOD には正しいバージョン情報がない可能性があります。互換性を確保するために、最新バージョンを再インストールすることをお勧めします。';

  @override
  String get repairedModTooltip => '修復された MOD に関する情報';

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
