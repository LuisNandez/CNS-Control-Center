import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import '../models/mod_info.dart';
import '../utils/version_utils.dart';
import 'archive_service.dart';
import 'nexus_api_service.dart';
import 'package:flutter/material.dart';

class ModManagerService {
  static Future<String?> getFitMeshTypeForMod(Directory modDir) async {
    try {
      await for (final entity in modDir.list()) {
        if (entity is File && p.extension(entity.path).toLowerCase() == '.json') {
          var jsonString = await entity.readAsString();
          jsonString = jsonString.replaceAll(RegExp(r',\s*(?=[\}\]])'), '');
          final jsonDecoded = json.decode(jsonString);
          if (jsonDecoded is List && jsonDecoded.isNotEmpty) {
            final modInfo = jsonDecoded[0] as Map<String, dynamic>;
            final fitMeshType = modInfo['FitMeshType'] as String?;
            if (fitMeshType != null && fitMeshType.trim().isNotEmpty) {
              return fitMeshType.trim();
            }
          }
        }
      }
    } catch (e) {
      print("Could not read FitMeshType from ${modDir.path}: $e");
    }
    return null;
  }

  static Future<String?> getDisplayNameForMod(Directory modDir) async {
    try {
      await for (final entity in modDir.list()) {
        if (entity is File && p.extension(entity.path).toLowerCase() == '.json') {
          var jsonString = await entity.readAsString();
          jsonString = jsonString.replaceAll(RegExp(r',\s*(?=[\}\]])'), '');
          final jsonDecoded = json.decode(jsonString);
          if (jsonDecoded is List && jsonDecoded.isNotEmpty) {
            final modInfo = jsonDecoded[0] as Map<String, dynamic>;
            final displayName = modInfo['DisplayName'] as String?;
            if (displayName != null && displayName.trim().isNotEmpty) {
              return displayName.trim().replaceAll(RegExp(r'[\\/:*?"<>|]'), '-');
            }
          }
          break;
        }
      }
    } catch (e) {
      print("Could not read DisplayName from ${modDir.path}: $e");
    }
    return null;
  }

  static Future<String?> getCompositeDisplayName(Directory modDir) async {
    final List<File> jsonFiles = [];
    await for (final entity in modDir.list()) {
      if (entity is File && p.extension(entity.path).toLowerCase() == '.json') {
        jsonFiles.add(entity);
      }
    }

    if (jsonFiles.isEmpty) return null;

    List<String> displayNames = [];
    for (final jsonFile in jsonFiles) {
      try {
        var jsonString = await jsonFile.readAsString();
        jsonString = jsonString.replaceAll(RegExp(r',\s*(?=[\}\]])'), '');
        final jsonDecoded = json.decode(jsonString);
        if (jsonDecoded is List && jsonDecoded.isNotEmpty) {
          final modInfo = jsonDecoded[0] as Map<String, dynamic>;
          final displayName = modInfo['DisplayName'] as String?;
          if (displayName != null && displayName.trim().isNotEmpty) {
            displayNames.add(displayName.trim().replaceAll(RegExp(r'[\\/:*?"<>|]'), '-'));
          }
        }
      } catch (e) {
        print('Could not parse display name from ${jsonFile.path}: $e');
      }
    }
    return displayNames.isEmpty ? null : displayNames.join(' ~ ');
  }

  static Future<String?> getVersionFromModJsonDescription(Directory modDir) async {
    try {
      await for (final file in modDir.list()) {
        if (file is File && p.extension(file.path).toLowerCase() == '.json') {
          final jsonString = await file.readAsString();
          final jsonDecoded = json.decode(jsonString.replaceAll(RegExp(r',\s*(?=[\}\]])'), ''));
          if (jsonDecoded is List && jsonDecoded.isNotEmpty) {
            final modInfo = jsonDecoded[0] as Map<String, dynamic>;
            final description = modInfo['Description'] as String?;
            if (description != null) {
              return ModInfo.extractVersionFromName(description);
            }
          }
          break;
        }
      }
    } catch (e) {
      print('Error reading version from JSON description for ${modDir.path}: $e');
    }
    return null;
  }

