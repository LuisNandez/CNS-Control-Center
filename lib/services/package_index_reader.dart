// lib/services/package_index_reader.dart
//
// Lee la LISTA DE RUTAS interna de un contenedor de Unreal (.utoc de IoStore o
// .pak clásico) sin leer el .ucas / los datos. Sirve para saber QUÉ contiene un
// mod (¿reemplaza assets del juego o añade un blueprint propio?) mirando solo
// el índice, que es pequeño y casi siempre va en claro.
//
//  - .utoc: se parsea el "directory index" (flag 0x08). Devuelve rutas
//    completas con el mount point, p. ej.
//    ../../../SpeedMasterEve/Content/Mods/SpeedMasterEve/ModActor.uasset
//  - .pak v10+: "full directory index"; v<10 y casos raros: escaneo de cadenas.
//  - Cifrado / sin índice: devuelve null (el llamador decide qué hacer).
//
// Nunca lanza: ante cualquier error devuelve null.
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:path/path.dart' as p;

class PackageIndex {
  /// Mount point del contenedor (puede ser '' si no se pudo leer).
  final String mountPoint;

  /// Rutas completas con '/' (mount point + carpeta + archivo).
  final List<String> paths;

  /// true = salió de un índice estructurado; false = escaneo de cadenas
  /// (menos fiable: las rutas pueden venir fragmentadas).
  final bool structured;

  const PackageIndex({
    required this.mountPoint,
    required this.paths,
    required this.structured,
  });
}

class PackageIndexReader {
  static const int _maxIndexBytes = 64 * 1024 * 1024;
  static const int _scanTail = 16 * 1024 * 1024;
  static const int _maxScanResults = 200000;
  static const String _utocMagic = '-==--==--==--==-';
  static final RegExp _run = RegExp(r'[A-Za-z0-9_./\- ]{6,}');

  /// Lee el índice de [file] (.utoc o .pak). null si no se puede.
  static Future<PackageIndex?> read(File file) async {
    try {
      final ext = p.extension(file.path).toLowerCase();
      if (ext == '.utoc') return await _readUtoc(file);
      if (ext == '.pak') return await _readPak(file);
    } catch (_) {}
    return null;
  }

  // ------------------------------------------------------------------ .utoc

  static Future<PackageIndex?> _readUtoc(File f) async {
    final len = await f.length();
    if (len < 144 || len > _maxIndexBytes) return null;
    return parseUtoc(await f.readAsBytes());
  }

  /// Parsea un .utoc en memoria. Layout: cabecera | chunkIds(12) |
  /// offsets/lengths(10) | perfect hash seeds(4) [v>=4] | chunks sin perfect
  /// hash(4) [v>=5] | bloques de compresión | nombres de compresión |
  /// [firmas si flag 0x04] | ÍNDICE DE DIRECTORIOS (flag 0x08, tamaño en +48).
  static PackageIndex? parseUtoc(Uint8List b) {
    try {
      if (b.length < 144) return null;
      for (var i = 0; i < 16; i++) {
        if (b[i] != _utocMagic.codeUnitAt(i)) return null;
      }
      final bd = ByteData.sublistView(b);
      final version = bd.getUint8(16);
      final headerSize = bd.getUint32(20, Endian.little);
      final entryCount = bd.getUint32(24, Endian.little);
      final blockCount = bd.getUint32(28, Endian.little);
      final blockEntrySize = bd.getUint32(32, Endian.little);
      final methodCount = bd.getUint32(36, Endian.little);
      final methodLen = bd.getUint32(40, Endian.little);
      final dirSize = bd.getUint32(48, Endian.little);
      final flags = bd.getUint8(80);
      if ((flags & 0x02) != 0) return null; // cifrado
      if ((flags & 0x08) == 0 || dirSize == 0) return null; // sin índice
      final seeds = version >= 4 ? bd.getUint32(84, Endian.little) : 0;
      final noHash = version >= 5 ? bd.getUint32(96, Endian.little) : 0;

      var o = headerSize +
          entryCount * (12 + 10) +
          seeds * 4 +
          noHash * 4 +
          blockCount * blockEntrySize +
          methodCount * methodLen;
      if ((flags & 0x04) != 0) {
        final hashSize = bd.getUint32(o, Endian.little);
        o += 4 + hashSize * 2 + blockCount * 20;
      }
      if (o < 0 || o + dirSize > b.length) return null;
      return _parseDirectoryIndex(Uint8List.sublistView(b, o, o + dirSize));
    } catch (_) {
      return null;
    }
  }

