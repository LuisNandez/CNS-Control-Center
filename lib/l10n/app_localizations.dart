import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'CNS Control Center'**
  String get appTitle;

  /// No description provided for @appTitleWithVersion.
  ///
  /// In en, this message translates to:
  /// **'Custom Nanosuit System {version}'**
  String appTitleWithVersion(Object version);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose the application language'**
  String get settingsLanguageDesc;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsAboutDesc.
  ///
  /// In en, this message translates to:
  /// **'Information about the application'**
  String get settingsAboutDesc;

  /// No description provided for @settingsPathsAndTools.
  ///
  /// In en, this message translates to:
  /// **'Paths & Tools'**
  String get settingsPathsAndTools;

  /// No description provided for @settingsGameFolder.
  ///
  /// In en, this message translates to:
  /// **'Game Folder'**
  String get settingsGameFolder;

  /// No description provided for @settingsGameFolderDesc.
  ///
  /// In en, this message translates to:
  /// **'The root folder of your Stellar Blade installation.'**
  String get settingsGameFolderDesc;

  /// No description provided for @settings7zipPath.
  ///
  /// In en, this message translates to:
  /// **'7-Zip Path'**
  String get settings7zipPath;

  /// No description provided for @settings7zipPathDesc.
  ///
  /// In en, this message translates to:
  /// **'The location of the 7z.exe file for extracting mods.'**
  String get settings7zipPathDesc;

  /// No description provided for @settings7zipPathAuto.
  ///
  /// In en, this message translates to:
  /// **'Automatic search'**
  String get settings7zipPathAuto;

  /// No description provided for @settingsRepairMods.
  ///
  /// In en, this message translates to:
  /// **'Repair Legacy Mods'**
  String get settingsRepairMods;

  /// No description provided for @settingsRepairModsDesc.
  ///
  /// In en, this message translates to:
  /// **'Scans and creates info files for old mods using the local database. Requires API key.'**
  String get settingsRepairModsDesc;

  /// No description provided for @settingsConnectivity.
  ///
  /// In en, this message translates to:
  /// **'Connectivity & Updates'**
  String get settingsConnectivity;

  /// No description provided for @settingsApiKey.
  ///
  /// In en, this message translates to:
  /// **'Nexus Mods API Key'**
  String get settingsApiKey;

  /// No description provided for @settingsApiKeyDesc.
  ///
  /// In en, this message translates to:
  /// **'Required for checking mod updates.'**
  String get settingsApiKeyDesc;

  /// No description provided for @settingsApiKeySet.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get settingsApiKeySet;

  /// No description provided for @settingsApiKeyNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get settingsApiKeyNotSet;

  /// No description provided for @settingsSkippedVersions.
  ///
  /// In en, this message translates to:
  /// **'Manage Skipped Versions'**
  String get settingsSkippedVersions;

  /// No description provided for @settingsSkippedVersionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage mod versions you have chosen to skip.'**
  String get settingsSkippedVersionsDesc;

  /// No description provided for @settingsSkippedVersionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} versions skipped'**
  String settingsSkippedVersionsCount(Object count);

  /// No description provided for @dialogTitleSkippedVersions.
  ///
  /// In en, this message translates to:
  /// **'Skipped Mod Versions'**
  String get dialogTitleSkippedVersions;

  /// No description provided for @dialogNoSkippedVersions.
  ///
  /// In en, this message translates to:
  /// **'You have not skipped any mod versions.'**
  String get dialogNoSkippedVersions;

  /// No description provided for @dialogSkippedVersions.
  ///
  /// In en, this message translates to:
  /// **'Skipped Version'**
  String get dialogSkippedVersions;

  /// No description provided for @dialogTitleRepairMods.
  ///
  /// In en, this message translates to:
  /// **'Run Legacy Mod Repair?'**
  String get dialogTitleRepairMods;

  /// No description provided for @dialogContentRepairMods.
  ///
  /// In en, this message translates to:
  /// **'Warning: This feature is in development and may not be perfect.\n\nIt will scan mods without a \'nexus_info.json\' file and, if found in your local database, create one for them. It will also attempt to rename the mod\'s folder to include the found version (e.g., \'My Mod\' -> \'My Mod v1.2\').\n\nVersion Priority:\n1. From the folder name.\n2. From the mod\'s description field.\n3. From the latest version on Nexus Mods (requires API).\n\nDo you want to continue?'**
  String get dialogContentRepairMods;

  /// No description provided for @dialogActionRunRepair.
  ///
  /// In en, this message translates to:
  /// **'Run Repair'**
  String get dialogActionRunRepair;

  /// No description provided for @snackBarGamePathInvalid.
  ///
  /// In en, this message translates to:
  /// **'The selected folder does not appear to be a valid game folder.'**
  String get snackBarGamePathInvalid;

  /// No description provided for @snackBar7zipPathInvalid.
  ///
  /// In en, this message translates to:
  /// **'The selected file must be named 7z.exe.'**
  String get snackBar7zipPathInvalid;

  /// No description provided for @snackBarRepairStarted.
  ///
  /// In en, this message translates to:
  /// **'Legacy mod repair process has started...'**
  String get snackBarRepairStarted;

  /// No description provided for @snackBarRepairComplete.
  ///
  /// In en, this message translates to:
  /// **'Repair complete. {count} mod(s) were updated.'**
  String snackBarRepairComplete(Object count);

  /// No description provided for @snackBarRepairNoMods.
  ///
  /// In en, this message translates to:
  /// **'No legacy mods were found that needed repairing.'**
  String get snackBarRepairNoMods;

  /// No description provided for @errorApiRequiredForRepair.
  ///
  /// In en, this message translates to:
  /// **'API Key is required to find the latest version for mods without a local version.'**
  String get errorApiRequiredForRepair;

  /// No description provided for @installNewMod.
  ///
  /// In en, this message translates to:
  /// **'Install New Mod'**
  String get installNewMod;

  /// No description provided for @selectFiles.
  ///
  /// In en, this message translates to:
  /// **'Select Files'**
  String get selectFiles;

  /// No description provided for @selectFolder.
  ///
  /// In en, this message translates to:
  /// **'Select Folder'**
  String get selectFolder;

  /// No description provided for @installSelectedMod.
  ///
  /// In en, this message translates to:
  /// **'Install Selected Mod'**
  String get installSelectedMod;

  /// No description provided for @filesToInstall.
  ///
  /// In en, this message translates to:
  /// **'Files to Install:'**
  String get filesToInstall;

  /// No description provided for @cancelSelection.
  ///
  /// In en, this message translates to:
  /// **'Cancel Selection'**
  String get cancelSelection;

  /// No description provided for @searchMods.
  ///
  /// In en, this message translates to:
  /// **'Search mods...'**
  String get searchMods;

  /// No description provided for @enabledMods.
  ///
  /// In en, this message translates to:
  /// **'Enabled Mods'**
  String get enabledMods;

  /// No description provided for @disabledMods.
  ///
  /// In en, this message translates to:
  /// **'Disabled Mods'**
  String get disabledMods;

  /// No description provided for @refreshList.
  ///
  /// In en, this message translates to:
  /// **'Refresh list'**
  String get refreshList;

  /// No description provided for @noEnabledMods.
  ///
  /// In en, this message translates to:
  /// **'No enabled mods.'**
  String get noEnabledMods;

  /// No description provided for @noDisabledMods.
  ///
  /// In en, this message translates to:
  /// **'No disabled mods.'**
  String get noDisabledMods;

  /// No description provided for @showInFolder.
  ///
  /// In en, this message translates to:
  /// **'Show in folder'**
  String get showInFolder;

  /// No description provided for @disableMod.
  ///
  /// In en, this message translates to:
  /// **'Disable mod'**
  String get disableMod;

  /// No description provided for @enableMod.
  ///
  /// In en, this message translates to:
  /// **'Enable mod'**
  String get enableMod;

  /// No description provided for @deletePermanently.
  ///
  /// In en, this message translates to:
  /// **'Delete permanently'**
  String get deletePermanently;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select a language'**
  String get selectLanguage;

  /// No description provided for @statusSearchingGame.
  ///
  /// In en, this message translates to:
  /// **'Searching for Stellar Blade installation...'**
  String get statusSearchingGame;

  /// No description provided for @statusGamePathFound.
  ///
  /// In en, this message translates to:
  /// **'Game path found!'**
  String get statusGamePathFound;

  /// No description provided for @statusGamePathNotFound.
  ///
  /// In en, this message translates to:
  /// **'Could not find the game path automatically.'**
  String get statusGamePathNotFound;

  /// No description provided for @statusErrorFindingGame.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while searching for the game: {error}'**
  String statusErrorFindingGame(Object error);

  /// No description provided for @statusModsFound.
  ///
  /// In en, this message translates to:
  /// **'{enabledCount} mod(s) enabled, {disabledCount} disabled.'**
  String statusModsFound(Object disabledCount, Object enabledCount);

  /// No description provided for @statusErrorReadingMods.
  ///
  /// In en, this message translates to:
  /// **'Error reading installed mods: {error}'**
  String statusErrorReadingMods(Object error);

  /// No description provided for @statusFilesSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} file(s) selected. Ready to install.'**
  String statusFilesSelected(Object count);

  /// No description provided for @statusFolderSelected.
  ///
  /// In en, this message translates to:
  /// **'Folder \"{folderName}\" selected. Ready to install.'**
  String statusFolderSelected(Object folderName);

  /// No description provided for @statusArchiveLoaded.
  ///
  /// In en, this message translates to:
  /// **'File \"{fileName}\" loaded. {count} file(s) ready to install.'**
  String statusArchiveLoaded(Object count, Object fileName);

  /// No description provided for @statusSelectionCancelled.
  ///
  /// In en, this message translates to:
  /// **'Selection cancelled. Choose a new mod to install.'**
  String get statusSelectionCancelled;

  /// No description provided for @statusUpdateComplete.
  ///
  /// In en, this message translates to:
  /// **'Update complete.'**
  String get statusUpdateComplete;

  /// No description provided for @statusInstallationComplete.
  ///
  /// In en, this message translates to:
  /// **'Installation complete.'**
  String get statusInstallationComplete;

  /// No description provided for @statusError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String statusError(Object error);

  /// No description provided for @dialogTitle7zip.
  ///
  /// In en, this message translates to:
  /// **'7-Zip is Required'**
  String get dialogTitle7zip;

  /// No description provided for @dialogContent7zip.
  ///
  /// In en, this message translates to:
  /// **'To decompress this file, the application needs 7-Zip.\n\nPlease install it from its official page and then press \"Confirm\".'**
  String get dialogContent7zip;

  /// No description provided for @dialogContent7zipNotFound.
  ///
  /// In en, this message translates to:
  /// **'7-Zip has not been detected yet. Please make sure it is installed in the default path and try again.'**
  String get dialogContent7zipNotFound;

  /// No description provided for @dialogTitleCNSUpdate.
  ///
  /// In en, this message translates to:
  /// **'Main System Update Detected'**
  String get dialogTitleCNSUpdate;

  /// No description provided for @dialogContentCNSUpdate.
  ///
  /// In en, this message translates to:
  /// **'An update for the \"Custom Nanosuit System\" has been detected.\n\nThis will replace files in the main game folder (StellarBlade\\SB). Do you wish to continue?'**
  String get dialogContentCNSUpdate;

  /// No description provided for @dialogTitleMultipleJsons.
  ///
  /// In en, this message translates to:
  /// **'Multiple .json Files Detected'**
  String get dialogTitleMultipleJsons;

  /// No description provided for @dialogContentMultipleJsons.
  ///
  /// In en, this message translates to:
  /// **'{count} .json files have been detected. This could be a mod with multiple components.\n\nDo you want to install them all together in a single mod folder?'**
  String dialogContentMultipleJsons(Object count);

  /// No description provided for @dialogTitleModExists.
  ///
  /// In en, this message translates to:
  /// **'Mod Already Exists'**
  String get dialogTitleModExists;

  /// No description provided for @dialogContentModExists.
  ///
  /// In en, this message translates to:
  /// **'A mod named \"{modName}\" is already installed.\n\nDo you want to update it? Old files will be deleted before installing the new ones.'**
  String dialogContentModExists(Object modName);

  /// No description provided for @dialogContentModUpdate.
  ///
  /// In en, this message translates to:
  /// **'An older version \'{oldModName}\' was found.\n\nDo you want to remove it and update to \'{newModName}\'?'**
  String dialogContentModUpdate(Object newModName, Object oldModName);

  /// No description provided for @dialogTitleDeleteMod.
  ///
  /// In en, this message translates to:
  /// **'Delete Permanently?'**
  String get dialogTitleDeleteMod;

  /// No description provided for @dialogContentDeleteMod.
  ///
  /// In en, this message translates to:
  /// **'You are about to permanently delete the mod \"{modName}\". This action cannot be undone.\n\nAre you sure?'**
  String dialogContentDeleteMod(Object modName);

  /// No description provided for @dialogActionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dialogActionCancel;

  /// No description provided for @dialogActionGoToDownload.
  ///
  /// In en, this message translates to:
  /// **'Go to Download Page'**
  String get dialogActionGoToDownload;

  /// No description provided for @dialogActionConfirmInstallation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Installation'**
  String get dialogActionConfirmInstallation;

  /// No description provided for @dialogActionUpdateSystem.
  ///
  /// In en, this message translates to:
  /// **'Update System'**
  String get dialogActionUpdateSystem;

  /// No description provided for @dialogActionInstallAnyway.
  ///
  /// In en, this message translates to:
  /// **'Install Anyway'**
  String get dialogActionInstallAnyway;

  /// No description provided for @dialogActionUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get dialogActionUpdate;

  /// No description provided for @dialogActionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get dialogActionDelete;

  /// No description provided for @dialogActionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get dialogActionClose;

  /// No description provided for @snackBarBatchInstallComplete.
  ///
  /// In en, this message translates to:
  /// **'Batch installation complete. Success: {successCount}, Failed: {failedCount}.'**
  String snackBarBatchInstallComplete(Object failedCount, Object successCount);

  /// No description provided for @snackBarModInstalled.
  ///
  /// In en, this message translates to:
  /// **'Mod \"{modName}\" installed successfully.'**
  String snackBarModInstalled(Object modName);

  /// No description provided for @snackBarModEnabled.
  ///
  /// In en, this message translates to:
  /// **'Mod \"{modName}\" enabled.'**
  String snackBarModEnabled(Object modName);

  /// No description provided for @snackBarModDisabled.
  ///
  /// In en, this message translates to:
  /// **'Mod \"{modName}\" disabled.'**
  String snackBarModDisabled(Object modName);

  /// No description provided for @snackBarModDeleted.
  ///
  /// In en, this message translates to:
  /// **'Mod \"{modName}\" permanently deleted.'**
  String snackBarModDeleted(Object modName);

  /// No description provided for @snackBarCNSUpdated.
  ///
  /// In en, this message translates to:
  /// **'Custom Nanosuit System updated successfully.'**
  String get snackBarCNSUpdated;

  /// No description provided for @snackBarApiKeySaved.
  ///
  /// In en, this message translates to:
  /// **'API Key saved successfully.'**
  String get snackBarApiKeySaved;

  /// No description provided for @snackBarGamePathSaved.
  ///
  /// In en, this message translates to:
  /// **'Game path saved successfully.'**
  String get snackBarGamePathSaved;

  /// No description provided for @snackBar7zipPathSaved.
  ///
  /// In en, this message translates to:
  /// **'7-Zip path saved successfully.'**
  String get snackBar7zipPathSaved;

  /// No description provided for @snackBarSkippedVersionRemoved.
  ///
  /// In en, this message translates to:
  /// **'Skipped version removed.'**
  String get snackBarSkippedVersionRemoved;

  /// No description provided for @dropTargetOverlay.
  ///
  /// In en, this message translates to:
  /// **'Drop mods here'**
  String get dropTargetOverlay;

  /// No description provided for @pathSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Stellar Blade Path Not Found'**
  String get pathSelectionTitle;

  /// No description provided for @pathSelectionButtonManual.
  ///
  /// In en, this message translates to:
  /// **'Select Game Folder Manually'**
  String get pathSelectionButtonManual;

  /// No description provided for @pathSelectionButtonRetry.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get pathSelectionButtonRetry;

  /// No description provided for @errorFolderSelection.
  ///
  /// In en, this message translates to:
  /// **'Error selecting folder: {error}'**
  String errorFolderSelection(Object error);

  /// No description provided for @errorFileSelection.
  ///
  /// In en, this message translates to:
  /// **'Error selecting files: {error}'**
  String errorFileSelection(Object error);

  /// No description provided for @errorDecompressing.
  ///
  /// In en, this message translates to:
  /// **'Error decompressing file: {error}'**
  String errorDecompressing(Object error);

  /// No description provided for @errorProcessingArchive.
  ///
  /// In en, this message translates to:
  /// **'Error processing file: {error}'**
  String errorProcessingArchive(Object error);

  /// No description provided for @errorUnsupportedFormat.
  ///
  /// In en, this message translates to:
  /// **'Unsupported file format: {extension}'**
  String errorUnsupportedFormat(Object extension);

  /// No description provided for @error7zipRequired.
  ///
  /// In en, this message translates to:
  /// **'Operation cancelled: 7-Zip is required.'**
  String get error7zipRequired;

  /// No description provided for @errorGamePathUndefined.
  ///
  /// In en, this message translates to:
  /// **'Game path is not defined.'**
  String get errorGamePathUndefined;

  /// No description provided for @errorDestinationNotFound.
  ///
  /// In en, this message translates to:
  /// **'The game\'s destination folder does not exist.'**
  String get errorDestinationNotFound;

  /// No description provided for @errorUpdateSystem.
  ///
  /// In en, this message translates to:
  /// **'Error updating system: {error}'**
  String errorUpdateSystem(Object error);

  /// No description provided for @errorInstallNoSelection.
  ///
  /// In en, this message translates to:
  /// **'You have not selected anything to install.'**
  String get errorInstallNoSelection;

  /// No description provided for @errorInstallModExists.
  ///
  /// In en, this message translates to:
  /// **'Installation cancelled: Mod already exists.'**
  String get errorInstallModExists;

  /// No description provided for @errorNoJsonFound.
  ///
  /// In en, this message translates to:
  /// **'Each mod must contain at least one .json file.'**
  String get errorNoJsonFound;

  /// No description provided for @errorInvalidJsonFormat.
  ///
  /// In en, this message translates to:
  /// **'The file {fileName} has an invalid JSON format.'**
  String errorInvalidJsonFormat(Object fileName);

  /// No description provided for @errorNoDisplayName.
  ///
  /// In en, this message translates to:
  /// **'The file {fileName} does not appear to be a Custom Nanosuit System mod (missing \"DisplayName\").'**
  String errorNoDisplayName(Object fileName);

  /// No description provided for @errorNoValidDisplayName.
  ///
  /// In en, this message translates to:
  /// **'No valid \"DisplayName\" was found in the .json files.'**
  String get errorNoValidDisplayName;

  /// No description provided for @errorEnableMod.
  ///
  /// In en, this message translates to:
  /// **'Error enabling mod: {error}'**
  String errorEnableMod(Object error);

  /// No description provided for @errorDisableMod.
  ///
  /// In en, this message translates to:
  /// **'Error disabling mod: {error}'**
  String errorDisableMod(Object error);

  /// No description provided for @errorDeleteMod.
  ///
  /// In en, this message translates to:
  /// **'Error deleting mod: {error}'**
  String errorDeleteMod(Object error);

  /// No description provided for @errorOpenFolder.
  ///
  /// In en, this message translates to:
  /// **'Could not open folder: {path}'**
  String errorOpenFolder(Object path);

  /// No description provided for @statusUpdateSystemCancelled.
  ///
  /// In en, this message translates to:
  /// **'System update cancelled.'**
  String get statusUpdateSystemCancelled;

  /// No description provided for @statusUpdatingCNS.
  ///
  /// In en, this message translates to:
  /// **'Updating Custom Nanosuit System...'**
  String get statusUpdatingCNS;

  /// No description provided for @statusExtractingFile.
  ///
  /// In en, this message translates to:
  /// **'Extracting {fileName}...'**
  String statusExtractingFile(Object fileName);

  /// No description provided for @statusInstallationCancelledByUser.
  ///
  /// In en, this message translates to:
  /// **'Installation cancelled by user.'**
  String get statusInstallationCancelledByUser;

  /// No description provided for @errorNoCompatibleFilesInFolder.
  ///
  /// In en, this message translates to:
  /// **'The selected folder does not contain compatible mod files.'**
  String get errorNoCompatibleFilesInFolder;

  /// No description provided for @errorNoCompatibleFilesInArchive.
  ///
  /// In en, this message translates to:
  /// **'The compressed file does not contain compatible mod files.'**
  String get errorNoCompatibleFilesInArchive;

  /// No description provided for @errorNoJsonInSelection.
  ///
  /// In en, this message translates to:
  /// **'The selection does not contain a valid mod .json file.'**
  String get errorNoJsonInSelection;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About CNS Control Center'**
  String get aboutTitle;

  /// No description provided for @aboutContent.
  ///
  /// In en, this message translates to:
  /// **'This application is a mod manager for Stellar Blade, designed to work with the Custom Nanosuit System (CNS).\n\nRequirement: For full functionality with .rar and .7z files, 7-Zip must be installed on your system.'**
  String get aboutContent;

  /// No description provided for @aboutLinkText.
  ///
  /// In en, this message translates to:
  /// **'Visit my creator profile'**
  String get aboutLinkText;

  /// No description provided for @creatorProfileUrl.
  ///
  /// In en, this message translates to:
  /// **'https://next.nexusmods.com/profile/LuisNandez?gameId=7804'**
  String get creatorProfileUrl;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version: {version}'**
  String aboutVersion(Object version);

  /// No description provided for @openModsFolder.
  ///
  /// In en, this message translates to:
  /// **'Open Mods Folder'**
  String get openModsFolder;

  /// No description provided for @openInNexusMods.
  ///
  /// In en, this message translates to:
  /// **'Open in Nexus Mods'**
  String get openInNexusMods;

  /// No description provided for @checkForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get checkForUpdates;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Update available: v{version}'**
  String updateAvailable(Object version);

  /// No description provided for @dialogTitleApiKey.
  ///
  /// In en, this message translates to:
  /// **'Nexus Mods API Key'**
  String get dialogTitleApiKey;

  /// No description provided for @dialogContentApiKey.
  ///
  /// In en, this message translates to:
  /// **'To check for mod updates, you need a personal API key from Nexus Mods.'**
  String get dialogContentApiKey;

  /// No description provided for @dialogContentApiKeyInstructions.
  ///
  /// In en, this message translates to:
  /// **'1. Go to Nexus Mods and log in.\n2. Click your avatar and go to \'Site preferences\'.\n3. Go to the \'API\' tab.\n4. Click \'Generate a new API key\'.\n5. Copy the key and paste it here.'**
  String get dialogContentApiKeyInstructions;

  /// No description provided for @apiKey.
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get apiKey;

  /// No description provided for @apiKeyHintText.
  ///
  /// In en, this message translates to:
  /// **'Paste your API key here'**
  String get apiKeyHintText;

  /// No description provided for @dialogActionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get dialogActionSave;

  /// No description provided for @apiKeyRemoved.
  ///
  /// In en, this message translates to:
  /// **'API Key removed.'**
  String get apiKeyRemoved;

  /// No description provided for @invalidApiKeyError.
  ///
  /// In en, this message translates to:
  /// **'Invalid API Key.'**
  String get invalidApiKeyError;

  /// No description provided for @validatingApiKey.
  ///
  /// In en, this message translates to:
  /// **'Validating...'**
  String get validatingApiKey;

  /// No description provided for @errorApiKeyMissing.
  ///
  /// In en, this message translates to:
  /// **'Nexus Mods API Key is not configured. Please add it via the key icon in the top bar.'**
  String get errorApiKeyMissing;

  /// No description provided for @statusCheckingUpdates.
  ///
  /// In en, this message translates to:
  /// **'Checking for mod updates...'**
  String get statusCheckingUpdates;

  /// No description provided for @statusUpdatesFound.
  ///
  /// In en, this message translates to:
  /// **'{count} update(s) found!'**
  String statusUpdatesFound(Object count);

  /// No description provided for @statusNoUpdates.
  ///
  /// In en, this message translates to:
  /// **'All mods are up to date.'**
  String get statusNoUpdates;

  /// No description provided for @selectModArchive.
  ///
  /// In en, this message translates to:
  /// **'Select Mod Archive'**
  String get selectModArchive;

  /// No description provided for @viewImageGallery.
  ///
  /// In en, this message translates to:
  /// **'View Image'**
  String get viewImageGallery;

  /// No description provided for @imageGallery.
  ///
  /// In en, this message translates to:
  /// **'Image Gallery'**
  String get imageGallery;

  /// No description provided for @noImagesFound.
  ///
  /// In en, this message translates to:
  /// **'No images were found for this mod, or the API key has not been entered. Please enter the API key and check for updates afterward.'**
  String get noImagesFound;

  /// No description provided for @errorFetchingImages.
  ///
  /// In en, this message translates to:
  /// **'Error fetching images: {error}'**
  String errorFetchingImages(Object error);

  /// No description provided for @imageMod.
  ///
  /// In en, this message translates to:
  /// **'Mod Image'**
  String get imageMod;

  /// No description provided for @dialogContentUpdateOptions.
  ///
  /// In en, this message translates to:
  /// **'What would you like to do?'**
  String get dialogContentUpdateOptions;

  /// No description provided for @dialogActionIgnoreVersion.
  ///
  /// In en, this message translates to:
  /// **'Ignore'**
  String get dialogActionIgnoreVersion;

  /// No description provided for @dialogActionSkipVersion.
  ///
  /// In en, this message translates to:
  /// **'Skip Version'**
  String get dialogActionSkipVersion;

  /// No description provided for @dialogActionGoToDownloadPage.
  ///
  /// In en, this message translates to:
  /// **'Go to Download'**
  String get dialogActionGoToDownloadPage;

  /// No description provided for @installedMods.
  ///
  /// In en, this message translates to:
  /// **'Installed Mods'**
  String get installedMods;

  /// No description provided for @filterBy.
  ///
  /// In en, this message translates to:
  /// **'Filter:'**
  String get filterBy;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by:'**
  String get sortBy;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get filterEnabled;

  /// No description provided for @filterDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get filterDisabled;

  /// No description provided for @filterRepaired.
  ///
  /// In en, this message translates to:
  /// **'Repaired'**
  String get filterRepaired;

  /// No description provided for @sortByName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sortByName;

  /// No description provided for @sortByDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get sortByDate;

  /// No description provided for @noModsFound.
  ///
  /// In en, this message translates to:
  /// **'No mods found.'**
  String get noModsFound;

  /// No description provided for @statusExtractingMultipleFiles.
  ///
  /// In en, this message translates to:
  /// **'Extracting {count} of {total}: {fileName}'**
  String statusExtractingMultipleFiles(
    Object count,
    Object fileName,
    Object total,
  );

  /// No description provided for @previewInstallTitle.
  ///
  /// In en, this message translates to:
  /// **'Mods to be Installed:'**
  String get previewInstallTitle;

  /// No description provided for @dialogTitleUE4SS.
  ///
  /// In en, this message translates to:
  /// **'UE4SS Installation Detected'**
  String get dialogTitleUE4SS;

  /// No description provided for @dialogContentUE4SS.
  ///
  /// In en, this message translates to:
  /// **'The UE4SS tool has been detected. Do you want to install it to \'StellarBlade\\SB\\Binaries\\Win64\'?\n\nThis is required for many mods to work.'**
  String get dialogContentUE4SS;

  /// No description provided for @dialogActionInstallTool.
  ///
  /// In en, this message translates to:
  /// **'Install Tool'**
  String get dialogActionInstallTool;

  /// No description provided for @statusUE4SSInstallCancelled.
  ///
  /// In en, this message translates to:
  /// **'UE4SS installation cancelled.'**
  String get statusUE4SSInstallCancelled;

  /// No description provided for @statusInstallingUE4SS.
  ///
  /// In en, this message translates to:
  /// **'Installing UE4SS...'**
  String get statusInstallingUE4SS;

  /// No description provided for @snackBarUE4SSInstalled.
  ///
  /// In en, this message translates to:
  /// **'UE4SS installed successfully.'**
  String get snackBarUE4SSInstalled;

  /// No description provided for @error7zipDecompression.
  ///
  /// In en, this message translates to:
  /// **'7-Zip error during decompression: {error}'**
  String error7zipDecompression(Object error);

  /// No description provided for @statusUE4SSInstallComplete.
  ///
  /// In en, this message translates to:
  /// **'UE4SS installation complete.'**
  String get statusUE4SSInstallComplete;

  /// No description provided for @dialogTitleAlternativeVersion.
  ///
  /// In en, this message translates to:
  /// **'Alternative Version Detected'**
  String get dialogTitleAlternativeVersion;

  /// Content for the dialog when a different mod with the same nexus ID is detected.
  ///
  /// In en, this message translates to:
  /// **'An alternative version of this mod is already installed: \'{oldModName}\'.\n\nYou are about to install a different alternative named \'{newModName}\'.'**
  String dialogContentAlternativeVersion(
    String oldModName,
    String baseModName,
    String newModName,
  );

  /// No description provided for @dialogActionReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get dialogActionReplace;

  /// No description provided for @dialogActionInstallAsNew.
  ///
  /// In en, this message translates to:
  /// **'Install as New'**
  String get dialogActionInstallAsNew;

  /// No description provided for @dialogTitleUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  String get dialogTitleUpdate;

  /// Content for the mod update confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'You are about to update the mod \'{modName}\'.\n\nInstalled version: {oldVersion}\nNew version: {newVersion}'**
  String dialogContentUpdate(
    String modName,
    String oldVersion,
    String newVersion,
  );

  /// No description provided for @dialogTitleDowngrade.
  ///
  /// In en, this message translates to:
  /// **'Older Version Detected'**
  String get dialogTitleDowngrade;

  /// Content for the mod downgrade warning dialog.
  ///
  /// In en, this message translates to:
  /// **'Warning: You are about to install an older version of the mod \'{modName}\'.\n\nInstalled version: {oldVersion}\nVersion to install: {newVersion}'**
  String dialogContentDowngrade(
    String modName,
    String oldVersion,
    String newVersion,
  );

  /// No description provided for @dialogActionDowngrade.
  ///
  /// In en, this message translates to:
  /// **'Downgrade'**
  String get dialogActionDowngrade;

  /// No description provided for @dialogTitleReinstall.
  ///
  /// In en, this message translates to:
  /// **'Reinstall Mod'**
  String get dialogTitleReinstall;

  /// No description provided for @dialogContentReinstall.
  ///
  /// In en, this message translates to:
  /// **'You are about to reinstall version \'{version}\' of the mod \'{modName}\'.'**
  String dialogContentReinstall(Object modName, Object version);

  /// No description provided for @dialogActionReinstall.
  ///
  /// In en, this message translates to:
  /// **'Reinstall'**
  String get dialogActionReinstall;

  /// No description provided for @editModNameTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit mod name'**
  String get editModNameTooltip;

  /// No description provided for @dialogTitleEditModName.
  ///
  /// In en, this message translates to:
  /// **'Edit Mod Name'**
  String get dialogTitleEditModName;

  /// No description provided for @dialogLabelNewName.
  ///
  /// In en, this message translates to:
  /// **'New name'**
  String get dialogLabelNewName;

  /// No description provided for @errorModNameExists.
  ///
  /// In en, this message translates to:
  /// **'A mod named \"{modName}\" already exists.'**
  String errorModNameExists(Object modName);

  /// No description provided for @dialogTitleRepairedModWarning.
  ///
  /// In en, this message translates to:
  /// **'Repaired Mod Warning'**
  String get dialogTitleRepairedModWarning;

  /// No description provided for @dialogContentRepairedModWarning.
  ///
  /// In en, this message translates to:
  /// **'This mod might not have the correct version information. Reinstalling the latest version is recommended to ensure compatibility.'**
  String get dialogContentRepairedModWarning;

  /// No description provided for @repairedModTooltip.
  ///
  /// In en, this message translates to:
  /// **'Information about repaired mod'**
  String get repairedModTooltip;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'ja',
    'ko',
    'pt',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