  static Future<void> cacheNexusThumbnail({
    required Directory modDirectory,
    required String nexusId,
    required String? apiKey,
  }) async {
    final infoFile = File(p.join(modDirectory.path, 'nexus_info.json'));
    if (!await infoFile.exists()) return;

    try {
      Map<String, dynamic> data = json.decode(await infoFile.readAsString());

      if (data['customCoverPath'] != null && (data['customCoverPath'] as String).isNotEmpty) {
        return;
      }

      final nexusData = await NexusApiService.fetchNexusModData(nexusId, apiKey);
      final gallery = nexusData?['gallery'] as List<dynamic>?;
      if (gallery == null || gallery.isEmpty) return;

      final imageUrl = gallery.first['image'] as String?;
      if (imageUrl == null || imageUrl.isEmpty) return;

      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final fileExtension = p.extension(imageUrl).isNotEmpty ? p.extension(imageUrl) : '.jpg';
        const coverFileName = '_nexus_cover';
        final finalFileName = '$coverFileName$fileExtension';

        final coverFile = File(p.join(modDirectory.path, finalFileName));
        await coverFile.writeAsBytes(response.bodyBytes);

        data['customCoverPath'] = finalFileName;
        data['customCoverAlignmentX'] ??= 0.0;
        data['customCoverAlignmentY'] ??= 0.0;

        final encoder = JsonEncoder.withIndent('  ');
        await infoFile.writeAsString(encoder.convert(data));
        print('Portada de Nexus cacheada para ${p.basename(modDirectory.path)}');
      }
    } catch (e) {
      print('No se pudo cachear la portada de Nexus para ${p.basename(modDirectory.path)}: $e');
    }
  }

  static Future<List<ModInfo>> loadMods({
    required String? gameRootPath,
    required String finalModsPath,
    required String genericModsPath,
    required String logicModsPath,
    required String appVersion,
    required String? apiKey,
  }) async {
    Future<List<ModInfo>> getModsFromDirectory(
      String path,
      bool isEnabled, {
      Set<String> logicModNamesToIgnore = const {},
    }) async {
      final dir = Directory(path);
      if (!await dir.exists()) return [];

      final List<ModInfo> mods = [];
      await for (var entity in dir.list()) {
        if (entity is Directory) {
          final basename = p.basename(entity.path);

          if (path == genericModsPath && logicModNamesToIgnore.contains(basename)) continue;
          final basenameLower = basename.toLowerCase();
          if (path == genericModsPath && (basenameLower == 'customnanosuitsystem' || basenameLower == 'logicmods')) continue;
          if (basename == '__mod_backups__') continue;

          try {
            String? nexusId;
            String? installedVersion;
            String? origin;
            List<dynamic>? gallery;
            String? fitMeshType;
            String? modType;
            String? customCoverPath;
            Alignment? customCoverAlignment;
            DateTime? customCoverLastModified;
            String folderName = p.basename(entity.path);
            String displayName = ArchiveService.stripVersionFromFolderName(folderName);
            String customName = folderName;
            DateTime modLastModified = DateTime.now();
            String? customVersion;
            String? customFitMeshType;
            String? summary;
            String? customSummary;
            String? description;
            String? customDescription;
            String? author;
            String? customAuthor;
            String? userNotes;
            String? sourceUrl;
            String? customSourceUrl;
            List<String>? replacesOutfits;

            bool isEnabledForMod = isEnabled;
            DateTime? installDate;

            final infoFile = File(p.join(entity.path, 'nexus_info.json'));
            final fileStat = await entity.stat();

            if (await infoFile.exists()) {
              final content = await infoFile.readAsString();
              Map<String, dynamic> data = json.decode(content);

              final String? modManagerVersion = data['managerVersion'];
              final String? nexusIdForCheck = data['nexusId'];

              bool needsMetadataUpdate = modManagerVersion == null || (VersionUtils.compareVersions(appVersion, modManagerVersion) > 0);

              if (needsMetadataUpdate && nexusIdForCheck != null) {
                print('Auto-updating metadata for mod: ${data['displayName']}');
                final nexusData = await NexusApiService.fetchNexusModData(nexusIdForCheck, apiKey);

                if (nexusData != null) {
                  data['summary'] ??= nexusData['summary'];
                  data['author'] ??= nexusData['author'];
                  data['gallery'] ??= nexusData['gallery'];
                  data['description'] ??= nexusData['description'];
                  data['sourceUrl'] ??= 'https://www.nexusmods.com/stellarblade/mods/$nexusIdForCheck';
                  data['managerVersion'] = appVersion;

                  final encoder = JsonEncoder.withIndent('  ');
                  await infoFile.writeAsString(encoder.convert(data));
                  await cacheNexusThumbnail(modDirectory: entity, nexusId: nexusIdForCheck, apiKey: apiKey);
                }
              }

              if (data['installDate'] != null) installDate = DateTime.tryParse(data['installDate']);
              modLastModified = installDate ?? fileStat.modified;
              nexusId = data['nexusId'];
              installedVersion = data['installedVersion'];
              origin = data['origin'];
              gallery = data['gallery'];
              fitMeshType = data['fitMeshType'];
              modType = data['modType'] as String?;
              summary = data['summary'];
              customSummary = data['customSummary'];
              description = data['description'];
              customDescription = data['customDescription'];
              author = data['author'];
              customAuthor = data['customAuthor'];
              userNotes = data['userNotes'];
              sourceUrl = data['sourceUrl'];
              customSourceUrl = data['customSourceUrl'];
              if (data['replacesOutfits'] != null) {
                replacesOutfits = List<String>.from(data['replacesOutfits']);
              } else if (data['replacesOutfit'] != null) {
                // Compatibilidad con JSONs antiguos
                replacesOutfits = [data['replacesOutfit'] as String];
  }

              if (installedVersion != null && installedVersion.toLowerCase().startsWith('v')) {
                installedVersion = installedVersion.substring(1);
              }

              customCoverPath = data['customCoverPath'];
              if (customCoverPath != null) {
                final coverFile = File(p.join(entity.path, customCoverPath));
                if (await coverFile.exists()) {
                  customCoverLastModified = await coverFile.lastModified();
                }
              }
              if (data['customCoverAlignmentX'] != null && data['customCoverAlignmentY'] != null) {
                customCoverAlignment = Alignment(
                  data['customCoverAlignmentX'].toDouble(),
                  data['customCoverAlignmentY'].toDouble(),
                );
              }
              customVersion = data['customVersion'] as String?;
              customFitMeshType = data['customFitMeshType'] as String?;

              if (data['displayName'] != null) displayName = data['displayName'];
              if (data['customName'] != null) customName = data['customName'];
              else customName = displayName;
            }

            String folderNameLower = folderName.toLowerCase();
            // Verificamos si estamos leyendo la ruta de CNS y si es Animations o Cosmetics
            if (path == finalModsPath && (folderNameLower == 'animations' || folderNameLower == 'cosmetics')) {
              bool needsSave = false;
              Map<String, dynamic> localData = {};
              
              if (await infoFile.exists()) {
                try {
                  localData = json.decode(await infoFile.readAsString());
                } catch (_) {}
              }

              // Forzamos el ID de Nexus de CNS (1496)
              if (nexusId != '1496') {
                nexusId = '1496';
                localData['nexusId'] = '1496';
                needsSave = true;
              }
              
              // Opcional: Le ponemos un nombre claro para que no se confundan
              if (!displayName.startsWith('CNS')) {
                displayName = 'CNS ${folderName[0].toUpperCase()}${folderName.substring(1)}';
                customName = displayName;
                localData['displayName'] = displayName;
                localData['customName'] = customName;
                needsSave = true;
              }

              // Si le faltaba el ID, guardamos el json y forzamos la descarga de la portada 1496
              if (needsSave) {
                final encoder = JsonEncoder.withIndent('  ');
                await infoFile.writeAsString(encoder.convert(localData));
                await cacheNexusThumbnail(modDirectory: entity, nexusId: '1496', apiKey: apiKey);
              }
            }

            if (modType == null && isEnabled) {
              if (path == genericModsPath) modType = 'genericPak';
              else if (path == finalModsPath) modType = 'cns';
            }

            if (['movies', 'save', 'config', 'splash'].contains(modType) && await infoFile.exists()) {
              final content = await infoFile.readAsString();
              final data = json.decode(content);
              isEnabledForMod = data['isEnabled'] as bool? ?? false;
            }

            if (fitMeshType == null && modType != 'movies') {
              fitMeshType = await getFitMeshTypeForMod(entity);
              if (fitMeshType != null && await infoFile.exists()) {
                try {
                  final content = await infoFile.readAsString();
                  Map<String, dynamic> data = json.decode(content);
                  data['fitMeshType'] = fitMeshType;
                  final encoder = JsonEncoder.withIndent('  ');
                  await infoFile.writeAsString(encoder.convert(data));
                } catch (e) {}
              }
            }

            installedVersion ??= ModInfo.extractVersionFromName(folderName);

            mods.add(ModInfo(
              directory: entity,
              nexusId: nexusId,
              localVersion: installedVersion,
              lastModified: modLastModified,
              installDate: installDate,
              isEnabled: isEnabledForMod,
              origin: origin,
              displayName: displayName,
              customName: customName,
              gallery: gallery,
              fitMeshType: fitMeshType,
              modType: modType,
              customCoverPath: customCoverPath,
              customCoverAlignment: customCoverAlignment,
              customCoverLastModified: customCoverLastModified,
              customVersion: customVersion,
              customFitMeshType: customFitMeshType,
              summary: summary,
              customSummary: customSummary,
              description: description,
              customDescription: customDescription,
              author: author,
              customAuthor: customAuthor,
              userNotes: userNotes,
              sourceUrl: sourceUrl,
              customSourceUrl: customSourceUrl,
              replacesOutfits: replacesOutfits,
            ));
          } catch (e) {
            print("Error processing directory ${entity.path}: $e");
          }
        }
      }
      return mods;
    }

    final enabledLogicMods = await getModsFromDirectory(logicModsPath, true);
    final Set<String> logicModFolderNames = enabledLogicMods.map((mod) => p.basename(mod.directory.path)).toSet();
    final enabledCnsMods = await getModsFromDirectory(finalModsPath, true);
    final enabledGenericMods = await getModsFromDirectory(genericModsPath, true, logicModNamesToIgnore: logicModFolderNames);

    final List<ModInfo> coreCnsAddons = [];
    enabledCnsMods.removeWhere((mod) {
      final name = p.basename(mod.directory.path).toLowerCase();
      if (name == 'animations' || name == 'cosmetics') {
        coreCnsAddons.add(mod);
        return true; // Lo remueve de enabledCnsMods
      }
      return false;
    });

    if (gameRootPath == null) {
      return [...enabledCnsMods, ...enabledGenericMods, ...enabledLogicMods];
    }
    
    final backupDirPath = p.join(gameRootPath, 'SB', 'Content', '__MOD_BACKUPS__');
    final disabledMods = await getModsFromDirectory(backupDirPath, false);

    final List<ModInfo> disabledCoreCnsAddons = [];
    disabledMods.removeWhere((mod) {
      final name = p.basename(mod.directory.path).toLowerCase();
      // Verificamos que sea el de CNS viendo que tenga el nexusId 1496
      if ((name == 'animations' || name == 'cosmetics') && mod.nexusId == '1496') {
        disabledCoreCnsAddons.add(mod);
        return true;
      }
      return false;
    });

    return [...enabledCnsMods, ...enabledGenericMods, ...enabledLogicMods, ...disabledMods, ...coreCnsAddons, ...disabledCoreCnsAddons];
  }

  static Future<int> runSelfHealing({
    required List<ModInfo> allMods,
    required Map<String, dynamic> modDatabase,
    required String? apiKey,
  }) async {
    int repairedCount = 0;
    for (final mod in List.from(allMods)) {
      final infoFile = File(p.join(mod.directory.path, 'nexus_info.json'));
      bool needsRepair = false;
      if (await infoFile.exists()) {
        try {
          final content = await infoFile.readAsString();
          if (content.trim().isEmpty) {
            needsRepair = true;
          } else {
            final data = json.decode(content) as Map<String, dynamic>;
            final nexusId = data['nexusId'] as String?;
            if (nexusId == null || nexusId.isEmpty) needsRepair = true;
          }
        } catch (e) {
          print('Found malformed nexus_info.json for ${mod.customName}. Error: $e');
          needsRepair = true;
        }
      } else {
        needsRepair = true;
      }

      if (!needsRepair) continue;

      final primaryDisplayName = await getDisplayNameForMod(mod.directory);
      if (primaryDisplayName != null && modDatabase.containsKey(primaryDisplayName)) {
        final dbEntry = modDatabase[primaryDisplayName] as Map<String, dynamic>;
        final nexusId = dbEntry['nexusId'] as String?;
        if (nexusId == null) continue;

        String? version = ModInfo.extractVersionFromName(p.basename(mod.directory.path));
        version ??= await getVersionFromModJsonDescription(mod.directory);

        if (version == null) {
          if (apiKey == null || apiKey.isEmpty) break;
          version = await NexusApiService.fetchLatestModVersion(nexusId, apiKey);
        }

        final compositeDisplayName = await getCompositeDisplayName(mod.directory) ?? primaryDisplayName;
        final currentFolderName = p.basename(mod.directory.path);

        try {
          Map<String, dynamic> modData = {};
          if (await infoFile.exists()) {
            try {
              final content = await infoFile.readAsString();
              if (content.trim().isNotEmpty) modData = json.decode(content);
            } catch (e) {
              print('Could not parse existing nexus_info.json for ${mod.customName}. Creating new.');
            }
          }

          modData['nexusId'] = nexusId;
          modData['displayName'] = compositeDisplayName;
          modData['customName'] ??= currentFolderName;
          modData['installedVersion'] = version;
          modData['installDate'] ??= DateTime.now().toIso8601String();
          modData['origin'] = 'repaired';

          final nexusData = await NexusApiService.fetchNexusModData(nexusId, apiKey);
          if (nexusData != null) {
            modData['gallery'] = nexusData['gallery'];
            modData['summary'] = nexusData['summary'];
            modData['author'] = nexusData['author'];
            modData['description'] = nexusData['description'];
          }

          final encoder = JsonEncoder.withIndent('  ');
          await infoFile.writeAsString(encoder.convert(modData));
          await cacheNexusThumbnail(modDirectory: mod.directory, nexusId: nexusId, apiKey: apiKey);
          repairedCount++;
        } catch (e) {
          print('Could not self-repair mod "$primaryDisplayName": $e');
        }
      }
    }
    return repairedCount;
  }
}