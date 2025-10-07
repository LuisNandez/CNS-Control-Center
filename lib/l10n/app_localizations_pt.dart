// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'CNS Control Center';

  @override
  String appTitleWithVersion(Object version) {
    return 'Custom Nanosuit System $version';
  }

  @override
  String get settings => 'Configurações';

  @override
  String get settingsGeneral => 'Geral';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageDesc => 'Escolha o idioma do aplicativo';

  @override
  String get settingsAbout => 'Sobre';

  @override
  String get settingsAboutDesc => 'Informações sobre o aplicativo';

  @override
  String get settingsPathsAndTools => 'Caminhos e Ferramentas';

  @override
  String get settingsGameFolder => 'Pasta do Jogo';

  @override
  String get settingsGameFolderDesc =>
      'A pasta raiz da sua instalação do Stellar Blade.';

  @override
  String get settings7zipPath => 'Caminho do 7-Zip';

  @override
  String get settings7zipPathDesc =>
      'O local do arquivo 7z.exe para extrair mods.';

  @override
  String get settings7zipPathAuto => 'Busca automática';

  @override
  String get settingsRepairMods => 'Reparar Mods Legados';

  @override
  String get settingsRepairModsDesc =>
      'Verifica e cria arquivos de informação para mods antigos usando o banco de dados local. Requer chave de API.';

  @override
  String get settingsConnectivity => 'Conectividade e Atualizações';

  @override
  String get settingsApiKey => 'Chave de API do Nexus Mods';

  @override
  String get settingsApiKeyDesc =>
      'Necessária para verificar as atualizações dos mods.';

  @override
  String get settingsApiKeySet => 'Definida';

  @override
  String get settingsApiKeyNotSet => 'Não definida';

  @override
  String get settingsSkippedVersions => 'Gerenciar Versões Ignoradas';

  @override
  String get settingsSkippedVersionsDesc =>
      'Gerencie as versões de mods que você escolheu ignorar.';

  @override
  String settingsSkippedVersionsCount(Object count) {
    return '$count versões ignoradas';
  }

  @override
  String get dialogTitleSkippedVersions => 'Versões de Mods Ignoradas';

  @override
  String get dialogNoSkippedVersions =>
      'Você não ignorou nenhuma versão de mod.';

  @override
  String get dialogSkippedVersions => 'Versão Ignorada';

  @override
  String get dialogTitleRepairMods => 'Executar Reparo de Mods Legados?';

  @override
  String get dialogContentRepairMods =>
      'Aviso: Este recurso está em desenvolvimento e pode não ser perfeito.\n\nEle irá escanear mods sem o arquivo \'nexus_info.json\' e, se encontrado em seu banco de dados local, criará um para eles. Ele também tentará renomear a pasta do mod para incluir a versão encontrada (ex: \'Meu Mod\' -> \'Meu Mod v1.2\').\n\nPrioridade de Versão:\n1. Pelo nome da pasta.\n2. Pelo campo de descrição do mod.\n3. Pela versão mais recente no Nexus Mods (requer API).\n\nDeseja continuar?';

  @override
  String get dialogActionRunRepair => 'Executar Reparo';

  @override
  String get snackBarGamePathInvalid =>
      'A pasta selecionada não parece ser uma pasta de jogo válida.';

  @override
  String get snackBar7zipPathInvalid =>
      'O arquivo selecionado deve se chamar 7z.exe.';

  @override
  String get snackBarRepairStarted =>
      'O processo de reparo de mods legados foi iniciado...';

  @override
  String snackBarRepairComplete(Object count) {
    return 'Reparo concluído. $count mod(s) foram atualizados.';
  }

  @override
  String get snackBarRepairNoMods =>
      'Nenhum mod legado que precisasse de reparo foi encontrado.';

  @override
  String get errorApiRequiredForRepair =>
      'A Chave de API é necessária para encontrar a versão mais recente de mods sem uma versão local.';

  @override
  String get installNewMod => 'Instalar Novo Mod';

  @override
  String get selectFiles => 'Selecionar Arquivos';

  @override
  String get selectFolder => 'Selecionar Pasta';

  @override
  String get installSelectedMod => 'Instalar Mod Selecionado';

  @override
  String get filesToInstall => 'Arquivos para Instalar:';

  @override
  String get cancelSelection => 'Cancelar Seleção';

  @override
  String get searchMods => 'Buscar mods...';

  @override
  String get enabledMods => 'Mods Ativados';

  @override
  String get disabledMods => 'Mods Desativados';

  @override
  String get refreshList => 'Atualizar lista';

  @override
  String get noEnabledMods => 'Nenhum mod ativado.';

  @override
  String get noDisabledMods => 'Nenhum mod desativado.';

  @override
  String get showInFolder => 'Mostrar na pasta';

  @override
  String get disableMod => 'Desativar mod';

  @override
  String get enableMod => 'Ativar mod';

  @override
  String get deletePermanently => 'Excluir permanentemente';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Selecione um idioma';

  @override
  String get statusSearchingGame =>
      'Procurando a instalação do Stellar Blade...';

  @override
  String get statusGamePathFound => 'Caminho do jogo encontrado!';

  @override
  String get statusGamePathNotFound =>
      'Não foi possível encontrar o caminho do jogo automaticamente.';

  @override
  String statusErrorFindingGame(Object error) {
    return 'Ocorreu um erro ao procurar o jogo: $error';
  }

  @override
  String statusModsFound(Object disabledCount, Object enabledCount) {
    return '$enabledCount mod(s) ativado(s), $disabledCount desativado(s).';
  }

  @override
  String statusErrorReadingMods(Object error) {
    return 'Erro ao ler os mods instalados: $error';
  }

  @override
  String statusFilesSelected(Object count) {
    return '$count arquivo(s) selecionado(s). Pronto para instalar.';
  }

  @override
  String statusFolderSelected(Object folderName) {
    return 'Pasta \"$folderName\" selecionada. Pronta para instalar.';
  }

  @override
  String statusArchiveLoaded(Object count, Object fileName) {
    return 'Arquivo \"$fileName\" carregado. $count arquivo(s) prontos para instalar.';
  }

  @override
  String get statusSelectionCancelled =>
      'Seleção cancelada. Escolha um novo mod para instalar.';

  @override
  String get statusUpdateComplete => 'Atualização concluída.';

  @override
  String get statusInstallationComplete => 'Instalação concluída.';

  @override
  String statusError(Object error) {
    return 'Erro: $error';
  }

  @override
  String get dialogTitle7zip => '7-Zip é necessário';

  @override
  String get dialogContent7zip =>
      'Para descompactar este arquivo, o aplicativo precisa do 7-Zip.\n\nPor favor, instale-o a partir de sua página oficial e pressione \"Confirmar\".';

  @override
  String get dialogContent7zipNotFound =>
      'O 7-Zip ainda não foi detectado. Verifique se ele está instalado no caminho padrão и tente novamente.';

  @override
  String get dialogTitleMultipleJsons => 'Múltiplos Arquivos .json Detectados';

  @override
  String dialogContentMultipleJsons(Object count) {
    return '$count arquivos .json foram detectados. Isso pode ser um mod com múltiplos componentes.\n\nDeseja instalá-los todos juntos em uma única pasta de mod?';
  }

  @override
  String get dialogTitleModExists => 'O Mod Já Existe';

  @override
  String dialogContentModExists(Object modName) {
    return 'Um mod chamado \"$modName\" já está instalado.\n\nDeseja atualizá-lo? Os arquivos antigos serão excluídos antes de instalar os novos.';
  }

  @override
  String dialogContentModUpdate(Object newModName, Object oldModName) {
    return 'Uma versão mais antiga \'$oldModName\' foi encontrada.\n\nDeseja removê-la e atualizar para \'$newModName\'?';
  }

  @override
  String get dialogTitleDeleteMod => 'Excluir Permanentemente?';

  @override
  String dialogContentDeleteMod(Object modName) {
    return 'Você está prestes a excluir permanentemente o mod \"$modName\". Esta ação não pode ser desfeita.\n\nVocê tem certeza?';
  }

  @override
  String get dialogActionCancel => 'Cancelar';

  @override
  String get dialogActionGoToDownload => 'Ir para a Página de Download';

  @override
  String get dialogActionConfirmInstallation => 'Confirmar Instalação';

  @override
  String get dialogActionUpdateSystem => 'Atualizar Sistema';

  @override
  String get dialogActionInstallAnyway => 'Instalar Mesmo Assim';

  @override
  String get dialogActionDelete => 'Excluir';

  @override
  String get dialogActionClose => 'Fechar';

  @override
  String snackBarBatchInstallComplete(Object failedCount, Object successCount) {
    return 'Instalação em lote concluída. Sucesso: $successCount, Falha: $failedCount.';
  }

  @override
  String snackBarModInstalled(Object modName) {
    return 'Mod \"$modName\" instalado com sucesso.';
  }

  @override
  String snackBarModEnabled(Object modName) {
    return 'Mod \"$modName\" ativado.';
  }

  @override
  String snackBarModDisabled(Object modName) {
    return 'Mod \"$modName\" desativado.';
  }

  @override
  String snackBarModDeleted(Object modName) {
    return 'Mod \"$modName\" excluído permanentemente.';
  }

  @override
  String get snackBarCNSUpdated =>
      'Sistema de Nanotraje Personalizado atualizado com sucesso.';

  @override
  String get snackBarApiKeySaved => 'Chave de API salva com sucesso.';

  @override
  String get snackBarGamePathSaved => 'Caminho do jogo salvo com sucesso.';

  @override
  String get snackBar7zipPathSaved => 'Caminho do 7-Zip salvo com sucesso.';

  @override
  String get snackBarSkippedVersionRemoved => 'Versão ignorada removida.';

  @override
  String get dropTargetOverlay => 'Arraste os mods para cá';

  @override
  String get pathSelectionTitle => 'Caminho do Stellar Blade Não Encontrado';

  @override
  String get pathSelectionButtonManual =>
      'Selecionar Pasta do Jogo Manualmente';

  @override
  String get pathSelectionButtonRetry => 'Tentar Novamente';

  @override
  String errorFolderSelection(Object error) {
    return 'Erro ao selecionar a pasta: $error';
  }

  @override
  String errorFileSelection(Object error) {
    return 'Erro ao selecionar arquivos: $error';
  }

  @override
  String errorDecompressing(Object error) {
    return 'Erro ao descompactar o arquivo: $error';
  }

  @override
  String errorProcessingArchive(Object error) {
    return 'Erro ao processar o arquivo: $error';
  }

  @override
  String errorUnsupportedFormat(Object extension) {
    return 'Formato de arquivo não suportado: $extension';
  }

  @override
  String get error7zipRequired => 'Operação cancelada: 7-Zip é necessário.';

  @override
  String get errorGamePathUndefined => 'O caminho do jogo não está definido.';

  @override
  String get errorDestinationNotFound =>
      'A pasta de destino do jogo não existe.';

  @override
  String errorUpdateSystem(Object error) {
    return 'Erro ao atualizar o sistema: $error';
  }

  @override
  String get errorInstallNoSelection =>
      'Você não selecionou nada para instalar.';

  @override
  String get errorInstallModExists => 'Instalação cancelada: o mod já existe.';

  @override
  String get errorNoJsonFound =>
      'Cada mod deve conter pelo menos um arquivo .json.';

  @override
  String errorInvalidJsonFormat(Object fileName) {
    return 'O arquivo $fileName tem um formato JSON inválido.';
  }

  @override
  String errorNoDisplayName(Object fileName) {
    return 'O arquivo $fileName não parece ser um mod do Sistema de Nanotraje Personalizado (\"DisplayName\" ausente).';
  }

  @override
  String get errorNoValidDisplayName =>
      'Nenhum \"DisplayName\" válido foi encontrado nos arquivos .json.';

  @override
  String errorEnableMod(Object error) {
    return 'Erro ao ativar o mod: $error';
  }

  @override
  String errorDisableMod(Object error) {
    return 'Erro ao desativar o mod: $error';
  }

  @override
  String errorDeleteMod(Object error) {
    return 'Erro ao excluir o mod: $error';
  }

  @override
  String errorOpenFolder(Object path) {
    return 'Não foi possível abrir a pasta: $path';
  }

  @override
  String get statusUpdateSystemCancelled => 'Atualização do sistema cancelada.';

  @override
  String get statusUpdatingCNS =>
      'Atualizando o Sistema de Nanotraje Personalizado...';

  @override
  String statusExtractingFile(Object fileName) {
    return 'Extraindo $fileName...';
  }

  @override
  String get statusInstallationCancelledByUser =>
      'Instalação cancelada pelo usuário.';

  @override
  String get errorNoCompatibleFilesInFolder =>
      'A pasta selecionada não contém arquivos de mod compatíveis.';

  @override
  String get errorNoCompatibleFilesInArchive =>
      'O arquivo compactado não contém arquivos de mod compatíveis.';

  @override
  String get errorNoJsonInSelection =>
      'A seleção não contém um arquivo .json de mod válido.';

  @override
  String get aboutTitle => 'Sobre o Centro de Controle CNS';

  @override
  String get aboutContent =>
      'Este aplicativo é um gerenciador de mods para o Stellar Blade, projetado para funcionar com o Sistema de Nanotraje Personalizado (CNS).\n\nRequisito: Para funcionalidade completa com arquivos .rar e .7z, o 7-Zip deve estar instalado em seu sistema.';

  @override
  String get aboutLinkText => 'Visite meu perfil de criador';

  @override
  String get creatorProfileUrl =>
      'https://next.nexusmods.com/profile/LuisNandez?gameId=7804';

  @override
  String aboutVersion(Object version) {
    return 'Versão: $version';
  }

  @override
  String get openModsFolder => 'Abrir Pasta de Mods';

  @override
  String get openInNexusMods => 'Abrir no Nexus Mods';

  @override
  String get checkForUpdates => 'Verificar atualizações';

  @override
  String updateAvailable(Object version) {
    return 'Atualização disponível: v$version';
  }

  @override
  String get dialogTitleApiKey => 'Chave de API do Nexus Mods';

  @override
  String get dialogContentApiKey =>
      'Para verificar as atualizações dos mods, você precisa de uma chave de API pessoal do Nexus Mods.';

  @override
  String get dialogContentApiKeyInstructions =>
      '1. Vá para o Nexus Mods e faça login.\n2. Clique no seu avatar e vá para \'Preferências do site\'.\n3. Vá para a guia \'API\'.\n4. Clique em \'Gerar uma nova chave de API\'.\n5. Copie a chave e cole-a aqui.';

  @override
  String get apiKey => 'Chave de API';

  @override
  String get apiKeyHintText => 'Cole sua chave de API aqui';

  @override
  String get dialogActionSave => 'Salvar';

  @override
  String get apiKeyRemoved => 'Chave de API removida.';

  @override
  String get invalidApiKeyError => 'Chave de API inválida.';

  @override
  String get validatingApiKey => 'Validando...';

  @override
  String get errorApiKeyMissing =>
      'A Chave de API do Nexus Mods não está configurada. Adicione-a através do ícone de chave na barra superior.';

  @override
  String get statusCheckingUpdates => 'Verificando atualizações de mods...';

  @override
  String statusUpdatesFound(Object count) {
    return '$count atualização(ões) encontrada(s)!';
  }

  @override
  String get statusNoUpdates => 'Todos os mods estão atualizados.';

  @override
  String get selectModArchive => 'Selecionar Arquivo de Mod';

  @override
  String get viewImageGallery => 'Ver Imagem';

  @override
  String get imageGallery => 'Galeria de Imagens';

  @override
  String get noImagesFound =>
      'Nenhuma imagem foi encontrada para este mod, ou a chave de API não foi inserida. Insira a chave de API e verifique as atualizações depois.';

  @override
  String errorFetchingImages(Object error) {
    return 'Erro ao buscar imagens: $error';
  }

  @override
  String get imageMod => 'Imagem do Mod';

  @override
  String get modEnabledBadge => 'Ativado';

  @override
  String get modDisabledBadge => 'Desativado';

  @override
  String get modCategoryOther => 'Não especificado';

  @override
  String get dialogContentUpdateOptions => 'O que você gostaria de fazer?';

  @override
  String get dialogActionIgnoreVersion => 'Ignorar';

  @override
  String get dialogActionSkipVersion => 'Pular Versão';

  @override
  String get dialogActionGoToDownloadPage => 'Ir para o Download';

  @override
  String get installedMods => 'Mods Instalados';

  @override
  String get filterBy => 'Filtrar por:';

  @override
  String get sortBy => 'Ordenar por:';

  @override
  String get filterAll => 'Todos';

  @override
  String get filterEnabled => 'Ativados';

  @override
  String get filterDisabled => 'Desativados';

  @override
  String get filterRepaired => 'Reparados';

  @override
  String get sortByName => 'Nome';

  @override
  String get sortByDate => 'Data';

  @override
  String get noModsFound => 'Nenhum mod encontrado.';

  @override
  String get viewTypeGrid => 'Visualização em grade';

  @override
  String get viewTypeList => 'Visualização em lista';

  @override
  String statusExtractingMultipleFiles(
    Object count,
    Object fileName,
    Object total,
  ) {
    return 'Extraindo $count de $total: $fileName';
  }

  @override
  String get previewInstallTitle => 'Mods a serem instalados:';

  @override
  String get dialogTitleUE4SS => 'Instalação do UE4SS Detectada';

  @override
  String get dialogContentUE4SS =>
      'A ferramenta UE4SS foi detectada. Deseja instalá-la em \'StellarBlade\\SB\\Binaries\\Win64\'?\n\nIsso é necessário para que muitos mods funcionem.';

  @override
  String get dialogActionInstallTool => 'Instalar Ferramenta';

  @override
  String get statusUE4SSInstallCancelled => 'Instalação do UE4SS cancelada.';

  @override
  String get statusInstallingUE4SS => 'Instalando UE4SS...';

  @override
  String get snackBarUE4SSInstalled => 'UE4SS instalado com sucesso.';

  @override
  String error7zipDecompression(Object error) {
    return 'Erro do 7-Zip durante a descompactação: $error';
  }

  @override
  String get statusUE4SSInstallComplete => 'Instalação do UE4SS concluída.';

  @override
  String get dialogTitleAlternativeVersion => 'Versão Alternativa Detectada';

  @override
  String dialogContentAlternativeVersion(
    String oldModName,
    String baseModName,
    String newModName,
  ) {
    return 'Uma versão alternativa deste mod já está instalada: \'$oldModName\'.\n\nVocê está prestes a instalar uma alternativa diferente chamada \'$newModName\'.';
  }

  @override
  String get dialogActionReplace => 'Substituir';

  @override
  String get dialogActionInstallAsNew => 'Instalar como Novo';

  @override
  String get dialogTitleUpdate => 'Atualização Disponível';

  @override
  String dialogContentUpdate(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return 'Você está prestes a atualizar o mod \'$modName\'.\n\nVersão instalada: $oldVersion\nNova versão: $newVersion';
  }

  @override
  String get dialogTitleDowngrade => 'Versão Mais Antiga Detectada';

  @override
  String dialogContentDowngrade(
    String modName,
    String oldVersion,
    String newVersion,
  ) {
    return 'Aviso: Você está prestes a instalar uma versão mais antiga do mod \'$modName\'.\n\nVersão instalada: $oldVersion\nVersão a ser instalada: $newVersion';
  }

  @override
  String get dialogTitleReinstall => 'Reinstalar Mod';

  @override
  String dialogContentReinstall(Object modName, Object version) {
    return 'Você está prestes a reinstalar a versão \'$version\' do mod \'$modName\'.';
  }

  @override
  String get dialogActionReinstall => 'Reinstalar';

  @override
  String get editModNameTooltip => 'Editar nome do mod';

  @override
  String get setCoverTooltip => 'Definir imagem de capa personalizada';

  @override
  String get setCoverText => 'Definir Capa';

  @override
  String get restoreOriginalCoverText => 'Restaurar Capa Original';

  @override
  String errorSavingCoverText(Object error) {
    return 'Erro ao salvar a imagem de capa: $error';
  }

  @override
  String errorRestoringCoverText(Object error) {
    return 'Erro ao restaurar a imagem de capa original: $error';
  }

  @override
  String get editVersionText => 'Editar Versão';

  @override
  String get customVersionText => 'Versão Personalizada';

  @override
  String get editTagText => 'Editar Etiqueta';

  @override
  String get customTagText => 'Etiqueta Personalizada';

  @override
  String get dialogTitleEditModName => 'Editar Nome do Mod';

  @override
  String get dialogActionResetToDefault => 'Redefinir para o Padrão';

  @override
  String get dialogLabelNewName => 'Novo nome';

  @override
  String errorModNameExists(Object modName) {
    return 'Um mod chamado \"$modName\" já existe.';
  }

  @override
  String get dialogTitleRepairedModWarning => 'Aviso de Mod Reparado';

  @override
  String get dialogContentRepairedModWarning =>
      'Este mod pode não ter as informações de versão corretas. Reinstalar a versão mais recente é recomendado para garantir a compatibilidade.';

  @override
  String get repairedModTooltip => 'Informações sobre o mod reparado';

  @override
  String get disableAllModsTooltip => 'Desativar todos os mods';

  @override
  String get deleteAllModsTooltip => 'Excluir todos os mods desativados';

  @override
  String get dialogTitleDisableAll => 'Desativar Todos os Mods?';

  @override
  String dialogContentDisableAll(int count) {
    return 'Tem certeza de que deseja desativar todos os $count mods ativados? Eles serão movidos para a pasta de backup.';
  }

  @override
  String get dialogTitleDeleteAll => 'Excluir Mods Desativados?';

  @override
  String dialogContentDeleteAll(int count) {
    return 'Você está prestes a excluir permanentemente todos os $count mods desativados. Esta ação não pode ser desfeita.\n\nVocê tem certeza?';
  }

  @override
  String snackBarAllModsDisabled(int count) {
    return 'Todos os $count mods ativados foram desativados.';
  }

  @override
  String snackBarAllModsDeleted(int count) {
    return 'Todos os $count mods desativados foram excluídos permanentemente.';
  }

  @override
  String get snackBarNoModsToDisable => 'Não há mods ativados para desativar.';

  @override
  String get snackBarNoModsToDelete => 'Não há mods desativados para excluir.';

  @override
  String get enableAllModsTooltip => 'Ativar todos os mods';

  @override
  String get dialogTitleEnableAll => 'Ativar Todos os Mods?';

  @override
  String dialogContentEnableAll(int count) {
    return 'Tem certeza de que deseja ativar todos os $count mods desativados? Eles serão movidos para a pasta principal de mods.';
  }

  @override
  String snackBarAllModsEnabled(int count) {
    return 'Todos os $count mods desativados foram ativados.';
  }

  @override
  String get snackBarNoModsToEnable => 'Não há mods desativados para ativar.';

  @override
  String get editNotes => 'Editar Notas';

  @override
  String get notesHintText => 'Adicione suas notas pessoais aqui...';

  @override
  String get modAuthor => 'Autor';

  @override
  String get modDescription => 'Descrição';

  @override
  String get noDescriptionAvailable => 'Nenhuma descrição disponível.';

  @override
  String get personalNotes => 'Notas Pessoais';

  @override
  String get noNotesAvailable => 'Nenhuma nota adicionada ainda.';

  @override
  String get modDetailsTitle => 'Detalhes do Mod';

  @override
  String get modVersion => 'Versão';

  @override
  String get modCategory => 'Categoria';

  @override
  String get dialogTitleAddUrl => 'Adicionar Link do Mod';

  @override
  String get dialogLabelUrl => 'URL do Mod';

  @override
  String get errorInvalidUrl => 'Por favor, insira um URL válido.';

  @override
  String get addLinkTooltip => 'Adicionar um link de download para este mod';

  @override
  String get addLinkButtonText => 'Adicionar Link';

  @override
  String get openLinkButtonText => 'Abrir Link';

  @override
  String get editModTitle => 'Editar Detalhes do Mod';

  @override
  String get modNameLabel => 'Nome do Mod';

  @override
  String get authorLabel => 'Autor';

  @override
  String get summaryLabel => 'Descrição / Resumo';

  @override
  String get notesLabel => 'Notas Pessoais';

  @override
  String get urlLabel => 'URL de Download';

  @override
  String get changeCoverButton => 'Alterar Imagem de Capa';

  @override
  String get editButtonTooltip => 'Editar Mod';

  @override
  String get errorSavingNotes => 'Erro ao salvar notas';

  @override
  String get errorSavingUrl => 'Erro ao salvar URL';

  @override
  String get errorSavingChanges => 'Erro ao Salvar Alterações';

  @override
  String get errorTranslation => 'Não foi possível traduzir a descrição';

  @override
  String get translateDescription => 'Traduzir descrição';

  @override
  String get dialogTitleUE4SSReinstall => 'Reinstall UE4SS';

  @override
  String get dialogContentUE4SSReinstall =>
      'UE4SS already seems to be installed.\nDo you want to overwrite the existing installation? This can be useful if you suspect corrupt files.';

  @override
  String get dialogTitleCNSReinstall => 'Reinstall CNS System';

  @override
  String get dialogContentCNSReinstall =>
      'The main CNS system already seems to be installed.\nDo you want to reinstall it? Your existing mods will not be affected.';

  @override
  String dialogTitleUninstall(Object componentName) {
    return 'Uninstall $componentName';
  }

  @override
  String dialogContentUninstall(Object componentName) {
    return 'Are you sure you want to uninstall $componentName?\nThis action will remove the core component files but will not affect your installed mods.';
  }

  @override
  String get dialogActionUninstall => 'Yes, uninstall';

  @override
  String statusUninstalling(Object componentName) {
    return 'Uninstalling $componentName...';
  }

  @override
  String snackBarUninstalled(Object componentName) {
    return '$componentName uninstalled successfully';
  }

  @override
  String errorUninstalling(Object componentName) {
    return 'Error uninstalling $componentName';
  }

  @override
  String get settingsCoreComponents => 'Core Components';

  @override
  String get installedStatus => 'Installed';

  @override
  String get notInstalledStatus => 'Not detected';

  @override
  String get uninstallButton => 'Uninstall';

  @override
  String get cnsCoreSystem => 'Custom Nanosuit System';

  @override
  String get ue4ssInstallationDetected =>
      'Instalación de UE4SS existente detectada y adoptada';

  @override
  String get cnsInstallationDetected =>
      'Instalación de CNS Principal existente detectada y adoptada';

  @override
  String get ue4ssRequiredTitle => 'UE4SS Required';

  @override
  String get ue4ssRequiredContent =>
      'To install the Main CNS System, you must first install UE4SS.\nYou can download it from the following link:';

  @override
  String get uninstallDependencyTitle => 'Dependency Detected';

  @override
  String get uninstallDependencyContent =>
      'You must uninstall the Main CNS System before you can uninstall UE4SS, as CNS depends on it.';

  @override
  String get dialogActionUnderstood => 'Understood';

  @override
  String get appTitleNoCns => 'Custom Nanosuit System (Not Installed)';

  @override
  String get dialogTitleCNSUpdate => 'Update Main CNS System';

  @override
  String dialogContentCNSUpdate(Object oldVersion, Object newVersion) {
    return 'You are about to update CNS from version $oldVersion to the new version $newVersion.\nDo you wish to continue?';
  }

  @override
  String get dialogTitleCNSDowngrade => 'Downgrade CNS Version';

  @override
  String dialogContentCNSDowngrade(Object oldVersion, Object newVersion) {
    return 'Warning!\nYou are about to install an older version of CNS ($newVersion) than your current one ($oldVersion). This may cause issues.\nAre you sure?';
  }

  @override
  String dialogContentCNSReinstallVersion(Object version) {
    return 'You already have version $version of CNS installed.\nDo you want to reinstall the files anyway?';
  }

  @override
  String get dialogActionUpdate => 'Atualizar';

  @override
  String get dialogActionDowngrade => 'Fazer Downgrade';

  @override
  String get dialogTitleCNSInstall => 'Install Main CNS System';

  @override
  String get dialogContentCNSInstall =>
      'You are about to install the base Custom Nanosuit System (CNS).\nThis is required for CNS mods to work. Do you wish to continue?';

  @override
  String get dialogActionInstall => 'Install';
}
