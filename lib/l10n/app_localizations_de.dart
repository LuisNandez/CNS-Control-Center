// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'CNS Control Center';

  @override
  String appTitleWithVersion(Object version) {
    return 'Custom Nanosuit System $version';
  }

  @override
  String get settings => 'Einstellungen';

  @override
  String get settingsGeneral => 'Allgemein';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsLanguageDesc => 'Wähle die Anwendungssprache';

  @override
  String get settingsAbout => 'Über';

  @override
  String get settingsAboutDesc => 'Informationen über die Anwendung';

  @override
  String get settingsPathsAndTools => 'Pfade & Werkzeuge';

  @override
  String get settingsGameFolder => 'Spielordner';

  @override
  String get settingsGameFolderDesc =>
      'Der Stammordner deiner Stellar Blade-Installation.';

  @override
  String get settings7zipPath => '7-Zip-Pfad';

  @override
  String get settings7zipPathDesc =>
      'Der Speicherort der 7z.exe-Datei zum Extrahieren von Mods.';

  @override
  String get settings7zipPathAuto => 'Automatische Suche';

  @override
  String get settingsRepairMods => 'Legacy-Mods reparieren';

  @override
  String get settingsRepairModsDesc =>
      'Scannt und erstellt Infodateien für alte Mods unter Verwendung der lokalen Datenbank. API-Schlüssel erforderlich.';

  @override
  String get settingsConnectivity => 'Konnektivität & Updates';

  @override
  String get settingsApiKey => 'Nexus Mods API-Schlüssel';

  @override
  String get settingsApiKeyDesc =>
      'Erforderlich, um nach Mod-Updates zu suchen.';

  @override
  String get settingsApiKeySet => 'Gesetzt';

  @override
  String get settingsApiKeyNotSet => 'Nicht gesetzt';

  @override
  String get settingsSkippedVersions => 'Übersprungene Versionen verwalten';

  @override
  String get settingsSkippedVersionsDesc =>
      'Verwalte Mod-Versionen, die du übersprungen hast.';

  @override
  String settingsSkippedVersionsCount(Object count) {
    return '$count Versionen übersprungen';
  }

  @override
  String get dialogTitleSkippedVersions => 'Übersprungene Mod-Versionen';

  @override
  String get dialogNoSkippedVersions =>
      'Du hast keine Mod-Versionen übersprungen.';

  @override
  String get dialogSkippedVersions => 'Übersprungene Version';

  @override
  String get dialogTitleRepairMods => 'Legacy-Mod-Reparatur ausführen?';

  @override
  String get dialogContentRepairMods =>
      'Warnung: Diese Funktion befindet sich in der Entwicklung und ist möglicherweise nicht perfekt.\n\nSie scannt Mods ohne eine \'nexus_info.json\'-Datei und erstellt eine, falls sie in deiner lokalen Datenbank gefunden wird. Sie versucht auch, den Ordner des Mods umzubenennen, um die gefundene Version einzuschließen (z. B. \'Mein Mod\' -> \'Mein Mod v1.2\').\n\nVersionspriorität:\n1. Aus dem Ordnernamen.\n2. Aus dem Beschreibungsfeld des Mods.\n3. Aus der neuesten Version auf Nexus Mods (erfordert API).\n\nMöchtest du fortfahren?';

  @override
  String get dialogActionRunRepair => 'Reparatur ausführen';

  @override
  String get snackBarGamePathInvalid =>
      'Der ausgewählte Ordner scheint kein gültiger Spielordner zu sein.';

  @override
  String get snackBar7zipPathInvalid =>
      'Die ausgewählte Datei muss 7z.exe heißen.';

  @override
  String get snackBarRepairStarted =>
      'Der Reparaturprozess für Legacy-Mods wurde gestartet...';

  @override
  String snackBarRepairComplete(Object count) {
    return 'Reparatur abgeschlossen. $count Mod(s) wurden aktualisiert.';
  }

  @override
  String get snackBarRepairNoMods =>
      'Es wurden keine Legacy-Mods gefunden, die repariert werden mussten.';

  @override
  String get errorApiRequiredForRepair =>
      'Ein API-Schlüssel ist erforderlich, um die neueste Version für Mods ohne lokale Version zu finden.';

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
  String get selectLanguage => 'Wähle eine Sprache';

  @override
  String get statusSearchingGame =>
      'Suche nach der Installation von Stellar Blade...';

  @override
  String get statusGamePathFound => 'Spielpfad gefunden!';

  @override
  String get statusGamePathNotFound =>
      'Der Spielpfad konnte nicht automatisch gefunden werden.';

  @override
  String statusErrorFindingGame(Object error) {
    return 'Beim Suchen nach dem Spiel ist ein Fehler aufgetreten: $error';
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
      'Auswahl abgebrochen. Wähle einen neuen Mod zur Installation.';

  @override
  String get statusUpdateComplete => 'Update abgeschlossen.';

  @override
  String get statusInstallationComplete => 'Installation abgeschlossen.';

  @override
  String statusError(Object error) {
    return 'Fehler: $error';
  }

  @override
  String get dialogTitle7zip => '7-Zip ist erforderlich';

  @override
  String get dialogContent7zip =>
      'Um diese Datei zu dekomprimieren, benötigt die Anwendung 7-Zip.\n\nBitte installiere es von der offiziellen Seite und drücke dann auf \"Bestätigen\".';

  @override
  String get dialogContent7zipNotFound =>
      '7-Zip wurde noch nicht erkannt. Bitte stelle sicher, dass es im Standardpfad installiert ist, und versuche es erneut.';

  @override
  String get dialogTitleCNSUpdate => 'Hauptsystem-Update erkannt';

  @override
  String get dialogContentCNSUpdate =>
      'Ein Update für das \"Custom Nanosuit System\" wurde erkannt.\n\nDadurch werden Dateien im Hauptspielordner (StellarBlade\\SB) ersetzt. Möchtest du fortfahren?';

  @override
  String get dialogTitleMultipleJsons => 'Mehrere .json-Dateien erkannt';

  @override
  String dialogContentMultipleJsons(Object count) {
    return '$count .json-Dateien wurden erkannt. Dies könnte ein Mod mit mehreren Komponenten sein.\n\nMöchtest du sie alle zusammen in einem einzigen Mod-Ordner installieren?';
  }

  @override
  String get dialogTitleModExists => 'Mod existiert bereits';

  @override
  String dialogContentModExists(Object modName) {
    return 'Ein Mod mit dem Namen \"$modName\" ist bereits installiert.\n\nMöchtest du ihn aktualisieren? Alte Dateien werden vor der Installation der neuen gelöscht.';
  }

  @override
  String dialogContentModUpdate(Object newModName, Object oldModName) {
    return 'Eine ältere Version \'$oldModName\' wurde gefunden.\n\nMöchtest du sie entfernen und auf \'$newModName\' aktualisieren?';
  }

  @override
  String get dialogTitleDeleteMod => 'Dauerhaft löschen?';

  @override
  String dialogContentDeleteMod(Object modName) {
    return 'Du bist dabei, den Mod \"$modName\" dauerhaft zu löschen. Diese Aktion kann nicht rückgängig gemacht werden.\n\nBist du sicher?';
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
    return 'Stapelinstallation abgeschlossen. Erfolg: $successCount, Fehlgeschlagen: $failedCount.';
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
  String get snackBarGamePathSaved => 'Spielpfad erfolgreich gespeichert.';

  @override
  String get snackBar7zipPathSaved => '7-Zip-Pfad erfolgreich gespeichert.';

  @override
  String get snackBarSkippedVersionRemoved => 'Übersprungene Version entfernt.';

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
    return 'Fehler beim Verarbeiten der Datei: $error';
  }

  @override
  String errorUnsupportedFormat(Object extension) {
    return 'Nicht unterstütztes Dateiformat: $extension';
  }

  @override
  String get error7zipRequired =>
      'Vorgang abgebrochen: 7-Zip ist erforderlich.';

  @override
  String get errorGamePathUndefined => 'Der Spielpfad ist nicht definiert.';

  @override
  String get errorDestinationNotFound =>
      'Der Zielordner des Spiels existiert nicht.';

  @override
  String errorUpdateSystem(Object error) {
    return 'Fehler beim Aktualisieren des Systems: $error';
  }

  @override
  String get errorInstallNoSelection =>
      'Du hast nichts zum Installieren ausgewählt.';

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
  String get aboutTitle => 'Über CNS Control Center';

  @override
  String get aboutContent =>
      'Diese Anwendung ist ein Mod-Manager für Stellar Blade, der für die Verwendung mit dem Custom Nanosuit System (CNS) entwickelt wurde.\n\nVoraussetzung: Für die volle Funktionalität mit .rar- und .7z-Dateien muss 7-Zip auf deinem System installiert sein.';

  @override
  String get aboutLinkText => 'Besuche mein Erstellerprofil';

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
      'Um nach Mod-Updates zu suchen, benötigst du einen persönlichen API-Schlüssel von Nexus Mods.';

  @override
  String get dialogContentApiKeyInstructions =>
      '1. Gehe zu Nexus Mods und melde dich an.\n2. Klicke auf deinen Avatar und gehe zu \'Site preferences\'.\n3. Gehe zum Tab \'API\'.\n4. Klicke auf \'Generate a new API key\'.\n5. Kopiere den Schlüssel und füge ihn hier ein.';

  @override
  String get apiKey => 'API-Schlüssel';

  @override
  String get apiKeyHintText => 'Füge deinen API-Schlüssel hier ein';

  @override
  String get dialogActionSave => 'Speichern';

  @override
  String get apiKeyRemoved => 'API-Schlüssel entfernt.';

  @override
  String get invalidApiKeyError => 'Ungültiger API-Schlüssel.';

  @override
  String get validatingApiKey => 'Wird validiert...';

  @override
  String get errorApiKeyMissing =>
      'Der Nexus Mods API-Schlüssel ist nicht konfiguriert. Bitte füge ihn über das Schlüsselsymbol in der oberen Leiste hinzu.';

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
      'Für diesen Mod wurden keine Bilder gefunden oder der API-Schlüssel wurde nicht eingegeben. Bitte gib den API-Schlüssel ein und suche anschließend nach Updates.';

  @override
  String errorFetchingImages(Object error) {
    return 'Fehler beim Abrufen der Bilder: $error';
  }

  @override
  String get imageMod => 'Mod-Bild';

  @override
  String get dialogContentUpdateOptions => 'Was möchtest du tun?';

  @override
  String get dialogActionIgnoreVersion => 'Ignorieren';

  @override
  String get dialogActionSkipVersion => 'Version überspringen';

  @override
  String get dialogActionGoToDownloadPage => 'Zum Download gehen';

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
  String get filterRepaired => 'Repariert';

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
      'Das UE4SS-Tool wurde erkannt. Möchtest du es in \'StellarBlade\\SB\\Binaries\\Win64\' installieren?\n\nDies ist für viele Mods erforderlich, um zu funktionieren.';

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
    return 'Eine alternative Version dieses Mods ist bereits installiert: \'$oldModName\'.\n\nDu bist dabei, eine andere Alternative mit dem Namen \'$newModName\' zu installieren.';
  }

  @override
  String get dialogActionReplace => 'Ersetzen';

  @override
  String get dialogActionInstallAsNew => 'Als neu installieren';

  @override
  String get dialogTitleUpdate => 'Update verfügbar';

  @override
  String dialogContentUpdate(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return 'Du bist dabei, den Mod \'$modName\' zu aktualisieren.\n\nInstallierte Version: $oldVersion\nNeue Version: $newVersion';
  }

  @override
  String get dialogTitleDowngrade => 'Ältere Version erkannt';

  @override
  String dialogContentDowngrade(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return 'Warnung: Du bist dabei, eine ältere Version des Mods \'$modName\' zu installieren.\n\nInstallierte Version: $oldVersion\nZu installierende Version: $newVersion';
  }

  @override
  String get dialogActionDowngrade => 'Downgrade';

  @override
  String get dialogTitleReinstall => 'Mod neu installieren';

  @override
  String dialogContentReinstall(Object modName, Object version) {
    return 'Du bist dabei, die Version \'$version\' des Mods \'$modName\' neu zu installieren.';
  }

  @override
  String get dialogActionReinstall => 'Neu installieren';

  @override
  String get editModNameTooltip => 'Mod-Namen bearbeiten';

  @override
  String get dialogTitleEditModName => 'Mod-Namen bearbeiten';

  @override
  String get dialogActionResetToDefault => 'Reset to Default';

  @override
  String get dialogLabelNewName => 'Neuer Name';

  @override
  String errorModNameExists(Object modName) {
    return 'Ein Mod mit dem Namen \"$modName\" existiert bereits.';
  }

  @override
  String get dialogTitleRepairedModWarning => 'Warnung bei repariertem Mod';

  @override
  String get dialogContentRepairedModWarning =>
      'Dieser Mod hat möglicherweise nicht die korrekten Versionsinformationen. Es wird empfohlen, die neueste Version neu zu installieren, um die Kompatibilität zu gewährleisten.';

  @override
  String get repairedModTooltip => 'Informationen über reparierten Mod';

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

  @override
  String get viewModeGrid => 'Grid';

  @override
  String get viewModeList => 'List';

  @override
  String get modEnabledBadge => 'Enabled';

  @override
  String get modCategoryOther => 'Other';
}
