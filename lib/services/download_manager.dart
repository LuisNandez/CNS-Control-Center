import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
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
  final DownloadController controller = DownloadController();

  DownloadTask({
    required this.id,
    required this.nxmUrl,
    required this.fileName,
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

  void addDownload({
    required String nxmUrl, 
    required String apiKey, 
    required String fetchingText,
    required String linkErrorText,
    required String downloadErrorText,
    required Function(File, String, String) onComplete,
  }) async {
    final task = DownloadTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      nxmUrl: nxmUrl,
      fileName: fetchingText,
    );
    activeDownloads.add(task);
    notifyListeners();

    try {
      final linkData = await NexusApiService.getDownloadLinkFromNxm(nxmUrl, apiKey);
      if (linkData == null) {
        _updateTaskError(task, linkErrorText);
        return;
      }

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
      task.status = DownloadStatus.downloading;
      notifyListeners();

      final downloadedFile = await DownloadService.downloadFile(
        url: linkData['url']!,
        fileName: task.fileName,
        controller: task.controller,
        onProgress: (progress, speed, downloadedStr) {
          if (task.status == DownloadStatus.cancelled) return;
          task.progress = progress;
          task.speed = speed;
          task.downloaded = downloadedStr;
          notifyListeners();
        },
      );

      if (task.status == DownloadStatus.cancelled) return;

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
        _updateTaskError(task, downloadErrorText);
      }
    } catch (e) {
      if (task.status != DownloadStatus.cancelled) {
        _updateTaskError(task, e.toString());
      }
    }
  }

  void pauseTask(String id, {required String pausedText}) {
    final task = activeDownloads.firstWhere((t) => t.id == id);
    if (task.status == DownloadStatus.downloading) {
      task.controller.pause();
      task.status = DownloadStatus.paused;
      task.speed = pausedText; // Usamos el texto localizado
      notifyListeners();
    }
  }

  void resumeTask(String id) {
    final task = activeDownloads.firstWhere((t) => t.id == id);
    if (task.status == DownloadStatus.paused) {
      task.controller.resume();
      task.status = DownloadStatus.downloading;
      notifyListeners();
    }
  }

  void cancelTask(String id) {
    final task = activeDownloads.firstWhere((t) => t.id == id);
    task.controller.cancel();
    task.status = DownloadStatus.cancelled;
    notifyListeners();
    Future.delayed(const Duration(seconds: 2), () {
      activeDownloads.remove(task);
      notifyListeners();
    });
  }

  void _updateTaskError(DownloadTask task, String error) {
    task.status = DownloadStatus.error;
    task.errorMessage = error;
    notifyListeners();
    Future.delayed(const Duration(seconds: 5), () {
      activeDownloads.remove(task);
      notifyListeners();
    });
  }
}