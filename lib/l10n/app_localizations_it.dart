// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'CNS Control Center';

  @override
  String appTitleWithVersion(Object version) {
    return 'Custom Nanosuit System $version';
  }

  @override
  String get settings => 'Impostazioni';

  @override
  String get settingsGeneral => 'Generale';

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get settingsLanguageDesc => 'Scegli la lingua dell\'applicazione';

  @override
  String get settingsAbout => 'Informazioni';

  @override
  String get settingsAboutDesc => 'Informazioni sull\'applicazione';

  @override
  String get settingsPathsAndTools => 'Percorsi e Strumenti';

  @override
  String get settingsGameFolder => 'Cartella del gioco';

  @override
  String get settingsGameFolderDesc =>
      'La cartella principale della tua installazione di Stellar Blade.';

  @override
  String get settings7zipPath => 'Percorso di 7-Zip';

  @override
  String get settings7zipPathDesc =>
      'La posizione del file 7z.exe per estrarre le mod.';

  @override
  String get settings7zipPathAuto => 'Ricerca automatica';

  @override
  String get settingsRepairMods => 'Ripara Mod Legacy';

  @override
  String get settingsRepairModsDesc =>
      'Scansiona e crea file informativi per le vecchie mod utilizzando il database locale. Richiede una chiave API.';

  @override
  String get settingsConnectivity => 'Connettività e Aggiornamenti';

  @override
  String get settingsApiKey => 'Chiave API di Nexus Mods';

  @override
  String get settingsApiKeyDesc =>
      'Necessaria per controllare gli aggiornamenti delle mod.';

  @override
  String get settingsApiKeySet => 'Impostata';

  @override
  String get settingsApiKeyNotSet => 'Non impostata';

  @override
  String get settingsSkippedVersions => 'Gestisci Versioni Saltate';

  @override
  String get settingsSkippedVersionsDesc =>
      'Gestisci le versioni delle mod che hai scelto di saltare.';

  @override
  String settingsSkippedVersionsCount(Object count) {
    return '$count versioni saltate';
  }

  @override
  String get dialogTitleSkippedVersions => 'Versioni delle Mod Saltate';

  @override
  String get dialogNoSkippedVersions =>
      'Non hai saltato nessuna versione di mod.';

  @override
  String get dialogSkippedVersions => 'Versione Saltata';

  @override
  String get dialogTitleRepairMods =>
      'Eseguire la Riparazione delle Mod Legacy?';

  @override
  String get dialogContentRepairMods =>
      'Attenzione: Questa funzione è in fase di sviluppo e potrebbe non essere perfetta.\n\nScansionerà le mod senza un file \'nexus_info.json\' e, se trovata nel tuo database locale, ne creerà uno. Tenterà anche di rinominare la cartella della mod per includere la versione trovata (es. \'La Mia Mod\' -> \'La Mia Mod v1.2\').\n\nPriorità della Versione:\n1. Dal nome della cartella.\n2. Dal campo descrizione della mod.\n3. Dall\'ultima versione su Nexus Mods (richiede API).\n\nVuoi continuare?';

  @override
  String get dialogActionRunRepair => 'Esegui Riparazione';

  @override
  String get snackBarGamePathInvalid =>
      'La cartella selezionata non sembra essere una cartella di gioco valida.';

  @override
  String get snackBar7zipPathInvalid =>
      'Il file selezionato deve chiamarsi 7z.exe.';

  @override
  String get snackBarRepairStarted =>
      'Il processo di riparazione delle mod legacy è iniziato...';

  @override
  String snackBarRepairComplete(Object count) {
    return 'Riparazione completata. $count mod sono state aggiornate.';
  }

  @override
  String get snackBarRepairNoMods =>
      'Nessuna mod legacy da riparare è stata trovata.';

  @override
  String get errorApiRequiredForRepair =>
      'È richiesta una chiave API per trovare l\'ultima versione delle mod senza una versione locale.';

  @override
  String get installNewMod => 'Installa Nuova Mod';

  @override
  String get selectFiles => 'Seleziona File';

  @override
  String get selectFolder => 'Seleziona Cartella';

  @override
  String get installSelectedMod => 'Installa Mod Selezionata';

  @override
  String get filesToInstall => 'File da Installare:';

  @override
  String get cancelSelection => 'Annulla Selezione';

  @override
  String get searchMods => 'Cerca mod...';

  @override
  String get enabledMods => 'Mod Abilitate';

  @override
  String get disabledMods => 'Mod Disabilitate';

  @override
  String get refreshList => 'Aggiorna elenco';

  @override
  String get noEnabledMods => 'Nessuna mod abilitata.';

  @override
  String get noDisabledMods => 'Nessuna mod disabilitata.';

  @override
  String get showInFolder => 'Mostra nella cartella';

  @override
  String get disableMod => 'Disabilita mod';

  @override
  String get enableMod => 'Abilita mod';

  @override
  String get deletePermanently => 'Elimina definitivamente';

  @override
  String get language => 'Lingua';

  @override
  String get selectLanguage => 'Seleziona una lingua';

  @override
  String get statusSearchingGame =>
      'Ricerca dell\'installazione di Stellar Blade...';

  @override
  String get statusGamePathFound => 'Percorso del gioco trovato!';

  @override
  String get statusGamePathNotFound =>
      'Impossibile trovare automaticamente il percorso del gioco.';

  @override
  String statusErrorFindingGame(Object error) {
    return 'Si è verificato un errore durante la ricerca del gioco: $error';
  }

  @override
  String statusModsFound(Object disabledCount, Object enabledCount) {
    return '$enabledCount mod abilitate, $disabledCount disabilitate.';
  }

  @override
  String statusErrorReadingMods(Object error) {
    return 'Errore durante la lettura delle mod installate: $error';
  }

  @override
  String statusFilesSelected(Object count) {
    return '$count file selezionato/i. Pronto per l\'installazione.';
  }

  @override
  String statusFolderSelected(Object folderName) {
    return 'Cartella \"$folderName\" selezionata. Pronta per l\'installazione.';
  }

  @override
  String statusArchiveLoaded(Object count, Object fileName) {
    return 'File \"$fileName\" caricato. $count file pronto/i per l\'installazione.';
  }

  @override
  String get statusSelectionCancelled =>
      'Selezione annullata. Scegli una nuova mod da installare.';

  @override
  String get statusUpdateComplete => 'Aggiornamento completato.';

  @override
  String get statusInstallationComplete => 'Installazione completata.';

  @override
  String statusError(Object error) {
    return 'Errore: $error';
  }

  @override
  String get dialogTitle7zip => '7-Zip è Richiesto';

  @override
  String get dialogContent7zip =>
      'Per decomprimere questo file, l\'applicazione necessita di 7-Zip.\n\nInstallalo dalla sua pagina ufficiale e poi premi \"Conferma\".';

  @override
  String get dialogContent7zipNotFound =>
      '7-Zip non è stato ancora rilevato. Assicurati che sia installato nel percorso predefinito e riprova.';

  @override
  String get dialogTitleCNSUpdate =>
      'Rilevato Aggiornamento del Sistema Principale';

  @override
  String get dialogContentCNSUpdate =>
      'È stato rilevato un aggiornamento per il \"Custom Nanosuit System\".\n\nQuesto sostituirà i file nella cartella principale del gioco (StellarBlade\\SB). Desideri continuare?';

  @override
  String get dialogTitleMultipleJsons => 'Rilevati File .json Multipli';

  @override
  String dialogContentMultipleJsons(Object count) {
    return 'Sono stati rilevati $count file .json. Potrebbe trattarsi di una mod con più componenti.\n\nVuoi installarli tutti insieme in un\'unica cartella mod?';
  }

  @override
  String get dialogTitleModExists => 'La Mod Esiste Già';

  @override
  String dialogContentModExists(Object modName) {
    return 'Una mod chiamata \"$modName\" è già installata.\n\nVuoi aggiornarla? I vecchi file verranno eliminati prima di installare i nuovi.';
  }

  @override
  String dialogContentModUpdate(Object newModName, Object oldModName) {
    return 'È stata trovata una versione più vecchia \'$oldModName\'.\n\nVuoi rimuoverla e aggiornare a \'$newModName\'?';
  }

  @override
  String get dialogTitleDeleteMod => 'Eliminare Definitivamente?';

  @override
  String dialogContentDeleteMod(Object modName) {
    return 'Stai per eliminare definitivamente la mod \"$modName\". Questa azione non può essere annullata.\n\nSei sicuro?';
  }

  @override
  String get dialogActionCancel => 'Annulla';

  @override
  String get dialogActionGoToDownload => 'Vai alla Pagina di Download';

  @override
  String get dialogActionConfirmInstallation => 'Conferma Installazione';

  @override
  String get dialogActionUpdateSystem => 'Aggiorna Sistema';

  @override
  String get dialogActionInstallAnyway => 'Installa Comunque';

  @override
  String get dialogActionUpdate => 'Aggiorna';

  @override
  String get dialogActionDelete => 'Elimina';

  @override
  String get dialogActionClose => 'Chiudi';

  @override
  String snackBarBatchInstallComplete(Object failedCount, Object successCount) {
    return 'Installazione batch completata. Successo: $successCount, Falliti: $failedCount.';
  }

  @override
  String snackBarModInstalled(Object modName) {
    return 'Mod \"$modName\" installata con successo.';
  }

  @override
  String snackBarModEnabled(Object modName) {
    return 'Mod \"$modName\" abilitata.';
  }

  @override
  String snackBarModDisabled(Object modName) {
    return 'Mod \"$modName\" disabilitata.';
  }

  @override
  String snackBarModDeleted(Object modName) {
    return 'Mod \"$modName\" eliminata definitivamente.';
  }

  @override
  String get snackBarCNSUpdated =>
      'Custom Nanosuit System aggiornato con successo.';

  @override
  String get snackBarApiKeySaved => 'Chiave API salvata con successo.';

  @override
  String get snackBarGamePathSaved =>
      'Percorso del gioco salvato con successo.';

  @override
  String get snackBar7zipPathSaved => 'Percorso di 7-Zip salvato con successo.';

  @override
  String get snackBarSkippedVersionRemoved => 'Versione saltata rimossa.';

  @override
  String get dropTargetOverlay => 'Trascina qui le mod';

  @override
  String get pathSelectionTitle => 'Percorso di Stellar Blade Non Trovato';

  @override
  String get pathSelectionButtonManual =>
      'Seleziona Manualmente la Cartella del Gioco';

  @override
  String get pathSelectionButtonRetry => 'Riprova';

  @override
  String errorFolderSelection(Object error) {
    return 'Errore durante la selezione della cartella: $error';
  }

  @override
  String errorFileSelection(Object error) {
    return 'Errore durante la selezione dei file: $error';
  }

  @override
  String errorDecompressing(Object error) {
    return 'Errore durante la decompressione del file: $error';
  }

  @override
  String errorProcessingArchive(Object error) {
    return 'Errore durante l\'elaborazione del file: $error';
  }

  @override
  String errorUnsupportedFormat(Object extension) {
    return 'Formato file non supportato: $extension';
  }

  @override
  String get error7zipRequired => 'Operazione annullata: è richiesto 7-Zip.';

  @override
  String get errorGamePathUndefined => 'Il percorso del gioco non è definito.';

  @override
  String get errorDestinationNotFound =>
      'La cartella di destinazione del gioco non esiste.';

  @override
  String errorUpdateSystem(Object error) {
    return 'Errore durante l\'aggiornamento del sistema: $error';
  }

  @override
  String get errorInstallNoSelection =>
      'Non hai selezionato nulla da installare.';

  @override
  String get errorInstallModExists =>
      'Installazione annullata: la mod esiste già.';

  @override
  String get errorNoJsonFound =>
      'Ogni mod deve contenere almeno un file .json.';

  @override
  String errorInvalidJsonFormat(Object fileName) {
    return 'Il file $fileName ha un formato JSON non valido.';
  }

  @override
  String errorNoDisplayName(Object fileName) {
    return 'Il file $fileName non sembra essere una mod del Custom Nanosuit System (manca \"DisplayName\").';
  }

  @override
  String get errorNoValidDisplayName =>
      'Nessun \"DisplayName\" valido trovato nei file .json.';

  @override
  String errorEnableMod(Object error) {
    return 'Errore durante l\'abilitazione della mod: $error';
  }

  @override
  String errorDisableMod(Object error) {
    return 'Errore durante la disabilitazione della mod: $error';
  }

  @override
  String errorDeleteMod(Object error) {
    return 'Errore durante l\'eliminazione della mod: $error';
  }

  @override
  String errorOpenFolder(Object path) {
    return 'Impossibile aprire la cartella: $path';
  }

  @override
  String get statusUpdateSystemCancelled =>
      'Aggiornamento del sistema annullato.';

  @override
  String get statusUpdatingCNS => 'Aggiornamento del Custom Nanosuit System...';

  @override
  String statusExtractingFile(Object fileName) {
    return 'Estrazione di $fileName...';
  }

  @override
  String get statusInstallationCancelledByUser =>
      'Installazione annullata dall\'utente.';

  @override
  String get errorNoCompatibleFilesInFolder =>
      'La cartella selezionata non contiene file mod compatibili.';

  @override
  String get errorNoCompatibleFilesInArchive =>
      'Il file compresso non contiene file mod compatibili.';

  @override
  String get errorNoJsonInSelection =>
      'La selezione non contiene un file .json di mod valido.';

  @override
  String get aboutTitle => 'Informazioni su CNS Control Center';

  @override
  String get aboutContent =>
      'Questa applicazione è un gestore di mod for Stellar Blade, progettato per funzionare con il Custom Nanosuit System (CNS).\n\nRequisito: Per la piena funzionalità con i file .rar e .7z, 7-Zip deve essere installato sul tuo sistema.';

  @override
  String get aboutLinkText => 'Visita il mio profilo creatore';

  @override
  String get creatorProfileUrl =>
      'https://next.nexusmods.com/profile/LuisNandez?gameId=7804';

  @override
  String aboutVersion(Object version) {
    return 'Versione: $version';
  }

  @override
  String get openModsFolder => 'Apri Cartella Mod';

  @override
  String get openInNexusMods => 'Apri in Nexus Mods';

  @override
  String get checkForUpdates => 'Controlla aggiornamenti';

  @override
  String updateAvailable(Object version) {
    return 'Aggiornamento disponibile: v$version';
  }

  @override
  String get dialogTitleApiKey => 'Chiave API di Nexus Mods';

  @override
  String get dialogContentApiKey =>
      'Per controllare gli aggiornamenti delle mod, hai bisogno di una chiave API personale da Nexus Mods.';

  @override
  String get dialogContentApiKeyInstructions =>
      '1. Vai su Nexus Mods e accedi.\n2. Clicca sul tuo avatar e vai su \'Site preferences\'.\n3. Vai alla scheda \'API\'.\n4. Clicca su \'Generate a new API key\'.\n5. Copia la chiave e incollala qui.';

  @override
  String get apiKey => 'Chiave API';

  @override
  String get apiKeyHintText => 'Incolla qui la tua chiave API';

  @override
  String get dialogActionSave => 'Salva';

  @override
  String get apiKeyRemoved => 'Chiave API rimossa.';

  @override
  String get invalidApiKeyError => 'Chiave API non valida.';

  @override
  String get validatingApiKey => 'Convalida in corso...';

  @override
  String get errorApiKeyMissing =>
      'La chiave API di Nexus Mods non è configurata. Aggiungila tramite l\'icona a forma di chiave nella barra superiore.';

  @override
  String get statusCheckingUpdates => 'Controllo aggiornamenti mod...';

  @override
  String statusUpdatesFound(Object count) {
    return '$count aggiornamento/i trovato/i!';
  }

  @override
  String get statusNoUpdates => 'Tutte le mod sono aggiornate.';

  @override
  String get selectModArchive => 'Seleziona Archivio Mod';

  @override
  String get viewImageGallery => 'Visualizza Immagine';

  @override
  String get imageGallery => 'Galleria Immagini';

  @override
  String get noImagesFound =>
      'Nessuna immagine trovata per questa mod, o la chiave API non è stata inserita. Inserisci la chiave API e controlla gli aggiornamenti.';

  @override
  String errorFetchingImages(Object error) {
    return 'Errore nel recupero delle immagini: $error';
  }

  @override
  String get imageMod => 'Immagine Mod';

  @override
  String get modEnabledBadge => 'Enabled';

  @override
  String get modDisabledBadge => 'Disabled';

  @override
  String get modCategoryOther => 'Other';

  @override
  String get dialogContentUpdateOptions => 'Cosa vorresti fare?';

  @override
  String get dialogActionIgnoreVersion => 'Ignora';

  @override
  String get dialogActionSkipVersion => 'Salta Versione';

  @override
  String get dialogActionGoToDownloadPage => 'Vai al Download';

  @override
  String get installedMods => 'Mod Installate';

  @override
  String get filterBy => 'Filtra per:';

  @override
  String get sortBy => 'Ordina per:';

  @override
  String get filterAll => 'Tutte';

  @override
  String get filterEnabled => 'Abilitate';

  @override
  String get filterDisabled => 'Disabilitate';

  @override
  String get filterRepaired => 'Riparate';

  @override
  String get sortByName => 'Nome';

  @override
  String get sortByDate => 'Data';

  @override
  String get noModsFound => 'Nessuna mod trovata.';

  @override
  String statusExtractingMultipleFiles(
    Object count,
    Object fileName,
    Object total,
  ) {
    return 'Estrazione di $count di $total: $fileName';
  }

  @override
  String get previewInstallTitle => 'Mod da Installare:';

  @override
  String get dialogTitleUE4SS => 'Rilevata Installazione di UE4SS';

  @override
  String get dialogContentUE4SS =>
      'Lo strumento UE4SS è stato rilevato. Vuoi installarlo in \'StellarBlade\\SB\\Binaries\\Win64\'?\n\nQuesto è necessario per il funzionamento di molte mod.';

  @override
  String get dialogActionInstallTool => 'Installa Strumento';

  @override
  String get statusUE4SSInstallCancelled => 'Installazione di UE4SS annullata.';

  @override
  String get statusInstallingUE4SS => 'Installazione di UE4SS...';

  @override
  String get snackBarUE4SSInstalled => 'UE4SS installato con successo.';

  @override
  String error7zipDecompression(Object error) {
    return 'Errore di 7-Zip durante la decompressione: $error';
  }

  @override
  String get statusUE4SSInstallComplete => 'Installazione di UE4SS completata.';

  @override
  String get dialogTitleAlternativeVersion => 'Rilevata Versione Alternativa';

  @override
  String dialogContentAlternativeVersion(
    String oldModName,
    String baseModName,
    String newModName,
  ) {
    return 'Una versione alternativa di questa mod è già installata: \'$oldModName\'.\n\nStai per installare un\'alternativa diversa chiamata \'$newModName\'.';
  }

  @override
  String get dialogActionReplace => 'Sostituisci';

  @override
  String get dialogActionInstallAsNew => 'Installa come Nuova';

  @override
  String get dialogTitleUpdate => 'Aggiornamento Disponibile';

  @override
  String dialogContentUpdate(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return 'Stai per aggiornare la mod \'$modName\'.\n\nVersione installata: $oldVersion\nNuova versione: $newVersion';
  }

  @override
  String get dialogTitleDowngrade => 'Rilevata Versione Più Vecchia';

  @override
  String dialogContentDowngrade(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return 'Attenzione: Stai per installare una versione più vecchia della mod \'$modName\'.\n\nVersione installata: $oldVersion\nVersione da installare: $newVersion';
  }

  @override
  String get dialogActionDowngrade => 'Downgrade';

  @override
  String get dialogTitleReinstall => 'Reinstalla Mod';

  @override
  String dialogContentReinstall(Object modName, Object version) {
    return 'Stai per reinstallare la versione \'$version\' della mod \'$modName\'.';
  }

  @override
  String get dialogActionReinstall => 'Reinstalla';

  @override
  String get editModNameTooltip => 'Modifica nome mod';

  @override
  String get dialogTitleEditModName => 'Modifica Nome Mod';

  @override
  String get dialogActionResetToDefault => 'Reset to Default';

  @override
  String get dialogLabelNewName => 'Nuovo nome';

  @override
  String errorModNameExists(Object modName) {
    return 'Una mod chiamata \"$modName\" esiste già.';
  }

  @override
  String get dialogTitleRepairedModWarning => 'Avviso Mod Riparata';

  @override
  String get dialogContentRepairedModWarning =>
      'Questa mod potrebbe non avere le informazioni sulla versione corrette. Si consiglia di reinstallare l\'ultima versione per garantire la compatibilità.';

  @override
  String get repairedModTooltip => 'Informazioni sulla mod riparata';

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
