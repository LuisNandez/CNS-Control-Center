// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'CNS-Kontrollzentrum';

  @override
  String appTitleWithVersion(Object version) {
    return 'Custom Nanosuit System $version';
  }

  @override
  String get settings => 'Einstellungen';

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
  String get snackBarGamePathInvalid =>
      'The selected folder does not appear to be a valid game folder.';

  @override
  String get snackBar7zipPathInvalid =>
      'The selected file must be named 7z.exe.';

  @override
  String get installNewMod => 'Neuen Mod installieren';

  @override
  String get selectFiles => 'Dateien auswählen';

  @override
  String get selectFolder => 'Ordner auswählen';

  @override
  String get installSelectedMod => 'Ausgewählten Mod installieren';

  @override
  String get filesToInstall => 'Zu installierende Dateien:';

  @override
  String get cancelSelection => 'Auswahl abbrechen';

  @override
  String get searchMods => 'Mods suchen...';

  @override
  String get enabledMods => 'Aktivierte Mods';

  @override
  String get disabledMods => 'Deaktivierte Mods';

  @override
  String get refreshList => 'Liste aktualisieren';

  @override
  String get noEnabledMods => 'Keine aktivierten Mods.';

  @override
  String get noDisabledMods => 'Keine deaktivierten Mods.';

  @override
  String get showInFolder => 'Im Ordner anzeigen';

  @override
  String get disableMod => 'Mod deaktivieren';

  @override
  String get enableMod => 'Mod aktivieren';

  @override
  String get deletePermanently => 'Dauerhaft löschen';

  @override
  String get language => 'Sprache';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get statusSearchingGame => 'Suche nach Stellar Blade-Installation...';

  @override
  String get statusGamePathFound => 'Spielpfad gefunden!';

  @override
  String get statusGamePathNotFound =>
      'Der Spielpfad konnte nicht automatisch gefunden werden.';

  @override
  String statusErrorFindingGame(Object error) {
    return 'Beim Suchen des Spiels ist ein Fehler aufgetreten: $error';
  }

  @override
  String statusModsFound(Object disabledCount, Object enabledCount) {
    return '$enabledCount Mod(s) aktiviert, $disabledCount deaktiviert.';
  }

  @override
  String statusErrorReadingMods(Object error) {
    return 'Fehler beim Lesen der installierten Mods: $error';
  }

  @override
  String statusFilesSelected(Object count) {
    return '$count Datei(en) ausgewählt. Bereit zur Installation.';
  }

  @override
  String statusFolderSelected(Object folderName) {
    return 'Ordner \"$folderName\" ausgewählt. Bereit zur Installation.';
  }

  @override
  String statusArchiveLoaded(Object count, Object fileName) {
    return 'Datei \"$fileName\" geladen. $count Datei(en) bereit zur Installation.';
  }

  @override
  String get statusSelectionCancelled =>
      'Auswahl abgebrochen. Wählen Sie einen neuen Mod zur Installation.';

  @override
  String get statusUpdateComplete => 'Update abgeschlossen.';

  @override
  String get statusInstallationComplete => 'Installation abgeschlossen.';

  @override
  String statusError(Object error) {
    return 'Fehler: $error';
  }

  @override
  String get dialogTitle7zip => '7-Zip wird benötigt';

  @override
  String get dialogContent7zip =>
      'Um diese Datei zu dekomprimieren, benötigt die Anwendung 7-Zip.\n\nBitte installieren Sie es von der offiziellen Seite und drücken Sie dann \"Bestätigen\".';

  @override
  String get dialogContent7zipNotFound =>
      '7-Zip wurde noch nicht erkannt. Bitte stellen Sie sicher, dass es im Standardpfad installiert ist, und versuchen Sie es erneut.';

  @override
  String get dialogTitleCNSUpdate => 'Hauptsystem-Update erkannt';

  @override
  String get dialogContentCNSUpdate =>
      'Ein Update für das \"Custom Nanosuit System\" wurde erkannt.\n\nDies ersetzt Dateien im Hauptspielordner (StellarBlade\\SB). Möchten Sie fortfahren?';

  @override
  String get dialogTitleMultipleJsons => 'Mehrere .json-Dateien erkannt';

  @override
  String dialogContentMultipleJsons(Object count) {
    return '$count .json-Dateien wurden erkannt. Dies könnte ein Mod mit mehreren Komponenten sein.\n\nMöchten Sie alle zusammen in einem einzigen Mod-Ordner installieren?';
  }

  @override
  String get dialogTitleModExists => 'Mod existiert bereits';

  @override
  String dialogContentModExists(Object modName) {
    return 'Ein Mod namens \"$modName\" ist bereits installiert.\n\nMöchten Sie ihn aktualisieren? Alte Dateien werden vor der Installation der neuen gelöscht.';
  }

  @override
  String dialogContentModUpdate(Object newModName, Object oldModName) {
    return 'Eine ältere Version \'$oldModName\' wurde gefunden.\n\nMöchten Sie sie entfernen und auf \'$newModName\' aktualisieren?';
  }

  @override
  String get dialogTitleDeleteMod => 'Dauerhaft löschen?';

  @override
  String dialogContentDeleteMod(Object modName) {
    return 'Sie sind dabei, den Mod \"$modName\" dauerhaft zu löschen. Diese Aktion kann nicht rückgängig gemacht werden.\n\nSind Sie sicher?';
  }

  @override
  String get dialogActionCancel => 'Abbrechen';

  @override
  String get dialogActionGoToDownload => 'Zur Download-Seite gehen';

  @override
  String get dialogActionConfirmInstallation => 'Installation bestätigen';

  @override
  String get dialogActionUpdateSystem => 'System aktualisieren';

  @override
  String get dialogActionInstallAnyway => 'Trotzdem installieren';

  @override
  String get dialogActionUpdate => 'Aktualisieren';

  @override
  String get dialogActionDelete => 'Löschen';

  @override
  String get dialogActionClose => 'Schließen';

  @override
  String snackBarBatchInstallComplete(Object failedCount, Object successCount) {
    return 'Stapelinstallation abgeschlossen. Erfolgreich: $successCount, Fehlgeschlagen: $failedCount.';
  }

  @override
  String snackBarModInstalled(Object modName) {
    return 'Mod \"$modName\" erfolgreich installiert.';
  }

  @override
  String snackBarModEnabled(Object modName) {
    return 'Mod \"$modName\" aktiviert.';
  }

  @override
  String snackBarModDisabled(Object modName) {
    return 'Mod \"$modName\" deaktiviert.';
  }

  @override
  String snackBarModDeleted(Object modName) {
    return 'Mod \"$modName\" dauerhaft gelöscht.';
  }

  @override
  String get snackBarCNSUpdated =>
      'Custom Nanosuit System erfolgreich aktualisiert.';

  @override
  String get snackBarApiKeySaved => 'API-Schlüssel erfolgreich gespeichert.';

  @override
  String get snackBarGamePathSaved => 'Game path saved successfully.';

  @override
  String get snackBar7zipPathSaved => '7-Zip path saved successfully.';

  @override
  String get snackBarSkippedVersionRemoved => 'Skipped version removed.';

  @override
  String get dropTargetOverlay => 'Mods hier ablegen';

  @override
  String get pathSelectionTitle => 'Stellar Blade-Pfad nicht gefunden';

  @override
  String get pathSelectionButtonManual => 'Spielordner manuell auswählen';

  @override
  String get pathSelectionButtonRetry => 'Erneut versuchen';

  @override
  String errorFolderSelection(Object error) {
    return 'Fehler bei der Ordnerauswahl: $error';
  }

  @override
  String errorFileSelection(Object error) {
    return 'Fehler bei der Dateiauswahl: $error';
  }

  @override
  String errorDecompressing(Object error) {
    return 'Fehler beim Dekomprimieren der Datei: $error';
  }

  @override
  String errorProcessingArchive(Object error) {
    return 'Fehler bei der Verarbeitung des Archivs: $error';
  }

  @override
  String errorUnsupportedFormat(Object extension) {
    return 'Nicht unterstütztes Dateiformat: $extension';
  }

  @override
  String get error7zipRequired => 'Vorgang abgebrochen: 7-Zip wird benötigt.';

  @override
  String get errorGamePathUndefined => 'Spielpfad ist nicht definiert.';

  @override
  String get errorDestinationNotFound =>
      'Der Zielordner des Spiels existiert nicht.';

  @override
  String errorUpdateSystem(Object error) {
    return 'Fehler beim Aktualisieren des Systems: $error';
  }

  @override
  String get errorInstallNoSelection =>
      'Sie haben nichts zur Installation ausgewählt.';

  @override
  String get errorInstallModExists =>
      'Installation abgebrochen: Mod existiert bereits.';

  @override
  String get errorNoJsonFound =>
      'Jeder Mod muss mindestens eine .json-Datei enthalten.';

  @override
  String errorInvalidJsonFormat(Object fileName) {
    return 'Die Datei $fileName hat ein ungültiges JSON-Format.';
  }

  @override
  String errorNoDisplayName(Object fileName) {
    return 'Die Datei $fileName scheint kein Mod des Custom Nanosuit Systems zu sein (\"DisplayName\" fehlt).';
  }

  @override
  String get errorNoValidDisplayName =>
      'In den .json-Dateien wurde kein gültiger \"DisplayName\" gefunden.';

  @override
  String errorEnableMod(Object error) {
    return 'Fehler beim Aktivieren des Mods: $error';
  }

  @override
  String errorDisableMod(Object error) {
    return 'Fehler beim Deaktivieren des Mods: $error';
  }

  @override
  String errorDeleteMod(Object error) {
    return 'Fehler beim Löschen des Mods: $error';
  }

  @override
  String errorOpenFolder(Object path) {
    return 'Ordner konnte nicht geöffnet werden: $path';
  }

  @override
  String get statusUpdateSystemCancelled => 'Systemupdate abgebrochen.';

  @override
  String get statusUpdatingCNS => 'Custom Nanosuit System wird aktualisiert...';

  @override
  String statusExtractingFile(Object fileName) {
    return 'Extrahiere $fileName...';
  }

  @override
  String get statusInstallationCancelledByUser =>
      'Installation vom Benutzer abgebrochen.';

  @override
  String get errorNoCompatibleFilesInFolder =>
      'Der ausgewählte Ordner enthält keine kompatiblen Mod-Dateien.';

  @override
  String get errorNoCompatibleFilesInArchive =>
      'Die komprimierte Datei enthält keine kompatiblen Mod-Dateien.';

  @override
  String get errorNoJsonInSelection =>
      'Die Auswahl enthält keine gültige Mod-.json-Datei.';

  @override
  String get aboutTitle => 'Über das CNS Control Center';

  @override
  String get aboutContent =>
      'Diese Anwendung ist ein Mod-Manager für Stellar Blade, der für die Arbeit mit dem Custom Nanosuit System (CNS) entwickelt wurde.\n\nAnforderung: Für die volle Funktionalität mit .rar- und .7z-Dateien muss 7-Zip auf Ihrem System installiert sein.';

  @override
  String get aboutLinkText => 'Besuchen Sie das Profil meines Erstellers';

  @override
  String get creatorProfileUrl =>
      'https://next.nexusmods.com/profile/LuisNandez?gameId=7804';

  @override
  String aboutVersion(Object version) {
    return 'Version: $version';
  }

  @override
  String get openModsFolder => 'Mod-Ordner öffnen';

  @override
  String get openInNexusMods => 'In Nexus Mods öffnen';

  @override
  String get checkForUpdates => 'Nach Updates suchen';

  @override
  String updateAvailable(Object version) {
    return 'Update verfügbar: v$version';
  }

  @override
  String get dialogTitleApiKey => 'Nexus Mods API-Schlüssel';

  @override
  String get dialogContentApiKey =>
      'Um nach Mod-Updates zu suchen, benötigen Sie einen persönlichen API-Schlüssel von Nexus Mods.';

  @override
  String get dialogContentApiKeyInstructions =>
      '1. Gehen Sie zu Nexus Mods und melden Sie sich an.\n2. Klicken Sie auf Ihren Avatar und gehen Sie zu \'Site preferences\'.\n3. Gehen Sie zum Tab \'API\'.\n4. Klicken Sie auf \'Generate a new API key\'.\n5. Kopieren Sie den Schlüssel und fügen Sie ihn hier ein.';

  @override
  String get apiKey => 'API-Schlüssel';

  @override
  String get apiKeyHintText => 'Fügen Sie Ihren API-Schlüssel hier ein';

  @override
  String get dialogActionSave => 'Speichern';

  @override
  String get apiKeyRemoved => 'API-Schlüssel entfernt.';

  @override
  String get invalidApiKeyError => 'Ungültiger API-Schlüssel.';

  @override
  String get validatingApiKey => 'Überprüfe...';

  @override
  String get errorApiKeyMissing =>
      'Nexus Mods API-Schlüssel ist nicht konfiguriert. Bitte fügen Sie ihn über das Schlüsselsymbol in der oberen Leiste hinzu.';

  @override
  String get statusCheckingUpdates => 'Suche nach Mod-Updates...';

  @override
  String statusUpdatesFound(Object count) {
    return '$count Update(s) gefunden!';
  }

  @override
  String get statusNoUpdates => 'Alle Mods sind auf dem neuesten Stand.';

  @override
  String get selectModArchive => 'Mod-Archiv auswählen';

  @override
  String get viewImageGallery => 'Bild ansehen';

  @override
  String get imageGallery => 'Bildergalerie';

  @override
  String get noImagesFound =>
      'Für diesen Mod wurden keine Bilder gefunden oder der API-Schlüssel wurde nicht eingegeben. Bitte geben Sie den Schlüssel ein und suchen Sie danach nach Updates.';

  @override
  String errorFetchingImages(Object error) {
    return 'Fehler beim Abrufen der Bilder: $error';
  }

  @override
  String get imageMod => 'Mod-Bild';

  @override
  String get dialogContentUpdateOptions => 'Was möchten Sie tun?';

  @override
  String get dialogActionIgnoreVersion => 'Version ignorieren';

  @override
  String get dialogActionSkipVersion => 'Skip Version';

  @override
  String get dialogActionGoToDownloadPage => 'Zum Download';

  @override
  String get installedMods => 'Installierte Mods';

  @override
  String get filterBy => 'Filtern nach:';

  @override
  String get sortBy => 'Sortieren nach:';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterEnabled => 'Aktiviert';

  @override
  String get filterDisabled => 'Deaktiviert';

  @override
  String get sortByName => 'Name';

  @override
  String get sortByDate => 'Datum';

  @override
  String get noModsFound => 'Keine Mods gefunden.';

  @override
  String statusExtractingMultipleFiles(
    Object count,
    Object fileName,
    Object total,
  ) {
    return 'Extrahiere $count von $total: $fileName';
  }

  @override
  String get previewInstallTitle => 'Zu installierende Mods:';

  @override
  String get dialogTitleUE4SS => 'UE4SS-Installation erkannt';

  @override
  String get dialogContentUE4SS =>
      'Das UE4SS-Tool wurde erkannt. Möchten Sie es in \'StellarBlade\\SB\\Binaries\\Win64\' installieren?\n\nDies ist für viele Mods erforderlich, um zu funktionieren.';

  @override
  String get dialogActionInstallTool => 'Tool installieren';

  @override
  String get statusUE4SSInstallCancelled => 'UE4SS-Installation abgebrochen.';

  @override
  String get statusInstallingUE4SS => 'Installiere UE4SS...';

  @override
  String get snackBarUE4SSInstalled => 'UE4SS erfolgreich installiert.';

  @override
  String error7zipDecompression(Object error) {
    return '7-Zip-Fehler bei der Dekomprimierung: $error';
  }

  @override
  String get statusUE4SSInstallComplete => 'UE4SS-Installation abgeschlossen.';

  @override
  String get dialogTitleAlternativeVersion => 'Alternative Version erkannt';

  @override
  String dialogContentAlternativeVersion(
    String oldModName,
    String baseModName,
    String newModName,
  ) {
    return 'Eine alternative Version dieses Mods ist bereits installiert: \'$oldModName\'.\n\nSie sind dabei, eine andere Alternative namens \'$newModName\' zu installieren.';
  }

  @override
  String get dialogActionReplace => 'Ersetzen';

  @override
  String get dialogActionInstallAsNew => 'Als Neu installieren';

  @override
  String get dialogTitleUpdate => 'Update verfügbar';

  @override
  String dialogContentUpdate(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return 'Sie sind dabei, den Mod \'$modName\' zu aktualisieren.\n\nInstallierte Version: $oldVersion\nNeue Version: $newVersion';
  }

  @override
  String get dialogTitleDowngrade => 'Ältere Version erkannt';

  @override
  String dialogContentDowngrade(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return 'Achtung: Sie sind dabei, eine ältere Version des Mods \'$modName\' zu installieren.\n\nInstallierte Version: $oldVersion\nZu installierende Version: $newVersion';
  }

  @override
  String get dialogActionDowngrade => 'Downgrade';

  @override
  String get dialogTitleReinstall => 'Mod neu installieren';

  @override
  String dialogContentReinstall(Object modName, Object version) {
    return 'Sie sind dabei, die Version \'$version\' des Mods \'$modName\' neu zu installieren.';
  }

  @override
  String get dialogActionReinstall => 'Neu installieren';
}
