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
  String get settingsRepairMods => 'Réparer les Mods Hérités';

  @override
  String get settingsRepairModsDesc =>
      'Analyse et crée des fichiers d\'information pour les anciens mods en utilisant la base de données locale. Clé API requise.';

  @override
  String get settingsConnectivity => 'Connectivité et Mises à Jour';

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
  String get settingsSkippedVersions => 'Gérer les Versions Ignorées';

  @override
  String get settingsSkippedVersionsDesc =>
      'Gérez les versions de mods que vous avez choisi d\'ignorer.';

  @override
  String settingsSkippedVersionsCount(Object count) {
    return '$count versions ignorées';
  }

  @override
  String get dialogTitleSkippedVersions => 'Versions de Mods Ignorées';

  @override
  String get dialogNoSkippedVersions =>
      'Vous n\'avez ignoré aucune version de mod.';

  @override
  String get dialogSkippedVersions => 'Version Ignorée';

  @override
  String get dialogTitleRepairMods => 'Lancer la réparation des mods hérités ?';

  @override
  String get dialogContentRepairMods =>
      'Attention : Cette fonctionnalité est en cours de développement et peut ne pas être parfaite.\n\nElle analysera les mods sans fichier \'nexus_info.json\' et, si trouvés dans votre base de données locale, en créera un pour eux. Elle tentera également de renommer le dossier du mod pour inclure la version trouvée (ex: \'Mon Mod\' -> \'Mon Mod v1.2\').\n\nPriorité de la version :\n1. Depuis le nom du dossier.\n2. Depuis le champ de description du mod.\n3. Depuis la dernière version sur Nexus Mods (requiert une clé API).\n\nSouhaitez-vous continuer ?';

  @override
  String get dialogActionRunRepair => 'Lancer la Réparation';

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
  String get installNewMod => 'Installer un nouveau Mod';

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
      'Impossible de trouver le chemin du jeu automatiquement.';

  @override
  String statusErrorFindingGame(Object error) {
    return 'Une erreur est survenue lors de la recherche du jeu : $error';
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
    return '$count fichier(s) sélectionné(s). Prêt à installer.';
  }

  @override
  String statusFolderSelected(Object folderName) {
    return 'Dossier \"$folderName\" sélectionné. Prêt à installer.';
  }

  @override
  String statusArchiveLoaded(Object count, Object fileName) {
    return 'Fichier \"$fileName\" chargé. $count fichier(s) prêts à être installés.';
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
      'Pour décompresser ce fichier, l\'application a besoin de 7-Zip.\n\nVeuillez l\'installer depuis sa page officielle puis appuyez sur \"Confirmer\".';

  @override
  String get dialogContent7zipNotFound =>
      '7-Zip n\'a pas encore été détecté. Veuillez vous assurer qu\'il est installé dans le chemin par défaut et réessayez.';

  @override
  String get dialogTitleCNSUpdate =>
      'Mise à jour du système principal détectée';

  @override
  String get dialogContentCNSUpdate =>
      'Une mise à jour pour le \"Système de Nanocombinaison Personnalisé\" a été détectée.\n\nCela remplacera des fichiers dans le dossier principal du jeu (StellarBlade\\SB). Souhaitez-vous continuer ?';

  @override
  String get dialogTitleMultipleJsons => 'Plusieurs fichiers .json détectés';

  @override
  String dialogContentMultipleJsons(Object count) {
    return '$count fichiers .json ont été détectés. Il pourrait s\'agir d\'un mod avec plusieurs composants.\n\nVoulez-vous les installer tous ensemble dans un seul dossier de mod ?';
  }

  @override
  String get dialogTitleModExists => 'Le Mod existe déjà';

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
  String get dialogActionUpdateSystem => 'Mettre à jour le Système';

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
    return 'Installation par lot terminée. Succès : $successCount, Échecs : $failedCount.';
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
      'Le Système de Nanocombinaison Personnalisé a été mis à jour avec succès.';

  @override
  String get snackBarApiKeySaved => 'La clé API a été sauvegardée avec succès.';

  @override
  String get snackBarGamePathSaved =>
      'Le chemin du jeu a été sauvegardé avec succès.';

  @override
  String get snackBar7zipPathSaved =>
      'Le chemin de 7-Zip a été sauvegardé avec succès.';

  @override
  String get snackBarSkippedVersionRemoved => 'Version ignorée supprimée.';

  @override
  String get dropTargetOverlay => 'Déposez les mods ici';

  @override
  String get pathSelectionTitle => 'Chemin de Stellar Blade non trouvé';

  @override
  String get pathSelectionButtonManual =>
      'Sélectionner le dossier du jeu manuellement';

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
    return 'Format de fichier non supporté : $extension';
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
    return 'Le fichier $fileName ne semble pas être un mod du Système de Nanocombinaison Personnalisé (il manque \"DisplayName\").';
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
  String get statusUpdatingCNS =>
      'Mise à jour du Système de Nanocombinaison Personnalisé...';

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
      'Cette application est un gestionnaire de mods pour Stellar Blade, conçu pour fonctionner avec le Système de Nanocombinaison Personnalisé (CNS).\n\nPrérequis : Pour une fonctionnalité complète avec les fichiers .rar et .7z, 7-Zip doit être installé sur votre système.';

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
      '1. Allez sur Nexus Mods et connectez-vous.\n2. Cliquez sur votre avatar et allez dans \'Préférences du site\'.\n3. Allez dans l\'onglet \'API\'.\n4. Cliquez sur \'Générer une nouvelle clé API\'.\n5. Copiez la clé et collez-la ici.';

  @override
  String get apiKey => 'Clé API';

  @override
  String get apiKeyHintText => 'Collez votre clé API ici';

  @override
  String get dialogActionSave => 'Sauvegarder';

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
      'Aucune image n\'a été trouvée pour ce mod, ou la clé API n\'a pas été saisie. Veuillez saisir la clé API et vérifier les mises à jour ensuite.';

  @override
  String errorFetchingImages(Object error) {
    return 'Erreur lors de la récupération des images : $error';
  }

  @override
  String get imageMod => 'Image du Mod';

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
  String get dialogActionSkipVersion => 'Ignorer cette Version';

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
  String get dialogTitleUE4SS => 'Installation d\'UE4SS Détectée';

  @override
  String get dialogContentUE4SS =>
      'L\'outil UE4SS a été détecté. Voulez-vous l\'installer dans \'StellarBlade\\SB\\Binaries\\Win64\' ?\n\nCeci est requis pour que de nombreux mods fonctionnent.';

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
  String get dialogTitleDowngrade => 'Version plus Ancienne Détectée';

  @override
  String dialogContentDowngrade(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return 'Attention : Vous êtes sur le point d\'installer une version plus ancienne du mod \'$modName\'.\n\nVersion installée : $oldVersion\nVersion à installer : $newVersion';
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

  @override
  String get editModNameTooltip => 'Modifier le nom du mod';

  @override
  String get setCoverTooltip => 'Définir une image de couverture personnalisée';

  @override
  String get setCoverText => 'Définir la Couverture';

  @override
  String get restoreOriginalCoverText => 'Restaurer la Couverture Originale';

  @override
  String errorSavingCoverText(Object error) {
    return 'Erreur lors de la sauvegarde de l\'image de couverture : $error';
  }

  @override
  String errorRestoringCoverText(Object error) {
    return 'Erreur lors de la restauration de l\'image de couverture originale : $error';
  }

  @override
  String get editVersionText => 'Modifier la Version';

  @override
  String get customVersionText => 'Version Personnalisée';

  @override
  String get editTagText => 'Modifier l\'Étiquette';

  @override
  String get customTagText => 'Étiquette Personnalisée';

  @override
  String get dialogTitleEditModName => 'Modifier le Nom du Mod';

  @override
  String get dialogActionResetToDefault => 'Réinitialiser par Défaut';

  @override
  String get dialogLabelNewName => 'Nouveau nom';

  @override
  String errorModNameExists(Object modName) {
    return 'Un mod nommé \"$modName\" existe déjà.';
  }

  @override
  String get dialogTitleRepairedModWarning => 'Avertissement Mod Réparé';

  @override
  String get dialogContentRepairedModWarning =>
      'Ce mod pourrait ne pas avoir les informations de version correctes. Il est recommandé de réinstaller la dernière version pour assurer la compatibilité.';

  @override
  String get repairedModTooltip => 'Information sur le mod réparé';

  @override
  String get disableAllModsTooltip => 'Désactiver tous les mods';

  @override
  String get deleteAllModsTooltip => 'Supprimer tous les mods désactivés';

  @override
  String get dialogTitleDisableAll => 'Désactiver Tous les Mods ?';

  @override
  String dialogContentDisableAll(int count) {
    return 'Êtes-vous sûr de vouloir désactiver tous les $count mods activés ? Ils seront déplacés dans le dossier de sauvegarde.';
  }

  @override
  String get dialogTitleDeleteAll => 'Supprimer les Mods Désactivés ?';

  @override
  String dialogContentDeleteAll(int count) {
    return 'Vous êtes sur le point de supprimer définitivement tous les $count mods désactivés. Cette action est irréversible.\n\nÊtes-vous sûr ?';
  }

  @override
  String snackBarAllModsDisabled(int count) {
    return 'Tous les $count mods activés ont été désactivés.';
  }

  @override
  String snackBarAllModsDeleted(int count) {
    return 'Tous les $count mods désactivés ont été supprimés définitivement.';
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
  String get dialogTitleEnableAll => 'Activer Tous les Mods ?';

  @override
  String dialogContentEnableAll(int count) {
    return 'Êtes-vous sûr de vouloir activer tous les $count mods désactivés ? Ils seront déplacés vers le dossier principal des mods.';
  }

  @override
  String snackBarAllModsEnabled(int count) {
    return 'Tous les $count mods désactivés ont été activés.';
  }

  @override
  String get snackBarNoModsToEnable =>
      'Il n\'y a aucun mod désactivé à activer.';

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
}
