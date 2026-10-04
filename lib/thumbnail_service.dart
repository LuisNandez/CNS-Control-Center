// Un servicio optimizado para cargar, cachear y comprimir imágenes. Lo más importante aquí es que utiliza Isolates (compute) 
//para que la decodificación y redimensionamiento de las portadas se haga en un hilo secundario y no congele la interfaz de
// la aplicación.

import 'dart:async';
import 'dart:collection';
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


// --- LIMITADOR DE TRABAJO PESADO ---
//
// Sin límite, al hacer scroll rápido por una lista con muchas portadas sin
// miniatura se lanzaban decenas de isolates y descargas a la vez, y la
// aplicación se quedaba a tirones. Con esto solo se procesan unas pocas a la
// vez, y las más recientes (las que el usuario está viendo ahora) pasan
// primero.
class _TaskGate {
  _TaskGate(this.limit);

  final int limit;
  int _running = 0;
  final Queue<Completer<void>> _waiters = Queue<Completer<void>>();

  Future<T> run<T>(Future<T> Function() task) async {
    if (_running < limit) {
      _running++;
    } else {
      final waiter = Completer<void>();
      _waiters.addLast(waiter);
      await waiter.future; // el hueco se traspasa tal cual (no se recuenta)
    }
    try {
      return await task();
    } finally {
      if (_waiters.isNotEmpty) {
        // LIFO: la última petición suele ser la que está en pantalla.
        _waiters.removeLast().complete();
      } else {
        _running--;
      }
    }
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

  /// Peticiones en curso por clave: si dos tarjetas piden la misma portada a
  /// la vez (p. ej. al cambiar de cuadrícula a lista) se comparte el trabajo.
  final Map<String, Future<File?>> _inFlight = {};

  /// Máximo de portadas descargándose / comprimiéndose a la vez.
  final _TaskGate _gate = _TaskGate(2);

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
      // 1. Prepara los datos para enviar
      final request = _ProcessImageRequest(
        originalPath: originalFile.absolute.path,
        thumbnailPath: thumbnailFile.absolute.path,
      );

      // 2. Llama a 'compute' para ejecutar _processImageIsolate en un hilo separado
      final File? resultFile = await compute(_processImageIsolate, request);

      // 3. 'compute' ha terminado, recibimos el resultado
      if (resultFile != null) {
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

  Future<File?> getThumbnail(
    String cacheKey,
    String sourcePath, {
    bool isLocalFile = false,
  }) {
    final File? cached = _inMemoryCache[cacheKey];
    if (cached != null) return Future<File?>.value(cached);

    final Future<File?>? running = _inFlight[cacheKey];
    if (running != null) return running;

    final Future<File?> future = _getThumbnailImpl(
      cacheKey,
      sourcePath,
      isLocalFile: isLocalFile,
    );
    _inFlight[cacheKey] = future;
    // .ignore(): el error (si lo hay) le llega a quien espera `future`.
    future.whenComplete(() => _inFlight.remove(cacheKey)).ignore();
    return future;
  }

  Future<File?> _getThumbnailImpl(
    String cacheKey,
    String sourcePath, {
    bool isLocalFile = false,
  }) async {
    if (!_isInitialized) await initialize();
    if (_thumbnailCacheDir == null) return null;

    final String logName = p.basename(sourcePath);

    // Nombres de archivo (usando la cacheKey)
    final hashedName = _getHashedFileName(cacheKey);
    final thumbnailFile =
        File(p.join(_thumbnailCacheDir!.path, '$hashedName.jpg'));

    // 2. Revisar caché en disco (thumbnail) (usando la cacheKey)
    if (await thumbnailFile.exists()) {
      _inMemoryCache[cacheKey] = thumbnailFile;
      return thumbnailFile;
    }

    // 3 y 4 (descargar + comprimir) es lo pesado: se hace de pocas en pocas.
    return _gate.run(
      () => _createThumbnail(
        cacheKey,
        sourcePath,
        thumbnailFile,
        hashedName,
        logName,
        isLocalFile,
      ),
    );
  }

  Future<File?> _createThumbnail(
    String cacheKey,
    String sourcePath,
    File thumbnailFile,
    String hashedName,
    String logName,
    bool isLocalFile,
  ) async {
    // Mientras esperaba su turno otra petición pudo dejarla ya lista.
    final File? alreadyThere = _inMemoryCache[cacheKey];
    if (alreadyThere != null) return alreadyThere;
    if (await thumbnailFile.exists()) {
      _inMemoryCache[cacheKey] = thumbnailFile;
      return thumbnailFile;
    }

    // 3. No hay thumbnail. Necesitamos el original.
    File? fileToProcess;

    if (isLocalFile) {
      // 3a. Es un archivo local.
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
        fileToProcess = originalFile;
      } else {
        try {
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