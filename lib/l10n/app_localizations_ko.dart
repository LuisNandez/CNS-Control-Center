// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'CNS Control Center';

  @override
  String appTitleWithVersion(Object version) {
    return 'Custom Nanosuit System $version';
  }

  @override
  String get settings => '설정';

  @override
  String get settingsGeneral => '일반';

  @override
  String get settingsLanguage => '언어';

  @override
  String get settingsLanguageDesc => '애플리케이션 언어 선택';

  @override
  String get settingsAbout => '정보';

  @override
  String get settingsAboutDesc => '애플리케이션에 대한 정보';

  @override
  String get settingsPathsAndTools => '경로 및 도구';

  @override
  String get settingsGameFolder => '게임 폴더';

  @override
  String get settingsGameFolderDesc => 'Stellar Blade 설치의 루트 폴더입니다.';

  @override
  String get settings7zipPath => '7-Zip 경로';

  @override
  String get settings7zipPathDesc => '모드 추출을 위한 7z.exe 파일의 위치입니다.';

  @override
  String get settings7zipPathAuto => '자동 검색';

  @override
  String get settingsRepairMods => '레거시 모드 복구';

  @override
  String get settingsRepairModsDesc =>
      '로컬 데이터베이스를 사용하여 오래된 모드를 스캔하고 정보 파일을 생성합니다. API 키가 필요합니다.';

  @override
  String get settingsConnectivity => '연결 및 업데이트';

  @override
  String get settingsApiKey => 'Nexus Mods API 키';

  @override
  String get settingsApiKeyDesc => '모드 업데이트 확인에 필요합니다.';

  @override
  String get settingsApiKeySet => '설정됨';

  @override
  String get settingsApiKeyNotSet => '설정되지 않음';

  @override
  String get settingsSkippedVersions => '건너뛴 버전 관리';

  @override
  String get settingsSkippedVersionsDesc => '건너뛰기로 선택한 모드 버전을 관리합니다.';

  @override
  String settingsSkippedVersionsCount(Object count) {
    return '$count개 버전 건너뜀';
  }

  @override
  String get dialogTitleSkippedVersions => '건너뛴 모드 버전';

  @override
  String get dialogNoSkippedVersions => '건너뛴 모드 버전이 없습니다.';

  @override
  String get dialogSkippedVersions => '건너뛴 버전';

  @override
  String get dialogTitleRepairMods => '레거시 모드 복구를 실행하시겠습니까?';

  @override
  String get dialogContentRepairMods =>
      '경고: 이 기능은 개발 중이며 완벽하지 않을 수 있습니다.\n\n\'nexus_info.json\' 파일이 없는 모드를 스캔하고 로컬 데이터베이스에서 찾으면 해당 파일을 생성합니다. 또한 찾은 버전을 포함하도록 모드 폴더의 이름을 바꾸려고 시도합니다 (예: \'My Mod\' -> \'My Mod v1.2\').\n\n버전 우선순위:\n1. 폴더 이름에서\n2. 모드 설명 필드에서\n3. Nexus Mods의 최신 버전에서 (API 필요)\n\n계속하시겠습니까?';

  @override
  String get dialogActionRunRepair => '복구 실행';

  @override
  String get snackBarGamePathInvalid => '선택한 폴더가 유효한 게임 폴더가 아닌 것 같습니다.';

  @override
  String get snackBar7zipPathInvalid => '선택한 파일의 이름은 7z.exe여야 합니다.';

  @override
  String get snackBarRepairStarted => '레거시 모드 복구 프로세스가 시작되었습니다...';

  @override
  String snackBarRepairComplete(Object count) {
    return '복구 완료. $count개의 모드가 업데이트되었습니다.';
  }

  @override
  String get snackBarRepairNoMods => '복구가 필요한 레거시 모드를 찾을 수 없습니다.';

  @override
  String get errorApiRequiredForRepair =>
      '로컬 버전이 없는 모드의 최신 버전을 찾으려면 API 키가 필요합니다.';

  @override
  String get installNewMod => '모드 설치';

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
  String get deletePermanently => '영구 삭제';

  @override
  String get language => '언어';

  @override
  String get selectLanguage => '언어 선택';

  @override
  String get statusSearchingGame => 'Stellar Blade 설치를 검색하는 중...';

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
    return '설치된 모드 읽기 오류: $error';
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
    return '\"$fileName\" 파일이 로드되었습니다. $count개의 파일 설치 준비 완료.';
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
  String get dialogTitle7zip => '7-Zip 필요';

  @override
  String get dialogContent7zip =>
      '이 파일의 압축을 풀려면 애플리케이션에 7-Zip이 필요합니다.\n\n공식 페이지에서 설치한 다음 \"확인\"을 누르세요.';

  @override
  String get dialogContent7zipNotFound =>
      '7-Zip이 아직 감지되지 않았습니다. 기본 경로에 설치되었는지 확인하고 다시 시도하세요.';

  @override
  String get dialogTitleMultipleJsons => '여러 개의 .json 파일 감지됨';

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
    return '\"$modName\" 모드를 영구적으로 삭제하려고 합니다. 이 작업은 취소할 수 없습니다.\n\n확실합니까?';
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
  String get snackBarGamePathSaved => '게임 경로가 성공적으로 저장되었습니다.';

  @override
  String get snackBar7zipPathSaved => '7-Zip 경로가 성공적으로 저장되었습니다.';

  @override
  String get snackBarSkippedVersionRemoved => '건너뛴 버전이 제거되었습니다.';

  @override
  String get dropTargetOverlay => '여기에 모드 드롭';

  @override
  String get pathSelectionTitle => 'Stellar Blade 경로를 찾을 수 없음';

  @override
  String get pathSelectionButtonManual => '수동으로 게임 폴더 선택';

  @override
  String get pathSelectionButtonRetry => '다시 시도';

  @override
  String errorFolderSelection(Object error) {
    return '폴더 선택 오류: $error';
  }

  @override
  String errorFileSelection(Object error) {
    return '파일 선택 오류: $error';
  }

  @override
  String errorDecompressing(Object error) {
    return '파일 압축 해제 오류: $error';
  }

  @override
  String errorProcessingArchive(Object error) {
    return '파일 처리 오류: $error';
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
  String get errorDestinationNotFound => '게임의 대상 폴더가 존재하지 않습니다.';

  @override
  String errorUpdateSystem(Object error) {
    return '시스템 업데이트 오류: $error';
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
    return '$fileName 파일은 커스텀 나노슈트 시스템 모드가 아닌 것 같습니다(\"DisplayName\" 누락).';
  }

  @override
  String get errorNoValidDisplayName =>
      '.json 파일에서 유효한 \"DisplayName\"을 찾을 수 없습니다.';

  @override
  String errorEnableMod(Object error) {
    return '모드 활성화 오류: $error';
  }

  @override
  String errorDisableMod(Object error) {
    return '모드 비활성화 오류: $error';
  }

  @override
  String errorDeleteMod(Object error) {
    return '모드 삭제 오류: $error';
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
      '이 애플리케이션은 커스텀 나노슈트 시스템(CNS)과 함께 작동하도록 설계된 Stellar Blade용 모드 관리자입니다.\n\n요구 사항: .rar 및 .7z 파일의 모든 기능을 사용하려면 시스템에 7-Zip이 설치되어 있어야 합니다.';

  @override
  String get aboutLinkText => '내 제작자 프로필 방문';

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
    return '사용 가능한 업데이트: v$version';
  }

  @override
  String get dialogTitleApiKey => 'Nexus Mods API 키';

  @override
  String get dialogContentApiKey =>
      '모드 업데이트를 확인하려면 Nexus Mods의 개인 API 키가 필요합니다.';

  @override
  String get dialogContentApiKeyInstructions =>
      '1. Nexus Mods로 이동하여 로그인합니다.\n2. 아바타를 클릭하고 \'사이트 기본 설정\'으로 이동합니다.\n3. \'API\' 탭으로 이동합니다.\n4. \'새 API 키 생성\'을 클릭합니다.\n5. 키를 복사하여 여기에 붙여넣습니다.';

  @override
  String get apiKey => 'API 키';

  @override
  String get apiKeyHintText => '여기에 API 키 붙여넣기';

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
  String get viewImageGallery => '이미지 갤러리 보기';

  @override
  String get imageGallery => '이미지 갤러리';

  @override
  String get noImagesFound =>
      '이 모드의 이미지를 찾을 수 없거나 API 키가 입력되지 않았습니다. API 키를 입력한 후 업데이트를 확인하십시오.';

  @override
  String errorFetchingImages(Object error) {
    return '이미지 가져오기 오류: $error';
  }

  @override
  String get imageMod => '모드 이미지';

  @override
  String get modEnabledBadge => '활성화됨';

  @override
  String get modDisabledBadge => '비활성화됨';

  @override
  String get modCategoryOther => '지정되지 않음';

  @override
  String get dialogContentUpdateOptions => '무엇을 하시겠습니까?';

  @override
  String get dialogActionIgnoreVersion => '무시';

  @override
  String get dialogActionSkipVersion => '버전 건너뛰기';

  @override
  String get dialogActionGoToDownloadPage => '다운로드로 이동';

  @override
  String get installedMods => '설치된 모드';

  @override
  String get filterBy => '필터:';

  @override
  String get sortBy => '정렬 기준:';

  @override
  String get filterAll => '모두';

  @override
  String get filterEnabled => '활성화됨';

  @override
  String get filterDisabled => '비활성화됨';

  @override
  String get filterRepaired => '복구됨';

  @override
  String get sortByName => '이름';

  @override
  String get sortByDate => '날짜';

  @override
  String get noModsFound => '모드를 찾을 수 없습니다.';

  @override
  String get viewTypeGrid => '그리드 보기';

  @override
  String get viewTypeList => '목록 보기';

  @override
  String statusExtractingMultipleFiles(
    Object count,
    Object fileName,
    Object total,
  ) {
    return '$total개 중 $count개 추출 중: $fileName';
  }

  @override
  String get previewInstallTitle => '설치될 모드:';

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
  String get statusUE4SSInstallComplete => 'UE4SS 설치 완료.';

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
  String get dialogTitleReinstall => '모드 재설치';

  @override
  String dialogContentReinstall(Object modName, Object version) {
    return '\'$modName\' 모드의 \'$version\' 버전을 다시 설치하려고 합니다.';
  }

  @override
  String get dialogActionReinstall => '재설치';

  @override
  String get editModNameTooltip => '모드 이름 편집';

  @override
  String get setCoverTooltip => '사용자 지정 표지 이미지 설정';

  @override
  String get setCoverText => '표지 설정';

  @override
  String get restoreOriginalCoverText => '원래 표지 복원';

  @override
  String errorSavingCoverText(Object error) {
    return '표지 이미지 저장 오류: $error';
  }

  @override
  String errorRestoringCoverText(Object error) {
    return '원래 표지 이미지 복원 오류: $error';
  }

  @override
  String get editVersionText => '버전 편집';

  @override
  String get customVersionText => '사용자 지정 버전';

  @override
  String get editTagText => '태그 편집';

  @override
  String get customTagText => '사용자 지정 태그';

  @override
  String get dialogTitleEditModName => '모드 이름 편집';

  @override
  String get dialogActionResetToDefault => '기본값으로 재설정';

  @override
  String get dialogLabelNewName => '새 이름';

  @override
  String errorModNameExists(Object modName) {
    return '\"$modName\"이라는 이름의 모드가 이미 존재합니다.';
  }

  @override
  String get dialogTitleRepairedModWarning => '복구된 모드 경고';

  @override
  String get dialogContentRepairedModWarning =>
      '이 모드에 올바른 버전 정보가 없을 수 있습니다. 호환성을 보장하기 위해 최신 버전을 다시 설치하는 것이 좋습니다.';

  @override
  String get repairedModTooltip => '복구된 모드에 대한 정보';

  @override
  String get disableAllModsTooltip => '모든 모드 비활성화';

  @override
  String get deleteAllModsTooltip => '비활성화된 모든 모드 삭제';

  @override
  String get dialogTitleDisableAll => '모든 모드를 비활성화하시겠습니까?';

  @override
  String dialogContentDisableAll(int count) {
    return '활성화된 $count개의 모든 모드를 비활성화하시겠습니까? 백업 폴더로 이동됩니다.';
  }

  @override
  String get dialogTitleDeleteAll => '비활성화된 모드를 삭제하시겠습니까?';

  @override
  String dialogContentDeleteAll(int count) {
    return '비활성화된 $count개의 모든 모드를 영구적으로 삭제하려고 합니다. 이 작업은 취소할 수 없습니다.\n\n확실합니까?';
  }

  @override
  String snackBarAllModsDisabled(int count) {
    return '활성화된 $count개의 모든 모드가 비활성화되었습니다.';
  }

  @override
  String snackBarAllModsDeleted(int count) {
    return '비활성화된 $count개의 모든 모드가 영구적으로 삭제되었습니다.';
  }

  @override
  String get snackBarNoModsToDisable => '비활성화할 활성화된 모드가 없습니다.';

  @override
  String get snackBarNoModsToDelete => '삭제할 비활성화된 모드가 없습니다.';

  @override
  String get enableAllModsTooltip => '모든 모드 활성화';

  @override
  String get dialogTitleEnableAll => '모든 모드를 활성화하시겠습니까?';

  @override
  String dialogContentEnableAll(int count) {
    return '비활성화된 $count개의 모든 모드를 활성화하시겠습니까? 주 모드 폴더로 이동됩니다.';
  }

  @override
  String snackBarAllModsEnabled(int count) {
    return '비활성화된 $count개의 모든 모드가 활성화되었습니다.';
  }

  @override
  String get snackBarNoModsToEnable => '활성화할 비활성화된 모드가 없습니다.';

  @override
  String get editNotes => '메모 편집';

  @override
  String get notesHintText => '여기에 개인 메모 추가...';

  @override
  String get modAuthor => '제작자';

  @override
  String get modSummary => 'Summary';

  @override
  String get modDescription => '설명';

  @override
  String get noDescriptionAvailable => '설명 없음.';

  @override
  String get personalNotes => '개인 메모';

  @override
  String get noNotesAvailable => '아직 추가된 메모 없음.';

  @override
  String get modDetailsTitle => '모드 세부 정보';

  @override
  String get modVersion => '버전';

  @override
  String get modCategory => '카테고리';

  @override
  String get dialogTitleAddUrl => '모드 링크 추가';

  @override
  String get dialogLabelUrl => '모드 URL';

  @override
  String get errorInvalidUrl => '유효한 URL을 입력하십시오.';

  @override
  String get addLinkTooltip => '이 모드의 다운로드 링크 추가';

  @override
  String get addLinkButtonText => '링크 추가';

  @override
  String get openLinkButtonText => '링크 열기';

  @override
  String get editModTitle => '모드 세부 정보 편집';

  @override
  String get modNameLabel => '모드 이름';

  @override
  String get authorLabel => '제작자';

  @override
  String get summaryLabel => '설명 / 요약';

  @override
  String get notesLabel => '개인 메모';

  @override
  String get urlLabel => '다운로드 URL';

  @override
  String get changeCoverButton => '표지 이미지 변경';

  @override
  String get editButtonTooltip => '모드 편집';

  @override
  String get errorSavingNotes => '메모 저장 오류';

  @override
  String get errorSavingUrl => 'URL 저장 오류';

  @override
  String get errorSavingChanges => '변경 사항 저장 오류';

  @override
  String get errorTranslation => '설명을 번역할 수 없습니다';

  @override
  String get translateSummary => 'Translate summary';

  @override
  String get translateDescription => '설명 번역';

  @override
  String get dialogTitleUE4SSReinstall => 'UE4SS 재설치';

  @override
  String get dialogContentUE4SSReinstall =>
      'UE4SS가 이미 설치된 것 같습니다. 기존 설치를 덮어쓰시겠습니까? 파일이 손상되었다고 의심되는 경우 유용할 수 있습니다.';

  @override
  String get dialogTitleCNSReinstall => 'CNS 시스템 재설치';

  @override
  String get dialogContentCNSReinstall =>
      '주 CNS 시스템이 이미 설치된 것 같습니다. 다시 설치하시겠습니까? 기존 모드에는 영향을 미치지 않습니다.';

  @override
  String dialogTitleUninstall(Object componentName) {
    return '$componentName 제거';
  }

  @override
  String dialogContentUninstall(Object componentName) {
    return '$componentName을(를) 제거하시겠습니까? 이 작업은 핵심 구성 요소 파일을 제거하지만 설치된 모드에는 영향을 미치지 않습니다.';
  }

  @override
  String get dialogActionUninstall => '예, 제거합니다';

  @override
  String statusUninstalling(Object componentName) {
    return '$componentName 제거 중...';
  }

  @override
  String snackBarUninstalled(Object componentName) {
    return '$componentName이(가) 성공적으로 제거되었습니다';
  }

  @override
  String errorUninstalling(Object componentName) {
    return '$componentName 제거 오류';
  }

  @override
  String get settingsCoreComponents => '핵심 구성 요소';

  @override
  String get installedStatus => '설치됨';

  @override
  String get notInstalledStatus => '감지되지 않음';

  @override
  String get uninstallButton => '제거';

  @override
  String get cnsCoreSystem => '커스텀 나노슈트 시스템';

  @override
  String get ue4ssInstallationDetected => '기존 UE4SS 설치가 감지되어 채택되었습니다';

  @override
  String get cnsInstallationDetected => '기존 주 CNS 설치가 감지되어 채택되었습니다';

  @override
  String get ue4ssRequiredTitle => 'UE4SS 필요';

  @override
  String get ue4ssRequiredContent =>
      '주 CNS 시스템을 설치하려면 먼저 UE4SS를 설치해야 합니다. 다음 링크에서 다운로드할 수 있습니다:';

  @override
  String get uninstallDependencyTitle => '종속성 감지됨';

  @override
  String get uninstallDependencyContent =>
      'CNS가 UE4SS에 의존하므로 UE4SS를 제거하기 전에 주 CNS 시스템을 제거해야 합니다.';

  @override
  String get dialogActionUnderstood => '이해했습니다';

  @override
  String get appTitleNoCns => '커스텀 나노슈트 시스템 (설치되지 않음)';

  @override
  String get dialogTitleCNSUpdate => '주 CNS 시스템 업데이트';

  @override
  String dialogContentCNSUpdate(Object oldVersion, Object newVersion) {
    return '$oldVersion 버전에서 새 버전 $newVersion(으)로 CNS를 업데이트하려고 합니다. 계속하시겠습니까?';
  }

  @override
  String get dialogTitleCNSDowngrade => 'CNS 버전 다운그레이드';

  @override
  String dialogContentCNSDowngrade(Object oldVersion, Object newVersion) {
    return '경고! 현재 버전($oldVersion)보다 이전 버전의 CNS($newVersion)를 설치하려고 합니다. 문제가 발생할 수 있습니다. 확실합니까?';
  }

  @override
  String dialogContentCNSReinstallVersion(Object version) {
    return '이미 CNS 버전 $version이(가) 설치되어 있습니다. 그래도 파일을 다시 설치하시겠습니까?';
  }

  @override
  String get dialogActionUpdate => '업데이트';

  @override
  String get dialogActionDowngrade => '다운그레이드';

  @override
  String get dialogTitleCNSInstall => '주 CNS 시스템 설치';

  @override
  String get dialogContentCNSInstall =>
      '기본 커스텀 나노슈트 시스템(CNS)을 설치하려고 합니다. CNS 모드가 작동하려면 이것이 필요합니다. 계속하시겠습니까?';

  @override
  String get dialogActionInstall => '설치';

  @override
  String get settingsDeveloperOptions => '개발자 옵션';

  @override
  String get devDeleteNexusInfoTitle => '모든 nexus_info.json 파일 삭제';

  @override
  String get devDeleteNexusInfoDesc =>
      '모든 모드에서 모든 관리자 메타데이터 파일을 제거합니다. 전체 복구를 강제하는 데 유용합니다.';

  @override
  String get devExtractIdsTitle => '식별자 추출';

  @override
  String get devExtractIdsDesc =>
      '각 모드의 displayName 및 nexusId를 포함하는 \'ID Mods.json\'이라는 이름의 파일을 바탕 화면에 만듭니다.';

  @override
  String get devConfirmDeleteTitle => '삭제 확인';

  @override
  String get devConfirmDeleteDesc =>
      '모든 nexus_info.json 파일을 영구적으로 삭제하시겠습니까? 그러면 모든 사용자 지정 이름, 표지 및 메타데이터가 제거됩니다. 이 작업은 취소할 수 없습니다.';

  @override
  String get devDeleteSuccessTitle => '삭제 완료';

  @override
  String devDeleteSuccessDesc(Object count) {
    return '$count개의 nexus_info.json 파일을 성공적으로 삭제했습니다.';
  }

  @override
  String get devConfirmExtractTitle => '추출 확인';

  @override
  String get devConfirmExtractDesc =>
      '모든 모드를 스캔하고 바탕 화면에 \'ID Mods.json\'을 만듭니다. 같은 이름의 기존 파일을 덮어씁니다. 계속하시겠습니까?';

  @override
  String get devExtractAction => '추출';

  @override
  String get devExtractNoData => '추출할 유효한 식별자가 있는 모드를 찾을 수 없습니다.';

  @override
  String get devExtractDesktopNotFound => '오류: 바탕 화면 디렉터리를 찾을 수 없습니다.';

  @override
  String get devExtractSuccessTitle => '추출 완료';

  @override
  String devExtractSuccessDesc(Object path) {
    return '파일이 성공적으로 생성되었습니다: $path';
  }

  @override
  String get errorDialogTitle => '오류 발생';

  @override
  String get modDetailsCategory => '카테고리';

  @override
  String get modDetailsAuthor => '제작자';

  @override
  String get modDetailsNexusId => 'Nexus ID';

  @override
  String get modDetailsInstalledOn => '설치 날짜';

  @override
  String get unknownAuthor => '알 수 없음';

  @override
  String get statusInstalling => '설치 중...';

  @override
  String statusInstallingMod(int index, int total, String modName) {
    return '$total개 중 $index개 설치 중: $modName';
  }

  @override
  String byText(Object author) {
    return '제작자: $author';
  }

  @override
  String get filterUpdatesAvailable => '사용 가능한 업데이트';

  @override
  String snackBarUpdateIgnored(String modName) {
    return '이번 세션에서 \'$modName\'의 업데이트를 무시했습니다.';
  }

  @override
  String snackBarVersionSkipped(String modName, String version) {
    return '앞으로 \'$modName\'의 \'$version\' 버전은 건너뜁니다.';
  }

  @override
  String statusUpdatingMetadata(String displayName, int arg1, int arg2) {
    return '\'$displayName\'의 메타데이터 업데이트 중($arg1/$arg2)...';
  }

  @override
  String genericModInstallTitle(String modName) {
    return 'Generic Mod Installed: $modName';
  }

  @override
  String genericModInstallDesc(String path) {
    return 'Installed to $path. This mod is not managed by the app and must be uninstalled manually.';
  }

  @override
  String genericModInstallError(String modName) {
    return 'Failed to install generic mod: $modName';
  }

  @override
  String get modTypeCNS => 'CNS';

  @override
  String get modTypeGeneric => 'Generic';

  @override
  String get modTypeMovies => 'Movies';

  @override
  String get replacesOutfitTitle => 'Replaces Outfit';

  @override
  String get replacesOutfitClearTooltip => 'Clear outfit selection';

  @override
  String get replacesOutfitSelectTooltip => 'Select outfit to replace';

  @override
  String get replacesOutfitNone =>
      'No outfit selected. The tag will be \'Generic\'.';

  @override
  String get replacesOutfitSearchHint => 'Search outfits...';

  @override
  String get modTypeReplacement => 'Replacement';

  @override
  String get replacesOutfitHover => 'Hover over an outfit to see a preview.';
}
