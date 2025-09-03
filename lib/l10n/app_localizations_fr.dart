// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Centre de Contrôle CNS';

  @override
  String appTitleWithVersion(Object version) {
    return 'Custom Nanosuit System $version';
  }

  @override
  String get settings => 'Paramètres';

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
  String get installNewMod => 'Installer un Nouveau Mod';

  @override
  String get selectFiles => 'Sélectionner des Fichiers';

  @override
  String get selectFolder => 'Sélectionner un Dossier';

  @override
  String get installSelectedMod => 'Installer le Mod Sélectionné';

  @override
  String get filesToInstall => 'Fichiers à Installer :';

  @override
  String get cancelSelection => 'Annuler la Sélection';

  @override
  String get searchMods => 'Rechercher des mods...';

  @override
  String get enabledMods => 'Mods Activés';

  @override
  String get disabledMods => 'Mods Désactivés';

  @override
  String get refreshList => 'Actualiser la liste';

  @override
  String get noEnabledMods => 'Aucun mod activé.';

  @override
  String get noDisabledMods => 'Aucun mod désactivé.';

  @override
  String get showInFolder => 'Afficher dans le dossier';

  @override
  String get disableMod => 'Désactiver le mod';

  @override
  String get enableMod => 'Activer le mod';

  @override
  String get deletePermanently => 'Supprimer définitivement';

  @override
  String get language => 'Langue';

  @override
  String get selectLanguage => 'Sélectionnez une langue';

  @override
  String get statusSearchingGame =>
      'Recherche de l\'installation de Stellar Blade...';

  @override
  String get statusGamePathFound => 'Chemin du jeu trouvé !';

  @override
  String get statusGamePathNotFound =>
      'Impossible de trouver automatically le chemin du jeu.';

  @override
  String statusErrorFindingGame(Object error) {
    return 'Une erreur s\'est produite lors de la recherche du jeu : $error';
  }

  @override
  String statusModsFound(Object disabledCount, Object enabledCount) {
    return '$enabledCount mod(s) activé(s), $disabledCount désactivé(s).';
  }

  @override
  String statusErrorReadingMods(Object error) {
    return 'Erreur lors de la lecture des mods installés : $error';
  }

  @override
  String statusFilesSelected(Object count) {
    return '$count fichier(s) sélectionné(s). Prêt pour l\'installation.';
  }

  @override
  String statusFolderSelected(Object folderName) {
    return 'Dossier \"$folderName\" sélectionné. Prêt pour l\'installation.';
  }

  @override
  String statusArchiveLoaded(Object count, Object fileName) {
    return 'Fichier \"$fileName\" chargé. $count fichier(s) prêt(s) pour l\'installation.';
  }

  @override
  String get statusSelectionCancelled =>
      'Sélection annulée. Choisissez un nouveau mod à installer.';

  @override
  String get statusUpdateComplete => 'Mise à jour terminée.';

  @override
  String get statusInstallationComplete => 'Installation terminée.';

  @override
  String statusError(Object error) {
    return 'Erreur : $error';
  }

  @override
  String get dialogTitle7zip => '7-Zip est Requis';

  @override
  String get dialogContent7zip =>
      'Pour décompresser ce fichier, l\'application a besoin de 7-Zip.\n\nVeuillez l\'installer depuis sa page officielle, puis appuyez sur \"Confirmer\".';

  @override
  String get dialogContent7zipNotFound =>
      '7-Zip n\'a pas encore été détecté. Veuillez vous assurer qu\'il est installé dans le chemin par défaut et réessayez.';

  @override
  String get dialogTitleCNSUpdate =>
      'Mise à Jour du Système Principal Détectée';

  @override
  String get dialogContentCNSUpdate =>
      'Une mise à jour pour le \"Custom Nanosuit System\" a été détectée.\n\nCela remplacera des fichiers dans le dossier principal du jeu (StellarBlade\\SB). Souhaitez-vous continuer ?';

  @override
  String get dialogTitleMultipleJsons => 'Plusieurs Fichiers .json Détectés';

  @override
  String dialogContentMultipleJsons(Object count) {
    return '$count fichiers .json ont été détectés. Il pourrait s\'agir d\'un mod avec plusieurs composants.\n\nVoulez-vous les installer tous ensemble dans un seul dossier de mod ?';
  }

  @override
  String get dialogTitleModExists => 'Le Mod Existe Déjà';

  @override
  String dialogContentModExists(Object modName) {
    return 'Un mod nommé \"$modName\" est déjà installé.\n\nVoulez-vous le mettre à jour ? Les anciens fichiers seront supprimés avant d\'installer les nouveaux.';
  }

  @override
  String dialogContentModUpdate(Object newModName, Object oldModName) {
    return 'Une version plus ancienne \'$oldModName\' a été trouvée.\n\nVoulez-vous la supprimer et mettre à jour vers \'$newModName\' ?';
  }

  @override
  String get dialogTitleDeleteMod => 'Supprimer Définitivement ?';

  @override
  String dialogContentDeleteMod(Object modName) {
    return 'Vous êtes sur le point de supprimer définitivement le mod \"$modName\". Cette action est irréversible.\n\nÊtes-vous sûr ?';
  }

  @override
  String get dialogActionCancel => 'Annuler';

  @override
  String get dialogActionGoToDownload => 'Aller à la Page de Téléchargement';

  @override
  String get dialogActionConfirmInstallation => 'Confirmer l\'Installation';

  @override
  String get dialogActionUpdateSystem => 'Mettre à Jour le Système';

  @override
  String get dialogActionInstallAnyway => 'Installer quand même';

  @override
  String get dialogActionUpdate => 'Mettre à jour';

  @override
  String get dialogActionDelete => 'Supprimer';

  @override
  String get dialogActionClose => 'Fermer';

  @override
  String snackBarBatchInstallComplete(Object failedCount, Object successCount) {
    return 'Installation par lots terminée. Succès : $successCount, Échecs : $failedCount.';
  }

  @override
  String snackBarModInstalled(Object modName) {
    return 'Mod \"$modName\" installé avec succès.';
  }

  @override
  String snackBarModEnabled(Object modName) {
    return 'Mod \"$modName\" activé.';
  }

  @override
  String snackBarModDisabled(Object modName) {
    return 'Mod \"$modName\" désactivé.';
  }

  @override
  String snackBarModDeleted(Object modName) {
    return 'Mod \"$modName\" supprimé définitivement.';
  }

  @override
  String get snackBarCNSUpdated =>
      'Custom Nanosuit System mis à jour avec succès.';

  @override
  String get snackBarApiKeySaved => 'Clé API enregistrée avec succès.';

  @override
  String get snackBarGamePathSaved => 'Game path saved successfully.';

  @override
  String get snackBar7zipPathSaved => '7-Zip path saved successfully.';

  @override
  String get snackBarSkippedVersionRemoved => 'Skipped version removed.';

  @override
  String get dropTargetOverlay => 'Déposez les mods ici';

  @override
  String get pathSelectionTitle => 'Chemin de Stellar Blade Introuvable';

  @override
  String get pathSelectionButtonManual =>
      'Sélectionner Manuellement le Dossier du Jeu';

  @override
  String get pathSelectionButtonRetry => 'Réessayer';

  @override
  String errorFolderSelection(Object error) {
    return 'Erreur lors de la sélection du dossier : $error';
  }

  @override
  String errorFileSelection(Object error) {
    return 'Erreur lors de la sélection des fichiers : $error';
  }

  @override
  String errorDecompressing(Object error) {
    return 'Erreur lors de la décompression du fichier : $error';
  }

  @override
  String errorProcessingArchive(Object error) {
    return 'Erreur lors du traitement de l\'archive : $error';
  }

  @override
  String errorUnsupportedFormat(Object extension) {
    return 'Format de fichier non pris en charge : $extension';
  }

  @override
  String get error7zipRequired => 'Opération annulée : 7-Zip est requis.';

  @override
  String get errorGamePathUndefined => 'Le chemin du jeu n\'est pas défini.';

  @override
  String get errorDestinationNotFound =>
      'Le dossier de destination du jeu n\'existe pas.';

  @override
  String errorUpdateSystem(Object error) {
    return 'Erreur lors de la mise à jour du système : $error';
  }

  @override
  String get errorInstallNoSelection =>
      'Vous n\'avez rien sélectionné à installer.';

  @override
  String get errorInstallModExists =>
      'Installation annulée : le mod existe déjà.';

  @override
  String get errorNoJsonFound =>
      'Chaque mod doit contenir au moins un fichier .json.';

  @override
  String errorInvalidJsonFormat(Object fileName) {
    return 'Le fichier $fileName a un format JSON invalide.';
  }

  @override
  String errorNoDisplayName(Object fileName) {
    return 'Le fichier $fileName ne semble pas être un mod du Custom Nanosuit System (\"DisplayName\" manquant).';
  }

  @override
  String get errorNoValidDisplayName =>
      'Aucun \"DisplayName\" valide n\'a été trouvé dans les fichiers .json.';

  @override
  String errorEnableMod(Object error) {
    return 'Erreur lors de l\'activation du mod : $error';
  }

  @override
  String errorDisableMod(Object error) {
    return 'Erreur lors de la désactivation du mod : $error';
  }

  @override
  String errorDeleteMod(Object error) {
    return 'Erreur lors de la suppression du mod : $error';
  }

  @override
  String errorOpenFolder(Object path) {
    return 'Impossible d\'ouvrir le dossier : $path';
  }

  @override
  String get statusUpdateSystemCancelled => 'Mise à jour du système annulée.';

  @override
  String get statusUpdatingCNS => 'Mise à jour de Custom Nanosuit System...';

  @override
  String statusExtractingFile(Object fileName) {
    return 'Extraction de $fileName...';
  }

  @override
  String get statusInstallationCancelledByUser =>
      'Installation annulée par l\'utilisateur.';

  @override
  String get errorNoCompatibleFilesInFolder =>
      'Le dossier sélectionné ne contient pas de fichiers de mod compatibles.';

  @override
  String get errorNoCompatibleFilesInArchive =>
      'Le fichier compressé ne contient pas de fichiers de mod compatibles.';

  @override
  String get errorNoJsonInSelection =>
      'La sélection ne contient pas de fichier .json de mod valide.';

  @override
  String get aboutTitle => 'À propos de CNS Control Center';

  @override
  String get aboutContent =>
      'Cette application est un gestionnaire de mods pour Stellar Blade, conçu pour fonctionner avec le Custom Nanosuit System (CNS).\n\nPrérequis : Pour une fonctionnalité complète avec les fichiers .rar et .7z, 7-Zip doit être installé sur votre système.';

  @override
  String get aboutLinkText => 'Visitez le profil de mon créateur';

  @override
  String get creatorProfileUrl =>
      'https://next.nexusmods.com/profile/LuisNandez?gameId=7804';

  @override
  String aboutVersion(Object version) {
    return 'Version : $version';
  }

  @override
  String get openModsFolder => 'Ouvrir le Dossier des Mods';

  @override
  String get openInNexusMods => 'Ouvrir dans Nexus Mods';

  @override
  String get checkForUpdates => 'Vérifier les mises à jour';

  @override
  String updateAvailable(Object version) {
    return 'Mise à jour disponible : v$version';
  }

  @override
  String get dialogTitleApiKey => 'Clé API de Nexus Mods';

  @override
  String get dialogContentApiKey =>
      'Pour vérifier les mises à jour des mods, vous avez besoin d\'une clé API personnelle de Nexus Mods.';

  @override
  String get dialogContentApiKeyInstructions =>
      '1. Allez sur Nexus Mods et connectez-vous.\n2. Cliquez sur votre avatar et allez dans \'Site preferences\'.\n3. Allez dans l\'onglet \'API\'.\n4. Cliquez sur \'Generate a new API key\'.\n5. Copiez la clé et collez-la ici.';

  @override
  String get apiKey => 'Clé API';

  @override
  String get apiKeyHintText => 'Collez votre clé API ici';

  @override
  String get dialogActionSave => 'Enregistrer';

  @override
  String get apiKeyRemoved => 'Clé API supprimée.';

  @override
  String get invalidApiKeyError => 'Clé API invalide.';

  @override
  String get validatingApiKey => 'Validation...';

  @override
  String get errorApiKeyMissing =>
      'La clé API de Nexus Mods n\'est pas configurée. Veuillez l\'ajouter via l\'icône de clé dans la barre supérieure.';

  @override
  String get statusCheckingUpdates =>
      'Vérification des mises à jour des mods...';

  @override
  String statusUpdatesFound(Object count) {
    return '$count mise(s) à jour trouvée(s) !';
  }

  @override
  String get statusNoUpdates => 'Tous les mods sont à jour.';

  @override
  String get selectModArchive => 'Sélectionner l\'Archive du Mod';

  @override
  String get viewImageGallery => 'Voir l\'Image';

  @override
  String get imageGallery => 'Galerie d\'Images';

  @override
  String get noImagesFound =>
      'Aucune image n\'a été trouvée pour ce mod, ou la clé API n\'a pas été saisie. Veuillez saisir la clé et vérifier les mises à jour par la suite.';

  @override
  String errorFetchingImages(Object error) {
    return 'Erreur lors de la récupération des images : $error';
  }

  @override
  String get imageMod => 'Image du Mod';

  @override
  String get dialogContentUpdateOptions => 'Que souhaitez-vous faire ?';

  @override
  String get dialogActionIgnoreVersion => 'Ignorer la Version';

  @override
  String get dialogActionSkipVersion => 'Skip Version';

  @override
  String get dialogActionGoToDownloadPage => 'Aller au Téléchargement';

  @override
  String get installedMods => 'Mods Installés';

  @override
  String get filterBy => 'Filtrer par :';

  @override
  String get sortBy => 'Trier par :';

  @override
  String get filterAll => 'Tous';

  @override
  String get filterEnabled => 'Activés';

  @override
  String get filterDisabled => 'Désactivés';

  @override
  String get sortByName => 'Nom';

  @override
  String get sortByDate => 'Date';

  @override
  String get noModsFound => 'Aucun mod trouvé.';

  @override
  String statusExtractingMultipleFiles(
    Object count,
    Object fileName,
    Object total,
  ) {
    return 'Extraction de $count sur $total : $fileName';
  }

  @override
  String get previewInstallTitle => 'Mods à Installer :';

  @override
  String get dialogTitleUE4SS => 'Installation d\'UE4SS Détectée';

  @override
  String get dialogContentUE4SS =>
      'L\'outil UE4SS a été détecté. Voulez-vous l\'installer dans \'StellarBlade\\SB\\Binaries\\Win64\' ?\n\nCeci est nécessaire pour que de nombreux mods fonctionnent.';

  @override
  String get dialogActionInstallTool => 'Installer l\'Outil';

  @override
  String get statusUE4SSInstallCancelled => 'Installation d\'UE4SS annulée.';

  @override
  String get statusInstallingUE4SS => 'Installation d\'UE4SS...';

  @override
  String get snackBarUE4SSInstalled => 'UE4SS installé avec succès.';

  @override
  String error7zipDecompression(Object error) {
    return 'Erreur 7-Zip lors de la décompression : $error';
  }

  @override
  String get statusUE4SSInstallComplete => 'Installation d\'UE4SS terminée.';

  @override
  String get dialogTitleAlternativeVersion => 'Version Alternative Détectée';

  @override
  String dialogContentAlternativeVersion(
    String oldModName,
    String baseModName,
    String newModName,
  ) {
    return 'Une version alternative de ce mod est déjà installée : \'$oldModName\'.\n\nVous êtes sur le point d\'installer une alternative différente nommée \'$newModName\'.';
  }

  @override
  String get dialogActionReplace => 'Remplacer';

  @override
  String get dialogActionInstallAsNew => 'Installer comme Nouveau';

  @override
  String get dialogTitleUpdate => 'Mise à Jour Disponible';

  @override
  String dialogContentUpdate(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return 'Vous êtes sur le point de mettre à jour le mod \'$modName\'.\n\nVersion installée : $oldVersion\nNouvelle version : $newVersion';
  }

  @override
  String get dialogTitleDowngrade => 'Version Antérieure Détectée';

  @override
  String dialogContentDowngrade(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return 'Attention : Vous êtes sur le point d\'installer une version antérieure du mod \'$modName\'.\n\nVersion installée : $oldVersion\nVersion à installer : $newVersion';
  }

  @override
  String get dialogActionDowngrade => 'Rétrograder';

  @override
  String get dialogTitleReinstall => 'Réinstaller le Mod';

  @override
  String dialogContentReinstall(Object modName, Object version) {
    return 'Vous êtes sur le point de réinstaller la version \'$version\' du mod \'$modName\'.';
  }

  @override
  String get dialogActionReinstall => 'Réinstaller';
}
