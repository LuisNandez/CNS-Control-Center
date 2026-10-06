// lib/services/hd_atool_audio_service.dart
//
// Mods LOGIC hechos para HD-ATOOL (Animation Tool) que traen audio.
//
// HD-ATOOL lee los audios EXTERNOS de una carpeta fija (no hay .json ni otro
// mecanismo de redirección):
//
//     <juego>/SB/Content/Paks/LogicMods/HD-ATOOL_P/audio/<N>.wav
//
// y cada audio se llama como el número de la animación (1.wav, 12.wav, 123.mp3).
// Esos archivos NO van dentro de la carpeta del mod, así que el flujo normal
// (mover la carpeta del mod a/desde __MOD_BACKUPS__) no los activa ni los
// desactiva. Este servicio:
//
//   1. DETECTA si un mod logic depende de HD-ATOOL (su .utoc/.pak/.ucas
//      menciona "HD-ATOOL_P", p. ej. mount point ../../../SB/Content/Mods/HD-ATOOL_P/).
//   2. En el staging junta los audios numéricos del archivo (estén donde estén)
//      en <mod>/_hd_atool_audio/  -> esa carpeta es la "memoria" del mod.
//   3. activate():   copia esos audios a LogicMods/HD-ATOOL_P/audio/
//      (si ya había un archivo distinto con el mismo nombre, lo guarda en
//      <mod>/_hd_atool_audio_originals/).
//   4. deactivate(): quita de la carpeta del juego SOLO los audios que siguen
//      siendo idénticos a los del mod y restaura los originales guardados.
//
// Nunca lanza: los fallos de audio no deben romper la instalación/activación.
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:path/path.dart' as p;
import 'nexus_file_identifier.dart';

class HdAtoolAudio {
  /// Carpeta de HD-ATOOL dentro de LogicMods.
  static const String toolFolder = 'HD-ATOOL_P';

  /// Subcarpeta de audio dentro de [toolFolder].
  static const String audioSubfolder = 'audio';

  /// Dentro de la carpeta del mod: audios propios del mod (fuente de verdad).
  static const String storeDirName = '_hd_atool_audio';

  /// Dentro de la carpeta del mod: archivos del juego que se pisaron.
  static const String originalsDirName = '_hd_atool_audio_originals';

  /// Clave en nexus_info.json con los nombres instalados.
  static const String infoKey = 'hdAtoolAudio';

  static const Set<String> audioExtensions = {
    '.wav', '.mp3', '.ogg', '.flac', '.m4a',
  };

  static const int _scanBytes = 16 * 1024 * 1024;
  static final RegExp _numeric = RegExp(r'^\d+$');

  // ------------------------------------------------------------------ rutas

  /// .../Paks/LogicMods/HD-ATOOL_P/audio
  static String gameAudioPath(String logicModsPath) =>
      p.join(logicModsPath, toolFolder, audioSubfolder);

  /// ¿Es un audio de HD-ATOOL por nombre? (número + extensión de audio)
  static bool isAtoolAudioFile(String path) {
    if (!audioExtensions.contains(p.extension(path).toLowerCase())) {
      return false;
    }
    return _numeric.hasMatch(p.basenameWithoutExtension(path));
  }

  // -------------------------------------------------------------- detección

  /// ¿Algún contenedor (.utoc/.pak/.ucas) bajo [dir] referencia HD-ATOOL_P?
  /// Busca el texto en el archivo (el mount point y las rutas van en claro).
  static Future<bool> dependsOnHdAtool(Directory dir) async {
    try {
      if (!await dir.exists()) return false;
      final needle = toolFolder.toLowerCase().codeUnits;
      final utocs = <File>[];
      final others = <File>[];
      await for (final e in dir.list(recursive: true, followLinks: false)) {
        if (e is! File) continue;
        if (p.split(p.relative(e.path, from: dir.path)).contains(storeDirName)) {
          continue;
        }
        final ext = p.extension(e.path).toLowerCase();
        if (ext == '.utoc') {
          utocs.add(e);
        } else if (ext == '.pak' || ext == '.ucas') {
          others.add(e);
        }
      }
      // Primero lo barato: .utoc y .pak; el .ucas (grande) al final.
      for (final f in [
        ...utocs,
        ...others.where((f) => p.extension(f.path).toLowerCase() == '.pak'),
        ...others.where((f) => p.extension(f.path).toLowerCase() == '.ucas'),
      ]) {
        if (await _fileContains(f, needle)) return true;
      }
    } catch (e) {
      debugPrint('[HdAtoolAudio] dependsOnHdAtool error: $e');
    }
    return false;
  }

