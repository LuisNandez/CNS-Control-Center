// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures, no_leading_underscores_for_local_identifiers, constant_pattern_never_matches_value_type, unreachable_switch_default, non_constant_identifier_names, use_build_context_synchronously, deprecated_member_use, prefer_interpolation_to_compose_strings, control_flow_in_finally

import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:window_manager/window_manager.dart';
import 'settings_page.dart';
import 'thumbnail_service.dart';
import 'notification_service.dart';
import 'mod_classifier_service.dart';
import 'dart:async';
import 'patcher_service.dart';
import 'package:hugeicons/hugeicons.dart';

import 'models/mod_info.dart';
import 'config/app_prefs.dart';
import 'models/app_enums.dart';
import 'utils/version_utils.dart';
import 'services/nexus_api_service.dart';
import 'services/file_manager_service.dart';
import 'services/game_locator_service.dart';
import 'ui/widgets/mod_grid_card.dart';
import 'ui/widgets/mod_list_tile.dart';
import 'ui/widgets/mod_details_panel.dart';
import 'utils/text_utils.dart';
import 'ui/dialogs/edit_dialogs.dart';
import 'ui/widgets/installation_panel.dart';
import 'services/core_installer_service.dart';
import 'models/installation_models.dart';
import 'services/archive_service.dart';
import 'services/mod_manager_service.dart';
import 'services/update_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = NexusHttpOverrides();

  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(680, 700),
    size: Size(1100, 700),
    center: true,
    title: 'SB Control Center',
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
    _ModInstallerAppState? state = context
        .findAncestorStateOfType<_ModInstallerAppState>();
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
      title: 'SB Control Center',
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

class _ModInstallerHomePageState extends State<ModInstallerHomePage> {
  final List<PreparedMod> _preparedMods = [];
  PreparedUE4SS? _preparedUE4SS;
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
  String? _genericModsPath;
  String? _moviesPath;
  String? _moviesBackupPath;
  String? _logicModsPath;
  String? _ue4ssModsPath;

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

  bool _isInstalling = false;
  double _installationProgress = 0.0;
  String _installationStatus = '';
  Set<String> _logicModIds = {};

  ModFilter _currentFilter = ModFilter.all;
  ModTypeFilter _currentModTypeFilter = ModTypeFilter.all;
  ModSort _currentSort = ModSort.date;
  ModListViewMode _viewMode = ModListViewMode.grid;
  bool _showModTypeTags = true;

  bool _isUe4ssInstalled = false;
  bool _isCnsCoreInstalled = false;

