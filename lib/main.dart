import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:win32_registry/win32_registry.dart';
import 'l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:window_manager/window_manager.dart';
import 'settings_page.dart';
import 'thumbnail_service.dart';
import 'notification_service.dart';
import 'package:translator/translator.dart';

class AppPrefs {
  static const String languageCode = 'languageCode';
  static const String gameRootPath = 'gameRootPath';
  static const String sevenZipPath = 'sevenZipPath';
  static const String nexusApiKey = 'nexusApiKey';
  static const String skippedVersions = 'skippedVersions';
  static const String filterMode = 'filterMode';
  static const String sortMode = 'sortMode';
  static const String viewMode = 'viewMode'; // New preference for view mode
}

// Data class to hold all information about a mod.
class ModInfo {
  final Directory directory;
  final String? nexusId;
  String? localVersion;
  final DateTime lastModified;
  final DateTime? installDate;
  bool isEnabled;
  final String? origin;
  final String displayName; // Internal identifier, not user-editable.
  String customName;      // User-editable name.
  final List<dynamic>? gallery; // Added to store image gallery info from Nexus Mods.
  final String? fitMeshType;
  final String? customCoverPath;
  final Alignment? customCoverAlignment;
  final DateTime? customCoverLastModified;
  final String? customVersion;
  final String? customFitMeshType;
  String? summary;   // Descripción/resumen del mod.
  final String? customSummary;
  final String? author;    // Autor del mod.
  final String? customAuthor;
  String? userNotes;     // Notas personales del usuario.
  final String? sourceUrl;
  final String? customSourceUrl;

  ModInfo({
    required this.directory,
    this.nexusId,
    this.localVersion,
    required this.lastModified,
    this.installDate,
    required this.isEnabled,
    this.origin,
    required this.displayName,
    required this.customName,
    this.gallery,
    this.fitMeshType,
    this.customCoverPath,
    this.customCoverAlignment,
    this.customCoverLastModified,
    this.customVersion,
    this.customFitMeshType,
    this.summary,
    this.customSummary,
    this.author,
    this.customAuthor,
    this.userNotes,
    this.sourceUrl,
    this.customSourceUrl,
  });


  static String? _extractVersionFromName(String name) {
    // Extracts a version number (e.g., 1.0.0) from a file/folder name (e.g., ModName v1.0.0)
    final regex = RegExp(r'\b[vV][\s-]?([0-9]+(\.[0-9a-zA-Z]+)*)');
    final match = regex.firstMatch(name);
    return match?.group(1);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(600, 660),
    size: Size(1100, 700),
    center: true,
    title: 'CNS Control Center',
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const ModInstallerApp());
}

class ModInstallerApp extends StatefulWidget {
  const ModInstallerApp({super.key});

  @override
  State<ModInstallerApp> createState() => _ModInstallerAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _ModInstallerAppState? state =
        context.findAncestorStateOfType<_ModInstallerAppState>();
    state?.setLocale(newLocale);
  }
}

class _ModInstallerAppState extends State<ModInstallerApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  void _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString(AppPrefs.languageCode);
    if (languageCode != null) {
      setState(() {
        _locale = Locale(languageCode);
      });
    }
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CNS Control Center',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey[700],
        scaffoldBackgroundColor: const Color(0xFF1e1e1e),
        cardColor: const Color(0xFF2d2d2d),
        colorScheme: const ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.teal,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const ModInstallerHomePage(),
    );
  }
}

class ModInstallerHomePage extends StatefulWidget {
  const ModInstallerHomePage({super.key});

  @override
  State<ModInstallerHomePage> createState() => _ModInstallerHomePageState();
}

class _UpdateCheckJob {
  final ModInfo? mod;
  final bool isCns;
  _UpdateCheckJob({this.mod, this.isCns = false});
}

class _PreparedMod {
  final Directory sourceDir;
  final String? nexusId;
  final String? nexusVersion;
  _PreparedMod({required this.sourceDir, this.nexusId, this.nexusVersion});
}

class _PreparedUE4SS {
  final Directory sourceDir;
  _PreparedUE4SS({required this.sourceDir});
}

enum ModFilter { all, enabled, disabled, repaired }
enum ModSort { name, date }
enum ModListViewMode { grid, list }

enum _AlternativeVersionAction { cancel, replace, installAsNew }

class _ModInstallerHomePageState extends State<ModInstallerHomePage> {
  static const String _defaultUe4ssManifestContent = r'''
["dwmapi.dll","ue4ss","ue4ss/Default_UVTD_Configs","ue4ss/Default_UVTD_Configs/Config","ue4ss/Default_UVTD_Configs/Config/case_preserving_variants.json","ue4ss/Default_UVTD_Configs/Config/member_rename_map.json","ue4ss/Default_UVTD_Configs/Config/object_items.json","ue4ss/Default_UVTD_Configs/Config/pdbs_to_dump.json","ue4ss/Default_UVTD_Configs/Config/private_variables.json","ue4ss/Default_UVTD_Configs/Config/types_not_to_dump.json","ue4ss/Default_UVTD_Configs/Config/uprefix_to_fprefix.json","ue4ss/Default_UVTD_Configs/Config/valid_udt_names.json","ue4ss/Default_UVTD_Configs/Config/virtual_generator_includes.json","ue4ss/LICENSE","ue4ss/Mods","ue4ss/Mods/ActorDumperMod","ue4ss/Mods/ActorDumperMod/Scripts","ue4ss/Mods/ActorDumperMod/Scripts/main.lua","ue4ss/Mods/BPML_GenericFunctions","ue4ss/Mods/BPML_GenericFunctions/Scripts","ue4ss/Mods/BPML_GenericFunctions/Scripts/main.lua","ue4ss/Mods/BPModLoaderMod","ue4ss/Mods/BPModLoaderMod/load_order.txt","ue4ss/Mods/BPModLoaderMod/Scripts","ue4ss/Mods/BPModLoaderMod/Scripts/main.lua","ue4ss/Mods/CheatManagerEnablerMod","ue4ss/Mods/CheatManagerEnablerMod/Scripts","ue4ss/Mods/CheatManagerEnablerMod/Scripts/main.lua","ue4ss/Mods/ConsoleCommandsMod","ue4ss/Mods/ConsoleCommandsMod/Scripts","ue4ss/Mods/ConsoleCommandsMod/Scripts/dump_object.lua","ue4ss/Mods/ConsoleCommandsMod/Scripts/main.lua","ue4ss/Mods/ConsoleCommandsMod/Scripts/set.lua","ue4ss/Mods/ConsoleCommandsMod/Scripts/summon_unloaded_assets.lua","ue4ss/Mods/ConsoleEnablerMod","ue4ss/Mods/ConsoleEnablerMod/Scripts","ue4ss/Mods/ConsoleEnablerMod/Scripts/main.lua","ue4ss/Mods/jsbLuaProfilerMod","ue4ss/Mods/jsbLuaProfilerMod/Scripts","ue4ss/Mods/jsbLuaProfilerMod/Scripts/main.lua","ue4ss/Mods/Keybinds","ue4ss/Mods/Keybinds/Scripts","ue4ss/Mods/Keybinds/Scripts/main.lua","ue4ss/Mods/LineTraceMod","ue4ss/Mods/LineTraceMod/Scripts","ue4ss/Mods/LineTraceMod/Scripts/main.lua","ue4ss/Mods/mods.json","ue4ss/Mods/mods.txt","ue4ss/Mods/shared","ue4ss/Mods/shared/jsbProfiler","ue4ss/Mods/shared/jsbProfiler/jsbProfi.lua","ue4ss/Mods/shared/Types.lua","ue4ss/Mods/shared/UEHelpers","ue4ss/Mods/shared/UEHelpers/UEHelpers.lua","ue4ss/Mods/SplitScreenMod","ue4ss/Mods/SplitScreenMod/Scripts","ue4ss/Mods/SplitScreenMod/Scripts/main.lua","ue4ss/UE4SS-settings.ini","ue4ss/UE4SS.dll","ue4ss/UE4SS_Signatures","ue4ss/UE4SS_Signatures/FName_ToString.lua.example","ue4ss/UE4SS_Signatures/FText_Constructor.lua","ue4ss/UE4SS_Signatures/GNatives.lua","ue4ss/UE4SS_Signatures/GUObjectArray.lua","ue4ss/UE4SS_Signatures/GUObjectArray.lua.example","ue4ss/VTableLayout.ini"]
  ''';

  static const String _defaultCnsManifestContent = r'''
["Binaries","Binaries/Win64","Binaries/Win64/ue4ss","Binaries/Win64/ue4ss/Mods","Binaries/Win64/ue4ss/Mods/DekCNS","Binaries/Win64/ue4ss/Mods/DekCNS/enabled.txt","Binaries/Win64/ue4ss/Mods/DekCNS/Scripts","Binaries/Win64/ue4ss/Mods/DekCNS/Scripts/config.lua","Binaries/Win64/ue4ss/Mods/DekCNS/Scripts/json.lua","Binaries/Win64/ue4ss/Mods/DekCNS/Scripts/main.lua","Binaries/Win64/ue4ss/nexus_info.json","Content","Content/Paks","Content/Paks/LogicMods","Content/Paks/LogicMods/DekCNS_P.pak","Content/Paks/LogicMods/DekCNS_P.ucas","Content/Paks/LogicMods/DekCNS_P.utoc","Content/Paks/~mods","Content/Paks/~mods/CustomNanosuitSystem","Content/Paks/~mods/CustomNanosuitSystem/DekCNS-DefaultAccessories.dekcns.json","Content/Paks/~mods/CustomNanosuitSystem/DekCNS-DefaultEarrings.dekcns.json","Content/Paks/~mods/CustomNanosuitSystem/DekCNS-DefaultFaces.dekcns.json","Content/Paks/~mods/CustomNanosuitSystem/DekCNS-DefaultHairs.dekcns.json","Content/Paks/~mods/CustomNanosuitSystem/DekCNS-DefaultOutfits.dekcns.json","Content/Paks/~mods/CustomNanosuitSystem/DekCNS-DefaultOutfitsAdam.dekcns.json","Content/Paks/~mods/CustomNanosuitSystem/DekCNS-DefaultOutfitsDrone.dekcns.json","Content/Paks/~mods/CustomNanosuitSystem/DekCNS-DefaultOutfitsLily.dekcns.json","Content/Paks/~mods/CustomNanosuitSystem/DekCNS-DefaultWeaponsTest.dekcns.json","Content/Paks/~mods/CustomNanosuitSystem/DekCNS-Defaults.dekcns.json"]
  ''';
  final List<_PreparedMod> _preparedMods = [];
  _PreparedUE4SS? _preparedUE4SS;
  Map<String, List<String>> _modsToInstallPreviewMap = {};

  String _statusMessage = '';
  Color _statusColor = Colors.white;
  bool _isLoading = true;

  List<ModInfo> _allMods = [];

  final _searchController = TextEditingController();
  String _searchQuery = '';

  bool _isDragging = false;
  Directory? _tempExtractionDir;

  String? _gameRootPath;
  String? _finalModsPath;

  String? _7zipPath;

  String? _apiKey;

  List<String> _lastInstalledModNames = [];

  String _appVersion = '';

  String? _cnsVersion;
  String? _cnsNexusId;
  Map<String, dynamic>? _cnsUpdateInfo;

  final Map<String, Map<String, dynamic>> _modUpdates = {};
  final Set<String> _ignoredUpdates = {};
  bool _isCheckingForUpdates = false;

  Map<String, String> _skippedVersions = {};
  Map<String, dynamic> _modDatabase = {};
  
  bool _isExtracting = false;
  double _extractionProgress = 0.0;
  String _extractionStatus = '';

  ModFilter _currentFilter = ModFilter.all;
  ModSort _currentSort = ModSort.date;
  ModListViewMode _viewMode = ModListViewMode.grid;

  bool _isUe4ssInstalled = false;
  bool _isCnsCoreInstalled = false;

