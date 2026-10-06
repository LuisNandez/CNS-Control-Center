// lib/services/archive_service.dart
import 'dart:io';
import 'package:path/path.dart' as p;
import 'hd_atool_audio_service.dart';
import '../l10n/app_localizations.dart';
import '../mod_classifier_service.dart';
import '../models/installation_models.dart';
import 'nexus_file_identifier.dart';
import 'file_manager_service.dart';
import 'special_mods_handler.dart';
import 'config_mod_detector.dart';
import 'logic_mod_stager.dart';

class ArchiveService {
  static String stripVersionFromFolderName(String name) {
    final regex = RegExp(r'\s+[vV]?\d+(\.\d+)*(-[a-zA-Z0-9]+)?\s*$', caseSensitive: false);
    return name.replaceAll(regex, '').trim();
  }

  /// Nombre "limpio" del mod a partir del nombre del archivo descargado
  /// (sin consultar la API). Si el archivo sigue el patrón de Nexus
  /// (`Nombre-modId-versión-fecha`) devuelve solo la parte del nombre.
  static String cleanNexusFileName(String fileName) {
    final parsed = NexusFileNameParser.bestGuess(fileName);
    if (parsed != null) {
      return NexusFileNameParser.sanitizeDisplayName(
        parsed.name,
        version: NexusFileNameParser.normalizeVersion(parsed.version),
      );
    }
    return stripVersionFromFolderName(NexusFileNameParser.baseName(fileName));
  }

  static Future<Directory?> findUE4SSRoot(Directory root) async {
    final ue4ssDir = Directory(p.join(root.path, 'ue4ss'));
    final dwmapiFile = File(p.join(root.path, 'dwmapi.dll'));
    if (await ue4ssDir.exists() && await dwmapiFile.exists()) {
      return root;
    }

    await for (final entity in root.list(followLinks: false)) {
      if (entity is Directory) {
        final found = await findUE4SSRoot(entity);
        if (found != null) return found;
      }
    }
    return null;
  }

  static Future<List<Directory>> findValidModDirectories(Directory root) async {
    final List<Directory> found = [];
    final rootModType = await ModClassifierService.classifyModDirectory(root);
    if (rootModType != ModDirectoryType.unknown) {
      found.add(root);
      return found;
    }

    await for (final entity in root.list(followLinks: false)) {
      if (entity is Directory) {
        final basename = p.basename(entity.path);
        if (basename.startsWith('__') || basename.startsWith('.')) continue;
        final nestedMods = await findValidModDirectories(entity);
        found.addAll(nestedMods);
      }
    }
    return found;
  }

  static const Set<String> _containerExts = {'.pak', '.ucas', '.utoc'};

  static bool _isCnsJson(String path) =>
      p.basename(path).toLowerCase().endsWith('.dekcns.json');

  /// Busca .dekcns.json "sueltos" bajo [dir]: solo los que están en carpetas
  /// SIN contenedores (.pak/.ucas/.utoc), es decir, carpetas que solo guardan la
  /// configuración (p. ej. `CustomNanosuitSystem/`). Una carpeta con sus propios
  /// paks es otra variante y no se toca.
  static Future<void> _collectCnsJsons(
    Directory dir,
    List<File> out, {
    bool Function(String path)? skipDir,
  }) async {
    List<FileSystemEntity> kids;
    try {
      kids = await dir.list(followLinks: false).toList();
    } catch (_) {
      return;
    }
    final hasContainer = kids.any((e) =>
        e is File && _containerExts.contains(p.extension(e.path).toLowerCase()));
    if (!hasContainer) {
      for (final e in kids) {
        if (e is File && _isCnsJson(e.path)) out.add(e);
      }
    }
    for (final e in kids) {
      if (e is! Directory) continue;
      final name = p.basename(e.path);
      if (name.startsWith('__') || name.startsWith('.')) continue;
      if (skipDir != null && skipDir(e.path)) continue;
      await _collectCnsJsons(e, out, skipDir: skipDir);
    }
  }

