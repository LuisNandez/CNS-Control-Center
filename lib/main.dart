// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures, no_leading_underscores_for_local_identifiers, constant_pattern_never_matches_value_type, unreachable_switch_default, non_constant_identifier_names, use_build_context_synchronously, deprecated_member_use, prefer_interpolation_to_compose_strings, control_flow_in_finally

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
import 'package:flutter/gestures.dart';
import 'mod_classifier_service.dart';
import 'outfit_data.dart';
import 'dart:async';

class AppPrefs {
  static const String languageCode = 'languageCode';
  static const String gameRootPath = 'gameRootPath';
  static const String sevenZipPath = 'sevenZipPath';
  static const String nexusApiKey = 'nexusApiKey';
  static const String skippedVersions = 'skippedVersions';
  static const String filterMode = 'filterMode';
  static const String modTypeFilterMode = 'modTypeFilterMode';
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
  final String displayName;
  String customName;
  final List<dynamic>?
  gallery;
  final String? fitMeshType;
  final String? modType;
  final String? customCoverPath;
  final Alignment? customCoverAlignment;
  final DateTime? customCoverLastModified;
  final String? customVersion;
  final String? customFitMeshType;
  String? summary;
  String? description;
  final String? customSummary;
  final String? customDescription;
  final String? author;
  final String? customAuthor;
  String? userNotes;
  final String? sourceUrl;
  final String? customSourceUrl;
  final String? replacesOutfit;

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
    this.modType,
    this.customCoverPath,
    this.customCoverAlignment,
    this.customCoverLastModified,
    this.customVersion,
    this.customFitMeshType,
    this.summary,
    this.customSummary,
    this.description,
    this.customDescription,
    this.author,
    this.customAuthor,
    this.userNotes,
    this.sourceUrl,
    this.customSourceUrl,
    this.replacesOutfit,
  });

  ModInfo copyWith({
    Directory? directory,
    String? nexusId,
    String? localVersion,
    DateTime? lastModified,
    DateTime? installDate,
    bool? isEnabled,
    String? origin,
    String? displayName,
    String? customName,
    List<dynamic>? gallery,
    String? fitMeshType,
    String? modType,
    String? customCoverPath,
    Alignment? customCoverAlignment,
    DateTime? customCoverLastModified,
    String? customVersion,
    String? customFitMeshType,
    String? summary,
    String? customSummary,
    String? description,
    String? customDescription,
    String? author,
    String? customAuthor,
    String? userNotes,
    String? sourceUrl,
    String? customSourceUrl,
    String? replacesOutfit,
  }) {
    return ModInfo(
      directory: directory ?? this.directory,
      nexusId: nexusId ?? this.nexusId,
      localVersion: localVersion ?? this.localVersion,
      lastModified: lastModified ?? this.lastModified,
      installDate: installDate ?? this.installDate,
      isEnabled: isEnabled ?? this.isEnabled,
      origin: origin ?? this.origin,
      displayName: displayName ?? this.displayName,
      customName: customName ?? this.customName,
      gallery: gallery ?? this.gallery,
      fitMeshType: fitMeshType ?? this.fitMeshType,
      modType: modType ?? this.modType,
      customCoverPath: customCoverPath ?? this.customCoverPath,
      customCoverAlignment: customCoverAlignment ?? this.customCoverAlignment,
      customCoverLastModified:
      customCoverLastModified ?? this.customCoverLastModified,
      customVersion: customVersion ?? this.customVersion,
      customFitMeshType: customFitMeshType ?? this.customFitMeshType,
      summary: summary ?? this.summary,
      customSummary: customSummary ?? this.customSummary,
      description: description ?? this.description,
      customDescription: customDescription ?? this.customDescription,
      author: author ?? this.author,
      customAuthor: customAuthor ?? this.customAuthor,
      userNotes: userNotes ?? this.userNotes,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      customSourceUrl: customSourceUrl ?? this.customSourceUrl,
      replacesOutfit: replacesOutfit ?? this.replacesOutfit,
    );
  }

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
    minimumSize: Size(680, 700),
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
  final String archiveName;
  _PreparedMod({required this.sourceDir, this.nexusId, this.nexusVersion, required this.archiveName});
}

class _PreparedUE4SS {
  final Directory sourceDir;
  _PreparedUE4SS({required this.sourceDir});
}

enum ModFilter { all, enabled, disabled, updatesAvailable}

