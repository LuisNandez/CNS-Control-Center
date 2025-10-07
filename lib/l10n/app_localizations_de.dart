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
  String get settingsLanguageDesc => 'Wählen Sie die Anwendungssprache';

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
      'Der Stammordner Ihrer Stellar Blade-Installation.';

  @override
  String get settings7zipPath => '7-Zip-Pfad';

  @override
  String get settings7zipPathDesc =>
      'Der Speicherort der Datei 7z.exe zum Extrahieren von Mods.';

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
      'Verwalten Sie Mod-Versionen, die Sie übersprungen haben.';

  @override
  String settingsSkippedVersionsCount(Object count) {
    return '$count Versionen übersprungen';
  }

  @override
  String get dialogTitleSkippedVersions => 'Übersprungene Mod-Versionen';

  @override
  String get dialogNoSkippedVersions =>
      'Sie haben keine Mod-Versionen übersprungen.';

  @override
  String get dialogSkippedVersions => 'Übersprungene Version';

  @override
  String get dialogTitleRepairMods => 'Legacy-Mod-Reparatur ausführen?';

  @override
  String get dialogContentRepairMods =>
      'Warnung: Diese Funktion befindet sich in der Entwicklung und ist möglicherweise nicht perfekt.\n\nSie scannt Mods ohne eine \'nexus_info.json\'-Datei und erstellt eine, falls sie in Ihrer lokalen Datenbank gefunden wird. Es wird auch versucht, den Mod-Ordner umzubenennen, um die gefundene Version einzuschließen (z.B. \'Mein Mod\' -> \'Mein Mod v1.2\').\n\nVersionspriorität:\n1. Aus dem Ordnernamen.\n2. Aus dem Beschreibungsfeld des Mods.\n3. Aus der neuesten Version auf Nexus Mods (API erforderlich).\n\nMöchten Sie fortfahren?';

  @override
  String get dialogActionRunRepair => 'Reparatur ausführen';

  @override
  String get snackBarGamePathInvalid =>
      'Der ausgewählte Ordner scheint kein gültiger Spielordner zu sein.';

  @override
  String get snackBar7zipPathInvalid =>
      'Die ausgewählte Datei muss den Namen 7z.exe haben.';

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
  String get selectLanguage => 'Wählen Sie eine Sprache';

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
    return 'Bei der Suche nach dem Spiel ist ein Fehler aufgetreten: $error';
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
  String get dialogTitle7zip => '7-Zip ist erforderlich';

  @override
  String get dialogContent7zip =>
      'Um diese Datei zu dekomprimieren, benötigt die Anwendung 7-Zip.\n\nBitte installieren Sie es von der offiziellen Seite und drücken Sie dann auf \"Bestätigen\".';

  @override
  String get dialogContent7zipNotFound =>
      '7-Zip wurde noch nicht erkannt. Bitte stellen Sie sicher, dass es im Standardpfad installiert ist, und versuchen Sie es erneut.';

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
    return 'Ein Mod mit dem Namen \"$modName\" ist bereits installiert.\n\nMöchten Sie ihn aktualisieren? Alte Dateien werden vor der Installation der neuen gelöscht.';
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
      'Benutzerdefiniertes Nanosuit-System erfolgreich aktualisiert.';

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
    return 'Fehler bei der Verarbeitung der Datei: $error';
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
    return 'Die Datei $fileName scheint kein Mod für das Custom Nanosuit System zu sein (\"DisplayName\" fehlt).';
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
  String get statusUpdatingCNS =>
      'Benutzerdefiniertes Nanosuit-System wird aktualisiert...';

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
  String get aboutTitle => 'Über das CNS-Kontrollzentrum';

  @override
  String get aboutContent =>
      'Diese Anwendung ist ein Mod-Manager für Stellar Blade, der für das Custom Nanosuit System (CNS) entwickelt wurde.\n\nVoraussetzung: Für die volle Funktionalität mit .rar- und .7z-Dateien muss 7-Zip auf Ihrem System installiert sein.';

  @override
  String get aboutLinkText => 'Besuchen Sie mein Erstellerprofil';

  @override
  String get creatorProfileUrl =>
      'https://next.nexusmods.com/profile/LuisNandez?gameId=7804';

  @override
  String aboutVersion(Object version) {
    return 'Version: $version';
  }

  @override
  String get openModsFolder => 'Mods-Ordner öffnen';

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
  String get validatingApiKey => 'Wird validiert...';

  @override
  String get errorApiKeyMissing =>
      'Der Nexus Mods API-Schlüssel ist nicht konfiguriert. Bitte fügen Sie ihn über das Schlüsselsymbol in der oberen Leiste hinzu.';

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
      'Für diesen Mod wurden keine Bilder gefunden, oder der API-Schlüssel wurde nicht eingegeben. Bitte geben Sie den API-Schlüssel ein und suchen Sie anschließend nach Updates.';

  @override
  String errorFetchingImages(Object error) {
    return 'Fehler beim Abrufen der Bilder: $error';
  }

  @override
  String get imageMod => 'Mod-Bild';

  @override
  String get modEnabledBadge => 'Aktiviert';

  @override
  String get modDisabledBadge => 'Deaktiviert';

  @override
  String get modCategoryOther => 'Nicht angegeben';

  @override
  String get dialogContentUpdateOptions => 'Was möchten Sie tun?';

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
  String get viewTypeGrid => 'Rasteransicht';

  @override
  String get viewTypeList => 'Listenansicht';

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
    return 'Warnung: Sie sind dabei, eine ältere Version des Mods \'$modName\' zu installieren.\n\nInstallierte Version: $oldVersion\nZu installierende Version: $newVersion';
  }

  @override
  String get dialogTitleReinstall => 'Mod neu installieren';

  @override
  String dialogContentReinstall(Object modName, Object version) {
    return 'Sie sind dabei, die Version \'$version\' des Mods \'$modName\' neu zu installieren.';
  }

  @override
  String get dialogActionReinstall => 'Neu installieren';

  @override
  String get editModNameTooltip => 'Mod-Namen bearbeiten';

  @override
  String get setCoverTooltip => 'Benutzerdefiniertes Titelbild festlegen';

  @override
  String get setCoverText => 'Titelbild festlegen';

  @override
  String get restoreOriginalCoverText =>
      'Originales Titelbild wiederherstellen';

  @override
  String errorSavingCoverText(Object error) {
    return 'Fehler beim Speichern des Titelbilds: $error';
  }

  @override
  String errorRestoringCoverText(Object error) {
    return 'Fehler beim Wiederherstellen des originalen Titelbilds: $error';
  }

  @override
  String get editVersionText => 'Version bearbeiten';

  @override
  String get customVersionText => 'Benutzerdefinierte Version';

  @override
  String get editTagText => 'Tag bearbeiten';

  @override
  String get customTagText => 'Benutzerdefiniertes Tag';

  @override
  String get dialogTitleEditModName => 'Mod-Namen bearbeiten';

  @override
  String get dialogActionResetToDefault => 'Auf Standard zurücksetzen';

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
  String get disableAllModsTooltip => 'Alle Mods deaktivieren';

  @override
  String get deleteAllModsTooltip => 'Alle deaktivierten Mods löschen';

  @override
  String get dialogTitleDisableAll => 'Alle Mods deaktivieren?';

  @override
  String dialogContentDisableAll(int count) {
    return 'Sind Sie sicher, dass Sie alle $count aktivierten Mods deaktivieren möchten? Sie werden in den Backup-Ordner verschoben.';
  }

  @override
  String get dialogTitleDeleteAll => 'Deaktivierte Mods löschen?';

  @override
  String dialogContentDeleteAll(int count) {
    return 'Sie sind dabei, alle $count deaktivierten Mods dauerhaft zu löschen. Diese Aktion kann nicht rückgängig gemacht werden.\n\nSind Sie sicher?';
  }

  @override
  String snackBarAllModsDisabled(int count) {
    return 'Alle $count aktivierten Mods wurden deaktiviert.';
  }

  @override
  String snackBarAllModsDeleted(int count) {
    return 'Alle $count deaktivierten Mods wurden dauerhaft gelöscht.';
  }

  @override
  String get snackBarNoModsToDisable =>
      'Es gibt keine aktivierten Mods zum Deaktivieren.';

  @override
  String get snackBarNoModsToDelete =>
      'Es gibt keine deaktivierten Mods zum Löschen.';

  @override
  String get enableAllModsTooltip => 'Alle Mods aktivieren';

  @override
  String get dialogTitleEnableAll => 'Alle Mods aktivieren?';

  @override
  String dialogContentEnableAll(int count) {
    return 'Sind Sie sicher, dass Sie alle $count deaktivierten Mods aktivieren möchten? Sie werden in den Haupt-Mods-Ordner verschoben.';
  }

  @override
  String snackBarAllModsEnabled(int count) {
    return 'Alle $count deaktivierten Mods wurden aktiviert.';
  }

  @override
  String get snackBarNoModsToEnable =>
      'Es gibt keine deaktivierten Mods zum Aktivieren.';

  @override
  String get editNotes => 'Notizen bearbeiten';

  @override
  String get notesHintText =>
      'Fügen Sie hier Ihre persönlichen Notizen hinzu...';

  @override
  String get modAuthor => 'Autor';

  @override
  String get modDescription => 'Beschreibung';

  @override
  String get noDescriptionAvailable => 'Keine Beschreibung verfügbar.';

  @override
  String get personalNotes => 'Persönliche Notizen';

  @override
  String get noNotesAvailable => 'Noch keine Notizen hinzugefügt.';

  @override
  String get modDetailsTitle => 'Mod-Details';

  @override
  String get modVersion => 'Version';

  @override
  String get modCategory => 'Kategorie';

  @override
  String get dialogTitleAddUrl => 'Mod-Link hinzufügen';

  @override
  String get dialogLabelUrl => 'Mod-URL';

  @override
  String get errorInvalidUrl => 'Bitte geben Sie eine gültige URL ein.';

  @override
  String get addLinkTooltip => 'Einen Download-Link für diesen Mod hinzufügen';

  @override
  String get addLinkButtonText => 'Link hinzufügen';

  @override
  String get openLinkButtonText => 'Link öffnen';

  @override
  String get editModTitle => 'Mod-Details bearbeiten';

  @override
  String get modNameLabel => 'Mod-Name';

  @override
  String get authorLabel => 'Autor';

  @override
  String get summaryLabel => 'Beschreibung / Zusammenfassung';

  @override
  String get notesLabel => 'Persönliche Notizen';

  @override
  String get urlLabel => 'Download-URL';

  @override
  String get changeCoverButton => 'Titelbild ändern';

  @override
  String get editButtonTooltip => 'Mod bearbeiten';

  @override
  String get errorSavingNotes => 'Fehler beim Speichern der Notizen';

  @override
  String get errorSavingUrl => 'Fehler beim Speichern der URL';

  @override
  String get errorSavingChanges => 'Fehler beim Speichern der Änderungen';

  @override
  String get errorTranslation => 'Beschreibung konnte nicht übersetzt werden';

  @override
  String get translateDescription => 'Beschreibung übersetzen';

  @override
  String get dialogTitleUE4SSReinstall => 'UE4SS neu installieren';

  @override
  String get dialogContentUE4SSReinstall =>
      'UE4SS scheint bereits installiert zu sein. Möchten Sie die vorhandene Installation überschreiben? Dies kann nützlich sein, wenn Sie beschädigte Dateien vermuten.';

  @override
  String get dialogTitleCNSReinstall => 'CNS-System neu installieren';

  @override
  String get dialogContentCNSReinstall =>
      'Das Haupt-CNS-System scheint bereits installiert zu sein. Möchten Sie es neu installieren? Ihre vorhandenen Mods werden nicht beeinträchtigt.';

  @override
  String dialogTitleUninstall(Object componentName) {
    return '$componentName deinstallieren';
  }

  @override
  String dialogContentUninstall(Object componentName) {
    return 'Sind Sie sicher, dass Sie $componentName deinstallieren möchten? Diese Aktion entfernt die Kerndateien der Komponente, hat aber keine Auswirkungen auf Ihre installierten Mods.';
  }

  @override
  String get dialogActionUninstall => 'Ja, deinstallieren';

  @override
  String statusUninstalling(Object componentName) {
    return 'Deinstalliere $componentName...';
  }

  @override
  String snackBarUninstalled(Object componentName) {
    return '$componentName erfolgreich deinstalliert';
  }

  @override
  String errorUninstalling(Object componentName) {
    return 'Fehler bei der Deinstallation von $componentName';
  }

  @override
  String get settingsCoreComponents => 'Kernkomponenten';

  @override
  String get installedStatus => 'Installiert';

  @override
  String get notInstalledStatus => 'Nicht erkannt';

  @override
  String get uninstallButton => 'Deinstallieren';

  @override
  String get cnsCoreSystem => 'Custom Nanosuit System';

  @override
  String get ue4ssInstallationDetected =>
      'Bestehende UE4SS-Installation erkannt und übernommen';

  @override
  String get cnsInstallationDetected =>
      'Bestehende Haupt-CNS-Installation erkannt und übernommen';

  @override
  String get ue4ssRequiredTitle => 'UE4SS erforderlich';

  @override
  String get ue4ssRequiredContent =>
      'Um das Haupt-CNS-System zu installieren, müssen Sie zuerst UE4SS installieren. Sie können es unter folgendem Link herunterladen:';

  @override
  String get uninstallDependencyTitle => 'Abhängigkeit erkannt';

  @override
  String get uninstallDependencyContent =>
      'Sie müssen das Haupt-CNS-System deinstallieren, bevor Sie UE4SS deinstallieren können, da CNS davon abhängt.';

  @override
  String get dialogActionUnderstood => 'Verstanden';

  @override
  String get appTitleNoCns => 'Custom Nanosuit System (Nicht installiert)';

  @override
  String get dialogTitleCNSUpdate => 'Haupt-CNS-System aktualisieren';

  @override
  String dialogContentCNSUpdate(Object oldVersion, Object newVersion) {
    return 'Sie sind dabei, CNS von Version $oldVersion auf die neue Version $newVersion zu aktualisieren. Möchten Sie fortfahren?';
  }

  @override
  String get dialogTitleCNSDowngrade => 'CNS-Version herunterstufen';

  @override
  String dialogContentCNSDowngrade(Object oldVersion, Object newVersion) {
    return 'Warnung! Sie sind dabei, eine ältere Version von CNS ($newVersion) als Ihre aktuelle ($oldVersion) zu installieren. Dies kann zu Problemen führen. Sind Sie sicher?';
  }

  @override
  String dialogContentCNSReinstallVersion(Object version) {
    return 'Sie haben bereits Version $version von CNS installiert. Möchten Sie die Dateien trotzdem neu installieren?';
  }

  @override
  String get dialogActionUpdate => 'Aktualisieren';

  @override
  String get dialogActionDowngrade => 'Downgrade';

  @override
  String get dialogTitleCNSInstall => 'Haupt-CNS-System installieren';

  @override
  String get dialogContentCNSInstall =>
      'Sie sind dabei, das Basis-Custom-Nanosuit-System (CNS) zu installieren. Dies ist erforderlich, damit CNS-Mods funktionieren. Möchten Sie fortfahren?';

  @override
  String get dialogActionInstall => 'Installieren';

  @override
  String get settingsDeveloperOptions => 'Entwickleroptionen';

  @override
  String get devDeleteNexusInfoTitle => 'Alle nexus_info.json-Dateien löschen';

  @override
  String get devDeleteNexusInfoDesc =>
      'Entfernt alle Metadatendateien des Managers von jedem Mod. Dies ist nützlich, um eine vollständige Reparatur zu erzwingen.';

  @override
  String get devExtractIdsTitle => 'Identifikatoren extrahieren';

  @override
  String get devExtractIdsDesc =>
      'Erstellt eine Datei namens \'ID Mods.json\' auf Ihrem Desktop, die den displayName und die nexusId jedes Mods enthält.';

  @override
  String get devConfirmDeleteTitle => 'Löschung bestätigen';

  @override
  String get devConfirmDeleteDesc =>
      'Sind Sie sicher, dass Sie alle nexus_info.json-Dateien dauerhaft löschen möchten? Dadurch werden alle benutzerdefinierten Namen, Cover und Metadaten entfernt. Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get devDeleteSuccessTitle => 'Löschung abgeschlossen';

  @override
  String devDeleteSuccessDesc(Object count) {
    return '$count nexus_info.json-Dateien erfolgreich gelöscht.';
  }

  @override
  String get devConfirmExtractTitle => 'Extraktion bestätigen';

  @override
  String get devConfirmExtractDesc =>
      'Dies scannt alle Ihre Mods und erstellt \'ID Mods.json\' auf Ihrem Desktop. Eine vorhandene Datei mit demselben Namen wird überschrieben. Möchten Sie fortfahren?';

  @override
  String get devExtractAction => 'Extrahieren';

  @override
  String get devExtractNoData =>
      'Es wurden keine Mods mit gültigen Identifikatoren zum Extrahieren gefunden.';

  @override
  String get devExtractDesktopNotFound =>
      'Fehler: Das Desktop-Verzeichnis konnte nicht gefunden werden.';

  @override
  String get devExtractSuccessTitle => 'Extraktion abgeschlossen';

  @override
  String devExtractSuccessDesc(Object path) {
    return 'Datei erfolgreich erstellt unter: $path';
  }

  @override
  String get errorDialogTitle => 'Ein Fehler ist aufgetreten';
}