  bool _developerModeEnabled = false;
  int _versionTapCount = 0;
  Timer? _hoverTimer;
  OverlayEntry? _previewOverlay;
  Offset _cursorPosition = Offset.zero;

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
    _hoverTimer?.cancel();
    _previewOverlay?.remove();
    try {
      if (_tempExtractionDir != null && _tempExtractionDir!.existsSync()) {
        _tempExtractionDir!.deleteSync(recursive: true);
      }
    } catch (e) {
      print('Could not clean up temporary directory on exit: $e');
    }
    super.dispose();
  }

  bool _isUpdatingMetadata = false;
  double _metadataUpdateProgress = 0.0;
  String _metadataUpdateStatus = '';

  Future<void> _initialize() async {
    await _getAppVersion();
    await _thumbnailService.initialize();
    await _cleanUpOrphanedTempDirs();
    await _loadModDatabase();
    await _loadLogicModIds();
    await _find7zipPath();
    await _loadApiKey();
    await _loadSkippedVersions();
    await _loadPrefs();
    await _findGamePath();

    if (_finalModsPath != null) {
      await _checkCoreInstallations();
      await _migrateModFolders();
      await _runMetadataUpdateIfNeeded();
      await _loadAllMods();
      await _readCNSData();
    }
  }

  /*// Escribe los scripts empaquetados en el disco al iniciar la app.
  Future<void> _deployScriptAssets() async {
  final l10n = AppLocalizations.of(context)!;
  try {
    // 1. Obtener el directorio de la aplicación
    String appPath = Platform.resolvedExecutable;
    String appDir = p.dirname(appPath);

    // 2. Definir el nombre y la ruta final del script
    const String scriptFileName = 'StellarBlade_Chunk_Id_exe.py';
    final File targetFile = File(p.join(appDir, scriptFileName));

    // 3. Cargar el contenido del asset
    final String scriptContent =
        await rootBundle.loadString('assets/scripts/conflict_patcher.py');

    // 4. Escribir el archivo en el disco
    // Esto sobrescribirá el archivo si ya existe,
    // asegurando que la app siempre tenga la versión más reciente del script.
    await targetFile.writeAsString(scriptContent);

    print("Script de Patcher de Conflictos desplegado en: ${targetFile.path}");
  } catch (e) {
    print("Falló al desplegar el script de assets: $e");
    if (mounted) {
      NotificationService.instance.show(
        context: context,
        type: NotificationType.error,
        title: "Error de inicialización",
        description: "No se pudo crear el script del patcher: $e",
      );
    }
  }
  }*/

  Future<void> _checkCoreInstallations() async {
    if (_gameRootPath == null) return;
    final l10n = AppLocalizations.of(context)!;

    final win64Dir = Directory(
      p.join(_gameRootPath!, 'SB', 'Binaries', 'Win64'),
    );
    final metadataDir = Directory(p.join(win64Dir.path, '_manager_metadata'));

    final ue4ssManifest = File(p.join(metadataDir.path, 'ue4ss_manifest.json'));
    final cnsManifest = File(p.join(metadataDir.path, 'cns_manifest.json'));

 
    if (!await ue4ssManifest.exists()) {
      final ue4ssTriggerDir = Directory(
        p.join(win64Dir.path, 'ue4ss', 'Mods', 'ConsoleCommandsMod'),
      );
      if (await ue4ssTriggerDir.exists()) {
        print("Adopting existing UE4SS installation...");
        if (!await metadataDir.exists())
          await metadataDir.create(recursive: true);
        await ue4ssManifest.writeAsString(CoreInstallerService.defaultUe4ssManifestContent);
        if (mounted) {
          NotificationService.instance.show(
            context: context,
            type: NotificationType.info,
            title: l10n.ue4ssInstallationDetected,
          );
        }
      }
    }

    if (!await cnsManifest.exists()) {
      final cnsTriggerDir = Directory(
        p.join(win64Dir.path, 'ue4ss', 'Mods', 'DekCNS'),
      );
      if (await cnsTriggerDir.exists()) {
        print("Adopting existing CNS installation...");
        if (!await metadataDir.exists())
          await metadataDir.create(recursive: true);
        await cnsManifest.writeAsString(CoreInstallerService.defaultCnsManifestContent);
        if (mounted) {
          NotificationService.instance.show(
            context: context,
            type: NotificationType.info,
            title: l10n.cnsInstallationDetected,
          );
        }
      }
    }
    setState(() {
      _isUe4ssInstalled = ue4ssManifest.existsSync();
      _isCnsCoreInstalled = cnsManifest.existsSync();
    });
  }

  Future<void> _showInstallationPanel({List<File>? initialFiles}) async {
    if (_preparedMods.isNotEmpty) {
      _clearSelection();
    }

    final l10n = AppLocalizations.of(context)!;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF2a2a2a),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      enableDrag: false,
      builder: (context) {
        var hasProcessedInitialFiles = false;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setPanelState) {
            if (initialFiles != null && !hasProcessedInitialFiles) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                final bool didInstall = await _processArchives(
                  initialFiles,
                  panelStateSetter: setPanelState,
                );
                if (didInstall && mounted) {
                  Navigator.pop(context);
                }
              });
              hasProcessedInitialFiles = true;
            }
            return WillPopScope(
              onWillPop: () async {
                if (_isExtracting || _isLoading || _isInstalling) {
                  return false;
                }

                if (_preparedMods.isNotEmpty) {
                  await _cancelAndCleanInstallation();
                  setState(() {
                    _statusMessage = AppLocalizations.of(context)!.statusSelectionCancelled;
                    _statusColor = Colors.white;
                  });
                }
                return true;
              },
              child: InstallationPanelContent(
                l10n: l10n,
                isDragging: _isDragging,
                isExtracting: _isExtracting,
                isInstalling: _isInstalling,
                isLoading: _isLoading,
                extractionProgress: _extractionProgress,
                extractionStatus: _extractionStatus,
                installationProgress: _installationProgress,
                installationStatus: _installationStatus,
                statusMessage: _statusMessage,
                statusColor: _statusColor,
                hasPreparedMods: _preparedMods.isNotEmpty,
                modsToInstallPreviewMap: _modsToInstallPreviewMap,
                onFilesDropped: (files) async {
                  final bool didInstall = await _processArchives(
                    files,
                    panelStateSetter: setPanelState,
                  );
                  if (didInstall && mounted) {
                    Navigator.pop(context);
                  } else {
                    setPanelState(() {});
                  }
                },
                onDragUpdate: (isDragging) => setPanelState(() => _isDragging = isDragging),
                onPickArchive: () async {
                  final bool didInstall = await _pickArchive(
                    panelStateSetter: setPanelState,
                  );
                  if (didInstall && mounted) {
                    Navigator.pop(context);
                  } else {
                    setPanelState(() {});
                  }
                },
                onInstallMod: () async {
                  await _installMod(panelStateSetter: setPanelState);
                  if (mounted) Navigator.pop(context);
                },
                onCancelSelection: () => _clearSelection(panelStateSetter: setPanelState),
              ),
            );
          },
        );
      },
    );
    await _loadAllMods();
  }

  Future<void> _cancelAndCleanInstallation() async {
    _preparedMods.clear();
    _modsToInstallPreviewMap.clear();
    try {
      if (_tempExtractionDir != null && await _tempExtractionDir!.exists()) {
        await _tempExtractionDir!.delete(recursive: true);
        _tempExtractionDir = null;
        print('Temporary extraction directory cleaned up successfully.');
      }
    } catch (e) {
      print('Failed to clean up temp directory during cancellation: $e');
    }
  }

  Future<bool> _uninstallCoreComponent({required bool isUe4ss}) async {
    final l10n = AppLocalizations.of(context)!;
    final componentName = isUe4ss ? "UE4SS" : "CNS";

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
      return false;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: Text(l10n.dialogTitleUninstall(componentName)),
        content: Text(l10n.dialogContentUninstall(componentName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.dialogActionCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: Text(l10n.dialogActionUninstall),
          ),
        ],
      ),
    );

    if (confirm != true) return false;

    setState(() {
      _isLoading = true;
      _statusMessage = l10n.statusUninstalling(componentName);
    });

    try {
      if (_gameRootPath == null) throw Exception("Game path not found.");

      if (_gameRootPath == null) throw Exception("Game path not found.");

      // Llama al nuevo servicio para hacer el trabajo sucio
      await CoreInstallerService.uninstallCoreComponent(
        isUe4ss: isUe4ss,
        gameRootPath: _gameRootPath!,
      );

      NotificationService.instance.show(
        context: context,
        type: NotificationType.success,
        title: l10n.snackBarUninstalled(componentName),
      );

      return true;
    } catch (e) {
      NotificationService.instance.show(
        context: context,
        type: NotificationType.error,
        title: l10n.errorUninstalling(componentName),
        description: e.toString(),
      );
      return false;
    } finally {
      await _checkCoreInstallations();
      await _readCNSData();
      setState(() {
        _isLoading = false;
        _statusMessage = "";
      });
    }
  }

  Future<void> _cleanUpOrphanedTempDirs() async {
    try {
      final tempDir = Directory.systemTemp;
      await for (final entity in tempDir.list()) {
        if (entity is Directory &&
            p.basename(entity.path).startsWith('mod_manager_')) {
          try {
            await entity.delete(recursive: true);
          } catch (e) {
            print('Could not delete orphan directory ${entity.path}: $e');
          }
        }
      }
    } catch (e) {
      print(
        'An error occurred during general cleanup of temporary folders: $e',
      );
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
                final String newFolderName = data['displayName'].replaceAll(
                  RegExp(r'[\\/:*?"<>|]'),
                  '-',
                );
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
      final backupDirPath = p.join(
        _gameRootPath!,
        'SB',
        'Content',
        '__MOD_BACKUPS__',
      );
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
              print(
                'Migration conflict: Destination folder "$newPath" already exists. Skipping rename for "$oldPath".',
              );
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

  Future<void> _loadLogicModIds() async {
    try {
      final String content = await rootBundle.loadString('logic_mod_ids.json');
      final List<dynamic> idList = json.decode(content);
      setState(() {
        _logicModIds = idList.cast<String>().toSet();
      });
      print(
        'Local logic mod ID database loaded successfully (${_logicModIds.length} IDs).',
      );
    } catch (e) {
      print('Could not find or read logic_mod_ids.json, skipping: $e');
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
        for (var e in skippedList) e.split(';')[0]: e.split(';')[1],
      };
    });
  }

  Future<void> _saveSkippedVersions() async {
    final prefs = await SharedPreferences.getInstance();
    final skippedList = _skippedVersions.entries
        .map((e) => '${e.key};${e.value}')
        .toList();
    await prefs.setStringList(AppPrefs.skippedVersions, skippedList);
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final filterIndex =
        prefs.getInt(AppPrefs.filterMode) ?? ModFilter.all.index;
    final modTypeFilterIndex =
        prefs.getInt(AppPrefs.modTypeFilterMode) ?? ModTypeFilter.all.index;
    final sortIndex = prefs.getInt(AppPrefs.sortMode) ?? ModSort.date.index;
    final viewModeIndex =
        prefs.getInt(AppPrefs.viewMode) ?? ModListViewMode.grid.index;
    final showTags = prefs.getBool(AppPrefs.showModTypeTags) ?? true;

    setState(() {
      _currentFilter = ModFilter.values[filterIndex];
      _currentModTypeFilter = ModTypeFilter.values[modTypeFilterIndex];
      _currentSort = ModSort.values[sortIndex];
      _viewMode = ModListViewMode.values[viewModeIndex];
      _showModTypeTags = showTags;
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

      gamePath ??= await GameLocatorService.findSteamInstallation();

      if (gamePath != null && await Directory(gamePath).exists()) {
        final cnsModPath = p.join(
          gamePath,
          'SB',
          'Content',
          'Paks',
          '~mods',
          'CustomNanosuitSystem',
        );
        final genericModPath = p.join(
          gamePath,
          'SB',
          'Content',
          'Paks',
          '~mods',
        );
        final moviesPath = p.join(gamePath, 'SB', 'Content', 'Movies');
        final moviesBackupPath = p.join(
          gamePath,
          'SB',
          'Content',
          '__MOVIES_ORIGINALS__',
        );
        final logicModsPath = p.join(
          gamePath,
          'SB',
          'Content',
          'Paks',
          'LogicMods',
        );
        final ue4ssModsPath = p.join(
          gamePath,
          'SB',
          'Binaries',
          'Win64',
          'ue4ss',
          'Mods',
        );
        final cnsDir = Directory(cnsModPath);
        final genericDir = Directory(genericModPath);
        final moviesBackupDir = Directory(moviesBackupPath);
        final logicModsDir = Directory(logicModsPath);
        final ue4ssModsDir = Directory(ue4ssModsPath);

        if (!await cnsDir.exists()) {
          await cnsDir.create(recursive: true);
        }
        if (!await genericDir.exists()) {
          await genericDir.create(recursive: true);
        }
        if (!await moviesBackupDir.exists()) {
          await moviesBackupDir.create(recursive: true);
        }
        if (!await logicModsDir.exists()) {
          await logicModsDir.create(recursive: true);
        }
        if (!await ue4ssModsDir.exists()) {
          await ue4ssModsDir.create(recursive: true);
        }

        setState(() {
          _gameRootPath = gamePath;
          _finalModsPath = cnsModPath;
          _genericModsPath = genericModPath;
          _moviesPath = moviesPath;
          _moviesBackupPath = moviesBackupPath;
          _logicModsPath = logicModsPath;
          _ue4ssModsPath = ue4ssModsPath;
          if (mounted) {
            _statusMessage = AppLocalizations.of(context)!.statusGamePathFound;
          }
        });
      } else {
        setState(() {
          _finalModsPath = null;
          _genericModsPath = null;
          _moviesPath = null;
          _moviesBackupPath = null;
          _logicModsPath = null;
          _ue4ssModsPath = null;
          if (mounted) {
            _statusMessage = AppLocalizations.of(
              context,
            )!.statusGamePathNotFound;
          }
          _statusColor = Colors.orangeAccent;
        });
      }
    } catch (e) {
      setState(() {
        _finalModsPath = null;
        _genericModsPath = null;
        _moviesPath = null;
        _moviesBackupPath = null;
        _logicModsPath = null;
        _ue4ssModsPath = null;
        if (mounted) {
          _statusMessage = AppLocalizations.of(
            context,
          )!.statusErrorFindingGame(e.toString());
        }
        _statusColor = Colors.redAccent;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<String?> _readCNSData() async {
    if (_gameRootPath == null) {
      setState(() {
        _cnsVersion = null;
        _cnsNexusId = null;
      });
      return null;
    }

    setState(() {
      _cnsVersion = null;
      _cnsNexusId = null;
    });

    String? newVersion;

    try {
      final infoFile = File(
        p.join(
          _gameRootPath!,
          'SB',
          'Binaries',
          'Win64',
          'ue4ss',
          'nexus_info.json',
        ),
      );
      if (await infoFile.exists()) {
        final content = await infoFile.readAsString();
        final data = json.decode(content);
        setState(() {
          _cnsNexusId = data['nexusId'];
          _cnsVersion = data['installedVersion'];
        });
        newVersion = data['installedVersion'];
        return newVersion;
      }
    } catch (e) {
      print('Error reading CNS nexus_info.json: $e');
    }

    try {
      final luaFile = File(
        p.join(
          _gameRootPath!,
          'SB',
          'Binaries',
          'Win64',
          'ue4ss',
          'Mods',
          'DekCNS',
          'Scripts',
          'main.lua',
        ),
      );
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
            result,
            'SB',
            'Content',
            'Paks',
            '~mods',
            'CustomNanosuitSystem',
          );
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
          if (mounted) {
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

  Future<void> _runMetadataUpdateIfNeeded() async {
    if (_finalModsPath == null) return;
    final l10n = AppLocalizations.of(context)!;

    final List<Map<String, dynamic>> modsToUpdate = [];
    final List<String> modPaths = [];

    final enabledDir = Directory(_finalModsPath!);
    if (await enabledDir.exists()) {
      await for (var entity in enabledDir.list()) {
        if (entity is Directory) modPaths.add(entity.path);
      }
    }

    if (_gameRootPath != null) {
      final backupDirPath = p.join(
        _gameRootPath!,
        'SB',
        'Content',
        '__MOD_BACKUPS__',
      );
      final disabledDir = Directory(backupDirPath);
      if (await disabledDir.exists()) {
        await for (var entity in disabledDir.list()) {
          if (entity is Directory) modPaths.add(entity.path);
        }
      }
    }

    for (final modPath in modPaths) {
      if (p.basename(modPath) == '__MOD_BACKUPS__') continue;
      final infoFile = File(p.join(modPath, 'nexus_info.json'));
      if (await infoFile.exists()) {
        try {
          final content = await infoFile.readAsString();
          Map<String, dynamic> data = json.decode(content);
          final String? modManagerVersion = data['managerVersion'];
          final String? nexusIdForCheck = data['nexusId'];

          bool needsUpdate =
              modManagerVersion == null ||
              (VersionUtils.compareVersions(_appVersion, modManagerVersion) > 0);

          if (needsUpdate &&
              nexusIdForCheck != null &&
              nexusIdForCheck.isNotEmpty) {
            modsToUpdate.add({
              'path': modPath,
              'nexusId': nexusIdForCheck,
              'displayName': data['displayName'] ?? p.basename(modPath),
            });
          }
        } catch (e) {
          print(
            'No se pudo analizar nexus_info.json para la comprobación de actualización de metadatos en $modPath: $e',
          );
        }
      }
    }

    if (modsToUpdate.isNotEmpty) {
      setState(() {
        _isLoading = false;
        _isUpdatingMetadata = true;
        _metadataUpdateProgress = 0.0;
      });

      for (int i = 0; i < modsToUpdate.length; i++) {
        final modData = modsToUpdate[i];
        final modDirectory = Directory(modData['path']);
        final nexusId = modData['nexusId'];
        final displayName = modData['displayName'];
        final infoFile = File(p.join(modDirectory.path, 'nexus_info.json'));

        setState(() {
          _metadataUpdateProgress = (i + 1) / modsToUpdate.length;
          _metadataUpdateStatus = l10n.statusUpdatingMetadata(
            displayName,
            i + 1,
            modsToUpdate.length,
          );
        });

        try {
          final nexusData = await NexusApiService.fetchNexusModData(nexusId, _apiKey);
          Map<String, dynamic> data = {};
          if (await infoFile.exists()) {
            try {
              final content = await infoFile.readAsString();
              data = json.decode(content);
            } catch (e) {
              print("Corrigiendo nexus_info.json corrupto para $displayName.");
            }
          }

          if (nexusData != null) {
            data['summary'] ??= nexusData['summary'];
            data['author'] ??= nexusData['author'];
            data['gallery'] ??= nexusData['gallery'];
            data['description'] ??= nexusData['description'];
            data['sourceUrl'] ??=
                'https://www.nexusmods.com/stellarblade/mods/$nexusId';
            data['managerVersion'] = _appVersion;

            final encoder = JsonEncoder.withIndent('  ');
            await infoFile.writeAsString(encoder.convert(data));
            
            await ModManagerService.cacheNexusThumbnail(apiKey: _apiKey,
              modDirectory: modDirectory,
              nexusId: nexusId,
            );

            if (await infoFile.exists()) {
              data = json.decode(await infoFile.readAsString());
            }
          }

          final String? customCoverPath = data['customCoverPath'];
          if (customCoverPath != null && customCoverPath.isNotEmpty) {
            
            setState(() {
              _metadataUpdateStatus = l10n.statusUpdatingMetadata(
                displayName,
                i + 1,
                modsToUpdate.length,
              ) + " (${l10n.processingCover})";
            });

            final String sourcePath = p.join(modDirectory.path, customCoverPath);
            final String cacheKey = p.basename(modDirectory.path) + customCoverPath;

            await _thumbnailService.getThumbnail(
              cacheKey,
              sourcePath,
              isLocalFile: true,
            );
          }
        } catch (e) {
          print('Fallo al actualizar los metadatos para $displayName: $e');
        }
      }

      setState(() {
        _isUpdatingMetadata = false;
        _metadataUpdateStatus = '';
      });
    }
  }

  Future<void> _loadAllMods({bool clearHighlight = true}) async {
    if (_finalModsPath == null) return;
    setState(() {
      _isLoading = true;
      if (clearHighlight) {
        _lastInstalledModNames.clear();
      }
    });

    try {
      final mods = await ModManagerService.loadMods(
        gameRootPath: _gameRootPath,
        finalModsPath: _finalModsPath!,
        genericModsPath: _genericModsPath!,
        logicModsPath: _logicModsPath!,
        appVersion: _appVersion,
        apiKey: _apiKey,
      );

      setState(() {
        _allMods = mods;
        if (clearHighlight && mounted) {
          final totalEnabled = _allMods.where((m) => m.isEnabled).length;
          final totalDisabled = _allMods.length - totalEnabled;
          _statusMessage = AppLocalizations.of(context)!.statusModsFound(totalDisabled, totalEnabled);
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.snackBarRepairStarted),
        backgroundColor: Colors.blueGrey,
      ),
    );

    setState(() => _isLoading = true);

    int repairedCount = await ModManagerService.runSelfHealing(
      allMods: _allMods,
      modDatabase: _modDatabase,
      apiKey: _apiKey,
    );

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

  /// Ejecuta el Patcher de Conflictos nativo de Dart.
  Future<void> _runConflictPatcher() async {
    final l10n = AppLocalizations.of(context)!;

    if (_genericModsPath == null ||
        !await Directory(_genericModsPath!).exists()) {
      NotificationService.instance.show(
        context: context,
        type: NotificationType.error,
        title: l10n.errorDialogTitle,
        description: l10n.statusGamePathNotFound,
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = l10n.statusRunningPatcher;
    });

    List<LogEntry> fullLog = []; // Para el botón "Mostrar Log Completo"

    try {
      // 1. Crear una instancia del servicio y ejecutar el parcheo
      final PatcherService patcher = PatcherService(l10n);
      final PatcherResult result = await patcher.patchConflictsInDirectory(
        _genericModsPath!,
      );

      fullLog = result.logEntries; // Guardamos el log completo

      // 2. Procesar los resultados para crear un resumen simple
      final StringBuffer summary = StringBuffer();

      // --- Resumen de Container ID (Correcciones de Crashes) ---
      if (result.containerIdsFixed > 0) {
        summary.writeln(
          l10n.summarySuccessContainerIds(result.containerIdsFixed),
        );
      } else {
        summary.writeln(
          l10n.summaryNoContainerIdConflicts,
        );
      }
      summary.writeln("---");

      // --- INICIO DE LA NUEVA LÓGICA DE AGRUPACIÓN ---

      // Un mapa para agrupar los conflictos.
      // La clave (String) será la lista de mods en conflicto (ej: "Mod A, Mod B")
      // El valor (int) será cuántos archivos comparten.
      final Map<String, int> conflictGroups = {};
      const int commonConflictThreshold = 10;

      result.packageIdConflicts.forEach((id, mods) {
        // 1. Filtramos los "auto-conflictos" (mods.length < 2)
        //    y los conflictos "comunes" (demasiados mods).
        if (mods.length > 1 && mods.length < commonConflictThreshold) {
          // 2. Ordenamos la lista de mods para que "A, B" sea igual que "B, A"
          mods.sort();

          // 3. Creamos una clave única para este grupo de mods
          final String groupKey = mods.join(
            '\n    ',
          ); // Usamos \n para formatear

          // 4. Contamos cuántos archivos comparte este grupo
          conflictGroups[groupKey] = (conflictGroups[groupKey] ?? 0) + 1;
        }
      });
      // --- FIN DE LA NUEVA LÓGICA DE AGRUPACIÓN ---

      // --- Resumen de Package ID (Conflictos de Sobrescritura) ---
      if (conflictGroups.isEmpty) {
        summary.writeln(
          l10n.summaryNoPackageIdConflicts,
        );
      } else {
        summary.writeln(
          l10n.summaryFoundPackageIdConflicts(conflictGroups.length),
        );
        summary.writeln("---");

        // Ahora iteramos sobre los grupos únicos
        conflictGroups.forEach((modGroup, fileCount) {
          summary.writeln(
            l10n.summaryConflictGroupDetails(fileCount),
          );
          summary.writeln(
            "    $modGroup\n",
          ); // El modGroup ya tiene el formato con \n
        });
      }

      // 3. Mostrar el nuevo diálogo de resumen
      await showDialog(
        context: context,
        builder: (summaryContext) => AlertDialog(
          backgroundColor: const Color(0xFF2a2a2a),
          title: Text(l10n.patcherSummaryDialogTitle),
          content: SingleChildScrollView(
            child: SelectableText(summary.toString()),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(summaryContext).pop(),
              child: Text(l10n.dialogActionClose),
            ),
            // El botón "MOSTRAR LOG COMPLETO"
            ElevatedButton(
              child: Text(l10n.dialogActionShowFullLog),
              onPressed: () {
                Navigator.of(
                  summaryContext,
                ).pop(); // Cierra el diálogo de resumen
                _showFullPatcherLog(fullLog); // Abre el diálogo de log completo
              },
            ),
          ],
        ),
      );
    } catch (e) {
      NotificationService.instance.show(
        context: context,
        type: NotificationType.error,
        title: l10n.errorDialogTitle,
        description: e.toString(),
      );
      // Si falla, muestra el log que se haya acumulado
      if (fullLog.isEmpty) {
        // Si el log está vacío pero hubo un error, crea una entrada de error
        _showFullPatcherLog([LogEntry(e.toString(), LogEntryType.error)]);
      } else {
        // Si ya había log, muéstralo
        _showFullPatcherLog(fullLog);
      }
    } finally {
      setState(() {
        _isLoading = false;
        _statusMessage = '';
      });
    }
  }

  // ++ AÑADE ESTA NUEVA FUNCIÓN DE AYUDA (para no repetir código) ++
  void _showFullPatcherLog(List<LogEntry> logEntries) {
    final l10n = AppLocalizations.of(context)!;

    // Función de ayuda para mapear el tipo a un color
    Color _getLogColor(LogEntryType type) {
      switch (type) {
        case LogEntryType.success:
          return Colors.greenAccent; // VERDE
        case LogEntryType.error:
          return Colors.redAccent; // ROJO
        case LogEntryType.info:
          return Colors.lightBlueAccent; // AZUL
        case LogEntryType.normal:
        default:
          return Colors.white; // BLANCO
      }
    }

    showDialog(
      context: context,
      builder: (logContext) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: Text(l10n.fullLogDialogTitle),
        // Hacemos el diálogo más grande para el log
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.7,
          child: SingleChildScrollView(
            // Usamos SelectableText.rich para los TextSpans
            child: SelectableText.rich(
              TextSpan(
                // Estilo por defecto
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily:
                      'Consolas', // Una fuente monoespaciada es mejor para logs
                  fontSize: 12,
                  height: 1.4,
                ),
                children: logEntries.map((entry) {
                  // Mapea cada LogEntry a un TextSpan con su color
                  return TextSpan(
                    text: "${entry.text}\n", // Añade el salto de línea
                    style: TextStyle(color: _getLogColor(entry.type)),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(logContext).pop(),
            child: Text(l10n.dialogActionClose),
          ),
        ],
      ),
    );
  }

  Future<bool> _pickArchive({StateSetter? panelStateSetter}) async {
    // <-- AÑADE EL PARÁMETRO AQUÍ
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip', 'rar', '7z'],
        allowMultiple: true,
      );
      if (result != null && result.files.isNotEmpty) {
        final files = result.paths.map((path) => File(path!)).toList();
        // ++ PASA EL PARÁMETRO A LA SIGUIENTE FUNCIÓN ++
        return await _processArchives(
          files,
          panelStateSetter: panelStateSetter,
        );
      }
    } catch (e) {
      // Usa el setter si está disponible, si no, usa setState
      final updateState = panelStateSetter ?? setState;
      updateState(
        () => _statusMessage = AppLocalizations.of(
          context,
        )!.statusError(e.toString()),
      );
    }
    return false;
  }
  
  Future<bool> _show7zipRequiredDialog() async {
    bool isInstalled = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            String dialogMessage = AppLocalizations.of(
              context,
            )!.dialogContent7zip;
            Color messageColor = Colors.white;

            return AlertDialog(
              backgroundColor: const Color(0xFF2a2a2a),
              title: Text(AppLocalizations.of(context)!.dialogTitle7zip),
              content: Text(
                dialogMessage,
                style: TextStyle(color: messageColor),
              ),
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
                    AppLocalizations.of(context)!.dialogActionGoToDownload,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _find7zipPath();
                    if (_7zipPath != null) {
                      isInstalled = true;
                      Navigator.of(context).pop();
                    } else {
                      setDialogState(() {
                        dialogMessage = AppLocalizations.of(
                          context,
                        )!.dialogContent7zipNotFound;
                        messageColor = Colors.redAccent;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                    foregroundColor: Colors.black,
                  ),
                  child: Text(
                    AppLocalizations.of(
                      context,
                    )!.dialogActionConfirmInstallation,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
    return isInstalled;
  }

  Future<bool> _promptAndInstallUE4SS(Directory sourceDir) async {
    final l10n = AppLocalizations.of(context)!;

    if (_isUe4ssInstalled) {
      final reinstall = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF2a2a2a),
          title: Text(l10n.dialogTitleUE4SSReinstall),
          content: Text(l10n.dialogContentUE4SSReinstall),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.dialogActionCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.orangeAccent),
              child: Text(l10n.dialogActionReinstall),
            ),
          ],
        ),
      );
      if (reinstall != true) return false;
    } else {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF2a2a2a),
          title: Text(l10n.dialogTitleUE4SS),
          content: Text(l10n.dialogContentUE4SS),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.dialogActionCancel),
            ),
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
        return false;
      }
    }

    setState(() {
      _isLoading = true;
      _statusMessage = l10n.statusInstallingUE4SS;
    });

    try {
      if (_gameRootPath == null) throw Exception(l10n.errorGamePathUndefined);

      if (_gameRootPath == null) throw Exception(l10n.errorGamePathUndefined);

   // Llama al nuevo servicio
   await CoreInstallerService.installUE4SS(
     sourceDir: sourceDir,
     gameRootPath: _gameRootPath!,
   );

      NotificationService.instance.show(
        context: context,
        type: NotificationType.success,
        title: l10n.snackBarUE4SSInstalled,
      );

      setState(() {
        _statusMessage = l10n.statusUE4SSInstallComplete;
        _isUe4ssInstalled = true;
        _clearSelection();
      });
      return true;
    } catch (e) {
      setState(() {
        _statusMessage = l10n.statusError(e.toString());
        _statusColor = Colors.redAccent;
      });
      return false;
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<bool> _processArchives(
  List<File> archives, {
  StateSetter? panelStateSetter,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final updateState = panelStateSetter ?? setState;
  updateState(() {
    _isExtracting = true;
    _extractionProgress = 0.0;
    _extractionStatus = '';
  });

  try {
    if (_tempExtractionDir != null && await _tempExtractionDir!.exists()) {
      await _tempExtractionDir!.delete(recursive: true);
    }
    _tempExtractionDir = Directory.systemTemp.createTempSync('mod_manager_');

    final result = await ArchiveService.processArchives(
      archives: archives,
      tempExtractionDir: _tempExtractionDir!,
      sevenZipPath: _7zipPath,
      apiKey: _apiKey,
      logicModIds: _logicModIds,
      l10n: l10n,
      onProgress: (progress, status) {
        updateState(() {
          _extractionProgress = progress;
          _extractionStatus = status;
        });
      }
    );

    _preparedMods.clear();
    _preparedMods.addAll(result.preparedMods);
    _preparedUE4SS = result.preparedUE4SS;

    if (result.cnsUpdateDir != null) {
      return await _promptAndUpdateCNS(result.cnsUpdateDir!);
    } else if (_preparedUE4SS != null) {
      _preparedMods.clear();
      return await _promptAndInstallUE4SS(_preparedUE4SS!.sourceDir);
    } else {
      await _prepareInstallationPreview(panelStateSetter: panelStateSetter);
    }
    return false;
  } catch (e) {
    if (e.toString().contains('7ZIP_MISSING')) {
      final installed = await _show7zipRequiredDialog();
      if (!installed) {
        updateState(() {
          _statusMessage = l10n.statusError(l10n.error7zipRequired);
          _statusColor = Colors.redAccent;
        });
      }
      return false;
    }

    updateState(() {
      _statusMessage = l10n.statusError(e.toString());
      _statusColor = Colors.redAccent;
    });
    return false;
  } finally {
    updateState(() {
      _isExtracting = false;
    });
  }
}

  Future<void> _prepareInstallationPreview({
    StateSetter? panelStateSetter,
  }) async {
    // ++ INICIO DE LA MODIFICACIÓN ++
    AppLocalizations? l10n;
    if (mounted) {
      l10n = AppLocalizations.of(context);
    }

    if (_preparedMods.isEmpty) {
      final errorMessage =
          l10n?.errorNoCompatibleFilesInArchive ??
          'No compatible files found in archive.';
      _clearSelection(
        message: errorMessage,
        panelStateSetter: panelStateSetter,
      );
      return;
    }
    // ++ FIN DE LA MODIFICACIÓN ++

    final Map<String, List<String>> previewMap = {};

    for (final preparedMod in _preparedMods) {
      // 1. Intenta obtener el nombre del .json (para mods CNS)
      String? displayName = await ModManagerService.getDisplayNameForMod(preparedMod.sourceDir);

      // 2. Si falla (es null), usa el nombre del zip (para mods Genéricos)
      displayName ??= preparedMod.archiveName;

      // 3. Ahora displayName no debería ser nulo
      if (displayName.isNotEmpty) {
        String finalFolderName = displayName;
        if (preparedMod.nexusVersion != null) {
          finalFolderName = '$finalFolderName v${preparedMod.nexusVersion}';
        }

        // 4. CORRECCIÓN: Usamos la misma función que el instalador
        final List<String> allFileDisplayPaths = [];

        // 4a. Archivos del sourceDir (LogicMods, CNS, Genérico, etc.)
        // Estos solo mostrarán el nombre del archivo, ya que van a la carpeta principal del mod.
        if (await preparedMod.sourceDir.exists()) {
          final sourceFiles = await FileManagerService.findAllModFilesRecursive(
            preparedMod.sourceDir,
          );
          allFileDisplayPaths.addAll(
            sourceFiles.map((f) => p.basename(f.path)),
          );
        }

        // 4b. Archivos del ue4ssDir (si existen)
        if (preparedMod.ue4ssDir != null &&
            await preparedMod.ue4ssDir!.exists()) {
          final ue4ssFiles = await FileManagerService.findAllModFilesRecursive(
            preparedMod.ue4ssDir!,
          );
          for (final file in ue4ssFiles) {
            // Obtenemos la ruta relativa para mostrar la estructura (ej: ModName/Scripts/main.lua)
            final relativePath = p.relative(
              file.path,
              from: preparedMod.ue4ssDir!.path,
            );
            // Añadimos un prefijo para que el usuario sepa dónde va
            allFileDisplayPaths.add(
              p.join("[UE4SS]", relativePath).replaceAll(r'\', '/'),
            );
          }
        }

        // 4c. Archivos del tildeModsDir (si existen)
        if (preparedMod.tildeModsDir != null &&
            await preparedMod.tildeModsDir!.exists()) {
          final tildeFiles = await FileManagerService.findAllModFilesRecursive(
            preparedMod.tildeModsDir!,
          );
          for (final file in tildeFiles) {
            final relativePath = p.relative(
              file.path,
              from: preparedMod.tildeModsDir!.path,
            );
            // Añadimos un prefijo para que el usuario sepa dónde va
            allFileDisplayPaths.add(
              p.join("[~MODS]", relativePath).replaceAll(r'\', '/'),
            );
          }
        }

        // 5. Asigna la lista COMPLETA al mapa
        previewMap[finalFolderName] = allFileDisplayPaths;
      }
    }

    // Usa el actualizador de estado del panel si se proporciona
    final updateState = panelStateSetter ?? setState;
    updateState(() {
      _modsToInstallPreviewMap = previewMap;
      _statusMessage = AppLocalizations.of(
        context,
      )!.statusFilesSelected(_modsToInstallPreviewMap.length);
      _statusColor = Colors.white;
    });
  }

  Future<bool> _promptAndUpdateCNS(Directory sourceSBDir) async {
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
                onTap: () => launchUrl(
                  Uri.parse("https://github.com/Chrisr0/RE-UE4SS/releases"),
                ),
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
      return false; // Detiene la instalación si UE4SS no está presente.
    }

    final newVersion = await CoreInstallerService.getVersionFromCnsPackage(sourceSBDir);

    if (_isCnsCoreInstalled) {
      // CASO: YA HAY UNA VERSIÓN INSTALADA (Actualizar, Reinstalar o Revertir)
      final oldVersion = _cnsVersion ?? "N/A";

      // Comparamos la nueva versión con la antigua.
      final comparison = (newVersion != null && _cnsVersion != null)
          ? VersionUtils.compareVersions(newVersion, _cnsVersion!)
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
        content = l10n.dialogContentCNSReinstallVersion(
          newVersion ?? oldVersion,
        );
        actionText = l10n.dialogActionReinstall;
      }

      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF2a2a2a),
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.dialogActionCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: actionColor),
              child: Text(actionText),
            ),
          ],
        ),
      );
      if (confirm != true) return false;
    } else {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF2a2a2a),
          title: Text(l10n.dialogTitleCNSInstall),
          content: Text(l10n.dialogContentCNSInstall),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.dialogActionCancel),
            ),
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
        return false;
      }
    }

    setState(() {
      _isLoading = true;
      _statusMessage = l10n.statusUpdatingCNS;
    });

    try {
      if (_gameRootPath == null) throw Exception(l10n.errorGamePathUndefined);

      if (_gameRootPath == null) throw Exception(l10n.errorGamePathUndefined);

      // Llama al nuevo servicio
      await CoreInstallerService.installCNS(
        sourceSBDir: sourceSBDir,
        gameRootPath: _gameRootPath!,
      );

      // ignore: unused_local_variable
      String? versionFromLua;
      try {
        final luaFile = File(
          p.join(
            _gameRootPath!,
            'SB',
            'Binaries',
            'Win64',
            'ue4ss',
            'Mods',
            'DekCNS',
            'Scripts',
            'main.lua',
          ),
        );
        if (await luaFile.exists()) {
          final content = await luaFile.readAsString();
          final regex = RegExp(r'local CNS_Version = "(.+)"');
          final match = regex.firstMatch(content);
          if (match != null && match.group(1) != null) {
            versionFromLua = match.group(1);
          }
        }
      } catch (e) {
        /* ... */
      }

      // ... (resto de la lógica para crear nexus_info.json sin cambios)

      NotificationService.instance.show(
        context: context,
        type: NotificationType.success,
        title: l10n.snackBarCNSUpdated,
      );
      setState(() {
        _statusMessage = l10n.statusUpdateComplete;
        _isCnsCoreInstalled = true;
        _clearSelection();
      });

      await _readCNSData();
      return true;
    } catch (e) {
      setState(() {
        _statusMessage = l10n.statusError(e.toString());
        _statusColor = Colors.redAccent;
      });
      return false;
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _installMod({StateSetter? panelStateSetter}) async {
    final l10n = AppLocalizations.of(context)!;
    final updateState = panelStateSetter ?? setState;
    if (_finalModsPath == null) {
      updateState(() {
        _statusMessage = l10n.errorGamePathUndefined;
        _statusColor = Colors.redAccent;
      });
      return;
    }
    if (_preparedMods.isEmpty) {
      updateState(() {
        _statusMessage = l10n.errorInstallNoSelection;
        _statusColor = Colors.redAccent;
      });
      return;
    }

    // Usa los nuevos estados de instalación en lugar de _isLoading
    updateState(() {
      _isInstalling = true;
      _installationProgress = 0.0;
      _installationStatus =
          l10n.statusInstalling; // Necesitarás esta traducción
      _lastInstalledModNames.clear();
    });

    List<String> installedNames = [];
    String? errorMessage;
    int successCount = 0;
    int failCount = 0;

    try {
      for (int i = 0; i < _preparedMods.length; i++) {
        final preparedMod =
            _preparedMods[i]; // <-- Obtenemos el objeto completo
        try {
          // Llamamos a nuestra nueva función de instalación unificada
          final modName = await _installSingleMod(preparedMod, l10n: l10n);

          if (modName != null) {
            installedNames.add(modName);
            successCount++;
            updateState(() {
              _installationProgress = (i + 1) / _preparedMods.length;
              _installationStatus = l10n.statusInstallingMod(
                i + 1,
                _preparedMods.length,
                modName,
              );
            });
          } else {
            failCount++;
          }
        } catch (e) {
          print('Failed to install mod from ${preparedMod.sourceDir.path}: $e');
          failCount++;
        }
      }

      if (mounted) {
        // This block now correctly handles showing the final summary.
        if (_preparedMods.length > 1) {
          NotificationService.instance.show(
            context: context,
            type: failCount > 0
                ? (successCount > 0
                      ? NotificationType.info
                      : NotificationType.error)
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
        _isInstalling = false;
      });
      //await _loadAllMods(clearHighlight: false);
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

  // ++ AÑADIR ESTA FUNCIÓN (COPIADA DE _ModDetailsPanelState) ++
  /// Genera la ruta del asset para la vista previa de un traje.
  String _generateOutfitImagePath(String outfitName) {
    // 1. Minúsculas
    String safeName = outfitName.toLowerCase();
    // 2. Quitar (NG+) y caracteres especiales
    safeName = safeName
        .replaceAll('(ng+)', 'ng_plus')
        .replaceAll(RegExp(r'[^\w\s-]'), '');
    // 3. Reemplazar espacios y guiones con guiones bajos
    safeName = safeName.replaceAll(RegExp(r'[\s-]+'), '_');

    // 4. Devolver la ruta completa del asset
    return 'assets/images/outfits/$safeName.webp'; // Asume .webp
  }

  Future<String> _getComparableNameForMod(ModInfo mod) async {
    return mod.displayName;
  }

  Future<AlternativeVersionAction?> _showSmartInstallDialog({
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
      final comparison = VersionUtils.compareVersions(
        newVersion,
        oldVersionMod.localVersion!,
      );

      if (comparison > 0) {
        title = l10n.dialogTitleUpdate;
        content = l10n.dialogContentUpdate(modName, oldVersion, newVersionStr);
        replaceActionText = l10n.dialogActionUpdate;
      } else if (comparison < 0) {
        title = l10n.dialogTitleDowngrade;
        content = l10n.dialogContentDowngrade(
          modName,
          oldVersion,
          newVersionStr,
        );
        replaceActionText = l10n.dialogActionDowngrade;
      } else {
        title = l10n.dialogTitleReinstall;
        content = l10n.dialogContentReinstall(modName, newVersionStr);
        replaceActionText = l10n.dialogActionReinstall;
      }
    } else {
      content = l10n.dialogContentAlternativeVersion(
        modName,
        baseDisplayName,
        baseDisplayName,
      );
    }

    return showDialog<AlternativeVersionAction>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(AlternativeVersionAction.cancel),
            child: Text(l10n.dialogActionCancel),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.of(context).pop(AlternativeVersionAction.replace),
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

  Future<String?> _installSingleMod(
  PreparedMod preparedMod, {
  required AppLocalizations l10n,
  }) async {
    final modDir = preparedMod.sourceDir;
    final nexusId = preparedMod.nexusId;
    final nexusVersion = preparedMod.nexusVersion;
    final modType = preparedMod.modType;
    final ue4ssDir = preparedMod.ue4ssDir;
    final tildeModsDir = preparedMod.tildeModsDir;

    String? preservedCustomName;
    String? selectedOutfit;

    // 1. CLASIFICAR EL MOD Y OBTENER SUS DATOS
    //final modType = await ModClassifierService.classifyModDirectory(modDir); // <-- ELIMINADO: Ya tenemos el tipo
    String? baseDisplayName;
    String? fitMeshType;
    String? installPath;
    List<String> replacedFiles = [];

    // Definir la ruta de backup general (para mods deshabilitados y movies)
    if (_gameRootPath == null) throw Exception("Game path not defined.");
    final backupDirPath = p.join(
      _gameRootPath!,
      'SB',
      'Content',
      '__MOD_BACKUPS__',
    );
    // Asegurarse de que exista
    final backupDir = Directory(backupDirPath);
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    String
    finalFolderName; // La movemos aquí para que sea accesible por LogicMod

    if (modType == ModDirectoryType.logicMod) {
      // Es un LogicMod: Lógica de instalación dividida
      baseDisplayName = preparedMod.archiveName;
      fitMeshType = "Logic"; // Etiqueta

      // --- 1. Definir rutas ---
      // Ruta de la carpeta "LogicMods" en el zip (la fuente es la raíz del zip)
      final logicSourceDir = modDir; // sourceDir *es* la carpeta LogicMods
      final ue4ssSourceDir = ue4ssDir; // ue4ssDir *es* la carpeta Mods
      final tildeModsSourceDir =
          tildeModsDir; // tildeModsDir *es* la carpeta Mods

      // Ruta de destino para los LogicMods (.../Paks/LogicMods)
      installPath = _logicModsPath;
      if (installPath == null)
        throw Exception("LogicMods path is not defined.");

      // Ruta de destino para los archivos UE4SS (.../ue4ss/Mods)
      final ue4ssDestPath = _ue4ssModsPath;
      if (ue4ssDestPath == null)
        throw Exception("UE4SS Mods path is not defined.");

      final tildeModsDestPath = _genericModsPath;
      if (tildeModsDestPath == null)
        throw Exception("Generic mods (~mods) path is not defined.");

      // Nombre de la carpeta del mod (para la parte Lógica)
      finalFolderName = baseDisplayName;
      if (nexusVersion != null) {
        finalFolderName = '$finalFolderName v$nexusVersion';
      }

      // Ruta final para la parte Lógica: .../Paks/LogicMods/<mod_name>
      final logicModDestPath = p.join(installPath, finalFolderName);

      // --- 2. Lógica de Reemplazo ---
      // La "carpeta del mod" que gestionamos (activar/desactivar) es la de LogicMods.
      // La parte de UE4SS se considera una dependencia permanente.

      ModInfo? oldVersionMod;
      // Buscamos un mod existente con el mismo nombre Y que sea 'logicMod'
      try {
        oldVersionMod = _allMods.firstWhere(
          (mod) =>
              mod.displayName == baseDisplayName && mod.modType == 'logicMod',
        );
      } catch (e) {
        oldVersionMod = null; // No se encontró
      }

      AlternativeVersionAction? action;
      if (oldVersionMod != null) {
        // Ya existe un mod con este nombre.
        action = await _showSmartInstallDialog(
          oldVersionMod: oldVersionMod,
          baseDisplayName: baseDisplayName,
          newVersion: nexusVersion,
        );
      }

      if (action != null) {
        switch (action) {
          case AlternativeVersionAction.replace:
            if (oldVersionMod == null) {
              // Comprobación de seguridad
              throw Exception(
                "Attempted to replace a mod but no old version was identified.",
              );
            }
            // Preservar customName
            final oldInfoFile = File(
              p.join(oldVersionMod.directory.path, 'nexus_info.json'),
            );
            if (await oldInfoFile.exists()) {
              try {
                final oldData = json.decode(await oldInfoFile.readAsString());
                if (oldData['customName'] != null) {
                  preservedCustomName = oldData['customName'];
                }
              } catch (e) {
                print('Could not read old custom name. Error: $e');
              }
            }
            // Borramos la carpeta de LogicMods antigua
            final deleted = await FileManagerService.deleteDirectoryWithRetry(
              oldVersionMod.directory,
            );
            if (!deleted) {
              throw Exception(
                'Could not delete old mod version (${oldVersionMod.customName}).',
              );
            }
            // NOTA: No podemos desinstalar la parte de UE4SS. El usuario es responsable.
            break;
          case AlternativeVersionAction.installAsNew:
            break; // No hacer nada
          case AlternativeVersionAction.cancel:
          case null:
          default:
            throw Exception(l10n.statusInstallationCancelledByUser);
        }
      }

      // --- 3. Comprobar si la carpeta de destino existe (después del reemplazo) ---
      if (await Directory(logicModDestPath).exists()) {
        final confirmReinstall = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF2a2a2a),
            title: Text(l10n.dialogTitleModExists),
            content: Text(l10n.dialogContentModExists(finalFolderName)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.dialogActionCancel),
              ),
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
          // Preservar customName al reinstalar
          final oldInfoFile = File(p.join(logicModDestPath, 'nexus_info.json'));
          if (preservedCustomName == null && await oldInfoFile.exists()) {
            try {
              final oldData = json.decode(await oldInfoFile.readAsString());
              if (oldData['customName'] != null) {
                preservedCustomName = oldData['customName'];
              }
            } catch (e) {
              print('Could not read old custom name. Error: $e');
            }
          }
          final deleted = await FileManagerService.deleteDirectoryWithRetry(
            Directory(logicModDestPath),
          );
          if (!deleted) {
            throw Exception(
              'Could not delete existing mod ($finalFolderName) to reinstall.',
            );
          }
        }
      }

      // --- 4. Copiar los archivos ---

      // Parte A: Copiar .../zip/LogicMods/* A .../Paks/LogicMods/<mod_name>/
      await Directory(logicModDestPath).create(recursive: true);
      // Comprobamos si la fuente existe (aunque la detección ya lo hizo)
      await FileManagerService.copyDirectory(logicSourceDir, Directory(logicModDestPath));
      // Parte B: Copiar .../zip/Mods/* A .../ue4ss/Mods/ (Fusionar)
      if (ue4ssSourceDir != null && await ue4ssSourceDir.exists()) {
        await FileManagerService.copyDirectory(ue4ssSourceDir, Directory(ue4ssDestPath));
      } else {
        // (Opcional) Informar que no se copió nada de UE4SS
        print(
          "No se encontró la carpeta 'Mods' (UE4SS) para $finalFolderName. Omitiendo copia de scripts.",
        );
      }
      bool hasTildeModsComponent = false; // Rastreador
      if (tildeModsSourceDir != null && await tildeModsSourceDir.exists()) {
        // 1. Definir la nueva ruta de destino específica para este mod
        final tildeModDestPathWithFolder = p.join(
          tildeModsDestPath,
          finalFolderName,
        );
        hasTildeModsComponent = true; // Marcar como verdadero

        print(
          "Instalando archivos complementarios de ~mods para $finalFolderName en: $tildeModDestPathWithFolder",
        );

        // 2. Asegurarse de que esa carpeta exista
        final destDir = Directory(tildeModDestPathWithFolder);
        if (!await destDir.exists()) {
          await destDir.create(recursive: true);
        }

        // 3. Copiar el contenido de la fuente (~mods/*) a la nueva carpeta de destino
        await FileManagerService.copyDirectory(tildeModsSourceDir, destDir);
      }

      // Obtener la lista de carpetas de componentes de UE4SS
      List<String> ue4ssComponentFolders = [];
      if (ue4ssSourceDir != null && await ue4ssSourceDir.exists()) {
        await for (final entity in ue4ssSourceDir.list()) {
          if (entity is Directory) {
            ue4ssComponentFolders.add(p.basename(entity.path));
          }
        }
      }
      // --- 5. Crear nexus_info.json ---
      // Lo creamos dentro de la carpeta que SÍ gestionamos (.../Paks/LogicMods/<mod_name>)
      final infoFile = File(p.join(logicModDestPath, 'nexus_info.json'));
      final versionForFile = nexusVersion;

      final Map<String, dynamic> modData = {
        'nexusId': nexusId,
        'displayName': baseDisplayName,
        'customName': preservedCustomName ?? baseDisplayName,
        'installedVersion': versionForFile,
        'installDate': DateTime.now().toIso8601String(),
        'managerVersion': _appVersion,
        'fitMeshType': fitMeshType, // "Logic"
        'modType': modType.name, // "logicMod"
        'sourceUrl': nexusId != null
            ? 'https://www.nexusmods.com/stellarblade/mods/$nexusId'
            : null,
        'tildeModsComponentFolder': hasTildeModsComponent
            ? finalFolderName
            : null,
        'ue4ssComponents': ue4ssComponentFolders.isNotEmpty
            ? ue4ssComponentFolders
            : null,
      };
      modData.removeWhere((key, value) => value == null); // Limpia nulos

      if (nexusId != null) {
        final nexusData = await NexusApiService.fetchNexusModData(nexusId, _apiKey);
        if (nexusData != null) {
          modData['gallery'] = nexusData['gallery'];
          modData['summary'] = nexusData['summary'];
          modData['author'] = nexusData['author'];
          modData['description'] = nexusData['description'];
        }
      }

      final encoder = JsonEncoder.withIndent('  ');
      await infoFile.writeAsString(encoder.convert(modData));

      // --- 6. Copiar miniatura (igual que antes) ---
      if (nexusId != null) {
        await ModManagerService.cacheNexusThumbnail(apiKey: _apiKey,
          modDirectory: Directory(logicModDestPath),
          nexusId: nexusId,
        );
      }
      return finalFolderName; // Devuelve el nombre para el snackbar
    } else if (modType == ModDirectoryType.cns) {
      // Es un mod CNS: obtenemos el nombre y la etiqueta desde sus .json
      baseDisplayName = await ModManagerService.getCompositeDisplayName(modDir);
      fitMeshType = await ModManagerService.getFitMeshTypeForMod(modDir);
      installPath = _finalModsPath; // Se instala en la carpeta CNS
    } else if (modType == ModDirectoryType.genericPak) {
      // Es un mod Genérico: usamos el nombre del ZIP y la etiqueta "Generic"
      baseDisplayName = preparedMod.archiveName;
      fitMeshType = "Generic";
      installPath = _genericModsPath; // Se instala en la carpeta genérica
    } else if (modType == ModDirectoryType.movies) {
      baseDisplayName = preparedMod.archiveName;
      fitMeshType =
          null; // Los mods de películas no tienen etiqueta de contenido
      installPath = backupDirPath; // Se instala DIRECTAMENTE en backups

      // Busca todos los archivos .bk2 para guardarlos en el JSON
      await for (final entity in modDir.list()) {
        if (entity is File &&
            p.extension(entity.path).toLowerCase() == '.bk2') {
          replacedFiles.add(p.basename(entity.path));
        }
      }
      if (replacedFiles.isEmpty) {
        throw Exception("Movies mod contains no .bk2 files.");
      }
    } else {
      // No debería pasar si el clasificador de _processArchives funcionó
      throw Exception(l10n.errorNoCompatibleFilesInArchive);
    }

    if (baseDisplayName == null) {
      throw FormatException(l10n.errorNoValidDisplayName);
    }
    if (installPath == null) {
      throw Exception("Installation path could not be determined.");
    }

    finalFolderName = baseDisplayName;

    // 2. LÓGICA DE REEMPLAZO/ACTUALIZACIÓN (Esto permanece igual que antes)
    ModInfo? oldVersionMod;
    AlternativeVersionAction? action;

    List<ModInfo> nexusIdMatches = [];
    if (nexusId != null) {
      nexusIdMatches = _allMods.where((mod) => mod.nexusId == nexusId).toList();
    }

    if (nexusIdMatches.isNotEmpty) {
      // ... (La lógica de diálogo de actualización/reemplazo basada en nexusId)
      // Esta sección no necesita cambios, la copio de tu función original.
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
        action = await showDialog<AlternativeVersionAction>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF2a2a2a),
            title: Text(l10n.dialogTitleAlternativeVersion),
            content: Text(
              l10n.dialogContentAlternativeVersion(
                existingModExample,
                baseDisplayName!,
                finalFolderName,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(AlternativeVersionAction.cancel),
                child: Text(l10n.dialogActionCancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(
                  context,
                ).pop(AlternativeVersionAction.installAsNew),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                ),
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
        case AlternativeVersionAction.replace:
          if (oldVersionMod == null) {
            throw Exception(
              "Attempted to replace a mod but no old version was identified.",
            );
          }
          final oldInfoFile = File(
            p.join(oldVersionMod.directory.path, 'nexus_info.json'),
          );
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
          // Si el mod a reemplazar era un 'Movies' habilitado, deshabilítalo primero
          if (oldVersionMod.modType == 'movies' && oldVersionMod.isEnabled) {
            await _disableMod(oldVersionMod);
          }
          final deleted = await FileManagerService.deleteDirectoryWithRetry(
            oldVersionMod.directory,
          );
          if (!deleted) {
            throw Exception('Could not delete old mod version ($oldModName).');
          }
          break;
        case AlternativeVersionAction.installAsNew:
          break;
        case AlternativeVersionAction.cancel:
        case null:
        default:
          throw Exception(l10n.statusInstallationCancelledByUser);
      }
    }

    // 3. LÓGICA DE INSTALACIÓN (Esto también se copia)
    final newModPath = p.join(installPath, finalFolderName);

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
              child: Text(l10n.dialogActionCancel),
            ),
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
        // Si el mod a reinstalar es un 'Movies' habilitado, deshabilítalo primero
        final modToReinstall = _allMods.firstWhere(
          (m) => m.directory.path == newModPath,
          orElse: () => ModInfo(
            directory: Directory(''),
            lastModified: DateTime.now(),
            isEnabled: false,
            displayName: '',
            customName: '',
          ),
        );
        if (modToReinstall.directory.path.isNotEmpty &&
            modToReinstall.modType == 'movies' &&
            modToReinstall.isEnabled) {
          await _disableMod(modToReinstall);
        }

        final deleted = await FileManagerService.deleteDirectoryWithRetry(Directory(newModPath));
        if (!deleted) {
          throw Exception(
            'Could not delete existing mod ($finalFolderName) to reinstall after several attempts.',
          );
        }
      }
    }

    await Directory(newModPath).create(recursive: true);

    // 4. CREAR nexus_info.json (Aquí es donde guardamos la etiqueta)
    // Usamos el nexusId si existe, pero ahora creamos el archivo *siempre*.
    final infoFile = File(p.join(newModPath, 'nexus_info.json'));
    final versionForFile = nexusVersion;

    final Map<String, dynamic> modData = {
      'nexusId': nexusId,
      'displayName': baseDisplayName,
      'customName': preservedCustomName ?? baseDisplayName,
      'installedVersion': versionForFile,
      'installDate': DateTime.now().toIso8601String(),
      'managerVersion': _appVersion,
      'fitMeshType': fitMeshType, // <-- "Generic" o el tipo de CNS
      'modType': modType.name, // <-- AÑADIDO: "cns" o "genericPak"
      'sourceUrl': nexusId != null
          ? 'https://www.nexusmods.com/stellarblade/mods/$nexusId'
          : null,
      'isEnabled': (modType == ModDirectoryType.movies)
          ? false
          : null, // Los mods 'Movies' se instalan deshabilitados
      'replacedFiles': (modType == ModDirectoryType.movies)
          ? replacedFiles
          : null,
      'replacesOutfits': selectedOutfit != null ? [selectedOutfit] : null,
    };
    // Limpia valores nulos para no ensuciar el JSON
    modData.removeWhere((key, value) => value == null);

    if (nexusId != null) {
      final nexusData = await NexusApiService.fetchNexusModData(nexusId, _apiKey);
      if (nexusData != null) {
        modData['gallery'] = nexusData['gallery'];
        modData['summary'] = nexusData['summary'];
        modData['author'] = nexusData['author'];
        modData['description'] = nexusData['description'];
      }
    }

    final encoder = JsonEncoder.withIndent('  ');
    await infoFile.writeAsString(encoder.convert(modData));

    // 5. COPIAR ARCHIVOS (Usando la función auxiliar que ya tenías)
    List<File> filesToInstall = [];
    if (modType == ModDirectoryType.movies) {
      // Solo copia los archivos .bk2
      for (final fileName in replacedFiles) {
        filesToInstall.add(File(p.join(modDir.path, fileName)));
      }
    } else {
      // Lógica anterior para CNS/Genéricos
      filesToInstall = await FileManagerService.findAllModFilesRecursive(modDir);
    }

    for (final file in filesToInstall) {
      final fileName = p.basename(file.path);
      final destinationPath = p.join(newModPath, fileName);
      await file.copy(destinationPath);
    }

    if (nexusId != null) {
      await ModManagerService.cacheNexusThumbnail(apiKey: _apiKey,
        modDirectory: Directory(newModPath),
        nexusId: nexusId,
      );
    }
    return finalFolderName;
  }

  Future<bool> _enableMod(ModInfo modInfo) async {
    if (_finalModsPath == null ||
        _genericModsPath == null ||
        _logicModsPath == null)
      return false;
    final List<String> outfitsToReplace = modInfo.replacesOutfits ?? [];
    final bool isReplacementMod = outfitsToReplace.isNotEmpty;

    if (isReplacementMod) {
      ModInfo? conflictingMod;
      List<String> overlappingOutfits = [];

      try {
        for (final otherMod in _allMods) {
          if (otherMod.isEnabled && otherMod.directory.path != modInfo.directory.path) {
            final otherOutfits = otherMod.replacesOutfits ?? [];
            // Busca la intersección (trajes que ambos mods intentan usar)
            final intersection = outfitsToReplace.where((o) => otherOutfits.contains(o)).toList();
            
            if (intersection.isNotEmpty) {
              conflictingMod = otherMod;
              overlappingOutfits = intersection;
              break; // ¡Conflicto encontrado!
            }
          }
        }
      } catch (e) {
        conflictingMod = null;
      }

      if (conflictingMod != null) {
        final l10n = AppLocalizations.of(context)!;
        // Une los nombres con coma si hay múltiples conflictos
        final String outfitName = overlappingOutfits.join(', ');
        final String modName = conflictingMod.customName;

        // Obtenemos el texto completo de la localización
        final String fullString = l10n.dialogContentOutfitConflict(
          outfitName,
          modName,
        );

        // Dividimos el texto usando los nombres como separadores
        final List<String> parts = fullString.split(outfitName);
        final String part1 = parts.isNotEmpty ? parts[0] : "";

        String part2 = "";
        String part3 = "";

        if (parts.length > 1) {
          // Buscamos el nombre del mod en la segunda parte del texto
          final List<String> parts2 = parts[1].split(modName);
          part2 = parts2.isNotEmpty ? parts2[0] : "";
          if (parts2.length > 1) {
            part3 = parts2[1];
          }
        }

        // Ahora el diálogo devuelve un booleano (true = forzar activación)
        final bool? forceActivate = await showDialog<bool>(
          context: context,
          barrierDismissible: false, // No permitir cerrar sin elegir
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF2a2a2a),
            title: Text(l10n.dialogTitleOutfitConflict),

            // Reemplazamos el 'content: Text(...)' por 'content: RichText(...)'
            content: RichText(
              text: TextSpan(
                // Usar el estilo de texto por defecto del diálogo
                style:
                    Theme.of(context).dialogTheme.contentTextStyle ??
                    const TextStyle(color: Colors.white, height: 1.5),
                children: [
                  // Parte 1 del texto
                  TextSpan(text: part1),

                  // Widget 1: El nombre del traje (interactivo)
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: MouseRegion(
                      onEnter: (event) {
                        _cursorPosition = event.position;
                        _hoverTimer?.cancel();
                        _hoverTimer = Timer(
                          const Duration(milliseconds: 800),
                          () {
                            if (mounted) {
                              _showPreviewOverlay(
                                context,
                                outfitName, // El nombre del traje
                                _cursorPosition,
                              );
                            }
                          },
                        );
                      },
                      onExit: (event) => _hidePreviewOverlay(),
                      onHover: (event) => _cursorPosition = event.position,
                      child: Text(
                        outfitName, // El nombre resaltado
                        style: const TextStyle(
                          color: Colors.tealAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Parte 2 del texto
                  TextSpan(text: part2),

                  // Widget 2: El nombre del mod (interactivo)
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: InkWell(
                      onTap: () {
                        // Cierra el diálogo actual (con 'false' para cancelar la activación)
                        //Navigator.of(context).pop(false);
                        // Abre el panel de detalles del mod en conflicto
                        _showDetailsPage(conflictingMod!);
                      },
                      child: Text(
                        modName, // El nombre resaltado
                        style: const TextStyle(
                          color: Colors.yellowAccent,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),

                  // Parte 3 del texto
                  TextSpan(text: part3),
                ],
              ),
            ),

            actions: [
              // Botón de Cancelar
              TextButton(
                onPressed: () {
                  _hidePreviewOverlay(); // Oculta la vista previa si está visible
                  Navigator.of(context).pop(false);
                },
                child: Text(l10n.dialogActionCancel),
              ),
              // Botón de Activar y Desactivar
              ElevatedButton(
                onPressed: () {
                  _hidePreviewOverlay(); // Oculta la vista previa si está visible
                  Navigator.of(context).pop(true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                ),
                child: Text(l10n.dialogActionActivateAndDisable),
              ),
            ],
          ),
        );

        // Si el usuario no forzó la activación (canceló)
        if (forceActivate != true) {
          return false;
        }

        // Si el usuario SÍ forzó la activación, desactiva el mod conflictivo
        // antes de continuar con la activación del nuevo.
        final bool disabled = await _disableMod(conflictingMod);
        if (!disabled) {
          // Si no se pudo deshabilitar el mod conflictivo,
          // cancela la activación del nuevo.
          return false;
        }
        // ++ FIN DE LA MODIFICACIÓN DEL DIÁLOGO ++
      }
    }
    //setState(() => _isLoading = true);

    try {
      ModInfo updatedMod;

      // --- INICIO DE LÓGICA DE BIFURCACIÓN ---
      if (modInfo.modType == 'movies') {
        // LÓGICA DE REEMPLAZO (MOVIES)
        // ++ PASAMOS _allMods para que pueda resolver conflictos ++
        await _enableMovieMod(modInfo, _allMods);
        updatedMod = modInfo.copyWith(
          isEnabled: true,
        ); // Actualiza el estado local
      } else {
        // LÓGICA DE MOVIMIENTO DE CARPETA (CNS/GENÉRICO)
        final modName = p.basename(modInfo.directory.path);

        final backupContainerDir = modInfo.directory;

        // ++ INICIO DE LA MODIFICACIÓN ++
        // 1. Restaurar componentes adicionales si es un LogicMod
        if (modInfo.modType == 'logicMod') {
          // Leer el JSON desde su ubicación actual (dentro del respaldo)
          final infoFile = File(
            p.join(backupContainerDir.path, 'nexus_info.json'),
          );
          if (await infoFile.exists()) {
            try {
              final data = json.decode(await infoFile.readAsString());

              // 2. Restaurar Parte C (~mods component)
              final String? tildeFolder = data['tildeModsComponentFolder'];
              if (tildeFolder != null && _genericModsPath != null) {
                // Origen: __MOD_BACKUPS__/<mod_name>/_tilde_mods/<mod_name>
                final tildeBackupContainer = Directory(
                  p.join(backupContainerDir.path, "_tilde_mods"),
                );
                final tildeSourceDir = Directory(
                  p.join(tildeBackupContainer.path, tildeFolder),
                );

                if (await tildeSourceDir.exists()) {
                  print("Restaurando componente ~mods: $tildeFolder");
                  // Mover de vuelta a .../Paks/~mods/
                  await FileManagerService.moveMod(tildeSourceDir, _genericModsPath!);
                  // Limpiar la carpeta contenedora vacía
                  if (await tildeBackupContainer.list().isEmpty)
                    await tildeBackupContainer.delete();
                }
              }

              // 3. Restaurar Parte B (UE4SS components)
              final List<dynamic>? ue4ssFolders = data['ue4ssComponents'];
              if (ue4ssFolders != null && _ue4ssModsPath != null) {
                // Origen: __MOD_BACKUPS__/<mod_name>/_ue4ss_mods/
                final ue4ssBackupContainer = Directory(
                  p.join(backupContainerDir.path, "_ue4ss_mods"),
                );

                for (final folderName in ue4ssFolders.cast<String>()) {
                  // Origen: .../_ue4ss_mods/<component_name>
                  final ue4ssSourceDir = Directory(
                    p.join(ue4ssBackupContainer.path, folderName),
                  );
                  if (await ue4ssSourceDir.exists()) {
                    print("Restaurando componente UE4SS: $folderName");
                    // Mover de vuelta a .../ue4ss/Mods/
                    await FileManagerService.moveMod(ue4ssSourceDir, _ue4ssModsPath!);
                  }
                }
                // Limpiar la carpeta contenedora vacía
                if (await ue4ssBackupContainer.list().isEmpty)
                  await ue4ssBackupContainer.delete();
              }
            } catch (e) {
              print("Error al restaurar componentes de LogicMod: $e");
            }
          }
        }

        String modType = modInfo.modType ?? 'cns'; // Usa el tipo del ModInfo

        final String targetPath;
        if (modType == 'genericPak') {
          targetPath = _genericModsPath!;
        } else if (modType == 'logicMod') {
          targetPath = _logicModsPath!; // <-- RUTA NUEVA
        } else {
          targetPath = _finalModsPath!; // Default a CNS
        }

        final newDirectory = Directory(p.join(targetPath, modName));
        await FileManagerService.moveMod(backupContainerDir, targetPath);

        updatedMod = modInfo.copyWith(directory: newDirectory, isEnabled: true);
      }
      // --- FIN DE LÓGICA DE BIFURCACIÓN ---

      final modIndex = _allMods.indexWhere(
        (m) => m.directory.path == modInfo.directory.path,
      );
      if (modIndex != -1) {
        setState(() {
          _allMods[modIndex] = updatedMod;
        });
      } else {
        await _loadAllMods();
      }
      return true;
    } catch (e) {
      setState(() {
        _statusMessage = AppLocalizations.of(
          context,
        )!.errorEnableMod(e.toString());
        _statusColor = Colors.redAccent;
      });
      await _loadAllMods();
      return false;
    } finally {
      //setState(() => _isLoading = false);
    }
  }

  Future<bool> _disableMod(ModInfo modInfo) async {
    if (_gameRootPath == null) return false;
    //setState(() => _isLoading = true);

    try {
      final backupDir = Directory(
        p.join(_gameRootPath!, 'SB', 'Content', '__MOD_BACKUPS__'),
      );
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }

      ModInfo updatedMod;

      // --- INICIO DE LÓGICA DE BIFURCACIÓN ---
      if (modInfo.modType == 'movies') {
        // LÓGICA DE REEMPLAZO (MOVIES)
        await _disableMovieMod(modInfo);
        updatedMod = modInfo.copyWith(
          isEnabled: false,
        ); // Actualiza el estado local
      } else {
        // LÓGICA DE MOVIMIENTO DE CARPETA (CNS/GENÉRICO)
        final modName = p.basename(modInfo.directory.path);
        final newDirectory = Directory(p.join(backupDir.path, modName));
        // 1. Mover Parte A (La carpeta principal, ej: LogicMods/<mod_name>)
        await FileManagerService.moveMod(modInfo.directory, backupDir.path);

        // ++ INICIO DE LA MODIFICACIÓN ++
        // 2. Mover componentes adicionales si es un LogicMod
        if (modInfo.modType == 'logicMod') {
          // Leer el JSON desde su *nueva* ubicación (dentro del respaldo)
          final infoFile = File(p.join(newDirectory.path, 'nexus_info.json'));
          if (await infoFile.exists()) {
            try {
              final data = json.decode(await infoFile.readAsString());

              // 3. Mover Parte C (~mods component)
              final String? tildeFolder = data['tildeModsComponentFolder'];
              if (tildeFolder != null && _genericModsPath != null) {
                final tildeSourceDir = Directory(
                  p.join(_genericModsPath!, tildeFolder),
                );
                // Destino: __MOD_BACKUPS__/<mod_name>/_tilde_mods/
                final tildeDestContainer = Directory(
                  p.join(newDirectory.path, "_tilde_mods"),
                );
                if (!await tildeDestContainer.exists())
                  await tildeDestContainer.create();

                if (await tildeSourceDir.exists()) {
                  print("Archivando componente ~mods: $tildeFolder");
                  await FileManagerService.moveMod(tildeSourceDir, tildeDestContainer.path);
                }
              }

              // 4. Mover Parte B (UE4SS components)
              final List<dynamic>? ue4ssFolders = data['ue4ssComponents'];
              if (ue4ssFolders != null && _ue4ssModsPath != null) {
                // Destino: __MOD_BACKUPS__/<mod_name>/_ue4ss_mods/
                final ue4ssDestContainer = Directory(
                  p.join(newDirectory.path, "_ue4ss_mods"),
                );
                if (!await ue4ssDestContainer.exists())
                  await ue4ssDestContainer.create();

                for (final folderName in ue4ssFolders.cast<String>()) {
                  final ue4ssSourceDir = Directory(
                    p.join(_ue4ssModsPath!, folderName),
                  );
                  if (await ue4ssSourceDir.exists()) {
                    print("Archivando componente UE4SS: $folderName");
                    await FileManagerService.moveMod(ue4ssSourceDir, ue4ssDestContainer.path);
                  }
                }
              }
            } catch (e) {
              print("Error al archivar componentes de LogicMod: $e");
            }
          }
        }

        updatedMod = modInfo.copyWith(
          directory: newDirectory,
          isEnabled: false,
        );
      }
      // --- FIN DE LÓGICA DE BIFURCACIÓN ---

      final modIndex = _allMods.indexWhere(
        (m) => m.directory.path == modInfo.directory.path,
      );
      if (modIndex != -1) {
        setState(() {
          _allMods[modIndex] = updatedMod;
        });
      } else {
        await _loadAllMods();
      }
      return true;
    } catch (e) {
      setState(() {
        _statusMessage = AppLocalizations.of(
          context,
        )!.errorDisableMod(e.toString());
        _statusColor = Colors.redAccent;
      });
      await _loadAllMods();
      return false;
    } finally {
      //setState(() => _isLoading = false);
    }
  }

  /// Lógica específica para HABILITAR un mod de tipo "Movies".
  Future<void> _enableMovieMod(ModInfo modInfo, List<ModInfo> allMods) async {
    if (_moviesPath == null || _moviesBackupPath == null) {
      throw Exception("Movies paths are not defined.");
    }

    final infoFile = File(p.join(modInfo.directory.path, 'nexus_info.json'));
    if (!await infoFile.exists()) {
      throw Exception("nexus_info.json not found for ${modInfo.customName}.");
    }

    final data = json.decode(await infoFile.readAsString());
    final List<String> replacedFiles = List<String>.from(
      data['replacedFiles'] ?? [],
    );

    // ++ INICIO DE LA LÓGICA DE EXCLUSIVIDAD ++
    // 1. Deshabilitar otros mods que reemplacen los mismos archivos
    final Set<String> filesToReplace = replacedFiles.toSet();

    for (final otherMod in allMods) {
      // Si es el mismo mod, o no está habilitado, o no es de películas, lo ignoramos
      // ++ LÓGICA REVERTIDA: solo nos importa si 'otherMod.isEnabled' es true ++
      if (otherMod.directory.path == modInfo.directory.path ||
          !otherMod.isEnabled ||
          otherMod.modType != 'movies') {
        continue;
      }

      // Leemos los archivos del otro mod
      final otherInfoFile = File(
        p.join(otherMod.directory.path, 'nexus_info.json'),
      );
      if (!await otherInfoFile.exists()) continue;

      try {
        final otherData = json.decode(await otherInfoFile.readAsString());
        final List<String> otherReplacedFiles = List<String>.from(
          otherData['replacedFiles'] ?? [],
        );

        // Comprobamos si hay CUALQUIER solapamiento
        bool hasConflict = otherReplacedFiles.any(
          (file) => filesToReplace.contains(file),
        );

        if (hasConflict) {
          print("Disabling conflicting movie mod: ${otherMod.customName}");
          // Deshabilitamos el mod conflictivo (esto restaura la original)
          await _disableMovieMod(otherMod);

          // Actualizamos su estado en la lista principal (_allMods)
          final modIndex = allMods.indexWhere(
            (m) => m.directory.path == otherMod.directory.path,
          );
          if (modIndex != -1) {
            // Actualizamos la instancia en la lista que se está procesando
            allMods[modIndex] = otherMod.copyWith(isEnabled: false);
          }
        }
      } catch (e) {
        print("Error checking conflict for ${otherMod.customName}: $e");
      }
    }
    // ++ FIN DE LA LÓGICA DE EXCLUSIVIDAD ++

    // 2. Lógica de habilitación (copia de seguridad y reemplazo)
    // (Esta lógica se ejecuta DESPUÉS de que _disableMovieMod haya restaurado la original)
    for (final fileName in replacedFiles) {
      final gameFile = File(p.join(_moviesPath!, fileName));
      final backupFile = File(p.join(_moviesBackupPath!, '$fileName.bak'));
      final modFile = File(p.join(modInfo.directory.path, fileName));

      // 1. Crear respaldo del archivo original, SI NO EXISTE YA
      // (La lógica de "no sobrescribir respaldo" sigue siendo válida y crucial)
      if (await gameFile.exists() && !await backupFile.exists()) {
        await gameFile.copy(backupFile.path);
      }

      // 2. Copiar el archivo del mod al directorio del juego
      if (await modFile.exists()) {
        await modFile.copy(gameFile.path);
      }
    }

    // 3. Actualizar el estado en el JSON del nuevo mod
    data['isEnabled'] = true;
    final encoder = JsonEncoder.withIndent('  ');
    await infoFile.writeAsString(encoder.convert(data));
  }

  /// Lógica específica para DESHABILITAR un mod de tipo "Movies".
  Future<void> _disableMovieMod(ModInfo modInfo) async {
    if (_moviesPath == null || _moviesBackupPath == null) {
      throw Exception("Movies paths are not defined.");
    }

    final infoFile = File(p.join(modInfo.directory.path, 'nexus_info.json'));
    if (!await infoFile.exists()) {
      throw Exception("nexus_info.json not found for ${modInfo.customName}.");
    }

    final data = json.decode(await infoFile.readAsString());
    final List<String> replacedFiles = List<String>.from(
      data['replacedFiles'] ?? [],
    );

    for (final fileName in replacedFiles) {
      final gameFile = File(p.join(_moviesPath!, fileName));
      final backupFile = File(p.join(_moviesBackupPath!, '$fileName.bak'));

      // 1. Restaurar el respaldo, SI EXISTE
      if (await backupFile.exists()) {
        await backupFile.copy(gameFile.path);
      } else {
        // Si no hay respaldo, lo mejor que podemos hacer es borrar el archivo
        // del mod para no dejarlo en estado "modificado".
        if (await gameFile.exists()) {
          await gameFile.delete();
        }
      }
    }

    // 2. Actualizar el estado en el JSON
    data['isEnabled'] = false;
    final encoder = JsonEncoder.withIndent('  ');
    await infoFile.writeAsString(encoder.convert(data));
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
            child: Text(l10n.dialogActionCancel),
          ),
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
      // --- INICIO DE LÓGICA DE BIFURCACIÓN ---
      if (modInfo.modType == 'movies') {
        // LÓGICA DE REEMPLAZO (MOVIES)
        // 1. Si está habilitado, deshabilítalo primero para restaurar el original.
        if (modInfo.isEnabled) {
          await _disableMovieMod(modInfo);
        }

        // 2. (Opcional pero recomendado) Borra los backups de los originales
        final infoFile = File(
          p.join(modInfo.directory.path, 'nexus_info.json'),
        );
        if (await infoFile.exists() && _moviesBackupPath != null) {
          try {
            final data = json.decode(await infoFile.readAsString());
            final List<String> replacedFiles = List<String>.from(
              data['replacedFiles'] ?? [],
            );
            for (final fileName in replacedFiles) {
              final backupFile = File(
                p.join(_moviesBackupPath!, '$fileName.bak'),
              );
              if (await backupFile.exists()) {
                await backupFile.delete();
              }
            }
          } catch (e) {
            print("Could not clean up movie backups: $e");
          }
        }
      }
      // --- FIN DE LÓGICA DE BIFURCACIÓN ---

      // La lógica de borrado de carpeta es la misma para todos
      final deleted = await FileManagerService.deleteDirectoryWithRetry(modInfo.directory);

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

  Future<void> _enableAllMods(List<ModInfo> modsInView) async {
    final l10n = AppLocalizations.of(context)!;

    // ++ INICIO DE LA MODIFICACIÓN ++
    // 1. Obtenemos solo los mods deshabilitados QUE NO SEAN de tipo 'movies'.
    final disabledMods = modsInView
        .where((mod) => !mod.isEnabled && mod.modType != 'movies')
        .toList();
    // ++ FIN DE LA MODIFICACIÓN ++

    if (disabledMods.isEmpty) {
      if (mounted) {
        NotificationService.instance.show(
          context: context,
          type: NotificationType.info,
          // Este mensaje ahora es más preciso, ya que puede haber
          // mods de películas deshabilitados, pero no mods "habilitables"
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
        // El 'disabledMods.length' ahora es correcto (no incluye películas)
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
      if (_finalModsPath == null || _genericModsPath == null) {
        throw Exception("Mods paths are not defined.");
      }

      // 2. Un mapa para rastrear la ruta antigua a la nueva ModInfo
      final Map<String, ModInfo> updatedModMap = {};

      // ++ INICIO DE LA MODIFICACIÓN ++
      // 3. Eliminamos toda la lógica de 'movieFileOwnerMap'.
      // Iteramos directamente sobre 'disabledMods', que ya no contiene películas.

      for (final mod in disabledMods) {
        // 4. El 'if (mod.modType == 'movies')' se ha ido.
        // Solo queda la lógica 'else' (CNS/Genérico).

        // LÓGICA DE MOVIMIENTO DE CARPETA (CNS/GENÉRICO)
        final modName = p.basename(mod.directory.path);
        final modType = mod.modType ?? 'cns';

        final String targetPath = (modType == 'genericPak')
            ? _genericModsPath!
            : _finalModsPath!;

        await FileManagerService.moveMod(mod.directory, targetPath);

        updatedModMap[mod.directory.path] = mod.copyWith(
          directory: Directory(p.join(targetPath, modName)),
          isEnabled: true,
        );
      }
      // ++ FIN DE LA MODIFICACIÓN ++

      // 5. Actualizar la lista de estado (_allMods) usando el mapa
      final List<ModInfo> updatedModsList = _allMods.map((originalMod) {
        if (updatedModMap.containsKey(originalMod.directory.path)) {
          return updatedModMap[originalMod.directory.path]!;
        }
        return originalMod;
      }).toList();

      setState(() {
        _allMods = updatedModsList;
      });
      // --- FIN DE LA CORRECCIÓN ---

      if (mounted) {
        NotificationService.instance.show(
          context: context,
          type: NotificationType.success,
          // 'disabledMods.length' es correcto.
          title: l10n.snackBarAllModsEnabled(disabledMods.length),
        );
      }
    } catch (e) {
      setState(() {
        _statusMessage = AppLocalizations.of(
          context,
        )!.errorEnableMod(e.toString());
        _statusColor = Colors.redAccent;
      });
      await _loadAllMods();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _disableAllMods(List<ModInfo> modsInView) async {
    final l10n = AppLocalizations.of(context)!;
    final enabledMods = modsInView.where((mod) => mod.isEnabled).toList();

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
            child: Text(l10n.dialogActionCancel),
          ),
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
      final backupDir = Directory(
        p.join(_gameRootPath!, 'SB', 'Content', '__MOD_BACKUPS__'),
      );
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }

      // 1. Un mapa para rastrear la ruta antigua a la nueva ModInfo
      final Map<String, ModInfo> updatedModMap = {};

      for (final mod in enabledMods) {
        // ++ INICIO DE LA LÓGICA CORREGIDA ++
        if (mod.modType == 'movies') {
          // LÓGICA DE RESTAURACIÓN (MOVIES)
          await _disableMovieMod(mod);
          // Prepara la actualización para el mapa. No se mueve de carpeta.
          updatedModMap[mod.directory.path] = mod.copyWith(isEnabled: false);
        } else {
          // LÓGICA DE MOVIMIENTO DE CARPETA (CNS/GENÉRICO)
          final modName = p.basename(mod.directory.path);
          await FileManagerService.moveMod(mod.directory, backupDir.path);
          // Prepara la actualización para el mapa, con la nueva ruta.
          updatedModMap[mod.directory.path] = mod.copyWith(
            directory: Directory(p.join(backupDir.path, modName)),
            isEnabled: false,
          );
        }
        // ++ FIN DE LA LÓGICA CORREGIDA ++
      }

      // 2. Actualizar la lista de estado (_allMods) usando el mapa
      final List<ModInfo> updatedModsList = _allMods.map((originalMod) {
        // Comprueba si este mod es uno de los que acabamos de actualizar
        if (updatedModMap.containsKey(originalMod.directory.path)) {
          return updatedModMap[originalMod.directory.path]!;
        }
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
        _statusMessage = AppLocalizations.of(
          context,
        )!.errorDisableMod(e.toString());
        _statusColor = Colors.redAccent;
      });
      await _loadAllMods(); // Mantenemos la recarga total solo en caso de error
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteDisabledMods(List<ModInfo> modsInView) async {
    final l10n = AppLocalizations.of(context)!;
    final disabledMods = modsInView.where((mod) => !mod.isEnabled).toList();

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
            child: Text(l10n.dialogActionCancel),
          ),
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
        if (await FileManagerService.deleteDirectoryWithRetry(mod.directory)) {
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
        _statusMessage = AppLocalizations.of(
          context,
        )!.errorDeleteMod(e.toString());
        _statusColor = Colors.redAccent;
      });
    } finally {
      await _loadAllMods();
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showInExplorer(Directory modDirectory) async {
    final uri = Uri.file(modDirectory.path);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      setState(() {
        _statusMessage = AppLocalizations.of(
          context,
        )!.errorOpenFolder(modDirectory.path);
        _statusColor = Colors.redAccent;
      });
    }
  }

  Future<void> _clearSelection({
    String? message,
    StateSetter? panelStateSetter,
  }) async {
    final updateState = panelStateSetter ?? setState;

    await _cancelAndCleanInstallation();

    updateState(() {
      if (mounted) {
        _statusMessage =
            //message ?? AppLocalizations.of(context)!.statusSelectionCancelled;
            _statusMessage = '';
        _statusColor = Colors.white;
      }
      // ++ CAMBIO: Usa un color distintivo para que el mensaje sea visible. ++
      _statusColor = message == null
          ? Colors.orangeAccent
          : Colors.orangeAccent;
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
    _versionTapCount = 0;
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
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setDialogState) {
                return GestureDetector(
                  onTap: () {
                    setDialogState(() {
                      _versionTapCount++;
                    });

                    if (_versionTapCount >= 7) {
                      setState(() {
                        _developerModeEnabled = true;
                      });
                      Navigator.of(context).pop(); // Cierra el diálogo
                      NotificationService.instance.show(
                        context: context,
                        type: NotificationType.success,
                        title: 'Developer Mode Enabled!',
                      );
                    }
                  },
                  child: Text(l10n.aboutVersion(_appVersion)),
                );
              },
            ),
            const SizedBox(height: 20),
            InkWell(
              child: Text(
                l10n.aboutLinkText,
                style: const TextStyle(
                  color: Colors.tealAccent,
                  decoration: TextDecoration.underline,
                ),
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
                      ),
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
                  onPressed: isChecking
                      ? null
                      : () async {
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

                          final bool isValid = await NexusApiService.validateApiKey(keyToValidate);

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
          },
        );
      },
    );
  }

  Future<ModInfo?> _updateModCustomName(
    ModInfo mod,
    String newCustomName,
  ) async {
    if (newCustomName.isEmpty || newCustomName == mod.customName) {
      return null; // No hay cambios, no hagas nada
    }

    try {
      final infoFile = File(p.join(mod.directory.path, 'nexus_info.json'));
      Map<String, dynamic> data = {};
      if (await infoFile.exists()) {
        final content = await infoFile.readAsString();
        if (content.isNotEmpty) data = json.decode(content);
      }

      if (newCustomName == mod.displayName) {
        data.remove('customName');
      } else {
        data['customName'] = newCustomName;
      }

      final encoder = JsonEncoder.withIndent('  ');
      await infoFile.writeAsString(encoder.convert(data));

      // Reconstruye manualmente el objeto para asegurar que el nombre se actualice
      return ModInfo(
        directory: mod.directory,
        nexusId: mod.nexusId,
        localVersion: mod.localVersion,
        lastModified: mod.lastModified,
        installDate: mod.installDate,
        isEnabled: mod.isEnabled,
        origin: mod.origin,
        displayName: mod.displayName,
        // Asigna directamente desde el mapa 'data', con fallback al nombre de visualización
        customName: data['customName'] ?? mod.displayName,
        gallery: mod.gallery,
        fitMeshType: mod.fitMeshType,
        customCoverPath: mod.customCoverPath,
        customCoverAlignment: mod.customCoverAlignment,
        customCoverLastModified: mod.customCoverLastModified,
        customVersion: mod.customVersion,
        customFitMeshType: mod.customFitMeshType,
        summary: mod.summary,
        customSummary: mod.customSummary,
        description: mod.description,
        customDescription: mod.customDescription,
        author: mod.author,
        customAuthor: mod.customAuthor,
        userNotes: mod.userNotes,
        sourceUrl: mod.sourceUrl,
        customSourceUrl: mod.customSourceUrl,
      );
    } catch (e) {
      setState(() {
        _statusMessage = "Error renaming mod: $e";
        _statusColor = Colors.redAccent;
      });
      return null;
    }
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

    setState(() {
      _isCheckingForUpdates = true;
      _statusMessage = l10n.statusCheckingUpdates;
      _modUpdates.clear();
      _cnsUpdateInfo = null;
      _ignoredUpdates.clear();
    });

    final result = await UpdateService.checkForAllUpdates(
      apiKey: _apiKey!,
      cnsNexusId: _cnsNexusId,
      cnsVersion: _cnsVersion,
      gameRootPath: _gameRootPath,
      allMods: _allMods,
      skippedVersions: _skippedVersions,
    );

    setState(() {
      if (result.error != null) {
        _statusMessage = l10n.statusError(result.error!);
        _statusColor = Colors.redAccent;
      } else if (result.updatesFound > 0) {
        _statusMessage = l10n.statusUpdatesFound(result.updatesFound);
        _statusColor = Colors.yellowAccent;
        _cnsUpdateInfo = result.cnsUpdateInfo;
        _modUpdates.addAll(result.modUpdates);
      } else {
        _statusMessage = l10n.statusNoUpdates;
        _statusColor = Colors.greenAccent;
      }
      _isCheckingForUpdates = false;
    });
  }

  void _showImageGalleryDialog(
    ModInfo modInfo, {
    int initialIndex = 0,
    String? initialImage,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final List<String> images = (modInfo.gallery ?? [])
        .map((img) => img['image'] as String)
        .toList();

    if (modInfo.customCoverPath != null) {
      final customCoverFullPath = p.join(
        modInfo.directory.path,
        modInfo.customCoverPath!,
      );
      if (!images.contains(customCoverFullPath)) {
        images.insert(0, customCoverFullPath);
      }
    }

    if (images.isEmpty) {
      // No hacer nada si no hay imágenes
      return;
    }

    // Determina el índice inicial si se pasó una imagen específica
    int finalInitialIndex = initialIndex;
    if (initialImage != null) {
      int foundIndex = images.indexOf(initialImage);
      if (foundIndex != -1) {
        finalInitialIndex = foundIndex;
      }
    }

    final pageController = PageController(initialPage: finalInitialIndex);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: <Widget>[
              PageView.builder(
                controller: pageController,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final imageUrl = images[index];
                  final isLocal = !imageUrl.startsWith('http');
                  return InteractiveViewer(
                    panEnabled: true,
                    minScale: 1.0,
                    maxScale: 4.0,
                    child: Center(
                      child: isLocal
                          ? Image.file(File(imageUrl))
                          : Image.network(imageUrl),
                    ),
                  );
                },
              ),
              Positioned(
                top: 15,
                right: 15,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.5),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: l10n.dialogActionClose,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _showUpdateOptionsDialog({
    required String newVersion,
    required String nexusId,
    required int fileId,
    required String uniqueIdentifier,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final String cleanedVersion = newVersion.toLowerCase().startsWith('v')
        ? newVersion.substring(1)
        : newVersion;

    // Busca el nombre del mod para mostrarlo en la notificación.
    // Incluye un respaldo para el CNS, que no está en la lista general de mods.
    final modName = _allMods
        .firstWhere(
          (m) => m.nexusId == nexusId,
          orElse: () => ModInfo(
            directory: Directory(''),
            customName: l10n.cnsCoreSystem,
            displayName: '',
            isEnabled: false,
            lastModified: DateTime.now(),
          ),
        )
        .customName;

    // El diálogo ahora devuelve un booleano: 'true' si la notificación se ocultó.
    final bool? result = await showDialog<bool>(
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
              NotificationService.instance.show(
                context: context,
                type: NotificationType.info,
                title: l10n.snackBarUpdateIgnored(modName),
              );
              Navigator.of(context).pop(true); // Devuelve 'true'
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
                  _modUpdates.removeWhere(
                    (key, value) =>
                        _allMods
                            .firstWhere((mod) => mod.directory.path == key)
                            .nexusId ==
                        nexusId,
                  );
                }
              });
              await _saveSkippedVersions();
              NotificationService.instance.show(
                context: context,
                type: NotificationType.info,
                title: l10n.snackBarVersionSkipped(modName, newVersion),
              );
              Navigator.of(context).pop(true); // Devuelve 'true'
            },
            child: Text(l10n.dialogActionSkipVersion),
          ),
          ElevatedButton(
            onPressed: () async {
              final url = Uri.parse(
                'https://www.nexusmods.com/stellarblade/mods/$nexusId?tab=files&file_id=$fileId',
              );
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
              Navigator.of(context).pop(false); // Devuelve 'false'
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
    // Si el diálogo se cierra sin seleccionar, devuelve 'false'.
    return result ?? false;
  }

  Future<void> _manageSkippedVersions() async {
    final l10n = AppLocalizations.of(context)!;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
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
                              origin: null,
                            ),
                          );
                          final modName = mod.directory.path.isNotEmpty
                              ? mod.customName
                              : 'ID: ${entry.key}';

                          return ListTile(
                            title: Text(modName),
                            subtitle: Text(
                              '${l10n.dialogSkippedVersions}: ${entry.value}',
                            ),
                            trailing: IconButton(
                              icon: const HugeIcon(icon: HugeIcons.strokeRoundedDelete01, color: Colors.redAccent, size: 24.0),
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
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<ModInfo> _getFilteredAndSortedMods(AppLocalizations l10n) {
    List<ModInfo> mods = List.from(_allMods);

    // --- 1. APLICA EL FILTRO DE TIPO DE MOD (Barra de Navegación) ---
    switch (_currentModTypeFilter) {
      case ModTypeFilter.cns:
        // Incluye mods 'cns' y mods antiguos (null) que son tratados como cns
        mods.retainWhere((mod) => mod.modType == 'cns' || mod.modType == null);
        break;
      case ModTypeFilter.generic:
        // Ahora solo busca mods marcados explícitamente como 'genericPak'
        mods.retainWhere((mod) => mod.modType == 'genericPak');
        break;
      case ModTypeFilter.replacement:
        // Ahora busca mods marcados explícitamente como 'replacement'
        // (Esto también incluirá los mods antiguos que tenías,
        // una vez que actives el switch en ellos por primera vez).
        mods.retainWhere((mod) => mod.modType == 'replacement');
        break;
      case ModTypeFilter.movies:
        mods.retainWhere((mod) => mod.modType == 'movies');
        break;
      case ModTypeFilter.logicMod:
        mods.retainWhere((mod) => mod.modType == 'logicMod');
        break;
      case ModTypeFilter.all:
      default:
        // No filtrar por tipo
        break;
    }

    // --- 2. APLICA EL FILTRO DE ESTADO (Dropdown) ---
    // Esto ahora filtra SOBRE la lista ya filtrada por tipo.
    switch (_currentFilter) {
      case ModFilter.enabled:
        mods.retainWhere((mod) => mod.isEnabled);
        break;
      case ModFilter.disabled:
        mods.retainWhere((mod) => !mod.isEnabled);
        break;
      case ModFilter.updatesAvailable:
        mods.retainWhere((mod) {
          final updateInfo = _modUpdates[mod.directory.path];
          if (updateInfo == null) return false;

          final updateIdentifier = mod.directory.path + updateInfo['version'];
          return !_ignoredUpdates.contains(updateIdentifier);
        });
        break;
      case ModFilter.all:
      default:
        // No filtrar por estado
        break;
    }

    // --- 3. APLICA EL FILTRO DE BÚSQUEDA ---
    if (_searchQuery.isNotEmpty) {
      mods.retainWhere((mod) {
        final displayTag =
            mod.customFitMeshType ?? mod.fitMeshType ?? l10n.modCategoryOther;
        final query = _searchQuery.toLowerCase();

        final nameMatch = mod.customName.toLowerCase().contains(query);
        final tagMatch = displayTag.toLowerCase().contains(query);
        // Comprueba si el traje reemplazado coincide con la búsqueda
        final outfitMatch = (mod.replacesOutfits != null)
            ? mod.replacesOutfits!.any((outfit) => outfit.toLowerCase().contains(query))
            : false;

        return nameMatch || tagMatch || outfitMatch; // Añade outfitMatch
      });
    }

    // --- 4. APLICA EL ORDENAMIENTO ---
    switch (_currentSort) {
      case ModSort.name:
        mods.sort(
          (a, b) =>
              a.customName.toLowerCase().compareTo(b.customName.toLowerCase()),
        );
        break;
      case ModSort.date:
      default:
        mods.sort((a, b) {
          final dateCompare = b.lastModified.compareTo(a.lastModified);

          if (dateCompare != 0) {
            return dateCompare;
          }
          return a.customName.toLowerCase().compareTo(
            b.customName.toLowerCase(),
          );
        });
        break;
    }
    return mods;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filteredAndSortedMods = _getFilteredAndSortedMods(l10n);

    final cnsUpdateIdentifier = _cnsUpdateInfo != null
        ? 'CNS_' + _cnsUpdateInfo!['version']
        : '';
    final cnsIsIgnored = _ignoredUpdates.contains(cnsUpdateIdentifier);
    final hasEnabledMods = _allMods.any((mod) => mod.isEnabled);
    final hasDisabledMods = _allMods.any((mod) => !mod.isEnabled);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              _cnsVersion != null
                  ? l10n.appTitleWithVersion(_cnsVersion!)
                  : l10n.appTitleNoCns,
            ), // Usará el nuevo texto cuando no haya versión
            if (_cnsUpdateInfo != null && !cnsIsIgnored)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconButton(
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedNotification01,
                    color: Colors.yellowAccent,
                    size: 24.0,
                  ),
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
                  },
                ),
              ),
          ],
        ),
        backgroundColor: const Color(0xFF2a2a2a),
        actions: [
          IconButton(
            icon: const HugeIcon(icon: HugeIcons.strokeRoundedWifiSync, color: Colors.white, size: 24.0),
            tooltip: l10n.checkForUpdates,
            onPressed: _isLoading || _isCheckingForUpdates
                ? null
                : _checkForUpdates,
          ),
          IconButton(
            icon: const HugeIcon(icon: HugeIcons.strokeRoundedSetting07, color: Colors.white, size: 24.0),
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
                    onUninstallUE4SS: () =>
                        _uninstallCoreComponent(isUe4ss: true),
                    onUninstallCNS: () =>
                        _uninstallCoreComponent(isUe4ss: false),
                    // Resto de callbacks
                    onSelectGamePath: _selectGamePathManually,
                    onSelect7zipPath: _select7zipPathManually,
                    onShowApiKeyDialog: _showApiKeyDialog,
                    onManageSkippedVersions: _manageSkippedVersions,
                    onShowLanguageDialog: _showLanguageDialog,
                    onDeleteAllNexusInfo: _deleteAllNexusInfoFiles,
                    onExtractModIds: _extractModIdentifiers,
                    isDeveloperModeEnabled: _developerModeEnabled,
                    initialShowModTypeTags: _showModTypeTags,
                    onShowModTypeTagsChanged: (newValue) async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool(AppPrefs.showModTypeTags, newValue);
                      setState(() {
                        _showModTypeTags = newValue;
                      });
                    },
                    onShowAboutDialog: _showAboutDialog,
                    onRunSelfHealing: _showSelfHealConfirmationDialog,
                    onRunConflictPatcher: _runConflictPatcher,
                  ),
                ),
              );
            },
          ),
        ],
      ),

      // El body del Scaffold ahora es un Stack que contiene
      // el DropTarget (cuerpo principal) Y el nuevo Overlay de vista previa
      body: Stack(
        children: [
          DropTarget(
            onDragDone: (details) async {
              final files = details.files
                  .map((file) => File(file.path))
                  .toList();
              if (files.isNotEmpty) {
                // En lugar de procesar, ahora abre el panel CON los archivos.
                _showInstallationPanel(initialFiles: files);
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
                            if (_modsToInstallPreviewMap.isNotEmpty)
                              const Divider(height: 30, thickness: 1),
                            Expanded(
                              child: _buildModsListSection(
                                l10n.installedMods,
                                filteredAndSortedMods,
                                l10n,
                                hasEnabledMods,
                                hasDisabledMods,
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (_isUpdatingMetadata)
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Text(
                                      _metadataUpdateStatus,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  LinearProgressIndicator(
                                    value: _metadataUpdateProgress,
                                    backgroundColor: Colors.grey[800],
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Colors
                                              .lightBlueAccent, // Color distintivo
                                        ),
                                  ),
                                ],
                              )
                            else if (_isCheckingForUpdates)
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Text(
                                      l10n.statusCheckingUpdates,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  LinearProgressIndicator(
                                    value: null,
                                    backgroundColor: Colors.grey[800],
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Colors.tealAccent,
                                        ),
                                  ),
                                ],
                              )
                            else if (_isLoading)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              )
                            else
                              Text(
                                _statusMessage,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _statusColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
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
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const HugeIcon(
                            icon: HugeIcons.strokeRoundedArchiveArrowDown,
                            size: 80,
                            color: Colors.tealAccent,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            l10n.dropTargetOverlay,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // ++ AÑADIDO: El overlay de vista previa se renderiza aquí ++
          //_buildOutfitPreviewOverlay(),
        ],
      ),
    );
  }

  Widget _buildPathSelectionScreen(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.orangeAccent, size: 64),
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
            icon: const HugeIcon(icon: HugeIcons.strokeRoundedFolder01, color: Colors.white, size: 24.0),
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
          ),
        ],
      ),
    );
  }

  Widget _buildModGridCard(ModInfo modInfo, AppLocalizations l10n) {
  final updateInfo = _modUpdates[modInfo.directory.path];
  final hasUpdate = updateInfo != null;
  final updateIdentifier = hasUpdate ? modInfo.directory.path + updateInfo['version'] : '';
  final isIgnored = _ignoredUpdates.contains(updateIdentifier);
  final isHighlighted = _lastInstalledModNames.contains(p.basename(modInfo.directory.path));
  final displayVersion = modInfo.customVersion ?? modInfo.localVersion;
  final bool isReplacement = modInfo.replacesOutfits != null && modInfo.replacesOutfits!.isNotEmpty;
  final String displayTag = isReplacement
      ? modInfo.replacesOutfits!.first
      : (modInfo.customFitMeshType ?? modInfo.fitMeshType ?? l10n.modCategoryOther);

  void _performSurgicalUpdate(ModInfo? updatedMod) {
    if (updatedMod == null) return;
    final modIndex = _allMods.indexWhere((m) => m.directory.path == updatedMod.directory.path);
    if (modIndex != -1) {
      setState(() {
        _allMods[modIndex] = updatedMod;
      });
    }
  }

  return ModGridCard(
    modInfo: modInfo,
    l10n: l10n,
    thumbnailService: _thumbnailService,
    updateInfo: updateInfo,
    isIgnored: isIgnored,
    isHighlighted: isHighlighted,
    showModTypeTags: _showModTypeTags,
    isLoading: _isLoading,
    onTapDetails: () => _showDetailsPage(modInfo),
    onUpdateAvailableTap: () {
      if (modInfo.nexusId != null) {
        _showUpdateOptionsDialog(
          newVersion: updateInfo!['version'],
          nexusId: modInfo.nexusId!,
          fileId: updateInfo['fileId'],
          uniqueIdentifier: updateIdentifier,
        );
      }
    },
    onEditVersionTap: () async {
      final updatedMod = await EditDialogs.showEditDialog(
        context: context,
        title: l10n.editVersionText,
        label: l10n.customVersionText,
        initialValue: displayVersion ?? '',
        defaultValue: modInfo.localVersion ?? '',
        maxLength: 15,
        onSave: (newValue) => _updateModCustomProperty(modInfo, newVersion: newValue),
      );
      _performSurgicalUpdate(updatedMod);
    },
    onEditTagTap: () async {
      final updatedMod = await EditDialogs.showEditDialog(
        context: context,
        title: l10n.editTagText,
        label: l10n.customTagText,
        initialValue: displayTag,
        defaultValue: modInfo.fitMeshType ?? l10n.modCategoryOther,
        onSave: (newValue) => _updateModCustomProperty(modInfo, newTag: newValue),
      );
      _performSurgicalUpdate(updatedMod);
    },
    onHoverEnter: (position, outfitName) {
      _cursorPosition = position;
      _hoverTimer?.cancel();
      _hoverTimer = Timer(const Duration(milliseconds: 800), () {
        if (mounted) {
          _showPreviewOverlay(context, outfitName, _cursorPosition);
        }
      });
    },
    onHoverMove: (position) => _cursorPosition = position,
    onHoverExit: () => _hidePreviewOverlay(),
    onEnable: _enableMod,
    onDisable: _disableMod,
    onEditNameTap: () async {
      final newName = await EditDialogs.showEditModNameDialog(context, modInfo);
      if (newName != null && newName.trim().isNotEmpty) {
        final updatedMod = await _updateModCustomName(modInfo, newName.trim());
        _performSurgicalUpdate(updatedMod);
      }
    },
    onSetCoverTap: () => _setCustomCover(modInfo),
    onRevertCoverTap: () => _revertToDefaultCover(modInfo),
    onShowFolderTap: () => _showInExplorer(modInfo.directory),
    onShowGalleryTap: () => _showImageGalleryDialog(modInfo),
    onOpenNexusTap: () async {
      if (modInfo.nexusId != null) {
        final url = Uri.parse('https://www.nexusmods.com/stellarblade/mods/${modInfo.nexusId}');
        if (await canLaunchUrl(url)) await launchUrl(url);
      }
    },
    onDeleteTap: () => _deleteModPermanently(modInfo),
  );
}

  Widget _buildModListTile(ModInfo modInfo, AppLocalizations l10n) {
  final isHighlighted = _lastInstalledModNames.contains(p.basename(modInfo.directory.path));
  final updateInfo = _modUpdates[modInfo.directory.path];
  final hasUpdate = updateInfo != null;
  final updateIdentifier = hasUpdate ? modInfo.directory.path + updateInfo['version'] : '';
  final isIgnored = _ignoredUpdates.contains(updateIdentifier);

  void _performSurgicalUpdate(ModInfo? updatedMod) {
    if (updatedMod == null) return;
    final modIndex = _allMods.indexWhere((m) => m.directory.path == updatedMod.directory.path);
    if (modIndex != -1) {
      setState(() {
        _allMods[modIndex] = updatedMod;
      });
    }
  }

  return ModListTile(
    modInfo: modInfo,
    l10n: l10n,
    updateInfo: updateInfo,
    isIgnored: isIgnored,
    isHighlighted: isHighlighted,
    isLoading: _isLoading,
    onRepairedInfoTap: _showRepairedModInfoDialog,
    onDeleteTap: () => _deleteModPermanently(modInfo),
    onUpdateAvailableTap: () {
      if (modInfo.nexusId != null) {
        _showUpdateOptionsDialog(
          newVersion: updateInfo!['version'],
          nexusId: modInfo.nexusId!,
          fileId: updateInfo['fileId'],
          uniqueIdentifier: updateIdentifier,
        );
      }
    },
    onEditNameTap: () async {
      final newName = await EditDialogs.showEditModNameDialog(context, modInfo);
      if (newName != null && newName.trim().isNotEmpty) {
        final updatedMod = await _updateModCustomName(modInfo, newName.trim());
        _performSurgicalUpdate(updatedMod);
      }
    },
    onShowFolderTap: () => _showInExplorer(modInfo.directory),
    onShowGalleryTap: () => _showImageGalleryDialog(modInfo),
    onOpenNexusTap: () async {
      if (modInfo.nexusId != null) {
        final url = Uri.parse('https://www.nexusmods.com/stellarblade/mods/${modInfo.nexusId}');
        if (await canLaunchUrl(url)) await launchUrl(url);
      }
    },
    onEnable: _enableMod,
    onDisable: _disableMod,
  );
}

  Widget _buildModsListSection(
    String title,
    List<ModInfo> mods,
    AppLocalizations l10n,
    bool hasEnabledMods,
    bool hasDisabledMods,
  ) {
    // 1. Calcula los estados basándose en la lista 'mods' (la vista actual)
    final bool hasEnabledModsInView = mods.any((mod) => mod.isEnabled);
    final bool hasDisabledModsInView = mods.any((mod) => !mod.isEnabled);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const HugeIcon(icon: HugeIcons.strokeRoundedAddCircle, color: Colors.white, size: 24.0),
              label: Text(
                l10n.installNewMod,
              ), // Asegúrate de tener esta traducción
              onPressed:
                  _showInstallationPanel, // Este método lo crearemos a continuación
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 16,
                ),
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: 0),
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
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.3),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16,
                      ),
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
                  isSelected: [
                    _viewMode == ModListViewMode.grid,
                    _viewMode == ModListViewMode.list,
                  ],
                  onPressed: (index) async {
                    final newMode = index == 0
                        ? ModListViewMode.grid
                        : ModListViewMode.list;
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setInt(AppPrefs.viewMode, newMode.index);
                    setState(() => _viewMode = newMode);
                  },
                  borderRadius: BorderRadius.circular(8),
                  constraints: const BoxConstraints(
                    minHeight: 36,
                    minWidth: 36,
                  ),
                  children: [
                    Tooltip(
                      message: l10n.viewTypeGrid,
                      child: HugeIcon(icon: HugeIcons.strokeRoundedLayoutGrid, size: 20),
                    ),
                    Tooltip(
                      message: l10n.viewTypeList,
                      child: HugeIcon(icon: HugeIcons.strokeRoundedLeftToRightListBullet, size: 20),
                    ),
                  ],
                ),
                PopupMenuButton<ModFilter>(
                  icon: const HugeIcon(icon: HugeIcons.strokeRoundedFilter, size: 20),
                  tooltip: l10n.filterBy,
                  onSelected: (ModFilter result) async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setInt(AppPrefs.filterMode, result.index);
                    setState(() {
                      _currentFilter = result;
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    // ++ LISTA SIMPLIFICADA ++
                    final filterOptions = [
                      {'value': ModFilter.all, 'text': l10n.filterAll},
                      {'value': ModFilter.enabled, 'text': l10n.filterEnabled},
                      {
                        'value': ModFilter.disabled,
                        'text': l10n.filterDisabled,
                      },
                      {
                        'value': ModFilter.updatesAvailable,
                        'text': l10n.filterUpdatesAvailable,
                      },
                    ];

                    // ++ CONSTRUCTOR SIMPLIFICADO ++
                    return filterOptions.map((option) {
                      return PopupMenuItem<ModFilter>(
                        value: option['value'] as ModFilter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(option['text'] as String),
                            if (_currentFilter == option['value'])
                              const HugeIcon(icon: HugeIcons.strokeRoundedTick02, color: Colors.tealAccent),
                          ],
                        ),
                      );
                    }).toList();
                  },
                ),
                PopupMenuButton<ModSort>(
                  icon: const HugeIcon(icon: HugeIcons.strokeRoundedSorting01, size: 20),
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
                              const HugeIcon(icon: HugeIcons.strokeRoundedTick02, color: Colors.tealAccent),
                          ],
                        ),
                      );
                    }).toList();
                  },
                ),
                IconButton(
                  icon: const HugeIcon(icon: HugeIcons.strokeRoundedFolderSymlink, size: 20),
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_finalModsPath != null) {
                            _showInExplorer(Directory(_finalModsPath!));
                          }
                        },
                  tooltip: l10n.openModsFolder,
                ),
                IconButton(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedPower,
                    // ++ MODIFICADO: Usa el booleano de la vista actual
                    color: (_isLoading || !hasDisabledModsInView)
                        ? Colors.greenAccent.withOpacity(0.4)
                        : Colors.greenAccent,
                  ),
                  // ++ MODIFICADO: Usa el booleano y pasa la lista 'mods'
                  onPressed: _isLoading || !hasDisabledModsInView
                      ? null
                      : () => _enableAllMods(mods),
                  tooltip: l10n.enableAllModsTooltip,
                ),
                IconButton(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedPowerOff,
                    // ++ MODIFICADO: Usa el booleano de la vista actual
                    color: (_isLoading || !hasEnabledModsInView)
                        ? Colors.orangeAccent.withOpacity(0.4)
                        : Colors.orangeAccent,
                  ),
                  // ++ MODIFICADO: Usa el booleano y pasa la lista 'mods'
                  onPressed: _isLoading || !hasEnabledModsInView
                      ? null
                      : () => _disableAllMods(mods),
                  tooltip: l10n.disableAllModsTooltip,
                ),
                IconButton(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedDelete04,
                    // ++ MODIFICADO: Usa el booleano de la vista actual
                    color: (_isLoading || !hasDisabledModsInView)
                        ? Colors.redAccent.withOpacity(0.4)
                        : Colors.redAccent,
                  ),
                  // ++ MODIFICADO: Usa el booleano y pasa la lista 'mods'
                  onPressed: _isLoading || !hasDisabledModsInView
                      ? null
                      : () => _deleteDisabledMods(mods),
                  tooltip: l10n.deleteAllModsTooltip,
                ),
                IconButton(
                  icon: const HugeIcon(icon: HugeIcons.strokeRoundedRefresh01),
                  onPressed: _isLoading
                      ? null
                      : () => _loadAllMods(clearHighlight: true),
                  tooltip: l10n.refreshList,
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Container(
            width: double.infinity, // Ocupa todo el ancho
            alignment: Alignment.center, // Centra los botones
            child: SingleChildScrollView(
              // Permite scroll horizontal en ventanas pequeñas
              scrollDirection: Axis.horizontal,
              child: ToggleButtons(
                isSelected: ModTypeFilter.values
                    .map((type) => type == _currentModTypeFilter)
                    .toList(),
                onPressed: (index) async {
                  final newTypeFilter = ModTypeFilter.values[index];
                  final prefs = await SharedPreferences.getInstance();
                  // Guardamos la nueva preferencia
                  await prefs.setInt(
                    AppPrefs.modTypeFilterMode,
                    newTypeFilter.index,
                  );
                  setState(() {
                    _currentModTypeFilter = newTypeFilter;
                  });
                },
                borderRadius: BorderRadius.circular(8),
                constraints: const BoxConstraints(minHeight: 36), // Altura fija
                children: [
                  _buildNavButton(l10n.filterAll),
                  _buildNavButton(l10n.modTypeCNS),
                  _buildNavButton(l10n.modTypeReplacement),
                  _buildNavButton(l10n.modTypeMovies),
                  _buildNavButton(l10n.modTypeLogic),
                  _buildNavButton(l10n.modTypeGeneric),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: mods.isEmpty
              ? Center(
                  child: Text(
                    l10n.noModsFound,
                    style: const TextStyle(color: Colors.grey),
                  ),
                )
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _viewMode == ModListViewMode.grid
                      ? GridView.builder(
                          key: const ValueKey('grid'),
                          //cacheExtent:
                              //4000.0, // Mejora el rendimiento al hacer scroll
                          padding: const EdgeInsets.all(4),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
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
                          //cacheExtent:
                              //4000.0, // Mejora el rendimiento al hacer scroll
                          itemCount: mods.length,
                          itemBuilder: (context, index) {
                            return _buildModListTile(mods[index], l10n);
                          },
                        ),
                ),
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
      final Alignment? alignment = await EditDialogs.showCoverAlignmentDialog(context,imageFile);

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

  Future<void> _revertToDefaultCover(ModInfo mod) async {
    if (mod.customCoverPath == null || mod.customCoverPath!.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final infoFile = File(p.join(mod.directory.path, 'nexus_info.json'));
      if (!await infoFile.exists()) {
        throw Exception("nexus_info.json not found.");
      }

      // --- START: NEW SMART REVERT LOGIC ---

      // 1. Delete the current custom cover file, but ONLY if it's NOT the cached nexus file.
      final currentCoverFile = File(
        p.join(mod.directory.path, mod.customCoverPath!),
      );
      if (!p.basename(currentCoverFile.path).startsWith('_nexus_cover')) {
        if (await currentCoverFile.exists()) {
          await currentCoverFile.delete();
        }
      }

      // 2. Read the JSON data.
      Map<String, dynamic> data = json.decode(await infoFile.readAsString());

      // 3. Check if a cached nexus cover exists in the mod's folder.
      String? cachedNexusCoverName;
      await for (final file in mod.directory.list()) {
        if (file is File && p.basename(file.path).startsWith('_nexus_cover')) {
          cachedNexusCoverName = p.basename(file.path);
          break;
        }
      }

      // 4. Update the JSON based on whether a cached cover was found.
      if (cachedNexusCoverName != null) {
        // A cached version exists, so point the custom path to it.
        data['customCoverPath'] = cachedNexusCoverName;
        // Also set a default center alignment for it.
        data['customCoverAlignmentX'] = 0.0;
        data['customCoverAlignmentY'] = 0.0;
      } else {
        // No cached version was found, so remove the custom path and alignment completely.
        // This will force the UI to fall back to the internet URL.
        data.remove('customCoverPath');
        data.remove('customCoverAlignmentX');
        data.remove('customCoverAlignmentY');
      }

      // --- END: NEW SMART REVERT LOGIC ---

      // 5. Write the updated data back to the file.
      final encoder = JsonEncoder.withIndent('  ');
      await infoFile.writeAsString(encoder.convert(data));

      // 6. Reload the mods list to reflect the changes in the UI.
      await _loadAllMods(clearHighlight: false);
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

  Future<void> _showDetailsPage(ModInfo modInfo) async {
    void onPanelClosed(ModInfo? updatedModInfo) {
      if (updatedModInfo != null) {
        // Usamos addPostFrameCallback para posponer la actualización hasta que el árbol de widgets
        // esté desbloqueado (después de que el panel se haya cerrado por completo).
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted)
            return; // Buena práctica: verificar si el widget aún existe.

          final modIndex = _allMods.indexWhere(
            (mod) => mod.directory.path == updatedModInfo.directory.path,
          );

          if (modIndex != -1) {
            setState(() {
              _allMods[modIndex] = updatedModInfo;
            });
          }
        });
      }
    }

    // ++ INICIO DE LA MODIFICACIÓN ++
    // Obtenemos la información de actualización y el estado "ignorado" para este mod específico.
    final updateInfo = _modUpdates[modInfo.directory.path];
    final hasUpdate = updateInfo != null;
    final updateIdentifier = hasUpdate
        ? modInfo.directory.path + (updateInfo['version'] as String)
        : '';
    final isIgnored = _ignoredUpdates.contains(updateIdentifier);
    // ++ FIN DE LA MODIFICACIÓN ++

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ModDetailsPanel(
        initialModInfo: modInfo,
        thumbnailService: _thumbnailService,
        onUpdateDetails: _updateModDetails,
        onShowInExplorer: _showInExplorer,
        onShowImageGallery: _showImageGalleryDialog,
        onShowGeneralEditDialog: EditDialogs.showGeneralEditDialog,
        onPanelClosed: onPanelClosed,

        // ++ INICIO DE LA MODIFICACIÓN ++
        // Pasamos la información de la actualización y la función del diálogo al panel.
        updateInfo: updateInfo,
        isIgnored: isIgnored,
        onShowUpdateDialog: _showUpdateOptionsDialog,
        // ++ FIN DE LA MODIFICACIÓN ++
      ),
    );
  }

  /// Guarda una propiedad personalizada (versión o etiqueta) en el JSON y actualiza el estado.
  Future<ModInfo?> _updateModCustomProperty(
    ModInfo mod, {
    String? newVersion,
    String? newTag,
  }) async {
    try {
      final infoFile = File(p.join(mod.directory.path, 'nexus_info.json'));
      Map<String, dynamic> data = {};
      if (await infoFile.exists()) {
        final content = await infoFile.readAsString();
        if (content.isNotEmpty) data = json.decode(content);
      }

      if (newVersion != null) {
        if (newVersion.isEmpty || newVersion == mod.localVersion) {
          data.remove('customVersion');
        } else {
          data['customVersion'] = newVersion;
        }
      }

      if (newTag != null) {
        if (newTag.isEmpty || newTag == mod.fitMeshType) {
          data.remove('customFitMeshType');
        } else {
          data['customFitMeshType'] = newTag;
        }
      }

      final encoder = JsonEncoder.withIndent('  ');
      await infoFile.writeAsString(encoder.convert(data));

      // Reconstruye manualmente el objeto para asegurar que los nulos se apliquen
      return ModInfo(
        directory: mod.directory,
        nexusId: mod.nexusId,
        localVersion: mod.localVersion,
        lastModified: mod.lastModified,
        installDate: mod.installDate,
        isEnabled: mod.isEnabled,
        origin: mod.origin,
        displayName: mod.displayName,
        customName: mod.customName,
        gallery: mod.gallery,
        fitMeshType: mod.fitMeshType,
        customCoverPath: mod.customCoverPath,
        customCoverAlignment: mod.customCoverAlignment,
        customCoverLastModified: mod.customCoverLastModified,
        // Asigna directamente desde el mapa 'data' para reflejar los valores eliminados
        customVersion: data['customVersion'],
        customFitMeshType: data['customFitMeshType'],
        summary: mod.summary,
        customSummary: mod.customSummary,
        description: mod.description,
        customDescription: data['customDescription'],
        author: mod.author,
        customAuthor: mod.customAuthor,
        userNotes: mod.userNotes,
        sourceUrl: mod.sourceUrl,
        customSourceUrl: mod.customSourceUrl,
      );
    } catch (e) {
      print('Error updating custom property: $e');
      return null;
    }
  }

  String? _extractNexusIdFromUrl(String url) {
    try {
      // Regex para encontrar ".../stellarblade/mods/123"
      final regex = RegExp(r'nexusmods\.com/stellarblade/mods/(\d+)');
      final match = regex.firstMatch(url);
      // Devuelve el primer grupo capturado (el ID) si hay coincidencia.
      return match?.group(1);
    } catch (e) {
      print("Error al analizar la URL de Nexus: $e");
      return null;
    }
  }

  /// Actualiza múltiples detalles del mod en el archivo JSON y devuelve un ModInfo actualizado.
  Future<ModInfo?> _updateModDetails(
    ModInfo mod,
    Map<String, dynamic> newData,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      Directory modDirectory = mod.directory;

      // Prepara la compatibilidad para recibir listas de la futura UI
      if (newData.containsKey('replacesOutfit') || newData.containsKey('replacesOutfits')) {
        List<String> newOutfits = [];
        if (newData.containsKey('replacesOutfits') && newData['replacesOutfits'] != null) {
          newOutfits = List<String>.from(newData['replacesOutfits']);
        } else if (newData.containsKey('replacesOutfit') && newData['replacesOutfit'] != null) {
          final String single = newData['replacesOutfit'] as String;
          if (single.isNotEmpty) newOutfits.add(single);
        }

        if (newOutfits.isNotEmpty) {
          ModInfo? conflictingMod;
          List<String> overlappingOutfits = [];
          
          try {
            for (final otherMod in _allMods) {
              if (otherMod.isEnabled && otherMod.directory.path != mod.directory.path) {
                final otherOutfits = otherMod.replacesOutfits ?? [];
                // Compara si la nueva lista de trajes choca con algún mod habilitado
                final intersection = newOutfits.where((o) => otherOutfits.contains(o)).toList();
                
                if (intersection.isNotEmpty) {
                  conflictingMod = otherMod;
                  overlappingOutfits = intersection;
                  break;
                }
              }
            }
          } catch (e) {
            conflictingMod = null;
          }

          if (conflictingMod != null && mod.isEnabled) {
            final String outfitName = overlappingOutfits.join(', ');
            final String modName = conflictingMod.customName;

            // Obtenemos el texto completo de la localización
            final String fullString = l10n.dialogContentOutfitConflict(
              outfitName,
              modName,
            );

            // Dividimos el texto usando los nombres como separadores
            final List<String> parts = fullString.split(outfitName);
            final String part1 = parts.isNotEmpty ? parts[0] : "";

            String part2 = "";
            String part3 = "";

            if (parts.length > 1) {
              // Buscamos el nombre del mod en la segunda parte del texto
              final List<String> parts2 = parts[1].split(modName);
              part2 = parts2.isNotEmpty ? parts2[0] : "";
              if (parts2.length > 1) {
                part3 = parts2[1];
              }
            }

            final bool? forceActivate = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                backgroundColor: const Color(0xFF2a2a2a),
                title: Text(l10n.dialogTitleOutfitConflict),

                // Reemplazamos el 'content: Text(...)' por 'content: RichText(...)'
                content: RichText(
                  text: TextSpan(
                    // Usar el estilo de texto por defecto del diálogo
                    style:
                        Theme.of(context).dialogTheme.contentTextStyle ??
                        const TextStyle(color: Colors.white, height: 1.5),
                    children: [
                      // Parte 1 del texto
                      TextSpan(text: part1),

                      // Widget 1: El nombre del traje (interactivo)
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: MouseRegion(
                          onEnter: (event) {
                            _cursorPosition = event.position;
                            _hoverTimer?.cancel();
                            _hoverTimer = Timer(
                              const Duration(milliseconds: 800),
                              () {
                                if (mounted) {
                                  _showPreviewOverlay(
                                    context,
                                    outfitName, // El nombre del traje
                                    _cursorPosition,
                                  );
                                }
                              },
                            );
                          },
                          onExit: (event) => _hidePreviewOverlay(),
                          onHover: (event) => _cursorPosition = event.position,
                          child: Text(
                            outfitName, // El nombre resaltado
                            style: const TextStyle(
                              color: Colors.tealAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Parte 2 del texto
                      TextSpan(text: part2),

                      // Widget 2: El nombre del mod (interactivo)
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: InkWell(
                          onTap: () {
                            // ¡YA NO CERRAMOS LA ALERTA!
                            // Abre el panel de detalles del mod en conflicto
                            _showDetailsPage(conflictingMod!);
                          },
                          child: Text(
                            modName, // El nombre resaltado
                            style: const TextStyle(
                              color: Colors.yellowAccent,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),

                      // Parte 3 del texto
                      TextSpan(text: part3),
                    ],
                  ),
                ),

                actions: [
                  TextButton(
                    onPressed: () {
                      _hidePreviewOverlay(); // Oculta la vista previa si está visible
                      Navigator.of(context).pop(false);
                    },
                    child: Text(l10n.dialogActionCancel),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _hidePreviewOverlay(); // Oculta la vista previa si está visible
                      Navigator.of(context).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent,
                      foregroundColor: Colors.black,
                    ),
                    child: Text(
                      l10n.dialogActionActivateAndDisable,
                    ), // Reutilizamos el l10n
                  ),
                ],
              ),
            );

            // 4. Si el usuario canceló, detenemos el guardado
            if (forceActivate != true) {
              return null; // Devuelve null para indicar que no se guardó nada
            }

            // 5. Si el usuario confirmó, desactiva el mod conflictivo
            await _disableMod(conflictingMod);
          }
        }
      }

      final infoFile = File(p.join(modDirectory.path, 'nexus_info.json'));
      Map<String, dynamic> data = {};
      if (await infoFile.exists()) {
        final content = await infoFile.readAsString();
        if (content.isNotEmpty) data = json.decode(content);
      }

      String?
      newNexusId; // Para almacenar un nuevo ID y usarlo para cachear la miniatura
      if (newData.containsKey('customSourceUrl')) {
        final newUrl = newData['customSourceUrl'] as String;
        final potentialNexusId = _extractNexusIdFromUrl(newUrl);
        final oldNexusId = data['nexusId'] as String?;

        // Comprueba si es una URL de Nexus válida, nueva y diferente a la que ya teníamos
        if (potentialNexusId != null && potentialNexusId != oldNexusId) {
          print(
            'Nuevo Nexus ID $potentialNexusId detectado. Obteniendo metadatos...',
          );
          // Si es así, obtenemos los datos de la API
          final nexusData = await NexusApiService.fetchNexusModData(potentialNexusId, _apiKey);

          if (nexusData != null) {
            newNexusId =
                potentialNexusId; // Guardamos el ID para cachear la miniatura más tarde

            // Rellenamos el mapa 'data' con los nuevos metadatos
            data['nexusId'] = newNexusId;
            data['gallery'] = nexusData['gallery'];
            data['summary'] = nexusData['summary'];
            data['author'] = nexusData['author'];
            data['description'] = nexusData['description'];
            data['sourceUrl'] = newUrl; // Establece la URL principal

            // Limpiamos todos los campos personalizados que serían anulados por estos nuevos datos
            data.remove('customSourceUrl');
            data.remove('customSummary');
            data.remove('customAuthor');
            data.remove('customDescription');

            // También eliminamos las claves de 'newData' para que no se procesen de nuevo más abajo
            newData.remove('customSourceUrl');
            newData.remove(
              'author',
            ); // El diálogo 'General Edit' también envía 'author'
            // (No es necesario eliminar 'summary' o 'customDescription' ya que vienen de otros diálogos)

            print('Metadatos obtenidos y aplicados para $newNexusId.');
          }
        }
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
        if (value.isEmpty || value == mod.displayName)
          data.remove('customName');
        else
          data['customName'] = value;
      }
      if (newData.containsKey('author')) {
        final value = newData['author'] as String;
        if (value.isEmpty || value == mod.author)
          data.remove('customAuthor');
        else
          data['customAuthor'] = value;
      }

      if (newData.containsKey('summary')) {
        final newCustomSummary = newData['summary'] as String;
        if (newCustomSummary.isEmpty || newCustomSummary == mod.summary) {
          data.remove('customSummary');
        } else {
          data['customSummary'] = newCustomSummary;
        }
      }

      if (newData.containsKey('customDescription')) {
        final newCustomDescription = newData['customDescription'] as String;
        // Si la nueva descripción es igual a la original (sin HTML), la eliminamos para no guardar datos redundantes.
        final originalDescriptionStripped = TextUtils.stripHtml(mod.description);
        if (newCustomDescription.isEmpty ||
            newCustomDescription == originalDescriptionStripped) {
          data.remove('customDescription');
        } else {
          data['customDescription'] = newCustomDescription;
        }
      }

      if (newData.containsKey('userNotes'))
        data['userNotes'] = newData['userNotes'];

      if (newData.containsKey('modType')) {
        data['modType'] = newData['modType'];
      }

      if (newData.containsKey('replacesOutfits') || newData.containsKey('replacesOutfit')) {
        List<String>? outList;
        if (newData.containsKey('replacesOutfits')) {
          outList = newData['replacesOutfits'] as List<String>?;
        } else {
          final val = newData['replacesOutfit'] as String?;
          outList = (val != null && val.isNotEmpty) ? [val] : null;
        }

        if (outList == null || outList.isEmpty) {
          data.remove('replacesOutfits');
          data.remove('replacesOutfit'); // Limpiamos la clave vieja
        } else {
          data['replacesOutfits'] = outList;
          data.remove('replacesOutfit'); // Nos aseguramos de no dejar basura
        }
      }

      if (newData.containsKey('customSourceUrl')) {
        final value = newData['customSourceUrl'] as String;
        if (value.isEmpty || value == mod.sourceUrl)
          data.remove('customSourceUrl');
        else
          data['customSourceUrl'] = value;
      }

      // Añade la lógica para manejar la versión y la etiqueta personalizadas.
      if (newData.containsKey('customVersion')) {
        final value = newData['customVersion'] as String;
        if (value.isEmpty || value == mod.localVersion) {
          data.remove('customVersion');
        } else {
          data['customVersion'] = value;
        }
      }

      if (newData.containsKey('customFitMeshType')) {
        final value = newData['customFitMeshType'] as String;
        if (value.isEmpty || value == mod.fitMeshType) {
          data.remove('customFitMeshType');
        } else {
          data['customFitMeshType'] = value;
        }
      }

      final encoder = JsonEncoder.withIndent('  ');
      await infoFile.writeAsString(encoder.convert(data));

      // --- LÍNEA ELIMINADA ---
      // await _loadAllMods(clearHighlight: false);  <-- ESTO CAUSABA EL PARPADEO
      if (newNexusId != null) {
        await ModManagerService.cacheNexusThumbnail(apiKey: _apiKey,
          modDirectory: modDirectory,
          nexusId: newNexusId,
        );
      }
      // Ahora, construimos y devolvemos un nuevo objeto ModInfo con los datos actualizados
      // para que el panel pueda refrescar su propia UI sin afectar el fondo.
      return ModInfo(
        directory: modDirectory,
        isEnabled: mod.isEnabled,
        lastModified: mod.lastModified,
        installDate: mod.installDate,
        displayName: data['displayName'] ?? mod.displayName,
        customName:
            data['customName'] ?? data['displayName'] ?? mod.displayName,
        nexusId: data['nexusId'] ?? mod.nexusId,
        localVersion: data['installedVersion'] ?? mod.localVersion,
        customVersion: data['customVersion'],
        origin: data['origin'] ?? mod.origin,
        gallery: data['gallery'] ?? mod.gallery,
        modType: data['modType'] ?? mod.modType,
        fitMeshType: data['fitMeshType'] ?? mod.fitMeshType,
        customFitMeshType: data['customFitMeshType'],
        customCoverPath: data['customCoverPath'],
        customCoverAlignment: data.containsKey('customCoverAlignmentX')
            ? Alignment(
                data['customCoverAlignmentX'],
                data['customCoverAlignmentY'],
              )
            : null,
        customCoverLastModified: data.containsKey('customCoverPath')
            ? await File(
                p.join(modDirectory.path, data['customCoverPath']),
              ).lastModified()
            : null,
        summary: data['summary'] ?? mod.summary,
        customSummary: data['customSummary'],
        description: data['description'] ?? mod.description,
        customDescription: data['customDescription'],
        author: data['author'] ?? mod.author,
        customAuthor: data['customAuthor'],
        userNotes: data['userNotes'],
        sourceUrl: data['sourceUrl'] ?? mod.sourceUrl,
        customSourceUrl: data['customSourceUrl'],
        replacesOutfits: data['replacesOutfits'] != null ? List<String>.from(data['replacesOutfits']) : null,
      );
    } catch (e) {
      print('Error updating mod details: $e');
      final l10n = AppLocalizations.of(context)!;
      if (mounted) {
        NotificationService.instance.show(
          context: context,
          type: NotificationType.error,
          title: l10n.errorSavingChanges,
          description: e.toString(),
        );
      }
      return null;
    }
  }

  /// Displays a confirmation dialog and then proceeds to delete all nexus_info.json files.
  Future<void> _deleteAllNexusInfoFiles() async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: Text(l10n.devConfirmDeleteTitle),
        content: Text(l10n.devConfirmDeleteDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.dialogActionCancel),
          ),
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
    int deleteCount = 0;
    try {
      for (final mod in _allMods) {
        final infoFile = File(p.join(mod.directory.path, 'nexus_info.json'));
        if (await infoFile.exists()) {
          try {
            await infoFile.delete();
            deleteCount++;
          } catch (e) {
            print('Could not delete nexus_info.json for ${mod.customName}: $e');
          }
        }
      }

      if (mounted) {
        NotificationService.instance.show(
          context: context,
          type: NotificationType.success,
          title: l10n.devDeleteSuccessTitle,
          description: l10n.devDeleteSuccessDesc(deleteCount),
        );
      }
    } catch (e) {
      if (mounted) {
        NotificationService.instance.show(
          context: context,
          type: NotificationType.error,
          title: l10n.errorDialogTitle,
          description: e.toString(),
        );
      }
    } finally {
      await _loadAllMods();
      setState(() => _isLoading = false);
    }
  }

  /// Extracts mod identifiers to a JSON file on the user's desktop.
  Future<void> _extractModIdentifiers() async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: Text(l10n.devConfirmExtractTitle),
        content: Text(l10n.devConfirmExtractDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.dialogActionCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.tealAccent),
            child: Text(l10n.devExtractAction),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      final Map<String, dynamic> extractedData = {};
      for (final mod in _allMods) {
        final infoFile = File(p.join(mod.directory.path, 'nexus_info.json'));
        if (await infoFile.exists()) {
          try {
            final content = await infoFile.readAsString();
            final data = json.decode(content);
            final displayName = data['displayName'] as String?;
            final nexusId = data['nexusId'] as String?;

            if (displayName != null &&
                nexusId != null &&
                displayName.isNotEmpty &&
                nexusId.isNotEmpty) {
              extractedData[displayName] = {'nexusId': nexusId};
            }
          } catch (e) {
            print(
              'Could not parse nexus_info.json for ${mod.customName}, skipping.',
            );
          }
        }
      }

      if (extractedData.isEmpty) {
        if (mounted) {
          NotificationService.instance.show(
            context: context,
            type: NotificationType.info,
            title: l10n.devExtractNoData,
          );
        }
        return;
      }

      String? homePath;
      if (Platform.isWindows) {
        homePath = Platform.environment['USERPROFILE'];
      } else if (Platform.isLinux || Platform.isMacOS) {
        homePath = Platform.environment['HOME'];
      }

      if (homePath == null) {
        throw Exception(
          'Could not find the home directory environment variable.',
        );
      }

      final desktopDir = Directory(p.join(homePath, 'Desktop'));
      if (!await desktopDir.exists()) {
        if (mounted) {
          NotificationService.instance.show(
            context: context,
            type: NotificationType.error,
            title: l10n.devExtractDesktopNotFound,
          );
        }
        return;
      }

      final outputFile = File(p.join(desktopDir.path, 'ID Mods.json'));

      final encoder = JsonEncoder.withIndent('  ');
      await outputFile.writeAsString(encoder.convert(extractedData));

      if (mounted) {
        NotificationService.instance.show(
          context: context,
          type: NotificationType.success,
          title: l10n.devExtractSuccessTitle,
          description: l10n.devExtractSuccessDesc(outputFile.path),
        );
      }
    } catch (e) {
      if (mounted) {
        NotificationService.instance.show(
          context: context,
          type: NotificationType.error,
          title: l10n.errorDialogTitle,
          description: e.toString(),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Widget auxiliar para dar padding uniforme a los botones de navegación
  Widget _buildNavButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(text),
    );
  }

  /*/ ++ AÑADIDO: Función para construir el overlay de vista previa del traje ++
  Widget _buildOutfitPreviewOverlay() {
    return ValueListenableBuilder<String?>(
      valueListenable: _hoveredOutfitNotifier,
      builder: (context, outfitName, child) {
        // Usa AnimatedOpacity para una aparición/desaparición suave
        return AnimatedOpacity(
          opacity: outfitName != null ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          // Si no hay outfit, no renderiza nada
          child: (outfitName == null)
              ? const SizedBox.shrink()
              // IgnorePointer evita que el overlay bloquee clics
              : IgnorePointer(
                  child: Align(
                    // Posiciona el overlay en la esquina inferior izquierda
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      // Tamaño fijo para la vista previa
                      width: 210, // Proporción 3:4.5 (como la tarjeta)
                      height: 315,
                      margin: const EdgeInsets.all(24), // Margen desde la esquina
                      decoration: BoxDecoration(
                        color: const Color(0xFF2a2a2a),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.tealAccent, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Column(
                          children: [
                            // La imagen del traje
                            Expanded(
                              child: Image.asset(
                                _generateOutfitImagePath(outfitName),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Center(
                                  child: Icon(
                                    Icons.hide_image_outlined,
                                    color: Colors.grey[700],
                                    size: 50,
                                  ),
                                ),
                              ),
                            ),
                            // El nombre del traje
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                outfitName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }*/

  /// Muestra el overlay de vista previa del traje en la posición del cursor.
  void _showPreviewOverlay(
    BuildContext context,
    String outfitName,
    Offset position,
  ) {
    // Oculta cualquier overlay anterior
    _hidePreviewOverlay();

    _previewOverlay = OverlayEntry(
      builder: (context) => Positioned(
        // Posiciona el overlay ligeramente abajo y a la derecha del cursor
        // para que el cursor no lo tape.
        left: position.dx - 50,
        top: position.dy - 220,
        child: IgnorePointer(
          // Evita que el overlay bloquee clics
          child: Opacity(
            opacity: 1, // 100% de opacidad (totalmente visible)
            child: SizedBox(
              // Tamaño de la vista previa (sin borde)
              width: 100,
              height: 211,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0), // Un leve redondeo
                child: Image.asset(
                  _generateOutfitImagePath(
                    outfitName,
                  ), // Reutiliza la función existente
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    // Placeholder en caso de error
                    color: Colors.black.withOpacity(0.5),
                    child: const HugeIcon(
                      icon: HugeIcons.strokeRoundedImageDelete02,
                      color: Colors.grey,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Inserta el overlay en la pantalla
    if (mounted) {
      Overlay.of(context).insert(_previewOverlay!);
    }
  }

  /// Oculta y limpia el temporizador y el overlay de vista previa.
  void _hidePreviewOverlay() {
    _hoverTimer?.cancel(); // Cancela el temporizador si está activo
    _previewOverlay?.remove(); // Elimina el overlay de la pantalla
    _previewOverlay = null; // Limpia la referencia
  }
}

class NexusHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        // Permitir la conexión aunque el certificado parezca expirado
        // en el SO del usuario, SOLO si el host pertenece a Nexus Mods.
        if (host.contains('nexusmods.com')) {
          return true;
        }
        return false; // Rechazar para cualquier otro dominio por seguridad
      };
  }
}