  static Future<bool> _fileContains(File f, List<int> needleLower) async {
    RandomAccessFile? raf;
    try {
      raf = await f.open();
      final len = await raf.length();
      final head = math.min(len, _scanBytes);
      await raf.setPosition(0);
      if (_containsCI(await raf.read(head), needleLower)) return true;
      if (len > head) {
        // El índice de un .pak clásico va al final.
        final tail = math.min(len - head, _scanBytes);
        await raf.setPosition(len - tail);
        if (_containsCI(await raf.read(tail), needleLower)) return true;
      }
    } catch (_) {
    } finally {
      await raf?.close();
    }
    return false;
  }

  /// Búsqueda ASCII sin distinguir mayúsculas. [needleLower] ya en minúsculas.
  static bool _containsCI(Uint8List hay, List<int> needleLower) {
    final n = needleLower.length;
    if (n == 0 || hay.length < n) return false;
    final first = needleLower[0];
    final last = hay.length - n;
    for (var i = 0; i <= last; i++) {
      if (_lower(hay[i]) != first) continue;
      var j = 1;
      while (j < n && _lower(hay[i + j]) == needleLower[j]) {
        j++;
      }
      if (j == n) return true;
    }
    return false;
  }

  static int _lower(int c) => (c >= 0x41 && c <= 0x5A) ? c + 32 : c;

  // ---------------------------------------------------------------- staging

  /// Reúne los audios numéricos del mod en `<logicOut>/_hd_atool_audio/`.
  ///
  ///  - Los que ya se copiaron dentro de logicOut (p. ej. porque el zip traía
  ///    LogicMods/HD-ATOOL_P/audio/1.wav) se MUEVEN allí.
  ///  - Los que están en cualquier otra parte del archivo se copian.
  ///
  /// [archiveRoot] es la raíz del archivo extraído; [skipRoots] carpetas que
  /// no se exploran (staging, UE4SS...). Devuelve cuántos audios quedaron.
  static Future<int> stageAudio({
    required Directory archiveRoot,
    required Directory logicOut,
    List<String> skipRoots = const [],
  }) async {
    final store = Directory(p.join(logicOut.path, storeDirName));
    var count = 0;
    try {
      await store.create(recursive: true);

      // 1) Audios que ya cayeron dentro del staging lógico.
      final inside = <File>[];
      await for (final e in logicOut.list(recursive: true, followLinks: false)) {
        if (e is File &&
            isAtoolAudioFile(e.path) &&
            !p.isWithin(store.path, e.path)) {
          inside.add(e);
        }
      }
      for (final f in inside) {
        final dest = File(p.join(store.path, p.basename(f.path)));
        if (!await dest.exists()) {
          await f.rename(dest.path);
        } else {
          await f.delete();
        }
      }
      await _pruneEmptyDirs(logicOut, keep: store.path);

      // 2) Audios en el resto del archivo.
      await _collectAudio(archiveRoot, skipRoots, store);

      await for (final e in store.list(followLinks: false)) {
        if (e is File) count++;
      }
      if (count == 0 && await store.exists()) await store.delete(recursive: true);
    } catch (e) {
      debugPrint('[HdAtoolAudio] stageAudio error: $e');
    }
    return count;
  }

  static Future<void> _collectAudio(
      Directory dir, List<String> skipRoots, Directory store) async {
    List<FileSystemEntity> kids;
    try {
      kids = await dir.list(followLinks: false).toList();
    } catch (_) {
      return;
    }
    for (final e in kids) {
      final name = p.basename(e.path);
      if (name.startsWith('__') || name.startsWith('.')) continue;
      if (skipRoots.any((s) => p.equals(s, e.path))) continue;
      if (e is Directory) {
        await _collectAudio(e, skipRoots, store);
      } else if (e is File && isAtoolAudioFile(e.path)) {
        final dest = File(p.join(store.path, name));
        if (!await dest.exists()) await e.copy(dest.path);
      }
    }
  }

  static Future<void> _pruneEmptyDirs(Directory root, {required String keep}) async {
    final dirs = <Directory>[];
    await for (final e in root.list(recursive: true, followLinks: false)) {
      if (e is Directory && !p.equals(e.path, keep) && !p.isWithin(keep, e.path)) {
        dirs.add(e);
      }
    }
    dirs.sort((a, b) => b.path.length.compareTo(a.path.length)); // hijos primero
    for (final d in dirs) {
      try {
        if (await d.list().isEmpty) await d.delete();
      } catch (_) {}
    }
  }

