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
  String get dialogTitleSkippedVersions => 'Versões de Mod Ignoradas';

  @override
  String get dialogNoSkippedVersions =>
      'Você não ignorou nenhuma versão de mod.';

  @override
  String get dialogSkippedVersions => 'Versão Ignorada';

  @override
  String get dialogTitleRepairMods => 'Executar Reparo de Mods Legados?';

  @override
  String get dialogContentRepairMods =>
      'Aviso: Este recurso está em desenvolvimento e pode не ser perfeito.\n\nEle verificará os mods sem um arquivo \'nexus_info.json\' e, se encontrado em seu banco de dados local, criará um para eles. Ele também tentará renomear a pasta do mod para incluir a versão encontrada (ex., \'Meu Mod\' -> \'Meu Mod v1.2\').\n\nPrioridade de Versão:\n1. Do nome da pasta.\n2. Do campo de descrição do mod.\n3. Da versão mais recente no Nexus Mods (requer API).\n\nDeseja continuar?';

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
      'A Chave de API é necessária para encontrar a versão mais recente para mods sem uma versão local.';

  @override
  String get installNewMod => 'Instalar Mod';

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
  String get statusUpdateComplete => 'Atualização completa.';

  @override
  String get statusInstallationComplete => 'Instalação completa.';

  @override
  String statusError(Object error) {
    return 'Erro: $error';
  }

  @override
  String get dialogTitle7zip => '7-Zip é Necessário';

  @override
  String get dialogContent7zip =>
      'Para descompactar este arquivo, o aplicativo precisa do 7-Zip.\n\nPor favor, instale-o a partir de sua página oficial e, em seguida, pressione \"Confirmar\".';

  @override
  String get dialogContent7zipNotFound =>
      'O 7-Zip ainda не foi detectado. Verifique se ele está instalado no caminho padrão e tente novamente.';

  @override
  String get dialogTitleMultipleJsons => 'Vários Arquivos .json Detectados';

  @override
  String dialogContentMultipleJsons(Object count) {
    return '$count arquivos .json foram detectados. Pode ser um mod com vários componentes.\n\nDeseja instalá-los todos juntos em uma única pasta de mod?';
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
    return 'Você está prestes a excluir permanentemente o mod \"$modName\". Esta ação não pode ser desfeita.\n\nTem certeza?';
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
      'Custom Nanosuit System atualizado com sucesso.';

  @override
  String get snackBarApiKeySaved => 'Chave de API salva com sucesso.';

  @override
  String get snackBarGamePathSaved => 'Caminho do jogo salvo com sucesso.';

  @override
  String get snackBar7zipPathSaved => 'Caminho do 7-Zip salvo com sucesso.';

  @override
  String get snackBarSkippedVersionRemoved => 'Versão ignorada removida.';

  @override
  String get dropTargetOverlay => 'Arraste os mods aqui';

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
  String get errorGamePathUndefined => 'O caminho do jogo не está definido.';

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
    return 'O arquivo $fileName não parece ser um mod do Custom Nanosuit System (faltando \"DisplayName\").';
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
  String get statusUpdatingCNS => 'Atualizando o Custom Nanosuit System...';

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
      'A seleção не contém um arquivo .json de mod válido.';

  @override
  String get aboutTitle => 'Sobre o Centro de Controle CNS';

  @override
  String get aboutContent =>
      'Este aplicativo é um gerenciador de mods para o Stellar Blade, projetado para funcionar com o Custom Nanosuit System (CNS).\n\nRequisito: Para funcionalidade completa com arquivos .rar e .7z, o 7-Zip deve estar instalado no seu sistema.';

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
      'Para verificar atualizações de mods, você precisa de uma chave de API pessoal do Nexus Mods.';

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
      'A chave de API do Nexus Mods não está configurada. Adicione-a através do ícone de chave na barra superior.';

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
  String get viewImageGallery => 'Ver Galeria de Imagens';

  @override
  String get imageGallery => 'Galeria de Imagens';

  @override
  String get noImagesFound =>
      'Nenhuma imagem foi encontrada para este mod, ou a chave de API не foi inserida. Por favor, insira a chave de API e verifique as atualizações depois.';

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
  String get dialogActionGoToDownloadPage => 'Ir para Download';

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
  String get previewInstallTitle => 'Mods a Serem Instalados:';

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
    return 'Erro do 7-Zip durante a descompressão: $error';
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
    return 'Erro ao salvar a imagem da capa: $error';
  }

  @override
  String errorRestoringCoverText(Object error) {
    return 'Erro ao restaurar a imagem da capa original: $error';
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
  String get dialogActionResetToDefault => 'Restaurar para Padrão';

  @override
  String get dialogLabelNewName => 'Novo nome';

  @override
  String errorModNameExists(Object modName) {
    return 'Um mod com o nome \"$modName\" já existe.';
  }

  @override
  String get dialogTitleRepairedModWarning => 'Aviso de Mod Reparado';

  @override
  String get dialogContentRepairedModWarning =>
      'Este mod pode não ter as informações de versão corretas. Recomenda-se reinstalar a versão mais recente para garantir a compatibilidade.';

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
    return 'Você está prestes a excluir permanentemente todos os $count mods desativados. Esta ação não pode ser desfeita.\n\nTem certeza?';
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
  String get errorInvalidUrl => 'Por favor, insira uma URL válida.';

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
  String get changeCoverButton => 'Alterar Imagem da Capa';

  @override
  String get editButtonTooltip => 'Editar Mod';

  @override
  String get errorSavingNotes => 'Erro ao salvar as notas';

  @override
  String get errorSavingUrl => 'Erro ao salvar a URL';

  @override
  String get errorSavingChanges => 'Erro ao Salvar Alterações';

  @override
  String get errorTranslation => 'Não foi possível traduzir a descrição';

  @override
  String get translateDescription => 'Traduzir descrição';

  @override
  String get dialogTitleUE4SSReinstall => 'Reinstalar UE4SS';

  @override
  String get dialogContentUE4SSReinstall =>
      'O UE4SS já parece estar instalado. Deseja substituir a instalação existente? Isso pode ser útil se você suspeitar de arquivos corrompidos.';

  @override
  String get dialogTitleCNSReinstall => 'Reinstalar Sistema CNS';

  @override
  String get dialogContentCNSReinstall =>
      'O sistema CNS principal já parece estar instalado. Deseja reinstalá-lo? Seus mods existentes não serão afetados.';

  @override
  String dialogTitleUninstall(Object componentName) {
    return 'Desinstalar $componentName';
  }

  @override
  String dialogContentUninstall(Object componentName) {
    return 'Tem certeza de que deseja desinstalar $componentName? Esta ação removerá os arquivos do componente principal, mas не afetará seus mods instalados.';
  }

  @override
  String get dialogActionUninstall => 'Sim, desinstalar';

  @override
  String statusUninstalling(Object componentName) {
    return 'Desinstalando $componentName...';
  }

  @override
  String snackBarUninstalled(Object componentName) {
    return '$componentName desinstalado com sucesso';
  }

  @override
  String errorUninstalling(Object componentName) {
    return 'Erro ao desinstalar $componentName';
  }

  @override
  String get settingsCoreComponents => 'Componentes Principais';

  @override
  String get installedStatus => 'Instalado';

  @override
  String get notInstalledStatus => 'Não detectado';

  @override
  String get uninstallButton => 'Desinstalar';

  @override
  String get cnsCoreSystem => 'Custom Nanosuit System';

  @override
  String get ue4ssInstallationDetected =>
      'Instalação existente do UE4SS detectada e adotada';

  @override
  String get cnsInstallationDetected =>
      'Instalação principal do CNS existente detectada e adotada';

  @override
  String get ue4ssRequiredTitle => 'UE4SS Necessário';

  @override
  String get ue4ssRequiredContent =>
      'Para instalar o Sistema Principal do CNS, você deve primeiro instalar o UE4SS. Você pode baixá-lo no seguinte link:';

  @override
  String get uninstallDependencyTitle => 'Dependência Detectada';

  @override
  String get uninstallDependencyContent =>
      'Você deve desinstalar o Sistema Principal do CNS antes de poder desinstalar o UE4SS, pois o CNS depende dele.';

  @override
  String get dialogActionUnderstood => 'Entendido';

  @override
  String get appTitleNoCns => 'Custom Nanosuit System (Não Instalado)';

  @override
  String get dialogTitleCNSUpdate => 'Atualizar Sistema Principal do CNS';

  @override
  String dialogContentCNSUpdate(Object oldVersion, Object newVersion) {
    return 'Você está prestes a atualizar o CNS da versão $oldVersion para a nova versão $newVersion. Deseja continuar?';
  }

  @override
  String get dialogTitleCNSDowngrade => 'Fazer Downgrade da Versão do CNS';

  @override
  String dialogContentCNSDowngrade(Object oldVersion, Object newVersion) {
    return 'Aviso! Você está prestes a instalar uma versão mais antiga do CNS ($newVersion) do que a sua atual ($oldVersion). Isso pode causar problemas. Tem certeza?';
  }

  @override
  String dialogContentCNSReinstallVersion(Object version) {
    return 'Você já tem a versão $version do CNS instalada. Deseja reinstalar os arquivos mesmo assim?';
  }

  @override
  String get dialogActionUpdate => 'Atualizar';

  @override
  String get dialogActionDowngrade => 'Fazer Downgrade';

  @override
  String get dialogTitleCNSInstall => 'Instalar Sistema Principal do CNS';

  @override
  String get dialogContentCNSInstall =>
      'Você está prestes a instalar o sistema base Custom Nanosuit System (CNS). Isso é necessário para que os mods do CNS funcionem. Deseja continuar?';

  @override
  String get dialogActionInstall => 'Instalar';

  @override
  String get settingsDeveloperOptions => 'Opções de Desenvolvedor';

  @override
  String get devDeleteNexusInfoTitle =>
      'Excluir Todos os Arquivos nexus_info.json';

  @override
  String get devDeleteNexusInfoDesc =>
      'Remove todos os arquivos de metadados do gerenciador de cada mod. Isso é útil para forçar um reparo completo.';

  @override
  String get devExtractIdsTitle => 'Extrair Identificadores';

  @override
  String get devExtractIdsDesc =>
      'Cria um arquivo chamado \'ID Mods.json\' na sua área de trabalho contendo o displayName e o nexusId de cada mod.';

  @override
  String get devConfirmDeleteTitle => 'Confirmar Exclusão';

  @override
  String get devConfirmDeleteDesc =>
      'Tem certeza de que deseja excluir permanentemente todos os arquivos nexus_info.json? Isso removerá todos os nomes, capas e metadados personalizados. Esta ação não pode ser desfeita.';

  @override
  String get devDeleteSuccessTitle => 'Exclusão Concluída';

  @override
  String devDeleteSuccessDesc(Object count) {
    return '$count arquivos nexus_info.json excluídos com sucesso.';
  }

  @override
  String get devConfirmExtractTitle => 'Confirmar Extração';

  @override
  String get devConfirmExtractDesc =>
      'Isso verificará todos os seus mods e criará \'ID Mods.json\' na sua área de trabalho. Isso substituirá qualquer arquivo existente com o mesmo nome. Deseja continuar?';

  @override
  String get devExtractAction => 'Extrair';

  @override
  String get devExtractNoData =>
      'Nenhum mod com identificadores válidos foi encontrado para extrair.';

  @override
  String get devExtractDesktopNotFound =>
      'Erro: Não foi possível encontrar o diretório da Área de Trabalho.';

  @override
  String get devExtractSuccessTitle => 'Extração Concluída';

  @override
  String devExtractSuccessDesc(Object path) {
    return 'Arquivo criado com sucesso em: $path';
  }

  @override
  String get errorDialogTitle => 'Ocorreu um Erro';

  @override
  String get modDetailsCategory => 'Categoria';

  @override
  String get modDetailsAuthor => 'Autor';

  @override
  String get modDetailsNexusId => 'ID do Nexus';

  @override
  String get modDetailsInstalledOn => 'Instalado em';

  @override
  String get unknownAuthor => 'Desconhecido';

  @override
  String get statusInstalling => 'Instalando...';

  @override
  String statusInstallingMod(int index, int total, String modName) {
    return 'Instalando $index/$total: $modName';
  }

  @override
  String byText(Object author) {
    return 'por $author';
  }

  @override
  String get filterUpdatesAvailable => 'Atualizações disponíveis';

  @override
  String snackBarUpdateIgnored(String modName) {
    return 'Update for \'$modName\' ignored for this session.';
  }

  @override
  String snackBarVersionSkipped(String modName, String version) {
    return 'Version \'$version\' of \'$modName\' will be skipped in future checks.';
  }
}