  /// FIoDirectoryIndexResource: FString MountPoint; directorios (name,
  /// firstChild, nextSibling, firstFile: u32); archivos (name, nextFile,
  /// userData: u32); tabla de FStrings.
  static PackageIndex? _parseDirectoryIndex(Uint8List d) {
    try {
      const none = 0xFFFFFFFF;
      final r = _Reader(d);
      final mount = r.fstr();
      final nd = r.u32();
      if (nd > d.length ~/ 16) return null;
      final dirs = List<int>.generate(nd * 4, (_) => r.u32());
      final nf = r.u32();
      if (nf > d.length ~/ 12) return null;
      final files = List<int>.generate(nf * 3, (_) => r.u32());
      final ns = r.u32();
      if (ns > d.length ~/ 4) return null;
      final strings = List<String>.generate(ns, (_) => r.fstr());
      if (nd == 0) return null;

      final out = <String>[];
      var steps = 0;
      final maxSteps = nd + nf + 8;

      void walk(int start, String path, int depth) {
        var i = start;
        while (i != none) {
          if (depth > 64 || ++steps > maxSteps) return;
          final name = dirs[i * 4];
          final child = dirs[i * 4 + 1];
          final sibling = dirs[i * 4 + 2];
          var f = dirs[i * 4 + 3];
          final cur = name == none ? path : '$path${strings[name]}/';
          while (f != none) {
            if (++steps > maxSteps) return;
            out.add('$cur${strings[files[f * 3]]}');
            f = files[f * 3 + 1];
          }
          if (child != none) walk(child, cur, depth + 1);
          i = sibling;
        }
      }

      walk(0, mount, 0);
      return PackageIndex(mountPoint: mount, paths: out, structured: true);
    } catch (_) {
      return null;
    }
  }

  // ------------------------------------------------------------------- .pak

  /// El footer (magic E1 12 6F 5A) da versión, indexOffset e indexSize.
  static Future<PackageIndex?> _readPak(File f) async {
    final raf = await f.open();
    try {
      final len = await raf.length();
      if (len < 44) return null;
      final tailLen = math.min(len, 1024);
      await raf.setPosition(len - tailLen);
      final tail = await raf.read(tailLen);
      for (var i = tail.length - 24; i >= 0; i--) {
        if (tail[i] == 0xE1 &&
            tail[i + 1] == 0x12 &&
            tail[i + 2] == 0x6F &&
            tail[i + 3] == 0x5A) {
          final bd = ByteData.sublistView(tail);
          final version = bd.getUint32(i + 4, Endian.little);
          final offset = bd.getUint64(i + 8, Endian.little);
          final size = bd.getUint64(i + 16, Endian.little);
          if (offset < 0 ||
              size <= 0 ||
              size > _maxIndexBytes ||
              offset + size > len) {
            break;
          }
          await raf.setPosition(offset);
          final primary = await raf.read(size);
          final mount = _tryMount(primary);

          if (version < 10) {
            return PackageIndex(
                mountPoint: mount,
                paths: _scanStrings(_lastBytes(primary, _scanTail)),
                structured: false);
          }
          final extra = await _readFullDirectoryIndex(raf, primary, len);
          if (extra == null) break; // sin directorio completo: plan B
          final parsed = _parsePakDirectory(extra, mount);
          if (parsed != null && parsed.isNotEmpty) {
            return PackageIndex(
                mountPoint: mount, paths: parsed, structured: true);
          }
          return PackageIndex(
              mountPoint: mount,
              paths: _scanStrings(_lastBytes(extra, _scanTail)),
              structured: false);
        }
      }
      // Plan B: escanear el final del archivo.
      final n = math.min(len, _scanTail);
      await raf.setPosition(len - n);
      return PackageIndex(
          mountPoint: '',
          paths: _scanStrings(await raf.read(n)),
          structured: false);
    } finally {
      await raf.close();
    }
  }

  static Uint8List _lastBytes(Uint8List b, int max) =>
      b.length <= max ? b : Uint8List.sublistView(b, b.length - max);