  // ++ THUMBNAIL SERVICE INSTANCE ++
  final ThumbnailService _thumbnailService = ThumbnailService();


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_statusMessage.isEmpty && mounted) {
      _statusMessage = AppLocalizations.of(context)!.statusSearchingGame;
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    try {
      if (_tempExtractionDir != null && _tempExtractionDir!.existsSync()) {
        _tempExtractionDir!.deleteSync(recursive: true);
      }
    } catch (e) {
      print('Could not clean up temporary directory on exit: $e');
    }
    super.dispose();
  }

  Future<void> _initialize() async {
    await _getAppVersion();
    await _thumbnailService.initialize(); // ++ INITIALIZE THUMBNAIL SERVICE ++
    await _cleanUpOrphanedTempDirs();
    await _loadModDatabase();
    await _find7zipPath();
    await _loadApiKey();
    await _loadSkippedVersions();
    await _loadPrefs();
    await _findGamePath();

    if (_finalModsPath != null) {
      await _checkCoreInstallations();
      await _migrateModFolders();
      await _loadAllMods();
      await _readCNSData();
    }
  }

  /// Verifica la existencia de manifiestos para determinar si UE4SS y CNS están instalados.
  Future<void> _checkCoreInstallations() async {
  if (_gameRootPath == null) return;
  final l10n = AppLocalizations.of(context)!;

  final win64Dir = Directory(p.join(_gameRootPath!, 'SB', 'Binaries', 'Win64'));
  final metadataDir = Directory(p.join(win64Dir.path, '_manager_metadata'));

  final ue4ssManifest = File(p.join(metadataDir.path, 'ue4ss_manifest.json'));
  final cnsManifest = File(p.join(metadataDir.path, 'cns_manifest.json'));

  // --- Lógica de Detección y Adopción ---

  // 1. Adoptar UE4SS si no tiene manifiesto pero sí la carpeta clave.
  if (!await ue4ssManifest.exists()) {
    final ue4ssTriggerDir = Directory(p.join(win64Dir.path, 'ue4ss', 'Mods', 'ConsoleCommandsMod'));
    if (await ue4ssTriggerDir.exists()) {
      print("Adopting existing UE4SS installation...");
      if (!await metadataDir.exists()) await metadataDir.create(recursive: true);
      await ue4ssManifest.writeAsString(_defaultUe4ssManifestContent);
      if (mounted) {
        NotificationService.instance.show(
            context: context,
            type: NotificationType.info,
            title: l10n.ue4ssInstallationDetected,
        );
      }
    }
  }

  // 2. Adoptar CNS si no tiene manifiesto pero sí la carpeta clave.
  if (!await cnsManifest.exists()) {
    final cnsTriggerDir = Directory(p.join(win64Dir.path, 'ue4ss', 'Mods', 'DekCNS'));
    if (await cnsTriggerDir.exists()) {
      print("Adopting existing CNS installation...");
      if (!await metadataDir.exists()) await metadataDir.create(recursive: true);
      await cnsManifest.writeAsString(_defaultCnsManifestContent);
      if (mounted) {
        NotificationService.instance.show(
            context: context,
            type: NotificationType.info,
            title: l10n.cnsInstallationDetected,
        );
      }
    }
  }

  // --- Lógica final para actualizar la UI ---
  // Esto se ejecuta siempre, reflejando los manifiestos existentes o los que se acaban de crear.
  setState(() {
    _isUe4ssInstalled = ue4ssManifest.existsSync();
    _isCnsCoreInstalled = cnsManifest.existsSync();
  });
}

  /// Recorre un directorio de forma recursiva y devuelve una lista de rutas relativas.
  Future<List<String>> _generateInstallManifest(Directory sourceDir, String basePath) async {
    final List<String> paths = [];
    await for (final entity in sourceDir.list(recursive: true, followLinks: false)) {
      final relativePath = p.relative(entity.path, from: basePath);
      paths.add(relativePath.replaceAll(r'\', '/')); // Normalizar a slashes
    }
    return paths;
  }

  /// Desinstala un componente principal (UE4SS o CNS) leyendo su manifiesto.
  Future<bool> _uninstallCoreComponent({required bool isUe4ss}) async {
  final l10n = AppLocalizations.of(context)!;
  final componentName = isUe4ss ? "UE4SS" : "CNS";

  // Si se intenta desinstalar UE4SS mientras CNS aún está instalado...
  if (isUe4ss && _isCnsCoreInstalled) {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: Text(l10n.uninstallDependencyTitle),
        content: Text(l10n.uninstallDependencyContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.dialogActionUnderstood),
          ),
        ],
      ),
    );
    return false; // Detiene la desinstalación.
  }
  
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF2a2a2a),
      title: Text(l10n.dialogTitleUninstall(componentName)),
      content: Text(l10n.dialogContentUninstall(componentName)),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.dialogActionCancel)),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
          child: Text(l10n.dialogActionUninstall),
        ),
      ],
    ),
  );

  if (confirm != true) return false;
  
  setState(() { _isLoading = true; _statusMessage = l10n.statusUninstalling(componentName); });

  try {
    if (_gameRootPath == null) throw Exception("Game path not found.");
    
    final manifestName = isUe4ss ? 'ue4ss_manifest.json' : 'cns_manifest.json';
    final manifestFile = File(p.join(_gameRootPath!, 'SB', 'Binaries', 'Win64', '_manager_metadata', manifestName));
    
    if (!await manifestFile.exists()) {
      throw Exception("Installation manifest not found. Cannot uninstall.");
    }
    
    final content = await manifestFile.readAsString();
    final List<String> relativePaths = List<String>.from(json.decode(content));
    
    final String baseDeletePath = isUe4ss
      ? p.join(_gameRootPath!, 'SB', 'Binaries', 'Win64')
      : p.join(_gameRootPath!, 'SB');

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
    
    NotificationService.instance.show(
      context: context, type: NotificationType.success, title: l10n.snackBarUninstalled(componentName),
    );
    
    return true; // <-- INFORMA QUE LA OPERACIÓN FUE EXITOSA
    
  } catch (e) {
    NotificationService.instance.show(
      context: context, type: NotificationType.error, title: l10n.errorUninstalling(componentName), description: e.toString(),
    );
    return false; // <-- INFORMA QUE LA OPERACIÓN FALLÓ
  } finally {
    await _checkCoreInstallations();
    await _readCNSData();
    setState(() { _isLoading = false; _statusMessage = ""; });
  }
}

  Future<List<File>> _findAllModFilesRecursive(Directory dir) async {
    final List<File> foundFiles = [];
    const validExtensions = ['.json', '.pak', '.ucas', '.utoc'];
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File &&
          validExtensions.contains(p.extension(entity.path).toLowerCase())) {
        foundFiles.add(entity);
      }
    }
    return foundFiles;
  }

  Future<void> _cleanUpOrphanedTempDirs() async {
    try {
      final tempDir = Directory.systemTemp;
      // Asynchronously checks the contents of the system's temporary directory.
      await for (final entity in tempDir.list()) {
        // If an entity is a folder and its name starts with "mod_manager_", delete it.
        if (entity is Directory &&
            p.basename(entity.path).startsWith('mod_manager_')) {
          try {
            await entity.delete(recursive: true);
          } catch (e) {
            // Ignore errors if a specific folder cannot be deleted (it might be in use).
            print('Could not delete orphan directory ${entity.path}: $e');
          }
        }
      }
    } catch (e) {
      print('An error occurred during general cleanup of temporary folders: $e');
    }
  }
  
  Future<void> _showRepairedModInfoDialog() async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: Text(l10n.dialogTitleRepairedModWarning),
        content: Text(l10n.dialogContentRepairedModWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.dialogActionClose),
          ),
        ],
      ),
    );
  }

  Future<void> _migrateModFolders() async {
    setState(() {
      _statusMessage = "Verifying integrity of mods...";
      _isLoading = true;
    });

    Future<List<Map<String, dynamic>>> _scanForMigration(String path) async {
      final dir = Directory(path);
      if (!await dir.exists()) return [];

      final List<Map<String, dynamic>> tasks = [];
      List<FileSystemEntity> entities;
      try {
        entities = dir.listSync(); 
      } catch (e) {
        print("Error listing directory $path: $e");
        return [];
      }

      for (var entity in entities) {
        if (entity is Directory) {
           if (p.basename(entity.path) == '__MOD_BACKUPS__') continue;
          
          final infoFile = File(p.join(entity.path, 'nexus_info.json'));
          if (await infoFile.exists()) {
            try {
              final content = await infoFile.readAsString();
              Map<String, dynamic> data = json.decode(content);

              if (data['customName'] == null && data['displayName'] != null) {
                final String newFolderName = data['displayName'].replaceAll(RegExp(r'[\\/:*?"<>|]'), '-');
                tasks.add({
                  'oldPath': entity.path,
                  'newPath': p.join(entity.parent.path, newFolderName),
                  'jsonData': data,
                });
              }
            } catch (e) {
              print('Error scanning ${entity.path} for migration: $e');
            }
          }
        }
      }
      return tasks;
    }

    final List<Map<String, dynamic>> allTasks = [];
    if (_finalModsPath != null) {
      allTasks.addAll(await _scanForMigration(_finalModsPath!));
    }
    if (_gameRootPath != null) {
      final backupDirPath = p.join(_gameRootPath!, 'SB', 'Content', '__MOD_BACKUPS__');
      allTasks.addAll(await _scanForMigration(backupDirPath));
    }
    
    if (allTasks.isNotEmpty) {
      print('Found ${allTasks.length} mods to migrate.');
      for (final task in allTasks) {
        try {
          final oldPath = task['oldPath'] as String;
          final newPath = task['newPath'] as String;
          final jsonData = task['jsonData'] as Map<String, dynamic>;

          Directory newDirHandle = Directory(newPath);
          if (oldPath != newPath) {
            if (await Directory(newPath).exists()) {
              print('Migration conflict: Destination folder "$newPath" already exists. Skipping rename for "$oldPath".');
              newDirHandle = Directory(oldPath);
            } else {
               await Directory(oldPath).rename(newPath);
               print('Renamed: $oldPath -> $newPath');
            }
          }
          
          final infoFile = File(p.join(newDirHandle.path, 'nexus_info.json'));
          jsonData['customName'] = jsonData['displayName'];
          jsonData['managerVersion'] = _appVersion; 
          
          final encoder = JsonEncoder.withIndent('  ');
          await infoFile.writeAsString(encoder.convert(jsonData));

        } catch (e) {
          print('Migration failed for ${task['oldPath']}: $e');
        }
      }
      print('Migration complete.');
    }
  }

  Future<void> _loadModDatabase() async {
    try {
      final String content = await rootBundle.loadString('mod_database.json');
      final data = json.decode(content);
      if (data is Map<String, dynamic>) {
        setState(() {
          _modDatabase = data;
        });
        print('Local mod database loaded successfully.');
      }
    } catch (e) {
      print('Could not find or read mod_database.json, skipping: $e');
    }
  }

  Future<void> _loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _apiKey = prefs.getString(AppPrefs.nexusApiKey);
    });
  }

  Future<void> _saveApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppPrefs.nexusApiKey, apiKey);
    setState(() {
      _apiKey = apiKey;
    });
  }
  
  Future<void> _loadSkippedVersions() async {
    final prefs = await SharedPreferences.getInstance();
    final skippedList = prefs.getStringList(AppPrefs.skippedVersions) ?? [];
    setState(() {
      _skippedVersions = {
        for (var e in skippedList) e.split(';')[0]: e.split(';')[1]
      };
    });
  }

  Future<void> _saveSkippedVersions() async {
    final prefs = await SharedPreferences.getInstance();
    final skippedList =
        _skippedVersions.entries.map((e) => '${e.key};${e.value}').toList();
    await prefs.setStringList(AppPrefs.skippedVersions, skippedList);
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final filterIndex = prefs.getInt(AppPrefs.filterMode) ?? ModFilter.all.index;
    final sortIndex = prefs.getInt(AppPrefs.sortMode) ?? ModSort.date.index;
    final viewModeIndex = prefs.getInt(AppPrefs.viewMode) ?? ModListViewMode.grid.index;

    setState(() {
      _currentFilter = ModFilter.values[filterIndex];
      _currentSort = ModSort.values[sortIndex];
      _viewMode = ModListViewMode.values[viewModeIndex];
    });
  }

  Future<void> _removeSkippedVersion(String nexusId) async {
    setState(() {
      _skippedVersions.remove(nexusId);
    });
    await _saveSkippedVersions();
    if (mounted) {
      NotificationService.instance.show(
        context: context,
        type: NotificationType.info,
        title: AppLocalizations.of(context)!.snackBarSkippedVersionRemoved,
      );
      
    }
  }

  Future<bool> _validateApiKey(String apiKey) async {
    if (apiKey.isEmpty) {
      return false;
    }
    try {
      final response = await http.get(
        Uri.parse('https://api.nexusmods.com/v1/users/validate.json'),
        headers: {
          'apikey': apiKey,
          'accept': 'application/json',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error validating API key: $e');
      return false;
    }
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }
  
  Future<void> _find7zipPath() async {
    final prefs = await SharedPreferences.getInstance();
    String? saved7zipPath = prefs.getString(AppPrefs.sevenZipPath);
    
    if (saved7zipPath != null && await File(saved7zipPath).exists()) {
      setState(() => _7zipPath = saved7zipPath);
      return;
    }

    const List<String> possiblePaths = [
      r'C:\Program Files\7-Zip\7z.exe',
      r'C:\Program Files (x86)\7-Zip\7z.exe',
    ];
    for (final path in possiblePaths) {
      if (await File(path).exists()) {
        setState(() => _7zipPath = path);
        return;
      }
    }
  }
  
  Future<String?> _select7zipPathManually() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['exe'],
        dialogTitle: 'Select the 7z.exe file',
      );
      if (result != null && result.files.single.path != null) {
        final newPath = result.files.single.path!;
        if (p.basename(newPath).toLowerCase() != '7z.exe') {
          if (mounted) {
            NotificationService.instance.show(
              context: context,
              type: NotificationType.error,
              title: AppLocalizations.of(context)!.snackBar7zipPathInvalid,
            );
          }
          return null;
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppPrefs.sevenZipPath, newPath);
        setState(() {
          _7zipPath = newPath;
        });
        if (mounted) {
            NotificationService.instance.show(
              context: context,
              type: NotificationType.success,
              title: AppLocalizations.of(context)!.snackBar7zipPathSaved,
            );
        }
        return newPath;
      }
    } catch (e) {
       setState(() => _statusMessage = 'Error selecting 7-Zip: $e');
    }
    return null;
  }


  Future<void> _findGamePath() async {
    setState(() {
      _isLoading = true;
      if (mounted) {
        _statusMessage = AppLocalizations.of(context)!.statusSearchingGame;
      }
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      String? savedPath = prefs.getString(AppPrefs.gameRootPath);
      String? gamePath;

      if (savedPath != null && await Directory(savedPath).exists()) {
        final validationPath = p.join(savedPath, 'SB', 'Content', 'Paks');
        if (await Directory(validationPath).exists()) {
          gamePath = savedPath;
        }
      }

      gamePath ??= await _findSteamInstallation();

      if (gamePath != null && await Directory(gamePath).exists()) {
        final modPath = p.join(
            gamePath, 'SB', 'Content', 'Paks', '~mods', 'CustomNanosuitSystem');
        setState(() {
          _gameRootPath = gamePath;
          _finalModsPath = modPath;
          if (mounted) {
            _statusMessage = AppLocalizations.of(context)!.statusGamePathFound;
          }
        });
      } else {
        setState(() {
          _finalModsPath = null;
          if (mounted) {
            _statusMessage = AppLocalizations.of(context)!.statusGamePathNotFound;
          }
          _statusColor = Colors.orangeAccent;
        });
      }
    } catch (e) {
      setState(() {
        _finalModsPath = null;
        if (mounted) {
          _statusMessage = AppLocalizations.of(context)!.statusErrorFindingGame(e.toString());
        }
        _statusColor = Colors.redAccent;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<String?> _findSteamInstallation() async {
    if (!Platform.isWindows) return null;
    try {
      final key = Registry.openPath(RegistryHive.currentUser,
          path: r'Software\Valve\Steam');
      final steamPath = key.getValueAsString('SteamPath');
      key.close();

      if (steamPath == null) return null;

      final List<String> libraryPaths = [steamPath];
      final libraryFoldersVdf =
          File(p.join(steamPath, 'steamapps', 'libraryfolders.vdf'));

      if (await libraryFoldersVdf.exists()) {
        final content = await libraryFoldersVdf.readAsString();
        final regex = RegExp(r'"path"\s+"(.+)"');
        final matches = regex.allMatches(content);
        for (final match in matches) {
          final path = match.group(1)!.replaceAll(r'\\', r'\');
          libraryPaths.add(path);
        }
      }

      for (final libPath in libraryPaths.toSet()) {
        final gamePath =
            p.join(libPath, 'steamapps', 'common', 'StellarBlade');
        if (await Directory(gamePath).exists()) {
          return gamePath;
        }
      }
    } catch (e) {
      print("Error searching Steam registry: $e");
      return null;
    }
    return null;
  }

  Future<String?> _readCNSData() async {
  if (_gameRootPath == null) {
    setState(() {
      _cnsVersion = null;
      _cnsNexusId = null;
    });
    return null;
  }

  // Primero, reinicia la versión a null.
  // Si no se encuentran los archivos, este será el valor final.
  setState(() {
    _cnsVersion = null;
    _cnsNexusId = null;
  });

  String? newVersion;

  // Intenta leer desde nexus_info.json (fuente principal)
  try {
    final infoFile = File(p.join(_gameRootPath!, 'SB', 'Binaries', 'Win64', 'ue4ss', 'nexus_info.json'));
    if (await infoFile.exists()) {
      final content = await infoFile.readAsString();
      final data = json.decode(content);
      setState(() {
        _cnsNexusId = data['nexusId'];
        _cnsVersion = data['installedVersion'];
      });
      newVersion = data['installedVersion'];
      return newVersion; // Versión encontrada, terminamos aquí.
    }
  } catch (e) {
    print('Error reading CNS nexus_info.json: $e');
  }

  // Si no se encontró arriba, intenta leer desde el archivo main.lua
  try {
    final luaFile = File(p.join(_gameRootPath!, 'SB', 'Binaries', 'Win64', 'ue4ss', 'Mods', 'DekCNS', 'Scripts', 'main.lua'));
    if (await luaFile.exists()) {
      final content = await luaFile.readAsString();
      final regex = RegExp(r'local CNS_Version = "(.+)"');
      final match = regex.firstMatch(content);
      if (match != null && match.group(1) != null) {
        setState(() {
          _cnsVersion = match.group(1);
        });
        newVersion = match.group(1);
      }
    }
  } catch (e) {
    print('Error reading CNS version from LUA: $e');
  }

  return newVersion;
}

  Future<String?> _selectGamePathManually() async {
    try {
      String? result = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Please select the main StellarBlade folder',
      );
      if (result != null) {
        final validationPath = p.join(result, 'SB', 'Content', 'Paks');
        if (await Directory(validationPath).exists()) {
          final modPath = p.join(
              result, 'SB', 'Content', 'Paks', '~mods', 'CustomNanosuitSystem');
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(AppPrefs.gameRootPath, result);
          setState(() {
            _gameRootPath = result;
            _finalModsPath = modPath;
          });
          if (mounted) {
            NotificationService.instance.show(
              context: context,
              type: NotificationType.success,
              title: AppLocalizations.of(context)!.snackBarGamePathSaved,
            );
          }
          await _initialize();
          return result;
        } else {
          if(mounted) {
            NotificationService.instance.show(
              context: context,
              type: NotificationType.error,
              title: AppLocalizations.of(context)!.snackBarGamePathInvalid,
            );
          }
          setState(() {
            _statusMessage =
                'The selected folder does not seem to be correct. Please try again.';
            _statusColor = Colors.redAccent;
          });
        }
      }
    } catch (e) {
      setState(() => _statusMessage = 'Error selecting folder: $e');
    }
    return null;
  }
  
  Future<String?> _getVersionFromModJsonDescription(Directory modDir) async {
    try {
      await for (final file in modDir.list()) {
        if (file is File && p.extension(file.path).toLowerCase() == '.json') {
          final jsonString = await file.readAsString();
          final jsonDecoded = json.decode(jsonString.replaceAll(RegExp(r',\s*(?=[\}\]])'), ''));
          if (jsonDecoded is List && jsonDecoded.isNotEmpty) {
            final modInfo = jsonDecoded[0] as Map<String, dynamic>;
            final description = modInfo['Description'] as String?;
            if (description != null) {
              return ModInfo._extractVersionFromName(description);
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
  
  String _stripVersionFromFolderName(String name) {
    final regex = RegExp(r'\s+[vV]?\d+(\.\d+)*(-[a-zA-Z0-9]+)?\s*$', caseSensitive: false);
    return name.replaceAll(regex, '').trim();
  }
  
  Future<void> _loadAllMods({bool clearHighlight = true}) async {
    if (_finalModsPath == null) return;
    setState(() {
      _isLoading = true;
      if (clearHighlight) {
        _lastInstalledModNames.clear();
      }
    });

    // Esta función interna procesa un directorio (mods activados o desactivados)
    Future<List<ModInfo>> getModsFromDirectory(String path, bool isEnabled) async {
      final dir = Directory(path);
      if (!await dir.exists()) return [];

      final List<ModInfo> mods = [];
      await for (var entity in dir.list()) {
        if (entity is Directory) {
          if (p.basename(entity.path) == '__MOD_BACKUPS__') continue;
          try {
            // Inicializa todas las variables que vamos a leer.
            String? nexusId;
            String? installedVersion;
            String? origin;
            List<dynamic>? gallery;
            String? fitMeshType;
            String? customCoverPath;
            Alignment? customCoverAlignment;
            DateTime? customCoverLastModified;
            String folderName = p.basename(entity.path);
            String displayName = _stripVersionFromFolderName(folderName);
            String customName = folderName;
            DateTime modLastModified = DateTime.now();
            String? customVersion;
            String? customFitMeshType;
            String? summary;
            String? customSummary;
            String? author;
            String? customAuthor;
            String? userNotes;
            String? sourceUrl;
            String? customSourceUrl;

            final infoFile = File(p.join(entity.path, 'nexus_info.json'));
            final fileStat = await entity.stat(); // <-- Move this up so it's always assigned
            if (await infoFile.exists()) {
                final content = await infoFile.readAsString();
                Map<String, dynamic> data = json.decode(content);

                // --- INICIO DE LA LÓGICA DE ACTUALIZACIÓN AUTOMÁTICA ---
                final String? modManagerVersion = data['managerVersion'];
                final String? nexusIdForCheck = data['nexusId'];
                
                bool needsMetadataUpdate = modManagerVersion == null || (_compareVersions(_appVersion, modManagerVersion) > 0);

                if (needsMetadataUpdate && nexusIdForCheck != null) {
                  print('Auto-updating metadata for mod: ${data['displayName']}');
                  final nexusData = await _fetchNexusModData(nexusIdForCheck);

                  if (nexusData != null) {
                    data['summary'] ??= nexusData['summary'];
                    data['author'] ??= nexusData['author'];
                    data['gallery'] ??= nexusData['gallery'];
                    // ✅ LÍNEA AÑADIDA: Asegura que la URL de origen exista.
                    data['sourceUrl'] ??= 'https://www.nexusmods.com/stellarblade/mods/$nexusIdForCheck';
                    data['managerVersion'] = _appVersion; 

                    final encoder = JsonEncoder.withIndent('  ');
                    await infoFile.writeAsString(encoder.convert(data));
                    print('...metadata for ${data['displayName']} updated successfully.');
                  }
                }
                // --- FIN DE LA LÓGICA DE ACTUALIZACIÓN ---
                DateTime? installDate;
            if (data['installDate'] != null) {
              installDate = DateTime.tryParse(data['installDate']);
            }
            // Usa la fecha de instalación si existe, si no, usa la fecha de modificación de la carpeta
            modLastModified = installDate ?? fileStat.modified;
                // Leemos los datos del mapa 'data' (que ahora puede estar actualizado)
                nexusId = data['nexusId'];
                installedVersion = data['installedVersion'];
                origin = data['origin'];
                gallery = data['gallery'];
                fitMeshType = data['fitMeshType'];
                summary = data['summary'];
                customSummary = data['customSummary'];
                author = data['author'];
                customAuthor = data['customAuthor'];
                userNotes = data['userNotes'];
                sourceUrl = data['sourceUrl'];
                customSourceUrl = data['customSourceUrl'];

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

                if (data['displayName'] != null) {
                  displayName = data['displayName'];
                }
                if (data['customName'] != null) {
                  customName = data['customName'];
                } else {
                  customName = displayName;
                }
            }

            // Lógica de fallback si el nexus_info.json no existe o está incompleto
            if (fitMeshType == null) {
              fitMeshType = await _getFitMeshTypeForMod(entity);
              if (fitMeshType != null && await infoFile.exists()) {
                try {
                  final content = await infoFile.readAsString();
                  Map<String, dynamic> data = json.decode(content);
                  data['fitMeshType'] = fitMeshType;
                  final encoder = JsonEncoder.withIndent('  ');
                  await infoFile.writeAsString(encoder.convert(data));
                } catch (e) {
                  print("Could not update nexus_info.json with FitMeshType for ${entity.path}: $e");
                }
              }
            }
            installedVersion ??= ModInfo._extractVersionFromName(folderName);

            // final fileStat = await entity.stat(); <-- Already declared above

            // Añade el mod a la lista con toda la información cargada (y potencialmente actualizada)
            mods.add(ModInfo(
              directory: entity,
              nexusId: nexusId,
              localVersion: installedVersion,
              lastModified: modLastModified,
              isEnabled: isEnabled,
              origin: origin,
              displayName: displayName,
              customName: customName,
              gallery: gallery,
              fitMeshType: fitMeshType,
              customCoverPath: customCoverPath,
              customCoverAlignment: customCoverAlignment,
              customCoverLastModified: customCoverLastModified,
              customVersion: customVersion,
              customFitMeshType: customFitMeshType,
              summary: summary,
              customSummary: customSummary,
              author: author,
              customAuthor: customAuthor,
              userNotes: userNotes,
              sourceUrl: sourceUrl,
              customSourceUrl: customSourceUrl,
            ));
          } catch (e) {
            print("Error processing directory ${entity.path}: $e");
          }
        }
      }
      return mods;
    }

    try {
      final enabledMods = await getModsFromDirectory(_finalModsPath!, true);

      if (_gameRootPath == null) {
        final disabledMods = <ModInfo>[];
        setState(() {
         _allMods = [...enabledMods, ...disabledMods];
        });
        return;
      }
      final backupDirPath = p.join(_gameRootPath!, 'SB', 'Content', '__MOD_BACKUPS__');
      final disabledMods = await getModsFromDirectory(backupDirPath, false);

      setState(() {
        _allMods = [...enabledMods, ...disabledMods];
        if (clearHighlight && mounted) {
          _statusMessage = AppLocalizations.of(context)!
              .statusModsFound(disabledMods.length, enabledMods.length);
          _statusColor = Colors.white;
        }
      });
    } catch (e) {
      setState(() {
        if (mounted) {
          _statusMessage = AppLocalizations.of(context)!.statusErrorReadingMods(e.toString());
        }
        _statusColor = Colors.redAccent;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showSelfHealConfirmationDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: Text(l10n.dialogTitleRepairMods),
        content: Text(l10n.dialogContentRepairMods),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.dialogActionCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.tealAccent),
            child: Text(l10n.dialogActionRunRepair),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _runSelfHealing();
    }
  }

  Future<void> _runSelfHealing() async {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(l10n.snackBarRepairStarted),
      backgroundColor: Colors.blueGrey,
    ));

    setState(() => _isLoading = true);

    int repairedCount = 0;
    for (final mod in List.from(_allMods)) {
      final infoFile = File(p.join(mod.directory.path, 'nexus_info.json'));

      // --- INICIO DE LA LÓGICA MEJORADA ---
      bool needsRepair = false;
      if (await infoFile.exists()) {
        try {
          final content = await infoFile.readAsString();
          // Si el archivo está vacío o no es un JSON válido, necesita reparación.
          if (content.trim().isEmpty) {
            needsRepair = true;
          } else {
            final data = json.decode(content) as Map<String, dynamic>;
            final nexusId = data['nexusId'] as String?;
            // Si el nexusId es nulo o una cadena vacía, necesita reparación.
            if (nexusId == null || nexusId.isEmpty) {
              needsRepair = true;
            }
          }
        } catch (e) {
          // Si el JSON está mal formado, también necesita reparación.
          print('Found malformed nexus_info.json for ${mod.customName}, scheduling for repair. Error: $e');
          needsRepair = true;
        }
      } else {
        // Si el archivo no existe, definitivamente necesita reparación.
        needsRepair = true;
      }

      // Si después de todas las comprobaciones no necesita reparación, pasa al siguiente mod.
      if (!needsRepair) {
        continue;
      }
      // --- FIN DE LA LÓGICA MEJORADA ---

      final primaryDisplayName = await _getDisplayNameForMod(mod.directory);
      if (primaryDisplayName != null && _modDatabase.containsKey(primaryDisplayName)) {
        final dbEntry = _modDatabase[primaryDisplayName] as Map<String, dynamic>;
        final nexusId = dbEntry['nexusId'] as String?;

        if (nexusId == null) continue;

        String? version = ModInfo._extractVersionFromName(p.basename(mod.directory.path));
        version ??= await _getVersionFromModJsonDescription(mod.directory);

        if (version == null) {
          if (_apiKey == null || _apiKey!.isEmpty) {
            if (mounted) {
              NotificationService.instance.show(
                context: context,
                type: NotificationType.error,
                title: l10n.errorApiRequiredForRepair,
              );
            }
            break; 
          }
          version = await _fetchLatestModVersion(nexusId);
        }
        
        final compositeDisplayName = await _getCompositeDisplayName(mod.directory) ?? primaryDisplayName;
        final currentFolderName = p.basename(mod.directory.path);

        try {
          // Lee los datos existentes para no perder información como el 'customName'.
          Map<String, dynamic> modData = {};
          if (await infoFile.exists()) {
            try {
              final content = await infoFile.readAsString();
              if (content.trim().isNotEmpty) {
                 modData = json.decode(content);
              }
            } catch (e) {
              // Si está mal formado, empezamos de cero pero lo registramos.
              print('Could not parse existing nexus_info.json for ${mod.customName}. A new one will be created.');
            }
          }

          // Actualiza o añade los campos necesarios.
          modData['nexusId'] = nexusId;
          modData['displayName'] = compositeDisplayName;
          modData['customName'] ??= currentFolderName; // Si no tenía customName, usa el de la carpeta.
          modData['installedVersion'] = version;
          modData['installDate'] ??= DateTime.now().toIso8601String(); // Si no tenía fecha, la añade.
          modData['origin'] = 'repaired';

          final nexusData = await _fetchNexusModData(nexusId);
          if (nexusData != null) {
            modData['gallery'] = nexusData['gallery'];
            modData['summary'] = nexusData['summary'];
            modData['author'] = nexusData['author'];
          }

          final encoder = JsonEncoder.withIndent('  ');
          await infoFile.writeAsString(encoder.convert(modData));
          
          repairedCount++;
        } catch (e) {
          print('Could not self-repair mod "$primaryDisplayName": $e');
        }
      }
    }

    if (mounted) {
      if (repairedCount > 0) {
        NotificationService.instance.show(
          context: context,
          type: NotificationType.success,
          title: l10n.snackBarRepairComplete(repairedCount),
        );
      } else {
        NotificationService.instance.show(
          context: context,
          type: NotificationType.info,
          title: l10n.snackBarRepairNoMods,
        );
      }
    }
    
    await _loadAllMods();
    setState(() => _isLoading = false);
  }

  Future<String?> _fetchLatestModVersion(String nexusId) async {
    try {
      if (_apiKey == null || _apiKey!.isEmpty) return null;
      final headers = {'apikey': _apiKey!, 'accept': 'application/json'};
      final url = Uri.parse('https://api.nexusmods.com/v1/games/stellarblade/mods/$nexusId/files.json');
      final response = await http.get(url, headers: headers);

      if (response.statusCode != 200) return null;

      final jsonResponse = json.decode(response.body);
      final allFiles = jsonResponse['files'] as List;
      
      dynamic highestVersionFile;
      String highestVersion = "0";
      for (final file in allFiles) {
        final currentVersion = file['version'] as String?;
        if (currentVersion != null && _compareVersions(currentVersion, highestVersion) > 0) {
          highestVersion = currentVersion;
          highestVersionFile = file;
        }
      }
      return highestVersionFile?['version'];
    } catch (e) {
      print('Error fetching latest version for mod $nexusId: $e');
      return null;
    }
  }

  Future<void> _pickArchive() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip', 'rar', '7z'],
        allowMultiple: true,
      );
      if (result != null && result.files.isNotEmpty) {
        final files = result.paths.map((path) => File(path!)).toList();
        await _processArchives(files);
      }
    } catch (e) {
      setState(() =>
          _statusMessage = AppLocalizations.of(context)!.statusError(e.toString()));
    }
  }

  Future<Map<String, String>?> _extractNexusInfoFromName(String name) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Se necesita una API Key para identificar mods con nombres complejos.'),
          backgroundColor: Colors.orangeAccent,
        ));
      }
      return null;
    }

    try {
      // Busca todos los números de 3 a 5 dígitos que estén entre guiones.
      final potentialIdsRegex = RegExp(r'-(\d{3,5})-');
      final matches = potentialIdsRegex.allMatches(name);

      for (final match in matches) {
        final potentialId = match.group(1);
        if (potentialId == null) continue;

        // Valida cada ID potencial con la API de Nexus.
        if (await _isValidNexusId(potentialId)) {
          // ¡ID VÁLIDO ENCONTRADO! Este es nuestro mod.
          final validId = potentialId;

          // Lo que queda del nombre después del ID válido.
          // ej: "v01-1757576128.zip"
          final remainingString = name.substring(match.end);
          
          // Busca el último guion para separar la versión del ID de descarga.
          final lastHyphenIndex = remainingString.lastIndexOf('-');
          
          if (lastHyphenIndex != -1) {
            // La versión es todo lo que está entre el ID del mod y el último guion.
            String version = remainingString.substring(0, lastHyphenIndex);

            // Limpia la cadena de la versión.
            version = version.replaceAll('-', '.');
            if (version.toLowerCase().startsWith('v')) {
              version = version.substring(1);
            }
            if (version.toLowerCase().startsWith('cns.')) {
              version = version.substring(4);
            }

            print('API Validation successful: Found mod ID $validId with version $version');
            return {'id': validId, 'version': version};
          }
        }
      }
    } catch (e) {
      print('An error occurred during smart Nexus info extraction: $e');
    }
    
    // Si la lógica de validación con API falla, no se encontró nada.
    print('Could not validate any potential mod ID from filename: $name');
    return null;
  }

  Future<bool> _show7zipRequiredDialog() async {
    bool isInstalled = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            String dialogMessage =
                AppLocalizations.of(context)!.dialogContent7zip;
            Color messageColor = Colors.white;

            return AlertDialog(
              backgroundColor: const Color(0xFF2a2a2a),
              title: Text(AppLocalizations.of(context)!.dialogTitle7zip),
              content:
                  Text(dialogMessage, style: TextStyle(color: messageColor)),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context)!.dialogActionCancel),
                ),
                TextButton(
                  onPressed: () async {
                    final url = Uri.parse('https://www.7-zip.org/');
                    await launchUrl(url);
                  },
                  child: Text(
                      AppLocalizations.of(context)!.dialogActionGoToDownload),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _find7zipPath();
                    if (_7zipPath != null) {
                      isInstalled = true;
                      Navigator.of(context).pop();
                    } else {
                      setDialogState(() {
                        dialogMessage = AppLocalizations.of(context)!
                            .dialogContent7zipNotFound;
                        messageColor = Colors.redAccent;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent,
                      foregroundColor: Colors.black),
                  child: Text(AppLocalizations.of(context)!
                      .dialogActionConfirmInstallation),
                ),
              ],
            );
          },
        );
      },
    );
    return isInstalled;
  }

  Future<void> _promptAndInstallUE4SS(Directory sourceDir) async {
  final l10n = AppLocalizations.of(context)!;

  if (_isUe4ssInstalled) {
    final reinstall = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: Text(l10n.dialogTitleUE4SSReinstall),
        content: Text(l10n.dialogContentUE4SSReinstall),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.dialogActionCancel)),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.orangeAccent),
            child: Text(l10n.dialogActionReinstall),
          ),
        ],
      ),
    );
    if (reinstall != true) return;
  } else {
      final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: Text(l10n.dialogTitleUE4SS),
        content: Text(l10n.dialogContentUE4SS),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.dialogActionCancel)),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.tealAccent),
            child: Text(l10n.dialogActionInstallTool),
          ),
        ],
      ),
    );
    if (confirm != true) {
      setState(() => _statusMessage = l10n.statusUE4SSInstallCancelled);
      return;
    }
  }

  setState(() { _isLoading = true; _statusMessage = l10n.statusInstallingUE4SS; });

  try {
    if (_gameRootPath == null) throw Exception(l10n.errorGamePathUndefined);
    
    final manifestDir = Directory(p.join(_gameRootPath!, 'SB', 'Binaries', 'Win64', '_manager_metadata'));
    if (!await manifestDir.exists()) await manifestDir.create(recursive: true);
    final manifestFile = File(p.join(manifestDir.path, 'ue4ss_manifest.json'));

    // ++ INICIO DE LA NUEVA LÓGICA DE COMBINACIÓN ++
    // 1. Generar la lista de archivos de la NUEVA instalación.
    final newPaths = await _generateInstallManifest(sourceDir, sourceDir.path);
    
    // 2. Cargar la lista de archivos del manifiesto ANTIGUO, si existe.
    Set<String> finalPaths = newPaths.toSet(); // Usamos un Set para evitar duplicados.
    if (await manifestFile.exists()) {
      try {
        final oldContent = await manifestFile.readAsString();
        final List<String> oldPaths = List<String>.from(json.decode(oldContent));
        // 3. Añadir los archivos antiguos a la lista final.
        finalPaths.addAll(oldPaths);
      } catch (e) {
        print("No se pudo leer el manifiesto antiguo de UE4SS, será reemplazado. Error: $e");
      }
    }
    
    // 4. Escribir la lista combinada y final en el manifiesto.
    await manifestFile.writeAsString(json.encode(finalPaths.toList()));
    // ++ FIN DE LA NUEVA LÓGICA DE COMBINACIÓN ++

    final destinationDir = Directory(p.join(_gameRootPath!, 'SB', 'Binaries', 'Win64'));
    await _copyDirectory(sourceDir, destinationDir);

    NotificationService.instance.show(
      context: context, type: NotificationType.success, title: l10n.snackBarUE4SSInstalled,
    );
    
    setState(() {
      _statusMessage = l10n.statusUE4SSInstallComplete;
      _isUe4ssInstalled = true;
      _clearSelection();
    });

  } catch (e) {
    setState(() { _statusMessage = l10n.statusError(e.toString()); _statusColor = Colors.redAccent; });
  } finally {
    setState(() => _isLoading = false);
  }
}

    Future<void> _processArchives(List<File> archives) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isExtracting = true;
      _extractionProgress = 0.0;
      _extractionStatus = '';
    });

    bool cnsUpdateInitiated = false;
    _preparedUE4SS = null;

    try {
      try {
        if (_tempExtractionDir != null && await _tempExtractionDir!.exists()) {
          await _tempExtractionDir!.delete(recursive: true);
        }
      } catch (e) {
        print('Could not clean up previous temporary directory: $e');
      }
      _tempExtractionDir =
          Directory.systemTemp.createTempSync('mod_manager_');
      
      _preparedMods.clear();

      for (int i = 0; i < archives.length; i++) {
        final archiveFile = archives[i];
        final fileName = p.basename(archiveFile.path);

        setState(() {
          _extractionProgress = (i + 1) / archives.length;
          _extractionStatus = l10n.statusExtractingMultipleFiles(i + 1, fileName, archives.length);
        });

        final nexusInfo = await _extractNexusInfoFromName(fileName);
        final archiveTempDir = Directory(p.join(_tempExtractionDir!.path, i.toString()));
        await archiveTempDir.create();
        
        final extension = p.extension(archiveFile.path).toLowerCase();

        if (['.zip', '.rar', '.7z'].contains(extension)) {
          if (_7zipPath == null || !await File(_7zipPath!).exists()) {
            final installed = await _show7zipRequiredDialog();
            if (!installed) {
              throw Exception(l10n.error7zipRequired);
            }
          }
          final result = await Process.run(
            _7zipPath!,
            ['x', archiveFile.path, '-o${archiveTempDir.path}', '-y'],
          );
          if (result.exitCode != 0) {
            throw Exception(l10n.error7zipDecompression(result.stderr.toString()));
          }
        } else {
          throw Exception(l10n.errorUnsupportedFormat(extension));
        }

        final ue4ssRoot = await _findUE4SSRoot(archiveTempDir);

        if (ue4ssRoot != null) {
          _preparedUE4SS = _PreparedUE4SS(sourceDir: ue4ssRoot);
          continue; 
        }

        final sbDir = Directory(p.join(archiveTempDir.path, 'SB'));
        if (await sbDir.exists() &&
            await Directory(p.join(sbDir.path, 'Binaries')).exists() &&
            await Directory(p.join(sbDir.path, 'Content')).exists()) {
          await _promptAndUpdateCNS(sbDir);
          cnsUpdateInitiated = true;
        } else {
          final allModFiles = await _findAllModFilesRecursive(archiveTempDir);

          final jsonFiles = allModFiles.where((f) => p.extension(f.path).toLowerCase() == '.json').toList();
          final pakFiles = allModFiles.where((f) => ['.pak', '.ucas', '.utoc'].contains(p.extension(f.path).toLowerCase())).toList();

          if (jsonFiles.isNotEmpty && pakFiles.isNotEmpty) {
            
            final consolidatedDir = await Directory(p.join(archiveTempDir.path, '_consolidated_')).create();

            for (final modFile in allModFiles) {
              final newPath = p.join(consolidatedDir.path, p.basename(modFile.path));
              await modFile.copy(newPath);
            }
            
            _preparedMods.add(_PreparedMod(
              sourceDir: consolidatedDir,
              nexusId: nexusInfo?['id'],
              nexusVersion: nexusInfo?['version'],
            ));

          } else {
            final foundModDirs = await _findValidModDirectories(archiveTempDir);
            for (final modDir in foundModDirs) {
              _preparedMods.add(_PreparedMod(
                sourceDir: modDir,
                nexusId: nexusInfo?['id'],
                nexusVersion: nexusInfo?['version'],
              ));
            }
          }
        }
      }

      if (_preparedUE4SS != null) {
        _preparedMods.clear(); 
        await _promptAndInstallUE4SS(_preparedUE4SS!.sourceDir);
      } else if (cnsUpdateInitiated && _preparedMods.isEmpty) {
      } else {
        await _prepareInstallationPreview();
      }

    } catch (e) {
      setState(() {
        _statusMessage = l10n.statusError(e.toString());
        _statusColor = Colors.redAccent;
      });
    } finally {
      setState(() {
        _isExtracting = false;
      });
    }
  }

  
  Future<List<Directory>> _findValidModDirectories(Directory root) async {
    final List<Directory> found = [];
    bool isRootAMod = false;

    await for (final entity in root.list(followLinks: false)) {
      if (entity is File && p.extension(entity.path).toLowerCase() == '.json') {
        isRootAMod = true;
        break;
      }
    }

    if (isRootAMod) {
      found.add(root);
      return found;
    }

    await for (final entity in root.list(followLinks: false)) {
      if (entity is Directory) {
        final basename = p.basename(entity.path);
        if (basename.startsWith('__') || basename.startsWith('.')) continue;

        final nestedMods = await _findValidModDirectories(entity);
        found.addAll(nestedMods);
      }
    }

    return found;
  }

  Future<Directory?> _findUE4SSRoot(Directory root) async {
    final ue4ssDir = Directory(p.join(root.path, 'ue4ss'));
    final dwmapiFile = File(p.join(root.path, 'dwmapi.dll'));
    if (await ue4ssDir.exists() && await dwmapiFile.exists()) {
      return root;
    }

    await for (final entity in root.list(followLinks: false)) {
      if (entity is Directory) {
        final found = await _findUE4SSRoot(entity);
        if (found != null) {
          return found;
        }
      }
    }

    return null;
  }

  Future<void> _prepareInstallationPreview() async {
    if (_preparedMods.isEmpty) {
      _clearSelection(message: AppLocalizations.of(context)!.errorNoCompatibleFilesInArchive);
      return;
    }

    final Map<String, List<String>> previewMap = {};

    for (final preparedMod in _preparedMods) {
      final displayName = await _getDisplayNameForMod(preparedMod.sourceDir);
      if (displayName != null) {
        String finalFolderName = displayName;
        if (preparedMod.nexusVersion != null) {
          finalFolderName = '$finalFolderName v${preparedMod.nexusVersion}';
        }
        
        final files = preparedMod.sourceDir.listSync().whereType<File>().map((f) => p.basename(f.path)).toList();
        previewMap[finalFolderName] = files;
      }
    }

    setState(() {
      _modsToInstallPreviewMap = previewMap;
      _statusMessage = AppLocalizations.of(context)!.statusFilesSelected(_modsToInstallPreviewMap.length);
      _statusColor = Colors.white;
    });
  }


  Future<void> _promptAndUpdateCNS(Directory sourceSBDir) async {
  final l10n = AppLocalizations.of(context)!;

  if (!_isUe4ssInstalled) {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: Text(l10n.ue4ssRequiredTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.ue4ssRequiredContent),
            const SizedBox(height: 20),
            InkWell(
              onTap: () => launchUrl(Uri.parse("https://github.com/Chrisr0/RE-UE4SS/releases")),
              child: const Text(
                "https://github.com/Chrisr0/RE-UE4SS/releases",
                style: TextStyle(
                  color: Colors.tealAccent,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.dialogActionClose),
          ),
        ],
      ),
    );
    return; // Detiene la instalación si UE4SS no está presente.
  }

  final newVersion = await _getVersionFromCnsPackage(sourceSBDir);
  
  if (_isCnsCoreInstalled) {
    // CASO: YA HAY UNA VERSIÓN INSTALADA (Actualizar, Reinstalar o Revertir)
    final oldVersion = _cnsVersion ?? "N/A";
    
    // Comparamos la nueva versión con la antigua.
    final comparison = (newVersion != null && _cnsVersion != null)
        ? _compareVersions(newVersion, _cnsVersion!)
        : 1; // Si no podemos comparar, asumimos que es una actualización.

    String title, content, actionText;
    Color actionColor = Colors.orangeAccent;

    if (comparison > 0) {
      // UPDATE (Actualización)
      title = l10n.dialogTitleCNSUpdate;
      content = l10n.dialogContentCNSUpdate(oldVersion, newVersion!);
      actionText = l10n.dialogActionUpdate;
      actionColor = Colors.tealAccent;
    } else if (comparison < 0) {
      // DOWNGRADE (Revertir)
      title = l10n.dialogTitleCNSDowngrade;
      content = l10n.dialogContentCNSDowngrade(oldVersion, newVersion!);
      actionText = l10n.dialogActionDowngrade;
      actionColor = Colors.redAccent;
    } else {
      // REINSTALL (Misma versión)
      title = l10n.dialogTitleCNSReinstall;
      content = l10n.dialogContentCNSReinstallVersion(newVersion ?? oldVersion);
      actionText = l10n.dialogActionReinstall;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.dialogActionCancel)),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: actionColor),
            child: Text(actionText),
          ),
        ],
      )
    );
    if (confirm != true) return;
  } else {
      final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: Text(l10n.dialogTitleCNSInstall),
        content: Text(l10n.dialogContentCNSInstall),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.dialogActionCancel)),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.tealAccent),
            child: Text(l10n.dialogActionInstall),
          ),
        ],
      ),
    );
    if (confirm != true) {
      setState(() => _statusMessage = l10n.statusUpdateSystemCancelled);
      return;
    }
  }

  setState(() { _isLoading = true; _statusMessage = l10n.statusUpdatingCNS; });

  try {
    if (_gameRootPath == null) throw Exception(l10n.errorGamePathUndefined);
    
    final manifestDir = Directory(p.join(_gameRootPath!, 'SB', 'Binaries', 'Win64', '_manager_metadata'));
    if (!await manifestDir.exists()) await manifestDir.create(recursive: true);
    final manifestFile = File(p.join(manifestDir.path, 'cns_manifest.json'));

    // ++ INICIO DE LA NUEVA LÓGICA DE COMBINACIÓN ++
    // 1. Generar la lista de archivos de la NUEVA instalación.
    final newPaths = await _generateInstallManifest(sourceSBDir, sourceSBDir.path);

    // 2. Cargar la lista de archivos del manifiesto ANTIGUO, si existe.
    Set<String> finalPaths = newPaths.toSet();
    if (await manifestFile.exists()) {
      try {
        final oldContent = await manifestFile.readAsString();
        final List<String> oldPaths = List<String>.from(json.decode(oldContent));
        // 3. Añadir los archivos antiguos a la lista final.
        finalPaths.addAll(oldPaths);
      } catch (e) {
        print("No se pudo leer el manifiesto antiguo de CNS, será reemplazado. Error: $e");
      }
    }

    // 4. Escribir la lista combinada y final en el manifiesto.
    await manifestFile.writeAsString(json.encode(finalPaths.toList()));
    // ++ FIN DE LA NUEVA LÓGICA DE COMBINACIÓN ++

    final destinationSBDir = Directory(p.join(_gameRootPath!, 'SB'));
    await _copyDirectory(sourceSBDir, destinationSBDir);
    
    String? versionFromLua;
    // ... (el resto de la lógica de la función no cambia)
    try {
      final luaFile = File(p.join(_gameRootPath!, 'SB', 'Binaries', 'Win64', 'ue4ss', 'Mods', 'DekCNS', 'Scripts', 'main.lua'));
      if (await luaFile.exists()) {
        final content = await luaFile.readAsString();
        final regex = RegExp(r'local CNS_Version = "(.+)"');
        final match = regex.firstMatch(content);
        if (match != null && match.group(1) != null) {
          versionFromLua = match.group(1);
        }
      }
    } catch (e) { /* ... */ }

    // ... (resto de la lógica para crear nexus_info.json sin cambios)
    
    NotificationService.instance.show(
      context: context, type: NotificationType.success, title: l10n.snackBarCNSUpdated,
    );
    setState(() {
      _statusMessage = l10n.statusUpdateComplete;
      _isCnsCoreInstalled = true;
      _clearSelection();
    });
    
    await _readCNSData();
    
  } catch (e) {
    setState(() { _statusMessage = l10n.statusError(e.toString()); _statusColor = Colors.redAccent; });
  } finally {
    setState(() => _isLoading = false);
  }
}

  Future<void> _copyDirectory(Directory source, Directory destination) async {
    await for (var entity in source.list(recursive: false)) {
      if (entity is Directory) {
        var newDirectory =
            Directory(p.join(destination.absolute.path, p.basename(entity.path)));
        await newDirectory.create();
        await _copyDirectory(entity.absolute, newDirectory.absolute);
      } else if (entity is File) {
        await entity.copy(p.join(destination.path, p.basename(entity.path)));
      }
    }
  }

  Future<void> _installMod() async {
    final l10n = AppLocalizations.of(context)!;
    if (_finalModsPath == null) {
      setState(() {
        _statusMessage = l10n.errorGamePathUndefined;
        _statusColor = Colors.redAccent;
      });
      return;
    }
    if (_preparedMods.isEmpty) {
      setState(() {
        _statusMessage = l10n.errorInstallNoSelection;
        _statusColor = Colors.redAccent;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _lastInstalledModNames.clear();
    });

    List<String> installedNames = [];
    String? errorMessage;
    int successCount = 0;
    int failCount = 0;

    try {
      for (final preparedMod in _preparedMods) {
        try {
          final modName = await _installSingleModFromDirectory(
            preparedMod.sourceDir,
            nexusId: preparedMod.nexusId,
            nexusVersion: preparedMod.nexusVersion,
          );
          if (modName != null) {
            installedNames.add(modName);
            successCount++;
            if (mounted && _preparedMods.length > 1) {
              NotificationService.instance.show(
                context: context,
                type: NotificationType.success,
                title: l10n.snackBarModInstalled(modName),
              );
            }
          } else {
            failCount++;
          }
        } catch (e) {
          print('Failed to install mod from ${preparedMod.sourceDir.path}: $e');
          failCount++;
        }
      }

      if (mounted) {
        if (_preparedMods.length > 1) {
          Color snackBarColor = (failCount > 0)
              ? (successCount > 0 ? Colors.orange : Colors.red)
              : Colors.green[600]!;
          NotificationService.instance.show(
            context: context,
            type: failCount > 0
                ? (successCount > 0 ? NotificationType.info : NotificationType.error)
                : NotificationType.success,
            title: l10n.snackBarBatchInstallComplete(failCount, successCount),
          );
        } else if (successCount == 1) {
          NotificationService.instance.show(
            context: context,
            type: NotificationType.success,
            title: l10n.snackBarModInstalled(installedNames.first),
          );
        }
      }
    } catch (e) {
      errorMessage = e.toString();
      if (mounted) {
        NotificationService.instance.show(
          context: context,
          type: NotificationType.error,
          title: l10n.statusError(errorMessage),
        );
      }
    } finally {
      setState(() {
        _lastInstalledModNames = installedNames;
        if (errorMessage == null) {
          _statusMessage = installedNames.isNotEmpty
              ? l10n.statusInstallationComplete
              : 'Installation produced no new mods.';
        } else {
          _statusMessage = l10n.statusError(errorMessage);
          _statusColor = Colors.redAccent;
        }
        _clearSelection();
        _isLoading = false;
      });
      await _loadAllMods(clearHighlight: false);
      try {
        if (_tempExtractionDir != null && await _tempExtractionDir!.exists()) {
          await _tempExtractionDir!.delete(recursive: true);
        }
        _tempExtractionDir = null;
        await _cleanUpOrphanedTempDirs();
      } catch (e) {
        print('Failed to clean up temp directory: $e');
      }
    }
  }

  Future<String?> _installSingleModFromDirectory(Directory modDir,
      {bool recursive = false, String? nexusId, String? nexusVersion}) async {
    const validExtensions = ['.pak', '.ucas', '.utoc', '.json'];
    final List<File> files = [];
    await for (final entity in modDir.list(recursive: recursive)) {
      if (entity is File &&
          validExtensions.contains(p.extension(entity.path).toLowerCase())) {
        files.add(entity);
      }
    }

    if (files.isEmpty) return null;

    return await _installSingleModFromListOfFiles(files,
        nexusId: nexusId, nexusVersion: nexusVersion);
  }

  Future<String?> _getCompositeDisplayName(Directory modDir) async {
    final List<File> jsonFiles = [];
    await for (final entity in modDir.list()) {
      if (entity is File && p.extension(entity.path).toLowerCase() == '.json') {
        jsonFiles.add(entity);
      }
    }

    if (jsonFiles.isEmpty) {
      return null;
    }

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
            final sanitizedDisplayName =
                displayName.trim().replaceAll(RegExp(r'[\\/:*?"<>|]'), '-');
            displayNames.add(sanitizedDisplayName);
          }
        }
      } catch (e) {
        print('Could not parse display name from ${jsonFile.path}: $e');
      }
    }

    if (displayNames.isEmpty) {
      return null;
    }

    return displayNames.join(' ~ ');
  }

  Future<String?> _getFitMeshTypeForMod(Directory modDir) async {
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
              // Return the first one found.
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

  Future<String?> _getDisplayNameForMod(Directory modDir) async {
    try {
      await for (final entity in modDir.list()) {
        if (entity is File &&
            p.extension(entity.path).toLowerCase() == '.json') {
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
  
  Future<String> _getComparableNameForMod(ModInfo mod) async {
    return mod.displayName;
  }

  Future<_AlternativeVersionAction?> _showSmartInstallDialog({
    required ModInfo oldVersionMod,
    required String baseDisplayName,
    required String? newVersion,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final oldVersion = oldVersionMod.localVersion ?? 'N/A';
    final newVersionStr = newVersion ?? 'N/A';
    final modName = oldVersionMod.customName; 
    
    String title = l10n.dialogTitleAlternativeVersion;
    String content;
    String replaceActionText = l10n.dialogActionReplace;

    if (oldVersionMod.localVersion != null && newVersion != null) {
      final comparison = _compareVersions(newVersion, oldVersionMod.localVersion!);
      
      if (comparison > 0) {
        title = l10n.dialogTitleUpdate;
        content = l10n.dialogContentUpdate(modName, oldVersion, newVersionStr);
        replaceActionText = l10n.dialogActionUpdate;
      } else if (comparison < 0) {
        title = l10n.dialogTitleDowngrade;
        content = l10n.dialogContentDowngrade(modName, oldVersion, newVersionStr);
        replaceActionText = l10n.dialogActionDowngrade;
      } else {
        title = l10n.dialogTitleReinstall;
        content = l10n.dialogContentReinstall(modName, newVersionStr);
        replaceActionText = l10n.dialogActionReinstall;
      }
    } else {
      content = l10n.dialogContentAlternativeVersion(modName, baseDisplayName, baseDisplayName);
    }

    return showDialog<_AlternativeVersionAction>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(_AlternativeVersionAction.cancel),
            child: Text(l10n.dialogActionCancel),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.of(context).pop(_AlternativeVersionAction.replace),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent,
              foregroundColor: Colors.black,
            ),
            child: Text(replaceActionText),
          ),
        ],
      ),
    );
  }

  Future<String> _installSingleModFromListOfFiles(List<File> files,
      {String? nexusId, String? nexusVersion}) async {
    final l10n = AppLocalizations.of(context)!;
    final tempModDir = files.first.parent;
    String? preservedCustomName;

    final fitMeshType = await _getFitMeshTypeForMod(tempModDir);

    final baseDisplayName = await _getCompositeDisplayName(tempModDir);
    if (baseDisplayName == null) {
      throw FormatException(l10n.errorNoValidDisplayName);
    }

    String finalFolderName = baseDisplayName;
    
    ModInfo? oldVersionMod;
    _AlternativeVersionAction? action;

    List<ModInfo> nexusIdMatches = [];
    if (nexusId != null) {
      nexusIdMatches = _allMods.where((mod) => mod.nexusId == nexusId).toList();
    }

    if (nexusIdMatches.isNotEmpty) {
      for (final candidateMod in nexusIdMatches) {
        final candidateName = await _getComparableNameForMod(candidateMod);
        if (candidateName.toLowerCase() == baseDisplayName.toLowerCase()) {
          oldVersionMod = candidateMod;
          break;
        }
      }

      if (oldVersionMod != null) {
        action = await _showSmartInstallDialog(
          oldVersionMod: oldVersionMod,
          baseDisplayName: baseDisplayName,
          newVersion: nexusVersion,
        );
      } else {
        final existingModExample = nexusIdMatches.first.customName;
        action = await showDialog<_AlternativeVersionAction>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF2a2a2a),
            title: Text(l10n.dialogTitleAlternativeVersion),
            content: Text(l10n.dialogContentAlternativeVersion(existingModExample, baseDisplayName, finalFolderName)),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(_AlternativeVersionAction.cancel),
                child: Text(l10n.dialogActionCancel),
              ),
              ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).pop(_AlternativeVersionAction.installAsNew),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                    foregroundColor: Colors.black),
                child: Text(l10n.dialogActionInstallAsNew),
              ),
            ],
          ),
        );
      }
    } else {
      for (final existingMod in _allMods) {
        if (existingMod.displayName == baseDisplayName) {
          oldVersionMod = existingMod;
          break;
        }
      }
      if (oldVersionMod != null) {
          action = await _showSmartInstallDialog(
            oldVersionMod: oldVersionMod,
            baseDisplayName: baseDisplayName,
            newVersion: nexusVersion,
          );
      }
    }

    if (action != null) {
      switch (action) {
        case _AlternativeVersionAction.replace:
          if(oldVersionMod == null) {
             throw Exception("Attempted to replace a mod but no old version was identified.");
          }
          final oldInfoFile = File(p.join(oldVersionMod.directory.path, 'nexus_info.json'));
          if (await oldInfoFile.exists()) {
            try {
              final oldData = json.decode(await oldInfoFile.readAsString());
              if (oldData['customName'] != null) {
                preservedCustomName = oldData['customName'];
                print('Preserving custom name: $preservedCustomName');
              }
            } catch (e) {
              print('Could not read old custom name. Defaulting. Error: $e');
            }
          }

          final oldModName = oldVersionMod.customName;
          final deleted = await _deleteDirectoryWithRetry(oldVersionMod.directory);
          if (!deleted) {
            throw Exception(
                'Could not delete old mod version ($oldModName).');
          }
          break;
        case _AlternativeVersionAction.installAsNew:
          break;
        case _AlternativeVersionAction.cancel:
        case null:
        default:
          throw Exception(l10n.statusInstallationCancelledByUser);
      }
    }
    
    final newModPath = p.join(_finalModsPath!, finalFolderName);

    if (await Directory(newModPath).exists()) {
      final confirmReinstall = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF2a2a2a),
          title: Text(l10n.dialogTitleModExists),
          content: Text(l10n.dialogContentModExists(finalFolderName)),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.dialogActionCancel)),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.tealAccent),
              child: Text(l10n.dialogActionUpdate),
            ),
          ],
        ),
      );

      if (confirmReinstall != true) {
        throw Exception(l10n.errorInstallModExists);
      } else {
        final oldInfoFile = File(p.join(newModPath, 'nexus_info.json'));
        if (preservedCustomName == null && await oldInfoFile.exists()) {
          try {
            final oldData = json.decode(await oldInfoFile.readAsString());
            if (oldData['customName'] != null) {
              preservedCustomName = oldData['customName'];
              print('Preserving custom name: $preservedCustomName');
            }
          } catch (e) {
            print('Could not read old custom name. Defaulting. Error: $e');
          }
        }
        final deleted =
            await _deleteDirectoryWithRetry(Directory(newModPath));
        if (!deleted) {
          throw Exception(
              'Could not delete existing mod ($finalFolderName) to reinstall after several attempts.');
        }
      }
    }

    await Directory(newModPath).create(recursive: true);

    if (nexusId != null) {
      final infoFile = File(p.join(newModPath, 'nexus_info.json'));
      final versionForFile = nexusVersion;

      final Map<String, dynamic> modData = {
        'nexusId': nexusId,
        'displayName': baseDisplayName,
        'customName': preservedCustomName ?? baseDisplayName,
        'installedVersion': versionForFile,
        'installDate': DateTime.now().toIso8601String(),
        'managerVersion': _appVersion,
        'fitMeshType': fitMeshType,
        'sourceUrl': 'https://www.nexusmods.com/stellarblade/mods/$nexusId',
      };

      final nexusData = await _fetchNexusModData(nexusId);
      if (nexusData != null) {
        modData['gallery'] = nexusData['gallery'];
        modData['summary'] = nexusData['summary'];
        modData['author'] = nexusData['author'];
      }

      final encoder = JsonEncoder.withIndent('  ');
      await infoFile.writeAsString(encoder.convert(modData));
    }

    for (final file in files) {
      final fileName = p.basename(file.path);
      final destinationPath = p.join(newModPath, fileName);
      await file.copy(destinationPath);
    }

    return finalFolderName;
  }

  Future<void> _moveMod(Directory modDir, String toPath) async {
    final modName = p.basename(modDir.path);
    final destinationPath = p.join(toPath, modName);
    await modDir.rename(destinationPath);
  }

  Future<void> _enableMod(ModInfo modInfo) async {
    if (_finalModsPath == null) return;
    setState(() => _isLoading = true);

    try {
      final modName = p.basename(modInfo.directory.path);
      final newDirectory = Directory(p.join(_finalModsPath!, modName));

      await _moveMod(modInfo.directory, _finalModsPath!);
      
      /*if (mounted) {
        NotificationService.instance.show(
          context: context,
          type: NotificationType.success,
          title: AppLocalizations.of(context)!.snackBarModEnabled(modInfo.customName),
  );
      }*/

      // --- INICIO DE LA LÓGICA SIN PARPADEO ---
      final modIndex = _allMods.indexWhere((m) => m.directory.path == modInfo.directory.path);
      if (modIndex != -1) {
        // Crea una copia del mod con el estado y la nueva ruta actualizados
        final updatedMod = ModInfo(
          directory: newDirectory, // <-- Actualiza la ruta
          isEnabled: true,         // <-- Actualiza el estado
          // Mantiene el resto de la información intacta
          nexusId: modInfo.nexusId,
          localVersion: modInfo.localVersion,
          lastModified: modInfo.lastModified,
          origin: modInfo.origin,
          displayName: modInfo.displayName,
          customName: modInfo.customName,
          gallery: modInfo.gallery,
          fitMeshType: modInfo.fitMeshType,
          customCoverPath: modInfo.customCoverPath,
          customCoverAlignment: modInfo.customCoverAlignment,
          customCoverLastModified: modInfo.customCoverLastModified,
        );
        setState(() {
          _allMods[modIndex] = updatedMod;
        });
      } else {
        await _loadAllMods(); // Fallback por si algo sale mal
      }
      // --- FIN DE LA LÓGICA SIN PARPADEO ---

    } catch (e) {
      setState(() {
        _statusMessage = AppLocalizations.of(context)!.errorEnableMod(e.toString());
        _statusColor = Colors.redAccent;
      });
      await _loadAllMods(); // Si hay un error, recarga todo por seguridad
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _disableMod(ModInfo modInfo) async {
    if (_gameRootPath == null) return;
    setState(() => _isLoading = true);
    
    try {
      final backupDir = Directory(p.join(_gameRootPath!, 'SB', 'Content', '__MOD_BACKUPS__'));
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }
      
      final modName = p.basename(modInfo.directory.path);
      final newDirectory = Directory(p.join(backupDir.path, modName));

      await _moveMod(modInfo.directory, backupDir.path);

      /*if (mounted) {
        NotificationService.instance.show(
          context: context,
          type: NotificationType.info,
          title: AppLocalizations.of(context)!.snackBarModDisabled(modInfo.customName),
        );
      }*/

      // --- INICIO DE LA LÓGICA SIN PARPADEO ---
      final modIndex = _allMods.indexWhere((m) => m.directory.path == modInfo.directory.path);
      if (modIndex != -1) {
        // Crea una copia del mod con el estado y la nueva ruta actualizados
        final updatedMod = ModInfo(
          directory: newDirectory, // <-- Actualiza la ruta
          isEnabled: false,        // <-- Actualiza el estado
          // Mantiene el resto de la información intacta
          nexusId: modInfo.nexusId,
          localVersion: modInfo.localVersion,
          lastModified: modInfo.lastModified,
          origin: modInfo.origin,
          displayName: modInfo.displayName,
          customName: modInfo.customName,
          gallery: modInfo.gallery,
          fitMeshType: modInfo.fitMeshType,
          customCoverPath: modInfo.customCoverPath,
          customCoverAlignment: modInfo.customCoverAlignment,
          customCoverLastModified: modInfo.customCoverLastModified,
        );
        setState(() {
          _allMods[modIndex] = updatedMod;
        });
      } else {
        await _loadAllMods(); // Fallback por si algo sale mal
      }
      // --- FIN DE LA LÓGICA SIN PARPADEO ---
      
    } catch (e) {
      setState(() {
        _statusMessage = AppLocalizations.of(context)!.errorDisableMod(e.toString());
        _statusColor = Colors.redAccent;
      });
      await _loadAllMods(); // Si hay un error, recarga todo por seguridad
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteModPermanently(ModInfo modInfo) async {
    final l10n = AppLocalizations.of(context)!;
    final modName = modInfo.customName;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: Text(l10n.dialogTitleDeleteMod),
        content: Text(l10n.dialogContentDeleteMod(modName)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.dialogActionCancel)),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: Text(l10n.dialogActionDelete),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isLoading = true;
      _lastInstalledModNames.clear();
    });
    try {
      final deleted = await _deleteDirectoryWithRetry(modInfo.directory);
      if (deleted && mounted) {
        NotificationService.instance.show(
          context: context,
          type: NotificationType.error,
          title: l10n.snackBarModDeleted(modName),
        );
      } else if (!deleted) {
        throw Exception('Could not delete directory.');
      }
      await _loadAllMods();
    } catch (e) {
      setState(() {
        _statusMessage = l10n.errorDeleteMod(e.toString());
        _statusColor = Colors.redAccent;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _enableAllMods() async {
    final l10n = AppLocalizations.of(context)!;
    final disabledMods = _allMods.where((mod) => !mod.isEnabled).toList();

    if (disabledMods.isEmpty) {
      if (mounted) {
        NotificationService.instance.show(
          context: context,
          type: NotificationType.info,
          title: l10n.snackBarNoModsToEnable,
        );
      }
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: Text(l10n.dialogTitleEnableAll),
        content: Text(l10n.dialogContentEnableAll(disabledMods.length)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.dialogActionCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.greenAccent),
            child: Text(l10n.enableMod),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      if (_finalModsPath == null) {
        throw Exception("Mods path is not defined.");
      }
      
      // Guarda las rutas originales de los mods que vamos a mover
      final modsToUpdate = {for (var mod in disabledMods) mod.directory.path};

      for (final mod in disabledMods) {
        await _moveMod(mod.directory, _finalModsPath!);
      }

      // --- INICIO DE LA LÓGICA SIN PARPADEO ---
      // Mapea la lista actual a una nueva lista con los estados actualizados
      final List<ModInfo> updatedModsList = _allMods.map((originalMod) {
        if (modsToUpdate.contains(originalMod.directory.path)) {
          final modName = p.basename(originalMod.directory.path);
          final newDirectory = Directory(p.join(_finalModsPath!, modName));
          // Devuelve una copia actualizada del mod
          return ModInfo(
            directory: newDirectory, isEnabled: true,
            nexusId: originalMod.nexusId, localVersion: originalMod.localVersion,
            lastModified: originalMod.lastModified, origin: originalMod.origin,
            displayName: originalMod.displayName, customName: originalMod.customName,
            gallery: originalMod.gallery, fitMeshType: originalMod.fitMeshType,
            customCoverPath: originalMod.customCoverPath,
            customCoverAlignment: originalMod.customCoverAlignment,
            customCoverLastModified: originalMod.customCoverLastModified,
          );
        }
        // Si el mod no cambió, devuélvelo tal cual
        return originalMod;
      }).toList();

      setState(() {
        _allMods = updatedModsList;
      });
      // --- FIN DE LA LÓGICA SIN PARPADEO ---

      if (mounted) {
        NotificationService.instance.show(
          context: context,
          type: NotificationType.success,
          title: l10n.snackBarAllModsEnabled(disabledMods.length),
        );
      }
    } catch (e) {
      setState(() {
        _statusMessage = AppLocalizations.of(context)!.errorEnableMod(e.toString());
        _statusColor = Colors.redAccent;
      });
      await _loadAllMods(); // Mantenemos la recarga total solo en caso de error
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _disableAllMods() async {
    final l10n = AppLocalizations.of(context)!;
    final enabledMods = _allMods.where((mod) => mod.isEnabled).toList();

    if (enabledMods.isEmpty) {
        if (mounted) {
          NotificationService.instance.show(
            context: context,
            type: NotificationType.info,
            title: l10n.snackBarNoModsToDisable,
          );
        }
        return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: Text(l10n.dialogTitleDisableAll),
        content: Text(l10n.dialogContentDisableAll(enabledMods.length)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.dialogActionCancel)),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.orangeAccent),
            child: Text(l10n.disableMod),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      if (_gameRootPath == null) {
        throw Exception("Game path is not defined.");
      }
      final backupDir = Directory(p.join(_gameRootPath!, 'SB', 'Content', '__MOD_BACKUPS__'));
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }

      // Guarda las rutas originales de los mods que vamos a mover
      final modsToUpdate = {for (var mod in enabledMods) mod.directory.path};

      for (final mod in enabledMods) {
        await _moveMod(mod.directory, backupDir.path);
      }

      // --- INICIO DE LA LÓGICA SIN PARPADEO ---
      final List<ModInfo> updatedModsList = _allMods.map((originalMod) {
        if (modsToUpdate.contains(originalMod.directory.path)) {
          final modName = p.basename(originalMod.directory.path);
          final newDirectory = Directory(p.join(backupDir.path, modName));
          // Devuelve una copia actualizada del mod
          return ModInfo(
            directory: newDirectory, isEnabled: false,
            nexusId: originalMod.nexusId, localVersion: originalMod.localVersion,
            lastModified: originalMod.lastModified, origin: originalMod.origin,
            displayName: originalMod.displayName, customName: originalMod.customName,
            gallery: originalMod.gallery, fitMeshType: originalMod.fitMeshType,
            customCoverPath: originalMod.customCoverPath,
            customCoverAlignment: originalMod.customCoverAlignment,
            customCoverLastModified: originalMod.customCoverLastModified,
          );
        }
        // Si el mod no cambió, devuélvelo tal cual
        return originalMod;
      }).toList();

      setState(() {
        _allMods = updatedModsList;
      });
      // --- FIN DE LA LÓGICA SIN PARPADEO ---

      if (mounted) {
        NotificationService.instance.show(
          context: context,
          type: NotificationType.info,
          title: l10n.snackBarAllModsDisabled(enabledMods.length),
        );
      }
    } catch (e) {
      setState(() {
        _statusMessage = AppLocalizations.of(context)!.errorDisableMod(e.toString());
        _statusColor = Colors.redAccent;
      });
      await _loadAllMods(); // Mantenemos la recarga total solo en caso de error
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteDisabledMods() async {
    final l10n = AppLocalizations.of(context)!;
    final disabledMods = _allMods.where((mod) => !mod.isEnabled).toList();

    if (disabledMods.isEmpty) {
        if (mounted) {
          NotificationService.instance.show(
            context: context,
            type: NotificationType.info,
            title: l10n.snackBarNoModsToDelete,
          );
        }
        return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: Text(l10n.dialogTitleDeleteAll),
        content: Text(l10n.dialogContentDeleteAll(disabledMods.length)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.dialogActionCancel)),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: Text(l10n.dialogActionDelete),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      int deletedCount = 0;
      for (final mod in disabledMods) {
          if (await _deleteDirectoryWithRetry(mod.directory)) {
              deletedCount++;
          }
      }

      if (mounted) {
        NotificationService.instance.show(
          context: context,
          type: NotificationType.error,
          title: l10n.snackBarAllModsDeleted(deletedCount),
        );
      }
    } catch (e) {
      setState(() {
        _statusMessage = AppLocalizations.of(context)!.errorDeleteMod(e.toString());
        _statusColor = Colors.redAccent;
      });
    } finally {
      await _loadAllMods();
      setState(() => _isLoading = false);
    }
  }

  Future<bool> _deleteDirectoryWithRetry(Directory dir,
      {int retries = 3}) async {
    for (int i = 0; i < retries; i++) {
      try {
        if (await dir.exists()) {
          await dir.delete(recursive: true);
        }
        return true;
      } on PathAccessException {
        print(
            'Access denied while deleting ${dir.path}. Retrying (${i + 1}/$retries)...');
        await Future.delayed(const Duration(milliseconds: 300));
      } catch (e) {
        rethrow;
      }
    }
    print('Could not delete directory ${dir.path} after $retries attempts.');
    return false;
  }

  Future<void> _showInExplorer(Directory modDirectory) async {
    final uri = Uri.file(modDirectory.path);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      setState(() {
        _statusMessage =
            AppLocalizations.of(context)!.errorOpenFolder(modDirectory.path);
        _statusColor = Colors.redAccent;
      });
    }
  }

  void _clearSelection({String? message}) {
    setState(() {
      _preparedMods.clear();
      _modsToInstallPreviewMap.clear();
      if (mounted) {
        _statusMessage = message ?? AppLocalizations.of(context)!.statusSelectionCancelled;
      }
      _statusColor = message == null ? Colors.white : Colors.orangeAccent;
    });
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2a2a2a),
          title: Text(AppLocalizations.of(context)!.language),
          content: SizedBox(
            width: double.minPositive,
            child: ListView(
              shrinkWrap: true,
              children: [
                _languageTile('en', 'English'),
                _languageTile('es', 'Español'),
                _languageTile('pt', 'Português'),
                _languageTile('ru', 'Русский'),
                _languageTile('de', 'Deutsch'),
                _languageTile('zh', '中文'),
                _languageTile('ja', '日本語'),
                _languageTile('ko', '한국어'),
                _languageTile('it', 'Italiano'),
                _languageTile('fr', 'Français'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.dialogActionClose),
            ),
          ],
        );
      },
    );
  }

  Widget _languageTile(String languageCode, String languageName) {
    return ListTile(
      title: Text(languageName),
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('languageCode', languageCode);
        ModInstallerApp.setLocale(context, Locale(languageCode));
        Navigator.of(context).pop();
      },
    );
  }

  void _showAboutDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: Text(l10n.aboutTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.aboutContent),
            const SizedBox(height: 12),
            Text(l10n.aboutVersion(_appVersion)),
            const SizedBox(height: 20),
            InkWell(
              child: Text(
                l10n.aboutLinkText,
                style: const TextStyle(
                    color: Colors.tealAccent,
                    decoration: TextDecoration.underline),
              ),
              onTap: () => launchUrl(Uri.parse(l10n.creatorProfileUrl)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.dialogActionClose),
          ),
        ],
      ),
    );
  }
  
  Future<String?> _showApiKeyDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final apiKeyController = TextEditingController(text: _apiKey);

    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        bool isChecking = false;
        String? errorMessage;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF2a2a2a),
              title: Text(l10n.dialogTitleApiKey),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(l10n.dialogContentApiKey),
                    const SizedBox(height: 16),
                    Text(
                      l10n.dialogContentApiKeyInstructions,
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: apiKeyController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: l10n.apiKey,
                        hintText: l10n.apiKeyHintText,
                        errorText: errorMessage,
                      ),
                      onChanged: (_) {
                        if (errorMessage != null) {
                           setDialogState(() {
                             errorMessage = null;
                           });
                        }
                      },
                    ),
                    if (isChecking)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(width: 16),
                            Text(l10n.validatingApiKey),
                          ],
                        ),
                      )
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(l10n.dialogActionCancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  onPressed: isChecking ? null : () async {
                    final keyToValidate = apiKeyController.text;
                    if (keyToValidate.isEmpty) {
                      await _saveApiKey('');
                       if (mounted) {
                         NotificationService.instance.show(
                           context: context,
                           type: NotificationType.info,
                           title: l10n.apiKeyRemoved,
                         );
                        Navigator.of(context).pop('');
                      }
                      return;
                    }

                    setDialogState(() {
                      isChecking = true;
                      errorMessage = null;
                    });
                    
                    final bool isValid = await _validateApiKey(keyToValidate);

                    if (mounted) {
                       if (isValid) {
                          await _saveApiKey(keyToValidate);
                          NotificationService.instance.show(
                            context: context,
                            type: NotificationType.success,
                            title: l10n.snackBarApiKeySaved,
                          );
                          Navigator.of(context).pop(keyToValidate);
                       } else {
                          setDialogState(() {
                            isChecking = false;
                            errorMessage = l10n.invalidApiKeyError;
                          });
                       }
                    }
                  },
                  child: Text(l10n.dialogActionSave),
                ),
              ],
            );
          }
        );
      },
    );
  }

  Future<void> _updateModCustomName(ModInfo mod, String newCustomName) async {
    final l10n = AppLocalizations.of(context)!;
    if (newCustomName.isEmpty || newCustomName == mod.customName) {
      return;
    }
    
    setState(() => _isLoading = true);
    try {
      // Ya no se renombra la carpeta. Solo se actualiza el archivo JSON.
      final infoFile = File(p.join(mod.directory.path, 'nexus_info.json'));
      if (await infoFile.exists()) {
        try {
          final content = await infoFile.readAsString();
          Map<String, dynamic> data = json.decode(content);
          
          // Asigna el nuevo nombre personalizado o lo elimina si es igual al original.
          if (newCustomName == mod.displayName) {
            data.remove('customName');
          } else {
            data['customName'] = newCustomName;
          }
          
          final encoder = JsonEncoder.withIndent('  ');
          await infoFile.writeAsString(encoder.convert(data));
        } catch (e) {
          print("Could not update customName in nexus_info.json: $e");
        }
      }
      
      // Recarga la lista de mods para que la UI refleje el nuevo nombre.
      await _loadAllMods();

    } catch (e) {
       setState(() {
        _statusMessage = "Error renaming mod: $e";
        _statusColor = Colors.redAccent;
      });
      await _loadAllMods();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // main.dart

  // main.dart

  Future<void> _showEditModNameDialog(ModInfo modInfo) async {
    final nameController = TextEditingController(text: modInfo.customName);
    final l10n = AppLocalizations.of(context)!;

    final newName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        // En lugar de AlertDialog, usamos el widget base 'Dialog'.
        return Dialog(
          backgroundColor: const Color(0xFF2a2a2a),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          // Construimos el contenido manualmente con una Columna.
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              // ESTA ES LA PROPIEDAD MÁS IMPORTANTE:
              // Le dice a la columna que ocupe el mínimo espacio vertical necesario,
              // evitando que se expanda para llenar toda la pantalla.
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // 1. Título del Diálogo
                Text(
                  l10n.dialogTitleEditModName,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),

                // 2. Campo de Texto
                TextField(
                  controller: nameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: l10n.dialogLabelNewName,
                    hintText: modInfo.customName,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Fila de Acciones (Botones)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(modInfo.displayName),
                      child: Text(l10n.dialogActionResetToDefault),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(l10n.dialogActionCancel),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(nameController.text),
                          child: Text(l10n.dialogActionSave),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    // La lógica para guardar no cambia.
    if (newName != null && newName.trim().isNotEmpty) {
      await _updateModCustomName(modInfo, newName.trim());
    }
  }

  int _compareVersions(String v1, String v2) {
    try {
      final cleanV1 = v1.toLowerCase().replaceAll(RegExp(r'^[vV]'), '');
      final cleanV2 = v2.toLowerCase().replaceAll(RegExp(r'^[vV]'), '');

      List<String> parts1 = cleanV1.split('.');
      List<String> parts2 = cleanV2.split('.');

      int length = parts1.length > parts2.length ? parts1.length : parts2.length;

      for (int i = 0; i < length; i++) {
        String p1Str = i < parts1.length ? parts1[i] : '0';
        String p2Str = i < parts2.length ? parts2[i] : '0';

        bool p1IsNum = int.tryParse(p1Str) != null;
        bool p2IsNum = int.tryParse(p2Str) != null;

        if (p1IsNum && p2IsNum) {
          int p1Num = int.parse(p1Str);
          int p2Num = int.parse(p2Str);
          if (p1Num > p2Num) return 1;
          if (p1Num < p2Num) return -1;
        } else if (p1IsNum && !p2IsNum) {
          return 1; 
        } else if (!p1IsNum && p2IsNum) {
          return -1;
        } else {
          int comparison = p1Str.compareTo(p2Str);
          if (comparison != 0) {
            return comparison;
          }
        }
      }
      return 0;
    } catch (e) {
      print('Error comparing versions "$v1" and "$v2": $e');
      return v1.compareTo(v2);
    }
  }

  Future<Map<String, dynamic>?> _fetchNexusModData(String nexusId) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      print("API Key not configured, not fetching Nexus data.");
      return null;
    }
    final headers = {'apikey': _apiKey!, 'accept': 'application/json'};

    try {
      final modDetailsUrl = Uri.parse(
          'https://api.nexusmods.com/v1/games/stellarblade/mods/$nexusId.json');
      var response = await http.get(modDetailsUrl, headers: headers);

      if (response.statusCode == 200) {
        final modDetails = json.decode(response.body);
        
        // Extraemos la información que necesitamos
        final pictureUrl = modDetails['picture_url'] as String?;
        final summary = modDetails['summary'] as String?;
        final author = modDetails['author'] as String?;
        
        List<Map<String, dynamic>>? gallery;
        if (pictureUrl != null && pictureUrl.isNotEmpty) {
          gallery = [{"image": pictureUrl, "thumbnail": pictureUrl}];
        }

        // Devolvemos un mapa con todos los datos.
        return {
          'gallery': gallery,
          'summary': summary,
          'author': author,
        };
      }

      print("Failed to fetch Nexus data for mod $nexusId (code: ${response.statusCode}).");
      return null;
    } catch (e) {
      print("An exception occurred while fetching Nexus data for mod $nexusId: $e");
      return null;
    }
  }

  Future<void> _updateNexusInfoFile(Directory modDirectory,
      {Map<String, dynamic>? updateCheckData,
      List<Map<String, dynamic>>? galleryData}) async {
    final infoFile = File(p.join(modDirectory.path, 'nexus_info.json'));
    Map<String, dynamic> modData = {};
    if (galleryData != null) {
      modData['gallery'] = galleryData;
    }

    try {
      if (await infoFile.exists()) {
        modData = json.decode(await infoFile.readAsString());
      }
    } catch (e) {
      print(
          "Could not read existing nexus_info.json, creating a new one. Error: $e");
    }

    if (updateCheckData != null) {
      modData['lastUpdateCheck'] = updateCheckData;
    }

    final encoder = JsonEncoder.withIndent('  ');
    await infoFile.writeAsString(encoder.convert(modData));
  }

  Future<void> _checkForUpdates() async {
    final l10n = AppLocalizations.of(context)!;
    
    if (_apiKey == null || _apiKey!.isEmpty) {
      await _showApiKeyDialog();
      if (_apiKey == null || _apiKey!.isEmpty) {
          setState(() {
            _statusMessage = l10n.errorApiKeyMissing;
            _statusColor = Colors.orangeAccent;
          });
          return;
      }
    }

    final List<_UpdateCheckJob> jobs = [];

    final cnsHasNexusId = _cnsNexusId != null && _cnsNexusId!.isNotEmpty;
    if (cnsHasNexusId) {
      jobs.add(_UpdateCheckJob(isCns: true));
    }

    final allModsWithNexusId = _allMods
        .where((mod) => mod.nexusId != null && mod.nexusId!.isNotEmpty)
        .toList();
    for (final mod in allModsWithNexusId) {
      jobs.add(_UpdateCheckJob(mod: mod));
    }

    if (jobs.isEmpty) {
      setState(() {
        _statusMessage = l10n.statusNoUpdates;
        _statusColor = Colors.white;
      });
      return;
    }

    setState(() {
      _isCheckingForUpdates = true;
      _statusMessage = l10n.statusCheckingUpdates;
      _modUpdates.clear();
      _cnsUpdateInfo = null;
      _ignoredUpdates.clear();
    });

    final headers = {'apikey': _apiKey!, 'accept': 'application/json'};
    final List<Future<Map<String, dynamic>?>> futures = [];

    for (final job in jobs) {
      if (job.isCns) {
        futures.add(_checkSingleModUpdate(
            headers: headers,
            nexusId: _cnsNexusId!,
            localVersion: _cnsVersion ?? '0',
            hasLocalVersion: _cnsVersion != null,
            modName: "Custom Nanosuit System",
            modDirectory: Directory(
                p.join(_gameRootPath!, 'SB', 'Binaries', 'Win64', 'ue4ss')), displayName: ''));
      } else if (job.mod != null) {
        // Determina qué versión usar para la comprobación de actualizaciones.
        // Prioriza la 'customVersion' definida por el usuario.
        final String versionForCheck = job.mod!.customVersion != null && job.mod!.customVersion!.isNotEmpty
            ? job.mod!.customVersion!
            : job.mod!.localVersion ?? '0';

        // Se considera que una versión existe si la versión personalizada o la local están presentes.
        final bool hasVersionForCheck = (job.mod!.customVersion != null && job.mod!.customVersion!.isNotEmpty) ||
                                         (job.mod!.localVersion != null && job.mod!.localVersion!.isNotEmpty);

        futures.add(_checkSingleModUpdate(
            headers: headers,
            nexusId: job.mod!.nexusId!,
            localVersion: versionForCheck,       // Usar la versión determinada
            hasLocalVersion: hasVersionForCheck, // Usar el nuevo booleano
            modName: job.mod!.customName,
            displayName: job.mod!.displayName,
            modDirectory: job.mod!.directory));
      }
    }

    String? detailedError;
    List<Map<String, dynamic>?> results = [];
    try {
      results = await Future.wait(futures);
    } catch (e) {
      detailedError = e.toString();
    }

    int updatesFound = 0;
    for (int i = 0; i < results.length; i++) {
      final result = results[i];
      final job = jobs[i];

      if (result != null) {
        updatesFound++;
        if (job.isCns) {
          _cnsUpdateInfo = result;
        } else if (job.mod != null) {
          _modUpdates[job.mod!.directory.path] = result;
        }
      }
    }

    setState(() {
      if (detailedError != null) {
        _statusMessage = l10n.statusError(detailedError);
        _statusColor = Colors.redAccent;
      } else if (updatesFound > 0) {
        _statusMessage = l10n.statusUpdatesFound(updatesFound);
        _statusColor = Colors.yellowAccent;
      } else {
        _statusMessage = l10n.statusNoUpdates;
        _statusColor = Colors.greenAccent;
      }
      _isCheckingForUpdates = false;
    });
  }

  Future<Map<String, dynamic>?> _checkSingleModUpdate({
    required Map<String, String> headers,
    required String nexusId,
    required String localVersion,
    required bool hasLocalVersion,
    required String modName,
    required String displayName,
    required Directory modDirectory,
  }) async {
    final url = Uri.parse(
        'https://api.nexusmods.com/v1/games/stellarblade/mods/$nexusId/files.json');
    final response = await http.get(url, headers: headers);

    try {
      final updateCheckData = {
        'timestamp': DateTime.now().toIso8601String(),
        'statusCode': response.statusCode,
      };
      await _updateNexusInfoFile(modDirectory, updateCheckData: updateCheckData);
    } catch (e) {
      print(
          'Could not update nexus_info.json file for $modName: $e');
    }

    if (response.statusCode != 200) {
      print('Error for mod $nexusId: ${response.statusCode} - ${response.body}');
      return null;
    }

    final jsonResponse = json.decode(response.body);
    final allFiles = jsonResponse['files'] as List;
    final potentialFiles = allFiles
        .where((file) =>
            file['category_name'] == 'MAIN' ||
            file['category_name'] == 'OPTIONAL')
        .toList();

    final compatibleFiles = potentialFiles.where((file) {
      final fileName = (file['file_name'] as String).toLowerCase();
      return !fileName.contains('not cns') && !fileName.contains('without cns') && !fileName.contains('non cns');
    }).toList();

    if (compatibleFiles.isNotEmpty) {
      List<dynamic> filesToConsider;
      final cnsFiles = compatibleFiles
          .where((file) =>
              (file['file_name'] as String).toLowerCase().contains('cns'))
          .toList();

      filesToConsider = cnsFiles.isNotEmpty ? cnsFiles : compatibleFiles;

      final modsWithSameId = _allMods.where((m) => m.nexusId == nexusId).length;
      if (modsWithSameId > 1) {
        final keywords = displayName.toLowerCase().split(' ').where((s) => s.isNotEmpty).toList();
        int highestScore = 0;

        const exclusiveTerms = ['no tail', 'notail'];

        final fileScores = filesToConsider.map((file) {
          final fileName = (file['file_name'] as String).toLowerCase();
          final modDisplayNameLower = displayName.toLowerCase();
          int score = 0;
          bool isMismatch = false;

          for (final term in exclusiveTerms) {
            if (fileName.contains(term) && !modDisplayNameLower.contains(term)) {
              isMismatch = true;
              break;
            }
          }

          if (isMismatch) {
            score = -1; 
          } else {
            for (final keyword in keywords) {
              if (fileName.contains(keyword)) {
                score++;
              }
            }
          }
          return {'file': file, 'score': score};
        }).toList();

        for (final scoredFile in fileScores) {
          if (scoredFile['score'] as int > highestScore) {
            highestScore = scoredFile['score'] as int;
          }
        }

        if (highestScore > 0) {
          final bestMatches = fileScores
              .where((scoredFile) => scoredFile['score'] == highestScore)
              .map((scoredFile) => scoredFile['file'])
              .toList();
          
          if (bestMatches.isNotEmpty) {
            filesToConsider = bestMatches;
          }
        }
      }

      dynamic highestVersionFile;
      String highestVersion = "0";
      for (final file in filesToConsider) {
        final currentVersion = file['version'] as String?;
        if (currentVersion != null && _compareVersions(currentVersion, highestVersion) > 0) {
          highestVersion = currentVersion;
          highestVersionFile = file;
        }
      }

      if (highestVersionFile != null) {
        final latestVersion = highestVersionFile['version'] as String;
        
        final skippedVersion = _skippedVersions[nexusId];
        final isSkipped = skippedVersion != null && _compareVersions(latestVersion, skippedVersion) <= 0;

        if (hasLocalVersion && !isSkipped && _compareVersions(latestVersion, localVersion) > 0) {
          return {
            'version': latestVersion,
            'fileId': highestVersionFile['file_id'] as int,
          };
        }
      }
    }
    return null;
  }


  Future<void> _recheckSpecificMod(String nexusId, {String? newVersion}) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      print("API Key not configured, cannot re-check mod.");
      return;
    }
    final headers = {'apikey': _apiKey!, 'accept': 'application/json'};

    if (_cnsNexusId == nexusId) {
      final versionToCheck = newVersion ?? _cnsVersion;
      if (versionToCheck == null) return;
      final updateInfo = await _checkSingleModUpdate(
        headers: headers,
        nexusId: _cnsNexusId!,
        localVersion: versionToCheck,
        hasLocalVersion: true,
        modName: "Custom Nanosuit System",
        modDirectory: Directory(
            p.join(_gameRootPath!, 'SB', 'Binaries', 'Win64', 'ue4ss')), displayName: '',
      );
      setState(() => _cnsUpdateInfo = updateInfo);
    } else {
      try {
        final modToRecheck = _allMods
            .firstWhere((m) => m.nexusId == nexusId);
        // Prioriza la versión para la nueva comprobación en este orden:
        // 1. Una nueva versión pasada explícitamente a la función.
        // 2. La versión personalizada del mod si existe.
        // 3. La versión local (automática) del mod.
        final versionToCheck = newVersion ??
            (modToRecheck.customVersion?.isNotEmpty == true
                ? modToRecheck.customVersion
                : modToRecheck.localVersion);

        if (versionToCheck != null) {
          final hasVersionForCheck = versionToCheck.isNotEmpty;
          final updateInfo = await _checkSingleModUpdate(
              headers: headers,
              nexusId: modToRecheck.nexusId!,
              localVersion: versionToCheck,
              hasLocalVersion: hasVersionForCheck,
              modName: modToRecheck.customName,
              modDirectory: modToRecheck.directory, 
              displayName: modToRecheck.displayName); // Pasar el displayName
          setState(() {
            if (updateInfo == null) {
              _modUpdates.remove(modToRecheck.directory.path);
            } else {
              _modUpdates[modToRecheck.directory.path] = updateInfo;
            }
          });
        }
      } catch (e) {
        print("Mod with nexusId $nexusId not found for re-check: $e");
      }
    }
  }

  void _showImageGalleryDialog(ModInfo modInfo) {
    final l10n = AppLocalizations.of(context)!;
    
    // Primero, intenta encontrar una portada personalizada local
    File? customCoverFile;
    if (modInfo.customCoverPath != null && modInfo.customCoverPath!.isNotEmpty) {
      final path = p.join(modInfo.directory.path, modInfo.customCoverPath!);
      final file = File(path);
      if (file.existsSync()) {
        customCoverFile = file;
      }
    }

    Widget content;
    
    if (customCoverFile != null) {
      // Si existe la portada personalizada, prepara el widget para mostrarla
      content = InteractiveViewer(
        panEnabled: true,
        minScale: 1.0,
        maxScale: 4.0,
        child: Center(
          child: Image.file(
            customCoverFile,
            fit: BoxFit.contain,
          ),
        ),
      );
    } else {
      // Si no, usa la lógica anterior para mostrar la galería de Nexus
      final images = modInfo.gallery;
      if (images != null && images.isNotEmpty) {
        content = InteractiveViewer(
          panEnabled: true,
          minScale: 1.0,
          maxScale: 4.0,
          child: Center(
            child: Image.network(
              images.first['image'],
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Icon(Icons.error, color: Colors.redAccent));
              },
              fit: BoxFit.contain,
            ),
          ),
        );
      } else {
        content = Center(child: Text(l10n.noImagesFound));
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          contentPadding: EdgeInsets.zero,
          backgroundColor: const Color(0xFF1e1e1e),
          content: Stack(
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.8,
                child: content, // El widget de contenido se decide arriba
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    shape: const CircleBorder(),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: l10n.dialogActionClose,
                ),
              ),
            ],
          ),
          actions: null,
        );
      },
    );
  }

  Future<void> _showUpdateOptionsDialog({
    required String newVersion,
    required String nexusId,
    required int fileId,
    required String uniqueIdentifier,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final String cleanedVersion = newVersion.toLowerCase().startsWith('v')
        ? newVersion.substring(1)
        : newVersion;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: Text(l10n.updateAvailable(cleanedVersion)),
        content: Text(l10n.dialogContentUpdateOptions),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _ignoredUpdates.add(uniqueIdentifier);
              });
              Navigator.of(context).pop();
            },
            child: Text(l10n.dialogActionIgnoreVersion),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                 _skippedVersions[nexusId] = newVersion;
                if (nexusId == _cnsNexusId) {
                  _cnsUpdateInfo = null;
                } else {
                  _modUpdates.removeWhere((key, value) =>
                      _allMods.firstWhere((mod) => mod.directory.path == key).nexusId == nexusId);
                }
              });
              await _saveSkippedVersions();
              Navigator.of(context).pop();
            },
            child: Text(l10n.dialogActionSkipVersion),
          ),
          ElevatedButton(
            onPressed: () async {
              final url = Uri.parse(
                  'https://www.nexusmods.com/stellarblade/mods/$nexusId?tab=files&file_id=$fileId');
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent,
              foregroundColor: Colors.black,
            ),
            child: Text(l10n.dialogActionGoToDownloadPage),
          ),
        ],
      ),
    );
  }
  
  Future<void> _manageSkippedVersions() async {
    final l10n = AppLocalizations.of(context)!;
    
    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setDialogState) {
            final skippedEntries = _skippedVersions.entries.toList();

            return AlertDialog(
              backgroundColor: const Color(0xFF2a2a2a),
              title: Text(l10n.dialogTitleSkippedVersions),
              content: SizedBox(
                width: double.maxFinite,
                child: skippedEntries.isEmpty
                    ? Center(child: Text(l10n.dialogNoSkippedVersions))
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: skippedEntries.length,
                        itemBuilder: (context, index) {
                          final entry = skippedEntries[index];
                          final mod = _allMods.firstWhere(
                              (m) => m.nexusId == entry.key,
                              orElse: () => ModInfo(
                                  directory: Directory(''),
                                  lastModified: DateTime.now(),
                                  isEnabled: false,
                                  displayName: 'ID: ${entry.key}',
                                  customName: 'ID: ${entry.key}',
                                  gallery: null,
                                  origin: null));
                          final modName = mod.directory.path.isNotEmpty
                              ? mod.customName
                              : 'ID: ${entry.key}';

                          return ListTile(
                            title: Text(modName),
                            subtitle: Text('${l10n.dialogSkippedVersions}: ${entry.value}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.redAccent),
                              onPressed: () async {
                                await _removeSkippedVersion(entry.key);
                                setDialogState(() {});
                              },
                            ),
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.dialogActionClose),
                )
              ],
            );
          });
        });
  }


  List<ModInfo> _getFilteredAndSortedMods(AppLocalizations l10n) {
    List<ModInfo> mods = List.from(_allMods);

    switch (_currentFilter) {
      case ModFilter.enabled:
        mods.retainWhere((mod) => mod.isEnabled);
        break;
      case ModFilter.disabled:
        mods.retainWhere((mod) => !mod.isEnabled);
        break;
      case ModFilter.repaired:
        mods.retainWhere((mod) => mod.origin == 'repaired');
        break;
      case ModFilter.all:
      default:
        break;
    }
    
    if (_searchQuery.isNotEmpty) {
      mods.retainWhere((mod) {
        // Obtenemos la etiqueta visible, igual que en la UI.
        final displayTag = mod.customFitMeshType ?? mod.fitMeshType ?? l10n.modCategoryOther;
        final query = _searchQuery.toLowerCase();
        
        // Comprobamos si el nombre del mod coincide.
        final nameMatch = mod.customName.toLowerCase().contains(query);
        // Comprobamos si la etiqueta coincide.
        final tagMatch = displayTag.toLowerCase().contains(query);

        // El mod se mantiene si cualquiera de los dos coincide.
        return nameMatch || tagMatch;
      });
    }

    switch (_currentSort) {
      case ModSort.name:
        mods.sort((a, b) => a.customName.toLowerCase().compareTo(b.customName.toLowerCase()));
        break;
      case ModSort.date:
      default:
        // ✅ INICIO DE LA SOLUCIÓN
        mods.sort((a, b) {
          // 1. Criterio principal: Ordenar por fecha (descendente)
          final dateCompare = b.lastModified.compareTo(a.lastModified);
          
          // 2. Si las fechas son diferentes, usamos ese resultado
          if (dateCompare != 0) {
            return dateCompare;
          }
          
          // 3. Criterio de desempate: Si las fechas son iguales, ordenar por nombre (ascendente)
          //    para garantizar un orden estable y predecible.
          return a.customName.toLowerCase().compareTo(b.customName.toLowerCase());
        });
        // ✅ FIN DE LA SOLUCIÓN
        break;
    }

    return mods;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canInstall = _preparedMods.isNotEmpty && !_isLoading && !_isExtracting;
    final filteredAndSortedMods = _getFilteredAndSortedMods(l10n);

    final cnsUpdateIdentifier = _cnsUpdateInfo != null ? 'CNS_' + _cnsUpdateInfo!['version'] : '';
    final cnsIsIgnored = _ignoredUpdates.contains(cnsUpdateIdentifier);
    final hasEnabledMods = _allMods.any((mod) => mod.isEnabled);
    final hasDisabledMods = _allMods.any((mod) => !mod.isEnabled);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(_cnsVersion != null
            ? l10n.appTitleWithVersion(_cnsVersion!)
            : l10n.appTitleNoCns), // Usará el nuevo texto cuando no haya versión
            if (_cnsUpdateInfo != null && !cnsIsIgnored)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconButton(
                    icon: const Icon(Icons.notification_important,
                        color: Colors.yellowAccent),
                    tooltip: l10n.updateAvailable(_cnsUpdateInfo!['version']),
                    onPressed: () {
                      if (_cnsNexusId != null) {
                        _showUpdateOptionsDialog(
                          newVersion: _cnsUpdateInfo!['version'],
                          nexusId: _cnsNexusId!,
                          fileId: _cnsUpdateInfo!['fileId'],
                          uniqueIdentifier: cnsUpdateIdentifier,
                        );
                      }
                    }),
              ),
          ],
        ),
        backgroundColor: const Color(0xFF2a2a2a),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_sync_outlined),
            tooltip: l10n.checkForUpdates,
            onPressed: _isLoading || _isCheckingForUpdates ? null : _checkForUpdates,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: l10n.settings,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    initialGameRootPath: _gameRootPath,
                    initialSevenZipPath: _7zipPath,
                    initialApiKey: _apiKey,
                    skippedVersions: _skippedVersions,
                    // Pasar los nuevos estados y funciones a la página de configuración
                    isUe4ssInstalled: _isUe4ssInstalled,
                    isCnsCoreInstalled: _isCnsCoreInstalled,
                    onUninstallUE4SS: () => _uninstallCoreComponent(isUe4ss: true),
                    onUninstallCNS: () => _uninstallCoreComponent(isUe4ss: false),
                    // Resto de callbacks
                    onSelectGamePath: _selectGamePathManually,
                    onSelect7zipPath: _select7zipPathManually,
                    onShowApiKeyDialog: _showApiKeyDialog,
                    onManageSkippedVersions: _manageSkippedVersions,
                    onShowLanguageDialog: _showLanguageDialog,
                    onShowAboutDialog: _showAboutDialog,
                    onRunSelfHealing: _showSelfHealConfirmationDialog,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: DropTarget(
        onDragDone: (details) async {
          final paths = details.files.map((file) => file.path).toList();
          if (paths.isNotEmpty) {
             final files = paths.map((path) => File(path)).toList();
             await _processArchives(files);
          }
        },
        onDragEntered: (details) => setState(() => _isDragging = true),
        onDragExited: (details) => setState(() => _isDragging = false),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _finalModsPath == null && !_isLoading
                  ? _buildPathSelectionScreen(l10n)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildInstallerSection(canInstall, l10n),
                        if (_modsToInstallPreviewMap.isNotEmpty)
                          _buildSelectionPreviewSection(l10n),
                        const Divider(height: 30, thickness: 1),
                        Expanded(
                          child: _buildModsListSection(l10n.installedMods, filteredAndSortedMods, l10n, hasEnabledMods, hasDisabledMods),
                        ),
                        const SizedBox(height: 20),
                        if (_isExtracting)
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  _extractionStatus,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white70),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: _extractionProgress,
                                backgroundColor: Colors.grey[800],
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.tealAccent),
                              ),
                            ],
                          )
                        else if (_isCheckingForUpdates)
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  l10n.statusCheckingUpdates,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white70),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: null,
                                backgroundColor: Colors.grey[800],
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.tealAccent),
                              ),
                            ],
                          )
                        else if (_isLoading)
                          Center(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),)))
                        else
                          Text(_statusMessage,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: _statusColor,
                                  fontWeight: FontWeight.w500)),
                      ],
                    ),
            ),
            if (_isDragging)
              Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    border: Border.all(
                        color: Colors.tealAccent,
                        width: 3,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.download_for_offline,
                          size: 80, color: Colors.tealAccent),
                      const SizedBox(height: 20),
                      Text(
                        l10n.dropTargetOverlay,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPathSelectionScreen(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline,
              color: Colors.orangeAccent, size: 64),
          const SizedBox(height: 24),
          Text(
            l10n.pathSelectionTitle,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            _statusMessage,
            style: TextStyle(color: _statusColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.folder_open),
            label: Text(l10n.pathSelectionButtonManual),
            onPressed: _selectGamePathManually,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
          TextButton(
            onPressed: _findGamePath,
            child: Text(l10n.pathSelectionButtonRetry),
          )
        ],
      ),
    );
  }

  Widget _buildInstallerSection(bool canInstall, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12), // Padding vertical reducido
            ),
            icon: const Icon(Icons.archive),
            label: Text(l10n.selectModArchive),
            onPressed: _isLoading ? null : _pickArchive,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.download_for_offline),
            label: Text(l10n.installSelectedMod),
            onPressed: canInstall ? _installMod : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12), // Padding vertical reducido
              backgroundColor: canInstall ? Colors.tealAccent : Colors.grey[700],
              foregroundColor: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionPreviewSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.previewInstallTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              icon: const Icon(Icons.cancel, size: 18),
              label: Text(l10n.cancelSelection),
              onPressed: () => _clearSelection(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[700]!)),
          child: ListView.builder(
            itemCount: _modsToInstallPreviewMap.keys.length,
            itemBuilder: (context, index) {
              final folderName = _modsToInstallPreviewMap.keys.elementAt(index);
              final files = _modsToInstallPreviewMap[folderName]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(children: [
                      const Icon(Icons.folder_zip_outlined,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(folderName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                    ]),
                  ),
                  ...files.map((file) => Padding(
                    padding: const EdgeInsets.only(left: 24.0, top: 2.0, bottom: 2.0),
                    child: Row(children: [
                      const Icon(Icons.insert_drive_file_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(child: Text(file, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)))
                    ]),
                  ))
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModGridCard(ModInfo modInfo, AppLocalizations l10n) {
    final thumbnailUrl = (modInfo.gallery != null && modInfo.gallery!.isNotEmpty)
        ? modInfo.gallery!.first['thumbnail'] as String?
        : null;

    final updateInfo = _modUpdates[modInfo.directory.path];
    final hasUpdate = updateInfo != null;
    final updateIdentifier =
        hasUpdate ? modInfo.directory.path + updateInfo['version'] : '';
    final isIgnored = _ignoredUpdates.contains(updateIdentifier);
    final isHighlighted =
        _lastInstalledModNames.contains(p.basename(modInfo.directory.path));
    final hasCustomCover = modInfo.customCoverPath != null && modInfo.customCoverPath!.isNotEmpty;
    File? customCoverFile;
    if (hasCustomCover) {
      // Creamos el objeto File de forma optimista, sin comprobar si existe aquí.
      final path = p.join(modInfo.directory.path, modInfo.customCoverPath!);
      customCoverFile = File(path);
    }
    final displayVersion = modInfo.customVersion ?? modInfo.localVersion;
    final displayTag = modInfo.customFitMeshType ?? modInfo.fitMeshType ?? l10n.modCategoryOther;

    return Card(
      key: UniqueKey(),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: hasUpdate && !isIgnored
              ? Colors.yellowAccent
              : (isHighlighted ? Colors.tealAccent : Colors.transparent),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: InkWell( // Usamos InkWell para un mejor efecto visual al tocar
              onDoubleTap: () => _showDetailsPage(modInfo), // <-- ACCIÓN DE UN SOLO CLIC
              //onDoubleTap: () => _showImageGalleryDialog(modInfo), // Mantenemos el doble clic para la galería
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    // ++ USE THE NEW THUMBNAIL WIDGET ++
                    child: customCoverFile != null
                      ? Image.file(
                          customCoverFile,
                          key: ValueKey(modInfo.customCoverLastModified), // Volvemos a la ValueKey que es más eficiente
                          fit: BoxFit.cover,
                          alignment: modInfo.customCoverAlignment ?? Alignment.center,
                          // Si el archivo no se encuentra (por la condición de carrera),
                          // usa la imagen de Nexus como fallback.
                          errorBuilder: (context, error, stackTrace) {
                            return ModThumbnailImage(
                              imageUrl: thumbnailUrl,
                              thumbnailService: _thumbnailService,
                            );
                          },
                        )
                      : ModThumbnailImage(
                          imageUrl: thumbnailUrl,
                          thumbnailService: _thumbnailService,
                        ),
                  ),
                  if (!modInfo.isEnabled)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          l10n.modDisabledBadge,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (hasUpdate && !isIgnored)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: IconButton(
                        icon: const Icon(Icons.notification_important_rounded, color: Colors.yellowAccent),
                        tooltip: l10n.updateAvailable(
                          (updateInfo['version'] as String).toLowerCase().startsWith('v')
                            ? (updateInfo['version'] as String).substring(1)
                            : updateInfo['version']
                        ),
                        onPressed: () {
                          if (modInfo.nexusId != null) {
                            _showUpdateOptionsDialog(
                              newVersion: updateInfo['version'],
                              nexusId: modInfo.nexusId!,
                              fileId: updateInfo['fileId'],
                              uniqueIdentifier: updateIdentifier,
                            );
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: Tooltip(
                    message: modInfo.customName,
                    child: Text(
                      modInfo.customName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (displayVersion != null)
                   InkWell(
                     onTap: () => _showEditDialog(
                        context: context,
                        title: l10n.editVersionText,
                        label: l10n.customVersionText,
                        initialValue: displayVersion,
                        defaultValue: modInfo.localVersion ?? '',
                        onSave: (newValue) => _updateModCustomProperty(modInfo, newVersion: newValue),
                     ),
                     borderRadius: BorderRadius.circular(4),
                     child: Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                       child: Text(
                          'v$displayVersion',
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                     ),
                   ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: InkWell(
                    onTap: () => _showEditDialog(
                      context: context,
                      title: l10n.editTagText,
                      label: l10n.customTagText,
                      initialValue: displayTag,
                      defaultValue: modInfo.fitMeshType ?? l10n.modCategoryOther,
                      onSave: (newValue) => _updateModCustomProperty(modInfo, newTag: newValue),
                    ),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        displayTag,
                        style: const TextStyle(fontSize: 10, color: Colors.white70),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Transform.scale(
                      scale: 0.6,
                      child: Switch(
                        value: modInfo.isEnabled,
                        onChanged: _isLoading
                            ? null
                            : (value) {
                                if (value) {
                                  _enableMod(modInfo);
                                } else {
                                  _disableMod(modInfo);
                                }
                              },
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 20),
                      onSelected: (value) async {
                        switch (value) {
                          case 'edit':
                            _showEditModNameDialog(modInfo);
                            break;
                          case 'set_cover':
                            _setCustomCover(modInfo);
                            break;
                          case 'revert_cover':
                            _revertToDefaultCover(modInfo);
                            break;
                          case 'folder':
                            _showInExplorer(modInfo.directory);
                            break;
                          case 'gallery':
                            _showImageGalleryDialog(modInfo);
                            break;
                          case 'nexus':
                             if (modInfo.nexusId != null) {
                                final url = Uri.parse('https://www.nexusmods.com/stellarblade/mods/${modInfo.nexusId}');
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                }
                              }
                            break;
                          case 'delete':
                            _deleteModPermanently(modInfo);
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text(l10n.editModNameTooltip),
                        ),
                        PopupMenuItem(
                          value: 'set_cover',
                          child: Text(l10n.setCoverTooltip),
                        ),
                        if (modInfo.customCoverPath != null && modInfo.customCoverPath!.isNotEmpty)
                          PopupMenuItem(
                            value: 'revert_cover',
                            child: Text(l10n.restoreOriginalCoverText),
                          ),
                        PopupMenuItem(
                          value: 'folder',
                          child: Text(l10n.showInFolder),
                        ),
                        if (modInfo.nexusId != null)
                          PopupMenuItem(
                            value: 'gallery',
                            child: Text(l10n.viewImageGallery),
                          ),
                        if (modInfo.nexusId != null)
                          PopupMenuItem(
                            value: 'nexus',
                            child: Text(l10n.openInNexusMods),
                          ),
                        if (!modInfo.isEnabled)
                          const PopupMenuDivider(),
                        if (!modInfo.isEnabled)
                          PopupMenuItem(
                            value: 'delete',
                            child: Text(l10n.deletePermanently, style: const TextStyle(color: Colors.redAccent)),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

   Widget _buildModListTile(ModInfo modInfo, AppLocalizations l10n) {
    final isHighlighted =
        _lastInstalledModNames.contains(p.basename(modInfo.directory.path));
    final updateInfo = _modUpdates[modInfo.directory.path];
    final hasUpdate = updateInfo != null;
    final updateIdentifier =
        hasUpdate ? modInfo.directory.path + updateInfo['version'] : '';
    final isIgnored = _ignoredUpdates.contains(updateIdentifier);

    return Card(
      key: UniqueKey(),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      color: isHighlighted
          ? Colors.teal.withOpacity(0.3)
          : (modInfo.isEnabled
              ? Colors.grey[850]
              : Colors.orange[900]?.withOpacity(0.2)),
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: hasUpdate && !isIgnored
                  ? Colors.yellowAccent
                  : (isHighlighted ? Colors.tealAccent : Colors.transparent),
              width: hasUpdate && !isIgnored ? 2.0 : 1.5),
          borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        dense: true,
        visualDensity: VisualDensity.compact,
        leading:
            Icon(Icons.extension, color: modInfo.isEnabled ? Colors.tealAccent : Colors.grey),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Flexible(
              child: Text(
                modInfo.customName,
                style: TextStyle(
                  color: modInfo.isEnabled ? Colors.white : Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (modInfo.localVersion != null &&
                modInfo.localVersion!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'v${modInfo.localVersion}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Row(
          children: [
            if (isHighlighted)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child:
                    Icon(Icons.new_releases, color: Colors.yellow[700], size: 18),
              ),
            if (modInfo.origin == 'repaired')
              IconButton(
                padding: const EdgeInsets.only(right: 8.0),
                constraints: const BoxConstraints(),
                icon: Icon(Icons.build, color: Colors.amber[700], size: 16),
                onPressed: _showRepairedModInfoDialog,
                tooltip: l10n.repairedModTooltip,
                splashRadius: 16,
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!modInfo.isEnabled)
              IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                onPressed:
                    _isLoading ? null : () => _deleteModPermanently(modInfo),
                tooltip: l10n.deletePermanently,
              ),
            if (hasUpdate && !isIgnored)
              IconButton(
                icon: const Icon(Icons.notification_important,
                    color: Colors.yellowAccent),
                tooltip: l10n.updateAvailable(
                  (updateInfo['version'] as String).toLowerCase().startsWith('v')
                    ? (updateInfo['version'] as String).substring(1)
                    : updateInfo['version']
                ),
                onPressed: () {
                  if (modInfo.nexusId != null) {
                    _showUpdateOptionsDialog(
                      newVersion: updateInfo['version'],
                      nexusId: modInfo.nexusId!,
                      fileId: updateInfo['fileId'],
                      uniqueIdentifier: updateIdentifier,
                    );
                  }
                },
              ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white70),
              onPressed: _isLoading ? null : () => _showEditModNameDialog(modInfo),
              tooltip: l10n.editModNameTooltip,
            ),
            IconButton(
              icon: const Icon(Icons.folder_open, color: Colors.white70),
              onPressed:
                  _isLoading ? null : () => _showInExplorer(modInfo.directory),
              tooltip: l10n.showInFolder,
            ),
            if (modInfo.nexusId != null)
              IconButton(
                icon: const Icon(Icons.photo_library_outlined,
                    color: Colors.purpleAccent),
                onPressed: () => _showImageGalleryDialog(modInfo),
                tooltip: l10n.viewImageGallery,
              ),
            if (modInfo.nexusId != null)
              IconButton(
                icon: const Icon(Icons.link, color: Colors.lightBlueAccent),
                onPressed: () async {
                  final url = Uri.parse(
                      'https://www.nexusmods.com/stellarblade/mods/${modInfo.nexusId}');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                tooltip: l10n.openInNexusMods,
              ),
            if (modInfo.isEnabled)
              IconButton(
                icon: const Icon(Icons.power_settings_new,
                    color: Colors.orangeAccent),
                onPressed: _isLoading ? null : () => _disableMod(modInfo),
                tooltip: l10n.disableMod,
              )
            else
              IconButton(
                icon: const Icon(Icons.power_settings_new,
                    color: Colors.greenAccent),
                onPressed: _isLoading ? null : () => _enableMod(modInfo),
                tooltip: l10n.enableMod,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildModsListSection(
      String title, List<ModInfo> mods, AppLocalizations l10n, bool hasEnabledMods, bool hasDisabledMods) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent)),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: l10n.searchMods,
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.3),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[700]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[700]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.tealAccent),
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                 ToggleButtons(
                  isSelected: [_viewMode == ModListViewMode.grid, _viewMode == ModListViewMode.list],
                  onPressed: (index) async {
                    final newMode = index == 0 ? ModListViewMode.grid : ModListViewMode.list;
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setInt(AppPrefs.viewMode, newMode.index);
                    setState(() => _viewMode = newMode);
                  },
                  borderRadius: BorderRadius.circular(8),
                  constraints: const BoxConstraints(minHeight: 36, minWidth: 36),
                  children: [
                    Tooltip(message: l10n.viewTypeGrid, child: Icon(Icons.grid_view_outlined, size: 20)),
                    Tooltip(message: l10n.viewTypeList, child: Icon(Icons.view_list_outlined, size: 20)),
                  ],
                ),
                PopupMenuButton<ModFilter>(
                  icon: const Icon(Icons.filter_list),
                  tooltip: l10n.filterBy,
                  onSelected: (ModFilter result) async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setInt(AppPrefs.filterMode, result.index);
                    setState(() {
                      _currentFilter = result;
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    final filterOptions = [
                      {'value': ModFilter.all, 'text': l10n.filterAll},
                      {'value': ModFilter.enabled, 'text': l10n.filterEnabled},
                      {'value': ModFilter.disabled, 'text': l10n.filterDisabled},
                      {'value': ModFilter.repaired, 'text': l10n.filterRepaired},
                    ];
                    return filterOptions.map((option) {
                      return PopupMenuItem<ModFilter>(
                        value: option['value'] as ModFilter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(option['text'] as String),
                            if (_currentFilter == option['value'])
                              const Icon(Icons.check, color: Colors.tealAccent),
                          ],
                        ),
                      );
                    }).toList();
                  },
                ),
                PopupMenuButton<ModSort>(
                  icon: const Icon(Icons.sort),
                  tooltip: l10n.sortBy,
                  onSelected: (ModSort result) async {
                     final prefs = await SharedPreferences.getInstance();
                    await prefs.setInt(AppPrefs.sortMode, result.index);
                    setState(() {
                      _currentSort = result;
                    });
                  },
                  itemBuilder: (BuildContext context) {
                     final sortOptions = [
                      {'value': ModSort.date, 'text': l10n.sortByDate},
                      {'value': ModSort.name, 'text': l10n.sortByName},
                    ];
                    return sortOptions.map((option) {
                      return PopupMenuItem<ModSort>(
                        value: option['value'] as ModSort,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(option['text'] as String),
                            if (_currentSort == option['value'])
                              const Icon(Icons.check, color: Colors.tealAccent),
                          ],
                        ),
                      );
                    }).toList();
                  },
                ),
                IconButton(
                    icon: const Icon(Icons.folder_special_outlined),
                    onPressed: _isLoading
                        ? null
                        : () {
                            if(_finalModsPath != null) {
                              _showInExplorer(Directory(_finalModsPath!));
                            }
                          },
                    tooltip: l10n.openModsFolder),
                IconButton(
                    icon: const Icon(Icons.power_outlined, color: Colors.greenAccent),
                    onPressed: _isLoading || !hasDisabledMods ? null : _enableAllMods,
                    tooltip: l10n.enableAllModsTooltip
                ),
                IconButton(
                    icon: const Icon(Icons.power_off_outlined, color: Colors.orangeAccent),
                    onPressed: _isLoading || !hasEnabledMods ? null : _disableAllMods,
                    tooltip: l10n.disableAllModsTooltip
                ),
                IconButton(
                    icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
                    onPressed: _isLoading || !hasDisabledMods ? null : _deleteDisabledMods,
                    tooltip: l10n.deleteAllModsTooltip
                ),
                IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _isLoading
                        ? null
                        : () => _loadAllMods(clearHighlight: true),
                    tooltip: l10n.refreshList),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: mods.isEmpty
              ? Center(
                  child: Text(l10n.noModsFound,
                      style: const TextStyle(color: Colors.grey)))
              : AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _viewMode == ModListViewMode.grid
                  ? GridView.builder(
                      key: const ValueKey('grid'),
                      padding: const EdgeInsets.all(4),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 220,
                        childAspectRatio: 3 / 4.5,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: mods.length,
                      itemBuilder: (context, index) {
                        return _buildModGridCard(mods[index], l10n);
                      },
                    )
                  : ListView.builder(
                    key: const ValueKey('list'),
                    itemCount: mods.length,
                    itemBuilder: (context, index) {
                      return _buildModListTile(mods[index], l10n);
                    },
                  )
              )
        ),
      ],
    );
  }

  Future<void> _setCustomCover(ModInfo mod) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['png', 'jpg', 'jpeg', 'webp', 'bmp', 'pwebp', 'tiff'],
    dialogTitle: 'Selecciona una portada para el mod',
  );

  if (result != null && result.files.single.path != null) {
    final imageFile = File(result.files.single.path!);
    final Alignment? alignment = await _showCoverAlignmentDialog(imageFile);

    if (alignment == null) return;

    setState(() => _isLoading = true);
    try {
      // ===== INICIO DE LA CORRECCIÓN =====
      // 1. Guarda los cambios en el archivo nexus_info.json
      final extension = p.extension(imageFile.path);
      final newFileName = '_custom_cover$extension';
      final destinationPath = p.join(mod.directory.path, newFileName);
      await imageFile.copy(destinationPath);

      final infoFile = File(p.join(mod.directory.path, 'nexus_info.json'));
      Map<String, dynamic> data = {};
      if (await infoFile.exists()) {
        final content = await infoFile.readAsString();
        if (content.isNotEmpty) data = json.decode(content);
      }
      data['customCoverPath'] = newFileName;
      data['customCoverAlignmentX'] = alignment.x;
      data['customCoverAlignmentY'] = alignment.y;
      final encoder = JsonEncoder.withIndent('  ');
      await infoFile.writeAsString(encoder.convert(data));
      
      // 2. Llama a _loadAllMods() para recargar discretamente toda la lista
      // con la información 100% correcta desde los archivos.
      await _loadAllMods(clearHighlight: false);
      // ===== FIN DE LA CORRECCIÓN =====

    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        NotificationService.instance.show(
          context: context,
          type: NotificationType.error,
          title: l10n.errorRestoringCoverText(e.toString()),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}

  Future<Alignment?> _showCoverAlignmentDialog(File imageFile) async {
    final image = await decodeImageFromList(imageFile.readAsBytesSync());
    final imageSize = Size(image.width.toDouble(), image.height.toDouble());

    final l10n = AppLocalizations.of(context)!;
    Offset offset = Offset.zero;

    return showDialog<Alignment>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // ✅ SOLUCIÓN: Declaramos todas las variables necesarias aquí.
            Size? containerSize;
            Size? scaledImageSize;
            Rect? initialImageRect;
            double? cropWidth;
            double? cropHeight;

            return AlertDialog(
              title: Text(l10n.setCoverText),
              contentPadding: EdgeInsets.zero,
              backgroundColor: const Color(0xFF2d2d2d),
              content: SizedBox(
                width: 500,
                height: 600,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    containerSize = Size(constraints.maxWidth, constraints.maxHeight);
                    
                    final fittedSizes = applyBoxFit(BoxFit.contain, imageSize, containerSize!);
                    scaledImageSize = fittedSizes.destination;
                    
                    const cardAspectRatio = 3 / 4.2; // La proporción que ajustaste
                    
                    // ✅ SOLUCIÓN: Asignamos valores a las variables superiores (sin 'double' al inicio).
                    if ((scaledImageSize!.width / scaledImageSize!.height) > cardAspectRatio) {
                      cropHeight = scaledImageSize!.height;
                      cropWidth = cropHeight! * cardAspectRatio;
                    } else {
                      cropWidth = scaledImageSize!.width;
                      cropHeight = cropWidth! / cardAspectRatio;
                    }

                    final cropRect = Rect.fromCenter(
                      center: containerSize!.center(Offset.zero),
                      width: cropWidth!,
                      height: cropHeight!,
                    );

                    initialImageRect = Alignment.center.inscribe(
                      scaledImageSize!,
                      Rect.fromLTWH(0, 0, containerSize!.width, containerSize!.height),
                    );
                    
                    final minDx = cropRect.right - (initialImageRect!.left + scaledImageSize!.width);
                    final maxDx = cropRect.left - initialImageRect!.left;
                    final minDy = cropRect.bottom - (initialImageRect!.top + scaledImageSize!.height);
                    final maxDy = cropRect.top - initialImageRect!.top;
                    
                    return GestureDetector(
                      onPanUpdate: (details) {
                        setDialogState(() {
                          offset = Offset(
                            (offset.dx + details.delta.dx).clamp(min(minDx, maxDx), max(minDx, maxDx)),
                            (offset.dy + details.delta.dy).clamp(min(minDy, maxDy), max(minDy, maxDy)),
                          );
                        });
                      },
                      child: ClipRect(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              left: initialImageRect!.left + offset.dx,
                              top: initialImageRect!.top + offset.dy,
                              width: scaledImageSize!.width,
                              height: scaledImageSize!.height,
                              child: Image.file(imageFile, fit: BoxFit.fill),
                            ),
                            CustomPaint(
                              size: containerSize!,
                              painter: CropOverlayPainter(cropRect: cropRect),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.dialogActionCancel),
                ),
                ElevatedButton(
                  onPressed: () {
                    // ✅ SOLUCIÓN: Las variables ahora son accesibles y seguras de usar.
                    if (scaledImageSize == null || initialImageRect == null || cropWidth == null || cropHeight == null) return;
                    
                    final extraWidth = scaledImageSize!.width - cropWidth!;
                    final extraHeight = scaledImageSize!.height - cropHeight!;

                    final centerOffset = offset;
                    
                    final alignmentX = extraWidth > 0 ? (centerOffset.dx / (extraWidth / 2)) * -1 : 0.0;
                    final alignmentY = extraHeight > 0 ? (centerOffset.dy / (extraHeight / 2)) * -1 : 0.0;

                    final finalAlignment = Alignment(
                      alignmentX.clamp(-1.0, 1.0),
                      alignmentY.clamp(-1.0, 1.0),
                    );
                    
                    Navigator.of(context).pop(finalAlignment);
                  },
                  child: Text(l10n.dialogActionSave),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _revertToDefaultCover(ModInfo mod) async {
  if (mod.customCoverPath == null) return;

  setState(() => _isLoading = true);
  try {
    // 1. Borra el archivo de la imagen personalizada.
    final coverFile = File(p.join(mod.directory.path, mod.customCoverPath!));
    if (await coverFile.exists()) {
      await coverFile.delete();
    }

    // 2. Actualiza el archivo nexus_info.json para eliminar las referencias.
    final infoFile = File(p.join(mod.directory.path, 'nexus_info.json'));
    if (await infoFile.exists()) {
      final content = await infoFile.readAsString();
      Map<String, dynamic> data = json.decode(content);
      
      data.remove('customCoverPath');
      data.remove('customCoverAlignmentX');
      data.remove('customCoverAlignmentY');
      
      final encoder = JsonEncoder.withIndent('  ');
      await infoFile.writeAsString(encoder.convert(data));
    }

    // ===== CORRECCIÓN AQUÍ =====
    // 3. Llama a _loadAllMods() para recargar la lista con la información
    // 100% correcta desde los archivos, igual que en la función anterior.
    await _loadAllMods(clearHighlight: false);
    // ===========================

  } catch (e) {
    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      NotificationService.instance.show(
        context: context,
        type: NotificationType.error,
        title: l10n.errorRestoringCoverText(e.toString()),
      );
    }
  } finally {
    setState(() => _isLoading = false);
  }
}

  /// Consulta la API de Nexus para verificar si un ID de mod es válido para Stellar Blade.
  Future<bool> _isValidNexusId(String modId) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      return false; // No se puede validar sin una API key.
    }
    try {
      final uri = Uri.parse('https://api.nexusmods.com/v1/games/stellarblade/mods/$modId.json');
      final response = await http.get(
        uri,
        headers: {'apikey': _apiKey!, 'accept': 'application/json'},
      );
      // Si la respuesta es 200 OK, el mod existe y el ID es válido.
      return response.statusCode == 200;
    } catch (e) {
      print('Error during API validation for mod ID $modId: $e');
      return false; // Error de red u otro problema.
    }
  }

  Future<void> _showDetailsPage(ModInfo modInfo) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModDetailsPage(
          modInfo: modInfo,
          thumbnailService: _thumbnailService,
          onSaveDetails: (newData) => _updateModDetails(modInfo, newData),
        ),
      ),
    );
    // Refresca el estado por si el nombre (nombre de la carpeta) ha cambiado.
    setState(() {});
  }

  Future<void> _updateUserNotes(ModInfo mod, String newNotes, dynamic l10n) async {
    try {
      final infoFile = File(p.join(mod.directory.path, 'nexus_info.json'));
      Map<String, dynamic> data = {};
      if (await infoFile.exists()) {
        final content = await infoFile.readAsString();
        if (content.isNotEmpty) data = json.decode(content);
      }

      data['userNotes'] = newNotes;

      final encoder = JsonEncoder.withIndent('  ');
      await infoFile.writeAsString(encoder.convert(data));

      // Actualiza el estado en memoria para un refresco instantáneo
      final modIndex = _allMods.indexWhere((m) => m.directory.path == mod.directory.path);
      if (modIndex != -1) {
        setState(() {
          _allMods[modIndex].userNotes = newNotes;
        });
      }
    } catch (e) {
      print('Error saving user notes: $e');
      if (mounted) {
        NotificationService.instance.show(
          context: context,
          type: NotificationType.error,
          title: l10n.errorSavingNotes,
          description: e.toString(),
        );
      }
    }
  }

  /// Fetches gallery images for a mod from Nexus Mods API.
  Future<List<Map<String, dynamic>>?> _fetchModImages(String nexusId) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      print("API Key not configured, not fetching mod images.");
      return null;
    }
    final headers = {'apikey': _apiKey!, 'accept': 'application/json'};
    try {
      final modDetailsUrl = Uri.parse(
          'https://api.nexusmods.com/v1/games/stellarblade/mods/$nexusId.json');
      var response = await http.get(modDetailsUrl, headers: headers);

      if (response.statusCode == 200) {
        final modDetails = json.decode(response.body);
        final pictureUrl = modDetails['picture_url'] as String?;
        if (pictureUrl != null && pictureUrl.isNotEmpty) {
          return [
            {"image": pictureUrl, "thumbnail": pictureUrl}
          ];
        }
      }
      print("Failed to fetch mod images for mod $nexusId (code: ${response.statusCode}).");
      return null;
    } catch (e) {
      print("An exception occurred while fetching mod images for mod $nexusId: $e");
      return null;
    }
  }

  /// Muestra un diálogo para editar un valor de texto personalizado (versión o etiqueta).
  Future<void> _showEditDialog({
    required BuildContext context,
    required String title,
    required String label,
    required String initialValue,
    required String defaultValue,
    required Function(String) onSave,
  }) async {
    final controller = TextEditingController(text: initialValue);
    final l10n = AppLocalizations.of(context)!;

    final newValue = await showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // --- INICIO DE LA CORRECCIÓN ---
            // Compara el texto actual con el valor predeterminado real del mod.
            final bool isCurrentlyDefault = controller.text == defaultValue;

            return AlertDialog(
              title: Text(title),
              content: TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(labelText: label),
                onChanged: (value) => setDialogState(() {}),
              ),
              actions: [
                TextButton(
                  // Se deshabilita si el valor actual YA ES el predeterminado.
                  onPressed: isCurrentlyDefault
                      ? null
                      : () {
                          // Al hacer clic, el campo de texto se restaura al valor predeterminado.
                          setDialogState(() {
                            controller.text = defaultValue;
                            controller.selection = TextSelection.fromPosition(
                              TextPosition(offset: controller.text.length),
                            );
                          });
                        },
                  child: Text(l10n.dialogActionResetToDefault),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.dialogActionCancel),
                ),
                ElevatedButton(
                  // Al guardar, se envía el valor que esté actualmente en el campo.
                  onPressed: () => Navigator.of(context).pop(controller.text),
                  child: Text(l10n.dialogActionSave),
                ),
              ],
            );
            // --- FIN DE LA CORRECCIÓN ---
          },
        );
      },
    );

    controller.dispose();

    if (newValue != null) {
      onSave(newValue);
    }
  }

  /// Guarda una propiedad personalizada (versión o etiqueta) en el JSON y actualiza el estado.
  Future<void> _updateModCustomProperty(ModInfo mod, {String? newVersion, String? newTag}) async {
  setState(() => _isLoading = true);
  try {
    final infoFile = File(p.join(mod.directory.path, 'nexus_info.json'));
    Map<String, dynamic> data = {};
    if (await infoFile.exists()) {
      final content = await infoFile.readAsString();
      if(content.isNotEmpty) data = json.decode(content);
    }

    if (newVersion != null) {
      if (newVersion.isEmpty) {
        data.remove('customVersion');
      } else {
        data['customVersion'] = newVersion;
      }
    }

    if (newTag != null) {
      if (newTag.isEmpty) {
        data.remove('customFitMeshType');
      } else {
        data['customFitMeshType'] = newTag;
      }
    }

    final encoder = JsonEncoder.withIndent('  ');
    await infoFile.writeAsString(encoder.convert(data));

    // ===== CORRECCIÓN AQUÍ =====
    // 1. Se elimina la lógica manual que intentaba actualizar el estado local.
    // 2. Se llama a _loadAllMods() para recargar la lista con la información
    //    100% correcta desde el archivo, igual que con las portadas.
    await _loadAllMods(clearHighlight: false);
    // ===========================

  } catch (e) {
    print('Error updating custom property: $e');
  } finally {
    setState(() => _isLoading = false);
  }
}
  // Este método se encargará de guardar la URL personalizada en el archivo JSON del mod.
  Future<void> _updateModCustomSourceUrl(ModInfo mod, String newUrl, dynamic l10n) async {
    try {
      final infoFile = File(p.join(mod.directory.path, 'nexus_info.json'));
      Map<String, dynamic> data = {};
      if (await infoFile.exists()) {
        final content = await infoFile.readAsString();
        if (content.isNotEmpty) data = json.decode(content);
      }

      if (newUrl.isEmpty) {
        data.remove('customSourceUrl');
      } else {
        data['customSourceUrl'] = newUrl;
      }

      final encoder = JsonEncoder.withIndent('  ');
      await infoFile.writeAsString(encoder.convert(data));

      // Actualiza el estado en memoria para un refresco instantáneo sin recargar todo
      final modIndex = _allMods.indexWhere((m) => m.directory.path == mod.directory.path);
      if (modIndex != -1) {
         final updatedMod = ModInfo(
          directory: mod.directory, isEnabled: mod.isEnabled, nexusId: mod.nexusId,
          localVersion: mod.localVersion, lastModified: mod.lastModified,
          origin: mod.origin, displayName: mod.displayName, customName: mod.customName,
          gallery: mod.gallery, fitMeshType: mod.fitMeshType,
          customCoverPath: mod.customCoverPath, customCoverAlignment: mod.customCoverAlignment,
          customCoverLastModified: mod.customCoverLastModified,
          customVersion: mod.customVersion, customFitMeshType: mod.customFitMeshType,
          summary: mod.summary, author: mod.author, userNotes: mod.userNotes,
          customSourceUrl: newUrl.isEmpty ? null : newUrl, // Aplica el valor actualizado
        );
        setState(() { _allMods[modIndex] = updatedMod; });
      }
    } catch (e) {
      print('Error saving custom source URL: $e');
      if (mounted) {
        NotificationService.instance.show(
          context: context,
          type: NotificationType.error,
          title: l10n.errorSavingUrl,
          description: e.toString(),
        );
      }
    }
  }

  Future<ModInfo?> _updateModDetails(ModInfo mod, Map<String, dynamic> newData) async {
    try {
      // La lógica para renombrar la carpeta se ha eliminado por completo.
      // La variable 'modDirectory' ahora siempre se refiere a la carpeta original.
      Directory modDirectory = mod.directory;
  
      final infoFile = File(p.join(modDirectory.path, 'nexus_info.json'));
      Map<String, dynamic> data = {};
      if (await infoFile.exists()) {
        final content = await infoFile.readAsString();
        if (content.isNotEmpty) data = json.decode(content);
      }
      
      if (newData.containsKey('newCoverFile')) {
        final imageFile = newData['newCoverFile'] as File;
        final alignment = newData['newCoverAlignment'] as Alignment?;
        final extension = p.extension(imageFile.path);
        final newFileName = '_custom_cover$extension';
        final destinationPath = p.join(modDirectory.path, newFileName);
        await imageFile.copy(destinationPath);
        data['customCoverPath'] = newFileName;
        if (alignment != null) {
          data['customCoverAlignmentX'] = alignment.x;
          data['customCoverAlignmentY'] = alignment.y;
        }
      }
      
      if (newData.containsKey('customName')) {
        final value = newData['customName'] as String;
        if (value.isEmpty || value == mod.displayName) data.remove('customName');
        else data['customName'] = value;
      }
      if (newData.containsKey('author')) {
        final value = newData['author'] as String;
        if (value.isEmpty || value == mod.author) data.remove('customAuthor');
        else data['customAuthor'] = value;
      }
      
      if (newData.containsKey('summary')) {
        final newCustomSummary = newData['summary'] as String;
        if (newCustomSummary.isEmpty || newCustomSummary == mod.summary) {
          data.remove('customSummary');
        } else {
          data['customSummary'] = newCustomSummary;
        }
      }
  
      if (newData.containsKey('userNotes')) data['userNotes'] = newData['userNotes'];
      
      if (newData.containsKey('customSourceUrl')) {
        final value = newData['customSourceUrl'] as String;
        if (value.isEmpty || value == mod.sourceUrl) data.remove('customSourceUrl');
        else data['customSourceUrl'] = value;
      }
      
      final encoder = JsonEncoder.withIndent('  ');
      await infoFile.writeAsString(encoder.convert(data));
  
      await _loadAllMods(clearHighlight: false);
  
      // Busca el mod actualizado usando la ruta original, que ya no cambia.
      return _allMods.firstWhere((m) => m.directory.path == modDirectory.path, orElse: () => mod);
    } catch (e) {
      print('Error updating mod details: $e');
      final l10n = AppLocalizations.of(context)!;
      if (mounted) {
        NotificationService.instance.show(
          context: context, type: NotificationType.error,
          title: l10n.errorSavingChanges, description: e.toString(),
        );
      }
      return null;
    }
  }

  Future<String?> _getVersionFromCnsPackage(Directory sourceSBDir) async {
  try {
    final luaFile = File(p.join(sourceSBDir.path, 'Binaries', 'Win64', 'ue4ss', 'Mods', 'DekCNS', 'Scripts', 'main.lua'));
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

}

// main.dart (Modificación en el estilo del botón en ModDetailsPage)

class ModDetailsPage extends StatefulWidget {
  final ModInfo modInfo;
  final ThumbnailService thumbnailService;
  // Cambia Future<void> por Future<ModInfo?>
  final Future<ModInfo?> Function(Map<String, dynamic> newData) onSaveDetails;

  const ModDetailsPage({
    super.key,
    required this.modInfo,
    required this.thumbnailService,
    required this.onSaveDetails,
  });

  @override
  State<ModDetailsPage> createState() => _ModDetailsPageState();
}

class _ModDetailsPageState extends State<ModDetailsPage> {
  late ModInfo currentModInfo;
  ImageProvider? _imageProvider;
  bool _isImageLoading = true;
  bool _isTranslating = false;
  bool _showTranslateButton = false;
  bool _isDependenciesInitialized = false;

  @override
void initState() {
  super.initState();
  // --- CORRECCIÓN: Asegúrate de que esta línea esté presente ---
  currentModInfo = widget.modInfo;
  // -----------------------------------------------------------
  _loadImageProvider();
}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Este método se ejecuta después de initState y tiene un context válido.
    // Usamos un flag para que solo se ejecute la primera vez.
    if (!_isDependenciesInitialized) {
      _checkIfTranslationIsPossible();
      _isDependenciesInitialized = true;
    }
  }

  @override
  void didUpdateWidget(covariant ModDetailsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.modInfo != oldWidget.modInfo) {
      setState(() {
        currentModInfo = widget.modInfo;
        _showTranslateButton = false;
      });
      _loadImageProvider();
      _checkIfTranslationIsPossible();
    }
  }

  void _checkIfTranslationIsPossible() async {
  final summary = currentModInfo.summary;
  if (summary == null ||
      summary.trim().isEmpty ||
      (currentModInfo.customSummary?.isNotEmpty ?? false)) {
    if (mounted) setState(() => _showTranslateButton = false);
    return;
  }
  
  if (!mounted) return;
  final String currentLocale = Localizations.localeOf(context).languageCode;

  try {
    final translator = GoogleTranslator();
    final snippet = summary.length > 150 ? summary.substring(0, 150) : summary;

    // --- SOLUCIÓN DEFINITIVA: USAR UN IDIOMA PIVOTE ---
    // Traducimos la muestra a un tercer idioma neutral (alemán) para forzar
    // una detección de origen fiable, sin importar el idioma de la app.
    const String pivotLocale = 'de';
    final translation = await translator.translate(snippet, to: pivotLocale);
    final detectedLanguageCode = translation.sourceLanguage.code.toLowerCase();
    // --- FIN DE LA SOLUCIÓN DEFINITIVA ---

    print('Idioma detectado: $detectedLanguageCode, Idioma de la App: $currentLocale');

    if (mounted && detectedLanguageCode != currentLocale && detectedLanguageCode != 'auto') {
      setState(() => _showTranslateButton = true);
    } else {
      setState(() => _showTranslateButton = false);
    }
  } catch (e) {
    print("Error detectando el idioma: $e");
    if (mounted) setState(() => _showTranslateButton = false);
  }
}

  Future<void> _translateSummary() async {
    final l10n = AppLocalizations.of(context)!;
    if (currentModInfo.summary == null || currentModInfo.summary!.trim().isEmpty) return;

    setState(() => _isTranslating = true);

    try {
      final translator = GoogleTranslator();
      final currentLocale = Localizations.localeOf(context).languageCode;
      
      final translation = await translator.translate(
        currentModInfo.summary!,
        from: 'auto', // Detecta el idioma automáticamente
        to: currentLocale,
      );

      final updatedMod = await widget.onSaveDetails({'summary': translation.text});
      
      // Actualiza la UI con la nueva información.
      if (updatedMod != null && mounted) {
        setState(() {
          currentModInfo = updatedMod;
          _showTranslateButton = false; // Oculta el botón después de traducir.
        });
      }
    } catch (e) {
      if (mounted) {
        NotificationService.instance.show(
          context: context,
          type: NotificationType.error,
          title: l10n.errorTranslation,
          description: e.toString(),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isTranslating = false);
      }
    }
  }

  Future<void> _loadImageProvider() async {
    if (currentModInfo.customCoverPath != null && currentModInfo.customCoverPath!.isNotEmpty) {
      final path = p.join(currentModInfo.directory.path, currentModInfo.customCoverPath!);
      final file = File(path);
      if (file.existsSync()) {
        _imageProvider = FileImage(file)..evict();
        if (mounted) setState(() => _isImageLoading = false);
        return;
      }
    }

    final imageUrl = (currentModInfo.gallery != null && currentModInfo.gallery!.isNotEmpty)
        ? currentModInfo.gallery!.first['image'] as String? : null;

    if (imageUrl != null) {
      final file = await widget.thumbnailService.getThumbnail(imageUrl);
      if (mounted && file != null) {
        _imageProvider = FileImage(file);
        setState(() => _isImageLoading = false);
      }
    } else {
       if (mounted) setState(() => _isImageLoading = false);
    }
  }

  // --- DIÁLOGO GENERAL SIMPLIFICADO ---
  // Ahora solo edita nombre, autor, URL y portada.
  Future<void> _showGeneralEditDialog() async {
    final l10n = AppLocalizations.of(context)!;
    
    final nameController = TextEditingController(text: currentModInfo.customName);
    final authorController = TextEditingController(text: currentModInfo.customAuthor ?? currentModInfo.author ?? '');
    final String defaultUrl = currentModInfo.sourceUrl ??
        (currentModInfo.nexusId != null
            ? 'https://www.nexusmods.com/stellarblade/mods/${currentModInfo.nexusId}'
            : '');
    
    // El controlador se inicializa con la URL personalizada, o con la predeterminada (ahora siempre correcta).
    final urlController = TextEditingController(text: currentModInfo.customSourceUrl ?? defaultUrl);

    File? newCoverFile;
    Alignment? newCoverAlignment;

    final updatedData = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          final bool canResetName = nameController.text != currentModInfo.displayName;
          final bool canResetAuthor = authorController.text != (currentModInfo.author ?? '');
          final bool canResetUrl = urlController.text != (currentModInfo.sourceUrl ?? '');

          Widget buildEditableRow(TextEditingController controller, String label, String defaultValue, bool canReset) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: TextField(controller: controller, onChanged: (v) => setDialogState((){}), decoration: InputDecoration(labelText: label, isDense: true))),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: !canReset ? null : () => setDialogState(() => controller.text = defaultValue),
                  child: Text(l10n.dialogActionResetToDefault, style: const TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4)),
                ),
              ],
            );
          }

          return AlertDialog(
            title: Text(l10n.editModTitle),
            content: SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(children: [
                      Expanded(child: TextField(controller: nameController, onChanged: (v) => setDialogState((){}), decoration: InputDecoration(labelText: l10n.modNameLabel))),
                      TextButton(onPressed: !canResetName ? null : () => setDialogState(() => nameController.text = currentModInfo.displayName), child: Text(l10n.dialogActionResetToDefault)),
                    ]),
                    const SizedBox(height: 16),
                    // --- CAMPO DE AUTOR ---
                    Row(children: [
                      Expanded(child: TextField(controller: authorController, onChanged: (v) => setDialogState((){}), decoration: InputDecoration(labelText: l10n.authorLabel))),
                      TextButton(onPressed: !canResetAuthor ? null : () => setDialogState(() => authorController.text = currentModInfo.author ?? ''), child: Text(l10n.dialogActionResetToDefault)),
                    ]),
                    const SizedBox(height: 16),
                    // --- CAMPO DE URL ---
                    Row(children: [
                      Expanded(child: TextField(controller: urlController, onChanged: (v) => setDialogState((){}), decoration: InputDecoration(labelText: l10n.urlLabel))),
                      TextButton(onPressed: !canResetUrl ? null : () => setDialogState(() => urlController.text = defaultUrl), child: Text(l10n.dialogActionResetToDefault)),
                    ]),
                    const SizedBox(height: 24),
                    if (newCoverFile != null)
                      Image.file(newCoverFile!, height: 100),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.image_search),
                      label: Text(l10n.changeCoverButton),
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['png', 'jpg', 'jpeg', 'webp', 'bmp', 'pwebp', 'tiff']);
                        if (result != null && result.files.single.path != null) {
                          final pickedFile = File(result.files.single.path!);
                          final alignment = await _showCoverAlignmentDialog(pickedFile);
                          setDialogState(() {
                            newCoverFile = pickedFile;
                            newCoverAlignment = alignment;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.dialogActionCancel)),
              ElevatedButton(
                onPressed: () {
                  final Map<String, dynamic> dataToSave = {
                    'customName': nameController.text,
                    'author': authorController.text,
                    'customSourceUrl': urlController.text,
                  };
                  if (newCoverFile != null) {
                    dataToSave['newCoverFile'] = newCoverFile;
                    dataToSave['newCoverAlignment'] = newCoverAlignment;
                  }
                  Navigator.of(context).pop(dataToSave);
                },
                child: Text(l10n.dialogActionSave),
              ),
            ],
          );
        });
      },
    );

    nameController.dispose();
    authorController.dispose();
    urlController.dispose();

   if (updatedData != null) {
      // 1. Llama a la función de guardado y espera el resultado.
      final updatedModInfo = await widget.onSaveDetails(updatedData);
      
      // 2. Si el guardado fue exitoso, actualiza el estado con la información correcta.
      if (updatedModInfo != null && mounted) {
        setState(() {
          // 'updatedModInfo' contiene la ruta a la carpeta real y sin cambios.
          currentModInfo = updatedModInfo;
          _loadImageProvider();
        });
      }
    }
  }
  
  // --- NUEVO DIÁLOGO GENÉRICO ---
  // Para editar un solo campo de texto a la vez (descripción, notas, etc.).
  Future<String?> _showSingleFieldEditDialog({
    required String title,
    required String label,
    required String initialValue,
    String? defaultValue,
  }) async {
    final controller = TextEditingController(text: initialValue);
    final l10n = AppLocalizations.of(context)!;

    return await showDialog<String>(
      context: context,
      builder: (context) {
        // --- INICIO DE LA MODIFICACIÓN ---
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // Comprueba si el texto actual es igual al valor predeterminado.
            final bool isCurrentlyDefault = controller.text == (defaultValue ?? '');

            return AlertDialog(
              title: Text(title),
              content: TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(labelText: label),
                maxLines: null, // Permite múltiples líneas
                onChanged: (value) => setDialogState(() {}), // Actualiza el estado al escribir
              ),
              actions: [
                // Solo muestra el botón si se proporciona un valor predeterminado
                if (defaultValue != null)
                  TextButton(
                    onPressed: isCurrentlyDefault ? null : () {
                      setDialogState(() {
                        controller.text = defaultValue;
                        // Mueve el cursor al final del texto
                        controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.text.length),
                        );
                      });
                    },
                    child: Text(l10n.dialogActionResetToDefault),
                  ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.dialogActionCancel),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(controller.text),
                  child: Text(l10n.dialogActionSave),
                ),
              ],
            );
          },
        );
        // --- FIN DE LA MODIFICACIÓN ---
      },
    );
  }

  Future<Alignment?> _showCoverAlignmentDialog(File imageFile) async {
    final image = await decodeImageFromList(imageFile.readAsBytesSync());
    final imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final l10n = AppLocalizations.of(context)!;
    Offset offset = Offset.zero;

    return showDialog<Alignment>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Size? containerSize; Size? scaledImageSize; Rect? initialImageRect;
            double? cropWidth; double? cropHeight;
            return AlertDialog(
              title: Text(l10n.setCoverText), contentPadding: EdgeInsets.zero,
              backgroundColor: const Color(0xFF2d2d2d),
              content: SizedBox(width: 500, height: 600,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    containerSize = Size(constraints.maxWidth, constraints.maxHeight);
                    final fittedSizes = applyBoxFit(BoxFit.contain, imageSize, containerSize!);
                    scaledImageSize = fittedSizes.destination;
                    const cardAspectRatio = 3 / 4.2;
                    if ((scaledImageSize!.width / scaledImageSize!.height) > cardAspectRatio) {
                      cropHeight = scaledImageSize!.height;
                      cropWidth = cropHeight! * cardAspectRatio;
                    } else {
                      cropWidth = scaledImageSize!.width;
                      cropHeight = cropWidth! / cardAspectRatio;
                    }
                    final cropRect = Rect.fromCenter(center: containerSize!.center(Offset.zero), width: cropWidth!, height: cropHeight!);
                    initialImageRect = Alignment.center.inscribe(scaledImageSize!, Rect.fromLTWH(0, 0, containerSize!.width, containerSize!.height));
                    final minDx = cropRect.right - (initialImageRect!.left + scaledImageSize!.width);
                    final maxDx = cropRect.left - initialImageRect!.left;
                    final minDy = cropRect.bottom - (initialImageRect!.top + scaledImageSize!.height);
                    final maxDy = cropRect.top - initialImageRect!.top;
                    return GestureDetector(
                      onPanUpdate: (details) {
                        setDialogState(() {
                          offset = Offset(
                            (offset.dx + details.delta.dx).clamp(min(minDx, maxDx), max(minDx, maxDx)),
                            (offset.dy + details.delta.dy).clamp(min(minDy, maxDy), max(minDy, maxDy)),
                          );
                        });
                      },
                      child: ClipRect(
                        child: Stack(alignment: Alignment.center,
                          children: [
                            Positioned(
                              left: initialImageRect!.left + offset.dx, top: initialImageRect!.top + offset.dy,
                              width: scaledImageSize!.width, height: scaledImageSize!.height,
                              child: Image.file(imageFile, fit: BoxFit.fill),
                            ),
                            CustomPaint(size: containerSize!, painter: CropOverlayPainter(cropRect: cropRect)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.dialogActionCancel)),
                ElevatedButton(
                  onPressed: () {
                    if (scaledImageSize == null || initialImageRect == null || cropWidth == null || cropHeight == null) return;
                    final extraWidth = scaledImageSize!.width - cropWidth!;
                    final extraHeight = scaledImageSize!.height - cropHeight!;
                    final centerOffset = offset;
                    final alignmentX = extraWidth > 0 ? (centerOffset.dx / (extraWidth / 2)) * -1 : 0.0;
                    final alignmentY = extraHeight > 0 ? (centerOffset.dy / (extraHeight / 2)) * -1 : 0.0;
                    final finalAlignment = Alignment(alignmentX.clamp(-1.0, 1.0), alignmentY.clamp(-1.0, 1.0));
                    Navigator.of(context).pop(finalAlignment);
                  },
                  child: Text(l10n.dialogActionSave),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _onLinkButtonPressed() async {
    final urlString = currentModInfo.customSourceUrl ?? currentModInfo.sourceUrl;
    if (urlString != null && urlString.isNotEmpty) {
      final url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } else {
      _showGeneralEditDialog();
    }
  }


  Future<void> _showInExplorer() async {
    final uri = Uri.file(currentModInfo.directory.path);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorOpenFolder(currentModInfo.directory.path)),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool hasLink = (currentModInfo.customSourceUrl ?? currentModInfo.sourceUrl)?.isNotEmpty ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFF1e1e1e),
      appBar: AppBar(
        title: Text(currentModInfo.customName, overflow: TextOverflow.ellipsis),
        backgroundColor: const Color(0xFF2a2a2a),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded),
            tooltip: l10n.editButtonTooltip,
            onPressed: _showGeneralEditDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 300, 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        image: _imageProvider != null
                            ? DecorationImage(
                                image: _imageProvider!,
                                fit: BoxFit.cover,
                                alignment: currentModInfo.customCoverAlignment ?? Alignment.center,
                              )
                            : null,
                      ),
                      child: _isImageLoading
                          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.tealAccent)))
                          : (_imageProvider == null
                              ? Center(
                                  child: Text(
                                    currentModInfo.customName,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white70),
                                  ),
                                )
                              : null),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Tooltip(
                    message: hasLink ? l10n.openLinkButtonText : l10n.addLinkTooltip,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: hasLink
                            ? LinearGradient(
                                colors: [
                                  Theme.of(context).colorScheme.secondary,
                                  const Color(0xFF00695C),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: hasLink ? null : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: hasLink ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ] : [],
                        border: hasLink ? null : Border.all(color: Colors.grey.withOpacity(0.4)),
                      ),
                      child: ElevatedButton.icon(
                        icon: Icon(
                          hasLink ? Icons.link_rounded : Icons.add_link_rounded,
                          size: 20,
                          color: hasLink ? Colors.white : Colors.grey[400],
                        ),
                        label: Text(
                          hasLink ? l10n.openLinkButtonText : l10n.addLinkButtonText,
                          style: TextStyle(
                            color: hasLink ? Colors.white : Colors.grey[400],
                            fontSize: 16,
                          ),
                        ),
                        onPressed: _onLinkButtonPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Tooltip(
                    message: l10n.showInFolder,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.folder_open, size: 20),
                      label: Text(l10n.showInFolder),
                      onPressed: _showInExplorer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF424242), // Color gris oscuro
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 30),

            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentModInfo.customName,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if ((currentModInfo.customVersion ?? currentModInfo.localVersion) != null &&
                        (currentModInfo.customVersion ?? currentModInfo.localVersion)!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          '${l10n.modVersion}: ${currentModInfo.customVersion ?? currentModInfo.localVersion}',
                          style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.7)),
                        ),
                      ),
                    const SizedBox(height: 15),
                    if ((currentModInfo.customAuthor ?? currentModInfo.author)?.isNotEmpty ?? false) ...[
                      Text(l10n.modAuthor, style: const TextStyle(color: Colors.tealAccent, fontSize: 14)),
                      const SizedBox(height: 4),
                      // Muestra el autor personalizado o el original
                      Text(currentModInfo.customAuthor ?? currentModInfo.author!, style: const TextStyle(fontSize: 18, color: Colors.white)),
                      const SizedBox(height: 20),
                    ],
                    // --- SECCIÓN DE DESCRIPCIÓN EDITABLE ---
                    _buildInfoSection(
                      context,
                      l10n.modDescription,
                      // Muestra la descripción personalizada, si no, la original.
                      currentModInfo.customSummary ?? currentModInfo.summary?.trim() ?? l10n.noDescriptionAvailable,
                      icon: Icons.description_outlined,
                      isEditable: true,
                      onEdit: () async {
                        final newSummary = await _showSingleFieldEditDialog(
                          title: l10n.modDescription,
                          label: l10n.summaryLabel,
                          // El valor inicial para editar es el personalizado o el original.
                          initialValue: currentModInfo.customSummary ?? currentModInfo.summary ?? '',
                          // El valor para restablecer es SIEMPRE el original.
                          defaultValue: currentModInfo.summary ?? '',
                        );
                        if (newSummary != null) {
                          final updatedMod = await widget.onSaveDetails({'summary': newSummary});
                          if (updatedMod != null && mounted) {
                            setState(() {
                               currentModInfo = updatedMod;
                            });
                          }
                        }
                      },
                      translateButton: (_showTranslateButton)
        ? (_isTranslating
            ? const Padding(
                padding: EdgeInsets.all(4.0),
                child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2)))
            : IconButton(
                icon: const Icon(Icons.translate,
                    color: Colors.white70, size: 20),
                onPressed: _translateSummary,
                tooltip: l10n.translateDescription,
                splashRadius: 20,
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ))
        : null,
                    ),
                    const SizedBox(height: 20),
                    // --- SECCIÓN DE NOTAS EDITABLE ---
                    _buildInfoSection(
                      context,
                      l10n.personalNotes,
                      currentModInfo.userNotes?.isNotEmpty ?? false ? currentModInfo.userNotes! : l10n.noNotesAvailable,
                      icon: Icons.edit_note_outlined,
                      isEditable: true,
                      onEdit: () async {
                        final newNotes = await _showSingleFieldEditDialog(
                          title: l10n.personalNotes,
                          label: l10n.notesLabel,
                          initialValue: currentModInfo.userNotes ?? '',
                        );
                        if (newNotes != null) {
                           await widget.onSaveDetails({'userNotes': newNotes});
                           setState(() {
                             currentModInfo.userNotes = newNotes;
                           });
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    if ((currentModInfo.customFitMeshType ?? currentModInfo.fitMeshType) != null &&
                      (currentModInfo.customFitMeshType ?? currentModInfo.fitMeshType)!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        '${l10n.modCategory}: ${currentModInfo.customFitMeshType ?? currentModInfo.fitMeshType}',
                        style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET AUXILIAR MODIFICADO ---
  // Ahora incluye un botón de editar opcional.
  Widget _buildInfoSection(BuildContext context, String title, String content,
      {IconData? icon,
      bool isEditable = false,
      VoidCallback? onEdit,
      Widget? translateButton}) { // El parámetro ahora está definido aquí
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: Colors.tealAccent.withOpacity(0.8), size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    title,
                    style: const TextStyle(color: Colors.tealAccent, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  if (isEditable)
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.white70, size: 20),
                      onPressed: onEdit,
                      tooltip: l10n.editButtonTooltip,
                      splashRadius: 20,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  // --- CORRECCIÓN 3: Uso del parámetro ---
                  if (translateButton != null) ...[ // Se usa la variable del parámetro
                    const SizedBox(width: 8),
                    translateButton, // Se usa la variable del parámetro
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(
              color: content == l10n.noDescriptionAvailable || content == l10n.noNotesAvailable
                  ? Colors.white.withOpacity(0.5)
                  : Colors.white.withOpacity(0.9),
              fontStyle: content == l10n.noDescriptionAvailable || content == l10n.noNotesAvailable
                  ? FontStyle.italic
                  : FontStyle.normal,
              height: 1.5,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

// ++ NEW WIDGET FOR OPTIMIZED THUMBNAILS ++
class ModThumbnailImage extends StatefulWidget {
  final String? imageUrl;
  final ThumbnailService thumbnailService;

  const ModThumbnailImage({
    super.key,
    required this.imageUrl,
    required this.thumbnailService,
  });

  @override
  State<ModThumbnailImage> createState() => _ModThumbnailImageState();
}

class _ModThumbnailImageState extends State<ModThumbnailImage> {
  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(covariant ModThumbnailImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageUrl != oldWidget.imageUrl) {
      // When the widget is reused for a different image, reload it.
      _loadImage();
    }
  }

  void _loadImage() {
    // Reset state for the new image
    _imageFile = null; 
    _isLoading = false;

    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) {
      // If there's no URL, don't do anything. The build method will show a placeholder.
      if(mounted) setState(() {});
      return;
    }
    
    // First, try to get the image synchronously from the in-memory cache.
    final cachedFile = widget.thumbnailService.getFromMemoryCache(widget.imageUrl!);
    if (cachedFile != null) {
      // If it exists, use it immediately.
      _imageFile = cachedFile;
      if (mounted) setState(() {});
    } else {
      // If not in memory, load it asynchronously from disk/network.
      _loadThumbnailAsync();
    }
  }

  Future<void> _loadThumbnailAsync() async {
    if (widget.imageUrl == null || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final file = await widget.thumbnailService.getThumbnail(widget.imageUrl!);

    if (mounted) {
      setState(() {
        _imageFile = file;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_imageFile != null) {
      // If we have the file, display it.
      return Image.file(
        _imageFile!,
        fit: BoxFit.cover,
        // Add a fade-in effect for a smoother appearance
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) {
            // If the image was already in memory (from Flutter's own image cache), show it instantly.
            return child;
          }
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: child,
          );
        },
      );
    }

    if (_isLoading) {
      // While loading from disk/network, show a progress indicator.
      return const Center(child: CircularProgressIndicator(strokeWidth: 2.0));
    }
    
    // Default placeholder if there's no image URL or if it failed to load.
    return const Icon(Icons.extension, size: 60, color: Colors.white38);
  }
  
}

class CropOverlayPainter extends CustomPainter {
  final Rect cropRect;

  CropOverlayPainter({required this.cropRect});

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = Colors.black.withOpacity(0.6);
    final cropPaint = Paint()..color = Colors.transparent;
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Dibuja el fondo sombreado
    final backgroundPath = Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      Path()..addRect(cropRect),
    );
    canvas.drawPath(backgroundPath, backgroundPaint);

    // Dibuja un borde blanco alrededor del área de recorte para que sea más visible
    canvas.drawRect(cropRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
