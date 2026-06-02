import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'file_manager_service.dart';

class CoreInstallerService {
  static const String defaultUe4ssManifestContent = r'''
  ["dwmapi.dll","ue4ss","ue4ss/Default_UVTD_Configs","ue4ss/Default_UVTD_Configs/Config","ue4ss/Default_UVTD_Configs/Config/case_preserving_variants.json","ue4ss/Default_UVTD_Configs/Config/member_rename_map.json","ue4ss/Default_UVTD_Configs/Config/object_items.json","ue4ss/Default_UVTD_Configs/Config/pdbs_to_dump.json","ue4ss/Default_UVTD_Configs/Config/private_variables.json","ue4ss/Default_UVTD_Configs/Config/types_not_to_dump.json","ue4ss/Default_UVTD_Configs/Config/uprefix_to_fprefix.json","ue4ss/Default_UVTD_Configs/Config/valid_udt_names.json","ue4ss/Default_UVTD_Configs/Config/virtual_generator_includes.json","ue4ss/LICENSE","ue4ss/Mods","ue4ss/Mods/ActorDumperMod","ue4ss/Mods/ActorDumperMod/Scripts","ue4ss/Mods/ActorDumperMod/Scripts/main.lua","ue4ss/Mods/BPML_GenericFunctions","ue4ss/Mods/BPML_GenericFunctions/Scripts","ue4ss/Mods/BPML_GenericFunctions/Scripts/main.lua","ue4ss/Mods/BPModLoaderMod","ue4ss/Mods/BPModLoaderMod/load_order.txt","ue4ss/Mods/BPModLoaderMod/Scripts","ue4ss/Mods/BPModLoaderMod/Scripts/main.lua","ue4ss/Mods/CheatManagerEnablerMod","ue4ss/Mods/CheatManagerEnablerMod/Scripts","ue4ss/Mods/CheatManagerEnablerMod/Scripts/main.lua","ue4ss/Mods/ConsoleCommandsMod","ue4ss/Mods/ConsoleCommandsMod/Scripts","ue4ss/Mods/ConsoleCommandsMod/Scripts/dump_object.lua","ue4ss/Mods/ConsoleCommandsMod/Scripts/main.lua","ue4ss/Mods/ConsoleCommandsMod/Scripts/set.lua","ue4ss/Mods/ConsoleCommandsMod/Scripts/summon_unloaded_assets.lua","ue4ss/Mods/ConsoleEnablerMod","ue4ss/Mods/ConsoleEnablerMod/Scripts","ue4ss/Mods/ConsoleEnablerMod/Scripts/main.lua","ue4ss/Mods/jsbLuaProfilerMod","ue4ss/Mods/jsbLuaProfilerMod/Scripts","ue4ss/Mods/jsbLuaProfilerMod/Scripts/main.lua","ue4ss/Mods/Keybinds","ue4ss/Mods/Keybinds/Scripts","ue4ss/Mods/Keybinds/Scripts/main.lua","ue4ss/Mods/LineTraceMod","ue4ss/Mods/LineTraceMod/Scripts","ue4ss/Mods/LineTraceMod/Scripts/main.lua","ue4ss/Mods/mods.json","ue4ss/Mods/mods.txt","ue4ss/Mods/shared","ue4ss/Mods/shared/jsbProfiler","ue4ss/Mods/shared/jsbProfiler/jsbProfi.lua","ue4ss/Mods/shared/Types.lua","ue4ss/Mods/shared/UEHelpers","ue4ss/Mods/shared/UEHelpers/UEHelpers.lua","ue4ss/Mods/SplitScreenMod","ue4ss/Mods/SplitScreenMod/Scripts","ue4ss/Mods/SplitScreenMod/Scripts/main.lua","ue4ss/UE4SS-settings.ini","ue4ss/UE4SS.dll","ue4ss/UE4SS_Signatures","ue4ss/UE4SS_Signatures/FName_ToString.lua.example","ue4ss/UE4SS_Signatures/FText_Constructor.lua","ue4ss/UE4SS_Signatures/GNatives.lua","ue4ss/UE4SS_Signatures/GUObjectArray.lua","ue4ss/UE4SS_Signatures/GUObjectArray.lua.example","ue4ss/VTableLayout.ini"]
  ''';

  static const String defaultCnsManifestContent = r'''
  ["Binaries","Binaries/Win64","Binaries/Win64/ue4ss","Binaries/Win64/ue4ss/Mods","Binaries/Win64/ue4ss/Mods/DekCNS","Binaries/Win64/ue4ss/Mods/DekCNS/enabled.txt","Binaries/Win64/ue4ss/Mods/DekCNS/Scripts","Binaries/Win64/ue4ss/Mods/DekCNS/Scripts/config.lua","Binaries/Win64/ue4ss/Mods/DekCNS/Scripts/json.lua","Binaries/Win64/ue4ss/Mods/DekCNS/Scripts/main.lua","Binaries/Win64/ue4ss/nexus_info.json","Content","Content/Paks","Content/Paks/LogicMods","Content/Paks/LogicMods/DekCNS_P.pak","Content/Paks/LogicMods/DekCNS_P.ucas","Content/Paks/LogicMods/DekCNS_P.utoc","Content/Paks/~mods","Content/Paks/~mods/CustomNanosuitSystem","Content/Paks/~mods/CustomNanosuitSystem/DekCNS-DefaultAccessories.dekcns.json","Content/Paks/~mods/CustomNanosuitSystem/DekCNS-DefaultEarrings.dekcns.json","Content/Paks/~mods/CustomNanosuitSystem/DekCNS-DefaultFaces.dekcns.json","Content/Paks/~mods/CustomNanosuitSystem/DekCNS-DefaultHairs.dekcns.json","Content/Paks/~mods/CustomNanosuitSystem/DekCNS-DefaultOutfits.dekcns.json","Content/Paks/~mods/CustomNanosuitSystem/DekCNS-DefaultOutfitsAdam.dekcns.json","Content/Paks/~mods/CustomNanosuitSystem/DekCNS-DefaultOutfitsDrone.dekcns.json","Content/Paks/~mods/CustomNanosuitSystem/DekCNS-DefaultOutfitsLily.dekcns.json","Content/Paks/~mods/CustomNanosuitSystem/DekCNS-DefaultWeaponsTest.dekcns.json","Content/Paks/~mods/CustomNanosuitSystem/DekCNS-Defaults.dekcns.json"]
  ''';