  /// Red de seguridad al instalar: si el mod ya copiado depende de HD-ATOOL y
  /// aún no tiene `_hd_atool_audio`, mueve ahí los audios numerados que haya
  /// dentro de su carpeta (p. ej. 1.wav junto a los paks).
  static Future<int> adoptInPlace(Directory modDir) async {
    try {
      if (!await dependsOnHdAtool(modDir)) {
        debugPrint('[HdAtoolAudio] ${p.basename(modDir.path)}: no depende de HD-ATOOL');
        return 0;
      }
      final existing = await storedNames(modDir);
      if (existing.isNotEmpty) return existing.length;
      return await stageAudio(archiveRoot: modDir, logicOut: modDir);
    } catch (e) {
      debugPrint('[HdAtoolAudio] adoptInPlace error: $e');
      return 0;
    }
  }

  // ------------------------------------------- la propia herramienta (1662)

  /// ID de Nexus del mod HD-ATOOL (Animation Tool). Es un mod logic cuya
  /// carpeta en LogicMods es siempre [toolFolder], no el nombre del mod.
  static const String toolNexusId = '1662';

  static bool isToolMod(String? nexusId) => nexusId == toolNexusId;

  /// Solo el "Main file" de Nexus del mod 1662 es la herramienta en sí. Los
  /// archivos opcionales (animtest, parches, ejemplos...) comparten el ID pero
  /// NO van a la carpeta fija HD-ATOOL_P. Requiere que la API haya confirmado
  /// la categoría (API key de Nexus); si no se sabe, no se considera principal.
  /// Se aceptan MAIN y OLD_VERSION (versiones anteriores del main).
  static bool isToolMain(String? nexusId, NexusFileIdentity? identity) =>
      isToolMod(nexusId) && (identity?.isMainFile ?? false);

  /// El zip puede traer la carpeta HD-ATOOL_P (p. ej. LogicMods/HD-ATOOL_P/...).
  /// Como el instalador ya instala dentro de LogicMods/HD-ATOOL_P, se sube su
  /// contenido un nivel para no terminar con HD-ATOOL_P/HD-ATOOL_P.
  static Future<void> flattenToolFolder(Directory dir) async {
    try {
      for (var i = 0; i < 4; i++) {
        Directory? inner;
        await for (final e in dir.list(followLinks: false)) {
          if (e is Directory &&
              p.basename(e.path).toLowerCase() == toolFolder.toLowerCase()) {
            inner = e;
            break;
          }
        }
        if (inner == null) return;
        final tmp = Directory(p.join(dir.path, '__flatten_tmp__'));
        await inner.rename(tmp.path);
        await _moveContents(tmp, dir, overwrite: true);
        await tmp.delete(recursive: true);
      }
    } catch (e) {
      debugPrint('[HdAtoolAudio] flattenToolFolder error: $e');
    }
  }

  /// ¿[dir] es una carpeta HD-ATOOL_P que NO es una instalación de la
  /// herramienta gestionada por la app? (la crea la carpeta de audio de otros
  /// mods, o el usuario la copió a mano). nexus_info.json con nexusId 1662 =
  /// instalación gestionada.
  static Future<bool> isStrayToolFolder(Directory dir) async {
    try {
      final info = File(p.join(dir.path, 'nexus_info.json'));
      if (!await info.exists()) return true;
      final txt = await info.readAsString();
      return !RegExp('"nexusId"\\s*:\\s*"?$toolNexusId"?').hasMatch(txt);
    } catch (_) {
      return true;
    }
  }

  /// Aparta `<[folder]>/audio` a una carpeta temporal para que sobreviva a un
  /// borrado/actualización de la herramienta. Devuelve null si no hay audios.
  static Future<Directory?> stashAudio(Directory folder) async {
    try {
      final audio = Directory(p.join(folder.path, audioSubfolder));
      if (!await audio.exists()) return null;
      final stash = await Directory.systemTemp.createTemp('hd_atool_audio_');
      await _moveContents(audio, stash, overwrite: true);
      return stash;
    } catch (e) {
      debugPrint('[HdAtoolAudio] stashAudio error: $e');
      return null;
    }
  }

  /// Devuelve los audios apartados a `<[folder]>/audio` y borra el temporal.
  static Future<void> restoreAudio(Directory? stash, Directory folder) async {
    if (stash == null) return;
    try {
      final audio = Directory(p.join(folder.path, audioSubfolder));
      await audio.create(recursive: true);
      await _moveContents(stash, audio, overwrite: true);
      await stash.delete(recursive: true);
    } catch (e) {
      debugPrint('[HdAtoolAudio] restoreAudio error: $e');
    }
  }

