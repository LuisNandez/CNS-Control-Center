// lib/services/logic_mod_detector.dart
//
// Decide si un contenedor (.utoc / .pak) es de un mod LOGIC (blueprint que
// carga UE4SS/BPModLoader) o de contenido (reemplazo de assets / genérico),
// leyendo SOLO su índice de rutas.
//
// Evidencia de LOGIC (cualquiera basta):
//   1. Un asset "ModActor.*": es el punto de entrada que busca BPModLoader
//      (/Game/Mods/<Nombre>/ModActor).
//   2. Rutas dentro de ".../Content/Mods/..." (/Game/Mods/...): espacio propio
//      de mods, el juego base no lo usa.
// Un reemplazo, en cambio, monta sobre ../../../SB/Content/<assets del juego>.
//
// Si el índice no se puede leer (cifrado / sin índice) se prueba una búsqueda
// de texto en el .ucas hermano; si tampoco hay pistas, el resultado es
// `unknown` y el llamador conserva su comportamiento de siempre.
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package_index_reader.dart';

enum PackageKind {
  /// Blueprint de mod (ModActor / Content/Mods).
  logic,

  /// Assets que reemplazan o añaden contenido del juego.
  content,

  /// No se pudo determinar.
  unknown,
}

class PackageVerdict {
  final PackageKind kind;
  final String reason;
  const PackageVerdict(this.kind, this.reason);

  bool get isLogic => kind == PackageKind.logic;

  @override
  String toString() => '${kind.name} ($reason)';
}

class LogicModDetector {
  static const Set<String> packageExtensions = {'.pak', '.utoc', '.ucas'};
  static const int _ucasScanBytes = 16 * 1024 * 1024;

  static final Map<String, PackageVerdict> _cache = {};

  // ------------------------------------------------------------- por rutas

  /// Evalúa las rutas internas de un contenedor.
  static PackageVerdict evaluatePaths(Iterable<String> paths,
      {bool structured = true}) {
    var any = false;
    String? modsFolderHit;
    for (final raw in paths) {
      any = true;
      final lower = raw.toLowerCase().replaceAll('\\', '/');
      final slash = lower.lastIndexOf('/');
      final name = slash >= 0 ? lower.substring(slash + 1) : lower;

      final isModActor = structured
          ? name.startsWith('modactor.')
          : lower.contains('modactor.');
      if (isModActor) {
        return PackageVerdict(PackageKind.logic, 'ModActor: $raw');
      }
      if (modsFolderHit == null &&
          (lower.contains('/content/mods/') || lower.contains('/game/mods/'))) {
        modsFolderHit = raw;
      }
    }
    if (modsFolderHit != null) {
      return PackageVerdict(PackageKind.logic, 'Content/Mods: $modsFolderHit');
    }
    if (!any) return const PackageVerdict(PackageKind.unknown, 'empty index');
    return const PackageVerdict(PackageKind.content, 'game asset paths');
  }

  // ------------------------------------------------------------ por archivo

  /// Veredicto de UN contenedor (.utoc o .pak). Para un .ucas devuelve unknown.
  static Future<PackageVerdict> classifyFile(File file) async {
    final ext = p.extension(file.path).toLowerCase();
    if (ext != '.utoc' && ext != '.pak') {
      return const PackageVerdict(PackageKind.unknown, 'not a container');
    }
    String key;
    try {
      final st = await file.stat();
      key = '${file.path}|${st.size}|${st.modified.millisecondsSinceEpoch}';
    } catch (_) {
      return const PackageVerdict(PackageKind.unknown, 'unreadable');
    }
    final cached = _cache[key];
    if (cached != null) return cached;

    PackageVerdict verdict;
    final index = await PackageIndexReader.read(file);
    if (index != null && index.paths.isNotEmpty) {
      verdict = evaluatePaths(index.paths, structured: index.structured);
      // Un escaneo de cadenas que no encontró nada no demuestra que sea
      // contenido: puede ser un índice ilegible.
      if (!index.structured && verdict.kind == PackageKind.content) {
        verdict = const PackageVerdict(PackageKind.unknown, 'unstructured scan');
      }
    } else {
      verdict = const PackageVerdict(PackageKind.unknown, 'no readable index');
    }

    if (verdict.kind == PackageKind.unknown && ext == '.utoc') {
      final ucas = File(p.setExtension(file.path, '.ucas'));
      if (await ucas.exists() && await _ucasMentionsMods(ucas)) {
        verdict = const PackageVerdict(
            PackageKind.logic, '.ucas references /Game/Mods or ModActor');
      }
    }

    debugPrint('[LogicModDetector] ${p.basename(file.path)} -> $verdict');
    _cache[key] = verdict;
    return verdict;
  }

  // ------------------------------------------------------------- por carpeta

  /// Veredicto agregado de todos los contenedores de [dir]. Un .pak que tiene
  /// un .utoc hermano (stub de IoStore) se ignora: manda el .utoc.
  /// logic si ALGUNO es logic; si no, content si alguno es content.
  static Future<PackageVerdict> classifyPackagesIn(Directory dir,
      {bool recursive = false}) async {
    final files = await _containers(dir, recursive: recursive);
    return classifyFiles(files);
  }

  static Future<PackageVerdict> classifyFiles(Iterable<File> files) async {
    final list = files.toList();
    final utocStems = <String>{
      for (final f in list)
        if (p.extension(f.path).toLowerCase() == '.utoc') _stemKey(f),
    };
    var sawContent = false;
    PackageVerdict last = const PackageVerdict(PackageKind.unknown, 'no containers');
    for (final f in list) {
      final ext = p.extension(f.path).toLowerCase();
      if (ext == '.pak' && utocStems.contains(_stemKey(f))) continue;
      if (ext != '.pak' && ext != '.utoc') continue;
      final v = await classifyFile(f);
      if (v.isLogic) return v;
      if (v.kind == PackageKind.content) sawContent = true;
      last = v;
    }
    if (sawContent) {
      return const PackageVerdict(PackageKind.content, 'game asset paths');
    }
    return last;
  }

  static Future<List<File>> _containers(Directory dir,
      {required bool recursive}) async {
    final out = <File>[];
    try {
      await for (final e in dir.list(recursive: recursive, followLinks: false)) {
        if (e is File &&
            packageExtensions.contains(p.extension(e.path).toLowerCase())) {
          out.add(e);
        }
      }
    } catch (_) {}
    return out;
  }

  static String _stemKey(File f) =>
      p.join(p.dirname(f.path), p.basenameWithoutExtension(f.path)).toLowerCase();

  // ---------------------------------------------------------------- .ucas

  static Future<bool> _ucasMentionsMods(File ucas) async {
    try {
      final raf = await ucas.open();
      try {
        final len = await raf.length();
        final n = math.min(len, _ucasScanBytes);
        final bytes = await raf.read(n);
        return _containsAscii(bytes, '/Game/Mods/') ||
            _containsAscii(bytes, 'ModActor');
      } finally {
        await raf.close();
      }
    } catch (_) {
      return false;
    }
  }

  static bool _containsAscii(Uint8List hay, String needle) {
    final n = needle.codeUnits;
    if (n.isEmpty || hay.length < n.length) return false;
    final first = n[0];
    final last = hay.length - n.length;
    for (var i = 0; i <= last; i++) {
      if (hay[i] != first) continue;
      var j = 1;
      while (j < n.length && hay[i + j] == n[j]) {
        j++;
      }
      if (j == n.length) return true;
    }
    return false;
  }
}