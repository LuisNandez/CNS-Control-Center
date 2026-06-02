import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import '../models/mod_info.dart';
import '../utils/version_utils.dart';

class UpdateCheckResult {
  final Map<String, dynamic>? cnsUpdateInfo;
  final Map<String, Map<String, dynamic>> modUpdates;
  final int updatesFound;
  final String? error;

  UpdateCheckResult({
    this.cnsUpdateInfo,
    required this.modUpdates,
    required this.updatesFound,
    this.error,
  });
}

class UpdateService {
  static String _normalizeName(String name) {
    final withoutExtension = p.basenameWithoutExtension(name);
    return withoutExtension.toLowerCase().replaceAll(RegExp(r'[_ -]'), '');
  }

  static Future<Map<String, dynamic>?> checkSingleModUpdate({
    required String apiKey,
    required String nexusId,
    required String localVersion,
    required bool hasLocalVersion,
    required String displayName,
    required Directory modDirectory,
    required Map<String, String> skippedVersions,
  }) async {
    final headers = {'apikey': apiKey, 'accept': 'application/json'};
    final url = Uri.parse('https://api.nexusmods.com/v1/games/stellarblade/mods/$nexusId/files.json');
    
    final response = await http.get(url, headers: headers);

    try {
      final infoFile = File(p.join(modDirectory.path, 'nexus_info.json'));
      if (await infoFile.exists()) {
        final modData = json.decode(await infoFile.readAsString());
        modData['lastUpdateCheck'] = {
          'timestamp': DateTime.now().toIso8601String(),
          'statusCode': response.statusCode,
        };
        await infoFile.writeAsString(JsonEncoder.withIndent('  ').convert(modData));
      }
    } catch (e) {
      print('Could not update lastUpdateCheck for $displayName: $e');
    }

    if (response.statusCode != 200) return null;

    final jsonResponse = json.decode(response.body);
    final allFiles = jsonResponse['files'] as List;
    
    final potentialFiles = allFiles.where((file) =>
        file['category_name'] == 'MAIN' || file['category_name'] == 'OPTIONAL').toList();

    final compatibleFiles = potentialFiles.where((file) {
      final fileName = (file['file_name'] as String).toLowerCase();
      return !fileName.contains('not cns') &&
             !fileName.contains('without cns') &&
             !fileName.contains('non cns');
    }).toList();

    if (compatibleFiles.isEmpty) return null;

    final cnsFiles = compatibleFiles.where((file) =>
        (file['file_name'] as String).toLowerCase().contains('cns')).toList();

    final filesToConsider = cnsFiles.isNotEmpty ? cnsFiles : compatibleFiles;
    dynamic bestMatchFile;

    if (filesToConsider.length == 1) {
      bestMatchFile = filesToConsider.first;
    } else {
      final normalizedDisplayName = _normalizeName(displayName);
      final keywords = displayName.toLowerCase().split(RegExp(r'[_ -]')).where((s) => s.isNotEmpty).toList();

      final fileScores = filesToConsider.map((file) {
        final rawFileName = file['file_name'] as String;
        final normalizedFileName = _normalizeName(rawFileName);
        int score = 0;

        if (normalizedFileName.contains(normalizedDisplayName)) {
          score = 100;
        } else {
          for (final keyword in keywords) {
            if (normalizedFileName.contains(keyword)) score++;
          }
        }
        return {'file': file, 'score': score};
      }).toList();

      fileScores.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));

      if (fileScores.isNotEmpty && (fileScores.first['score'] as int) > 0) {
        bestMatchFile = fileScores.first['file'];
      }
    }

    if (bestMatchFile != null) {
      final latestVersion = bestMatchFile['version'] as String;
      final skippedVersion = skippedVersions[nexusId];
      final isSkipped = skippedVersion != null && VersionUtils.compareVersions(latestVersion, skippedVersion) <= 0;

      if (hasLocalVersion && !isSkipped && VersionUtils.compareVersions(latestVersion, localVersion) > 0) {
        return {
          'version': latestVersion,
          'fileId': bestMatchFile['file_id'] as int,
        };
      }
    }
    return null;
  }

  static Future<UpdateCheckResult> checkForAllUpdates({
    required String apiKey,
    required String? cnsNexusId,
    required String? cnsVersion,
    required String? gameRootPath,
    required List<ModInfo> allMods,
    required Map<String, String> skippedVersions,
  }) async {
    final List<Future<Map<String, dynamic>?>> futures = [];
    final List<String> paths = [];
    final List<bool> isCnsList = [];

    if (cnsNexusId != null && cnsNexusId.isNotEmpty && gameRootPath != null) {
      futures.add(checkSingleModUpdate(
        apiKey: apiKey,
        nexusId: cnsNexusId,
        localVersion: cnsVersion ?? '0',
        hasLocalVersion: cnsVersion != null,
        displayName: "Custom Nanosuit System",
        modDirectory: Directory(p.join(gameRootPath, 'SB', 'Binaries', 'Win64', 'ue4ss')),
        skippedVersions: skippedVersions,
      ));
      paths.add('');
      isCnsList.add(true);
    }

    final allModsWithNexusId = allMods.where((mod) => mod.nexusId != null && mod.nexusId!.isNotEmpty).toList();
    
    for (final mod in allModsWithNexusId) {
      final String versionForCheck = mod.customVersion?.isNotEmpty == true
          ? mod.customVersion!
          : mod.localVersion ?? '0';

      final bool hasVersionForCheck = (mod.customVersion?.isNotEmpty == true) || 
                                      (mod.localVersion?.isNotEmpty == true);

      futures.add(checkSingleModUpdate(
        apiKey: apiKey,
        nexusId: mod.nexusId!,
        localVersion: versionForCheck,
        hasLocalVersion: hasVersionForCheck,
        displayName: mod.displayName,
        modDirectory: mod.directory,
        skippedVersions: skippedVersions,
      ));
      paths.add(mod.directory.path);
      isCnsList.add(false);
    }

    if (futures.isEmpty) {
      return UpdateCheckResult(modUpdates: {}, updatesFound: 0);
    }

    try {
      final results = await Future.wait(futures);
      int updatesFound = 0;
      Map<String, dynamic>? cnsUpdateInfo;
      final Map<String, Map<String, dynamic>> modUpdates = {};

      for (int i = 0; i < results.length; i++) {
        final result = results[i];
        if (result != null) {
          updatesFound++;
          if (isCnsList[i]) {
            cnsUpdateInfo = result;
          } else {
            modUpdates[paths[i]] = result;
          }
        }
      }

      return UpdateCheckResult(
        cnsUpdateInfo: cnsUpdateInfo,
        modUpdates: modUpdates,
        updatesFound: updatesFound,
      );
    } catch (e) {
      return UpdateCheckResult(
        modUpdates: {},
        updatesFound: 0,
        error: e.toString(),
      );
    }
  }
}