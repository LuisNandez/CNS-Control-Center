// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'CNS Control Center';

  @override
  String appTitleWithVersion(Object version) {
    return 'Custom Nanosuit System $version';
  }

  @override
  String get settings => 'Paramètres';

  @override
  String get settingsGeneral => 'Général';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageDesc => 'Choisissez la langue de l\'application';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get settingsAboutDesc => 'Informations sur l\'application';

  @override
  String get settingsPathsAndTools => 'Chemins et outils';

  @override
  String get settingsGameFolder => 'Dossier du jeu';

  @override
  String get settingsGameFolderDesc =>
      'Le dossier racine de votre installation de Stellar Blade.';

  @override
  String get settings7zipPath => 'Chemin 7-Zip';

  @override
  String get settings7zipPathDesc =>
      'L\'emplacement du fichier 7z.exe pour l\'extraction des mods.';

  @override
  String get settings7zipPathAuto => 'Recherche automatique';

  @override
  String get settingsRepairMods => 'Réparer les mods hérités';

  @override
  String get settingsRepairModsDesc =>
      'Analyse et crée des fichiers d\'informations pour les anciens mods à l\'aide de la base de données locale. Clé API requise.';

  @override
  String get settingsConnectivity => 'Connectivité et mises à jour';

  @override
  String get settingsApiKey => 'Clé API Nexus Mods';

  @override
  String get settingsApiKeyDesc =>
      'Nécessaire pour vérifier les mises à jour des mods.';

  @override
  String get settingsApiKeySet => 'Définie';

  @override
  String get settingsApiKeyNotSet => 'Non définie';

  @override
  String get settingsSkippedVersions => 'Gérer les versions ignorées';

  @override
  String get settingsSkippedVersionsDesc =>
      'Gérez les versions de mods que vous avez choisi d\'ignorer.';

  @override
  String settingsSkippedVersionsCount(Object count) {
    return '$count versions ignorées';
  }

  @override
  String get dialogTitleSkippedVersions => 'Versions de mod ignorées';

  @override
  String get dialogNoSkippedVersions =>
      'Vous n\'avez ignoré aucune version de mod.';

  @override
  String get dialogSkippedVersions => 'Version ignorée';

  @override
  String get dialogTitleRepairMods =>
      'Exécuter la réparation des mods hérités ?';

  @override
  String get dialogContentRepairMods =>
      'Avertissement : cette fonctionnalité est en cours de développement et peut ne pas être parfaite.\n\nElle analysera les mods sans fichier \'nexus_info.json\' et, s\'il est trouvé dans votre base de données locale, en créera un pour eux. Elle tentera également de renommer le dossier du mod pour inclure la version trouvée (par exemple, \'Mon mod\' -> \'Mon mod v1.2\').\n\nPriorité de version :\n1. Depuis le nom du dossier.\n2. Depuis le champ de description du mod.\n3. Depuis la dernière version sur Nexus Mods (nécessite une API).\n\nVoulez-vous continuer ?';

  @override
  String get dialogActionRunRepair => 'Exécuter la réparation';

  @override
  String get snackBarGamePathInvalid =>
      'Le dossier sélectionné ne semble pas être un dossier de jeu valide.';

  @override
  String get snackBar7zipPathInvalid =>
      'Le fichier sélectionné doit s\'appeler 7z.exe.';

  @override
  String get snackBarRepairStarted =>
      'Le processus de réparation des mods hérités a commencé...';

  @override
  String snackBarRepairComplete(Object count) {
    return 'Réparation terminée. $count mod(s) ont été mis à jour.';
  }

  @override
  String get snackBarRepairNoMods =>
      'Aucun mod hérité nécessitant une réparation n\'a été trouvé.';

  @override
  String get errorApiRequiredForRepair =>
      'Une clé API est requise pour trouver la dernière version des mods sans version locale.';

  @override
  String get installNewMod => 'Installer un nouveau mod';

  @override
  String get selectFiles => 'Sélectionner des fichiers';

  @override
  String get selectFolder => 'Sélectionner un dossier';

  @override
  String get installSelectedMod => 'Installer le mod sélectionné';

  @override
  String get filesToInstall => 'Fichiers à installer :';

  @override
  String get cancelSelection => 'Annuler la sélection';

  @override
  String get searchMods => 'Rechercher des mods...';

  @override
  String get enabledMods => 'Mods activés';

  @override
  String get disabledMods => 'Mods désactivés';

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
  String get statusGamePathFound => 'Chemin du jeu trouvé !';

  @override
  String get statusGamePathNotFound =>
      'Impossible de trouver automatiquement le chemin du jeu.';

  @override
  String statusErrorFindingGame(Object error) {
    return 'Une erreur s\'est produite lors de la recherche du jeu : $error';
  }

  @override
  String statusModsFound(Object disabledCount, Object enabledCount) {
    return '$enabledCount mod(s) activés, $disabledCount désactivés.';
  }

  @override
  String statusErrorReadingMods(Object error) {
    return 'Erreur lors de la lecture des mods installés : $error';
  }

  @override
  String statusFilesSelected(Object count) {
    return '$count fichier(s) sélectionné(s). Prêt à installer.';
  }

  @override
  String statusFolderSelected(Object folderName) {
    return 'Dossier « $folderName » sélectionné. Prêt à installer.';
  }

  @override
  String statusArchiveLoaded(Object count, Object fileName) {
    return 'Fichier « $fileName » chargé. $count fichier(s) prêts à être installés.';
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
    return 'Erreur : $error';
  }

  @override
  String get dialogTitle7zip => '7-Zip est requis';

  @override
  String get dialogContent7zip =>
      'Pour décompresser ce fichier, l\'application a besoin de 7-Zip.\n\nVeuillez l\'installer depuis sa page officielle, puis appuyez sur « Confirmer ».';

  @override
  String get dialogContent7zipNotFound =>
      '7-Zip n\'a pas encore été détecté. Veuillez vous assurer qu\'il est installé dans le chemin par défaut et réessayez.';

  @override
  String get dialogTitleCNSUpdate =>
      'Mise à jour du système principal détectée';

  @override
  String get dialogContentCNSUpdate =>
      'Une mise à jour du « Système Nanosuit personnalisé » a été détectée.\n\nCela remplacera les fichiers dans le dossier principal du jeu (StellarBlade\\SB). Souhaitez-vous continuer ?';

  @override
  String get dialogTitleMultipleJsons => 'Plusieurs fichiers .json détectés';

  @override
  String dialogContentMultipleJsons(Object count) {
    return '$count fichiers .json ont été détectés. Il peut s\'agir d\'un mod avec plusieurs composants.\n\nVoulez-vous les installer tous ensemble dans un seul dossier de mod ?';
  }

  @override
  String get dialogTitleModExists => 'Le mod existe déjà';

  @override
  String dialogContentModExists(Object modName) {
    return 'Un mod nommé « $modName » est déjà installé.\n\nVoulez-vous le mettre à jour ? Les anciens fichiers seront supprimés avant l\'installation des nouveaux.';
  }

  @override
  String dialogContentModUpdate(Object newModName, Object oldModName) {
    return 'Une version plus ancienne \'$oldModName\' a été trouvée.\n\nVoulez-vous la supprimer et la mettre à jour vers \'$newModName\' ?';
  }

  @override
  String get dialogTitleDeleteMod => 'Supprimer définitivement ?';

  @override
  String dialogContentDeleteMod(Object modName) {
    return 'Vous êtes sur le point de supprimer définitivement le mod « $modName ». Cette action est irréversible.\n\nÊtes-vous sûr ?';
  }

  @override
  String get dialogActionCancel => 'Annuler';

  @override
  String get dialogActionGoToDownload => 'Aller à la page de téléchargement';

  @override
  String get dialogActionConfirmInstallation => 'Confirmer l\'installation';

  @override
  String get dialogActionUpdateSystem => 'Mettre à jour le système';

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
    return 'Installation par lots terminée. Réussite : $successCount, Échec : $failedCount.';
  }

  @override
  String snackBarModInstalled(Object modName) {
    return 'Le mod « $modName » a été installé avec succès.';
  }

  @override
  String snackBarModEnabled(Object modName) {
    return 'Le mod « $modName » a été activé.';
  }

  @override
  String snackBarModDisabled(Object modName) {
    return 'Le mod « $modName » a été désactivé.';
  }

  @override
  String snackBarModDeleted(Object modName) {
    return 'Le mod « $modName » a été supprimé définitivement.';
  }

  @override
  String get snackBarCNSUpdated =>
      'Le système Nanosuit personnalisé a été mis à jour avec succès.';

  @override
  String get snackBarApiKeySaved => 'La clé API a été enregistrée avec succès.';

  @override
  String get snackBarGamePathSaved =>
      'Le chemin du jeu a été enregistré avec succès.';

  @override
  String get snackBar7zipPathSaved =>
      'Le chemin 7-Zip a été enregistré avec succès.';

  @override
  String get snackBarSkippedVersionRemoved =>
      'La version ignorée a été supprimée.';

  @override
  String get dropTargetOverlay => 'Déposez les mods ici';

  @override
  String get pathSelectionTitle => 'Chemin de Stellar Blade introuvable';

  @override
  String get pathSelectionButtonManual =>
      'Sélectionner manuellement le dossier du jeu';

  @override
  String get pathSelectionButtonRetry => 'Réessayer';

  @override
  String errorFolderSelection(Object error) {
    return 'Erreur lors de la sélection du dossier : $error';
  }

  @override
  String errorFileSelection(Object error) {
    return 'Erreur lors de la sélection des fichiers : $error';
  }

  @override
  String errorDecompressing(Object error) {
    return 'Erreur lors de la décompression du fichier : $error';
  }

  @override
  String errorProcessingArchive(Object error) {
    return 'Erreur lors du traitement du fichier : $error';
  }

  @override
  String errorUnsupportedFormat(Object extension) {
    return 'Format de fichier non pris en charge : $extension';
  }

  @override
  String get error7zipRequired => 'Opération annulée : 7-Zip est requis.';

  @override
  String get errorGamePathUndefined => 'Le chemin du jeu n\'est pas défini.';

  @override
  String get errorDestinationNotFound =>
      'Le dossier de destination du jeu n\'existe pas.';

  @override
  String errorUpdateSystem(Object error) {
    return 'Erreur lors de la mise à jour du système : $error';
  }

  @override
  String get errorInstallNoSelection =>
      'Vous n\'avez rien sélectionné à installer.';

  @override
  String get errorInstallModExists =>
      'Installation annulée : le mod existe déjà.';

  @override
  String get errorNoJsonFound =>
      'Chaque mod doit contenir au moins un fichier .json.';

  @override
  String errorInvalidJsonFormat(Object fileName) {
    return 'Le fichier $fileName a un format JSON non valide.';
  }

  @override
  String errorNoDisplayName(Object fileName) {
    return 'Le fichier $fileName ne semble pas être un mod du système Nanosuit personnalisé (« DisplayName » manquant).';
  }

  @override
  String get errorNoValidDisplayName =>
      'Aucun « DisplayName » valide n\'a été trouvé dans les fichiers .json.';

  @override
  String errorEnableMod(Object error) {
    return 'Erreur lors de l\'activation du mod : $error';
  }

  @override
  String errorDisableMod(Object error) {
    return 'Erreur lors de la désactivation du mod : $error';
  }

  @override
  String errorDeleteMod(Object error) {
    return 'Erreur lors de la suppression du mod : $error';
  }

  @override
  String errorOpenFolder(Object path) {
    return 'Impossible d\'ouvrir le dossier : $path';
  }

  @override
  String get statusUpdateSystemCancelled => 'Mise à jour du système annulée.';

  @override
  String get statusUpdatingCNS =>
      'Mise à jour du système Nanosuit personnalisé...';

  @override
  String statusExtractingFile(Object fileName) {
    return 'Extraction de $fileName...';
  }

  @override
  String get statusInstallationCancelledByUser =>
      'Installation annulée par l\'utilisateur.';

  @override
  String get errorNoCompatibleFilesInFolder =>
      'Le dossier sélectionné ne contient aucun fichier de mod compatible.';

  @override
  String get errorNoCompatibleFilesInArchive =>
      'Le fichier compressé ne contient aucun fichier de mod compatible.';

  @override
  String get errorNoJsonInSelection =>
      'La sélection ne contient pas de fichier .json de mod valide.';

  @override
  String get aboutTitle => 'À propos du centre de contrôle CNS';

  @override
  String get aboutContent =>
      'Cette application est un gestionnaire de mods pour Stellar Blade, conçu pour fonctionner avec le système Nanosuit personnalisé (CNS).\n\nPrérequis : pour une fonctionnalité complète avec les fichiers .rar et .7z, 7-Zip doit être installé sur votre système.';

  @override
  String get aboutLinkText => 'Visitez mon profil de créateur';

  @override
  String get creatorProfileUrl =>
      'https://next.nexusmods.com/profile/LuisNandez?gameId=7804';

  @override
  String aboutVersion(Object version) {
    return 'Version : $version';
  }

  @override
  String get openModsFolder => 'Ouvrir le dossier des mods';

  @override
  String get openInNexusMods => 'Ouvrir dans Nexus Mods';

  @override
  String get checkForUpdates => 'Vérifier les mises à jour';

  @override
  String updateAvailable(Object version) {
    return 'Mise à jour disponible : v$version';
  }

  @override
  String get dialogTitleApiKey => 'Clé API Nexus Mods';

  @override
  String get dialogContentApiKey =>
      'Pour vérifier les mises à jour des mods, vous avez besoin d\'une clé API personnelle de Nexus Mods.';

  @override
  String get dialogContentApiKeyInstructions =>
      '1. Allez sur Nexus Mods et connectez-vous.\n2. Cliquez sur votre avatar et allez dans « Préférences du site ».\n3. Allez dans l\'onglet « API ».\n4. Cliquez sur « Générer une nouvelle clé API ».\n5. Copiez la clé et collez-la ici.';

  @override
  String get apiKey => 'Clé API';

  @override
  String get apiKeyHintText => 'Collez votre clé API ici';

  @override
  String get dialogActionSave => 'Enregistrer';

  @override
  String get apiKeyRemoved => 'Clé API supprimée.';

  @override
  String get invalidApiKeyError => 'Clé API non valide.';

  @override
  String get validatingApiKey => 'Validation en cours...';

  @override
  String get errorApiKeyMissing =>
      'La clé API de Nexus Mods n\'est pas configurée. Veuillez l\'ajouter via l\'icône de clé dans la barre supérieure.';

  @override
  String get statusCheckingUpdates =>
      'Vérification des mises à jour des mods...';

  @override
  String statusUpdatesFound(Object count) {
    return '$count mise(s) à jour trouvée(s) !';
  }

  @override
  String get statusNoUpdates => 'Tous les mods sont à jour.';

  @override
  String get selectModArchive => 'Sélectionner l\'archive du mod';

  @override
  String get viewImageGallery => 'Afficher l\'image';

  @override
  String get imageGallery => 'Galerie d\'images';

  @override
  String get noImagesFound =>
      'Aucune image n\'a été trouvée pour ce mod, ou la clé API n\'a pas été saisie. Veuillez saisir la clé API et vérifier les mises à jour par la suite.';

  @override
  String errorFetchingImages(Object error) {
    return 'Erreur lors de la récupération des images : $error';
  }

  @override
  String get imageMod => 'Image du mod';

  @override
  String get modEnabledBadge => 'Activé';

  @override
  String get modDisabledBadge => 'Désactivé';

  @override
  String get modCategoryOther => 'Non spécifié';

  @override
  String get dialogContentUpdateOptions => 'Que souhaitez-vous faire ?';

  @override
  String get dialogActionIgnoreVersion => 'Ignorer';

  @override
  String get dialogActionSkipVersion => 'Ignorer la version';

  @override
  String get dialogActionGoToDownloadPage => 'Aller au téléchargement';

  @override
  String get installedMods => 'Mods installés';

  @override
  String get filterBy => 'Filtrer :';

  @override
  String get sortBy => 'Trier par :';

  @override
  String get filterAll => 'Tous';

  @override
  String get filterEnabled => 'Activés';

  @override
  String get filterDisabled => 'Désactivés';

  @override
  String get filterRepaired => 'Réparés';

  @override
  String get sortByName => 'Nom';

  @override
  String get sortByDate => 'Date';

  @override
  String get noModsFound => 'Aucun mod trouvé.';

  @override
  String get viewTypeGrid => 'Vue grille';

  @override
  String get viewTypeList => 'Vue liste';

  @override
  String statusExtractingMultipleFiles(
    Object count,
    Object fileName,
    Object total,
  ) {
    return 'Extraction de $count sur $total : $fileName';
  }

  @override
  String get previewInstallTitle => 'Mods à installer :';

  @override
  String get dialogTitleUE4SS => 'Installation d\'UE4SS détectée';

  @override
  String get dialogContentUE4SS =>
      'L\'outil UE4SS a été détecté. Voulez-vous l\'installer dans \'StellarBlade\\SB\\Binaries\\Win64\' ?\n\nCeci est nécessaire pour que de nombreux mods fonctionnent.';

  @override
  String get dialogActionInstallTool => 'Installer l\'outil';

  @override
  String get statusUE4SSInstallCancelled => 'Installation d\'UE4SS annulée.';

  @override
  String get statusInstallingUE4SS => 'Installation d\'UE4SS en cours...';

  @override
  String get snackBarUE4SSInstalled => 'UE4SS installé avec succès.';

  @override
  String error7zipDecompression(Object error) {
    return 'Erreur 7-Zip lors de la décompression : $error';
  }

  @override
  String get statusUE4SSInstallComplete => 'Installation d\'UE4SS terminée.';

  @override
  String get dialogTitleAlternativeVersion => 'Version alternative détectée';

  @override
  String dialogContentAlternativeVersion(
    String oldModName,
    String baseModName,
    String newModName,
  ) {
    return 'Une version alternative de ce mod est déjà installée : \'$oldModName\'.\n\nVous êtes sur le point d\'installer une autre alternative nommée \'$newModName\'.';
  }

  @override
  String get dialogActionReplace => 'Remplacer';

  @override
  String get dialogActionInstallAsNew => 'Installer comme nouveau';

  @override
  String get dialogTitleUpdate => 'Mise à jour disponible';

  @override
  String dialogContentUpdate(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return 'Vous êtes sur le point de mettre à jour le mod \'$modName\'.\n\nVersion installée : $oldVersion\nNouvelle version : $newVersion';
  }

  @override
  String get dialogTitleDowngrade => 'Version plus ancienne détectée';

  @override
  String dialogContentDowngrade(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return 'Avertissement : vous êtes sur le point d\'installer une version plus ancienne du mod \'$modName\'.\n\nVersion installée : $oldVersion\nVersion à installer : $newVersion';
  }

  @override
  String get dialogActionDowngrade => 'Rétrograder';

  @override
  String get dialogTitleReinstall => 'Réinstaller le mod';

  @override
  String dialogContentReinstall(Object modName, Object version) {
    return 'Vous êtes sur le point de réinstaller la version \'$version\' du mod \'$modName\'.';
  }

  @override
  String get dialogActionReinstall => 'Réinstaller';

  @override
  String get editModNameTooltip => 'Modifier le nom du mod';

  @override
  String get setCoverTooltip => 'Set custom cover image';

  @override
  String get setCoverText => 'Set Cover';

  @override
  String get restoreOriginalCoverText => 'Restore Original Cover';

  @override
  String errorSavingCoverText(Object error) {
    return 'Error saving cover image: $error';
  }

  @override
  String errorRestoringCoverText(Object error) {
    return 'Error restoring original cover image: $error';
  }

  @override
  String get dialogTitleEditModName => 'Modifier le nom du mod';

  @override
  String get dialogActionResetToDefault => 'Réinitialiser par défaut';

  @override
  String get dialogLabelNewName => 'Nouveau nom';

  @override
  String errorModNameExists(Object modName) {
    return 'Un mod nommé « $modName » existe déjà.';
  }

  @override
  String get dialogTitleRepairedModWarning => 'Avertissement de mod réparé';

  @override
  String get dialogContentRepairedModWarning =>
      'Ce mod peut ne pas avoir les bonnes informations de version. Il est recommandé de réinstaller la dernière version pour garantir la compatibilité.';

  @override
  String get repairedModTooltip => 'Informations sur le mod réparé';

  @override
  String get disableAllModsTooltip => 'Désactiver tous les mods';

  @override
  String get deleteAllModsTooltip => 'Supprimer tous les mods désactivés';

  @override
  String get dialogTitleDisableAll => 'Désactiver tous les mods ?';

  @override
  String dialogContentDisableAll(int count) {
    return 'Êtes-vous sûr de vouloir désactiver les $count mods activés ? Ils seront déplacés vers le dossier de sauvegarde.';
  }

  @override
  String get dialogTitleDeleteAll => 'Supprimer les mods désactivés ?';

  @override
  String dialogContentDeleteAll(int count) {
    return 'Vous êtes sur le point de supprimer définitivement les $count mods désactivés. Cette action est irréversible.\n\nÊtes-vous sûr ?';
  }

  @override
  String snackBarAllModsDisabled(int count) {
    return 'Les $count mods activés ont tous été désactivés.';
  }

  @override
  String snackBarAllModsDeleted(int count) {
    return 'Les $count mods désactivés ont tous été supprimés définitivement.';
  }

  @override
  String get snackBarNoModsToDisable =>
      'Il n\'y a aucun mod activé à désactiver.';

  @override
  String get snackBarNoModsToDelete =>
      'Il n\'y a aucun mod désactivé à supprimer.';

  @override
  String get enableAllModsTooltip => 'Activer tous les mods';

  @override
  String get dialogTitleEnableAll => 'Activer tous les mods ?';

  @override
  String dialogContentEnableAll(int count) {
    return 'Êtes-vous sûr de vouloir activer les $count mods désactivés ? Ils seront déplacés vers le dossier principal des mods.';
  }

  @override
  String snackBarAllModsEnabled(int count) {
    return 'Les $count mods désactivés ont tous été activés.';
  }

  @override
  String get snackBarNoModsToEnable =>
      'Il n\'y a aucun mod désactivé à activer.';
}