  /// Un mod CNS puede venir con los paks en una carpeta y el .dekcns.json en
  /// otra (típico: paks en la raíz y el json en `CustomNanosuitSystem/`). El
  /// clasificador mira cada carpeta por separado y lo tomaba por genérico.
  ///
  /// Si [modDir] se clasificó como genérico y existe un .dekcns.json:
  ///   1) dentro de [modDir], en una subcarpeta sin paks, o
  ///   2) fuera de él (carpeta hermana) cuando [allowOutside] es true (el
  ///      archivo trae un único mod, así que no hay duda de a quién pertenece),
  /// el json se MUEVE a la raíz de [modDir] (la forma plana que espera el
  /// instalador de CNS) y devuelve true. Solo trabaja sobre la carpeta temporal
  /// de extracción, nunca sobre los archivos del usuario.
  static Future<bool> _adoptCnsJsons({
    required Directory modDir,
    required Directory archiveRoot,
    required List<Directory> allModDirs,
    required bool allowOutside,
  }) async {
    final jsons = <File>[];
    await _collectCnsJsons(modDir, jsons);
    if (jsons.isEmpty && allowOutside) {
      await _collectCnsJsons(
        archiveRoot,
        jsons,
        skipDir: (path) => allModDirs
            .any((m) => p.equals(m.path, path) || p.isWithin(m.path, path)),
      );
    }
    if (jsons.isEmpty) return false;

    var movedAny = false;
    final oldParents = <Directory>{};
    for (final f in jsons) {
      final dest = File(p.join(modDir.path, p.basename(f.path)));
      if (await dest.exists()) continue; // nunca se pisa un json existente
      try {
        try {
          await f.rename(dest.path);
        } catch (_) {
          await f.copy(dest.path);
          await f.delete();
        }
        movedAny = true;
        oldParents.add(f.parent);
      } catch (_) {}
    }

    // Quita las carpetas que quedaron vacías (p. ej. CustomNanosuitSystem/).
    for (final d in oldParents) {
      if (p.equals(d.path, modDir.path) || p.equals(d.path, archiveRoot.path)) {
        continue;
      }
      try {
        if (await d.list().isEmpty) await d.delete();
      } catch (_) {}
    }
    return movedAny;
  }