  static Future<List<String>> generateInstallManifest(Directory sourceDir, String basePath) async {
    final List<String> paths = [];
    await for (final entity in sourceDir.list(recursive: true, followLinks: false)) {
      final relativePath = p.relative(entity.path, from: basePath);
      paths.add(relativePath.replaceAll(r'\', '/'));
    }
    return paths;
  }

  static Future<String?> getVersionFromCnsPackage(Directory sourceSBDir) async {
    try {
      final luaFile = File(
        p.join(sourceSBDir.path, 'Binaries', 'Win64', 'ue4ss', 'Mods', 'DekCNS', 'Scripts', 'main.lua'),
      );
      if (await luaFile.exists()) {
        final content = await luaFile.readAsString();
        final regex = RegExp(r'local CNS_Version = "(.+)"');
        final match = regex.firstMatch(content);
        if (match != null && match.group(1) != null) {
          return match.group(1);
        }
      }
    } catch (e) {
      print("No se pudo leer la versión del paquete CNS: $e");
    }
    return null;
  }

  static Future<void> uninstallCoreComponent({
    required bool isUe4ss,
    required String gameRootPath,
  }) async {
    final manifestName = isUe4ss ? 'ue4ss_manifest.json' : 'cns_manifest.json';
    final manifestFile = File(
      p.join(gameRootPath, 'SB', 'Binaries', 'Win64', '_manager_metadata', manifestName),
    );

    if (!await manifestFile.exists()) {
      throw Exception("Installation manifest not found. Cannot uninstall.");
    }

    final content = await manifestFile.readAsString();
    final List<String> relativePaths = List<String>.from(json.decode(content));

    final String baseDeletePath = isUe4ss
        ? p.join(gameRootPath, 'SB', 'Binaries', 'Win64')
        : p.join(gameRootPath, 'SB');

    for (final relativePath in relativePaths.reversed) {
      final fullPath = p.join(baseDeletePath, relativePath);
      try {
        final entityType = await FileSystemEntity.type(fullPath, followLinks: false);
        if (entityType == FileSystemEntityType.file) {
          await File(fullPath).delete();
        } else if (entityType == FileSystemEntityType.directory) {
          await Directory(fullPath).delete();
        }
      } catch (e) {
        print("Could not delete entity $fullPath: $e");
      }
    }

    await manifestFile.delete();
  }

  static Future<void> installUE4SS({
    required Directory sourceDir,
    required String gameRootPath,
  }) async {
    final manifestDir = Directory(p.join(gameRootPath, 'SB', 'Binaries', 'Win64', '_manager_metadata'));
    if (!await manifestDir.exists()) await manifestDir.create(recursive: true);
    final manifestFile = File(p.join(manifestDir.path, 'ue4ss_manifest.json'));

    final newPaths = await generateInstallManifest(sourceDir, sourceDir.path);
    Set<String> finalPaths = newPaths.toSet();
    
    if (await manifestFile.exists()) {
      try {
        final oldContent = await manifestFile.readAsString();
        finalPaths.addAll(List<String>.from(json.decode(oldContent)));
      } catch (e) {
        print("No se pudo leer el manifiesto antiguo de UE4SS, será reemplazado. Error: $e");
      }
    }

    await manifestFile.writeAsString(json.encode(finalPaths.toList()));

    final destinationDir = Directory(p.join(gameRootPath, 'SB', 'Binaries', 'Win64'));
    await FileManagerService.copyDirectory(sourceDir, destinationDir);
  }

  static Future<void> installCNS({
    required Directory sourceSBDir,
    required String gameRootPath,
  }) async {
    final manifestDir = Directory(p.join(gameRootPath, 'SB', 'Binaries', 'Win64', '_manager_metadata'));
    if (!await manifestDir.exists()) await manifestDir.create(recursive: true);
    final manifestFile = File(p.join(manifestDir.path, 'cns_manifest.json'));

    final newPaths = await generateInstallManifest(sourceSBDir, sourceSBDir.path);
    Set<String> finalPaths = newPaths.toSet();
    
    if (await manifestFile.exists()) {
      try {
        final oldContent = await manifestFile.readAsString();
        finalPaths.addAll(List<String>.from(json.decode(oldContent)));
      } catch (e) {
        print("No se pudo leer el manifiesto antiguo de CNS, será reemplazado. Error: $e");
      }
    }

    await manifestFile.writeAsString(json.encode(finalPaths.toList()));

    final destinationSBDir = Directory(p.join(gameRootPath, 'SB'));
    await FileManagerService.copyDirectory(sourceSBDir, destinationSBDir);
  }
}