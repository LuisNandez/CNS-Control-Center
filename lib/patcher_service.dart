// Contiene la lógica profunda para solucionar conflictos entre mods (archivos .ucas/.utoc). Se encarga de buscar secuencias de
// bytes problemáticas (Container IDs y Package IDs duplicados) y reescribirlas para evitar crashes en el juego.

// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math'; // Importamos 'math' para Random
import 'dart:typed_data';
import 'package:path/path.dart' as p;
import 'l10n/app_localizations.dart';

enum LogEntryType { normal, success, error, info }

class LogEntry {
  final String text;
  final LogEntryType type;
  LogEntry(this.text, [this.type = LogEntryType.normal]);
}

// Usamos una clase para encapsular la lógica, tal como lo hacía el script de Python.
class PatcherResult {
  /// El log de texto completo para depuración.
  final List<LogEntry> logEntries;
  
  /// Cuántos conflictos de Container ID se corrigieron.
  final int containerIdsFixed;
  
  /// Un mapa de todos los conflictos de Package ID encontrados.
  /// La clave (int) es el ID del paquete, el valor (List<String>) es la lista de mods en conflicto.
  final Map<int, List<String>> packageIdConflicts;

  PatcherResult({
    required this.logEntries,
    required this.containerIdsFixed,
    required this.packageIdConflicts,
  });
}

class PatcherService {
  final List<int> _containerIds = [];
  final Map<int, List<String>> _packageIds = {};
  final List<LogEntry> _logEntries = [];
  // final Uuid _uuid = const Uuid(); // Ya no se usa
  
  // ++ USAMOS Random.secure() en lugar de UUID ++
  final Random _random = Random.secure(); 

  final AppLocalizations l10n;
  PatcherService(this.l10n);

  // Esta es la función principal que llamarás desde main.dart
  Future<PatcherResult> patchConflictsInDirectory(String modsDirectoryPath) {
    // Usamos un try-catch para devolver el log, ya sea de éxito o de error.
    // Observa que ahora devuelve un Future<PatcherResult>
    return _safeRun(() async {
      _logEntries.add(LogEntry(l10n.patcherStarted));
      _logEntries.add(LogEntry(l10n.workingDirectory(modsDirectoryPath)));

      final dir = Directory(modsDirectoryPath);
      if (!await dir.exists()) {
        throw Exception(l10n.modsDirNotFound(modsDirectoryPath));
      }

      final List<File> utocFiles = [];

      Future<void> findUtocFiles(Directory currentDir) async {
        try {
          await for (final entity
              in currentDir.list(recursive: false, followLinks: false)) {
            if (entity is File && entity.path.toLowerCase().endsWith('.utoc')) {
              utocFiles.add(entity);
            } else if (entity is Directory) {
              await findUtocFiles(entity);
            }
          }
        } catch (e) {
          _logEntries.add(LogEntry(
              l10n.warnCannotScanFolder(currentDir.path), LogEntryType.error));
          _logEntries.add(
              LogEntry(l10n.errorDetails(e.toString()), LogEntryType.error));
        }
      }

      await findUtocFiles(dir);

      _logEntries.add(LogEntry(l10n.foundUtocFiles(utocFiles.length)));
      if (utocFiles.isEmpty) {
        _logEntries.add(LogEntry(l10n.noModsFound2));
        // Devolvemos un resultado vacío
        return PatcherResult(
          // -- MODIFICADO: --
          logEntries: _logEntries,
          containerIdsFixed: 0,
          packageIdConflicts: {},
        );
      }

      int fixedContainerIdCount = 0;
      
      // 1. Procesar todos los archivos .utoc
      for (final utocFile in utocFiles) {
        final fixed = await _parseUtoc(utocFile);
        if (fixed) {
          fixedContainerIdCount++;
        }
      }

      // 2. Filtrar solo los conflictos de PackageId
      final Map<int, List<String>> allPackageIdConflicts = {};
      _packageIds.forEach((id, mods) {
        if (mods.length > 1) {
          allPackageIdConflicts[id] = mods;
        }
      });

      // 3. Escribir el resumen final en el log (PARA EL LOG COMPLETO)
      _logEntries.add(LogEntry(l10n.patcherSummaryTitle));
      _logEntries.add(LogEntry(l10n.processedMods(utocFiles.length)));
      _logEntries.add(
          LogEntry(l10n.fixedContainerIdConflicts(fixedContainerIdCount)));
      _logEntries.add(
          LogEntry(l10n.foundPackageIdConflicts(allPackageIdConflicts.length)));

      // 4. Devolver el objeto PatcherResult estructurado
      return PatcherResult(
        logEntries: _logEntries,
        containerIdsFixed: fixedContainerIdCount,
        packageIdConflicts: allPackageIdConflicts,
      );
    });
  }

