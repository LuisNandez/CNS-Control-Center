import 'dart:io';
import 'dart:async';

class ExpiredLinkException implements Exception {
  final String message;
  final int? statusCode;
  ExpiredLinkException(this.message, {this.statusCode});
  @override
  String toString() => message;
}

/// Respuesta HTTP inesperada. El texto visible se genera en la UI con
/// l10n.downloadErrorHttp(statusCode).
class HttpStatusException implements Exception {
  final int statusCode;
  HttpStatusException(this.statusCode);
  @override
  String toString() => 'HTTP error: $statusCode';
}

class DownloadController {
  StreamSubscription<List<int>>? subscription;
  bool isCancelled = false;
  Function()? onCancel;

  void pause() => subscription?.pause();
  void resume() => subscription?.resume();
  void cancel() {
    isCancelled = true;
    subscription?.cancel();
    onCancel?.call();
  }
}

class DownloadService {
  /// Descarga un archivo desde una URL y reporta el progreso, soportando pausa, reanudación nativa y cancelación.
  static Future<File?> downloadFile({
    required String url,
    required File targetFile, // AHORA RECIBE EL ARCHIVO DIRECTAMENTE
    required Function(double progress, String speed, String downloadedStr) onProgress,
    DownloadController? controller,
  }) async {
    try {
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse(url));

      // 1. Verificamos si ya tenemos una parte del archivo en el disco
      int existingBytes = 0;
      if (await targetFile.exists()) {
        existingBytes = await targetFile.length();
        if (existingBytes > 0) {
          // Solicitamos al servidor que empiece desde el byte que nos falta
          request.headers.add(HttpHeaders.rangeHeader, 'bytes=$existingBytes-');
        }
      }

      final response = await request.close();

      // 2. Manejo de enlace expirado (clave para el flujo del Manager)
      if (response.statusCode == 403 || response.statusCode == 410) {
        throw ExpiredLinkException(
          'Nexus link expired (${response.statusCode})',
          statusCode: response.statusCode,
        );
      }

      if (response.statusCode != 200 && response.statusCode != 206 && response.statusCode != 416) {
        throw HttpStatusException(response.statusCode);
      }

      // 3. Determinar el comportamiento según la respuesta del servidor
      bool isAppending = response.statusCode == 206; // 206 significa que aceptó el Range
      int totalBytes = response.contentLength;

      if (isAppending) {
        totalBytes += existingBytes; // El peso total es lo que ya teníamos + lo que enviará
      } else if (response.statusCode == 200) {
        existingBytes = 0; // El servidor ignoró el Range (no lo soporta), toca empezar de cero
      } else if (response.statusCode == 416) {
        // 416 (Range Not Satisfiable) suele significar que el archivo ya se descargó completo
        return targetFile; 
      }

      int receivedBytes = existingBytes;
      
      // Abrimos el archivo en modo "append" si estamos reanudando, o "write" si empezamos de cero
      final sink = targetFile.openWrite(mode: isAppending ? FileMode.append : FileMode.write);

      final stopwatch = Stopwatch()..start();
      int lastBytesForSpeed = receivedBytes;
      final completer = Completer<File?>();

      controller?.onCancel = () async {
        await sink.close();
        // IMPORTANTE: NO borramos el archivo aquí. Así permitimos reanudar luego.
        if (!completer.isCompleted) completer.complete(null);
      };

      controller?.subscription = response.timeout(
        const Duration(seconds: 15),
        onTimeout: (sink) {
          // Si pasan 15 segundos sin recibir ni un byte, forzamos un corte
          sink.addError(const SocketException("Timeout: no network data received"));
        },
      ).listen(
        (chunk) {
          if (controller?.isCancelled ?? false) return;

          receivedBytes += chunk.length;
          sink.add(chunk);

          if (totalBytes > 0) {
            final elapsed = stopwatch.elapsedMilliseconds;
            if (elapsed > 300) {
              // La velocidad se calcula solo con lo descargado en esta sesión, no con los bytes totales
              final speedBps = ((receivedBytes - lastBytesForSpeed) / (elapsed / 1000)).round();
              final speedStr = '${(speedBps / 1024 / 1024).toStringAsFixed(2)} MB/s';
              final downloadedStr = '${(receivedBytes / 1024 / 1024).toStringAsFixed(2)} / ${(totalBytes / 1024 / 1024).toStringAsFixed(2)} MB';

              onProgress(receivedBytes / totalBytes, speedStr, downloadedStr);

              stopwatch.reset();
              lastBytesForSpeed = receivedBytes;
            }
          }
        },
        onDone: () async {
          if (controller?.isCancelled ?? false) return;
          await sink.close();

          if (totalBytes > 0) {
             final finalStr = '${(totalBytes / 1024 / 1024).toStringAsFixed(2)} / ${(totalBytes / 1024 / 1024).toStringAsFixed(2)} MB';
             onProgress(1.0, '0 MB/s', finalStr);
          }

          if (!completer.isCompleted) completer.complete(targetFile);
        },
        onError: (e) async {
          print("Error en el stream de descarga: $e");
          await sink.close();
          if (!completer.isCompleted) completer.completeError(e);
        },
        cancelOnError: true,
      );

      return await completer.future;
    } catch (e) {
      if (e is ExpiredLinkException) rethrow; // Pasamos la excepción al Manager
      print("Error general en la descarga: $e");
      return null;
    }
  }
}