  static String _tryMount(Uint8List primary) {
    try {
      return _Reader(primary).fstr();
    } catch (_) {
      return '';
    }
  }

  /// Índice primario v10+: FString MountPoint, i32 NumEntries, u64
  /// PathHashSeed, i32 bHasPathHashIndex [+ i64 off, i64 size, 20B hash],
  /// i32 bHasFullDirectoryIndex [+ i64 off, i64 size, 20B hash].
  static Future<Uint8List?> _readFullDirectoryIndex(
      RandomAccessFile raf, Uint8List primary, int fileLen) async {
    try {
      final bd = ByteData.sublistView(primary);
      var o = 0;
      final strLen = bd.getInt32(o, Endian.little);
      o += 4 + (strLen >= 0 ? strLen : -strLen * 2);
      o += 4 + 8; // NumEntries + PathHashSeed
      final hasPathHash = bd.getInt32(o, Endian.little) != 0;
      o += 4;
      if (hasPathHash) o += 8 + 8 + 20;
      final hasFullDir = bd.getInt32(o, Endian.little) != 0;
      o += 4;
      if (!hasFullDir) return null;
      final off = bd.getInt64(o, Endian.little);
      final size = bd.getInt64(o + 8, Endian.little);
      if (off < 0 ||
          size <= 0 ||
          size > _maxIndexBytes ||
          off + size > fileLen) {
        return null;
      }
      await raf.setPosition(off);
      return await raf.read(size);
    } catch (_) {
      return null;
    }
  }

  /// Full directory index: i32 nDirs; por dir: FString nombre, i32 nFiles y por
  /// archivo: FString nombre + i32 offset codificado.
  static List<String>? _parsePakDirectory(Uint8List d, String mount) {
    try {
      final r = _Reader(d);
      final dirCount = r.i32();
      if (dirCount < 0 || dirCount > d.length) return null;
      final out = <String>[];
      for (var i = 0; i < dirCount; i++) {
        final dir = r.fstr();
        final fileCount = r.i32();
        if (fileCount < 0 || fileCount > d.length) return null;
        for (var j = 0; j < fileCount; j++) {
          final name = r.fstr();
          r.i32();
          out.add(_join(mount, dir, name));
        }
      }
      return out;
    } catch (_) {
      return null;
    }
  }

  static String _join(String mount, String dir, String name) {
    var s = mount;
    if (dir.isNotEmpty) {
      s = s.endsWith('/') && dir.startsWith('/') ? '$s${dir.substring(1)}' : '$s$dir';
    }
    if (s.isNotEmpty && !s.endsWith('/')) s = '$s/';
    return '$s$name';
  }

  // ----------------------------------------------------------------- plan B

  /// Escaneo de cadenas de texto imprimibles (sin estructura).
  static List<String> _scanStrings(Uint8List bytes) {
    final out = <String>[];
    final text = String.fromCharCodes(bytes);
    for (final m in _run.allMatches(text)) {
      out.add(m.group(0)!);
      if (out.length >= _maxScanResults) break;
    }
    return out;
  }
}

/// Lector binario little-endian con FStrings de Unreal.
class _Reader {
  final Uint8List d;
  final ByteData bd;
  int p = 0;
  _Reader(this.d) : bd = ByteData.sublistView(d);

  int u32() {
    final v = bd.getUint32(p, Endian.little);
    p += 4;
    return v;
  }

  int i32() {
    final v = bd.getInt32(p, Endian.little);
    p += 4;
    return v;
  }

  /// FString: i32 longitud (>0 = ASCII, <0 = UTF-16 con -longitud caracteres),
  /// incluye el terminador nulo.
  String fstr() {
    final n = i32();
    if (n == 0) return '';
    if (n > 0) {
      if (n > d.length - p) {
        throw const FormatException('FString fuera de rango');
      }
      final end = p + n;
      final s = String.fromCharCodes(d, p, d[end - 1] == 0 ? end - 1 : end);
      p = end;
      return s;
    }
    final c = -n;
    if (c * 2 > d.length - p) {
      throw const FormatException('FString fuera de rango');
    }
    final units =
        List<int>.generate(c, (i) => bd.getUint16(p + i * 2, Endian.little));
    p += c * 2;
    if (units.isNotEmpty && units.last == 0) units.removeLast();
    return String.fromCharCodes(units);
  }
}