  /// Envoltorio de seguridad para asegurar que siempre devolvemos un log.
  Future<PatcherResult> _safeRun(Future<PatcherResult> Function() action) async {
    try {
      return await action();
    } catch (e, s) {
      _logEntries.add(LogEntry(l10n.fatalErrorTitle, LogEntryType.error));
      _logEntries.add(LogEntry(e.toString(), LogEntryType.error));
      _logEntries.add(LogEntry(s.toString(), LogEntryType.error));
      print(l10n.patcherServiceError(e.toString()));
      // Devolver un PatcherResult con el log de error
      return PatcherResult(
        logEntries: _logEntries,
        containerIdsFixed: 0,
        packageIdConflicts: {},
      );
    }
  }

  /// Genera un nuevo ID de 64 bits (traducción de `generate_u64_id`)
  // ++ FUNCIÓN CORREGIDA (Usa Random.secure en lugar de UUID) ++
  int _generateU64Id() {
    // Genera 8 bytes aleatorios
    final ByteData byteData = ByteData(8);
    byteData.setUint32(0, _random.nextInt(0xFFFFFFFF));
    byteData.setUint32(4, _random.nextInt(0xFFFFFFFF));
    int newId = byteData.getUint64(0, Endian.little);

    // Asegura que no esté duplicado
    while (_containerIds.contains(newId)) {
      byteData.setUint32(0, _random.nextInt(0xFFFFFFFF));
      byteData.setUint32(4, _random.nextInt(0xFFFFFFFF));
      newId = byteData.getUint64(0, Endian.little);
    }
    _containerIds.add(newId);
    return newId;
  }

  // ++ NUEVA FUNCIÓN DE AYUDA (para buscar una secuencia de bytes) ++
  /// Busca una secuencia de bytes (sublista) dentro de una lista de bytes más grande.
  int _findByteSequence(Uint8List data, Uint8List sequence, [int start = 0]) {
    if (sequence.isEmpty) return -1;
    for (int i = start; i <= data.length - sequence.length; i++) {
      bool found = true;
      for (int j = 0; j < sequence.length; j++) {
        if (data[i + j] != sequence[j]) {
          found = false;
          break;
        }
      }
      if (found) return i;
    }
    return -1;
  }


  /// Reemplaza bytes en un archivo (traducción de `find_and_replace_bytes`)
  Future<int> _findAndReplaceBytes(File file, int oldId, int newId) async {
    final Uint8List data = await file.readAsBytes();

    // Convertir los IDs a listas de bytes (Little Endian)
    final ByteData oldBytesData = ByteData(8)
      ..setUint64(0, oldId, Endian.little);
    final Uint8List oldBytes = oldBytesData.buffer.asUint8List();

    final ByteData newBytesData = ByteData(8)
      ..setUint64(0, newId, Endian.little);
    final Uint8List newBytes = newBytesData.buffer.asUint8List();

    int replacements = 0;
    int offset = 0;

    while (offset < data.length) {
      // ++ CORRECCIÓN (Usamos la nueva función _findByteSequence) ++
      final int index = _findByteSequence(data, oldBytes, offset);
      
      if (index == -1) {
        break; // No se encontraron más
      }

      // Reemplazar la secuencia
      data.setRange(index, index + 8, newBytes);
      replacements++;
      offset = index + 8;
    }

    if (replacements > 0) {
      // Escribir el archivo modificado de vuelta al disco
      await file.writeAsBytes(data);
    }
    return replacements;
  }

