import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import '../l10n/app_localizations.dart';
import 'nexus_api_service.dart';
import 'download_service.dart';

enum DownloadStatus { fetching, downloading, paused, complete, error, cancelled }

class DownloadTask {
  final String id;
  final String nxmUrl;
  String fileName;
  double progress;
  String speed;
  String downloaded;
  DownloadStatus status;
  String? errorMessage;
  String? modId;
  String? version;
  File? file;
  File? targetFile; 
  final DownloadController controller = DownloadController();

  // NUEVO: Guardamos los parámetros necesarios para reintentar
  final String apiKey;
  final String linkErrorText;
  final String downloadErrorText;
  final AppLocalizations l10n; // textos localizados de estado/errores
  final Function(File, String, String) onComplete;

  /// Ya no requiere atención: terminó bien o el usuario la canceló. Las tareas
  /// con error NO cuentan como terminadas porque esperan un reintento.
  bool get isFinished =>
      status == DownloadStatus.complete || status == DownloadStatus.cancelled;

  DownloadTask({
    required this.id,
    required this.nxmUrl,
    required this.fileName,
    required this.apiKey, // <-- Añadir
    required this.linkErrorText, // <-- Añadir
    required this.downloadErrorText, // <-- Añadir
    required this.l10n,
    required this.onComplete, // <-- Añadir
    this.progress = 0.0,
    this.speed = "",
    this.downloaded = "",
    this.status = DownloadStatus.fetching,
  });
}

class DownloadManager extends ChangeNotifier {
  static final DownloadManager instance = DownloadManager._internal();
  DownloadManager._internal();

  final List<DownloadTask> activeDownloads = [];

  /// Descargas que siguen vivas (en curso, en pausa o con error pendiente).
  int get unfinishedCount => activeDownloads.where((t) => !t.isFinished).length;
  bool get hasActiveDownloads => unfinishedCount > 0;

  DownloadTask? _find(String id) {
    for (final t in activeDownloads) {
      if (t.id == id) return t;
    }
    return null;
  }

  /// Quita la tarea de la lista pasado un momento (para que la píldora pueda
  /// mostrar el check / "Cancelado" mientras haya otras descargas activas).
  void _removeLater(DownloadTask task, Duration delay) {
    Future.delayed(delay, () {
      if (activeDownloads.remove(task)) notifyListeners();
    });
  }
  bool _isUserPremium = false;
  bool get isUserPremium => _isUserPremium;

  set isUserPremium(bool value) {
    if (_isUserPremium != value) {
      _isUserPremium = value;
      notifyListeners(); // Actualiza la UI de descargas automáticamente
    }
  }

  void addDownload({
    required String nxmUrl, 
    required String apiKey, 
    required String fetchingText,
    required String linkErrorText,
    required String downloadErrorText,
    required AppLocalizations l10n,
    required Function(File, String, String) onComplete,
  }) {
    final task = DownloadTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      nxmUrl: nxmUrl,
      fileName: fetchingText,
      apiKey: apiKey,                   // <-- NUEVO
      linkErrorText: linkErrorText,     // <-- NUEVO
      downloadErrorText: downloadErrorText, // <-- NUEVO
      l10n: l10n,
      onComplete: onComplete,           // <-- NUEVO
    );
    activeDownloads.add(task);
    notifyListeners();

