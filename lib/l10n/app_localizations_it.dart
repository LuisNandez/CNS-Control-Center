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
  String get settings => 'Impostazioni';

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
    return '$enabledCount mod abilitata(e), $disabledCount disabilitata(e).';
  }

  @override
  String statusErrorReadingMods(Object error) {
    return 'Errore nella lettura delle mod installate: $error';
  }

  @override
  String statusFilesSelected(Object count) {
    return '$count file selezionato(i). Pronto per l\'installazione.';
  }

  @override
  String statusFolderSelected(Object folderName) {
    return 'Cartella \"$folderName\" selezionata.\nPronto per l\'installazione.';
  }

  @override
  String statusArchiveLoaded(Object count, Object fileName) {
    return 'File \"$fileName\" caricato.\n$count file pronto(i) per l\'installazione.';
  }

  @override
  String get statusSelectionCancelled =>
      'Selezione annullata.\nScegli una nuova mod da installare.';

  @override
  String get statusUpdateComplete => 'Aggiornamento completato.';

  @override
  String get statusInstallationComplete => 'Installazione completata.';

  @override
  String statusError(Object error) {
    return 'Errore: $error';
  }

  @override
  String get dialogTitle7zip => 'È Richiesto 7-Zip';

  @override
  String get dialogContent7zip =>
      'Per decomprimere questo file, l\'applicazione necessita di 7-Zip.\n\nInstallalo dalla sua pagina ufficiale e poi premi \"Conferma\".';

  @override
  String get dialogContent7zipNotFound =>
      '7-Zip non è stato ancora rilevato.\nAssicurati che sia installato nel percorso predefinito e riprova.';

  @override
  String get dialogTitleCNSUpdate =>
      'Rilevato Aggiornamento del Sistema Principale';

  @override
  String get dialogContentCNSUpdate =>
      'È stato rilevato un aggiornamento per il \"Custom Nanosuit System\".\n\nQuesto sostituirà i file nella cartella principale del gioco (StellarBlade\\SB).\nDesideri continuare?';

  @override
  String get dialogTitleMultipleJsons => 'Rilevati File .json Multipli';

  @override
  String dialogContentMultipleJsons(Object count) {
    return 'Sono stati rilevati $count file .json.\nPotrebbe trattarsi di una mod con più componenti.\n\nVuoi installarli tutti insieme in un\'unica cartella mod?';
  }

  @override
  String get dialogTitleModExists => 'La Mod Esiste Già';

  @override
  String dialogContentModExists(Object modName) {
    return 'Una mod chiamata \"$modName\" è già installata.\n\nVuoi aggiornarla?\nI vecchi file verranno eliminati prima di installare quelli nuovi.';
  }

  @override
  String dialogContentModUpdate(Object newModName, Object oldModName) {
    return 'È stata trovata una versione precedente \'$oldModName\'.\n\nVuoi rimuoverla e aggiornare a \'$newModName\'?';
  }

  @override
  String get dialogTitleDeleteMod => 'Eliminare Definitivamente?';

  @override
  String dialogContentDeleteMod(Object modName) {
    return 'Stai per eliminare definitivamente la mod \"$modName\".\nQuesta azione non può essere annullata.\n\nSei sicuro?';
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
    return 'Installazione batch completata.\nSuccesso: $successCount, Falliti: $failedCount.';
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
      'Nessun \"DisplayName\" valido trovato nei file .json.';

  @override
  String errorEnableMod(Object error) {
    return 'Errore nell\'abilitare la mod: $error';
  }

  @override
  String errorDisableMod(Object error) {
    return 'Errore nel disabilitare la mod: $error';
  }

  @override
  String errorDeleteMod(Object error) {
    return 'Errore nell\'eliminare la mod: $error';
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
      'Aggiornamento di Custom Nanosuit System in corso...';

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
      'La selezione non contiene un file .json valido per la mod.';

  @override
  String get aboutTitle => 'Informazioni su CNS Control Center';

  @override
  String get aboutContent =>
      'Questa applicazione è un gestore di mod per Stellar Blade, progettato per funzionare con il Custom Nanosuit System (CNS).\n\nRequisito: Per la piena funzionalità con i file .rar e .7z, è necessario che 7-Zip sia installato sul sistema.';

  @override
  String get aboutLinkText => 'Visita il mio profilo creatore';

  @override
  String get creatorProfileUrl =>
      'https://www.nexusmods.com/users/your-user-id';

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
      'Per verificare la presenza di aggiornamenti delle mod, è necessaria una chiave API personale di Nexus Mods.\nPuoi generarne una nelle impostazioni del tuo profilo sul loro sito web.';

  @override
  String get apiKey => 'Chiave API';

  @override
  String get dialogActionSave => 'Salva';

  @override
  String get snackBarApiKeySaved => 'Chiave API salvata con successo.';

  @override
  String get errorApiKeyMissing =>
      'La chiave API di Nexus Mods non è configurata.\nAggiungila nelle impostazioni.';

  @override
  String get statusCheckingUpdates => 'Verifica aggiornamenti mod in corso...';

  @override
  String statusUpdatesFound(Object count) {
    return '$count aggiornamento(i) trovato(i)!';
  }

  @override
  String get statusNoUpdates => 'Tutte le mod sono aggiornate.';

  @override
  String get selectModArchive => 'Seleziona Archivio Mod';

  @override
  String get viewImageGallery => 'Visualizza Galleria Immagini';

  @override
  String get imageGallery => 'Galleria Immagini';

  @override
  String get noImagesFound => 'Nessuna immagine trovata per questa mod.';

  @override
  String errorFetchingImages(Object error) {
    return 'Errore nel recupero delle immagini: $error';
  }

  @override
  String get imageMod => 'Immagine Mod';

  @override
  String get dialogContentUpdateOptions => 'Cosa vorresti fare?';

  @override
  String get dialogActionIgnoreVersion => 'Ignora Versione';

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
    return 'Estrazione di $count su $total: $fileName';
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
  String get statusInstallingUE4SS => 'Installazione di UE4SS in corso...';

  @override
  String get snackBarUE4SSInstalled => 'UE4SS installato con successo.';

  @override
  String error7zipDecompression(Object error) {
    return 'Errore di 7-Zip durante la decompressione: $error';
  }

  @override
  String get statusUE4SSInstallComplete => 'Installazione di UE4SS completata.';
}