  /// Al ACTIVAR la herramienta: si en LogicMods ya existe una carpeta
  /// HD-ATOOL_P "suelta" (con los audios de otros mods activos), se funde en
  /// la carpeta de la herramienta guardada ([toolFolderInBackup]) para que el
  /// movimiento de carpeta no choque y no se pierda ningún audio.
  static Future<void> absorbStrayToolFolder(
      Directory liveFolder, Directory toolFolderInBackup) async {
    try {
      if (!await liveFolder.exists()) return;
      await _moveContents(liveFolder, toolFolderInBackup, overwrite: false);
      await liveFolder.delete(recursive: true);
    } catch (e) {
      debugPrint('[HdAtoolAudio] absorbStrayToolFolder error: $e');
    }
  }

  /// Mueve el contenido de [from] dentro de [to] (recursivo). Con
  /// overwrite=false no pisa archivos que ya existan en [to].
  static Future<void> _moveContents(Directory from, Directory to,
      {required bool overwrite}) async {
    await to.create(recursive: true);
    await for (final e in from.list(followLinks: false)) {
      final target = p.join(to.path, p.basename(e.path));
      if (e is Directory) {
        await _moveContents(e, Directory(target), overwrite: overwrite);
      } else if (e is File) {
        final dst = File(target);
        if (await dst.exists()) {
          if (!overwrite) continue;
          await dst.delete();
        }
        try {
          await e.rename(target);
        } on FileSystemException {
          await e.copy(target); // otro volumen
          await e.delete();
        }
      }
    }
  }

  // ------------------------------------------------------- activar / quitar

  /// Nombres de los audios que el mod trae en [modDir].
  static Future<List<String>> storedNames(Directory modDir) async {
    final store = Directory(p.join(modDir.path, storeDirName));
    final out = <String>[];
    if (!await store.exists()) return out;
    await for (final e in store.list(followLinks: false)) {
      if (e is File) out.add(p.basename(e.path));
    }
    out.sort();
    return out;
  }

  /// Pone los audios del mod en la carpeta de HD-ATOOL del juego.
  /// [modDir] es la carpeta del mod (donde esté ahora); [gameAudioDir] la
  /// carpeta .../LogicMods/HD-ATOOL_P/audio. Devuelve los nombres colocados.
  static Future<List<String>> activate(
      Directory modDir, String gameAudioDir) async {
    final placed = <String>[];
    try {
      final names = await storedNames(modDir);
      debugPrint('[HdAtoolAudio] activate ${p.basename(modDir.path)}: ${names.length} audio(s) -> $gameAudioDir');
      if (names.isEmpty) return placed;
      final store = p.join(modDir.path, storeDirName);
      final originals = Directory(p.join(modDir.path, originalsDirName));
      await Directory(gameAudioDir).create(recursive: true);

      for (final name in names) {
        final src = File(p.join(store, name));
        final dst = File(p.join(gameAudioDir, name));
        if (await dst.exists()) {
          if (await _sameFile(src, dst)) {
            placed.add(name);
            continue; // ya está puesto
          }
          // Archivo distinto con el mismo nombre: se guarda para restaurarlo.
          await originals.create(recursive: true);
          final bak = File(p.join(originals.path, name));
          if (!await bak.exists()) await dst.copy(bak.path);
        }
        await src.copy(dst.path);
        placed.add(name);
      }
    } catch (e) {
      debugPrint('[HdAtoolAudio] activate error: $e');
    }
    return placed;
  }

  /// Quita del juego los audios de este mod y restaura lo que había antes.
  /// Solo borra un archivo si sigue siendo idéntico al del mod: si otro mod o
  /// el usuario lo cambió, no se toca.
  static Future<void> deactivate(Directory modDir, String gameAudioDir) async {
    try {
      final names = await storedNames(modDir);
      if (names.isEmpty) return;
      final store = p.join(modDir.path, storeDirName);
      final originals = p.join(modDir.path, originalsDirName);

      for (final name in names) {
        final mine = File(p.join(store, name));
        final live = File(p.join(gameAudioDir, name));
        if (await live.exists()) {
          if (!await _sameFile(mine, live)) continue; // ya no es nuestro
          await live.delete();
        }
        final bak = File(p.join(originals, name));
        if (await bak.exists()) {
          await Directory(gameAudioDir).create(recursive: true);
          await bak.copy(live.path);
          await bak.delete();
        }
      }
      final o = Directory(originals);
      if (await o.exists() && await o.list().isEmpty) await o.delete();
    } catch (e) {
      debugPrint('[HdAtoolAudio] deactivate error: $e');
    }
  }

  static Future<bool> _sameFile(File a, File b) async {
    try {
      if (await a.length() != await b.length()) return false;
      final x = await a.readAsBytes();
      final y = await b.readAsBytes();
      for (var i = 0; i < x.length; i++) {
        if (x[i] != y[i]) return false;
      }
      return true;
    } catch (_) {
      return false;
    }
  }
}