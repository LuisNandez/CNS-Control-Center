// lib/services/variant_conflict_service.dart
//
// Detecta cuándo UN mismo archivo comprimido trae varias variantes (subcarpetas)
// que reemplazan lo mismo (el mismo traje / los mismos archivos del juego).
// Instalarlas todas haría que la segunda sobrescriba a la primera, así que la
// app le pregunta al usuario cuál quiere instalar.
import 'dart:io';
import 'package:path/path.dart' as p;
import '../mod_classifier_service.dart';
import '../models/installation_models.dart';
import 'outfit_detector.dart';

/// Conjunto de variantes de un mismo archivo que se pisan entre sí.
class VariantGroup {
  final String archiveName;
  final List<PreparedMod> variants;

  /// Trajes que reemplazan (puede estar vacío si el conflicto se detectó solo
  /// por tener archivos con el mismo nombre).
  final List<String> outfits;

  VariantGroup({
    required this.archiveName,
    required this.variants,
    required this.outfits,
  });
}

class VariantConflictService {
  static const _containerExts = ['.pak', '.ucas', '.utoc', '.json'];

  /// Busca grupos de variantes en conflicto dentro de [mods].
  /// Solo mira mods que salen de un archivo con varias subcarpetas.
  ///
  /// Si [detectOutfits] es false (asignación automática de trajes desactivada
  /// en Ajustes) no se leen los .pak/.utoc: las variantes se comparan solo por
  /// el nombre de sus archivos.
  static Future<List<VariantGroup>> findGroups(
    List<PreparedMod> mods, {
    bool detectOutfits = true,
  }) async {
    // 1) Candidatas: mods pak/CNS con archiveKey, agrupadas por archivo.
    final Map<String, List<PreparedMod>> byArchive = {};
    for (final m in mods) {
      if (m.archiveKey == null) continue;
      if (m.modType != ModDirectoryType.genericPak &&
          m.modType != ModDirectoryType.cns &&
          m.modType != ModDirectoryType.logicMod) {
        continue;
      }
      byArchive.putIfAbsent(m.archiveKey!, () => []).add(m);
    }

    final groups = <VariantGroup>[];
    for (final candidates in byArchive.values) {
      if (candidates.length < 2) continue;

      // 2) Firma de cada variante: trajes + nombres de archivo.
      final outfits = <Set<String>>[];
      final names = <Set<String>>[];
      for (final m in candidates) {
        final o = <String>{};
        if (detectOutfits && m.modType == ModDirectoryType.genericPak) {
          try {
            o.addAll(await OutfitDetector.detect(m.sourceDir));
          } catch (_) {}
        }
        outfits.add(o);
        final sig = await _containerNames(m.sourceDir);
        // Mods logic: las carpetas de mod UE4SS (ue4ss/Mods/<Nombre>) también
        // se pisan entre variantes.
        if (m.ue4ssDir != null) sig.addAll(await _ue4ssModNames(m.ue4ssDir!));
        names.add(sig);
      }

      // 3) Union-Find: dos variantes chocan si comparten traje o un archivo.
      final parent = List<int>.generate(candidates.length, (i) => i);
      int find(int x) {
        while (parent[x] != x) {
          parent[x] = parent[parent[x]];
          x = parent[x];
        }
        return x;
      }
      bool overlap(Set<String> a, Set<String> b) => a.any(b.contains);
      for (int i = 0; i < candidates.length; i++) {
        for (int j = i + 1; j < candidates.length; j++) {
          if (overlap(outfits[i], outfits[j]) || overlap(names[i], names[j])) {
            parent[find(i)] = find(j);
          }
        }
      }

      final Map<int, List<int>> comps = {};
      for (int i = 0; i < candidates.length; i++) {
        comps.putIfAbsent(find(i), () => []).add(i);
      }
      for (final idxs in comps.values) {
        if (idxs.length < 2) continue;
        final allOutfits = <String>{};
        for (final i in idxs) {
          allOutfits.addAll(outfits[i]);
        }
        groups.add(VariantGroup(
          archiveName: candidates[idxs.first].archiveName,
          variants: [for (final i in idxs) candidates[i]],
          outfits: allOutfits.toList()..sort(),
        ));
      }
    }
    return groups;
  }

  static Future<Set<String>> _ue4ssModNames(Directory ue4ssDir) async {
    final out = <String>{};
    try {
      final mods = Directory(p.join(ue4ssDir.path, 'Mods'));
      if (!await mods.exists()) return out;
      await for (final e in mods.list(followLinks: false)) {
        if (e is Directory) out.add('ue4ss:${p.basename(e.path).toLowerCase()}');
      }
    } catch (_) {}
    return out;
  }

  static Future<Set<String>> _containerNames(Directory dir) async {
    final out = <String>{};
    try {
      await for (final e in dir.list(recursive: true, followLinks: false)) {
        if (e is File &&
            _containerExts.contains(p.extension(e.path).toLowerCase())) {
          out.add(p.basename(e.path).toLowerCase());
        }
      }
    } catch (_) {}
    return out;
  }

  /// Aplica la decisión del usuario sobre [group]: deja solo las variantes de
  /// [keepIndexes] (índices dentro de group.variants) en [mods].
  static void applyChoice(
    List<PreparedMod> mods,
    VariantGroup group,
    List<int> keepIndexes,
  ) {
    final keep = {for (final i in keepIndexes) group.variants[i]};
    mods.removeWhere((m) => group.variants.contains(m) && !keep.contains(m));
  }

  /// Debe llamarse al final (con las decisiones ya aplicadas):
  ///  - recalcula `soleModInArchive`;
  ///  - si varias variantes del mismo archivo siguen instalándose, les añade el
  ///    nombre de su subcarpeta para que no compartan carpeta de destino (esa
  ///    era la causa de que la 2.ª sobrescribiera a la 1.ª).
  static void finalize(List<PreparedMod> mods) {
    final Map<String, int> perArchive = {};
    for (final m in mods) {
      final k = m.archiveKey;
      if (k != null) perArchive[k] = (perArchive[k] ?? 0) + 1;
    }
    for (int i = 0; i < mods.length; i++) {
      final m = mods[i];
      final k = m.archiveKey;
      if (k != null && (perArchive[k] ?? 0) > 1) {
        m.soleModInArchive = false;
        // Los pak genéricos y los mods logic usan el nombre del archivo como
        // carpeta; los CNS se nombran por sus .json.
        if ((m.modType == ModDirectoryType.genericPak ||
                m.modType == ModDirectoryType.logicMod) &&
            m.variantLabel != null &&
            !m.archiveName.endsWith(' - ${m.variantLabel}')) {
          final label = m.variantLabel!.replaceAll(RegExp(r'[\\/:*?"<>|]+'), ' - ');
          mods[i] = m.withArchiveName('${m.archiveName} - $label');
        }
      } else if (k != null) {
        // Quedó una sola variante: ya es "el único mod" del archivo.
        m.soleModInArchive = m.identity == null || _isSoleByIdentity(mods, m);
      }
    }
  }

  static bool _isSoleByIdentity(List<PreparedMod> mods, PreparedMod m) =>
      mods.where((o) => o.identity != null && o.identity == m.identity).length <= 1;
}