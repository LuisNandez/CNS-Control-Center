// lib/services/archive_service.dart
import 'dart:io';
import 'package:path/path.dart' as p;
import '../l10n/app_localizations.dart';
import '../mod_classifier_service.dart';
import '../models/installation_models.dart';
import 'nexus_api_service.dart';
import 'file_manager_service.dart';
import 'special_mods_handler.dart';

class ArchiveService {
  static String stripVersionFromFolderName(String name) {
    final regex = RegExp(r'\s+[vV]?\d+(\.\d+)*(-[a-zA-Z0-9]+)?\s*$', caseSensitive: false);
    return name.replaceAll(regex, '').trim();
  }

  static String cleanNexusFileName(String fileName) {
    final nexusIdRegex = RegExp(r'-(\d{2,6})-');
    final match = nexusIdRegex.firstMatch(fileName);
    if (match != null) {
      return fileName.substring(0, match.start);
    } else {
      return stripVersionFromFolderName(fileName);
    }
  }

  static Future<Map<String, String>?> extractNexusInfoFromName(String name, String? apiKey) async {
    if (apiKey == null || apiKey.isEmpty) return null;
    try {
      final potentialIdsRegex = RegExp(r'-(\d{2,6})-');
      final matches = potentialIdsRegex.allMatches(name);

      for (final match in matches) {
        final potentialId = match.group(1);
        if (potentialId == null) continue;

        if (await NexusApiService.isValidNexusId(potentialId, apiKey)) {
          final validId = potentialId;
          final remainingString = name.substring(match.end);
          final lastHyphenIndex = remainingString.lastIndexOf('-');

          if (lastHyphenIndex != -1) {
            String version = remainingString.substring(0, lastHyphenIndex);
            version = version.replaceAll('-', '.');
            if (version.toLowerCase().startsWith('v')) version = version.substring(1);
            if (version.toLowerCase().startsWith('cns.')) version = version.substring(4);
            return {'id': validId, 'version': version};
          }
        }
      }
    } catch (e) {
      print('An error occurred during smart Nexus info extraction: $e');
    }
    return null;
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

      final nexusInfo = await extractNexusInfoFromName(fileName, apiKey);
      final String? nexusId = nexusInfo?['id'];
      final bool isLogicModById = (nexusId != null && logicModIds.contains(nexusId));
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
      final archiveName = cleanNexusFileName(baseArchiveName);

      final allModFiles = await FileManagerService.findAllModFilesRecursive(archiveTempDir);
      final hasPaks = allModFiles.any((f) => ['.pak', '.ucas', '.utoc'].contains(p.extension(f.path).toLowerCase()));
      final hasJsons = allModFiles.any((f) => p.extension(f.path).toLowerCase() == '.json');
      final hasMovies = allModFiles.any((f) => ['.bk2', '.webm'].contains(p.extension(f.path).toLowerCase()));

      // --- NUEVO ESCÁNER INFALIBLE PARA SPLASH ---
      // Buscamos directamente en el disco duro, ignorando los filtros de la app
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
      // -------------------------------------------

      if (hasMovies && !hasPaks && !hasJsons) {
        preparedMods.add(PreparedMod(
          sourceDir: archiveTempDir,
          ue4ssDir: null,
          tildeModsDir: null,
          nexusId: nexusInfo?['id'],
          nexusVersion: nexusInfo?['version'],
          archiveName: archiveName,
          modType: ModDirectoryType.movies,
        ));
        continue;
      }

      // --- NUEVA INTERCEPCIÓN PARA SPLASH ---
      // Si tiene imágenes y NO tiene Paks ni Videos, interceptamos el ZIP COMPLETO
      if (hasSplashImages && !hasPaks && !hasMovies) {
        preparedMods.add(PreparedMod(
          sourceDir: archiveTempDir, // Pasamos toda la carpeta principal intacta
          ue4ssDir: null,
          tildeModsDir: null,
          nexusId: nexusInfo?['id'],
          nexusVersion: nexusInfo?['version'],
          archiveName: archiveName,
          modType: ModDirectoryType.splash,
        ));
        continue; // Rompemos el ciclo aquí para que NO divida el ZIP en 3 ventanas
      }
      // ---------------------------------------

      // 1. Comprobar UE4SS
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

      // 3. Comprobar LogicMod
      final logicSourceDir = Directory(p.join(archiveTempDir.path, 'SB', 'Content', 'Paks', 'LogicMods'));
      final ue4ssSourceDir = Directory(p.join(archiveTempDir.path, 'SB', 'Binaries', 'Win64', 'ue4ss')); // MODIFICADO: Apunta a la raíz de ue4ss

      final bool hasLogicDir = await logicSourceDir.exists();
      final bool hasUe4ssDir = await ue4ssSourceDir.exists();

      if (hasLogicDir || hasUe4ssDir) {
        final tildeModsSourceDir = Directory(p.join(archiveTempDir.path, 'SB', 'Content', 'Paks', '~mods'));
        final bool tildeModsExists = await tildeModsSourceDir.exists();

        // Aseguramos la existencia de un sourceDir base para alojar los metadatos
        if (!hasLogicDir) {
          await logicSourceDir.create(recursive: true);
        }

        preparedMods.add(PreparedMod(
          sourceDir: logicSourceDir,
          ue4ssDir: hasUe4ssDir ? ue4ssSourceDir : null,
          tildeModsDir: tildeModsExists ? tildeModsSourceDir : null,
          nexusId: nexusInfo?['id'],
          nexusVersion: nexusInfo?['version'],
          archiveName: archiveName,
          modType: ModDirectoryType.logicMod,
        ));
        continue;
      }

      // Comprobar estructuras LogicMod/ue4ss en la raíz del ZIP (Sin estructura SB)
      Directory? nestedLogicModDir;
      Directory? nestedUe4ssModsDir;

      final List<FileSystemEntity> rootEntities = await archiveTempDir.list().toList();
      final rootDirs = rootEntities.whereType<Directory>().toList();

      // 1. Primero buscamos directamente en la raíz de la extracción
      final rootLogicModsDir = Directory(p.join(archiveTempDir.path, 'LogicMods'));
      if (await rootLogicModsDir.exists()) nestedLogicModDir = rootLogicModsDir;

      final rootUe4ssModsDir = Directory(p.join(archiveTempDir.path, 'ue4ss')); // MODIFICADO: Apunta a la raíz de ue4ss
      if (await rootUe4ssModsDir.exists()) nestedUe4ssModsDir = rootUe4ssModsDir;

      // 2. Si no están en la raíz, buscamos dentro de una posible carpeta envoltorio
      if (nestedLogicModDir == null && nestedUe4ssModsDir == null && rootDirs.length == 1) {
        final potentialLogicModsDir = Directory(p.join(rootDirs.first.path, 'LogicMods'));
        if (await potentialLogicModsDir.exists()) nestedLogicModDir = potentialLogicModsDir;
        
        final potentialUe4ssModsDir = Directory(p.join(rootDirs.first.path, 'ue4ss')); // MODIFICADO: Apunta a la raíz de ue4ss
        if (await potentialUe4ssModsDir.exists()) nestedUe4ssModsDir = potentialUe4ssModsDir;
      }

      if (nestedLogicModDir != null || nestedUe4ssModsDir != null) {
        Directory actualLogicDir = nestedLogicModDir ?? await Directory(p.join(archiveTempDir.path, '_logic_base_')).create();
        
        preparedMods.add(PreparedMod(
          sourceDir: actualLogicDir,
          ue4ssDir: nestedUe4ssModsDir,
          tildeModsDir: null,
          nexusId: nexusInfo?['id'],
          nexusVersion: nexusInfo?['version'],
          archiveName: archiveName,
          modType: ModDirectoryType.logicMod,
        ));
        continue;
      }

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
          nexusVersion: nexusInfo?['version'],
          archiveName: archiveName,
          modType: targetType, 
        ));
        continue;
      }

      // 4. Comprobar Subdirectorios
      final foundModDirs = await findValidModDirectories(archiveTempDir);
      if (foundModDirs.isNotEmpty) {
        for (final modDir in foundModDirs) {
          var modType = await ModClassifierService.classifyModDirectory(modDir);
          if (isLogicModById && modType != ModDirectoryType.unknown) {
            modType = ModDirectoryType.logicMod;
          }
          if (modType != ModDirectoryType.unknown) {
            preparedMods.add(PreparedMod(
              sourceDir: modDir,
              ue4ssDir: null,
              nexusId: nexusInfo?['id'],
              nexusVersion: nexusInfo?['version'],
              archiveName: archiveName,
              modType: modType,
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
      final configFiles = allModFiles.where((f) {
        final name = p.basename(f.path).toLowerCase();
        return ['engine.ini', 'scalability.ini', 'input.ini', 'game.ini'].contains(name);
      }).toList();
      

      if (jsonFiles.isNotEmpty && pakFiles.isNotEmpty) {
        final consolidatedDir = await Directory(p.join(archiveTempDir.path, '_consolidated_')).create();
        for (final modFile in allModFiles) {
          final ext = p.extension(modFile.path).toLowerCase();
          if (['.json', '.pak', '.ucas', '.utoc'].contains(ext)) {
            await modFile.copy(p.join(consolidatedDir.path, p.basename(modFile.path)));
          }
        }
        preparedMods.add(PreparedMod(sourceDir: consolidatedDir, archiveName: archiveName, modType: ModDirectoryType.cns, nexusId: nexusInfo?['id'], nexusVersion: nexusInfo?['version']));
      } else if (jsonFiles.isEmpty && pakFiles.isNotEmpty) {
        final consolidatedDir = await Directory(p.join(archiveTempDir.path, '_consolidated_')).create();
        for (final modFile in pakFiles) {
          await modFile.copy(p.join(consolidatedDir.path, p.basename(modFile.path)));
        }
        preparedMods.add(PreparedMod(sourceDir: consolidatedDir, archiveName: archiveName, modType: ModDirectoryType.genericPak, nexusId: nexusInfo?['id'], nexusVersion: nexusInfo?['version']));
      } else if (jsonFiles.isEmpty && pakFiles.isEmpty && bk2Files.isNotEmpty) {
        final consolidatedDir = await Directory(p.join(archiveTempDir.path, '_consolidated_')).create();
        for (final modFile in bk2Files) {
          await modFile.copy(p.join(consolidatedDir.path, p.basename(modFile.path)));
        }
        preparedMods.add(PreparedMod(sourceDir: consolidatedDir, archiveName: archiveName, modType: ModDirectoryType.movies, nexusId: nexusInfo?['id'], nexusVersion: nexusInfo?['version']));
      }
      else if (saveFiles.isNotEmpty) {
        final consolidatedDir = await Directory(p.join(archiveTempDir.path, '_consolidated_')).create();
        for (final modFile in saveFiles) {
          await modFile.copy(p.join(consolidatedDir.path, p.basename(modFile.path)));
        }
        preparedMods.add(PreparedMod(sourceDir: consolidatedDir, archiveName: archiveName, modType: ModDirectoryType.save, nexusId: nexusInfo?['id'], nexusVersion: nexusInfo?['version']));
      } else if (configFiles.isNotEmpty) {
        final consolidatedDir = await Directory(p.join(archiveTempDir.path, '_consolidated_')).create();
        for (final modFile in configFiles) {
          await modFile.copy(p.join(consolidatedDir.path, p.basename(modFile.path)));
        }
        preparedMods.add(PreparedMod(sourceDir: consolidatedDir, archiveName: archiveName, modType: ModDirectoryType.config, nexusId: nexusInfo?['id'], nexusVersion: nexusInfo?['version']));
      }
    }

    return ArchiveProcessingResult(preparedMods: preparedMods, preparedUE4SS: preparedUE4SS);
  }
}