// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'CNSコントロールセンター';

  @override
  String appTitleWithVersion(Object version) {
    return 'カスタムナノスーツシステム $version';
  }

  @override
  String get settings => '設定';

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
  String get installNewMod => '新しいMODをインストール';

  @override
  String get selectFiles => 'ファイルを選択';

  @override
  String get selectFolder => 'フォルダを選択';

  @override
  String get installSelectedMod => '選択したMODをインストール';

  @override
  String get filesToInstall => 'インストールするファイル:';

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
  String get selectLanguage => '言語を選択';

  @override
  String get statusSearchingGame => 'Stellar Bladeのインストールを検索中...';

  @override
  String get statusGamePathFound => 'ゲームパスが見つかりました！';

  @override
  String get statusGamePathNotFound => 'ゲームパスを自動的に見つけることができませんでした。';

  @override
  String statusErrorFindingGame(Object error) {
    return 'ゲームの検索中にエラーが発生しました: $error';
  }

  @override
  String statusModsFound(Object disabledCount, Object enabledCount) {
    return '$enabledCount個のMODが有効、$disabledCount個が無効です。';
  }

  @override
  String statusErrorReadingMods(Object error) {
    return 'インストールされたMODの読み取り中にエラーが発生しました: $error';
  }

  @override
  String statusFilesSelected(Object count) {
    return '$count個のファイルが選択されました。インストール準備完了です。';
  }

  @override
  String statusFolderSelected(Object folderName) {
    return 'フォルダ「$folderName」が選択されました。インストール準備完了です。';
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
    return 'エラー: $error';
  }

  @override
  String get dialogTitle7zip => '7-Zipが必要です';

  @override
  String get dialogContent7zip =>
      'このファイルを解凍するには、アプリケーションに7-Zipが必要です。\n\n公式サイトからインストールし、「確認」を押してください。';

  @override
  String get dialogContent7zipNotFound =>
      '7-Zipがまだ検出されていません。デフォルトのパスにインストールされていることを確認して、もう一度お試しください。';

  @override
  String get dialogTitleCNSUpdate => 'メインシステムのアップデートが検出されました';

  @override
  String get dialogContentCNSUpdate =>
      '「カスタムナノスーツシステム」のアップデートが検出されました。\n\nこれにより、メインゲームフォルダ（StellarBlade\\SB）のファイルが置き換えられます。続行しますか？';

  @override
  String get dialogTitleMultipleJsons => '複数の.jsonファイルが検出されました';

  @override
  String dialogContentMultipleJsons(Object count) {
    return '$count個の.jsonファイルが検出されました。これは複数のコンポーネントを持つMODかもしれません。\n\nすべてを1つのMODフォルダにまとめてインストールしますか？';
  }

  @override
  String get dialogTitleModExists => 'MODはすでに存在します';

  @override
  String dialogContentModExists(Object modName) {
    return '「$modName」という名前のMODはすでにインストールされています。\n\n更新しますか？古いファイルは新しいファイルをインストールする前に削除されます。';
  }

  @override
  String dialogContentModUpdate(Object newModName, Object oldModName) {
    return '古いバージョン\'$oldModName\'が見つかりました。\n\n削除して\'$newModName\'に更新しますか？';
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
  String get dialogActionGoToDownload => 'ダウンロードページへ';

  @override
  String get dialogActionConfirmInstallation => 'インストールを確認';

  @override
  String get dialogActionUpdateSystem => 'システムを更新';

  @override
  String get dialogActionInstallAnyway => ' trotzdem installieren';

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
  String get snackBarGamePathSaved => 'Game path saved successfully.';

  @override
  String get snackBar7zipPathSaved => '7-Zip path saved successfully.';

  @override
  String get snackBarSkippedVersionRemoved => 'Skipped version removed.';

  @override
  String get dropTargetOverlay => 'ここにMODをドラッグ＆ドロップ';

  @override
  String get pathSelectionTitle => 'Stellar Bladeのパスが見つかりません';

  @override
  String get pathSelectionButtonManual => 'ゲームフォルダを手動で選択';

  @override
  String get pathSelectionButtonRetry => '再試行';

  @override
  String errorFolderSelection(Object error) {
    return 'フォルダの選択中にエラーが発生しました: $error';
  }

  @override
  String errorFileSelection(Object error) {
    return 'ファイルの選択中にエラーが発生しました: $error';
  }

  @override
  String errorDecompressing(Object error) {
    return 'ファイルの解凍中にエラーが発生しました: $error';
  }

  @override
  String errorProcessingArchive(Object error) {
    return 'アーカイブの処理中にエラーが発生しました: $error';
  }

  @override
  String errorUnsupportedFormat(Object extension) {
    return 'サポートされていないファイル形式です: $extension';
  }

  @override
  String get error7zipRequired => '操作がキャンセルされました：7-Zipが必要です。';

  @override
  String get errorGamePathUndefined => 'ゲームパスが定義されていません。';

  @override
  String get errorDestinationNotFound => 'ゲームの宛先フォルダが存在しません。';

  @override
  String errorUpdateSystem(Object error) {
    return 'システムの更新中にエラーが発生しました: $error';
  }

  @override
  String get errorInstallNoSelection => 'インストールするものが選択されていません。';

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
    return 'ファイル$fileNameはカスタムナノスーツシステムのMODではないようです（「DisplayName」がありません）。';
  }

  @override
  String get errorNoValidDisplayName =>
      '.jsonファイルに有効な「DisplayName」が見つかりませんでした。';

  @override
  String errorEnableMod(Object error) {
    return 'MODの有効化中にエラーが発生しました: $error';
  }

  @override
  String errorDisableMod(Object error) {
    return 'MODの無効化中にエラーが発生しました: $error';
  }

  @override
  String errorDeleteMod(Object error) {
    return 'MODの削除中にエラーが発生しました: $error';
  }

  @override
  String errorOpenFolder(Object path) {
    return 'フォルダを開けませんでした: $path';
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
  String get statusInstallationCancelledByUser => 'ユーザーによってインストールがキャンセルされました。';

  @override
  String get errorNoCompatibleFilesInFolder =>
      '選択したフォルダに互換性のあるMODファイルが含まれていません。';

  @override
  String get errorNoCompatibleFilesInArchive =>
      '圧縮ファイルに互換性のあるMODファイルが含まれていません。';

  @override
  String get errorNoJsonInSelection => '選択範囲に有効なMODの.jsonファイルが含まれていません。';

  @override
  String get aboutTitle => 'CNSコントロールセンターについて';

  @override
  String get aboutContent =>
      'このアプリケーションは、カスタムナノスーツシステム（CNS）と連携するように設計されたStellar BladeのMODマネージャーです。\n\n要件：.rarおよび.7zファイルを完全に機能させるには、システムに7-Zipをインストールする必要があります。';

  @override
  String get aboutLinkText => '作成者のプロフィールを見る';

  @override
  String get creatorProfileUrl =>
      'https://next.nexusmods.com/profile/LuisNandez?gameId=7804';

  @override
  String aboutVersion(Object version) {
    return 'バージョン: $version';
  }

  @override
  String get openModsFolder => 'MODフォルダを開く';

  @override
  String get openInNexusMods => 'Nexus Modsで開く';

  @override
  String get checkForUpdates => 'アップデートを確認';

  @override
  String updateAvailable(Object version) {
    return 'アップデートがあります: v$version';
  }

  @override
  String get dialogTitleApiKey => 'Nexus Mods APIキー';

  @override
  String get dialogContentApiKey =>
      'MODのアップデートを確認するには、Nexus Modsの個人APIキーが必要です。';

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
      'Nexus ModsのAPIキーが設定されていません。トップバーのキーアイコンから追加してください。';

  @override
  String get statusCheckingUpdates => 'MODのアップデートを確認中...';

  @override
  String statusUpdatesFound(Object count) {
    return '$count件のアップデートが見つかりました！';
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
      'このMODの画像が見つからないか、APIキーが入力されていません。キーを入力してからアップデートを確認してください。';

  @override
  String errorFetchingImages(Object error) {
    return '画像の取得中にエラーが発生しました: $error';
  }

  @override
  String get imageMod => 'MOD画像';

  @override
  String get dialogContentUpdateOptions => 'どうしますか？';

  @override
  String get dialogActionIgnoreVersion => 'バージョンを無視';

  @override
  String get dialogActionSkipVersion => 'Skip Version';

  @override
  String get dialogActionGoToDownloadPage => 'ダウンロードへ';

  @override
  String get installedMods => 'インストール済みMOD';

  @override
  String get filterBy => 'フィルター:';

  @override
  String get sortBy => '並べ替え:';

  @override
  String get filterAll => 'すべて';

  @override
  String get filterEnabled => '有効';

  @override
  String get filterDisabled => '無効';

  @override
  String get filterRepaired => 'Repaired';

  @override
  String get sortByName => '名前';

  @override
  String get sortByDate => '日付';

  @override
  String get noModsFound => 'MODが見つかりません。';

  @override
  String statusExtractingMultipleFiles(
    Object count,
    Object fileName,
    Object total,
  ) {
    return '$total中$countを展開中: $fileName';
  }

  @override
  String get previewInstallTitle => 'インストールするMOD:';

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
    return '展開中の7-Zipエラー: $error';
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
    return 'このMODの代替バージョンはすでにインストールされています：\'$oldModName\'。\n\n\'$newModName\'という名前の別の代替バージョンをインストールしようとしています。';
  }

  @override
  String get dialogActionReplace => '置き換える';

  @override
  String get dialogActionInstallAsNew => '新規としてインストール';

  @override
  String get dialogTitleUpdate => 'アップデートがあります';

  @override
  String dialogContentUpdate(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return 'MOD \'$modName\' を更新しようとしています。\n\nインストール済みバージョン: $oldVersion\n新しいバージョン: $newVersion';
  }

  @override
  String get dialogTitleDowngrade => '古いバージョンが検出されました';

  @override
  String dialogContentDowngrade(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return '警告：MOD \'$modName\' の古いバージョンをインストールしようとしています。\n\nインストール済みバージョン: $oldVersion\nインストールするバージョン: $newVersion';
  }

  @override
  String get dialogActionDowngrade => 'ダウングレード';

  @override
  String get dialogTitleReinstall => 'MODを再インストール';

  @override
  String dialogContentReinstall(Object modName, Object version) {
    return 'MOD \'$modName\' のバージョン \'$version\' を再インストールしようとしています。';
  }

  @override
  String get dialogActionReinstall => '再インストール';
}
