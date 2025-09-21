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
  String get settingsPathsAndTools => 'Percorsi e strumenti';

  @override
  String get settingsGameFolder => 'Cartella del gioco';

  @override
  String get settingsGameFolderDesc =>
      'La cartella principale della tua installazione di Stellar Blade.';

  @override
  String get settings7zipPath => 'Percorso 7-Zip';

  @override
  String get settings7zipPathDesc =>
      'La posizione del file 7z.exe per l\'estrazione delle mod.';

  @override
  String get settings7zipPathAuto => 'Ricerca automatica';

  @override
  String get settingsRepairMods => 'Ripara mod obsolete';

  @override
  String get settingsRepairModsDesc =>
      'Scansiona e crea file informativi per le vecchie mod utilizzando il database locale. Richiede la chiave API.';

  @override
  String get settingsConnectivity => 'Connettività e aggiornamenti';

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
  String get settingsSkippedVersions => 'Gestisci versioni saltate';

  @override
  String get settingsSkippedVersionsDesc =>
      'Gestisci le versioni delle mod che hai scelto di saltare.';

  @override
  String settingsSkippedVersionsCount(Object count) {
    return '$count versioni saltate';
  }

  @override
  String get dialogTitleSkippedVersions => 'Versioni mod saltate';

  @override
  String get dialogNoSkippedVersions =>
      'Non hai saltato nessuna versione di mod.';

  @override
  String get dialogSkippedVersions => 'Versione saltata';

  @override
  String get dialogTitleRepairMods =>
      'Eseguire la riparazione delle mod obsolete?';

  @override
  String get dialogContentRepairMods =>
      'Avvertenza: questa funzione è in fase di sviluppo e potrebbe non essere perfetta.\n\nScansionerà le mod senza un file \'nexus_info.json\' e, se trovata nel tuo database locale, ne creerà uno. Tenterà anche di rinominare la cartella della mod per includere la versione trovata (ad esempio, \'La mia mod\' -> \'La mia mod v1.2\').\n\nPriorità della versione:\n1. Dal nome della cartella.\n2. Dal campo della descrizione della mod.\n3. Dall\'ultima versione su Nexus Mods (richiede API).\n\nVuoi continuare?';

  @override
  String get dialogActionRunRepair => 'Esegui riparazione';

  @override
  String get snackBarGamePathInvalid =>
      'La cartella selezionata non sembra essere una cartella di gioco valida.';

  @override
  String get snackBar7zipPathInvalid =>
      'Il file selezionato deve essere denominato 7z.exe.';

  @override
  String get snackBarRepairStarted =>
      'Il processo di riparazione delle mod obsolete è iniziato...';

  @override
  String snackBarRepairComplete(Object count) {
    return 'Riparazione completata. $count mod sono state aggiornate.';
  }

  @override
  String get snackBarRepairNoMods =>
      'Non sono state trovate mod obsolete che necessitavano di riparazione.';

  @override
  String get errorApiRequiredForRepair =>
      'La chiave API è necessaria per trovare l\'ultima versione per le mod senza una versione locale.';

  @override
  String get installNewMod => 'Installa nuova mod';

  @override
  String get selectFiles => 'Seleziona file';

  @override
  String get selectFolder => 'Seleziona cartella';

  @override
  String get installSelectedMod => 'Installa mod selezionata';

  @override
  String get filesToInstall => 'File da installare:';

  @override
  String get cancelSelection => 'Annulla selezione';

  @override
  String get searchMods => 'Cerca mod...';

  @override
  String get enabledMods => 'Mod abilitate';

  @override
  String get disabledMods => 'Mod disabilitate';

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
    return '$count file selezionati. Pronti per l\'installazione.';
  }

  @override
  String statusFolderSelected(Object folderName) {
    return 'Cartella \"$folderName\" selezionata. Pronta per l\'installazione.';
  }

  @override
  String statusArchiveLoaded(Object count, Object fileName) {
    return 'File \"$fileName\" caricato. $count file pronti per l\'installazione.';
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
  String get dialogTitle7zip => 'È richiesto 7-Zip';

  @override
  String get dialogContent7zip =>
      'Per decomprimere questo file, l\'applicazione necessita di 7-Zip.\n\nInstallalo dalla sua pagina ufficiale e poi premi \"Conferma\".';

  @override
  String get dialogContent7zipNotFound =>
      '7-Zip non è stato ancora rilevato. Assicurati che sia installato nel percorso predefinito e riprova.';

  @override
  String get dialogTitleCNSUpdate =>
      'Rilevato aggiornamento del sistema principale';

  @override
  String get dialogContentCNSUpdate =>
      'È stato rilevato un aggiornamento per il \"Custom Nanosuit System\".\n\nQuesto sostituirà i file nella cartella principale del gioco (StellarBlade\\SB). Desideri continuare?';

  @override
  String get dialogTitleMultipleJsons => 'Rilevati più file .json';

  @override
  String dialogContentMultipleJsons(Object count) {
    return 'Sono stati rilevati $count file .json. Potrebbe trattarsi di una mod con più componenti.\n\nVuoi installarli tutti insieme in un\'unica cartella mod?';
  }

  @override
  String get dialogTitleModExists => 'La mod esiste già';

  @override
  String dialogContentModExists(Object modName) {
    return 'Una mod chiamata \"$modName\" è già installata.\n\nVuoi aggiornarla? I vecchi file verranno eliminati prima di installare quelli nuovi.';
  }

  @override
  String dialogContentModUpdate(Object newModName, Object oldModName) {
    return 'È stata trovata una versione precedente \'$oldModName\'.\n\nVuoi rimuoverla e aggiornare a \'$newModName\'?';
  }

  @override
  String get dialogTitleDeleteMod => 'Eliminare definitivamente?';

  @override
  String dialogContentDeleteMod(Object modName) {
    return 'Stai per eliminare definitivamente la mod \"$modName\". Questa azione non può essere annullata.\n\nSei sicuro?';
  }

  @override
  String get dialogActionCancel => 'Annulla';

  @override
  String get dialogActionGoToDownload => 'Vai alla pagina di download';

  @override
  String get dialogActionConfirmInstallation => 'Conferma installazione';

  @override
  String get dialogActionUpdateSystem => 'Aggiorna sistema';

  @override
  String get dialogActionInstallAnyway => 'Installa comunque';

  @override
  String get dialogActionUpdate => 'Aggiorna';

  @override
  String get dialogActionDelete => 'Elimina';

  @override
  String get dialogActionClose => 'Chiudi';

  @override
  String snackBarBatchInstallComplete(Object failedCount, Object successCount) {
    return 'Installazione batch completata. Successo: $successCount, Fallito: $failedCount.';
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
  String get snackBar7zipPathSaved => 'Percorso 7-Zip salvato con successo.';

  @override
  String get snackBarSkippedVersionRemoved => 'Versione saltata rimossa.';

  @override
  String get dropTargetOverlay => 'Trascina qui le mod';

  @override
  String get pathSelectionTitle => 'Percorso di Stellar Blade non trovato';

  @override
  String get pathSelectionButtonManual =>
      'Seleziona manualmente la cartella del gioco';

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
      'La selezione non contiene un file .json mod valido.';

  @override
  String get aboutTitle => 'Informazioni su CNS Control Center';

  @override
  String get aboutContent =>
      'Questa applicazione è un gestore di mod per Stellar Blade, progettato per funzionare con il Custom Nanosuit System (CNS).\n\nRequisito: per la piena funzionalità con i file .rar e .7z, 7-Zip deve essere installato sul tuo sistema.';

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
  String get openModsFolder => 'Apri cartella mod';

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
      '1. Vai su Nexus Mods e accedi.\n2. Fai clic sul tuo avatar e vai su \'Preferenze del sito\'.\n3. Vai alla scheda \'API\'.\n4. Fai clic su \'Genera una nuova chiave API\'.\n5. Copia la chiave e incollala qui.';

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
      'La chiave API di Nexus Mods non è configurata. Aggiungila tramite l\'icona della chiave nella barra in alto.';

  @override
  String get statusCheckingUpdates =>
      'Controllo degli aggiornamenti delle mod...';

  @override
  String statusUpdatesFound(Object count) {
    return '$count aggiornamenti trovati!';
  }

  @override
  String get statusNoUpdates => 'Tutte le mod sono aggiornate.';

  @override
  String get selectModArchive => 'Seleziona archivio mod';

  @override
  String get viewImageGallery => 'Visualizza immagine';

  @override
  String get imageGallery => 'Galleria di immagini';

  @override
  String get noImagesFound =>
      'Nessuna immagine trovata per questa mod, oppure la chiave API non è stata inserita. Inserisci la chiave API e controlla gli aggiornamenti in seguito.';

  @override
  String errorFetchingImages(Object error) {
    return 'Errore durante il recupero delle immagini: $error';
  }

  @override
  String get imageMod => 'Immagine della mod';

  @override
  String get modEnabledBadge => 'Abilitata';

  @override
  String get modDisabledBadge => 'Disabilitata';

  @override
  String get modCategoryOther => 'Non specificato';

  @override
  String get dialogContentUpdateOptions => 'Cosa vorresti fare?';

  @override
  String get dialogActionIgnoreVersion => 'Ignora';

  @override
  String get dialogActionSkipVersion => 'Salta versione';

  @override
  String get dialogActionGoToDownloadPage => 'Vai al download';

  @override
  String get installedMods => 'Mod installate';

  @override
  String get filterBy => 'Filtra:';

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
  String get viewTypeGrid => 'Visualizzazione a griglia';

  @override
  String get viewTypeList => 'Visualizzazione a elenco';

  @override
  String statusExtractingMultipleFiles(
    Object count,
    Object fileName,
    Object total,
  ) {
    return 'Estrazione di $count di $total: $fileName';
  }

  @override
  String get previewInstallTitle => 'Mod da installare:';

  @override
  String get dialogTitleUE4SS => 'Rilevata installazione di UE4SS';

  @override
  String get dialogContentUE4SS =>
      'Lo strumento UE4SS è stato rilevato. Vuoi installarlo in \'StellarBlade\\SB\\Binaries\\Win64\'?\n\nÈ necessario per il funzionamento di molte mod.';

  @override
  String get dialogActionInstallTool => 'Installa strumento';

  @override
  String get statusUE4SSInstallCancelled => 'Installazione di UE4SS annullata.';

  @override
  String get statusInstallingUE4SS => 'Installazione di UE4SS in corso...';

  @override
  String get snackBarUE4SSInstalled => 'UE4SS installato con successo.';

  @override
  String error7zipDecompression(Object error) {
    return 'Errore 7-Zip durante la decompressione: $error';
  }

  @override
  String get statusUE4SSInstallComplete => 'Installazione di UE4SS completata.';

  @override
  String get dialogTitleAlternativeVersion => 'Rilevata versione alternativa';

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
  String get dialogActionInstallAsNew => 'Installa come nuova';

  @override
  String get dialogTitleUpdate => 'Aggiornamento disponibile';

  @override
  String dialogContentUpdate(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return 'Stai per aggiornare la mod \'$modName\'.\n\nVersione installata: $oldVersion\nNuova versione: $newVersion';
  }

  @override
  String get dialogTitleDowngrade => 'Rilevata versione precedente';

  @override
  String dialogContentDowngrade(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return 'Avvertenza: stai per installare una versione precedente della mod \'$modName\'.\n\nVersione installata: $oldVersion\nVersione da installare: $newVersion';
  }

  @override
  String get dialogActionDowngrade => 'Downgrade';

  @override
  String get dialogTitleReinstall => 'Reinstalla mod';

  @override
  String dialogContentReinstall(Object modName, Object version) {
    return 'Stai per reinstallare la versione \'$version\' della mod \'$modName\'.';
  }

  @override
  String get dialogActionReinstall => 'Reinstalla';

  @override
  String get editModNameTooltip => 'Modifica nome mod';

  @override
  String get dialogTitleEditModName => 'Modifica nome mod';

  @override
  String get dialogActionResetToDefault => 'Ripristina predefinito';

  @override
  String get dialogLabelNewName => 'Nuovo nome';

  @override
  String errorModNameExists(Object modName) {
    return 'Esiste già una mod chiamata \"$modName\".';
  }

  @override
  String get dialogTitleRepairedModWarning => 'Avviso mod riparata';

  @override
  String get dialogContentRepairedModWarning =>
      'Questa mod potrebbe non avere le informazioni corrette sulla versione. Si consiglia di reinstallare l\'ultima versione per garantire la compatibilità.';

  @override
  String get repairedModTooltip => 'Informazioni sulla mod riparata';

  @override
  String get disableAllModsTooltip => 'Disabilita tutte le mod';

  @override
  String get deleteAllModsTooltip => 'Elimina tutte le mod disabilitate';

  @override
  String get dialogTitleDisableAll => 'Disabilitare tutte le mod?';

  @override
  String dialogContentDisableAll(int count) {
    return 'Sei sicuro di voler disabilitare tutte le $count mod abilitate? Verranno spostate nella cartella di backup.';
  }

  @override
  String get dialogTitleDeleteAll => 'Eliminare le mod disabilitate?';

  @override
  String dialogContentDeleteAll(int count) {
    return 'Stai per eliminare definitivamente tutte le $count mod disabilitate. Questa azione non può essere annullata.\n\nSei sicuro?';
  }

  @override
  String snackBarAllModsDisabled(int count) {
    return 'Tutte le $count mod abilitate sono state disabilitate.';
  }

  @override
  String snackBarAllModsDeleted(int count) {
    return 'Tutte le $count mod disabilitate sono state eliminate definitivamente.';
  }

  @override
  String get snackBarNoModsToDisable =>
      'Non ci sono mod abilitate da disabilitare.';

  @override
  String get snackBarNoModsToDelete =>
      'Non ci sono mod disabilitate da eliminare.';

  @override
  String get enableAllModsTooltip => 'Abilita tutte le mod';

  @override
  String get dialogTitleEnableAll => 'Abilitare tutte le mod?';

  @override
  String dialogContentEnableAll(int count) {
    return 'Sei sicuro di voler abilitare tutte le $count mod disabilitate? Verranno spostate nella cartella principale delle mod.';
  }

  @override
  String snackBarAllModsEnabled(int count) {
    return 'Tutte le $count mod disabilitate sono state abilitate.';
  }

  @override
  String get snackBarNoModsToEnable =>
      'Non ci sono mod disabilitate da abilitare.';
}
