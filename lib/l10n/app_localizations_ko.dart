// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'CNS 제어 센터';

  @override
  String appTitleWithVersion(Object version) {
    return '커스텀 나노슈트 시스템 $version';
  }

  @override
  String get settings => '설정';

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
  String get installNewMod => '새 모드 설치';

  @override
  String get selectFiles => '파일 선택';

  @override
  String get selectFolder => '폴더 선택';

  @override
  String get installSelectedMod => '선택한 모드 설치';

  @override
  String get filesToInstall => '설치할 파일:';

  @override
  String get cancelSelection => '선택 취소';

  @override
  String get searchMods => '모드 검색...';

  @override
  String get enabledMods => '활성화된 모드';

  @override
  String get disabledMods => '비활성화된 모드';

  @override
  String get refreshList => '목록 새로고침';

  @override
  String get noEnabledMods => '활성화된 모드가 없습니다.';

  @override
  String get noDisabledMods => '비활성화된 모드가 없습니다.';

  @override
  String get showInFolder => '폴더에 표시';

  @override
  String get disableMod => '모드 비활성화';

  @override
  String get enableMod => '모드 활성화';

  @override
  String get deletePermanently => '영구적으로 삭제';

  @override
  String get language => '언어';

  @override
  String get selectLanguage => '언어 선택';

  @override
  String get statusSearchingGame => 'Stellar Blade 설치 경로 검색 중...';

  @override
  String get statusGamePathFound => '게임 경로를 찾았습니다!';

  @override
  String get statusGamePathNotFound => '게임 경로를 자동으로 찾을 수 없습니다.';

  @override
  String statusErrorFindingGame(Object error) {
    return '게임 검색 중 오류 발생: $error';
  }

  @override
  String statusModsFound(Object disabledCount, Object enabledCount) {
    return '$enabledCount개의 모드 활성화됨, $disabledCount개 비활성화됨.';
  }

  @override
  String statusErrorReadingMods(Object error) {
    return '설치된 모드를 읽는 중 오류 발생: $error';
  }

  @override
  String statusFilesSelected(Object count) {
    return '$count개의 파일이 선택되었습니다. 설치 준비 완료.';
  }

  @override
  String statusFolderSelected(Object folderName) {
    return '\"$folderName\" 폴더가 선택되었습니다. 설치 준비 완료.';
  }

  @override
  String statusArchiveLoaded(Object count, Object fileName) {
    return '\"$fileName\" 파일이 로드되었습니다. $count개의 파일을 설치할 준비가 되었습니다.';
  }

  @override
  String get statusSelectionCancelled => '선택이 취소되었습니다. 설치할 새 모드를 선택하세요.';

  @override
  String get statusUpdateComplete => '업데이트 완료.';

  @override
  String get statusInstallationComplete => '설치 완료.';

  @override
  String statusError(Object error) {
    return '오류: $error';
  }

  @override
  String get dialogTitle7zip => '7-Zip이 필요합니다';

  @override
  String get dialogContent7zip =>
      '이 파일의 압축을 해제하려면 7-Zip이 필요합니다.\n\n공식 페이지에서 설치한 후 \"확인\"을 누르십시오.';

  @override
  String get dialogContent7zipNotFound =>
      '7-Zip이 아직 감지되지 않았습니다. 기본 경로에 설치되었는지 확인하고 다시 시도하십시오.';

  @override
  String get dialogTitleCNSUpdate => '주요 시스템 업데이트 감지됨';

  @override
  String get dialogContentCNSUpdate =>
      '\"커스텀 나노슈트 시스템\"에 대한 업데이트가 감지되었습니다.\n\n메인 게임 폴더(StellarBlade\\SB)의 파일이 교체됩니다. 계속하시겠습니까?';

  @override
  String get dialogTitleMultipleJsons => '여러 .json 파일 감지됨';

  @override
  String dialogContentMultipleJsons(Object count) {
    return '$count개의 .json 파일이 감지되었습니다. 여러 구성 요소가 있는 모드일 수 있습니다.\n\n모두 단일 모드 폴더에 함께 설치하시겠습니까?';
  }

  @override
  String get dialogTitleModExists => '모드가 이미 존재합니다';

  @override
  String dialogContentModExists(Object modName) {
    return '\"$modName\"이라는 이름의 모드가 이미 설치되어 있습니다.\n\n업데이트하시겠습니까? 새 파일을 설치하기 전에 이전 파일이 삭제됩니다.';
  }

  @override
  String dialogContentModUpdate(Object newModName, Object oldModName) {
    return '이전 버전 \'$oldModName\'이(가) 발견되었습니다.\n\n제거하고 \'$newModName\'(으)로 업데이트하시겠습니까?';
  }

  @override
  String get dialogTitleDeleteMod => '영구적으로 삭제하시겠습니까?';

  @override
  String dialogContentDeleteMod(Object modName) {
    return '\"$modName\" 모드를 영구적으로 삭제하려고 합니다. 이 작업은 되돌릴 수 없습니다.\n\n확실합니까?';
  }

  @override
  String get dialogActionCancel => '취소';

  @override
  String get dialogActionGoToDownload => '다운로드 페이지로 이동';

  @override
  String get dialogActionConfirmInstallation => '설치 확인';

  @override
  String get dialogActionUpdateSystem => '시스템 업데이트';

  @override
  String get dialogActionInstallAnyway => '그래도 설치';

  @override
  String get dialogActionUpdate => '업데이트';

  @override
  String get dialogActionDelete => '삭제';

  @override
  String get dialogActionClose => '닫기';

  @override
  String snackBarBatchInstallComplete(Object failedCount, Object successCount) {
    return '일괄 설치 완료. 성공: $successCount, 실패: $failedCount.';
  }

  @override
  String snackBarModInstalled(Object modName) {
    return '\"$modName\" 모드가 성공적으로 설치되었습니다.';
  }

  @override
  String snackBarModEnabled(Object modName) {
    return '\"$modName\" 모드가 활성화되었습니다.';
  }

  @override
  String snackBarModDisabled(Object modName) {
    return '\"$modName\" 모드가 비활성화되었습니다.';
  }

  @override
  String snackBarModDeleted(Object modName) {
    return '\"$modName\" 모드가 영구적으로 삭제되었습니다.';
  }

  @override
  String get snackBarCNSUpdated => '커스텀 나노슈트 시스템이 성공적으로 업데이트되었습니다.';

  @override
  String get snackBarApiKeySaved => 'API 키가 성공적으로 저장되었습니다.';

  @override
  String get snackBarGamePathSaved => 'Game path saved successfully.';

  @override
  String get snackBar7zipPathSaved => '7-Zip path saved successfully.';

  @override
  String get snackBarSkippedVersionRemoved => 'Skipped version removed.';

  @override
  String get dropTargetOverlay => '여기에 모드를 드롭하세요';

  @override
  String get pathSelectionTitle => 'Stellar Blade 경로를 찾을 수 없습니다';

  @override
  String get pathSelectionButtonManual => '게임 폴더 수동 선택';

  @override
  String get pathSelectionButtonRetry => '재시도';

  @override
  String errorFolderSelection(Object error) {
    return '폴더 선택 중 오류 발생: $error';
  }

  @override
  String errorFileSelection(Object error) {
    return '파일 선택 중 오류 발생: $error';
  }

  @override
  String errorDecompressing(Object error) {
    return '파일 압축 해제 중 오류 발생: $error';
  }

  @override
  String errorProcessingArchive(Object error) {
    return '아카이브 처리 중 오류 발생: $error';
  }

  @override
  String errorUnsupportedFormat(Object extension) {
    return '지원되지 않는 파일 형식: $extension';
  }

  @override
  String get error7zipRequired => '작업이 취소되었습니다: 7-Zip이 필요합니다.';

  @override
  String get errorGamePathUndefined => '게임 경로가 정의되지 않았습니다.';

  @override
  String get errorDestinationNotFound => '게임의 대상 폴더가 없습니다.';

  @override
  String errorUpdateSystem(Object error) {
    return '시스템 업데이트 중 오류 발생: $error';
  }

  @override
  String get errorInstallNoSelection => '설치할 항목을 선택하지 않았습니다.';

  @override
  String get errorInstallModExists => '설치가 취소되었습니다: 모드가 이미 존재합니다.';

  @override
  String get errorNoJsonFound => '각 모드에는 최소한 하나의 .json 파일이 포함되어야 합니다.';

  @override
  String errorInvalidJsonFormat(Object fileName) {
    return '$fileName 파일의 JSON 형식이 잘못되었습니다.';
  }

  @override
  String errorNoDisplayName(Object fileName) {
    return '$fileName 파일은 커스텀 나노슈트 시스템 모드가 아닌 것 같습니다(\'DisplayName\' 없음).';
  }

  @override
  String get errorNoValidDisplayName =>
      '.json 파일에서 유효한 \"DisplayName\"을 찾을 수 없습니다.';

  @override
  String errorEnableMod(Object error) {
    return '모드 활성화 중 오류 발생: $error';
  }

  @override
  String errorDisableMod(Object error) {
    return '모드 비활성화 중 오류 발생: $error';
  }

  @override
  String errorDeleteMod(Object error) {
    return '모드 삭제 중 오류 발생: $error';
  }

  @override
  String errorOpenFolder(Object path) {
    return '폴더를 열 수 없습니다: $path';
  }

  @override
  String get statusUpdateSystemCancelled => '시스템 업데이트가 취소되었습니다.';

  @override
  String get statusUpdatingCNS => '커스텀 나노슈트 시스템 업데이트 중...';

  @override
  String statusExtractingFile(Object fileName) {
    return '$fileName 추출 중...';
  }

  @override
  String get statusInstallationCancelledByUser => '사용자가 설치를 취소했습니다.';

  @override
  String get errorNoCompatibleFilesInFolder => '선택한 폴더에 호환되는 모드 파일이 없습니다.';

  @override
  String get errorNoCompatibleFilesInArchive => '압축 파일에 호환되는 모드 파일이 없습니다.';

  @override
  String get errorNoJsonInSelection => '선택 항목에 유효한 모드 .json 파일이 없습니다.';

  @override
  String get aboutTitle => 'CNS 제어 센터 정보';

  @override
  String get aboutContent =>
      '이 애플리케이션은 Stellar Blade용 모드 관리자로, 커스텀 나노슈트 시스템(CNS)과 함께 작동하도록 설계되었습니다.\n\n요구 사항: .rar 및 .7z 파일을 완전히 사용하려면 시스템에 7-Zip이 설치되어 있어야 합니다.';

  @override
  String get aboutLinkText => '제작자 프로필 방문';

  @override
  String get creatorProfileUrl =>
      'https://next.nexusmods.com/profile/LuisNandez?gameId=7804';

  @override
  String aboutVersion(Object version) {
    return '버전: $version';
  }

  @override
  String get openModsFolder => '모드 폴더 열기';

  @override
  String get openInNexusMods => 'Nexus Mods에서 열기';

  @override
  String get checkForUpdates => '업데이트 확인';

  @override
  String updateAvailable(Object version) {
    return '업데이트 가능: v$version';
  }

  @override
  String get dialogTitleApiKey => 'Nexus Mods API 키';

  @override
  String get dialogContentApiKey =>
      '모드 업데이트를 확인하려면 Nexus Mods의 개인 API 키가 필요합니다.';

  @override
  String get dialogContentApiKeyInstructions =>
      '1. Nexus Mods로 이동하여 로그인합니다.\n2. 아바타를 클릭하고 \'사이트 환경설정\'으로 이동합니다.\n3. \'API\' 탭으로 이동합니다.\n4. \'새 API 키 생성\'을 클릭합니다.\n5. 키를 복사하여 여기에 붙여넣습니다.';

  @override
  String get apiKey => 'API 키';

  @override
  String get apiKeyHintText => '여기에 API 키를 붙여넣으세요';

  @override
  String get dialogActionSave => '저장';

  @override
  String get apiKeyRemoved => 'API 키가 제거되었습니다.';

  @override
  String get invalidApiKeyError => '잘못된 API 키입니다.';

  @override
  String get validatingApiKey => '확인 중...';

  @override
  String get errorApiKeyMissing =>
      'Nexus Mods API 키가 구성되지 않았습니다. 상단 바의 키 아이콘을 통해 추가하십시오.';

  @override
  String get statusCheckingUpdates => '모드 업데이트 확인 중...';

  @override
  String statusUpdatesFound(Object count) {
    return '$count개의 업데이트를 찾았습니다!';
  }

  @override
  String get statusNoUpdates => '모든 모드가 최신 버전입니다.';

  @override
  String get selectModArchive => '모드 아카이브 선택';

  @override
  String get viewImageGallery => '이미지 보기';

  @override
  String get imageGallery => '이미지 갤러리';

  @override
  String get noImagesFound =>
      '이 모드에 대한 이미지를 찾을 수 없거나 API 키가 입력되지 않았습니다. 키를 입력한 후 업데이트를 확인하십시오.';

  @override
  String errorFetchingImages(Object error) {
    return '이미지를 가져오는 중 오류 발생: $error';
  }

  @override
  String get imageMod => '모드 이미지';

  @override
  String get dialogContentUpdateOptions => '무엇을 하시겠습니까?';

  @override
  String get dialogActionIgnoreVersion => '버전 무시';

  @override
  String get dialogActionSkipVersion => 'Skip Version';

  @override
  String get dialogActionGoToDownloadPage => '다운로드로 이동';

  @override
  String get installedMods => '설치된 모드';

  @override
  String get filterBy => '필터:';

  @override
  String get sortBy => '정렬:';

  @override
  String get filterAll => '모두';

  @override
  String get filterEnabled => '활성화됨';

  @override
  String get filterDisabled => '비활성화됨';

  @override
  String get filterRepaired => 'Repaired';

  @override
  String get sortByName => '이름';

  @override
  String get sortByDate => '날짜';

  @override
  String get noModsFound => '모드를 찾을 수 없습니다.';

  @override
  String statusExtractingMultipleFiles(
    Object count,
    Object fileName,
    Object total,
  ) {
    return '$total 중 $count 추출 중: $fileName';
  }

  @override
  String get previewInstallTitle => '설치할 모드:';

  @override
  String get dialogTitleUE4SS => 'UE4SS 설치 감지됨';

  @override
  String get dialogContentUE4SS =>
      'UE4SS 도구가 감지되었습니다. \'StellarBlade\\SB\\Binaries\\Win64\'에 설치하시겠습니까?\n\n많은 모드가 작동하려면 이것이 필요합니다.';

  @override
  String get dialogActionInstallTool => '도구 설치';

  @override
  String get statusUE4SSInstallCancelled => 'UE4SS 설치가 취소되었습니다.';

  @override
  String get statusInstallingUE4SS => 'UE4SS 설치 중...';

  @override
  String get snackBarUE4SSInstalled => 'UE4SS가 성공적으로 설치되었습니다.';

  @override
  String error7zipDecompression(Object error) {
    return '압축 해제 중 7-Zip 오류: $error';
  }

  @override
  String get statusUE4SSInstallComplete => 'UE4SS 설치가 완료되었습니다.';

  @override
  String get dialogTitleAlternativeVersion => '대체 버전 감지됨';

  @override
  String dialogContentAlternativeVersion(
    String oldModName,
    String baseModName,
    String newModName,
  ) {
    return '이 모드의 대체 버전이 이미 설치되어 있습니다: \'$oldModName\'.\n\n\'$newModName\'이라는 다른 대체 버전을 설치하려고 합니다.';
  }

  @override
  String get dialogActionReplace => '교체';

  @override
  String get dialogActionInstallAsNew => '새로 설치';

  @override
  String get dialogTitleUpdate => '업데이트 가능';

  @override
  String dialogContentUpdate(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return '\'$modName\' 모드를 업데이트하려고 합니다.\n\n설치된 버전: $oldVersion\n새 버전: $newVersion';
  }

  @override
  String get dialogTitleDowngrade => '이전 버전 감지됨';

  @override
  String dialogContentDowngrade(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return '경고: \'$modName\' 모드의 이전 버전을 설치하려고 합니다.\n\n설치된 버전: $oldVersion\n설치할 버전: $newVersion';
  }

  @override
  String get dialogActionDowngrade => '다운그레이드';

  @override
  String get dialogTitleReinstall => '모드 재설치';

  @override
  String dialogContentReinstall(Object modName, Object version) {
    return '\'$modName\' 모드의 \'$version\' 버전을 재설치하려고 합니다.';
  }

  @override
  String get dialogActionReinstall => '재설치';
}