  static Future<ArchiveProcessingResult> processArchives({
    required List<File> archives,
    required Directory tempExtractionDir,
    required String? sevenZipPath,
    required String? apiKey,
    required Set<String> logicModIds,
    required AppLocalizations l10n,
    required Function(double progress, String status) onProgress,
  }) async {
    final List<PreparedMod> preparedMods = [];
    PreparedUE4SS? preparedUE4SS;

    for (int i = 0; i < archives.length; i++) {
      final archiveFile = archives[i];
      final fileName = p.basename(archiveFile.path);

      onProgress((i + 1) / archives.length, l10n.statusExtractingMultipleFiles(i + 1, fileName, archives.length));

      // Reconoce el archivo: mod, versión y nombre oficiales (API / MD5 / nombre).
      final NexusFileIdentity? identity = await NexusFileIdentifier.identify(
        archive: archiveFile,
        apiKey: apiKey,
      );
      final Map<String, String>? nexusInfo = identity?.toLegacyInfo();
      final String? nexusId = nexusInfo?['id'];
      final bool isLogicModById = (nexusId != null &&
          (logicModIds.contains(nexusId) ||
              HdAtoolAudio.isToolMain(nexusId, identity)));
      final bool isSpecialModById = (nexusId != null && SpecialModsHandler.isSpecialMod(nexusId));
      final archiveTempDir = Directory(p.join(tempExtractionDir.path, i.toString()));
      await archiveTempDir.create();

      final extension = p.extension(archiveFile.path).toLowerCase();

      if (['.zip', '.rar', '.7z'].contains(extension)) {
        if (sevenZipPath == null || !await File(sevenZipPath).exists()) {
          throw Exception('7ZIP_MISSING');
        }
        final result = await Process.run(sevenZipPath, [
          'x', archiveFile.path, '-o${archiveTempDir.path}', '-y',
        ]);
        if (result.exitCode != 0) {
          throw Exception(l10n.error7zipDecompression(result.stderr.toString()));
        }
      } else {
        throw Exception(l10n.errorUnsupportedFormat(extension));
      }

      final baseArchiveName = p.basenameWithoutExtension(archiveFile.path);
      // Nombre oficial de Nexus si se reconoció el archivo; si no, el del zip.
      final archiveName = (identity != null && identity.name.isNotEmpty)
          ? identity.fullName
          : cleanNexusFileName(baseArchiveName);

      final allModFiles = await FileManagerService.findAllModFilesRecursive(archiveTempDir);
      final hasPaks = allModFiles.any((f) => ['.pak', '.ucas', '.utoc'].contains(p.extension(f.path).toLowerCase()));
      final hasJsons = allModFiles.any((f) => p.extension(f.path).toLowerCase() == '.json');
      final hasMovies = allModFiles.any((f) => ['.bk2', '.webm'].contains(p.extension(f.path).toLowerCase()));

      // 1. Comprobar UE4SS (núcleo). Va ANTES que el resto de detecciones para
      //    que ni Splash ni Películas se queden con un archivo que no es suyo.
      final ue4ssRoot = await findUE4SSRoot(archiveTempDir);
      if (ue4ssRoot != null) {
        preparedUE4SS = PreparedUE4SS(sourceDir: ue4ssRoot);
        continue;
      }

      // 2. Comprobar Actualización CNS
      final sbDir = Directory(p.join(archiveTempDir.path, 'SB'));
      if (await sbDir.exists()) {
        final cnsLuaFile = File(p.join(sbDir.path, 'Binaries', 'Win64', 'ue4ss', 'Mods', 'DekCNS', 'Scripts', 'main.lua'));
        if (await cnsLuaFile.exists()) {
          return ArchiveProcessingResult(preparedMods: [], cnsUpdateDir: sbDir);
        }
      }

      // 3. Comprobar LogicMod en CUALQUIER estructura:
      //    carpetas de UE4SS (Scripts/main.lua, dlls/main.dll) y/o LogicMods,
      //    con o sin los .pak/.ucas/.utoc, en la ruta que sea (SB/..., ue4ss/...,
      //    Mods/<Nombre>/..., raíz, carpeta envoltorio). Los .pak se reparten por
      //    CONTENIDO (índice del .utoc): logic -> LogicMods, resto -> ~mods.
      //    (Los mods logic de SOLO .pak los resuelve el clasificador por carpeta.)
      if (!isSpecialModById) {
        final stagedLogic = await LogicModStager.process(archiveTempDir);
        if (stagedLogic.isNotEmpty) {
          final bool severalLogicVariants = stagedLogic.length > 1;
          for (final staged in stagedLogic) {
            preparedMods.add(PreparedMod(
              sourceDir: staged.logicDir,
              ue4ssDir: staged.ue4ssDir,
              tildeModsDir: staged.tildeDir,
              nexusId: nexusInfo?['id'],
              nexusVersion: nexusInfo?['version'], identity: identity,
              archiveName: archiveName,
              modType: ModDirectoryType.logicMod,
              archiveKey: severalLogicVariants ? archiveTempDir.path : null,
              variantLabel: severalLogicVariants ? staged.variantLabel : null,
            ));
          }
          continue;
        }
      }

      // Mods de configuración (.ini): si el archivo trae un .ini del juego, una
      // captura/portada (.png/.jpg) NO lo convierte en un mod de Splash.
      final bool hasConfigIni =
          (await ConfigModDetector.findConfigFiles(archiveTempDir, recursive: true)).isNotEmpty;

      if (hasMovies && !hasPaks && !hasJsons) {
        preparedMods.add(PreparedMod(
          sourceDir: archiveTempDir,
          ue4ssDir: null,
          tildeModsDir: null,
          nexusId: nexusInfo?['id'],
          nexusVersion: nexusInfo?['version'], identity: identity,
          archiveName: archiveName,
          modType: ModDirectoryType.movies,
        ));
        continue;
      }

      // --- ESCÁNER PARA SPLASH ---
      // Buscamos directamente en el disco duro, ignorando los filtros de la app.
      // Una imagen sola ya no basta: no debe haber paks, vídeos ni .ini de config.
      bool hasSplashImages = false;
      await for (final entity in archiveTempDir.list(recursive: true)) {
        if (entity is File) {
          final ext = p.extension(entity.path).toLowerCase();
          if (['.bmp', '.jpg', '.jpeg', '.png'].contains(ext)) {
            hasSplashImages = true;
            break; // En cuanto encontramos una imagen, sabemos que es Splash
          }
        }
      }

      // --- INTERCEPCIÓN PARA SPLASH ---
      // Si tiene imágenes y NO tiene Paks, Videos ni config, interceptamos el ZIP COMPLETO
      if (hasSplashImages && !hasPaks && !hasMovies && !hasConfigIni) {
        preparedMods.add(PreparedMod(
          sourceDir: archiveTempDir, // Pasamos toda la carpeta principal intacta
          ue4ssDir: null,
          tildeModsDir: null,
          nexusId: nexusInfo?['id'],
          nexusVersion: nexusInfo?['version'], identity: identity,
          archiveName: archiveName,
          modType: ModDirectoryType.splash,
        ));
        continue; // Rompemos el ciclo aquí para que NO divida el ZIP en 3 ventanas
      }
      // ---------------------------------------

      // 3.5 Interceptar Mods Especiales (como 550, 801, 1112) para que no se dividan
      if (isSpecialModById) {
        // Por defecto es genericPak, a menos que sea el 801 (Splash)
        ModDirectoryType targetType = ModDirectoryType.genericPak;
        if (nexusId == '801') {
          targetType = ModDirectoryType.splash;
        }

        preparedMods.add(PreparedMod(
          sourceDir: archiveTempDir, // Pasamos toda la raíz de extracción intacta
          ue4ssDir: null,
          tildeModsDir: null,
          nexusId: nexusId,
          nexusVersion: nexusInfo?['version'], identity: identity,
          archiveName: archiveName,
          modType: targetType, 
        ));
        continue;
      }

      // 4. Comprobar Subdirectorios
      final foundModDirs = await findValidModDirectories(archiveTempDir);
      if (foundModDirs.isNotEmpty) {
        final bool severalVariants = foundModDirs.length > 1;
        for (final modDir in foundModDirs) {
          var modType = await ModClassifierService.classifyModDirectory(modDir);
          if (isLogicModById && modType != ModDirectoryType.unknown) {
            modType = ModDirectoryType.logicMod;
          }
          // Paks en una carpeta y .dekcns.json en otra: es un mod CNS.
          if (modType == ModDirectoryType.genericPak) {
            final adopted = await _adoptCnsJsons(
              modDir: modDir,
              archiveRoot: archiveTempDir,
              allModDirs: foundModDirs,
              allowOutside: foundModDirs.length == 1,
            );
            if (adopted) modType = ModDirectoryType.cns;
          }
          // Mod logic para HD-ATOOL (paks sueltos + audios numerados): los audios
          // no están en la carpeta de los paks, así que se reúnen aquí dentro de
          // <modDir>/_hd_atool_audio para que el instalador los lleve consigo.
          if (modType == ModDirectoryType.logicMod &&
              !HdAtoolAudio.isToolMain(nexusId, identity) &&
              await HdAtoolAudio.dependsOnHdAtool(modDir)) {
            var n = await HdAtoolAudio.stageAudio(
                archiveRoot: modDir, logicOut: modDir);
            if (n == 0) {
              n = await HdAtoolAudio.stageAudio(
                  archiveRoot: archiveTempDir, logicOut: modDir);
            }
            print('[HdAtoolAudio] ${p.basename(modDir.path)}: $n audio(s) staged');
          }
          if (modType != ModDirectoryType.unknown) {
            // Nombre de la subcarpeta (variante) dentro del archivo.
            String? variantLabel;
            if (severalVariants) {
              final rel = p
                  .relative(modDir.path, from: archiveTempDir.path)
                  .replaceAll(r'\', '/');
              if (rel.isNotEmpty && rel != '.') variantLabel = rel;
            }
            preparedMods.add(PreparedMod(
              sourceDir: modDir,
              ue4ssDir: null,
              nexusId: nexusInfo?['id'],
              nexusVersion: nexusInfo?['version'], identity: identity,
              archiveName: archiveName,
              modType: modType,
              archiveKey: severalVariants ? archiveTempDir.path : null,
              variantLabel: variantLabel,
            ));
          }
        }
        continue;
      }

      // 5. Comprobar Archivos Sueltos
      //final allModFiles = await FileManagerService.findAllModFilesRecursive(archiveTempDir);
      final jsonFiles = allModFiles.where((f) => p.extension(f.path).toLowerCase() == '.json').toList();
      final pakFiles = allModFiles.where((f) => ['.pak', '.ucas', '.utoc'].contains(p.extension(f.path).toLowerCase())).toList();
      final bk2Files = allModFiles.where((f) => p.extension(f.path).toLowerCase() == '.bk2').toList();

      final saveFiles = allModFiles.where((f) => p.extension(f.path).toLowerCase() == '.sav').toList();
      // allModFiles no incluye .ini: se buscan aparte (antes esta lista siempre quedaba vacía).
      final configFiles = await ConfigModDetector.findConfigFiles(archiveTempDir, recursive: true);
      

      if (jsonFiles.isNotEmpty && pakFiles.isNotEmpty) {
        final consolidatedDir = await Directory(p.join(archiveTempDir.path, '_consolidated_')).create();
        for (final modFile in allModFiles) {
          final ext = p.extension(modFile.path).toLowerCase();
          if (['.json', '.pak', '.ucas', '.utoc'].contains(ext)) {
            await modFile.copy(p.join(consolidatedDir.path, p.basename(modFile.path)));
          }
        }
        preparedMods.add(PreparedMod(sourceDir: consolidatedDir, archiveName: archiveName, modType: ModDirectoryType.cns, nexusId: nexusInfo?['id'], nexusVersion: nexusInfo?['version'], identity: identity));
      } else if (jsonFiles.isEmpty && pakFiles.isNotEmpty) {
        final consolidatedDir = await Directory(p.join(archiveTempDir.path, '_consolidated_')).create();
        for (final modFile in pakFiles) {
          await modFile.copy(p.join(consolidatedDir.path, p.basename(modFile.path)));
        }
        preparedMods.add(PreparedMod(sourceDir: consolidatedDir, archiveName: archiveName, modType: ModDirectoryType.genericPak, nexusId: nexusInfo?['id'], nexusVersion: nexusInfo?['version'], identity: identity));
      } else if (jsonFiles.isEmpty && pakFiles.isEmpty && bk2Files.isNotEmpty) {
        final consolidatedDir = await Directory(p.join(archiveTempDir.path, '_consolidated_')).create();
        for (final modFile in bk2Files) {
          await modFile.copy(p.join(consolidatedDir.path, p.basename(modFile.path)));
        }
        preparedMods.add(PreparedMod(sourceDir: consolidatedDir, archiveName: archiveName, modType: ModDirectoryType.movies, nexusId: nexusInfo?['id'], nexusVersion: nexusInfo?['version'], identity: identity));
      }
      else if (saveFiles.isNotEmpty) {
        final consolidatedDir = await Directory(p.join(archiveTempDir.path, '_consolidated_')).create();
        for (final modFile in saveFiles) {
          await modFile.copy(p.join(consolidatedDir.path, p.basename(modFile.path)));
        }
        preparedMods.add(PreparedMod(sourceDir: consolidatedDir, archiveName: archiveName, modType: ModDirectoryType.save, nexusId: nexusInfo?['id'], nexusVersion: nexusInfo?['version'], identity: identity));
      } else if (configFiles.isNotEmpty) {
        final consolidatedDir = await Directory(p.join(archiveTempDir.path, '_consolidated_')).create();
        for (final modFile in configFiles) {
          await modFile.copy(p.join(consolidatedDir.path, p.basename(modFile.path)));
        }
        preparedMods.add(PreparedMod(sourceDir: consolidatedDir, archiveName: archiveName, modType: ModDirectoryType.config, nexusId: nexusInfo?['id'], nexusVersion: nexusInfo?['version'], identity: identity));
      }
    }

    // Si un mismo archivo contiene varios mods, el nombre del archivo no sirve
    // para distinguirlos (cada uno conserva su propio nombre interno).
    final Map<NexusFileIdentity, int> modsPerIdentity = {};
    for (final m in preparedMods) {
      final id = m.identity;
      if (id != null) modsPerIdentity[id] = (modsPerIdentity[id] ?? 0) + 1;
    }
    for (final m in preparedMods) {
      final id = m.identity;
      m.soleModInArchive = id == null || modsPerIdentity[id] == 1;
    }

    return ArchiveProcessingResult(preparedMods: preparedMods, preparedUE4SS: preparedUE4SS);
  }
}