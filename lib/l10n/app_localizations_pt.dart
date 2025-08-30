// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Centro de Controle CNS';

  @override
  String appTitleWithVersion(Object version) {
    return 'Custom Nanosuit System $version';
  }

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
  String get searchMods => 'Procurar mods...';

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
  String get settings => 'Configurações';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Selecione um idioma';

  @override
  String get statusSearchingGame =>
      'Procurando a instalação de Stellar Blade...';

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
    return 'Pasta \"$folderName\" selecionada. Pronto para instalar.';
  }

  @override
  String statusArchiveLoaded(Object count, Object fileName) {
    return 'Arquivo \"$fileName\" carregado. $count arquivo(s) pronto(s) para instalar.';
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
  String get dialogTitle7zip => '7-Zip é Necessário';

  @override
  String get dialogContent7zip =>
      'Para descompactar este arquivo, a aplicação precisa do 7-Zip.\n\nPor favor, instale-o a partir da sua página oficial e depois pressione \"Confirmar\".';

  @override
  String get dialogContent7zipNotFound =>
      'O 7-Zip ainda não foi detectado. Por favor, certifique-se de que está instalado no caminho padrão e tente novamente.';

  @override
  String get dialogTitleCNSUpdate =>
      'Atualização do Sistema Principal Detectada';

  @override
  String get dialogContentCNSUpdate =>
      'Foi detectada uma atualização para o \"Custom Nanosuit System\".\n\nIsto substituirá arquivos na pasta principal do jogo (StellarBlade\\SB). Deseja continuar?';

  @override
  String get dialogTitleMultipleJsons => 'Múltiplos Arquivos .json Detectados';

  @override
  String dialogContentMultipleJsons(Object count) {
    return '$count arquivos .json foram detectados. Pode ser um mod com múltiplos componentes.\n\nDeseja instalá-los todos juntos em uma única pasta de mod?';
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
  String get dialogActionUpdate => 'Atualizar';

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
  String get dropTargetOverlay => 'Arraste os mods para aqui';

  @override
  String get pathSelectionTitle => 'Caminho de Stellar Blade Não Encontrado';

  @override
  String get pathSelectionButtonManual =>
      'Selecionar Pasta do Jogo Manualmente';

  @override
  String get pathSelectionButtonRetry => 'Tentar Novamente';

  @override
  String errorFolderSelection(Object error) {
    return 'Erro ao selecionar pasta: $error';
  }

  @override
  String errorFileSelection(Object error) {
    return 'Erro ao selecionar arquivos: $error';
  }

  @override
  String errorDecompressing(Object error) {
    return 'Erro ao descompactar arquivo: $error';
  }

  @override
  String errorProcessingArchive(Object error) {
    return 'Erro ao processar arquivo: $error';
  }

  @override
  String errorUnsupportedFormat(Object extension) {
    return 'Formato de arquivo não suportado: $extension';
  }

  @override
  String get error7zipRequired => 'Operação cancelada: 7-Zip é necessário.';

  @override
  String get errorGamePathUndefined => 'Caminho do jogo não definido.';

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
  String get errorInstallModExists => 'Instalação cancelada: O mod já existe.';

  @override
  String get errorNoJsonFound =>
      'Cada mod deve conter pelo menos um arquivo .json.';

  @override
  String errorInvalidJsonFormat(Object fileName) {
    return 'O arquivo $fileName tem um formato JSON inválido.';
  }

  @override
  String errorNoDisplayName(Object fileName) {
    return 'O ficheiro $fileName não parece ser um mod do Custom Nanosuit System (falta \"DisplayName\").';
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
      'A seleção não contém um arquivo .json de mod válido.';

  @override
  String get aboutTitle => 'Sobre o CNS Control Center';

  @override
  String get aboutContent =>
      'Esta aplicação é um gerenciador de mods para Stellar Blade, projetado para funcionar com o Custom Nanosuit System (CNS).\n\nRequisito: Para funcionalidade completa com arquivos .rar e .7z, o 7-Zip deve estar instalado no seu sistema.';

  @override
  String get aboutLinkText => 'Visite o perfil do meu criador';

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
      '1. Vá para o Nexus Mods e faça login.\n2. Clique no seu avatar e vá para \'Site preferences\'.\n3. Vá para a guia \'API\'.\n4. Clique em \'Generate a new API key\'.\n5. Copie a chave e cole-a aqui.';

  @override
  String get apiKey => 'Chave de API';

  @override
  String get apiKeyHintText => 'Cole sua chave de API aqui';

  @override
  String get dialogActionSave => 'Salvar';

  @override
  String get snackBarApiKeySaved => 'Chave de API salva com sucesso.';

  @override
  String get apiKeyRemoved => 'Chave de API removida.';

  @override
  String get invalidApiKeyError => 'Chave de API inválida.';

  @override
  String get validatingApiKey => 'Validando...';

  @override
  String get errorApiKeyMissing =>
      'A chave de API do Nexus Mods não está configurada. Por favor, adicione-a através do ícone de chave na barra superior.';

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
      'Nenhuma imagem foi encontrada para este mod, ou a chave de API não foi inserida. Por favor, insira a chave e verifique as atualizações depois.';

  @override
  String errorFetchingImages(Object error) {
    return 'Erro ao buscar imagens: $error';
  }

  @override
  String get imageMod => 'Imagem do Mod';

  @override
  String get dialogContentUpdateOptions => 'O que você gostaria de fazer?';

  @override
  String get dialogActionIgnoreVersion => 'Ignorar Versão';

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
  String get sortByName => 'Nome';

  @override
  String get sortByDate => 'Data';

  @override
  String get noModsFound => 'Nenhum mod encontrado.';

  @override
  String statusExtractingMultipleFiles(
    Object count,
    Object fileName,
    Object total,
  ) {
    return 'Extraindo $count de $total: $fileName';
  }

  @override
  String get previewInstallTitle => 'Mods a serem Instalados:';

  @override
  String get dialogTitleUE4SS => 'Instalação de UE4SS Detectada';

  @override
  String get dialogContentUE4SS =>
      'A ferramenta UE4SS foi detectada. Deseja instalá-la em \'StellarBlade\\SB\\Binaries\\Win64\'?\n\nIsso é necessário para que muitos mods funcionem.';

  @override
  String get dialogActionInstallTool => 'Instalar Ferramenta';

  @override
  String get statusUE4SSInstallCancelled => 'Instalação de UE4SS cancelada.';

  @override
  String get statusInstallingUE4SS => 'Instalando UE4SS...';

  @override
  String get snackBarUE4SSInstalled => 'UE4SS instalado com sucesso.';

  @override
  String error7zipDecompression(Object error) {
    return 'Erro do 7-Zip durante a descompressão: $error';
  }

  @override
  String get statusUE4SSInstallComplete => 'Instalação de UE4SS concluída.';

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
    return 'Aviso: Você está prestes a instalar uma versão mais antiga do mod \'$modName\'.\n\nVersão instalada: $oldVersion\nVersão a instalar: $newVersion';
  }

  @override
  String get dialogActionDowngrade => 'Downgrade';

  @override
  String get dialogTitleReinstall => 'Reinstalar Mod';

  @override
  String dialogContentReinstall(Object modName, Object version) {
    return 'Você está prestes a reinstalar a versão \'$version\' do mod \'$modName\'.';
  }

  @override
  String get dialogActionReinstall => 'Reinstalar';
}