  /// Parsea el archivo .utoc (traducción de `parse_utoc` y `_parse_header`)
  // ++ FUNCIÓN COMPLETAMENTE REESCRITA (para evitar errores de RandomAccessFile) ++
  Future<bool> _parseUtoc(File utocFile) async {
    final String baseName = p.basename(utocFile.path);
    _logEntries.add(LogEntry(l10n.analyzingFile(baseName)));

    try {
      final String ucasPath = utocFile.path.replaceAll('.utoc', '.ucas');
      final File ucasFile = File(ucasPath);
      if (!await ucasFile.exists()) {
        _logEntries.add(LogEntry(l10n.warnUcasNotFound, LogEntryType.error));
        return false;
      }

      // 1. Leer TODOS los bytes del .utoc en memoria
      final Uint8List utocData = await utocFile.readAsBytes();
      final ByteData utocView = ByteData.view(utocData.buffer);

      // --- Parseo del Encabezado (desde la data en memoria) ---
      // const int TOC_HEADER_SIZE = 4; // (offset 16)
      final int tocEntryCount = utocView.getUint32(20, Endian.little);
      // final int compressionBlockSize = utocView.getUint32(40, Endian.little);
      final int oldContainerId = utocView.getUint64(56, Endian.little);

      // --- Parseo de Package IDs (desde la data en memoria) ---
      for (int i = 0; i < tocEntryCount; i++) {
        final int offset = 144 + (i * 12); // Offset desde el inicio del archivo
        if (offset + 12 > utocData.length) {
            //_logEntries.add(LogEntry(l10n.warnCorruptHeader, LogEntryType.error));
            break;
        }
        final int packageId = utocView.getUint64(offset, Endian.little);
        // final int chunkType = utocView.getUint8(offset + 11);

        if (!_packageIds.containsKey(packageId)) {
          _packageIds[packageId] = [];
        }
        if (!_packageIds[packageId]!.contains(baseName)) {
          _packageIds[packageId]!.add(baseName);
        }
      }

      // --- Lógica de Conflicto de Container ID ---
      if (_containerIds.contains(oldContainerId)) {
        // ¡Conflicto detectado!
        _logEntries.add(LogEntry(
            l10n.conflictContainerIdDetected(oldContainerId),
            LogEntryType.error));

        // Generamos un nuevo ID
        final int newContainerId = _generateU64Id();
        _logEntries.add(
            LogEntry(l10n.generatingNewId(newContainerId), LogEntryType.info));

        // 1. Modificar el encabezado en memoria (offset 56)
        utocView.setUint64(56, newContainerId, Endian.little);

        // 2. Escribir los bytes del .utoc modificados de vuelta al disco
        await utocFile.writeAsBytes(utocData);
        _logEntries.add(LogEntry(l10n.utocFilePatched, LogEntryType.info));

        // 3. Parchear el archivo .ucas (usando la función que ya lee/escribe)
        _logEntries.add(LogEntry(l10n.patchingUcasFile, LogEntryType.info));
        final int replacements =
            await _findAndReplaceBytes(ucasFile, oldContainerId, newContainerId);
        _logEntries.add(LogEntry(
            l10n.ucasReplacementsSuccess(replacements), LogEntryType.info));

        _logEntries.add(LogEntry(l10n.patchComplete, LogEntryType.info));
        return true;
      } else {
        // No hay conflicto, solo registramos el ID
        _containerIds.add(oldContainerId);
        _logEntries.add(LogEntry(
            l10n.idRegisteredNoConflict(oldContainerId), LogEntryType.success));
        return false;
      }
    } catch (e, s) {
      _logEntries.add(LogEntry(
          l10n.errorProcessingFile(baseName, e.toString()),
          LogEntryType.error));
      _logEntries.add(LogEntry(s.toString(), LogEntryType.error));
      return false; // Indica que no se arregló
    }
  }
}