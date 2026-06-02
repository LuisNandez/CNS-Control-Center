// Un servicio optimizado para cargar, cachear y comprimir imágenes. Lo más importante aquí es que utiliza Isolates (compute) 
//para que la decodificación y redimensionamiento de las portadas se haga en un hilo secundario y no congele la interfaz de
// la aplicación.

import 'dart:io';
import 'dart:convert';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
// ++ AÑADIDO: Import para 'compute' (Isolates) ++
import 'package:flutter/foundation.dart';


// ++ AÑADIDO: Clase de ayuda para pasar datos al Isolate ++
// (Debe estar fuera de la clase ThumbnailService)
class _ProcessImageRequest {
  final String originalPath;
  final String thumbnailPath;

  _ProcessImageRequest({required this.originalPath, required this.thumbnailPath});
}

// ++ NUEVO: El "Decodificador Inteligente" (AHORA FUERA de la clase) ++
// (Debe ser una función de nivel superior o estática para usarla en un Isolate)
img.Image? _smartDecodeIsolate(Uint8List bytes) {
  try {
    img.Image? image = img.decodeImage(bytes);
    if (image != null) return image;
  } catch (e) { /* Falló auto-detección */ }

  print("... [ISOLATE] Auto-detección falló, probando específicos ...");

  try {
    img.Image? image = img.decodeJpg(bytes);
    if (image != null) {
      print("... [ISOLATE] ¡Decodificado como JPEG!");
      return image;
    }
  } catch (e) { /* No es JPEG */ }

  try {
    img.Image? image = img.decodePng(bytes);
    if (image != null) {
      print("... [ISOLATE] ¡Decodificado como PNG!");
      return image;
    }
  } catch (e) { /* No es PNG */ }

  try {
    img.Image? image = img.decodeWebP(bytes);
    if (image != null) {
      print("... [ISOLATE] ¡Decodificado como WebP!");
      return image;
    }
  } catch (e) { /* No es WebP */ }
  
  return null;
}

// ++ NUEVO: La función de procesamiento (AHORA FUERA de la clase) ++
// Esta es la función pesada que se ejecutará en el Isolate.
Future<File?> _processImageIsolate(_ProcessImageRequest request) async {
  try {
    const int minHeight = 400;
    final File originalFile = File(request.originalPath);
    final File thumbnailFile = File(request.thumbnailPath);

    final Uint8List originalBytes = await originalFile.readAsBytes();

    // 2. Decodificar usando el decodificador inteligente
    img.Image? image = _smartDecodeIsolate(originalBytes);

    if (image == null) {
      print("⚠️ [ISOLATE] No se pudo decodificar la imagen (TODOS los formatos fallaron): ${originalFile.path}");
      return null;
    }

    // 3. Reescalar
    if (image.height > minHeight) {
      image = img.copyResize(image, height: minHeight);
    }

    // 4. Codificar como JPEG
    final Uint8List processedBytes = img.encodeJpg(image, quality: 85);

    // 5. Escribir el nuevo archivo
    await thumbnailFile.writeAsBytes(processedBytes);

    // Devuelve el archivo exitoso. El 'print' lo haremos en el hilo principal.
    return thumbnailFile;
  } catch (e, s) {
    // Este print SÍ se mostrará en la consola de debug
    print("====================================================");
    print("🛑 ERROR FATAL EN ISOLATE DE PROCESAMIENTO 🛑");
    print("Archivo: ${request.originalPath}");
    print("Error: $e");
    print("Stack Trace: $s");
    print("====================================================");
    return null;
  }
}


// --- CLASE PRINCIPAL DEL SERVICIO ---

class ThumbnailService {
  static final ThumbnailService _instance = ThumbnailService._internal();
  factory ThumbnailService() => _instance;
  ThumbnailService._internal();

  Directory? _imageCacheDir;
  Directory? _thumbnailCacheDir;
  bool _isInitialized = false;

  final Map<String, File> _inMemoryCache = {};

  Future<void> initialize() async {
    // ... (Esta función initialize() no cambia)
    if (_isInitialized) return;
    try {
      final appDir = await getApplicationSupportDirectory();

      _imageCacheDir = Directory(p.join(appDir.path, 'image_cache'));
      if (!await _imageCacheDir!.exists()) {
        await _imageCacheDir!.create(recursive: true);
      }

      _thumbnailCacheDir = Directory(p.join(appDir.path, 'thumbnail_cache'));
      if (!await _thumbnailCacheDir!.exists()) {
        await _thumbnailCacheDir!.create(recursive: true);
      }

      print("--- CACHÉ DE MINIATURAS EN: ${_thumbnailCacheDir!.path} ---");

      _isInitialized = true;
    } catch (e) {
      print("Failed to initialize ThumbnailService directories: $e");
    }
  }

  File? getFromMemoryCache(String key) {
    return _inMemoryCache[key];
  }

