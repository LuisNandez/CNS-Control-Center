import 'dart:io';
import 'dart:async';
import 'package:path/path.dart' as p;

class DownloadService {
  /// Descarga un archivo desde una URL y reporta el progreso.
  static Future<File?> downloadFile({
    required String url,
    required String fileName,
    required Function(double progress, String speed, String downloadedStr) onProgress,
  }) async {
    try {
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();

      if (response.statusCode != 200) {
        throw Exception('Error HTTP: ${response.statusCode}');
      }

      final totalBytes = response.contentLength;
      int receivedBytes = 0;

      // Usamos un directorio temporal del sistema para la descarga parcial
      final tempDir = Directory.systemTemp.createTempSync('sb_downloads_');
      final file = File(p.join(tempDir.path, fileName));
      final sink = file.openWrite();

      final stopwatch = Stopwatch()..start();
      int lastBytes = 0;

      await for (var chunk in response) {
        receivedBytes += chunk.length;
        sink.add(chunk);

        if (totalBytes > 0) {
          final elapsed = stopwatch.elapsedMilliseconds;
          // Actualizar la UI cada 300ms para no saturar el hilo principal
          if (elapsed > 300) {
            final speedBps = ((receivedBytes - lastBytes) / (elapsed / 1000)).round();
            final speedStr = '${(speedBps / 1024 / 1024).toStringAsFixed(2)} MB/s';
            final downloadedStr = '${(receivedBytes / 1024 / 1024).toStringAsFixed(2)} / ${(totalBytes / 1024 / 1024).toStringAsFixed(2)} MB';

            onProgress(receivedBytes / totalBytes, speedStr, downloadedStr);

            stopwatch.reset();
            lastBytes = receivedBytes;
          }
        }
      }

      await sink.close();
      return file;
    } catch (e) {
      print("Error en la descarga: $e");
      return null;
    }
  }
}