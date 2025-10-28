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
  String get settingsPathsAndTools => 'Chemins et Outils';

  @override
  String get settingsGameFolder => 'Dossier du jeu';

  @override
  String get settingsGameFolderDesc =>
      'Le dossier racine de votre installation de Stellar Blade.';

  @override
  String get settings7zipPath => 'Chemin de 7-Zip';

  @override
  String get settings7zipPathDesc =>
      'L\'emplacement du fichier 7z.exe pour extraire les mods.';

  @override
  String get settings7zipPathAuto => 'Recherche automatique';

  @override
  String get settingsRepairMods => 'Réparer les mods hérités';

  @override
  String get settingsRepairModsDesc =>
      'Analyse et crée des fichiers d\'information pour les anciens mods en utilisant la base de données locale. Nécessite une clé API.';

  @override
  String get settingsConnectivity => 'Connectivité et Mises à jour';

  @override
  String get settingsApiKey => 'Clé API de Nexus Mods';

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
  String get dialogTitleSkippedVersions => 'Versions de mods ignorées';

  @override
  String get dialogNoSkippedVersions =>
      'Vous n\'avez ignoré aucune version de mod.';

  @override
  String get dialogSkippedVersions => 'Version ignorée';

  @override
  String get dialogTitleRepairMods => 'Lancer la réparation des mods hérités ?';

  @override
  String get dialogContentRepairMods =>
      'Attention : Cette fonctionnalité est en cours de développement et peut ne pas être parfaite.\n\nElle analysera les mods sans fichier \'nexus_info.json\' et, s\'ils sont trouvés dans votre base de données locale, en créera un pour eux. Elle tentera également de renommer le dossier du mod pour inclure la version trouvée (par exemple, \'Mon Mod\' -> \'Mon Mod v1.2\').\n\nPriorité de la version :\n1. À partir du nom du dossier.\n2. À partir du champ de description du mod.\n3. À partir de la dernière version sur Nexus Mods (nécessite l\'API).\n\nVoulez-vous continuer ?';

  @override
  String get dialogActionRunRepair => 'Lancer la réparation';

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
      'La clé API est requise pour trouver la dernière version des mods sans version locale.';

  @override
  String get installNewMod => 'Installer un mod';

  @override
  String get selectFiles => 'Sélectionner des fichiers';

  @override
  String get selectFolder => 'Sélectionner un dossier';

  @override
  String get installSelectedMod => 'Installer le mod sélectionné';

  @override
  String get filesToInstall => 'Fichiers à installer :';

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
  String get statusGamePathFound => 'Chemin du jeu trouvé !';

  @override
  String get statusGamePathNotFound =>
      'Impossible de trouver automatiquement le chemin du jeu.';

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
  String get dialogTitle7zip => '7-Zip est requis';

  @override
  String get dialogContent7zip =>
      'Pour décompresser ce fichier, l\'application a besoin de 7-Zip.\n\nVeuillez l\'installer depuis sa page officielle, puis appuyez sur \"Confirmer\".';

  @override
  String get dialogContent7zipNotFound =>
      '7-Zip n\'a pas encore été détecté. Veuillez vous assurer qu\'il est installé dans le chemin par défaut et réessayez.';

  @override
  String get dialogTitleMultipleJsons => 'Plusieurs fichiers .json détectés';

  @override
  String dialogContentMultipleJsons(Object count) {
    return '$count fichiers .json ont été détectés. Il pourrait s\'agir d\'un mod avec plusieurs composants.\n\nVoulez-vous les installer tous ensemble dans un seul dossier de mod ?';
  }

  @override
  String get dialogTitleModExists => 'Le mod existe déjà';

  @override
  String dialogContentModExists(Object modName) {
    return 'Un mod nommé \"$modName\" est déjà installé.\n\nVoulez-vous le mettre à jour ? Les anciens fichiers seront supprimés avant l\'installation des nouveaux.';
  }

  @override
  String dialogContentModUpdate(Object newModName, Object oldModName) {
    return 'Une version plus ancienne \'$oldModName\' a été trouvée.\n\nVoulez-vous la supprimer et mettre à jour vers \'$newModName\' ?';
  }

  @override
  String get dialogTitleDeleteMod => 'Supprimer définitivement ?';

  @override
  String dialogContentDeleteMod(Object modName) {
    return 'Vous êtes sur le point de supprimer définitivement le mod \"$modName\". Cette action est irréversible.\n\nÊtes-vous sûr ?';
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
  String get dialogActionDelete => 'Supprimer';

  @override
  String get dialogActionClose => 'Fermer';

  @override
  String snackBarBatchInstallComplete(Object failedCount, Object successCount) {
    return 'Installation par lots terminée. Succès : $successCount, Échecs : $failedCount.';
  }

  @override
  String snackBarModInstalled(Object modName) {
    return 'Le mod \"$modName\" a été installé avec succès.';
  }

  @override
  String snackBarModEnabled(Object modName) {
    return 'Le mod \"$modName\" a été activé.';
  }

  @override
  String snackBarModDisabled(Object modName) {
    return 'Le mod \"$modName\" a été désactivé.';
  }

  @override
  String snackBarModDeleted(Object modName) {
    return 'Le mod \"$modName\" a été supprimé définitivement.';
  }

  @override
  String get snackBarCNSUpdated =>
      'Le système Custom Nanosuit a été mis à jour avec succès.';

  @override
  String get snackBarApiKeySaved => 'La clé API a été enregistrée avec succès.';

  @override
  String get snackBarGamePathSaved =>
      'Le chemin du jeu a été enregistré avec succès.';

  @override
  String get snackBar7zipPathSaved =>
      'Le chemin de 7-Zip a été enregistré avec succès.';

  @override
  String get snackBarSkippedVersionRemoved =>
      'La version ignorée a été supprimée.';

  @override
  String get dropTargetOverlay => 'Déposez les mods ici';

  @override
  String get pathSelectionTitle => 'Chemin de Stellar Blade non trouvé';

  @override
  String get pathSelectionButtonManual =>
      'Sélectionner manuellement le dossier du jeu';

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
    return 'Erreur lors du traitement du fichier : $error';
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
  String get statusUpdatingCNS => 'Mise à jour du Custom Nanosuit System...';

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
  String get aboutTitle => 'À propos du Centre de Contrôle CNS';

  @override
  String get aboutContent =>
      'Cette application est un gestionnaire de mods pour Stellar Blade, conçu pour fonctionner avec le Custom Nanosuit System (CNS).\n\nPrérequis : Pour une fonctionnalité complète avec les fichiers .rar et .7z, 7-Zip doit être installé sur votre système.';

  @override
  String get aboutLinkText => 'Visitez mon profil de créateur';

  @override
  String get creatorProfileUrl =>
      'https://next.nexusmods.com/profile/LuisNandez?gameId=7804';

  @override
  String aboutVersion(Object version) {
    return 'Version : $version';
  }

  @override
  String get openModsFolder => 'Ouvrir le dossier des mods';

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
      '1. Allez sur Nexus Mods et connectez-vous.\n2. Cliquez sur votre avatar et allez dans \'Préférences du site\'.\n3. Allez dans l\'onglet \'API\'.\n4. Cliquez sur \'Générer une nouvelle clé API\'.\n5. Copiez la clé et collez-la ici.';

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
  String get validatingApiKey => 'Validation en cours...';

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
  String get selectModArchive => 'Sélectionner l\'archive du mod';

  @override
  String get viewImageGallery => 'Voir la galerie d\'images';

  @override
  String get imageGallery => 'Galerie d\'images';

  @override
  String get noImagesFound =>
      'Aucune image n\'a été trouvée pour ce mod, ou la clé API n\'a pas été saisie. Veuillez saisir la clé API et vérifier les mises à jour par la suite.';

  @override
  String errorFetchingImages(Object error) {
    return 'Erreur lors de la récupération des images : $error';
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
  String get dialogContentUpdateOptions => 'Que souhaitez-vous faire ?';

  @override
  String get dialogActionIgnoreVersion => 'Ignorer';

  @override
  String get dialogActionSkipVersion => 'Ignorer la version';

  @override
  String get dialogActionGoToDownloadPage => 'Aller au téléchargement';

  @override
  String get installedMods => 'Mods installés';

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
  String get filterRepaired => 'Réparés';

  @override
  String get sortByName => 'Nom';

  @override
  String get sortByDate => 'Date';

  @override
  String get noModsFound => 'Aucun mod trouvé.';

  @override
  String get viewTypeGrid => 'Vue en grille';

  @override
  String get viewTypeList => 'Vue en liste';

  @override
  String statusExtractingMultipleFiles(
    Object count,
    Object fileName,
    Object total,
  ) {
    return 'Extraction de $count sur $total : $fileName';
  }

  @override
  String get previewInstallTitle => 'Mods à installer :';

  @override
  String get dialogTitleUE4SS => 'Installation d\'UE4SS détectée';

  @override
  String get dialogContentUE4SS =>
      'L\'outil UE4SS a été détecté. Voulez-vous l\'installer dans \'StellarBlade\\SB\\Binaries\\Win64\' ?\n\nCeci est nécessaire pour que de nombreux mods fonctionnent.';

  @override
  String get dialogActionInstallTool => 'Installer l\'outil';

  @override
  String get statusUE4SSInstallCancelled => 'Installation d\'UE4SS annulée.';

  @override
  String get statusInstallingUE4SS => 'Installation d\'UE4SS...';

  @override
  String get snackBarUE4SSInstalled => 'UE4SS installé avec succès.';

  @override
  String error7zipDecompression(Object error) {
    return 'Erreur de 7-Zip lors de la décompression : $error';
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
    return 'Une version alternative de ce mod est déjà installée : \'$oldModName\'.\n\nVous êtes sur le point d\'installer une alternative différente nommée \'$newModName\'.';
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
    return 'Vous êtes sur le point de mettre à jour le mod \'$modName\'.\n\nVersion installée : $oldVersion\nNouvelle version : $newVersion';
  }

  @override
  String get dialogTitleDowngrade => 'Version plus ancienne détectée';

  @override
  String dialogContentDowngrade(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return 'Attention : vous êtes sur le point d\'installer une version plus ancienne du mod \'$modName\'.\n\nVersion installée : $oldVersion\nVersion à installer : $newVersion';
  }

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
  String get setCoverTooltip => 'Définir une image de couverture personnalisée';

  @override
  String get setCoverText => 'Définir la couverture';

  @override
  String get restoreOriginalCoverText => 'Restaurer la couverture originale';

  @override
  String errorSavingCoverText(Object error) {
    return 'Erreur lors de l\'enregistrement de l\'image de couverture : $error';
  }

  @override
  String errorRestoringCoverText(Object error) {
    return 'Erreur lors de la restauration de l\'image de couverture originale : $error';
  }

  @override
  String get editVersionText => 'Modifier la version';

  @override
  String get customVersionText => 'Version personnalisée';

  @override
  String get editTagText => 'Modifier le tag';

  @override
  String get customTagText => 'Tag personnalisé';

  @override
  String get dialogTitleEditModName => 'Modifier le nom du mod';

  @override
  String get dialogActionResetToDefault => 'Réinitialiser par défaut';

  @override
  String get dialogLabelNewName => 'Nouveau nom';

  @override
  String errorModNameExists(Object modName) {
    return 'Un mod nommé \"$modName\" existe déjà.';
  }

  @override
  String get dialogTitleRepairedModWarning => 'Avertissement de mod réparé';

  @override
  String get dialogContentRepairedModWarning =>
      'Ce mod pourrait ne pas avoir les informations de version correctes. Il est recommandé de réinstaller la dernière version pour assurer la compatibilité.';

  @override
  String get repairedModTooltip => 'Informations sur le mod réparé';

  @override
  String get disableAllModsTooltip => 'Désactiver tous les mods';

  @override
  String get deleteAllModsTooltip => 'Supprimer tous les mods désactivés';

  @override
  String get dialogTitleDisableAll => 'Désactiver tous les mods ?';

  @override
  String dialogContentDisableAll(int count) {
    return 'Êtes-vous sûr de vouloir désactiver les $count mods activés ? Ils seront déplacés dans le dossier de sauvegarde.';
  }

  @override
  String get dialogTitleDeleteAll => 'Supprimer les mods désactivés ?';

  @override
  String dialogContentDeleteAll(int count) {
    return 'Vous êtes sur le point de supprimer définitivement les $count mods désactivés. Cette action est irréversible.\n\nÊtes-vous sûr ?';
  }

  @override
  String snackBarAllModsDisabled(int count) {
    return 'Les $count mods activés ont été désactivés.';
  }

  @override
  String snackBarAllModsDeleted(int count) {
    return 'Les $count mods désactivés ont été supprimés définitivement.';
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
  String get dialogTitleEnableAll => 'Activer tous les mods ?';

  @override
  String dialogContentEnableAll(int count) {
    return 'Êtes-vous sûr de vouloir activer les $count mods désactivés ? Ils seront déplacés dans le dossier principal des mods.';
  }

  @override
  String snackBarAllModsEnabled(int count) {
    return 'Les $count mods désactivés ont été activés.';
  }

  @override
  String get snackBarNoModsToEnable =>
      'Il n\'y a aucun mod désactivé à activer.';

  @override
  String get editNotes => 'Modifier les notes';

  @override
  String get notesHintText => 'Ajoutez vos notes personnelles ici...';

  @override
  String get modAuthor => 'Auteur';

  @override
  String get modSummary => 'Summary';

  @override
  String get modDescription => 'Description';

  @override
  String get noDescriptionAvailable => 'Aucune description disponible.';

  @override
  String get personalNotes => 'Notes personnelles';

  @override
  String get noNotesAvailable => 'Aucune note ajoutée pour le moment.';

  @override
  String get modDetailsTitle => 'Détails du mod';

  @override
  String get modVersion => 'Version';

  @override
  String get modCategory => 'Catégorie';

  @override
  String get dialogTitleAddUrl => 'Ajouter un lien de mod';

  @override
  String get dialogLabelUrl => 'URL du mod';

  @override
  String get errorInvalidUrl => 'Veuillez entrer une URL valide.';

  @override
  String get addLinkTooltip => 'Ajouter un lien de téléchargement pour ce mod';

  @override
  String get addLinkButtonText => 'Ajouter un lien';

  @override
  String get openLinkButtonText => 'Ouvrir le lien';

  @override
  String get editModTitle => 'Modifier les détails du mod';

  @override
  String get modNameLabel => 'Nom du mod';

  @override
  String get authorLabel => 'Auteur';

  @override
  String get summaryLabel => 'Description / Résumé';

  @override
  String get notesLabel => 'Notes personnelles';

  @override
  String get urlLabel => 'URL de téléchargement';

  @override
  String get changeCoverButton => 'Changer l\'image de couverture';

  @override
  String get editButtonTooltip => 'Modifier le mod';

  @override
  String get errorSavingNotes => 'Erreur lors de l\'enregistrement des notes';

  @override
  String get errorSavingUrl => 'Erreur lors de l\'enregistrement de l\'URL';

  @override
  String get errorSavingChanges =>
      'Erreur lors de l\'enregistrement des modifications';

  @override
  String get errorTranslation => 'Impossible de traduire la description';

  @override
  String get translateSummary => 'Translate summary';

  @override
  String get translateDescription => 'Traduire la description';

  @override
  String get dialogTitleUE4SSReinstall => 'Réinstaller UE4SS';

  @override
  String get dialogContentUE4SSReinstall =>
      'UE4SS semble déjà être installé. Voulez-vous écraser l\'installation existante ? Cela peut être utile si vous suspectez des fichiers corrompus.';

  @override
  String get dialogTitleCNSReinstall => 'Réinstaller le système CNS';

  @override
  String get dialogContentCNSReinstall =>
      'Le système CNS principal semble déjà être installé. Voulez-vous le réinstaller ? Vos mods existants ne seront pas affectés.';

  @override
  String dialogTitleUninstall(Object componentName) {
    return 'Désinstaller $componentName';
  }

  @override
  String dialogContentUninstall(Object componentName) {
    return 'Êtes-vous sûr de vouloir désinstaller $componentName ? Cette action supprimera les fichiers principaux du composant mais n\'affectera pas vos mods installés.';
  }

  @override
  String get dialogActionUninstall => 'Oui, désinstaller';

  @override
  String statusUninstalling(Object componentName) {
    return 'Désinstallation de $componentName...';
  }

  @override
  String snackBarUninstalled(Object componentName) {
    return '$componentName désinstallé avec succès';
  }

  @override
  String errorUninstalling(Object componentName) {
    return 'Erreur lors de la désinstallation de $componentName';
  }

  @override
  String get settingsCoreComponents => 'Composants principaux';

  @override
  String get installedStatus => 'Installé';

  @override
  String get notInstalledStatus => 'Non détecté';

  @override
  String get uninstallButton => 'Désinstaller';

  @override
  String get cnsCoreSystem => 'Custom Nanosuit System';

  @override
  String get ue4ssInstallationDetected =>
      'Installation existante d\'UE4SS détectée et adoptée';

  @override
  String get cnsInstallationDetected =>
      'Installation principale de CNS existante détectée et adoptée';

  @override
  String get ue4ssRequiredTitle => 'UE4SS requis';

  @override
  String get ue4ssRequiredContent =>
      'Pour installer le système principal de CNS, vous devez d\'abord installer UE4SS. Vous pouvez le télécharger depuis le lien suivant :';

  @override
  String get uninstallDependencyTitle => 'Dépendance détectée';

  @override
  String get uninstallDependencyContent =>
      'Vous devez désinstaller le système principal de CNS avant de pouvoir désinstaller UE4SS, car CNS en dépend.';

  @override
  String get dialogActionUnderstood => 'Compris';

  @override
  String get appTitleNoCns => 'Custom Nanosuit System (Non installé)';

  @override
  String get dialogTitleCNSUpdate =>
      'Mettre à jour le système principal de CNS';

  @override
  String dialogContentCNSUpdate(Object oldVersion, Object newVersion) {
    return 'Vous êtes sur le point de mettre à jour CNS de la version $oldVersion à la nouvelle version $newVersion. Souhaitez-vous continuer ?';
  }

  @override
  String get dialogTitleCNSDowngrade => 'Rétrograder la version de CNS';

  @override
  String dialogContentCNSDowngrade(Object oldVersion, Object newVersion) {
    return 'Attention ! Vous êtes sur le point d\'installer une version plus ancienne de CNS ($newVersion) que votre version actuelle ($oldVersion). Cela peut causer des problèmes. Êtes-vous sûr ?';
  }

  @override
  String dialogContentCNSReinstallVersion(Object version) {
    return 'Vous avez déjà la version $version de CNS installée. Voulez-vous réinstaller les fichiers quand même ?';
  }

  @override
  String get dialogActionUpdate => 'Mettre à jour';

  @override
  String get dialogActionDowngrade => 'Rétrograder';

  @override
  String get dialogTitleCNSInstall => 'Installer le système principal de CNS';

  @override
  String get dialogContentCNSInstall =>
      'Vous êtes sur le point d\'installer le système de base Custom Nanosuit System (CNS). Ceci est nécessaire pour que les mods CNS fonctionnent. Souhaitez-vous continuer ?';

  @override
  String get dialogActionInstall => 'Installer';

  @override
  String get settingsDeveloperOptions => 'Options pour les développeurs';

  @override
  String get devDeleteNexusInfoTitle =>
      'Supprimer tous les fichiers nexus_info.json';

  @override
  String get devDeleteNexusInfoDesc =>
      'Supprime tous les fichiers de métadonnées du gestionnaire de chaque mod. Ceci est utile pour forcer une réparation complète.';

  @override
  String get devExtractIdsTitle => 'Extraire les identifiants';

  @override
  String get devExtractIdsDesc =>
      'Crée un fichier nommé \'ID Mods.json\' sur votre bureau contenant le displayName et le nexusId de chaque mod.';

  @override
  String get devConfirmDeleteTitle => 'Confirmer la suppression';

  @override
  String get devConfirmDeleteDesc =>
      'Êtes-vous sûr de vouloir supprimer définitivement tous les fichiers nexus_info.json ? Cela supprimera tous les noms, couvertures et métadonnées personnalisés. Cette action est irréversible.';

  @override
  String get devDeleteSuccessTitle => 'Suppression terminée';

  @override
  String devDeleteSuccessDesc(Object count) {
    return '$count fichiers nexus_info.json supprimés avec succès.';
  }

  @override
  String get devConfirmExtractTitle => 'Confirmer l\'extraction';

  @override
  String get devConfirmExtractDesc =>
      'Ceci analysera tous vos mods et créera \'ID Mods.json\' sur votre bureau. Cela écrasera tout fichier existant du même nom. Voulez-vous continuer ?';

  @override
  String get devExtractAction => 'Extraire';

  @override
  String get devExtractNoData =>
      'Aucun mod avec des identifiants valides n\'a été trouvé pour l\'extraction.';

  @override
  String get devExtractDesktopNotFound =>
      'Erreur : Impossible de trouver le répertoire du Bureau.';

  @override
  String get devExtractSuccessTitle => 'Extraction terminée';

  @override
  String devExtractSuccessDesc(Object path) {
    return 'Fichier créé avec succès à l\'emplacement : $path';
  }

  @override
  String get errorDialogTitle => 'Une erreur s\'est produite';

  @override
  String get modDetailsCategory => 'Catégorie';

  @override
  String get modDetailsAuthor => 'Auteur';

  @override
  String get modDetailsNexusId => 'ID Nexus';

  @override
  String get modDetailsInstalledOn => 'Installé le';

  @override
  String get unknownAuthor => 'Inconnu';

  @override
  String get statusInstalling => 'Installation...';

  @override
  String statusInstallingMod(int index, int total, String modName) {
    return 'Installation de $index/$total : $modName';
  }

  @override
  String byText(Object author) {
    return 'par $author';
  }

  @override
  String get filterUpdatesAvailable => 'Mises à jour disponibles';

  @override
  String snackBarUpdateIgnored(String modName) {
    return 'Mise à jour pour \'$modName\' ignorée pour cette session.';
  }

  @override
  String snackBarVersionSkipped(String modName, String version) {
    return 'La version \'$version\' de \'$modName\' sera ignorée lors des futures vérifications.';
  }

  @override
  String statusUpdatingMetadata(String displayName, int arg1, int arg2) {
    return 'Mise à jour des métadonnées pour \'$displayName\' ($arg1 sur $arg2)...';
  }

  @override
  String genericModInstallTitle(String modName) {
    return 'Generic Mod Installed: $modName';
  }

  @override
  String genericModInstallDesc(String path) {
    return 'Installed to $path. This mod is not managed by the app and must be uninstalled manually.';
  }

  @override
  String genericModInstallError(String modName) {
    return 'Failed to install generic mod: $modName';
  }

  @override
  String get modTypeCNS => 'CNS';

  @override
  String get modTypeGeneric => 'Generic';

  @override
  String get modTypeMovies => 'Movies';

  @override
  String get replacesOutfitTitle => 'Replaces Outfit';

  @override
  String get replacesOutfitClearTooltip => 'Clear outfit selection';

  @override
  String get replacesOutfitSelectTooltip => 'Select outfit to replace';

  @override
  String get replacesOutfitNone =>
      'No outfit selected. The tag will be \'Generic\'.';

  @override
  String get replacesOutfitSearchHint => 'Search outfits...';

  @override
  String get modTypeReplacement => 'Replacement';

  @override
  String get replacesOutfitHover => 'Hover over an outfit to see a preview.';

  @override
  String get dialogTitleOutfitReplacement => 'Outfit Replacement?';

  @override
  String dialogContentOutfitReplacement(String modName) {
    return 'Is the mod \'$modName\' an outfit replacement?\n\nSelect \'Yes\' to choose which outfit it replaces, or \'No\' to install it as a generic mod.';
  }

  @override
  String get dialogActionNo => 'No';

  @override
  String get dialogActionYes => 'Yes';

  @override
  String get dialogTitleOutfitConflict => 'Outfit Conflict Detected';

  @override
  String dialogContentOutfitConflict(String outfitName, String modName) {
    return 'The outfit \'$outfitName\' is already being replaced by the mod \'$modName\'.\n\nDo you want to disable \'$modName\' and activate this one instead?';
  }

  @override
  String get dialogActionActivateAndDisable => 'Disable and Activate';

  @override
  String get replacementModSwitchTitle => 'Replacement mod';

  @override
  String get replacementModSwitchDesc =>
      'Check if this mod is designed to replace a suit in the game.';
}