  String _getHashedFileName(String key) {
    final bytes = utf8.encode(key);
    final digest = sha1.convert(bytes);
    return '$digest';
  }

  // ++ MODIFICADO: _processImage AHORA usa 'compute' ++
  // Esta función ahora es súper ligera, solo "envía" el trabajo al Isolate.
  Future<File?> _processImage(
    File originalFile,
    File thumbnailFile,
  ) async {
    try {
      print("⚡ Enviando a ISOLATE para compresión: ${p.basename(originalFile.path)}");

      // 1. Prepara los datos para enviar
      final request = _ProcessImageRequest(
        originalPath: originalFile.absolute.path,
        thumbnailPath: thumbnailFile.absolute.path,
      );

      // 2. Llama a 'compute' para ejecutar _processImageIsolate en un hilo separado
      final File? resultFile = await compute(_processImageIsolate, request);

      // 3. 'compute' ha terminado, recibimos el resultado
      if (resultFile != null) {
        print("👍 Compresión (en Isolate) exitosa: ${p.basename(resultFile.path)}");
        return resultFile;
      } else {
        print("⚠️ Compresión (en Isolate) falló para: ${p.basename(originalFile.path)}");
        return null;
      }
    } catch (e) {
      print("🛑 ERROR al *llamar* al Isolate: $e");
      return null;
    }
  }

  // ... (Esta función getThumbnail() no cambia)
  Future<File?> getThumbnail(
    String cacheKey,
    String sourcePath, {
    bool isLocalFile = false,
  }) async {
    if (!_isInitialized) await initialize();
    if (_thumbnailCacheDir == null) return null;

    final String logName = p.basename(sourcePath);

    // 1. Revisar caché en memoria (usando la cacheKey)
    if (_inMemoryCache.containsKey(cacheKey)) {
      print("✅ CACHÉ MEMORIA (Rápido): $logName");
      return _inMemoryCache[cacheKey];
    }

    // Nombres de archivo (usando la cacheKey)
    final hashedName = _getHashedFileName(cacheKey);
    final thumbnailFile =
        File(p.join(_thumbnailCacheDir!.path, '$hashedName.jpg'));

    // 2. Revisar caché en disco (thumbnail) (usando la cacheKey)
    if (await thumbnailFile.exists()) {
      print("📀 CACHÉ DISCO THUMBNAIL (Procesada): $logName");
      _inMemoryCache[cacheKey] = thumbnailFile;
      return thumbnailFile;
    }

    // 3. No hay thumbnail. Necesitamos el original.
    File? fileToProcess;

    if (isLocalFile) {
      // 3a. Es un archivo local.
      print("⚙️ PROCESANDO (Desde Archivo Local): $logName");
      // ++ CORREGIDO: Usa sourcePath para encontrar el archivo ++
      final localFile = File(sourcePath);
      if (await localFile.exists()) {
        fileToProcess = localFile;
      } else {
        print("⚠️ Archivo local no encontrado: $sourcePath");
        return null;
      }
    } else {
      // 3b. Es una URL de red.
      if (_imageCacheDir == null) return null;
      // ++ CORREGIDO: Usa sourcePath para obtener la extensión ++
      final originalExtension =
          p.extension(sourcePath).isNotEmpty ? p.extension(sourcePath) : '.jpg';
      final originalFile = File(
          p.join(_imageCacheDir!.path, '$hashedName$originalExtension'));

      if (await originalFile.exists()) {
        print("⚙️ PROCESANDO (Desde Original en disco): $logName");
        fileToProcess = originalFile;
      } else {
        try {
          print("🌍 DESCARGANDO Y PROCESANDO (Red): $logName");
          // ++ CORREGIDO: Usa sourcePath para descargar ++
          final response = await http.get(Uri.parse(sourcePath));
          if (response.statusCode == 200) {
            await originalFile.writeAsBytes(response.bodyBytes);
            fileToProcess = originalFile;
          } else {
            print(
                "Failed to download image from $sourcePath. Status: ${response.statusCode}");
            return null;
          }
        } catch (e) {
          print("Error downloading image from $sourcePath: $e");
          return null;
        }
      }
    }

    // 4. Procesar el original
    if (fileToProcess != null) {
      // Esta llamada ahora NO bloquea la UI
      final processedFile = await _processImage(fileToProcess, thumbnailFile);

      if (processedFile != null) {
        // --- ÉXITO ---
        print("👍 Usando miniatura procesada para: $logName");
        // ++ CORREGIDO: Almacena en caché usando la cacheKey ++
        _inMemoryCache[cacheKey] = processedFile;
        return processedFile;
      } else {
        // --- ¡¡FALLBACK!! ---
        print("⚠️ Fallback: Usando imagen original (sin procesar) para: $logName");
        // ++ CORREGIDO: Almacena en caché usando la cacheKey ++
        _inMemoryCache[cacheKey] = fileToProcess;
        return fileToProcess;
      }
    }

    return null;
  }
}