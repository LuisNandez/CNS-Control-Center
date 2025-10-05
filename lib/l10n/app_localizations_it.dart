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
  String get settingsGameFolder => 'Cartella del Gioco';

  @override
  String get settingsGameFolderDesc =>
      'La cartella principale della tua installazione di Stellar Blade.';

  @override
  String get settings7zipPath => 'Percorso 7-Zip';

  @override
  String get settings7zipPathDesc =>
      'La posizione del file 7z.exe per estrarre le mod.';

  @override
  String get settings7zipPathAuto => 'Ricerca automatica';

  @override
  String get settingsRepairMods => 'Ripara Mod Legacy';

  @override
  String get settingsRepairModsDesc =>
      'Scansiona e crea file informativi per le vecchie mod utilizzando il database locale. Richiede la chiave API.';

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
      'Attenzione: Questa funzionalità è in fase di sviluppo e potrebbe non essere perfetta.\n\nScansionerà le mod senza un file \'nexus_info.json\' e, se trovate nel tuo database locale, ne creerà uno per loro. Tenterà anche di rinominare la cartella della mod per includere la versione trovata (es. \'La Mia Mod\' -> \'La Mia Mod v1.2\').\n\nPriorità della Versione:\n1. Dal nome della cartella.\n2. Dal campo descrizione della mod.\n3. Dall\'ultima versione su Nexus Mods (richiede API).\n\nVuoi continuare?';

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
      'È richiesta la chiave API per trovare l\'ultima versione delle mod senza una versione locale.';

  @override
  String get installNewMod => 'Installa Nuova Mod';

  @override
  String get selectFiles => 'Seleziona File';

  @override
  String get selectFolder => 'Seleziona Cartella';

  @override
  String get installSelectedMod => 'Installa Mod Selezionata';

  @override
  String get filesToInstall => 'File da installare:';

  @override
  String get cancelSelection => 'Annulla Selezione';

  @override
  String get searchMods => 'Cerca mod...';

  @override
  String get enabledMods => 'Mod Abilitate';

  @override
  String get disabledMods => 'Mod Disabilitate';

  @override
  String get refreshList => 'Aggiorna lista';

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
      'Ricerca dell\'installazione di Stellar Blade in corso...';

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
    return 'Errore nella lettura delle mod installate: $error';
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
  String get dialogTitle7zip => 'È richiesto 7-Zip';

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
      'È stato rilevato un aggiornamento per il \"Sistema Nanosuit Personalizzato\".\n\nQuesto sostituirà i file nella cartella principale del gioco (StellarBlade\\SB). Desideri continuare?';

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
      'Sistema Nanosuit Personalizzato aggiornato con successo.';

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
  String get dropTargetOverlay => 'Trascina le mod qui';

  @override
  String get pathSelectionTitle => 'Percorso di Stellar Blade Non Trovato';

  @override
  String get pathSelectionButtonManual =>
      'Seleziona Manualmente la Cartella del Gioco';

  @override
  String get pathSelectionButtonRetry => 'Riprova';

  @override
  String errorFolderSelection(Object error) {
    return 'Errore nella selezione della cartella: $error';
  }

  @override
  String errorFileSelection(Object error) {
    return 'Errore nella selezione dei file: $error';
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
      'Nessun \"DisplayName\" valido è stato trovato nei file .json.';

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
  String get statusUpdatingCNS =>
      'Aggiornamento del Sistema Nanosuit Personalizzato...';

  @override
  String statusExtractingFile(Object fileName) {
    return 'Estrazione di $fileName...';
  }

  @override
  String get statusInstallationCancelledByUser =>
      'Installazione annullata dall\'utente.';

  @override
  String get errorNoCompatibleFilesInFolder =>
      'La cartella selezionata non contiene file di mod compatibili.';

  @override
  String get errorNoCompatibleFilesInArchive =>
      'Il file compresso non contiene file di mod compatibili.';

  @override
  String get errorNoJsonInSelection =>
      'La selezione non contiene un file .json di mod valido.';

  @override
  String get aboutTitle => 'Informazioni sul Centro di Controllo CNS';

  @override
  String get aboutContent =>
      'Questa applicazione è un gestore di mod per Stellar Blade, progettato per funzionare con il Sistema Nanosuit Personalizzato (CNS).\n\nRequisito: Per la piena funzionalità con i file .rar e .7z, 7-Zip deve essere installato sul tuo sistema.';

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
      '1. Vai su Nexus Mods e accedi.\n2. Clicca sul tuo avatar e vai su \'Preferenze del sito\'.\n3. Vai alla scheda \'API\'.\n4. Clicca su \'Genera una nuova chiave API\'.\n5. Copia la chiave e incollala qui.';

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
  String get statusCheckingUpdates => 'Controllo aggiornamenti mod in corso...';

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
      'Nessuna immagine trovata per questa mod, o la chiave API non è stata inserita. Inserisci la chiave API e controlla gli aggiornamenti in seguito.';

  @override
  String errorFetchingImages(Object error) {
    return 'Errore nel recupero delle immagini: $error';
  }

  @override
  String get imageMod => 'Immagine Mod';

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
  String get viewTypeGrid => 'Vista a griglia';

  @override
  String get viewTypeList => 'Vista a lista';

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
    return 'Errore 7-Zip durante la decompressione: $error';
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
  String get setCoverTooltip => 'Imposta immagine di copertina personalizzata';

  @override
  String get setCoverText => 'Imposta Copertina';

  @override
  String get restoreOriginalCoverText => 'Ripristina Copertina Originale';

  @override
  String errorSavingCoverText(Object error) {
    return 'Errore nel salvataggio dell\'immagine di copertina: $error';
  }

  @override
  String errorRestoringCoverText(Object error) {
    return 'Errore nel ripristino dell\'immagine di copertina originale: $error';
  }

  @override
  String get editVersionText => 'Modifica Versione';

  @override
  String get customVersionText => 'Versione Personalizzata';

  @override
  String get editTagText => 'Modifica Etichetta';

  @override
  String get customTagText => 'Etichetta Personalizzata';

  @override
  String get dialogTitleEditModName => 'Modifica Nome Mod';

  @override
  String get dialogActionResetToDefault => 'Ripristina Predefinito';

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
      'Questa mod potrebbe non avere le informazioni corrette sulla versione. Si consiglia di reinstallare l\'ultima versione per garantire la compatibilità.';

  @override
  String get repairedModTooltip => 'Informazioni sulla mod riparata';

  @override
  String get disableAllModsTooltip => 'Disabilita tutte le mod';

  @override
  String get deleteAllModsTooltip => 'Elimina tutte le mod disabilitate';

  @override
  String get dialogTitleDisableAll => 'Disabilitare Tutte le Mod?';

  @override
  String dialogContentDisableAll(int count) {
    return 'Sei sicuro di voler disabilitare tutte le $count mod abilitate? Verranno spostate nella cartella di backup.';
  }

  @override
  String get dialogTitleDeleteAll => 'Eliminare le Mod Disabilitate?';

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
  String get dialogTitleEnableAll => 'Abilitare Tutte le Mod?';

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

  @override
  String get editNotes => 'Edit Notes';

  @override
  String get notesHintText => 'Add your personal notes here...';

  @override
  String get modAuthor => 'Author';

  @override
  String get modDescription => 'Description';

  @override
  String get noDescriptionAvailable => 'No description available.';

  @override
  String get personalNotes => 'Personal Notes';

  @override
  String get noNotesAvailable => 'No notes added yet.';

  @override
  String get modDetailsTitle => 'Mod Details';

  @override
  String get modVersion => 'Version';

  @override
  String get modCategory => 'Category';

  @override
  String get dialogTitleAddUrl => 'Add Mod Link';

  @override
  String get dialogLabelUrl => 'Mod URL';

  @override
  String get errorInvalidUrl => 'Please enter a valid URL.';

  @override
  String get addLinkTooltip => 'Add a download link for this mod';

  @override
  String get addLinkButtonText => 'Add Link';

  @override
  String get openLinkButtonText => 'Open Link';

  @override
  String get editModTitle => 'Edit Mod Details';

  @override
  String get modNameLabel => 'Mod Name';

  @override
  String get authorLabel => 'Author';

  @override
  String get summaryLabel => 'Description / Summary';

  @override
  String get notesLabel => 'Personal Notes';

  @override
  String get urlLabel => 'Download URL';

  @override
  String get changeCoverButton => 'Change Cover Image';

  @override
  String get editButtonTooltip => 'Edit Mod';

  @override
  String get errorSavingNotes => 'Error saving notes';

  @override
  String get errorSavingUrl => 'Error saving URL';

  @override
  String get errorSavingChanges => 'Error Saving Changes';
}