enum ModTypeFilter { all, cns, replacement, movies, generic }

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
  String? _genericModsPath;
  String? _moviesPath;
  String? _moviesBackupPath;

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

  ModFilter _currentFilter = ModFilter.all;
  ModTypeFilter _currentModTypeFilter = ModTypeFilter.all;
  ModSort _currentSort = ModSort.date;
  ModListViewMode _viewMode = ModListViewMode.grid;

  bool _isUe4ssInstalled = false;
  bool _isCnsCoreInstalled = false;

  bool _developerModeEnabled = false;
  int _versionTapCount = 0;
  Timer? _hoverTimer;
  OverlayEntry? _previewOverlay;
  Offset _cursorPosition = Offset.zero;


  // ++ THUMBNAIL SERVICE INSTANCE ++
  final ThumbnailService _thumbnailService = ThumbnailService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_statusMessage.isEmpty && mounted) {
      _statusMessage = AppLocalizations.of(context)!.statusSearchingGame;
    }
  }

  String _normalizeName(String name) {
    // Primero, elimina la extensión del archivo si existe (como .zip, .rar, etc.)
    final withoutExtension = p.basenameWithoutExtension(name);
    return withoutExtension.toLowerCase().replaceAll(
      RegExp(r'[_ -]'),
      '',
    ); // Elimina guiones bajos, espacios y guiones
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
      await _runMetadataUpdateIfNeeded();
      await _loadAllMods();
      await _readCNSData();
    }
  }

  /// Verifica la existencia de manifiestos para determinar si UE4SS y CNS están instalados.
  Future<void> _checkCoreInstallations() async {
    if (_gameRootPath == null) return;
    final l10n = AppLocalizations.of(context)!;

    final win64Dir = Directory(
      p.join(_gameRootPath!, 'SB', 'Binaries', 'Win64'),
    );
    final metadataDir = Directory(p.join(win64Dir.path, '_manager_metadata'));

    final ue4ssManifest = File(p.join(metadataDir.path, 'ue4ss_manifest.json'));
    final cnsManifest = File(p.join(metadataDir.path, 'cns_manifest.json'));

    // --- Lógica de Detección y Adopción ---

    // 1. Adoptar UE4SS si no tiene manifiesto pero sí la carpeta clave.
    if (!await ue4ssManifest.exists()) {
      final ue4ssTriggerDir = Directory(
        p.join(win64Dir.path, 'ue4ss', 'Mods', 'ConsoleCommandsMod'),
      );
      if (await ue4ssTriggerDir.exists()) {
        print("Adopting existing UE4SS installation...");
        if (!await metadataDir.exists())
          await metadataDir.create(recursive: true);
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
      final cnsTriggerDir = Directory(
        p.join(win64Dir.path, 'ue4ss', 'Mods', 'DekCNS'),
      );
      if (await cnsTriggerDir.exists()) {
        print("Adopting existing CNS installation...");
        if (!await metadataDir.exists())
          await metadataDir.create(recursive: true);
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
  Future<List<String>> _generateInstallManifest(
    Directory sourceDir,
    String basePath,
  ) async {
    final List<String> paths = [];
    await for (final entity in sourceDir.list(
      recursive: true,
      followLinks: false,
    )) {
      final relativePath = p.relative(entity.path, from: basePath);
      paths.add(relativePath.replaceAll(r'\', '/')); // Normalizar a slashes
    }
    return paths;
  }

  Future<void> _showInstallationPanel({List<File>? initialFiles}) async { 
    // Limpia cualquier selección anterior al abrir el panel
    if (_preparedMods.isNotEmpty) {
      _clearSelection();
    }
  
    final l10n = AppLocalizations.of(context)!;
    
    // El panel se reconstruirá internamente usando este StateSetter
    // para no afectar a la pantalla principal.
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF2a2a2a),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // Bloquea el cierre al tocar fuera del panel.
      //isDismissible: false,
      // Bloquea el cierre al deslizar el panel hacia abajo.
      enableDrag: false,
      builder: (context) {
        var hasProcessedInitialFiles = false;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setPanelState) {
            if (initialFiles != null && !hasProcessedInitialFiles) {
              // Usamos un post-frame callback para evitar errores de "setState durante el build".
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _processArchives(initialFiles, panelStateSetter: setPanelState);
              });
              hasProcessedInitialFiles = true; // Marcamos como procesados.
            }
            final canInstall = _preparedMods.isNotEmpty && !_isLoading && !_isExtracting && !_isInstalling;
            return WillPopScope(
              onWillPop: () async {
                // CASO 1: Si está ocupado (extrayendo/instalando), bloquea el cierre.
                if (_isExtracting || _isLoading || _isInstalling) {
                  return false;
                }

                // CASO 2: Si hay mods listos, límpialo todo antes de cerrar.
                if (_preparedMods.isNotEmpty) {
                  await _cancelAndCleanInstallation();
                  // Actualiza el mensaje en la pantalla principal de forma segura.
                  setState(() {
                     _statusMessage = AppLocalizations.of(context)!.statusSelectionCancelled;
                     _statusColor = Colors.white;
                  });
                }
                
                // CASO 3: Si no está ocupado y no hay nada seleccionado, permite el cierre.
                return true;
              },
            child: DropTarget(
                onDragDone: (details) async {
                final files = details.files.map((f) => File(f.path)).toList();
                if (files.isNotEmpty) {
                  // ++ INICIO DE LA MODIFICACIÓN ++
                  // Pasa el actualizador de estado del panel a la función de lógica
                  await _processArchives(files, panelStateSetter: setPanelState);
                  setPanelState(() {}); // Actualiza la UI una última vez si es necesario
                  // ++ FIN DE LA MODIFICACIÓN ++
                }
              },
              onDragEntered: (details) => setPanelState(() => _isDragging = true),
              onDragExited: (details) => setPanelState(() => _isDragging = false),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Barra superior para cerrar el panel
                        Center(
                          child: Container(
                            height: 5,
                            width: 40,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.grey[700],
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        
                        // Contenido del panel
                        Text(l10n.installNewMod, style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 16),
                        
                        // Botones de selección e instalación
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.archive),
                                label: Text(l10n.selectModArchive),
                                onPressed: (_isLoading || _isExtracting || _isInstalling) ? null : () async {
                                    await _pickArchive(panelStateSetter: setPanelState);
                                    setPanelState(() {});
                                  },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.download_for_offline),
                                label: Text(l10n.installSelectedMod),
                                onPressed: canInstall ? () async {
                                  // ++ INICIO DE LA MODIFICACIÓN ++
                                  // Pasa el setter a la función de instalación
                                  await _installMod(panelStateSetter: setPanelState);
                                  if (mounted) Navigator.pop(context); // Cierra el panel
                                  // ++ FIN DE LA MODIFICACIÓN ++
                                } : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: canInstall ? Colors.tealAccent : Colors.grey[700],
                                  foregroundColor: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Vista previa de la instalación
                        if (_modsToInstallPreviewMap.isNotEmpty)
                          _buildSelectionPreviewSection(
                            l10n,
                            panelStateSetter: setPanelState, // <-- PASA EL SETTER AQUÍ
                          ),
                        
                        
                        const SizedBox(height: 20),

                        // Indicadores de estado y progreso
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
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.tealAccent,
                                ),
                              ),
                            ],
                          )
                          else if (_isInstalling) // <-- AÑADIDO ESTE CASO
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    _installationStatus, // Usa el nuevo estado
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white70),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: _installationProgress, // Usa el nuevo progreso
                                  backgroundColor: Colors.grey[800],
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.greenAccent, // Un color diferente para distinguirla
                                  ),
                                ),
                              ],
                            )
                        else if (_preparedMods.isNotEmpty || _statusColor != Colors.white)
                            Text(
                              _statusMessage,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14, color: _statusColor),
                            ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // Overlay de arrastrar y soltar
                  if (_isDragging)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        border: Border.all(color: Colors.tealAccent, width: 3),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.download_for_offline, size: 80, color: Colors.tealAccent),
                            const SizedBox(height: 20),
                            Text(l10n.dropTargetOverlay, style: const TextStyle(color: Colors.white, fontSize: 24)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              ),
            );
          },
        );
      },
    );

    // Cuando el panel se cierra, recargamos la lista principal de mods.
    await _loadAllMods();
  }

  /// Descarga la imagen principal de Nexus, la guarda localmente y actualiza el JSON del mod.
  Future<void> _cacheNexusThumbnail({
    required Directory modDirectory,
    required String nexusId,
  }) async {
    final infoFile = File(p.join(modDirectory.path, 'nexus_info.json'));
    if (!await infoFile.exists()) return; // El archivo de información debe existir

    try {
      Map<String, dynamic> data = json.decode(await infoFile.readAsString());

      // SI EL MOD YA TIENE UNA PORTADA PERSONALIZADA, NO HACEMOS NADA.
      // Esto respeta la elección del usuario y evita descargas innecesarias.
      if (data['customCoverPath'] != null && (data['customCoverPath'] as String).isNotEmpty) {
        return;
      }

      // 1. Obtenemos la URL de la imagen desde la API de Nexus
      final nexusData = await _fetchNexusModData(nexusId);
      final gallery = nexusData?['gallery'] as List<dynamic>?;
      if (gallery == null || gallery.isEmpty) return;
      
      final imageUrl = gallery.first['image'] as String?;
      if (imageUrl == null || imageUrl.isEmpty) return;

      // 2. Descargamos la imagen
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        // 3. Guardamos la imagen en la carpeta del mod con un nombre estándar
        final fileExtension = p.extension(imageUrl).isNotEmpty ? p.extension(imageUrl) : '.jpg';
        const coverFileName = '_nexus_cover'; // Nombre base estándar
        final finalFileName = '$coverFileName$fileExtension';
        
        final coverFile = File(p.join(modDirectory.path, finalFileName));
        await coverFile.writeAsBytes(response.bodyBytes);

        // 4. Actualizamos el archivo nexus_info.json con la ruta local y una alineación por defecto
        data['customCoverPath'] = finalFileName;
        data['customCoverAlignmentX'] ??= 0.0; // Añade alineación por defecto si no existe
        data['customCoverAlignmentY'] ??= 0.0;
        
        final encoder = JsonEncoder.withIndent('  ');
        await infoFile.writeAsString(encoder.convert(data));
        print('Portada de Nexus cacheada para ${p.basename(modDirectory.path)}');
      }
    } catch (e) {
      print('No se pudo cachear la portada de Nexus para ${p.basename(modDirectory.path)}: $e');
    }
  }

  Future<void> _cancelAndCleanInstallation() async {
    // Limpia las listas de estado de la instalación.
    _preparedMods.clear();
    _modsToInstallPreviewMap.clear();

    // Intenta eliminar de forma segura el directorio de extracción temporal.
    try {
      if (_tempExtractionDir != null && await _tempExtractionDir!.exists()) {
        await _tempExtractionDir!.delete(recursive: true);
        _tempExtractionDir = null; // Libera la referencia
        print('Temporary extraction directory cleaned up successfully.');
      }
    } catch (e) {
      print('Failed to clean up temp directory during cancellation: $e');
    }
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

      final manifestName = isUe4ss
          ? 'ue4ss_manifest.json'
          : 'cns_manifest.json';
      final manifestFile = File(
        p.join(
          _gameRootPath!,
          'SB',
          'Binaries',
          'Win64',
          '_manager_metadata',
          manifestName,
        ),
      );

      if (!await manifestFile.exists()) {
        throw Exception("Installation manifest not found. Cannot uninstall.");
      }

      final content = await manifestFile.readAsString();
      final List<String> relativePaths = List<String>.from(
        json.decode(content),
      );

      final String baseDeletePath = isUe4ss
          ? p.join(_gameRootPath!, 'SB', 'Binaries', 'Win64')
          : p.join(_gameRootPath!, 'SB');

      for (final relativePath in relativePaths.reversed) {
        final fullPath = p.join(baseDeletePath, relativePath);
        try {
          final entityType = await FileSystemEntity.type(
            fullPath,
            followLinks: false,
          );
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
        context: context,
        type: NotificationType.success,
        title: l10n.snackBarUninstalled(componentName),
      );

      return true; // <-- INFORMA QUE LA OPERACIÓN FUE EXITOSA
    } catch (e) {
      NotificationService.instance.show(
        context: context,
        type: NotificationType.error,
        title: l10n.errorUninstalling(componentName),
        description: e.toString(),
      );
      return false; // <-- INFORMA QUE LA OPERACIÓN FALLÓ
    } finally {
      await _checkCoreInstallations();
      await _readCNSData();
      setState(() {
        _isLoading = false;
        _statusMessage = "";
      });
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
    // ++ AÑADIDO PARA EL NUEVO FILTRO ++
    final modTypeFilterIndex =
        prefs.getInt(AppPrefs.modTypeFilterMode) ?? ModTypeFilter.all.index;
    // --
    final sortIndex = prefs.getInt(AppPrefs.sortMode) ?? ModSort.date.index;
    final viewModeIndex =
        prefs.getInt(AppPrefs.viewMode) ?? ModListViewMode.grid.index;

    setState(() {
      _currentFilter = ModFilter.values[filterIndex];
      // ++ AÑADIDO PARA EL NUEVO FILTRO ++
      _currentModTypeFilter = ModTypeFilter.values[modTypeFilterIndex];
      // --
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
        headers: {'apikey': apiKey, 'accept': 'application/json'},
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
        // Ruta para mods CNS (la que ya tenías)
        final cnsModPath = p.join(
          gamePath,
          'SB',
          'Content',
          'Paks',
          '~mods',
          'CustomNanosuitSystem',
        );
        // NUEVA RUTA: Ruta para mods Genéricos (la carpeta ~mods raíz)
        final genericModPath = p.join(
          gamePath,
          'SB',
          'Content',
          'Paks',
          '~mods',
        );
        // Ruta de las películas del juego
        final moviesPath = p.join(
          gamePath, 'SB', 'Content', 'Movies',
        );
        // Ruta para guardar las películas ORIGINALES del juego
        final moviesBackupPath = p.join(
          gamePath, 'SB', 'Content', '__MOVIES_ORIGINALS__',
        );
        
        // --- INICIO DE LA MODIFICACIÓN ---
        // Asegurarse de que todas las carpetas de mods existan
        final cnsDir = Directory(cnsModPath);
        final genericDir = Directory(genericModPath);
        // Asegurarse de que el directorio de respaldo de películas exista
        final moviesBackupDir = Directory(moviesBackupPath);
        
        if (!await cnsDir.exists()) {
          await cnsDir.create(recursive: true);
        }
        if (!await genericDir.exists()) {
          await genericDir.create(recursive: true);
        }
        if (!await moviesBackupDir.exists()) {
          await moviesBackupDir.create(recursive: true);
        }
        // --- FIN DE LA MODIFICACIÓN ---

        setState(() {
          _gameRootPath = gamePath;
          _finalModsPath = cnsModPath; // Para mods CNS
          _genericModsPath = genericModPath; // Para mods Genéricos
          _moviesPath = moviesPath;
          _moviesBackupPath = moviesBackupPath;
          if (mounted) {
            _statusMessage = AppLocalizations.of(context)!.statusGamePathFound;
          }
        });
      } else {
        setState(() {
          _finalModsPath = null;
          _genericModsPath = null; // <-- Asegúrate de ponerlo a null también
          _moviesPath = null;
          _moviesBackupPath = null;
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
        _genericModsPath = null; // <-- Asegúrate de ponerlo a null también
        _moviesPath = null;
        _moviesBackupPath = null;
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

  Future<String?> _findSteamInstallation() async {
    if (!Platform.isWindows) return null;
    try {
      final key = Registry.openPath(
        RegistryHive.currentUser,
        path: r'Software\Valve\Steam',
      );
      final steamPath = key.getValueAsString('SteamPath');
      key.close();

      if (steamPath == null) return null;

      final List<String> libraryPaths = [steamPath];
      final libraryFoldersVdf = File(
        p.join(steamPath, 'steamapps', 'libraryfolders.vdf'),
      );

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
        final gamePath = p.join(libPath, 'steamapps', 'common', 'StellarBlade');
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
        return newVersion; // Versión encontrada, terminamos aquí.
      }
    } catch (e) {
      print('Error reading CNS nexus_info.json: $e');
    }

    // Si no se encontró arriba, intenta leer desde el archivo main.lua
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

  Future<String?> _getVersionFromModJsonDescription(Directory modDir) async {
    try {
      await for (final file in modDir.list()) {
        if (file is File && p.extension(file.path).toLowerCase() == '.json') {
          final jsonString = await file.readAsString();
          final jsonDecoded = json.decode(
            jsonString.replaceAll(RegExp(r',\s*(?=[\}\]])'), ''),
          );
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
      print(
        'Error reading version from JSON description for ${modDir.path}: $e',
      );
    }
    return null;
  }

  String _stripVersionFromFolderName(String name) {
    final regex = RegExp(
      r'\s+[vV]?\d+(\.\d+)*(-[a-zA-Z0-9]+)?\s*$',
      caseSensitive: false,
    );
    return name.replaceAll(regex, '').trim();
  }

  String _cleanNexusFileName(String fileName) {
    // 1. Intenta encontrar un patrón de ID de Mod de Nexus (ej: -123-)
    // Esta es la misma regex que se usa en _extractNexusInfoFromName
    final nexusIdRegex = RegExp(r'-(\d{2,5})-');
    final match = nexusIdRegex.firstMatch(fileName);

    if (match != null) {
      // ¡Encontrado! Devuelve todo lo que está ANTES del guion.
      // ej: "AwesomeOutfit-123-1-0" -> match.start es el índice 14.
      // substring(0, 14) devuelve "AwesomeOutfit".
      return fileName.substring(0, match.start);
    } else {
      // 2. No se encontró el patrón de ID.
      // Usa la lógica de limpieza antigua (para nombres como "MiMod v1.0").
      return _stripVersionFromFolderName(fileName);
    }
  }

  /// Escanea todos los mods y, si es necesario, actualiza sus metadatos mostrando una barra de progreso.
  Future<void> _runMetadataUpdateIfNeeded() async {
    if (_finalModsPath == null) return;
    final l10n = AppLocalizations.of(context)!;

    // 1. Escanea en busca de mods que necesiten una actualización
    final List<Map<String, dynamic>> modsToUpdate = [];
    final List<String> modPaths = [];

    // Escanea mods activados
    final enabledDir = Directory(_finalModsPath!);
    if (await enabledDir.exists()) {
      await for (var entity in enabledDir.list()) {
        if (entity is Directory) modPaths.add(entity.path);
      }
    }

    // Escanea mods desactivados
    if (_gameRootPath != null) {
      final backupDirPath = p.join(_gameRootPath!, 'SB', 'Content', '__MOD_BACKUPS__');
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

          bool needsUpdate = modManagerVersion == null || (_compareVersions(_appVersion, modManagerVersion) > 0);

          if (needsUpdate && nexusIdForCheck != null && nexusIdForCheck.isNotEmpty) {
            modsToUpdate.add({
              'path': modPath,
              'nexusId': nexusIdForCheck,
              'displayName': data['displayName'] ?? p.basename(modPath),
            });
          }
        } catch (e) {
          print('No se pudo analizar nexus_info.json para la comprobación de actualización de metadatos en ${modPath}: $e');
        }
      }
    }

    // 2. Si se encuentran actualizaciones, ejecuta el proceso
    if (modsToUpdate.isNotEmpty) {
      setState(() {
        _isLoading = false; // Detiene el spinner de carga principal
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
          _metadataUpdateStatus = l10n.statusUpdatingMetadata(displayName, i + 1, modsToUpdate.length);
        });

        try {
          final nexusData = await _fetchNexusModData(nexusId);
          if (nexusData != null) {
            final content = await infoFile.readAsString();
            Map<String, dynamic> data = json.decode(content);

            data['summary'] ??= nexusData['summary'];
            data['author'] ??= nexusData['author'];
            data['gallery'] ??= nexusData['gallery'];
            data['description'] ??= nexusData['description'];
            data['sourceUrl'] ??= 'https://www.nexusmods.com/stellarblade/mods/$nexusId';
            data['managerVersion'] = _appVersion;

            final encoder = JsonEncoder.withIndent('  ');
            await infoFile.writeAsString(encoder.convert(data));
            await _cacheNexusThumbnail(modDirectory: modDirectory, nexusId: nexusId);
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

    // Esta función interna procesa un directorio (mods activados o desactivados)
    Future<List<ModInfo>> getModsFromDirectory(
      String path,
      bool isEnabled,
    ) async {
      final dir = Directory(path);
      if (!await dir.exists()) return [];

      final List<ModInfo> mods = [];
      await for (var entity in dir.list()) {
        if (entity is Directory) {
          // --- INICIO DE LA MODIFICACIÓN ---
          // Si estamos escaneando la carpeta genérica, omitimos la carpeta CNS.
          if (path == _genericModsPath && 
              p.basename(entity.path).toLowerCase() == 'customnanosuitsystem') {
                continue;
          }
          if (p.basename(entity.path) == '__MOD_BACKUPS__') continue;
          try {
            // Inicializa todas las variables que vamos a leer.
            String? nexusId;
            String? installedVersion;
            String? origin;
            List<dynamic>? gallery;
            String? fitMeshType;
            String? modType;
            bool? isEnabledFromJson;
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
            String? description;
            String? customDescription;
            String? author;
            String? customAuthor;
            String? userNotes;
            String? sourceUrl;
            String? customSourceUrl;
            String? replacesOutfit;

            bool isEnabledForMod = isEnabled; 
            DateTime? installDate;

            final infoFile = File(p.join(entity.path, 'nexus_info.json'));
            final fileStat = await entity
                .stat(); // <-- Move this up so it's always assigned
            if (await infoFile.exists()) {
              final content = await infoFile.readAsString();
              Map<String, dynamic> data = json.decode(content);

              // --- INICIO DE LA LÓGICA DE ACTUALIZACIÓN AUTOMÁTICA ---
              final String? modManagerVersion = data['managerVersion'];
              final String? nexusIdForCheck = data['nexusId'];

              bool needsMetadataUpdate =
                  modManagerVersion == null ||
                  (_compareVersions(_appVersion, modManagerVersion) > 0);

              if (needsMetadataUpdate && nexusIdForCheck != null) {
                print('Auto-updating metadata for mod: ${data['displayName']}');
                final nexusData = await _fetchNexusModData(nexusIdForCheck);

                if (nexusData != null) {
                  data['summary'] ??= nexusData['summary'];
                  data['author'] ??= nexusData['author'];
                  data['gallery'] ??= nexusData['gallery'];
                  data['description'] ??= nexusData['description'];
                  data['sourceUrl'] ??=
                      'https://www.nexusmods.com/stellarblade/mods/$nexusIdForCheck';
                  data['managerVersion'] = _appVersion;

                  final encoder = JsonEncoder.withIndent('  ');
                  await infoFile.writeAsString(encoder.convert(data));
                  print(
                    '...metadata for ${data['displayName']} updated successfully.',
                  );
                  await _cacheNexusThumbnail(modDirectory: entity, nexusId: nexusIdForCheck);
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
              modType = data['modType'] as String?;
              isEnabledFromJson = data['isEnabled'] as bool?;
              summary = data['summary'];
              customSummary = data['customSummary'];
              description = data['description'];
              customDescription = data['customDescription'];
              author = data['author'];
              customAuthor = data['customAuthor'];
              userNotes = data['userNotes'];
              sourceUrl = data['sourceUrl'];
              customSourceUrl = data['customSourceUrl'];
              replacesOutfit = data['replacesOutfit'] as String?;

              if (installedVersion != null &&
                  installedVersion.toLowerCase().startsWith('v')) {
                installedVersion = installedVersion.substring(1);
              }

              customCoverPath = data['customCoverPath'];
              if (customCoverPath != null) {
                final coverFile = File(p.join(entity.path, customCoverPath));
                if (await coverFile.exists()) {
                  customCoverLastModified = await coverFile.lastModified();
                }
              }
              if (data['customCoverAlignmentX'] != null &&
                  data['customCoverAlignmentY'] != null) {
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
            // Si el JSON no existía (modType sigue null) y el mod está HABILITADO
            // inferimos el tipo basado en la carpeta que estamos escaneando.
            if (modType == null && isEnabled) {
              if (path == _genericModsPath) {
                modType = 'genericPak';
              } else if (path == _finalModsPath) {
                modType = 'cns';
              }
              // Si está deshabilitado (isEnabled = false), lo dejamos como null
              // y la UI lo tratará como 'cns' por defecto (comportamiento antiguo).
            }

            if (modType == 'movies' && await infoFile.exists()) {
                final content = await infoFile.readAsString();
                final data = json.decode(content);
                isEnabledForMod = data['isEnabled'] as bool? ?? false;
              }
            // Lógica de fallback si el nexus_info.json no existe o está incompleto
            if (fitMeshType == null && modType != 'movies') {
              fitMeshType = await _getFitMeshTypeForMod(entity);
              if (fitMeshType != null && await infoFile.exists()) {
                try {
                  final content = await infoFile.readAsString();
                  Map<String, dynamic> data = json.decode(content);
                  data['fitMeshType'] = fitMeshType;
                  final encoder = JsonEncoder.withIndent('  ');
                  await infoFile.writeAsString(encoder.convert(data));
                } catch (e) {
                  print(
                    "Could not update nexus_info.json with FitMeshType for ${entity.path}: $e",
                  );
                }
              }
            }
            installedVersion ??= ModInfo._extractVersionFromName(folderName);

            // final fileStat = await entity.stat(); <-- Already declared above

            // Añade el mod a la lista con toda la información cargada (y potencialmente actualizada)
            mods.add(
              ModInfo(
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
                replacesOutfit: replacesOutfit,
              ),
            );
          } catch (e) {
            print("Error processing directory ${entity.path}: $e");
          }
        }
      }
      return mods;
    }

    try {
      final enabledCnsMods = await getModsFromDirectory(_finalModsPath!, true);
      final enabledGenericMods = await getModsFromDirectory(_genericModsPath!, true);

      if (_gameRootPath == null) {
        final disabledMods = <ModInfo>[];
        setState(() {
          _allMods = [...enabledCnsMods, ...enabledGenericMods, ...disabledMods];
        });
        return;
      }
      final backupDirPath = p.join(
        _gameRootPath!,
        'SB',
        'Content',
        '__MOD_BACKUPS__',
      );
      final disabledMods = await getModsFromDirectory(backupDirPath, false);
      
      // Combina todas las listas
      setState(() {
        _allMods = [...enabledCnsMods, ...enabledGenericMods, ...disabledMods];
        if (clearHighlight && mounted) {
          final totalEnabled = enabledCnsMods.length + enabledGenericMods.length; // Suma
          _statusMessage = AppLocalizations.of(
            context,
          )!.statusModsFound(disabledMods.length, totalEnabled); // Usa la suma
          _statusColor = Colors.white;
        }
      });
    } catch (e) {
      setState(() {
        if (mounted) {
          _statusMessage = AppLocalizations.of(
            context,
          )!.statusErrorReadingMods(e.toString());
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
          print(
            'Found malformed nexus_info.json for ${mod.customName}, scheduling for repair. Error: $e',
          );
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
      if (primaryDisplayName != null &&
          _modDatabase.containsKey(primaryDisplayName)) {
        final dbEntry =
            _modDatabase[primaryDisplayName] as Map<String, dynamic>;
        final nexusId = dbEntry['nexusId'] as String?;

        if (nexusId == null) continue;

        String? version = ModInfo._extractVersionFromName(
          p.basename(mod.directory.path),
        );
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

        final compositeDisplayName =
            await _getCompositeDisplayName(mod.directory) ?? primaryDisplayName;
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
              print(
                'Could not parse existing nexus_info.json for ${mod.customName}. A new one will be created.',
              );
            }
          }

          // Actualiza o añade los campos necesarios.
          modData['nexusId'] = nexusId;
          modData['displayName'] = compositeDisplayName;
          modData['customName'] ??=
              currentFolderName; // Si no tenía customName, usa el de la carpeta.
          modData['installedVersion'] = version;
          modData['installDate'] ??= DateTime.now()
              .toIso8601String(); // Si no tenía fecha, la añade.
          modData['origin'] = 'repaired';

          final nexusData = await _fetchNexusModData(nexusId);
          if (nexusData != null) {
            modData['gallery'] = nexusData['gallery'];
            modData['summary'] = nexusData['summary'];
            modData['author'] = nexusData['author'];
            modData['description'] = nexusData['description'];
          }

          final encoder = JsonEncoder.withIndent('  ');
          await infoFile.writeAsString(encoder.convert(modData));
          await _cacheNexusThumbnail(modDirectory: mod.directory, nexusId: nexusId);
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
      final url = Uri.parse(
        'https://api.nexusmods.com/v1/games/stellarblade/mods/$nexusId/files.json',
      );
      final response = await http.get(url, headers: headers);

      if (response.statusCode != 200) return null;

      final jsonResponse = json.decode(response.body);
      final allFiles = jsonResponse['files'] as List;

      dynamic highestVersionFile;
      String highestVersion = "0";
      for (final file in allFiles) {
        final currentVersion = file['version'] as String?;
        if (currentVersion != null &&
            _compareVersions(currentVersion, highestVersion) > 0) {
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

  Future<void> _pickArchive({StateSetter? panelStateSetter}) async { // <-- AÑADE EL PARÁMETRO AQUÍ
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip', 'rar', '7z'],
        allowMultiple: true,
      );
      if (result != null && result.files.isNotEmpty) {
        final files = result.paths.map((path) => File(path!)).toList();
        // ++ PASA EL PARÁMETRO A LA SIGUIENTE FUNCIÓN ++
        await _processArchives(files, panelStateSetter: panelStateSetter); 
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
  }
  Future<Map<String, String>?> _extractNexusInfoFromName(String name) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Se necesita una API Key para identificar mods con nombres complejos.',
            ),
            backgroundColor: Colors.orangeAccent,
          ),
        );
      }
      return null;
    }

    try {
      // Busca todos los números de 2 a 5 dígitos que estén entre guiones.
      final potentialIdsRegex = RegExp(r'-(\d{2,5})-');
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

            print(
              'API Validation successful: Found mod ID $validId with version $version',
            );
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
      if (reinstall != true) return;
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
        return;
      }
    }

    setState(() {
      _isLoading = true;
      _statusMessage = l10n.statusInstallingUE4SS;
    });

    try {
      if (_gameRootPath == null) throw Exception(l10n.errorGamePathUndefined);

      final manifestDir = Directory(
        p.join(_gameRootPath!, 'SB', 'Binaries', 'Win64', '_manager_metadata'),
      );
      if (!await manifestDir.exists())
        await manifestDir.create(recursive: true);
      final manifestFile = File(
        p.join(manifestDir.path, 'ue4ss_manifest.json'),
      );

      // ++ INICIO DE LA NUEVA LÓGICA DE COMBINACIÓN ++
      // 1. Generar la lista de archivos de la NUEVA instalación.
      final newPaths = await _generateInstallManifest(
        sourceDir,
        sourceDir.path,
      );

      // 2. Cargar la lista de archivos del manifiesto ANTIGUO, si existe.
      Set<String> finalPaths = newPaths
          .toSet(); // Usamos un Set para evitar duplicados.
      if (await manifestFile.exists()) {
        try {
          final oldContent = await manifestFile.readAsString();
          final List<String> oldPaths = List<String>.from(
            json.decode(oldContent),
          );
          // 3. Añadir los archivos antiguos a la lista final.
          finalPaths.addAll(oldPaths);
        } catch (e) {
          print(
            "No se pudo leer el manifiesto antiguo de UE4SS, será reemplazado. Error: $e",
          );
        }
      }

      // 4. Escribir la lista combinada y final en el manifiesto.
      await manifestFile.writeAsString(json.encode(finalPaths.toList()));
      // ++ FIN DE LA NUEVA LÓGICA DE COMBINACIÓN ++

      final destinationDir = Directory(
        p.join(_gameRootPath!, 'SB', 'Binaries', 'Win64'),
      );
      await _copyDirectory(sourceDir, destinationDir);

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
    } catch (e) {
      setState(() {
        _statusMessage = l10n.statusError(e.toString());
        _statusColor = Colors.redAccent;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _processArchives(List<File> archives, {StateSetter? panelStateSetter}) async {
    final l10n = AppLocalizations.of(context)!;
    final updateState = panelStateSetter ?? setState;
    updateState(() {
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
      _tempExtractionDir = Directory.systemTemp.createTempSync('mod_manager_');

      _preparedMods.clear();

      for (int i = 0; i < archives.length; i++) {
        final archiveFile = archives[i];
        final fileName = p.basename(archiveFile.path);

        updateState(() {
          _extractionProgress = (i + 1) / archives.length;
          _extractionStatus = l10n.statusExtractingMultipleFiles(
            i + 1,
            fileName,
            archives.length,
          );
        });

        final nexusInfo = await _extractNexusInfoFromName(fileName);
        final archiveTempDir = Directory(
          p.join(_tempExtractionDir!.path, i.toString()),
        );
        await archiveTempDir.create();

        final extension = p.extension(archiveFile.path).toLowerCase();

        if (['.zip', '.rar', '.7z'].contains(extension)) {
          if (_7zipPath == null || !await File(_7zipPath!).exists()) {
            final installed = await _show7zipRequiredDialog();
            if (!installed) {
              throw Exception(l10n.error7zipRequired);
            }
          }
          final result = await Process.run(_7zipPath!, [
            'x',
            archiveFile.path,
            '-o${archiveTempDir.path}',
            '-y',
          ]);
          if (result.exitCode != 0) {
            throw Exception(
              l10n.error7zipDecompression(result.stderr.toString()),
            );
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
          // --- LÓGICA HÍBRIDA: MANEJA ARCHIVOS SUELTOS Y SUBDIRECTORIOS ---
          
          // Nombre de fallback (limpio)
          final baseArchiveName = p.basenameWithoutExtension(archiveFile.path);
          final archiveName = _cleanNexusFileName(baseArchiveName);

          // 1. BUSCAR ARCHIVOS SUELTOS (en cualquier parte del zip)
          // Esta función busca recursivamente en todo el directorio temporal del zip
          final allModFiles = await _findAllModFilesRecursive(archiveTempDir);

          final jsonFiles = allModFiles
              .where((f) => p.extension(f.path).toLowerCase() == '.json')
              .toList();
          final pakFiles = allModFiles
              .where(
                (f) => [
                  '.pak',
                  '.ucas',
                  '.utoc',
                ].contains(p.extension(f.path).toLowerCase()),
              )
              .toList();

          // 2. DECIDIR EL TIPO BASADO EN LOS ARCHIVOS SUELTOS
          
          // CASO A: Archivos sueltos de un mod CNS (tienen .json y .pak)
          if (jsonFiles.isNotEmpty && pakFiles.isNotEmpty) {
            // Consolida todos los archivos en una sola carpeta temporal
            final consolidatedDir = await Directory(
              p.join(archiveTempDir.path, '_consolidated_'),
            ).create();

            for (final modFile in allModFiles) {
              // Solo copia los archivos de mod, no la basura
              final ext = p.extension(modFile.path).toLowerCase();
              if (ext == '.json' || ext == '.pak' || ext == '.ucas' || ext == '.utoc') {
                final newPath = p.join(
                  consolidatedDir.path,
                  p.basename(modFile.path),
                );
                await modFile.copy(newPath);
              }
            }

            _preparedMods.add(
              _PreparedMod(
                sourceDir: consolidatedDir, // Instala desde la carpeta consolidada
                nexusId: nexusInfo?['id'],
                nexusVersion: nexusInfo?['version'],
                archiveName: archiveName,
              ),
            );
          } 
          // CASO B: Archivos sueltos de un mod Genérico (solo .pak, NO .json)
          else if (jsonFiles.isEmpty && pakFiles.isNotEmpty) {
             // Consolida todos los archivos en una sola carpeta temporal
            final consolidatedDir = await Directory(
              p.join(archiveTempDir.path, '_consolidated_'),
            ).create();

            for (final modFile in pakFiles) { // Solo copia los paks
              final newPath = p.join(
                consolidatedDir.path,
                p.basename(modFile.path),
              );
              await modFile.copy(newPath);
            }

             _preparedMods.add(
              _PreparedMod(
                sourceDir: consolidatedDir, 
                nexusId: nexusInfo?['id'],
                nexusVersion: nexusInfo?['version'],
                archiveName: archiveName,
              ),
            );
          }
          // CASO C: No hay archivos sueltos. Buscar en subdirectorios.
          else {
            // Usa la función (que acabamos de restaurar) para encontrar
            // directorios de mod (CNS o Genéricos) anidados.
            final foundModDirs = await _findValidModDirectories(archiveTempDir);
            for (final modDir in foundModDirs) {
              _preparedMods.add(
                _PreparedMod(
                  sourceDir: modDir,
                  nexusId: nexusInfo?['id'],
                  nexusVersion: nexusInfo?['version'],
                  archiveName: archiveName,
                ),
              );
            }
          }
        }
      }

      if (_preparedUE4SS != null) {
        _preparedMods.clear();
        await _promptAndInstallUE4SS(_preparedUE4SS!.sourceDir);
      } else if (cnsUpdateInitiated && _preparedMods.isEmpty) {
      } else {
        await _prepareInstallationPreview(panelStateSetter: panelStateSetter);
      }
    } catch (e) {
      updateState(() {
        _statusMessage = l10n.statusError(e.toString());
        _statusColor = Colors.redAccent;
      });
    } finally {
      updateState(() {
        _isExtracting = false;
      });
    }
  }

  Future<List<Directory>> _findValidModDirectories(Directory root) async {
    final List<Directory> found = [];

    // 1. Comprueba si la propia raíz es un mod.
    final rootModType = await ModClassifierService.classifyModDirectory(root);
    if (rootModType != ModDirectoryType.unknown) {
      found.add(root);
      // Si la raíz es un mod, no escaneamos sus subcarpetas.
      return found;
    }

    // 2. Si la raíz no es un mod, escanea sus subdirectorios.
    await for (final entity in root.list(followLinks: false)) {
      if (entity is Directory) {
        final basename = p.basename(entity.path);
        // Ignora carpetas de sistema o de "basura"
        if (basename.startsWith('__') || basename.startsWith('.')) continue;

        // Llama recursivamente
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

  Future<void> _prepareInstallationPreview({StateSetter? panelStateSetter}) async {
    // ++ INICIO DE LA MODIFICACIÓN ++
    if (_preparedMods.isEmpty) {
      _clearSelection(
        message: AppLocalizations.of(context)!.errorNoCompatibleFilesInArchive,
        panelStateSetter: panelStateSetter, // <-- Pasa el actualizador del panel
      );
      return;
    }
    // ++ FIN DE LA MODIFICACIÓN ++

    final Map<String, List<String>> previewMap = {};

    for (final preparedMod in _preparedMods) {
      // 1. Intenta obtener el nombre del .json (para mods CNS)
      String? displayName = await _getDisplayNameForMod(preparedMod.sourceDir);

      // 2. Si falla (es null), usa el nombre del zip (para mods Genéricos)
      displayName ??= preparedMod.archiveName;

      // 3. Ahora displayName no debería ser nulo
      if (displayName.isNotEmpty) {
        String finalFolderName = displayName;
        if (preparedMod.nexusVersion != null) {
          finalFolderName = '$finalFolderName v${preparedMod.nexusVersion}';
        }

        // 4. CORRECCIÓN: Usamos la misma función que el instalador
        // para encontrar TODOS los archivos que se copiarán.
        final files = (await _findAllModFilesRecursive(preparedMod.sourceDir))
            .map((f) => p.basename(f.path))
            .toList();

        previewMap[finalFolderName] = files;
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
      if (confirm != true) return;
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
        return;
      }
    }

    setState(() {
      _isLoading = true;
      _statusMessage = l10n.statusUpdatingCNS;
    });

    try {
      if (_gameRootPath == null) throw Exception(l10n.errorGamePathUndefined);

      final manifestDir = Directory(
        p.join(_gameRootPath!, 'SB', 'Binaries', 'Win64', '_manager_metadata'),
      );
      if (!await manifestDir.exists())
        await manifestDir.create(recursive: true);
      final manifestFile = File(p.join(manifestDir.path, 'cns_manifest.json'));

      // ++ INICIO DE LA NUEVA LÓGICA DE COMBINACIÓN ++
      // 1. Generar la lista de archivos de la NUEVA instalación.
      final newPaths = await _generateInstallManifest(
        sourceSBDir,
        sourceSBDir.path,
      );

      // 2. Cargar la lista de archivos del manifiesto ANTIGUO, si existe.
      Set<String> finalPaths = newPaths.toSet();
      if (await manifestFile.exists()) {
        try {
          final oldContent = await manifestFile.readAsString();
          final List<String> oldPaths = List<String>.from(
            json.decode(oldContent),
          );
          // 3. Añadir los archivos antiguos a la lista final.
          finalPaths.addAll(oldPaths);
        } catch (e) {
          print(
            "No se pudo leer el manifiesto antiguo de CNS, será reemplazado. Error: $e",
          );
        }
      }

      // 4. Escribir la lista combinada y final en el manifiesto.
      await manifestFile.writeAsString(json.encode(finalPaths.toList()));
      // ++ FIN DE LA NUEVA LÓGICA DE COMBINACIÓN ++

      final destinationSBDir = Directory(p.join(_gameRootPath!, 'SB'));
      await _copyDirectory(sourceSBDir, destinationSBDir);

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
    } catch (e) {
      setState(() {
        _statusMessage = l10n.statusError(e.toString());
        _statusColor = Colors.redAccent;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _copyDirectory(Directory source, Directory destination) async {
    await for (var entity in source.list(recursive: false)) {
      if (entity is Directory) {
        var newDirectory = Directory(
          p.join(destination.absolute.path, p.basename(entity.path)),
        );
        await newDirectory.create();
        await _copyDirectory(entity.absolute, newDirectory.absolute);
      } else if (entity is File) {
        await entity.copy(p.join(destination.path, p.basename(entity.path)));
      }
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
      _installationStatus = l10n.statusInstalling; // Necesitarás esta traducción
      _lastInstalledModNames.clear();
    });
    

    List<String> installedNames = [];
    String? errorMessage;
    int successCount = 0;
    int failCount = 0;

    try {
      for (int i = 0; i < _preparedMods.length; i++) {
        final preparedMod = _preparedMods[i]; // <-- Obtenemos el objeto completo
        try {
          // Llamamos a nuestra nueva función de instalación unificada
          final modName = await _installSingleMod(
            preparedMod,
            l10n: l10n,
          );
          
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

  /// Muestra un diálogo para preguntar al usuario si un mod genérico es un reemplazo de traje.
  Future<bool> _promptForOutfitReplacement(String modName) async {
      final l10n = AppLocalizations.of(context)!;
      final bool? isReplacement = await showDialog<bool>(
        context: context,
        barrierDismissible: false, // Forzar una elección
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF2a2a2a),
          title: Text(l10n.dialogTitleOutfitReplacement), // <<< MODIFICADO
          content: Text(l10n.dialogContentOutfitReplacement(modName)), // <<< MODIFICADO
          actions: [
            // Botón "No"
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.dialogActionNo), // <<< MODIFICADO
            ),
            // Botón "Sí"
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                foregroundColor: Colors.black,
              ),
              child: Text(l10n.dialogActionYes), // <<< MODIFICADO
            ),
          ],
        ),
      );
      return isReplacement ?? false; // Por defecto 'falso' si se cierra
  }

  // ++ AÑADIR ESTA FUNCIÓN (COPIADA Y MODIFICADA DE _ModDetailsPanelState) ++
  /// Muestra el panel flotante para seleccionar un traje y DEVUELVE el nombre seleccionado.
  Future<String?> _promptToSelectOutfit(AppLocalizations l10n) async {
    final ValueNotifier<String?> hoveredOutfitNotifier = ValueNotifier<String?>(null);
    String searchQuery = '';
    bool isClosing = false;

    final String? selectedOutfit = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF2d2d2d),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8,
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            final filteredOutfits = stellarBladeOutfits.where((outfit) => 
              outfit.toLowerCase().contains(searchQuery.toLowerCase())
            ).toList();

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- LADO IZQUIERDO: BÚSQUEDA Y LISTA (2/3 del espacio) ---
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Container(
                        height: 5,
                        width: 40,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: TextField(
                          autofocus: true,
                          onChanged: (value) {
                            setDialogState(() {
                              searchQuery = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: l10n.replacesOutfitSearchHint,
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16)
                          ),
                        ),
                      ),
                      Expanded(
                        child: MouseRegion(
                          onExit: (_) {
                            if (isClosing) return;
                            if (hoveredOutfitNotifier.value != null) {
                              hoveredOutfitNotifier.value = null;
                            }
                          },
                          child: ListView.builder(
                            itemCount: filteredOutfits.length,
                            itemBuilder: (context, index) {
                              final outfit = filteredOutfits[index];
                              return MouseRegion(
                                onEnter: (_) {
                                  if (isClosing) return;
                                  if (hoveredOutfitNotifier.value != outfit) {
                                    hoveredOutfitNotifier.value = outfit;
                                  }
                                },
                                child: ListTile(
                                title: Text(outfit),
                                onTap: () {
                                  isClosing = true;
                                  // ¡CAMBIO CLAVE! Solo hacemos pop con el valor.
                                  Navigator.of(context).pop(outfit);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      )
                    ],
                  ),
                ),
                
                // --- LADO DERECHO: VISTA PREVIA (1/3 del espacio) ---
                Expanded(
                  flex: 1,
                  child: ValueListenableBuilder<String?>(
                    valueListenable: hoveredOutfitNotifier,
                    builder: (context, hoveredOutfitName, child) {
                      
                      return Container(
                        height: double.infinity, 
                        color: Colors.black.withOpacity(0.3),
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: AnimatedCrossFade(
                            crossFadeState: hoveredOutfitName == null 
                              ? CrossFadeState.showFirst 
                              : CrossFadeState.showSecond,
                            duration: const Duration(milliseconds: 200),
                            firstChild: Column(
                              key: const ValueKey('outfit_placeholder'),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_search_rounded, size: 60, color: Colors.grey[700]),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.replacesOutfitHover,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                              ],
                            ),
                            secondChild: ClipRRect(
                              key: ValueKey(hoveredOutfitName),
                              child: Image.asset(
                                _generateOutfitImagePath(hoveredOutfitName ?? ''), // Reusa la función auxiliar
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  final path = _generateOutfitImagePath(hoveredOutfitName ?? '');
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Preview not found at:\n$path",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  bottomChild,
                                  topChild,
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
    
    isClosing = true;
    hoveredOutfitNotifier.dispose();

    // Devuelve el traje seleccionado (o null si se cierra el panel)
    return selectedOutfit;
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
            final sanitizedDisplayName = displayName.trim().replaceAll(
              RegExp(r'[\\/:*?"<>|]'),
              '-',
            );
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
        if (entity is File &&
            p.extension(entity.path).toLowerCase() == '.json') {
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
              return displayName.trim().replaceAll(
                RegExp(r'[\\/:*?"<>|]'),
                '-',
              );
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
      final comparison = _compareVersions(
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

  Future<String?> _installSingleMod(
    _PreparedMod preparedMod, {
    required AppLocalizations l10n,
  }) async {
    final modDir = preparedMod.sourceDir;
    final nexusId = preparedMod.nexusId;
    final nexusVersion = preparedMod.nexusVersion;
    
    String? preservedCustomName;
    String? selectedOutfit;

    // 1. CLASIFICAR EL MOD Y OBTENER SUS DATOS
    final modType = await ModClassifierService.classifyModDirectory(modDir);
    String? baseDisplayName;
    String? fitMeshType;
    String? installPath;
    List<String> replacedFiles = [];

    // Definir la ruta de backup general (para mods deshabilitados y movies)
    if (_gameRootPath == null) throw Exception("Game path not defined.");
    final backupDirPath = p.join(
      _gameRootPath!, 'SB', 'Content', '__MOD_BACKUPS__',
    );
    // Asegurarse de que exista
    final backupDir = Directory(backupDirPath);
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    if (modType == ModDirectoryType.cns) {
      // Es un mod CNS: obtenemos el nombre y la etiqueta desde sus .json
      baseDisplayName = await _getCompositeDisplayName(modDir);
      fitMeshType = await _getFitMeshTypeForMod(modDir);
      installPath = _finalModsPath; // Se instala en la carpeta CNS
    } else if (modType == ModDirectoryType.genericPak) {
      // Es un mod Genérico: usamos el nombre del ZIP y la etiqueta "Generic"
      baseDisplayName = preparedMod.archiveName;
      fitMeshType = "Generic"; // <-- ¡AQUÍ ESTÁ LA ETIQUETA!
      installPath = _genericModsPath; // Se instala en la carpeta genérica
      // Preguntar si es un reemplazo de traje COMENTADO POR AHORA
      /*final bool isReplacement = await _promptForOutfitReplacement(baseDisplayName);
      if (isReplacement) {
        // Si es un reemplazo, abrimos el panel de selección de trajes
        selectedOutfit = await _promptToSelectOutfit(l10n);
      }*/
    } else if (modType == ModDirectoryType.movies) {
      baseDisplayName = preparedMod.archiveName;
      fitMeshType = null; // Los mods de películas no tienen etiqueta de contenido
      installPath = backupDirPath; // Se instala DIRECTAMENTE en backups
      
      // Busca todos los archivos .bk2 para guardarlos en el JSON
      await for (final entity in modDir.list()) {
        if (entity is File && p.extension(entity.path).toLowerCase() == '.bk2') {
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

    String finalFolderName = baseDisplayName;

    // 2. LÓGICA DE REEMPLAZO/ACTUALIZACIÓN (Esto permanece igual que antes)
    ModInfo? oldVersionMod;
    _AlternativeVersionAction? action;

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
        action = await showDialog<_AlternativeVersionAction>(
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
                    Navigator.of(context).pop(_AlternativeVersionAction.cancel),
                child: Text(l10n.dialogActionCancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(
                  context,
                ).pop(_AlternativeVersionAction.installAsNew),
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
        case _AlternativeVersionAction.replace:
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
          final deleted = await _deleteDirectoryWithRetry(
            oldVersionMod.directory,
          );
          if (!deleted) {
            throw Exception('Could not delete old mod version ($oldModName).');
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
        final modToReinstall = _allMods.firstWhere((m) => m.directory.path == newModPath, orElse: () => ModInfo(directory: Directory(''), lastModified: DateTime.now(), isEnabled: false, displayName: '', customName: ''));
        if (modToReinstall.directory.path.isNotEmpty && modToReinstall.modType == 'movies' && modToReinstall.isEnabled) {
          await _disableMod(modToReinstall);
        }

        final deleted = await _deleteDirectoryWithRetry(Directory(newModPath));
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
      'modType': modType.name,  // <-- AÑADIDO: "cns" o "genericPak"
      'sourceUrl': nexusId != null
          ? 'https://www.nexusmods.com/stellarblade/mods/$nexusId'
          : null,
      'isEnabled': (modType == ModDirectoryType.movies) ? false : null, // Los mods 'Movies' se instalan deshabilitados
      'replacedFiles': (modType == ModDirectoryType.movies) ? replacedFiles : null,
      'replacesOutfit': selectedOutfit,
    };
    // Limpia valores nulos para no ensuciar el JSON
    modData.removeWhere((key, value) => value == null);

    if (nexusId != null) {
      final nexusData = await _fetchNexusModData(nexusId);
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
      filesToInstall = await _findAllModFilesRecursive(modDir);
    }
    
    for (final file in filesToInstall) {
      final fileName = p.basename(file.path);
      final destinationPath = p.join(newModPath, fileName);
      await file.copy(destinationPath);
    }
    
    if (nexusId != null) {
      await _cacheNexusThumbnail(modDirectory: Directory(newModPath), nexusId: nexusId);
    }
    return finalFolderName;
  }

  Future<void> _moveMod(Directory modDir, String toPath) async {
    final modName = p.basename(modDir.path);
    final destinationPath = p.join(toPath, modName);
    await modDir.rename(destinationPath);
  }

  Future<void> _enableMod(ModInfo modInfo) async {
    // MODIFICACIÓN: Comprueba ambas rutas
    if (_finalModsPath == null || _genericModsPath == null) return;
    final String? outfitToReplace = modInfo.replacesOutfit;
    final bool isReplacementMod = outfitToReplace != null && outfitToReplace.isNotEmpty;

    if (isReplacementMod) {
      // Es un mod de reemplazo. Comprobar si ya hay otro habilitado para el mismo traje.
      ModInfo? conflictingMod;
      try {
        // Buscamos en todos los mods
        for (final otherMod in _allMods) {
          // Si el 'otro mod' está habilitado,
          // no es el mismo mod que intentamos activar,
          // y reemplaza el MISMO traje...
          if (otherMod.isEnabled &&
              otherMod.directory.path != modInfo.directory.path &&
              otherMod.replacesOutfit == outfitToReplace) {
            conflictingMod = otherMod;
            break; // ¡Conflicto encontrado! Salimos del bucle.
          }
        }
      } catch (e) {
        // (En caso de que el bucle falle, aunque es poco probable)
        conflictingMod = null;
      }

      // Si se encontró un mod en conflicto, muestra un diálogo y detén la activación.
      if (conflictingMod != null) {
        final l10n = AppLocalizations.of(context)!;
        
        // Ahora el diálogo devuelve un booleano (true = forzar activación)
        // Obtenemos los nombres para usarlos como separadores
      final String outfitName = outfitToReplace;
      final String modName = conflictingMod.customName;
      
      // Obtenemos el texto completo de la localización
      final String fullString = l10n.dialogContentOutfitConflict(outfitName, modName);
      
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
              style: Theme.of(context).dialogTheme.contentTextStyle ?? const TextStyle(color: Colors.white, height: 1.5),
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
                      _hoverTimer = Timer(const Duration(milliseconds: 800), () {
                        if (mounted) {
                          _showPreviewOverlay(
                            context,
                            outfitName, // El nombre del traje
                            _cursorPosition,
                          );
                        }
                      });
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
          return; // Detiene la activación.
        }

        // Si el usuario SÍ forzó la activación, desactiva el mod conflictivo
        // antes de continuar con la activación del nuevo.
        await _disableMod(conflictingMod);
        // ++ FIN DE LA MODIFICACIÓN DEL DIÁLOGO ++
      }
    }
    setState(() => _isLoading = true);

    try {
      ModInfo updatedMod;

      // --- INICIO DE LÓGICA DE BIFURCACIÓN ---
      if (modInfo.modType == 'movies') {
        // LÓGICA DE REEMPLAZO (MOVIES)
        // ++ PASAMOS _allMods para que pueda resolver conflictos ++
        await _enableMovieMod(modInfo, _allMods);
        updatedMod = modInfo.copyWith(isEnabled: true); // Actualiza el estado local
      } else {
        // LÓGICA DE MOVIMIENTO DE CARPETA (CNS/GENÉRICO)
        final modName = p.basename(modInfo.directory.path);
        
        String modType = modInfo.modType ?? 'cns'; // Usa el tipo del ModInfo
        
        final String targetPath = (modType == 'genericPak') 
            ? _genericModsPath! 
            : _finalModsPath!;
        
        final newDirectory = Directory(p.join(targetPath, modName));
        await _moveMod(modInfo.directory, targetPath);
        
        updatedMod = modInfo.copyWith(
          directory: newDirectory,
          isEnabled: true,
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

  Future<void> _disableMod(ModInfo modInfo) async {
    if (_gameRootPath == null) return;
    setState(() => _isLoading = true);

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
        updatedMod = modInfo.copyWith(isEnabled: false); // Actualiza el estado local
      } else {
        // LÓGICA DE MOVIMIENTO DE CARPETA (CNS/GENÉRICO)
        final modName = p.basename(modInfo.directory.path);
        final newDirectory = Directory(p.join(backupDir.path, modName));

        await _moveMod(modInfo.directory, backupDir.path);

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
    } catch (e) {
      setState(() {
        _statusMessage = AppLocalizations.of(
          context,
        )!.errorDisableMod(e.toString());
        _statusColor = Colors.redAccent;
      });
      await _loadAllMods();
    } finally {
      setState(() => _isLoading = false);
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
    final List<String> replacedFiles = List<String>.from(data['replacedFiles'] ?? []);

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
      final otherInfoFile = File(p.join(otherMod.directory.path, 'nexus_info.json'));
      if (!await otherInfoFile.exists()) continue;
      
      try {
        final otherData = json.decode(await otherInfoFile.readAsString());
        final List<String> otherReplacedFiles = List<String>.from(otherData['replacedFiles'] ?? []);

        // Comprobamos si hay CUALQUIER solapamiento
        bool hasConflict = otherReplacedFiles.any((file) => filesToReplace.contains(file));

        if (hasConflict) {
          print("Disabling conflicting movie mod: ${otherMod.customName}");
          // Deshabilitamos el mod conflictivo (esto restaura la original)
          await _disableMovieMod(otherMod); 
          
          // Actualizamos su estado en la lista principal (_allMods)
          final modIndex = allMods.indexWhere((m) => m.directory.path == otherMod.directory.path);
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
    final List<String> replacedFiles = List<String>.from(data['replacedFiles'] ?? []);

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
        final infoFile = File(p.join(modInfo.directory.path, 'nexus_info.json'));
        if (await infoFile.exists() && _moviesBackupPath != null) {
          try {
            final data = json.decode(await infoFile.readAsString());
            final List<String> replacedFiles = List<String>.from(data['replacedFiles'] ?? []);
            for (final fileName in replacedFiles) {
              final backupFile = File(p.join(_moviesBackupPath!, '$fileName.bak'));
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

  Future<void> _enableAllMods(List<ModInfo> modsInView) async {
    final l10n = AppLocalizations.of(context)!;

    // ++ INICIO DE LA MODIFICACIÓN ++
    // 1. Obtenemos solo los mods deshabilitados QUE NO SEAN de tipo 'movies'.
    final disabledMods = modsInView.where((mod) => !mod.isEnabled && mod.modType != 'movies').toList();
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
        
        await _moveMod(mod.directory, targetPath);
        
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
          await _moveMod(mod.directory, backupDir.path);
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

  Future<bool> _deleteDirectoryWithRetry(
    Directory dir, {
    int retries = 3,
  }) async {
    for (int i = 0; i < retries; i++) {
      try {
        if (await dir.exists()) {
          await dir.delete(recursive: true);
        }
        return true;
      } on PathAccessException {
        print(
          'Access denied while deleting ${dir.path}. Retrying (${i + 1}/$retries)...',
        );
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
        _statusMessage = AppLocalizations.of(
          context,
        )!.errorOpenFolder(modDirectory.path);
        _statusColor = Colors.redAccent;
      });
    }
  }

  Future<void> _clearSelection({String? message, StateSetter? panelStateSetter}) async {
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
      _statusColor = message == null ? Colors.orangeAccent : Colors.orangeAccent;
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

                          final bool isValid = await _validateApiKey(
                            keyToValidate,
                          );

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

  // main.dart

  Future<ModInfo?> _showEditModNameDialog(ModInfo modInfo) async {
    final nameController = TextEditingController(text: modInfo.customName);
    final l10n = AppLocalizations.of(context)!;

    final newName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Use StatefulBuilder to manage dialog state
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: const Color(0xFF2a2a2a),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      l10n.dialogTitleEditModName,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      autofocus: true,
                      // Add onChanged to rebuild the dialog and update button states
                      onChanged: (value) => setDialogState(() {}),
                      decoration: InputDecoration(
                        labelText: l10n.dialogLabelNewName,
                        hintText: modInfo.customName,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(
                          // The button is disabled if the name is already the default
                          onPressed: nameController.text == modInfo.displayName
                              ? null
                              : () {
                                  // ++ LÍNEA CORREGIDA ++
                                  // This now updates the text and rebuilds the dialog
                                  setDialogState(
                                    () => nameController.text =
                                        modInfo.displayName,
                                  );
                                },
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
                              onPressed: () => Navigator.of(
                                context,
                              ).pop(nameController.text),
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
      },
    );

    if (newName != null && newName.trim().isNotEmpty) {
      return await _updateModCustomName(modInfo, newName.trim());
    }

    return null;
  }

  int _compareVersions(String v1, String v2) {
    try {
      final cleanV1 = v1.toLowerCase().replaceAll(RegExp(r'^[vV]'), '');
      final cleanV2 = v2.toLowerCase().replaceAll(RegExp(r'^[vV]'), '');

      List<String> parts1 = cleanV1.split('.');
      List<String> parts2 = cleanV2.split('.');

      int length = parts1.length > parts2.length
          ? parts1.length
          : parts2.length;

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
        'https://api.nexusmods.com/v1/games/stellarblade/mods/$nexusId.json',
      );
      var response = await http.get(modDetailsUrl, headers: headers);

      if (response.statusCode == 200) {
        final modDetails = json.decode(response.body);

        // --- INICIO DE LA CORRECCIÓN ---
        // Extraemos la información que necesitamos SIN modificarla.
        // Se guarda el HTML/BBCode original para que la UI lo procese correctamente.
        final pictureUrl = modDetails['picture_url'] as String?;
        String? summary = modDetails['summary'] as String?; // <-- SIN .replaceAll()
        if (summary != null) {
          // Replaces the HTML line break tag with a real newline character.
          summary = summary.replaceAll('<br />', '\n');
        }
        String? description = modDetails['description'] as String?; // <-- SIN .replaceAll()
        if (description != null) {
          // Replaces the HTML line break tag with a real newline character.
          description = description.replaceAll('<br />', '\n');
        }
        final author = modDetails['author'] as String?;
        // --- FIN DE LA CORRECCIÓN ---

        List<Map<String, dynamic>>? gallery;
        if (pictureUrl != null && pictureUrl.isNotEmpty) {
          gallery = [
            {"image": pictureUrl, "thumbnail": pictureUrl},
          ];
        }

        // Devolvemos un mapa con todos los datos en crudo.
        return {
          'gallery': gallery,
          'summary': summary,
          'author': author,
          'description': description
        };
      }

      print(
        "Failed to fetch Nexus data for mod $nexusId (code: ${response.statusCode}).",
      );
      return null;
    } catch (e) {
      print(
        "An exception occurred while fetching Nexus data for mod $nexusId: $e",
      );
      return null;
    }
  }

  Future<void> _updateNexusInfoFile(
    Directory modDirectory, {
    Map<String, dynamic>? updateCheckData,
    List<Map<String, dynamic>>? galleryData,
  }) async {
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
        "Could not read existing nexus_info.json, creating a new one. Error: $e",
      );
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
        futures.add(
          _checkSingleModUpdate(
            headers: headers,
            nexusId: _cnsNexusId!,
            localVersion: _cnsVersion ?? '0',
            hasLocalVersion: _cnsVersion != null,
            modName: "Custom Nanosuit System",
            modDirectory: Directory(
              p.join(_gameRootPath!, 'SB', 'Binaries', 'Win64', 'ue4ss'),
            ),
            displayName: '',
          ),
        );
      } else if (job.mod != null) {
        // Determina qué versión usar para la comprobación de actualizaciones.
        // Prioriza la 'customVersion' definida por el usuario.
        final String versionForCheck =
            job.mod!.customVersion != null && job.mod!.customVersion!.isNotEmpty
            ? job.mod!.customVersion!
            : job.mod!.localVersion ?? '0';

        // Se considera que una versión existe si la versión personalizada o la local están presentes.
        final bool hasVersionForCheck =
            (job.mod!.customVersion != null &&
                job.mod!.customVersion!.isNotEmpty) ||
            (job.mod!.localVersion != null &&
                job.mod!.localVersion!.isNotEmpty);

        futures.add(
          _checkSingleModUpdate(
            headers: headers,
            nexusId: job.mod!.nexusId!,
            localVersion: versionForCheck, // Usar la versión determinada
            hasLocalVersion: hasVersionForCheck, // Usar el nuevo booleano
            modName: job.mod!.customName,
            displayName: job.mod!.displayName,
            modDirectory: job.mod!.directory,
          ),
        );
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
      'https://api.nexusmods.com/v1/games/stellarblade/mods/$nexusId/files.json',
    );
    final response = await http.get(url, headers: headers);

    try {
      final updateCheckData = {
        'timestamp': DateTime.now().toIso8601String(),
        'statusCode': response.statusCode,
      };
      await _updateNexusInfoFile(
        modDirectory,
        updateCheckData: updateCheckData,
      );
    } catch (e) {
      print('Could not update nexus_info.json file for $modName: $e');
    }

    if (response.statusCode != 200) {
      print(
        'Error for mod $nexusId: ${response.statusCode} - ${response.body}',
      );
      return null;
    }

    final jsonResponse = json.decode(response.body);
    final allFiles = jsonResponse['files'] as List;
    final potentialFiles = allFiles
        .where(
          (file) =>
              file['category_name'] == 'MAIN' ||
              file['category_name'] == 'OPTIONAL',
        )
        .toList();

    final compatibleFiles = potentialFiles.where((file) {
      final fileName = (file['file_name'] as String).toLowerCase();
      return !fileName.contains('not cns') &&
          !fileName.contains('without cns') &&
          !fileName.contains('non cns');
    }).toList();

    if (compatibleFiles.isNotEmpty) {
      List<dynamic> filesToConsider;
      final cnsFiles = compatibleFiles
          .where(
            (file) =>
                (file['file_name'] as String).toLowerCase().contains('cns'),
          )
          .toList();

      filesToConsider = cnsFiles.isNotEmpty ? cnsFiles : compatibleFiles;
      dynamic bestMatchFile;

      //final modsWithSameId = _allMods.where((m) => m.nexusId == nexusId).length;
      if (filesToConsider.length == 1) {
        // Si solo hay un archivo candidato, lo tomamos directamente.
        bestMatchFile = filesToConsider.first;
      } else {
        // Si hay múltiples candidatos, usamos el sistema de puntuación para decidir.
        final normalizedDisplayName = _normalizeName(displayName);
        final keywords = displayName
            .toLowerCase()
            .split(RegExp(r'[_ -]'))
            .where((s) => s.isNotEmpty)
            .toList();

        final fileScores = filesToConsider.map((file) {
          final rawFileName = file['file_name'] as String;
          final normalizedFileName = _normalizeName(rawFileName);
          int score = 0;

          if (normalizedFileName.contains(normalizedDisplayName)) {
            score = 100;
          } else {
            for (final keyword in keywords) {
              if (normalizedFileName.contains(keyword)) {
                score++;
              }
            }
          }
          return {'file': file, 'score': score};
        }).toList();

        // Ordenamos la lista para que el archivo con la puntuación más alta quede primero.
        fileScores.sort(
          (a, b) => (b['score'] as int).compareTo(a['score'] as int),
        );

        // Tomamos el mejor candidato, pero solo si su puntuación es mayor que cero.
        if (fileScores.isNotEmpty && fileScores.first['score'] as int > 0) {
          bestMatchFile = fileScores.first['file'];
        }
      }
      // ++ FIN DE LA LÓGICA CORREGIDA ++

      // Ahora, solo si hemos encontrado un candidato válido, procedemos a la comprobación de versión.
      if (bestMatchFile != null) {
        final latestVersion = bestMatchFile['version'] as String;

        final skippedVersion = _skippedVersions[nexusId];
        final isSkipped =
            skippedVersion != null &&
            _compareVersions(latestVersion, skippedVersion) <= 0;

        // Comparamos la versión del MEJOR CANDIDATO con la versión local.
        if (hasLocalVersion &&
            !isSkipped &&
            _compareVersions(latestVersion, localVersion) > 0) {
          return {
            'version': latestVersion,
            'fileId': bestMatchFile['file_id'] as int,
          };
        }
      }
    }
    return null;
  }
  //Funcion comentada por el momento, puede ser util en un futuro.
  /*Future<void> _recheckSpecificMod(String nexusId, {String? newVersion}) async {
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
          p.join(_gameRootPath!, 'SB', 'Binaries', 'Win64', 'ue4ss'),
        ),
        displayName: '',
      );
      setState(() => _cnsUpdateInfo = updateInfo);
    } else {
      try {
        final modToRecheck = _allMods.firstWhere((m) => m.nexusId == nexusId);
        // Prioriza la versión para la nueva comprobación en este orden:
        // 1. Una nueva versión pasada explícitamente a la función.
        // 2. La versión personalizada del mod si existe.
        // 3. La versión local (automática) del mod.
        final versionToCheck =
            newVersion ??
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
            displayName: modToRecheck.displayName,
          ); // Pasar el displayName
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
  }*/

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
        .firstWhere((m) => m.nexusId == nexusId,
            orElse: () =>
                ModInfo(directory: Directory(''), customName: l10n.cnsCoreSystem, displayName: '', isEnabled: false, lastModified: DateTime.now()))
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
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                              ),
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
        final outfitMatch = (mod.replacesOutfit != null)
            ? mod.replacesOutfit!.toLowerCase().contains(query)
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

  Future<Map<String, dynamic>?> _showGeneralEditDialog(
    ModInfo modInfo,
    BuildContext context,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    final nameController = TextEditingController(text: modInfo.customName);
    final authorController = TextEditingController(
      text: modInfo.customAuthor ?? modInfo.author ?? '',
    );
    final String defaultUrl =
        modInfo.sourceUrl ??
        (modInfo.nexusId != null
            ? 'https://www.nexusmods.com/stellarblade/mods/${modInfo.nexusId}'
            : '');
    final urlController = TextEditingController(
      text: modInfo.customSourceUrl ?? defaultUrl,
    );

    File? newCoverFile;
    Alignment? newCoverAlignment;

    final updatedData = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final bool canResetName =
                nameController.text != modInfo.displayName;
            final bool canResetAuthor =
                authorController.text != (modInfo.author ?? '');
            final bool canResetUrl =
                urlController.text != (modInfo.sourceUrl ?? '');

            return AlertDialog(
              title: Text(l10n.editModTitle),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: nameController,
                              onChanged: (v) => setDialogState(() {}),
                              decoration: InputDecoration(
                                labelText: l10n.modNameLabel,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: !canResetName
                                ? null
                                : () => setDialogState(
                                    () => nameController.text =
                                        modInfo.displayName,
                                  ),
                            child: Text(l10n.dialogActionResetToDefault),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: authorController,
                              onChanged: (v) => setDialogState(() {}),
                              decoration: InputDecoration(
                                labelText: l10n.authorLabel,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: !canResetAuthor
                                ? null
                                : () => setDialogState(
                                    () => authorController.text =
                                        modInfo.author ?? '',
                                  ),
                            child: Text(l10n.dialogActionResetToDefault),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: urlController,
                              onChanged: (v) => setDialogState(() {}),
                              decoration: InputDecoration(
                                labelText: l10n.urlLabel,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: !canResetUrl
                                ? null
                                : () => setDialogState(
                                    () => urlController.text = defaultUrl,
                                  ),
                            child: Text(l10n.dialogActionResetToDefault),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (newCoverFile != null)
                        Image.file(newCoverFile!, height: 100),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.image_search),
                        label: Text(l10n.changeCoverButton),
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(
                                type: FileType.custom,
                                allowedExtensions: [
                                  'png',
                                  'jpg',
                                  'jpeg',
                                  'webp',
                                  'bmp',
                                  'pwebp',
                                  'tiff',
                                ],
                              );
                          if (result != null &&
                              result.files.single.path != null) {
                            final pickedFile = File(result.files.single.path!);
                            final alignment = await _showCoverAlignmentDialog(
                              pickedFile,
                            );
                            if (alignment != null) {
                              setDialogState(() {
                                newCoverFile = pickedFile;
                                newCoverAlignment = alignment;
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.dialogActionCancel),
                ),
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
          },
        );
      },
    );

    nameController.dispose();
    authorController.dispose();
    urlController.dispose();

    return updatedData;
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
                  icon: const Icon(
                    Icons.notification_important,
                    color: Colors.yellowAccent,
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
            icon: const Icon(Icons.cloud_sync_outlined),
            tooltip: l10n.checkForUpdates,
            onPressed: _isLoading || _isCheckingForUpdates
                ? null
                : _checkForUpdates,
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
                    onShowAboutDialog: _showAboutDialog,
                    onRunSelfHealing: _showSelfHealConfirmationDialog,
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
              final files = details.files.map((file) => File(file.path)).toList();
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
                                      style: const TextStyle(color: Colors.white70),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  LinearProgressIndicator(
                                    value: _metadataUpdateProgress,
                                    backgroundColor: Colors.grey[800],
                                    valueColor: const AlwaysStoppedAnimation<Color>(
                                      Colors.lightBlueAccent, // Color distintivo
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
                                      style: const TextStyle(color: Colors.white70),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  LinearProgressIndicator(
                                    value: null,
                                    backgroundColor: Colors.grey[800],
                                    valueColor: const AlwaysStoppedAnimation<Color>(
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
                          const Icon(
                            Icons.download_for_offline,
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
          ),
        ],
      ),
    );
  }


  // main.dart

  Widget _buildSelectionPreviewSection(
    AppLocalizations l10n, {
    required StateSetter panelStateSetter,
  }) {
    final modEntries = _modsToInstallPreviewMap.entries.toList();
    final _scrollController = ScrollController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        // --- CABECERA DE LA SECCIÓN ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              l10n.previewInstallTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.cancel_outlined, size: 20),
              label: Text(l10n.cancelSelection),
              onPressed: _isInstalling ? null : () => _clearSelection(panelStateSetter: panelStateSetter),
              style: TextButton.styleFrom(
                // Un estilo visual para cuando el botón está deshabilitado.
                disabledForegroundColor: Colors.redAccent.withOpacity(0.4),
                foregroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
        const Divider(height: 20, color: Colors.white24),

        // ++ INICIO DE LA MODIFICACIÓN ++
        // Contenedor que limita la altura máxima de la lista y le da un estilo.
        Container(
          constraints: const BoxConstraints(
            maxHeight: 280, // Altura máxima antes de que aparezca el scroll
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Scrollbar( // Añade una barra de scroll visible
          controller: _scrollController,
          thumbVisibility: true,
            child: SingleChildScrollView( // Hace que el contenido sea desplazable
            controller: _scrollController,
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: List.generate(modEntries.length, (index) {
                  final entry = modEntries[index];
                  final folderName = entry.key;
                  final files = entry.value;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // -- Nombre del Mod --
                        Row(
                          children: [
                            Icon(
                              Icons.folder_zip_outlined,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                folderName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // -- Lista de Archivos Anidada --
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: files.map((file) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.insert_drive_file_outlined,
                                      size: 14,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        file,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[300],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        
                        // -- Separador (ajustado para no tener padding extra al final) --
                        if (index < modEntries.length - 1)
                          const Divider(height: 24, color: Colors.white10),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
        // ++ FIN DE LA MODIFICACIÓN ++
      ],
    );
  }

  Widget _buildModGridCard(ModInfo modInfo, AppLocalizations l10n) {
    String? coverImagePath;
    // 1. Prioriza la ruta de la portada personalizada (que ahora incluye nuestra imagen cacheada).
    if (modInfo.customCoverPath != null && modInfo.customCoverPath!.isNotEmpty) {
      coverImagePath = p.join(modInfo.directory.path, modInfo.customCoverPath!);
    } 
    // 2. Si no hay, recurre a la URL de internet de la galería.
    else if (modInfo.gallery != null && modInfo.gallery!.isNotEmpty) {
      coverImagePath = modInfo.gallery!.first['thumbnail'] as String?;
    }

    final updateInfo = _modUpdates[modInfo.directory.path];
    final hasUpdate = updateInfo != null;
    final updateIdentifier = hasUpdate
        ? modInfo.directory.path + updateInfo['version']
        : '';
    final isIgnored = _ignoredUpdates.contains(updateIdentifier);
    final isHighlighted = _lastInstalledModNames.contains(
      p.basename(modInfo.directory.path),
    );
    final hasCustomCover =
        modInfo.customCoverPath != null && modInfo.customCoverPath!.isNotEmpty;
    if (hasCustomCover) {
      p.join(modInfo.directory.path, modInfo.customCoverPath!);
    }
    final displayVersion = modInfo.customVersion ?? modInfo.localVersion;
    final bool isReplacement = modInfo.replacesOutfit != null && modInfo.replacesOutfit!.isNotEmpty;
    // La etiqueta ahora es el traje (si es un reemplazo) o la etiqueta personalizada/original (si no lo es)
    final String displayTag = isReplacement 
        ? modInfo.replacesOutfit! 
        : (modInfo.customFitMeshType ?? modInfo.fitMeshType ?? l10n.modCategoryOther);

    void _performSurgicalUpdate(ModInfo? updatedMod) {
      if (updatedMod == null) return;
      final modIndex = _allMods.indexWhere(
        (m) => m.directory.path == updatedMod.directory.path,
      );
      if (modIndex != -1) {
        setState(() {
          _allMods[modIndex] = updatedMod;
        });
      }
    }

    return Card(
      key: ValueKey(modInfo.directory.path), // Usa una clave consistente
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
            child: InkWell(
              onTap: () => _showDetailsPage(modInfo),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    // Ahora usamos un único widget que maneja tanto imágenes locales como de red.
                    child: ModThumbnailImage(
                      imageUrl: coverImagePath,
                      thumbnailService: _thumbnailService,
                      // La propiedad 'isLocal' se determina dinámicamente.
                      isLocal: coverImagePath != null && !coverImagePath.startsWith('http'),
                      fit: BoxFit.cover,
                      // La alineación se aplica aquí para las imágenes locales.
                      alignment: modInfo.customCoverAlignment ?? Alignment.center,
                    ),
                  ),
                  //if (!modInfo.isEnabled)
                    Positioned(
                    top: 8,
                    right: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // 1. Muestra "Disabled" SÓLO si está deshabilitado
                        if (!modInfo.isEnabled)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orangeAccent.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              l10n.modDisabledBadge,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        
                        // 2. Muestra un espacio SÓLO si está deshabilitado (para separar las etiquetas)
                        if (!modInfo.isEnabled)
                          const SizedBox(height: 4),

                        // 3. Muestra SIEMPRE la etiqueta de Tipo (CNS/Genérico)
                        _buildModTypeBadge(modInfo, l10n),
                      ],
                    ),
                  ),
                  if (hasUpdate && !isIgnored)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: IconButton(
                        icon: const Icon(
                          Icons.notification_important_rounded,
                          color: Colors.yellowAccent,
                        ),
                        tooltip: l10n.updateAvailable(
                          (updateInfo['version'] as String)
                                  .toLowerCase()
                                  .startsWith('v')
                              ? (updateInfo['version'] as String).substring(1)
                              : updateInfo['version'],
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
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (displayVersion != null)
                  InkWell(
                    onTap: () async {
                      final updatedMod = await _showEditDialog(
                        context: context,
                        title: l10n.editVersionText,
                        label: l10n.customVersionText,
                        initialValue: displayVersion,
                        defaultValue: modInfo.localVersion ?? '',
                        maxLength: 15,
                        onSave: (newValue) => _updateModCustomProperty(
                          modInfo,
                          newVersion: newValue,
                        ),
                      );
                      _performSurgicalUpdate(updatedMod);
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 2.0,
                      ),
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
                  child: Listener( // ++ 1. AÑADIR LISTENER ++
                    onPointerMove: (event) {
                      // Actualiza la posición del cursor continuamente
                      // Usamos la posición global para el Overlay
                      _cursorPosition = event.position;
                    },
                    child: MouseRegion(
                      // ++ 2. MODIFICAR onEnter ++
                      onEnter: (event) {
                        if (isReplacement) {
                          // Guarda la posición inicial
                          _cursorPosition = event.position;
                          // Cancela cualquier temporizador pendiente
                          _hoverTimer?.cancel();
                          // Inicia un nuevo temporizador de 800 milisegundos
                          _hoverTimer = Timer(const Duration(milliseconds: 800), () {
                            // Al completarse, muestra el overlay en la última posición guardada
                            if (mounted) {
                              _showPreviewOverlay(
                                context,
                                modInfo.replacesOutfit!,
                                _cursorPosition,
                              );
                            }
                          });
                        }
                      },
                      // ++ 3. MODIFICAR onExit ++
                      onExit: (_) {
                        // Al salir, oculta todo (cancela el temporizador y quita el overlay)
                        _hidePreviewOverlay();
                      },
                      child: InkWell(
                        onTap: isReplacement ? null : () async {
                          final updatedMod = await _showEditDialog(
                            context: context,
                            title: l10n.editTagText,
                            label: l10n.customTagText,
                            initialValue: displayTag, // 'displayTag' ya tiene el valor correcto
                            defaultValue:
                                modInfo.fitMeshType ?? l10n.modCategoryOther,
                            onSave: (newValue) =>
                                _updateModCustomProperty(modInfo, newTag: newValue),
                          );
                          _performSurgicalUpdate(updatedMod);
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: isReplacement 
                                ? Colors.black.withOpacity(0.4) 
                                : Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row( 
                            mainAxisSize: MainAxisSize.min, // Para que el icono no empuje el texto
                            children: [
                              if (isReplacement)
                                Icon(
                                  Icons.checkroom_outlined, 
                                  size: 10, 
                                  color: Colors.purpleAccent.shade100, // Color distintivo
                                ),
                              if (isReplacement)
                                const SizedBox(width: 4),
                              Flexible( // El texto debe ser flexible para los "..."
                                child: Text(
                                  displayTag, // 'displayTag' ya tiene el nombre del traje
                                  style: TextStyle(
                                    fontSize: 10,
                                    // (Opcional) Color diferente para el texto del traje
                                    color: isReplacement 
                                      ? const Color.fromARGB(255, 153, 151, 153) 
                                      : Colors.white70,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                        if (value == 'edit') {
                          final updatedMod = await _showEditModNameDialog(
                            modInfo,
                          );
                          // ++ LÓGICA DE ACTUALIZACIÓN AQUÍ ++
                          _performSurgicalUpdate(updatedMod);
                        } else {
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
                                final url = Uri.parse(
                                  'https://www.nexusmods.com/stellarblade/mods/${modInfo.nexusId}',
                                );
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                }
                              }
                              break;
                            case 'delete':
                              _deleteModPermanently(modInfo);
                              break;
                          }
                        }
                      },
                      // ++ INICIO DE LA CORRECCIÓN ++
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              const Icon(Icons.edit_outlined, size: 20),
                              const SizedBox(width: 12),
                              Flexible(child: Text(l10n.editModNameTooltip)),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'set_cover',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Flexible(child: Text(l10n.setCoverTooltip)),
                            ],
                          ),
                        ),
                        if (modInfo.customCoverPath != null &&
                            modInfo.customCoverPath!.isNotEmpty)
                          PopupMenuItem(
                            value: 'revert_cover',
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.photo_filter_outlined,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: Text(l10n.restoreOriginalCoverText),
                                ),
                              ],
                            ),
                          ),
                        PopupMenuItem(
                          value: 'folder',
                          child: Row(
                            children: [
                              const Icon(Icons.folder_open_outlined, size: 20),
                              const SizedBox(width: 12),
                              Flexible(child: Text(l10n.showInFolder)),
                            ],
                          ),
                        ),
                        if (modInfo.nexusId != null)
                          PopupMenuItem(
                            value: 'gallery',
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.photo_library_outlined,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Flexible(child: Text(l10n.viewImageGallery)),
                              ],
                            ),
                          ),
                        if (modInfo.nexusId != null)
                          PopupMenuItem(
                            value: 'nexus',
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.open_in_browser_outlined,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Flexible(child: Text(l10n.openInNexusMods)),
                              ],
                            ),
                          ),
                        if (!modInfo.isEnabled) const PopupMenuDivider(),
                        if (!modInfo.isEnabled)
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.delete_forever_outlined,
                                  size: 20,
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: Text(
                                    l10n.deletePermanently,
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                      // ++ FIN DE LA CORRECCIÓN ++
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Construye el widget de la etiqueta de Tipo de Mod (CNS, Genérico o Movies).
  Widget _buildModTypeBadge(ModInfo mod, AppLocalizations l10n) {
    final String modTypeString;
    final Color modTypeColor;

    // 2. LÓGICA MEJORADA
    final String? modType = mod.modType;

    if (modType == 'replacement') {
      modTypeString = l10n.modTypeReplacement; // "Reemplazo"
      modTypeColor = const Color.fromARGB(255, 182, 33, 135); // Color para "Reemplazo"
    } else if (modType == 'genericPak') {
      modTypeString = l10n.modTypeGeneric; // "Genérico"
      modTypeColor = const Color.fromARGB(255, 23, 86, 175); // Color para "Generic"
    } else if (modType == 'movies') {
      modTypeString = l10n.modTypeMovies; // "Películas"
      modTypeColor = const Color.fromARGB(255, 153, 49, 49); // Color para "Movies"
    } else {
      // Esto ahora solo se aplica a 'cns' y a mods antiguos (null)
      modTypeString = l10n.modTypeCNS; // "CNS"
      modTypeColor = Colors.teal.shade600; // Color para "CNS"
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: modTypeColor.withOpacity(0.9), // Usar el color dinámico
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        modTypeString, // Usar el texto dinámico
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildModListTile(ModInfo modInfo, AppLocalizations l10n) {
    final isHighlighted = _lastInstalledModNames.contains(
      p.basename(modInfo.directory.path),
    );
    final updateInfo = _modUpdates[modInfo.directory.path];
    final hasUpdate = updateInfo != null;
    final updateIdentifier = hasUpdate
        ? modInfo.directory.path + updateInfo['version']
        : '';
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
          width: hasUpdate && !isIgnored ? 2.0 : 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        visualDensity: VisualDensity.compact,
        leading: Icon(
          Icons.extension,
          color: modInfo.isEnabled ? Colors.tealAccent : Colors.grey,
        ),
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
                child: Icon(
                  Icons.new_releases,
                  color: Colors.yellow[700],
                  size: 18,
                ),
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
                onPressed: _isLoading
                    ? null
                    : () => _deleteModPermanently(modInfo),
                tooltip: l10n.deletePermanently,
              ),
            if (hasUpdate && !isIgnored)
              IconButton(
                icon: const Icon(
                  Icons.notification_important,
                  color: Colors.yellowAccent,
                ),
                tooltip: l10n.updateAvailable(
                  (updateInfo['version'] as String).toLowerCase().startsWith(
                        'v',
                      )
                      ? (updateInfo['version'] as String).substring(1)
                      : updateInfo['version'],
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
              onPressed: _isLoading
                  ? null
                  : () => _showEditModNameDialog(modInfo),
              tooltip: l10n.editModNameTooltip,
            ),
            IconButton(
              icon: const Icon(Icons.folder_open, color: Colors.white70),
              onPressed: _isLoading
                  ? null
                  : () => _showInExplorer(modInfo.directory),
              tooltip: l10n.showInFolder,
            ),
            if (modInfo.nexusId != null)
              IconButton(
                icon: const Icon(
                  Icons.photo_library_outlined,
                  color: Colors.purpleAccent,
                ),
                onPressed: () => _showImageGalleryDialog(modInfo),
                tooltip: l10n.viewImageGallery,
              ),
            if (modInfo.nexusId != null)
              IconButton(
                icon: const Icon(Icons.open_in_browser_outlined, color: Colors.lightBlueAccent),
                onPressed: () async {
                  final url = Uri.parse(
                    'https://www.nexusmods.com/stellarblade/mods/${modInfo.nexusId}',
                  );
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                tooltip: l10n.openInNexusMods,
              ),
            if (modInfo.isEnabled)
              IconButton(
                icon: const Icon(
                  Icons.power_settings_new,
                  color: Colors.orangeAccent,
                ),
                onPressed: _isLoading ? null : () => _disableMod(modInfo),
                tooltip: l10n.disableMod,
              )
            else
              IconButton(
                icon: const Icon(
                  Icons.power_settings_new,
                  color: Colors.greenAccent,
                ),
                onPressed: _isLoading ? null : () => _enableMod(modInfo),
                tooltip: l10n.enableMod,
              ),
          ],
        ),
      ),
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
              icon: const Icon(Icons.add_circle_outline_outlined),
              label: Text(l10n.installNewMod), // Asegúrate de tener esta traducción
              onPressed: _showInstallationPanel, // Este método lo crearemos a continuación
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
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
                      child: Icon(Icons.grid_view_outlined, size: 20),
                    ),
                    Tooltip(
                      message: l10n.viewTypeList,
                      child: Icon(Icons.view_list_outlined, size: 20),
                    ),
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
                          if (_finalModsPath != null) {
                            _showInExplorer(Directory(_finalModsPath!));
                          }
                        },
                  tooltip: l10n.openModsFolder,
                ),
                IconButton(
                  icon: Icon(
                    Icons.power_outlined,
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
                  icon: Icon(
                    Icons.power_off_outlined,
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
                  icon: Icon(
                    Icons.delete_sweep_outlined,
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
                  icon: const Icon(Icons.refresh),
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
                child: SingleChildScrollView( // Permite scroll horizontal en ventanas pequeñas
                  scrollDirection: Axis.horizontal,
                  child: ToggleButtons(
                    isSelected: ModTypeFilter.values
                        .map((type) => type == _currentModTypeFilter)
                        .toList(),
                    onPressed: (index) async {
                      final newTypeFilter = ModTypeFilter.values[index];
                      final prefs = await SharedPreferences.getInstance();
                      // Guardamos la nueva preferencia
                      await prefs.setInt(AppPrefs.modTypeFilterMode, newTypeFilter.index); 
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
                    containerSize = Size(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    );

                    final fittedSizes = applyBoxFit(
                      BoxFit.contain,
                      imageSize,
                      containerSize!,
                    );
                    scaledImageSize = fittedSizes.destination;

                    const cardAspectRatio =
                        3 / 4.2; // La proporción que ajustaste

                    // ✅ SOLUCIÓN: Asignamos valores a las variables superiores (sin 'double' al inicio).
                    if ((scaledImageSize!.width / scaledImageSize!.height) >
                        cardAspectRatio) {
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
                      Rect.fromLTWH(
                        0,
                        0,
                        containerSize!.width,
                        containerSize!.height,
                      ),
                    );

                    final minDx =
                        cropRect.right -
                        (initialImageRect!.left + scaledImageSize!.width);
                    final maxDx = cropRect.left - initialImageRect!.left;
                    final minDy =
                        cropRect.bottom -
                        (initialImageRect!.top + scaledImageSize!.height);
                    final maxDy = cropRect.top - initialImageRect!.top;

                    return GestureDetector(
                      onPanUpdate: (details) {
                        setDialogState(() {
                          offset = Offset(
                            (offset.dx + details.delta.dx).clamp(
                              min(minDx, maxDx),
                              max(minDx, maxDx),
                            ),
                            (offset.dy + details.delta.dy).clamp(
                              min(minDy, maxDy),
                              max(minDy, maxDy),
                            ),
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
                    if (scaledImageSize == null ||
                        initialImageRect == null ||
                        cropWidth == null ||
                        cropHeight == null)
                      return;

                    final extraWidth = scaledImageSize!.width - cropWidth!;
                    final extraHeight = scaledImageSize!.height - cropHeight!;

                    final centerOffset = offset;

                    final alignmentX = extraWidth > 0
                        ? (centerOffset.dx / (extraWidth / 2)) * -1
                        : 0.0;
                    final alignmentY = extraHeight > 0
                        ? (centerOffset.dy / (extraHeight / 2)) * -1
                        : 0.0;

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
    if (mod.customCoverPath == null || mod.customCoverPath!.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final infoFile = File(p.join(mod.directory.path, 'nexus_info.json'));
      if (!await infoFile.exists()) {
        throw Exception("nexus_info.json not found.");
      }

      // --- START: NEW SMART REVERT LOGIC ---

      // 1. Delete the current custom cover file, but ONLY if it's NOT the cached nexus file.
      final currentCoverFile = File(p.join(mod.directory.path, mod.customCoverPath!));
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

  /// Consulta la API de Nexus para verificar si un ID de mod es válido para Stellar Blade.
  Future<bool> _isValidNexusId(String modId) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      return false; // No se puede validar sin una API key.
    }
    try {
      final uri = Uri.parse(
        'https://api.nexusmods.com/v1/games/stellarblade/mods/$modId.json',
      );
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
    final updateIdentifier = hasUpdate ? modInfo.directory.path + (updateInfo['version'] as String) : '';
    final isIgnored = _ignoredUpdates.contains(updateIdentifier);
    // ++ FIN DE LA MODIFICACIÓN ++

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ModDetailsPanel(
        initialModInfo: modInfo,
        thumbnailService: _thumbnailService,
        onUpdateDetails: _updateModDetails,
        onShowInExplorer: _showInExplorer,
        onShowImageGallery: _showImageGalleryDialog,
        onShowGeneralEditDialog: _showGeneralEditDialog,
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

  /// Muestra un diálogo para editar un valor de texto personalizado (versión o etiqueta).
  Future<ModInfo?> _showEditDialog({
    required BuildContext context,
    required String title,
    required String label,
    required String initialValue,
    required String defaultValue,
    required Future<ModInfo?> Function(String) onSave,
    int? maxLength,
  }) async {
    final controller = TextEditingController(text: initialValue);
    final l10n = AppLocalizations.of(context)!;

    final newValue = await showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final bool isCurrentlyDefault = controller.text == defaultValue;
            return AlertDialog(
              title: Text(title),
              content: TextField(
                controller: controller,
                autofocus: true,
                maxLength: maxLength,
                onChanged: (value) =>
                    setDialogState(() {}), // Rebuild on text change
                decoration: InputDecoration(labelText: label),
              ),
              actions: [
                TextButton(
                  onPressed: isCurrentlyDefault
                      ? null
                      : () {
                          // ++ LÍNEA CORREGIDA ++
                          // This now updates the text and rebuilds the dialog
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
                  onPressed: () => Navigator.of(context).pop(controller.text),
                  child: Text(l10n.dialogActionSave),
                ),
              ],
            );
          },
        );
      },
    );

    controller.dispose();

    if (newValue != null) {
      return await onSave(newValue);
    }

    return null;
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

      if (newData.containsKey('replacesOutfit')) {
        final String? newOutfit = newData['replacesOutfit'] as String?;

        // 1. Comprobamos solo si se está ASIGNANDO un nuevo traje (no si se está borrando)
        if (newOutfit != null && newOutfit.isNotEmpty) {
          ModInfo? conflictingMod;
          try {
            // 2. Buscamos en todos los mods
            for (final otherMod in _allMods) {
              // Si el 'otro mod' está habilitado,
              // no es el mismo mod que intentamos editar,
              // y reemplaza el MISMO traje...
              if (otherMod.isEnabled &&
                  otherMod.directory.path != mod.directory.path &&
                  otherMod.replacesOutfit == newOutfit) {
                conflictingMod = otherMod;
                break; // ¡Conflicto encontrado!
              }
            }
          } catch (e) {
            conflictingMod = null;
          }

          // 3. Si se encontró un mod en conflicto, muestra el diálogo de elección.
          if (conflictingMod != null && mod.isEnabled) {
            final String outfitName = newOutfit;
            final String modName = conflictingMod.customName;
            
            // Obtenemos el texto completo de la localización
            final String fullString = l10n.dialogContentOutfitConflict(outfitName, modName);
            
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
                    style: Theme.of(context).dialogTheme.contentTextStyle ?? const TextStyle(color: Colors.white, height: 1.5),
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
                            _hoverTimer = Timer(const Duration(milliseconds: 800), () {
                              if (mounted) {
                                _showPreviewOverlay(
                                  context,
                                  outfitName, // El nombre del traje
                                  _cursorPosition,
                                );
                              }
                            });
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
                    child: Text(l10n.dialogActionActivateAndDisable), // Reutilizamos el l10n
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

      String? newNexusId; // Para almacenar un nuevo ID y usarlo para cachear la miniatura
      if (newData.containsKey('customSourceUrl')) {
        final newUrl = newData['customSourceUrl'] as String;
        final potentialNexusId = _extractNexusIdFromUrl(newUrl);
        final oldNexusId = data['nexusId'] as String?;

        // Comprueba si es una URL de Nexus válida, nueva y diferente a la que ya teníamos
        if (potentialNexusId != null && potentialNexusId != oldNexusId) {
          print('Nuevo Nexus ID $potentialNexusId detectado. Obteniendo metadatos...');
          // Si es así, obtenemos los datos de la API
          final nexusData = await _fetchNexusModData(potentialNexusId);

          if (nexusData != null) {
            newNexusId = potentialNexusId; // Guardamos el ID para cachear la miniatura más tarde
            
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
            newData.remove('author'); // El diálogo 'General Edit' también envía 'author'
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
        final originalDescriptionStripped =
            _ModDetailsPanelState()._stripHtml(mod.description);
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

      if (newData.containsKey('replacesOutfit')) {
        final value = newData['replacesOutfit'] as String?;
        if (value == null || value.isEmpty) {
          // Si el valor es nulo o vacío, lo eliminamos
          data.remove('replacesOutfit');
        } else {
          // Si hay un valor, lo guardamos
          data['replacesOutfit'] = value;
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
        await _cacheNexusThumbnail(modDirectory: modDirectory, nexusId: newNexusId);
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
        replacesOutfit: data['replacesOutfit'],
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

  Future<String?> _getVersionFromCnsPackage(Directory sourceSBDir) async {
    try {
      final luaFile = File(
        p.join(
          sourceSBDir.path,
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
          return match.group(1);
        }
      }
    } catch (e) {
      print("No se pudo leer la versión del paquete CNS: $e");
    }
    return null;
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
  void _showPreviewOverlay(BuildContext context, String outfitName, Offset position) {
    // Oculta cualquier overlay anterior
    _hidePreviewOverlay();

    _previewOverlay = OverlayEntry(
      builder: (context) => Positioned(
        // Posiciona el overlay ligeramente abajo y a la derecha del cursor
        // para que el cursor no lo tape.
        left: position.dx - 50,
        top: position.dy - 220,
        child: IgnorePointer( // Evita que el overlay bloquee clics
          child: Opacity(
            opacity: 1, // 100% de opacidad (totalmente visible)
            child: SizedBox(
              // Tamaño de la vista previa (sin borde)
              width: 100, 
              height: 211,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0), // Un leve redondeo
                child: Image.asset(
                  _generateOutfitImagePath(outfitName), // Reutiliza la función existente
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    // Placeholder en caso de error
                    color: Colors.black.withOpacity(0.5),
                    child: const Icon(
                      Icons.hide_image_outlined,
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

class ModImage extends StatelessWidget {
  final String imageUrl;
  final bool isLocal;
  final DateTime? lastModified;
  final BoxFit fit;
  final double? height;

  const ModImage({
    super.key,
    required this.imageUrl,
    this.isLocal = false,
    this.lastModified,
    this.fit = BoxFit.cover,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // Si la imagen es local (un archivo del sistema)
    if (isLocal) {
      return Image.file(
        File(imageUrl),
        key: ValueKey(lastModified), // Ayuda a recargar la imagen si cambia
        height: height,
        width: double.infinity,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 50, color: Colors.grey),
      );
    }
    // Si la imagen es de una URL (Nexus Mods)
    return Image.network(
      imageUrl,
      height: height,
      width: double.infinity,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.broken_image, size: 50, color: Colors.grey),
    );
  }
}

// ++ NEW WIDGET FOR OPTIMIZED THUMBNAILS ++
class ModThumbnailImage extends StatefulWidget {
  final String? imageUrl;
  final ThumbnailService thumbnailService;
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool isLocal;
  final Alignment alignment;

  const ModThumbnailImage({
    super.key,
    required this.imageUrl,
    required this.thumbnailService,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.isLocal = false, // Las imágenes de Nexus no son locales por defecto
    this.alignment = Alignment.center,
  });

  @override
  State<ModThumbnailImage> createState() => _ModThumbnailImageState();
}

class _ModThumbnailImageState extends State<ModThumbnailImage> {
  File? _imageFile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(covariant ModThumbnailImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageUrl != oldWidget.imageUrl) {
      _loadImage();
    }
  }

  void _loadImage() async {
    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    // Si es una imagen local, simplemente la usamos
    if (widget.isLocal) {
      _imageFile = File(widget.imageUrl!);
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    // Si es de red, usamos el servicio de caché
    setState(() => _isLoading = true);
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2.0));
    }

    if (_imageFile != null && _imageFile!.existsSync()) {
      return Image.file(
        _imageFile!,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        alignment: widget.alignment,
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.black26,
      child: const Icon(Icons.extension, size: 60, color: Colors.white38),
    );
  }
}

class CropOverlayPainter extends CustomPainter {
  final Rect cropRect;

  CropOverlayPainter({required this.cropRect});

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = Colors.black.withOpacity(0.6);
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

class _ModDetailsPanel extends StatefulWidget {
  final ModInfo initialModInfo;
  final ThumbnailService thumbnailService;
  // Funciones que necesita del widget principal
  final Future<ModInfo?> Function(ModInfo, Map<String, dynamic>)
  onUpdateDetails;
  final Future<void> Function(Directory) onShowInExplorer;
  final void Function(ModInfo) onShowImageGallery;
  final Future<Map<String, dynamic>?> Function(ModInfo, BuildContext)
  onShowGeneralEditDialog;
  final Function(ModInfo?) onPanelClosed;
  // Nuevas propiedades para gestionar la información de la actualización.
  final Map<String, dynamic>? updateInfo;
  final bool isIgnored;
  final Future<bool> Function({
    required String newVersion,
    required String nexusId,
    required int fileId,
    required String uniqueIdentifier,
  }) onShowUpdateDialog;

  const _ModDetailsPanel({
    required this.initialModInfo,
    required this.thumbnailService,
    required this.onUpdateDetails,
    required this.onShowInExplorer,
    required this.onShowImageGallery,
    required this.onShowGeneralEditDialog,
    required this.onPanelClosed,
    // Añadimos los nuevos parámetros al constructor.
    this.updateInfo,
    required this.isIgnored,
    required this.onShowUpdateDialog,
  });

  @override
  State<_ModDetailsPanel> createState() => _ModDetailsPanelState();
}

class _ModDetailsPanelState extends State<_ModDetailsPanel> {
  late ModInfo currentModInfo;
  bool _isTranslating = false;
  bool _showTranslateSummaryButton = false;
  bool _showTranslateDescriptionButton = false;
  bool _needsReloadOnClose = false;
  late bool _isIgnored;
  late bool _isReplacementMod;

  @override
  void initState() {
    super.initState();
    currentModInfo = widget.initialModInfo;
    _isIgnored = widget.isIgnored;
    _isReplacementMod = currentModInfo.modType == 'replacement' ||
        (currentModInfo.modType == 'genericPak' &&
            (currentModInfo.replacesOutfit != null &&
                currentModInfo.replacesOutfit!.isNotEmpty));
    // Comprueba si se puede traducir tan pronto como el widget se renderiza por primera vez.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateTranslationButtonVisibility();
    });
  }
  /// Limpia una cadena de texto de las etiquetas HTML más comunes.
  String _stripHtml(String? htmlString) {
    if (htmlString == null) return '';
    // Reemplaza saltos de línea y párrafos por fines de línea.
    final withLineBreaks = htmlString
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</li>', caseSensitive: false), '')
        .replaceAll(RegExp(r'</p>', caseSensitive: false), '');
    // Reemplaza los elementos de lista por un guion.
    final withListItems = withLineBreaks.replaceAll(
        RegExp(r'<li>', caseSensitive: false), '- ');
    // Elimina todas las demás etiquetas.
    final withoutTags = withListItems.replaceAll(RegExp(r'<[^>]*>'), '');
    // Decodifica las entidades HTML más comunes.
    final decoded = withoutTags
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ');
        
    // ++ LÍNEA AÑADIDA ++
    // Colapsa tres o más saltos de línea en solo dos, eliminando renglones vacíos excesivos.
    final cleanedNewlines = decoded.replaceAll(RegExp(r'(\n\s*){2,}'), '\n');

    return cleanedNewlines.trim();
  }

  /// El método dispose() se llama AUTOMÁTICAMENTE cuando el widget se va a destruir.
  // Es el lugar perfecto para nuestra lógica de cierre.
  @override
  void dispose() {
    // Llama al "mensajero" y le entrega el mod actualizado si hubo cambios.
    widget.onPanelClosed(_needsReloadOnClose ? currentModInfo : null);
    super.dispose();
  }

  Future<bool> _checkIfTextNeedsTranslation(String? text) async {
    if (!mounted) return false;
    if (text == null || text.trim().isEmpty) {
      return false;
    }

    final String currentLocale = Localizations.localeOf(context).languageCode;
    try {
      final translator = GoogleTranslator();
      // Usamos un fragmento para no enviar textos enormes a la API de detección
      final snippet = text.length > 150 ? text.substring(0, 150) : text;
      const String pivotLocale = 'de'; // Idioma pivote para forzar la detección
      final translation = await translator.translate(snippet, to: pivotLocale);
      final detectedLanguageCode = translation.sourceLanguage.code.toLowerCase();

      // Necesita traducción si el idioma detectado no es el de la app y no es "auto"
      return detectedLanguageCode != currentLocale && detectedLanguageCode != 'auto';
    } catch (e) {
      print("Error detectando el idioma: $e");
      return false;
    }
  }

  /// Comprueba ambos campos (resumen y descripción) y actualiza la visibilidad de sus botones.
  Future<void> _updateTranslationButtonVisibility() async {
    // --- Lógica para el botón del RESUMEN ---
    // Solo mostramos el botón si estamos viendo el resumen original (no uno personalizado).
    final isShowingOriginalSummary = currentModInfo.customSummary == null || currentModInfo.customSummary!.isEmpty;
    if (isShowingOriginalSummary) {
      final needsTranslation = await _checkIfTextNeedsTranslation(currentModInfo.summary);
      if (mounted) {
        setState(() => _showTranslateSummaryButton = needsTranslation);
      }
    } else {
       if (mounted) {
        setState(() => _showTranslateSummaryButton = false);
      }
    }

    // --- Lógica para el botón de la DESCRIPCIÓN ---
    // Solo mostramos el botón si estamos viendo la descripción original.
    final isShowingOriginalDescription = currentModInfo.customDescription == null || currentModInfo.customDescription!.isEmpty;
     if (isShowingOriginalDescription) {
      final needsTranslation = await _checkIfTextNeedsTranslation(currentModInfo.description);
      if (mounted) {
        setState(() => _showTranslateDescriptionButton = needsTranslation);
      }
    } else {
       if (mounted) {
        setState(() => _showTranslateDescriptionButton = false);
      }
    }
  }

  // Traduce el resumen
  Future<void> _translateSummary() async {
    final l10n = AppLocalizations.of(context)!;
    if (currentModInfo.summary == null || currentModInfo.summary!.trim().isEmpty) return;

    setState(() => _isTranslating = true);

    try {
      final translator = GoogleTranslator();
      final currentLocale = Localizations.localeOf(context).languageCode;
      final translation = await translator.translate(
        _stripHtml(currentModInfo.summary!), // Limpiamos el HTML antes de traducir
        from: 'auto',
        to: currentLocale,
      );

      // Guardamos la traducción en el campo personalizado 'summary' (que en la función onUpdateDetails se mapea a 'customSummary')
      final updatedMod = await widget.onUpdateDetails(currentModInfo, {
        'summary': translation.text,
      });

      if (updatedMod != null && mounted) {
        setState(() {
          currentModInfo = updatedMod;
          // ++ CAMBIO 3: Ocultar solo el botón del resumen ++
          _showTranslateSummaryButton = false; 
          _needsReloadOnClose = true;
        });
      }
    } catch (e) {
      NotificationService.instance.show(
        context: context,
        type: NotificationType.error,
        title: l10n.errorTranslation,
        description: e.toString(),
      );
    } finally {
      if (mounted) setState(() => _isTranslating = false);
    }
  }

  // Traduce la descripción
  Future<void> _translateDescription() async {
    final l10n = AppLocalizations.of(context)!;
    if (currentModInfo.description == null || currentModInfo.description!.trim().isEmpty) return;

    setState(() => _isTranslating = true);

    try {
      final translator = GoogleTranslator();
      final currentLocale = Localizations.localeOf(context).languageCode;
      final translation = await translator.translate(
        _stripHtml(currentModInfo.description!), // Limpiamos el HTML
        from: 'auto',
        to: currentLocale,
      );

      final updatedMod = await widget.onUpdateDetails(currentModInfo, {
        'customDescription': translation.text,
      });

      if (updatedMod != null && mounted) {
        setState(() {
          currentModInfo = updatedMod;
          // ++ CAMBIO 4: Ocultar solo el botón de la descripción ++
          _showTranslateDescriptionButton = false;
          _needsReloadOnClose = true;
        });
      }
    } catch (e) {
      NotificationService.instance.show(
        context: context,
        type: NotificationType.error,
        title: l10n.errorTranslation,
        description: e.toString(),
      );
    } finally {
      if (mounted) setState(() => _isTranslating = false);
    }
  }

  // Muestra diálogo para editar un solo campo (notas, descripción)
  Future<String?> _showSingleFieldEditDialog({
    required String title,
    required String label,
    required String initialValue,
    String? defaultValue,
    int? maxLength,
  }) async {
    final controller = TextEditingController(text: initialValue);
    final l10n = AppLocalizations.of(context)!;
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final bool isCurrentlyDefault =
                controller.text == (defaultValue ?? '');
            return AlertDialog(
              title: Text(title),
              content: TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(labelText: label),
                maxLines: null,
                maxLength: maxLength,
                onChanged: (v) => setDialogState(() {}),
              ),
              actions: [
                if (defaultValue != null)
                  TextButton(
                    onPressed: isCurrentlyDefault
                        ? null
                        : () => setDialogState(
                            () => controller.text = defaultValue,
                          ),
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
      },
    );
  }

  // Construye las secciones de texto
  Widget _buildInfoSection({
    required String title,
    required String content,
    required IconData icon,
    VoidCallback? onEdit,
  }) {
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
                  Icon(
                    icon,
                    color: Colors.tealAccent.withOpacity(0.8),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.tealAccent,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  // Botón para traducir el RESUMEN
                  if (title == l10n.modSummary && _showTranslateSummaryButton)
                    _isTranslating
                        ? const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(
                              Icons.translate,
                              color: Colors.white70,
                              size: 20,
                            ),
                            onPressed: _translateSummary,
                            tooltip: l10n.translateSummary,
                          ),
                  
                  // Botón para traducir la DESCRIPCIÓN
                  if (title == l10n.modDescription && _showTranslateDescriptionButton)
                     _isTranslating
                        ? const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(
                              Icons.translate,
                              color: Colors.white70,
                              size: 20,
                            ),
                            onPressed: _translateDescription,
                            tooltip: l10n.translateDescription,
                          ),

                  if (onEdit != null)
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Colors.white70,
                        size: 20,
                      ),
                      onPressed: onEdit,
                      tooltip: l10n.editButtonTooltip,
                      splashRadius: 20,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _stripHtml(content), // Limpiamos el HTML siempre antes de mostrar
            style: TextStyle(
              color: content.startsWith('No')
                  ? Colors.white.withOpacity(0.5)
                  : Colors.white.withOpacity(0.9),
              fontStyle: content.startsWith('No')
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

  /// Muestra el panel flotante para seleccionar un traje.
  Future<void> _showOutfitSelectionDialog(AppLocalizations l10n) async {
    // --- CAMBIO 1: El Notifier ahora guarda el *nombre* del traje, no el índice ---
    // Esto soluciona la raíz de todos los errores.
    final ValueNotifier<String?> hoveredOutfitNotifier = ValueNotifier<String?>(null);
    String searchQuery = ''; // El estado de la búsqueda se manejará localmente
    bool isClosing = false;

    final String? selectedOutfit = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF2d2d2d),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // Hacemos el panel más ancho y alto para que quepan bien las dos columnas
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8,
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      builder: (context) {
        // Usamos un StatefulBuilder para que SÓLO la columna de la lista
        // se reconstruya al escribir en el buscador.
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            
            // La lista filtrada se calcula aquí, cada vez que el StatefulBuilder se reconstruye
            final filteredOutfits = stellarBladeOutfits.where((outfit) => 
              outfit.toLowerCase().contains(searchQuery.toLowerCase())
            ).toList(); //

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- LADO IZQUIERDO: BÚSQUEDA Y LISTA (2/3 del espacio) ---
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // Barra de agarre
                      Container(
                        height: 5,
                        width: 40,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      // Barra de búsqueda
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: TextField(
                          autofocus: true,
                          onChanged: (value) {
                            // setDialogState SÓLO se usa para la búsqueda
                            setDialogState(() {
                              searchQuery = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: l10n.replacesOutfitSearchHint,
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16)
                          ),
                        ),
                      ),
                      // Lista de trajes (Expandida y con Scroll)
                      Expanded(
                        child: MouseRegion(
                          onExit: (_) {
                            if (isClosing) return;
                            // ++ INICIO DE LA MODIFICACIÓN ++
                            // Solo actualiza el notificador si el valor
                            // no es ya 'null'. Esto previene que
                            // onExit se dispare múltiples veces y
                            // cause el 'Duplicate key' en el AnimatedSwitcher.
                            if (hoveredOutfitNotifier.value != null) {
                              hoveredOutfitNotifier.value = null;
                            }
                            // ++ FIN DE LA MODIFICACIÓN ++
                          },
                          child: ListView.builder(
                            itemCount: filteredOutfits.length,
                            itemBuilder: (context, index) {
                              final outfit = filteredOutfits[index];
                              return MouseRegion(
                                // onEnter sigue aquí para *establecer* la vista previa
                                onEnter: (_) {
                                  if (isClosing) return;
                                  // ++ INICIO DE LA MODIFICACIÓN ++
                                  // Solo actualiza el notificador si el nuevo valor
                                  // es diferente al valor actual.
                                  // Esto previene el crash de "Duplicate key"
                                  // cuando el cursor se mueve rápido sobre el mismo item.
                                  if (hoveredOutfitNotifier.value != outfit) {
                                    hoveredOutfitNotifier.value = outfit;
                                  }
                                  // ++ FIN DE LA MODIFICACIÓN ++
                                },
                                // -- Ya NO necesitamos onExit aquí --
                                child: ListTile(
                                title: Text(outfit),
                                onTap: () {
                                  isClosing = true;
                                  Navigator.of(context).pop(outfit);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      )
                    ],
                  ),
                ),
                
                // --- LADO DERECHO: VISTA PREVIA (1/3 del espacio) ---
                Expanded(
                  flex: 1,
                  // --- CAMBIO 3: Escucha el ValueNotifier<String?> ---
                  child: ValueListenableBuilder<String?>(
                    valueListenable: hoveredOutfitNotifier,
                    builder: (context, hoveredOutfitName, child) {
                      
                      return Container(
                        // Ocupa toda la altura del panel
                        height: double.infinity, 
                        color: Colors.black.withOpacity(0.3),
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: AnimatedCrossFade(
                            // 1. Estado: Muestra el placeholder (first) o la imagen (second)
                            crossFadeState: hoveredOutfitName == null 
                              ? CrossFadeState.showFirst 
                              : CrossFadeState.showSecond,
                            
                            duration: const Duration(milliseconds: 200),
                            
                            // 2. Placeholder (Primer hijo)
                            firstChild: Column(
                              key: const ValueKey('outfit_placeholder'),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_search_rounded, size: 60, color: Colors.grey[700]),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.replacesOutfitHover,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                              ],
                            ),
                            
                            // 3. Imagen (Segundo hijo)
                            // La clave ValueKey(hoveredOutfitName) es crucial.
                            // Le dice al widget que cambie de imagen aunque el estado
                            // (showSecond) sea el mismo.
                            secondChild: ClipRRect(
                              key: ValueKey(hoveredOutfitName),
                              child: Image.asset(
                                // Usamos ?? '' para evitar errores si hoveredOutfitName es nulo
                                // durante el primer frame de la transición.
                                _generateOutfitImagePath(hoveredOutfitName ?? ''),
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  final path = _generateOutfitImagePath(hoveredOutfitName ?? '');
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Preview not found at:\n$path",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // 4. (Opcional pero recomendado) Esto evita que el panel "salte"
                            // de tamaño durante la animación de fundido.
                            layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  bottomChild,
                                  topChild,
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
    // (Por si el usuario cierra el panel sin seleccionar nada)
    isClosing = true;
    // Limpiamos el "mensajero" después de que el panel se cierra.
    hoveredOutfitNotifier.dispose();

    if (selectedOutfit != null) {
      _onOutfitSelected(selectedOutfit);
    }
  }

  /// Maneja el guardado del traje seleccionado.
  Future<void> _onOutfitSelected(String? outfitName) async {
    // Pasa los nuevos datos a la función de actualización del widget principal
    final updatedMod = await widget.onUpdateDetails(
      currentModInfo,
      {
        'replacesOutfit': outfitName, // Será nulo si se está limpiando
      },
    );

    if (updatedMod != null && mounted) {
      setState(() {
        currentModInfo = updatedMod;
        _needsReloadOnClose = true; // Marca que la lista principal necesita recargarse
      });
    }
  }

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

  /// Construye la UI para seleccionar un traje de reemplazo.
  Widget _buildOutfitReplacementSection(AppLocalizations l10n) {
    final String? replacedOutfit = currentModInfo.replacesOutfit;

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
              // --- TÍTULO ---
              Row(
                children: [
                  Icon(
                    Icons.swap_horiz_rounded,
                    color: Colors.tealAccent.withOpacity(0.8),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.replacesOutfitTitle, // Necesitarás esta traducción
                    style: const TextStyle(
                      color: Colors.tealAccent,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              
              // --- BOTÓN DE EDITAR / LIMPIAR ---
              IconButton(
                icon: Icon(
                  // Cambia el ícono si ya hay un traje seleccionado
                  replacedOutfit != null ? Icons.cancel_outlined : Icons.checkroom_outlined,
                  color: replacedOutfit != null ? Colors.redAccent : Colors.white70,
                  size: 20,
                ),
                onPressed: () {
                    if (replacedOutfit != null) {
                      // Limpiar la selección
                      _onOutfitSelected(null);
                    } else {
                      // Mostrar el diálogo de selección
                      _showOutfitSelectionDialog(l10n);
                    }
                },
                tooltip: replacedOutfit != null 
                    ? l10n.replacesOutfitClearTooltip 
                    : l10n.replacesOutfitSelectTooltip, // Necesitarás estas traducciones
                splashRadius: 20,
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),

          // --- "MINI-RETRATO" (El nombre del traje seleccionado) ---
          if (replacedOutfit != null) ...[
            const SizedBox(height: 12),
            // Mantenemos el contenedor original para el fondo y el borde
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12), // Un poco más de padding para la imagen
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center, // Centra verticalmente
                children: [
                  // 1. Vista previa de la imagen
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6.0), // Bordes redondeados más pequeños
                    child: Image.asset(
                      _generateOutfitImagePath(replacedOutfit), // Usamos la función auxiliar
                      width: 92.5, // Proporción 3:4 (como 60x80)
                      height: 167,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Placeholder si la imagen no se encuentra
                        return Container(
                          width: 52.5,
                          height: 70,
                          color: Colors.black.withOpacity(0.2),
                          child: const Icon(Icons.hide_image_outlined, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // 2. Nombre del traje
                  Expanded(
                    child: Text(
                      replacedOutfit,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16, // Más grande
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Mensaje de que no hay nada seleccionado
            const SizedBox(height: 10),
            Text(
              l10n.replacesOutfitNone, // Necesitarás esta traducción
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontStyle: FontStyle.italic,
                height: 1.5,
                fontSize: 15,
              ),
            )
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool hasLink =
        (currentModInfo.customSourceUrl ?? currentModInfo.sourceUrl)
            ?.isNotEmpty ??
        false;
      // Determina el nombre del autor
      final author = currentModInfo.customAuthor ?? currentModInfo.author;
    String? mainImagePath;
    // 1. PRIORITIZE the custom cover path. This now includes our cached '_nexus_cover.jpg'.
    if (currentModInfo.customCoverPath != null &&
        currentModInfo.customCoverPath!.isNotEmpty) {
      // It's a local file, so we build the full path to it.
      mainImagePath = p.join(
        currentModInfo.directory.path,
        currentModInfo.customCoverPath!,
      );
    // 2. FALLBACK to the internet URL from the gallery only if no custom/cached cover exists.
    } else if (currentModInfo.gallery != null &&
        currentModInfo.gallery!.isNotEmpty) {
      mainImagePath = currentModInfo.gallery!.first['image'];
    }

    final displayVersion =
        currentModInfo.customVersion ?? currentModInfo.localVersion;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) {
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFF1e1e1e),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              centerTitle: true,
              leadingWidth: 200, // Aumenta el espacio disponible para el `leading`
              leading: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Versión
                    if (displayVersion != null && displayVersion.isNotEmpty)
                      InkWell(
                        onTap: () async {
                          final newVersion = await _showSingleFieldEditDialog(
                            title: l10n.editVersionText,
                            label: l10n.customVersionText,
                            initialValue: displayVersion,
                            defaultValue: currentModInfo.localVersion ?? '',
                            maxLength: 15,
                          );
                          if (newVersion != null) {
                            final updatedMod = await widget.onUpdateDetails(
                              currentModInfo,
                              {'customVersion': newVersion},
                            );
                            if (updatedMod != null) {
                              setState(() {
                                currentModInfo = updatedMod;
                                _needsReloadOnClose = true;
                              });
                            }
                          }
                        },
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          child: Text(
                            "${l10n.modVersion} $displayVersion",
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    
                    if (displayVersion != null && displayVersion.isNotEmpty)
                      const SizedBox(width: 8),

                    // --- INICIO DE LA MODIFICACIÓN (Descomentado y actualizado) ---
                    /*/ Etiqueta
                    (() { // Usamos un constructor anónimo para definir las variables
                      final bool isReplacement = currentModInfo.replacesOutfit != null && currentModInfo.replacesOutfit!.isNotEmpty;
                      final String displayTag = isReplacement 
                          ? currentModInfo.replacesOutfit! 
                          : (currentModInfo.customFitMeshType ?? currentModInfo.fitMeshType ?? l10n.modCategoryOther);

                      return InkWell(
                        // Deshabilitamos el onTap si es un reemplazo
                        onTap: isReplacement ? null : () async {
                          final newTag = await _showSingleFieldEditDialog(
                            title: l10n.editTagText,
                            label: l10n.customTagText,
                            initialValue: displayTag,
                            defaultValue: currentModInfo.fitMeshType ?? '',
                          );
                          if (newTag != null) {
                            final updatedMod = await widget.onUpdateDetails(
                              currentModInfo,
                              {'customFitMeshType': newTag},
                            );
                            if (updatedMod != null) {
                              setState(() {
                                currentModInfo = updatedMod;
                                _needsReloadOnClose = true;
                              });
                            }
                          }
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isReplacement
                              ? Colors.black.withOpacity(0.4) // Fondo oscuro
                              : Colors.grey.withOpacity(0.2), // Fondo original
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row( // Usamos un Row para el icono
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isReplacement)
                                Icon(
                                  Icons.checkroom_outlined, 
                                  size: 12, 
                                  color: Colors.purpleAccent.shade100, // Color distintivo
                                ),
                              if (isReplacement)
                                const SizedBox(width: 6),
                              Text(
                                displayTag, // Muestra el nombre del traje
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isReplacement
                                    ? Colors.purpleAccent.shade100 // Color distintivo
                                    : Colors.white70, // Color original
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })(), // Fin del constructor anónimo de la etiqueta
                    // --- FIN DE LA MODIFICACIÓN ---*/
                  ],
                ),
              ),
              title: Container(
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              actions: [
                // Si hay una actualización que no está ignorada, muestra el botón.
                // Ahora la visibilidad depende del estado local '_isIgnored'.
                if (widget.updateInfo != null && !_isIgnored)
                  IconButton(
                    icon: const Icon(
                      Icons.notification_important_rounded,
                      color: Colors.yellowAccent,
                    ),
                    tooltip: l10n.updateAvailable(widget.updateInfo!['version']),
                    onPressed: () async {
                      if (currentModInfo.nexusId != null) {
                        final updateIdentifier =
                            currentModInfo.directory.path + (widget.updateInfo!['version'] as String);
                        
                        // 1. Llamamos a la función y esperamos su resultado (true/false).
                        final bool wasHidden = await widget.onShowUpdateDialog(
                          newVersion: widget.updateInfo!['version'],
                          nexusId: currentModInfo.nexusId!,
                          fileId: widget.updateInfo!['fileId'],
                          uniqueIdentifier: updateIdentifier,
                        );

                        // 2. Si el resultado es 'true', actualizamos el estado local para ocultar la campana.
                        if (wasHidden && mounted) {
                          setState(() {
                            _isIgnored = true;
                          });
                        }
                      }
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.edit_note_rounded),
                  tooltip: l10n.editButtonTooltip,
                  onPressed: () async {
                    final updatedData = await widget.onShowGeneralEditDialog(
                      currentModInfo,
                      context,
                    );
                    if (updatedData != null) {
                      final updatedMod = await widget.onUpdateDetails(
                        currentModInfo,
                        updatedData,
                      );
                      if (updatedMod != null) {
                        setState(() => currentModInfo = updatedMod);
                        _needsReloadOnClose = true;
                      }
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            body: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (mainImagePath != null)
                            ModImage(
                              imageUrl: mainImagePath,
                              isLocal: !mainImagePath.startsWith('http'),
                              lastModified:
                                  currentModInfo.customCoverLastModified,
                            )
                          else
                            const Center(
                              child: Icon(
                                Icons.extension,
                                size: 80,
                                color: Colors.white24,
                              ),
                            ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black.withOpacity(0.4),
                              ),
                              icon: const Icon(
                                Icons.fullscreen_outlined,
                                color: Colors.white,
                              ),
                              onPressed: () =>
                                  widget.onShowImageGallery(currentModInfo),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    currentModInfo.customName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2, // Límite de dos líneas
                    overflow: TextOverflow
                        .ellipsis, // Muestra "..." si el texto es muy largo
                  ),
                  // ++ INICIO DE LA MODIFICACIÓN: AUTOR COMO SUBTÍTULO ++
                  const SizedBox(height: 4),
                  Text(
                        // Verifica si el nombre del autor no es nulo ni está vacío
                        (author?.isNotEmpty ?? false)
                            // Si existe, usa la cadena localizada pasando el autor como argumento
                            ? l10n.byText(author!)
                            // De lo contrario, muestra una cadena vacía
                            : "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[400],
                        ),
                      ),
                  const SizedBox(height: 20),
                  // ++ FIN DE LA MODIFICACIÓN ++
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.folder_open),
                          label: Text(l10n.showInFolder),
                          onPressed: () =>
                              widget.onShowInExplorer(currentModInfo.directory),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(
                            hasLink
                                ? Icons.open_in_browser_outlined
                                : Icons.add_link_rounded,
                          ),
                          label: Text(
                            hasLink
                                ? l10n.openLinkButtonText
                                : l10n.addLinkButtonText,
                          ),
                          onPressed: () async {
                            final urlString =
                                currentModInfo.customSourceUrl ??
                                currentModInfo.sourceUrl;
                            if (urlString != null && urlString.isNotEmpty) {
                              final url = Uri.parse(urlString);
                              if (await canLaunchUrl(url)) await launchUrl(url);
                            } else {
                              final updatedData = await widget
                                  .onShowGeneralEditDialog(
                                    currentModInfo,
                                    context,
                                  );
                              if (updatedData != null) {
                                final updatedMod = await widget.onUpdateDetails(
                                  currentModInfo,
                                  updatedData,
                                );
                                if (updatedMod != null) {
                                  setState(() => currentModInfo = updatedMod);
                                  _needsReloadOnClose = true;
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hasLink
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.grey.withOpacity(0.2),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (currentModInfo.modType == 'genericPak' ||
                    currentModInfo.modType == 'replacement' ||
                    (currentModInfo.modType == null && currentModInfo.replacesOutfit != null) ) ...[
                    const SizedBox(height: 20),
                    // --- Switch para Mod de Reemplazo ---
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: SwitchListTile(
                        title: Text(
                          l10n.replacementModSwitchTitle, // "Mod de Reemplazo"
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          l10n.replacementModSwitchDesc, // "Marca si este mod reemplaza un traje."
                          style: TextStyle(color: Colors.grey[400], fontSize: 12),
                        ),
                        value: _isReplacementMod,
                        activeColor: Colors.tealAccent,

                        // ++ INICIO DE LA MODIFICACIÓN: onChanged ++
                        onChanged: (bool newValue) async {
                          // Define el nuevo tipo de mod basado en el switch
                          final String newModType = newValue ? 'replacement' : 'genericPak';
                          
                          // Prepara los datos para guardar.
                          final Map<String, dynamic> dataToSave = {
                            'modType': newModType,
                          };

                          // Si el usuario está APAGANDO el switch,
                          // también borramos el traje seleccionado.
                          if (newValue == false) {
                            dataToSave['replacesOutfit'] = null;
                          }

                          // Guardamos los cambios inmediatamente
                          final updatedMod = await widget.onUpdateDetails(
                            currentModInfo,
                            dataToSave,
                          );

                          // Actualizamos la UI local
                          if (updatedMod != null && mounted) {
                            setState(() {
                              currentModInfo = updatedMod;
                              _isReplacementMod = newValue; // Sincroniza el switch
                              _needsReloadOnClose = true;
                            });
                          } else {
                            // Si falla el guardado, revierte el switch
                            setState(() {
                              _isReplacementMod = !newValue;
                            });
                          }
                        },
                      ),
                    ),

                    // --- Sección de Selección de Traje (Condicional) ---
                    if (_isReplacementMod) ...[
                      const SizedBox(height: 20),
                      _buildOutfitReplacementSection(l10n),
                    ],
                  ],
                  const SizedBox(height: 30),
                  _buildInfoSection(
                    title: l10n.modSummary,
                    content:
                        currentModInfo.customSummary ??
                        currentModInfo.summary ??
                        l10n.noDescriptionAvailable,
                    icon: Icons.description_outlined,
                    onEdit: () async {
                      final newSummary = await _showSingleFieldEditDialog(
                        title: l10n.modSummary,
                        label: l10n.summaryLabel,
                        initialValue:
                            currentModInfo.customSummary ??
                            currentModInfo.summary ??
                            '',
                        defaultValue: currentModInfo.summary ?? '',
                      );
                      if (newSummary != null) {
                        final updatedMod = await widget.onUpdateDetails(
                          currentModInfo,
                          {'summary': newSummary},
                        );
                        if (updatedMod != null) {
                          setState(() {
                            currentModInfo = updatedMod;
                            _needsReloadOnClose = true;
                          });
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildInfoSection(
                    title: l10n.personalNotes,
                    content: currentModInfo.userNotes?.isNotEmpty ?? false
                        ? currentModInfo.userNotes!
                        : l10n.noNotesAvailable,
                    icon: Icons.edit_note_outlined,
                    onEdit: () async {
                      final newNotes = await _showSingleFieldEditDialog(
                        title: l10n.personalNotes,
                        label: l10n.notesLabel,
                        initialValue: currentModInfo.userNotes ?? '',
                      );
                      if (newNotes != null) {
                        final updatedMod = await widget.onUpdateDetails(
                          currentModInfo,
                          {'userNotes': newNotes},
                        );
                        if (updatedMod != null) {
                          setState(() {
                            currentModInfo = updatedMod;
                            _needsReloadOnClose = true;
                          });
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Container(
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
                                Icon(
                                  Icons.description_outlined,
                                  color: Colors.tealAccent.withOpacity(0.8),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.modDescription,
                                  style: const TextStyle(
                                    color: Colors.tealAccent,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                /*if (_showTranslateDescriptionButton)
                                  _isTranslating
                                      ? const Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          ),
                                        )
                                      : IconButton(
                                          icon: const Icon(
                                            Icons.translate,
                                            color: Colors.white70,
                                            size: 20,
                                          ),
                                          onPressed: _translateDescription,
                                          tooltip: l10n.translateDescription,
                                        ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    color: Colors.white70,
                                    size: 20,
                                  ),
                                  onPressed: () async {
                                    final newDescription = await _showSingleFieldEditDialog(
                                      title: l10n.modDescription,
                                      label: l10n.summaryLabel,
                                      initialValue: currentModInfo.customDescription ??
                                          _stripHtml(currentModInfo.description) ?? '',
                                      defaultValue: _stripHtml(currentModInfo.description) ?? '',
                                    );
                                    if (newDescription != null) {
                                      final updatedMod = await widget.onUpdateDetails(
                                        currentModInfo,
                                        {'customDescription': newDescription},
                                      );
                                      if (updatedMod != null) {
                                        setState(() {
                                          currentModInfo = updatedMod;
                                          _needsReloadOnClose = true;
                                        });
                                      }
                                    }
                                  },
                                  tooltip: l10n.editButtonTooltip,
                                  splashRadius: 20,
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                ),*/
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Aquí usamos el nuevo Widget
                        BBCodeRenderer(
                          data: currentModInfo.customDescription ??
                              currentModInfo.description ??
                              l10n.noDescriptionAvailable,
                          defaultStyle: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            height: 1.5,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class BBCodeRenderer extends StatelessWidget {
  final String data;
  final TextStyle? defaultStyle;

  const BBCodeRenderer({super.key, required this.data, this.defaultStyle});

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = defaultStyle ?? Theme.of(context).textTheme.bodyMedium ?? const TextStyle();
    final decodedData = data
      .replaceAll('&#92;', r'\')
      .replaceAll('&gt;', '>')
      .replaceAll('&lt;', '<')
      .replaceAll('&amp;', '&');
      
    final widgets = _parseBBCode(context, decodedData);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets.map((widget) {
        if (widget is RichText) {
          return DefaultTextStyle(
            style: defaultTextStyle,
            child: widget,
          );
        }
        return widget;
      }).toList(),
    );
  }

  /// Analizador principal que separa los elementos de bloque (imágenes, listas, etc).
  List<Widget> _parseBBCode(BuildContext context, String text) {
    final List<Widget> widgets = [];
    final regex = RegExp(
      r'(\[center\][\s\S]*?\[/center\]|\[left\][\s\S]*?\[/left\]|\[list(?:=1)?\][\s\S]*?\[/list\]|\[img\][\s\S]*?\[/img\])',
      caseSensitive: false,
    );

    text.splitMapJoin(
      regex,
      onMatch: (Match match) {
        final String matchText = match.group(0)!;
        final String lowerCaseMatch = matchText.toLowerCase();

        if (lowerCaseMatch.startsWith('[center]')) {
          final content = matchText.substring(8, matchText.length - 9);
          widgets.add(Center(child: Column(children: _parseBBCode(context, content))));
        } 
        else if (lowerCaseMatch.startsWith('[left]')) {
          final content = matchText.substring(6, matchText.length - 7);
          widgets.add(Align(
            alignment: Alignment.centerLeft,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: _parseBBCode(context, content)),
          ));
        } 
        else if (lowerCaseMatch.startsWith('[list')) {
          final bool isOrdered = lowerCaseMatch.startsWith('[list=1]');
          final int startIndex = matchText.indexOf(']') + 1;
          final content = matchText.substring(startIndex, matchText.length - 7);
          widgets.add(_buildList(context, content, isOrdered: isOrdered));
        } 
        else if (lowerCaseMatch.startsWith('[img]')) {
          final url = matchText.substring(5, matchText.length - 6).trim();
          widgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Image.network(
                url,
                errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image_outlined, color: Colors.grey),
              ),
            ),
          );
        }
        return '';
      },
      // ++ INICIO DE LA MODIFICACIÓN: MANEJAR [*] INDEPENDIENTES ++
      onNonMatch: (String text) {
        if (text.trim().isEmpty) return '';

        // Ahora, dividimos el texto sobrante por la etiqueta [*]
        final itemParts = text.split(RegExp(r'\[\*\]', caseSensitive: false));
        
        // El primer fragmento es texto normal antes de la primera viñeta
        if (itemParts.first.trim().isNotEmpty) {
          widgets.add(_buildRichText(context, itemParts.first));
        }

        // El resto de los fragmentos son viñetas independientes
        if (itemParts.length > 1) {
          for (final itemText in itemParts.skip(1)) {
            if (itemText.trim().isNotEmpty) {
              widgets.add(_buildStandaloneListItem(context, itemText.trim()));
            }
          }
        }
        return '';
      },
      // ++ FIN DE LA MODIFICACIÓN ++
    );

    return widgets;
  }
  
  /// Widget para construir listas.
  Widget _buildList(BuildContext context, String content, {bool isOrdered = false}) {
    final items = content.split(RegExp(r'\[\*\]', caseSensitive: false));
    if (items.isEmpty) return const SizedBox.shrink();

    final validItems = items.where((item) => item.trim().isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: validItems.asMap().entries.map((entry) {
        final index = entry.key;
        final itemText = entry.value;
        final String bullet = isOrdered ? "${index + 1}." : "•";

        return Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 2.0, bottom: 2.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 2.0),
                child: Text(bullet, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _parseBBCode(context, itemText.trim()),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ++ NUEVO: Widget para construir un elemento de lista INDEPENDIENTE ++
  Widget _buildStandaloneListItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 2.0, bottom: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 8.0, top: 2.0),
            child: Text("•", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          // El contenido del item puede tener más estilos, así que lo pasamos a RichText
          Expanded(child: _buildRichText(context, text)),
        ],
      ),
    );
  }


  /// Construye el RichText para estilos en línea (negrita, color, fuente, etc.).
  Widget _buildRichText(BuildContext context, String text) {
    final List<TextSpan> spans = [];
    final List<TextStyle> styleStack = [const TextStyle()];
    final List<GestureRecognizer?> recognizerStack = [null];
    
    final regex = RegExp(
        r'\[\/?(b|u|i|s|color|size|url|font)(?:=([^\]]*))?\]',
        caseSensitive: false,
    );

    text.splitMapJoin(
      regex,
      onMatch: (Match match) {
        final tagName = match.group(1)?.toLowerCase();
        final tagValue = match.group(2);
        final isClosingTag = match.group(0)!.startsWith('[/');

        if (isClosingTag) {
          if (styleStack.length > 1) styleStack.removeLast();
          if (recognizerStack.length > 1) recognizerStack.removeLast();
        } else {
          TextStyle currentStyle = styleStack.last;
          GestureRecognizer? currentRecognizer = recognizerStack.last;

          switch (tagName) {
            case 'b':
              currentStyle = currentStyle.copyWith(fontWeight: FontWeight.bold);
              break;
            case 'u':
              currentStyle = currentStyle.copyWith(decoration: TextDecoration.underline);
              break;
            case 'i':
              currentStyle = currentStyle.copyWith(fontStyle: FontStyle.italic);
              break;
            case 's':
              currentStyle = currentStyle.copyWith(decoration: TextDecoration.lineThrough);
              break;
            case 'color':
              final color = _hexToColor(tagValue);
              if (color != null) {
                currentStyle = currentStyle.copyWith(color: color);
              }
              break;
            case 'size':
              final fontSize = _sizeToFontSize(tagValue);
              if (fontSize != null) {
                currentStyle = currentStyle.copyWith(fontSize: fontSize);
              }
              break;
            case 'url':
              if (tagValue != null) {
                currentRecognizer = TapGestureRecognizer()
                  ..onTap = () async {
                    try {
                      final url = Uri.parse(tagValue);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    } catch (e) {
                      print('Could not launch URL $tagValue: $e');
                    }
                  };
                  currentStyle = currentStyle.copyWith(
                    color: Colors.lightBlueAccent,
                    decoration: TextDecoration.underline,
                  );
              }
              break;
            case 'font':
              if (tagValue != null) {
                currentStyle = currentStyle.copyWith(fontFamily: tagValue.replaceAll("'", "").replaceAll('"', ""));
              }
              break;
          }
          styleStack.add(currentStyle);
          recognizerStack.add(currentRecognizer);
        }
        return '';
      },
      onNonMatch: (String text) {
        if (text.isNotEmpty) {
          spans.add(
            TextSpan(
              text: text,
              style: styleStack.last,
              recognizer: recognizerStack.last,
            ),
          );
        }
        return '';
      },
    );
    
    return RichText(
      text: TextSpan(
        children: spans,
        style: defaultStyle ?? Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  // --- Funciones de Ayuda ---

  Color? _hexToColor(String? hex) {
    if (hex == null) return null;
    final hexString = hex.startsWith('#') ? hex.substring(1) : hex;
    if (hexString.length == 6) {
      return Color(int.parse('FF$hexString', radix: 16));
    }
    return null;
  }

  double? _sizeToFontSize(String? size) {
    if (size == null) return null;
    final sizeNum = int.tryParse(size);
    if (sizeNum == null) return null;
    switch (sizeNum) {
      case 1: return 10.0;
      case 2: return 12.0;
      case 3: return 14.0;
      case 4: return 16.0;
      case 5: return 20.0;
      case 6: return 24.0;
      case 7: return 32.0;
      default: return 14.0;
    }
  }
}