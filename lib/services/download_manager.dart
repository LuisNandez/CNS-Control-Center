import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'nexus_api_service.dart';
import 'download_service.dart';

enum DownloadStatus { fetching, downloading, complete, error }

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

  DownloadTask({
    required this.id,
    required this.nxmUrl,
    this.fileName = "Obteniendo...",
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
  bool get hasActiveDownloads => activeDownloads.isNotEmpty;

  void addDownload(String nxmUrl, String apiKey, Function(File, String, String) onComplete) async {
    final task = DownloadTask(id: DateTime.now().millisecondsSinceEpoch.toString(), nxmUrl: nxmUrl);
    activeDownloads.add(task);
    notifyListeners();

    try {
      final linkData = await NexusApiService.getDownloadLinkFromNxm(nxmUrl, apiKey);
      if (linkData == null) {
        _updateTaskError(task, "No se pudo obtener el enlace");
        return;
      }

      String finalFileName = linkData['fileName']!;
      final String extractedModId = linkData['modId']!;
      final String extractedVersion = linkData['version']!;

      // --- AQUÍ INTEGRAMOS TU LÓGICA DE REESTRUCTURACIÓN DE NOMBRE ---
      // Si el nombre original no contiene el ID del mod, construimos el nombre perfecto
      if (!finalFileName.contains('-$extractedModId-')) {
        final ext = p.extension(finalFileName);
        final nameWithoutExt = p.basenameWithoutExtension(finalFileName);
        final safeVersion = extractedVersion.replaceAll('.', '-');
        
        // Añadimos "-1-0" o "-0" al final para que ArchiveService detecte
        // la versión y valide la expresión regular perfectamente.
        finalFileName = '$nameWithoutExt-$extractedModId-$safeVersion-0$ext';
      }

      task.fileName = finalFileName;
      task.modId = extractedModId;
      task.version = extractedVersion;
      task.status = DownloadStatus.downloading;
      notifyListeners();

      // Pasamos el finalFileName ya corregido al DownloadService
      final downloadedFile = await DownloadService.downloadFile(
        url: linkData['url']!,
        fileName: task.fileName, 
        onProgress: (progress, speed, downloadedStr) {
          task.progress = progress;
          task.speed = speed;
          task.downloaded = downloadedStr;
          notifyListeners();
        },
      );

      if (downloadedFile != null) {
        task.status = DownloadStatus.complete;
        task.file = downloadedFile;
        notifyListeners();
        
        onComplete(downloadedFile, task.modId!, task.version!);
        Future.delayed(const Duration(seconds: 3), () {
          activeDownloads.remove(task);
          notifyListeners();
        });
      } else {
        _updateTaskError(task, "Error en la descarga");
      }
    } catch (e) {
      _updateTaskError(task, e.toString());
    }
  }

  void _updateTaskError(DownloadTask task, String error) {
    task.status = DownloadStatus.error;
    task.errorMessage = error;
    notifyListeners();
    // Remover la tarea fallida después de unos segundos
    Future.delayed(const Duration(seconds: 5), () {
      activeDownloads.remove(task);
      notifyListeners();
    });
  }
}