    // Iniciamos el flujo de descarga separando la lógica para poder reintentar
    _executeDownloadFlow(
      task: task,
      apiKey: apiKey,
      linkErrorText: linkErrorText,
      downloadErrorText: downloadErrorText,
      onComplete: onComplete,
    );
  }

  Future<void> _executeDownloadFlow({
    required DownloadTask task,
    required String apiKey,
    required String linkErrorText,
    required String downloadErrorText,
    required Function(File, String, String) onComplete,
    bool isRetry = false, 
  }) async {
    try {
      if (isRetry) {
        task.status = DownloadStatus.fetching;
        task.speed = task.l10n.downloadRefreshingLink;
        notifyListeners();
      }

      final linkData = await NexusApiService.getDownloadLinkFromNxm(task.nxmUrl, apiKey);
      if (linkData == null) {
        _updateTaskError(task, linkErrorText);
        return;
      }

      if (!isRetry) {
        String finalFileName = linkData['fileName']!;
        final String extractedModId = linkData['modId']!;
        final String extractedVersion = linkData['version']!;

        if (!finalFileName.contains('-$extractedModId-')) {
          final ext = p.extension(finalFileName);
          final nameWithoutExt = p.basenameWithoutExtension(finalFileName);
          final safeVersion = extractedVersion.replaceAll('.', '-');
          finalFileName = '$nameWithoutExt-$extractedModId-$safeVersion-0$ext';
        }

        task.fileName = finalFileName;
        task.modId = extractedModId;
        task.version = extractedVersion;

        // NUEVO: Crear un directorio temporal estable para evitar perder el progreso
        final tempDir = Directory(p.join(Directory.systemTemp.path, 'sb_control_downloads'));
        if (!await tempDir.exists()) await tempDir.create(recursive: true);
        
        task.targetFile = File(p.join(tempDir.path, task.fileName));
      }

      task.status = DownloadStatus.downloading;
      notifyListeners();

      // NUEVO: Pasamos task.targetFile! en lugar de solo el nombre
      final downloadedFile = await DownloadService.downloadFile(
        url: linkData['url']!,
        targetFile: task.targetFile!,
        controller: task.controller,
        onProgress: (progress, speed, downloadedStr) {
          if (task.status == DownloadStatus.cancelled) return;
          task.progress = progress;
          task.speed = speed;
          task.downloaded = downloadedStr;
          notifyListeners();
        },
      );

      if (task.status == DownloadStatus.cancelled || task.status == DownloadStatus.paused) return;

      if (downloadedFile != null) {
        task.progress = 1.0;
        task.status = DownloadStatus.complete;
        task.file = downloadedFile;
        // La píldora se cierra al instante si era la última descarga.
        notifyListeners();

        await Future.delayed(const Duration(milliseconds: 600));

        onComplete(downloadedFile, task.modId!, task.version!);
        _removeLater(task, const Duration(milliseconds: 1500));
      } else {
        _updateTaskError(task, downloadErrorText);
      }
    } catch (e) {
      if (task.status == DownloadStatus.cancelled || task.status == DownloadStatus.paused) return;
      final errorStr = e.toString().toLowerCase();
      final isNetworkError = errorStr.contains('socketexception') ||
                             errorStr.contains('timeout') ||
                             errorStr.contains('software caused connection abort');

      if (e is ExpiredLinkException && !isRetry) {
        print("Enlace expirado detectado. Solicitando uno nuevo a la API...");
        await _executeDownloadFlow(
          task: task,
          apiKey: apiKey,
          linkErrorText: linkErrorText,
          downloadErrorText: downloadErrorText,
          onComplete: onComplete,
          isRetry: true, 
        );
      } else if (isNetworkError) {
        // Muestra el botón de Reintentar con un mensaje claro si se cortó el internet
        _updateTaskError(task, task.l10n.downloadNoInternet);
      } else if (e is ExpiredLinkException) {
        _updateTaskError(task, task.l10n.downloadErrorLinkExpired(e.statusCode ?? 0));
      } else if (e is HttpStatusException) {
        _updateTaskError(task, task.l10n.downloadErrorHttp(e.statusCode));
      } else {
        _updateTaskError(task, e.toString());
      }
    }
  }

  void pauseTask(String id, {required String pausedText}) {
    final task = _find(id);
    if (task == null) return;
    if (task.status == DownloadStatus.downloading) {
      // 1. Cancelamos el stream para no mantener el socket abierto
      task.controller.cancel(); 
      task.status = DownloadStatus.paused;
      task.speed = pausedText; 
      notifyListeners();
    }
  }

  void resumeTask(String id) {
    final task = _find(id);
    if (task == null) return;
    if (task.status == DownloadStatus.paused) {
      task.controller.isCancelled = false; // <-- IMPORTANTE: Reactivar el controlador
      task.status = DownloadStatus.fetching;
      task.speed = task.l10n.downloadResuming;
      notifyListeners();

      // 2. Pedimos enlace fresco y usamos el Range header automático
      _executeDownloadFlow(
        task: task,
        apiKey: task.apiKey,
        linkErrorText: task.linkErrorText,
        downloadErrorText: task.downloadErrorText,
        onComplete: task.onComplete,
        isRetry: true, 
      );
    }
  }

  void cancelTask(String id) {
    final task = _find(id);
    if (task == null) return;
    task.controller.cancel();
    
    // Si el usuario cancela voluntariamente, borramos el archivo a medias para ahorrar espacio
    if (task.targetFile != null && task.targetFile!.existsSync()) {
      try {
        task.targetFile!.deleteSync();
      } catch (_) {} // Prevenir crasheos si Windows tiene bloqueado el archivo
    }

    task.status = DownloadStatus.cancelled;
    notifyListeners();
    _removeLater(task, const Duration(milliseconds: 1200));
  }

  void _updateTaskError(DownloadTask task, String error) {
    task.status = DownloadStatus.error;
    task.errorMessage = error;
    notifyListeners();
  }

  void retryTask(String id) {
    final task = _find(id);
    if (task == null) return;
    
    // Reiniciamos el estado visual
    task.status = DownloadStatus.fetching;
    task.errorMessage = null;
    task.speed = task.l10n.downloadResuming;
    notifyListeners();

    // Lanzamos el flujo indicando que es un reintento (isRetry: true)
    // Esto pedirá un enlace fresco a Nexus y usará el Range header.
    _executeDownloadFlow(
      task: task,
      apiKey: task.apiKey,
      linkErrorText: task.linkErrorText,
      downloadErrorText: task.downloadErrorText,
      onComplete: task.onComplete,
      isRetry: true, 
    );
  }
}
