import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:win32_registry/win32_registry.dart';
import 'l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';



// Clase para almacenar la información de un mod.
class ModInfo {
  final Directory directory;
  final String? nexusId;
  String? localVersion;
  final DateTime lastModified;
  bool isEnabled;

  ModInfo({
    required this.directory,
    this.nexusId,
    this.localVersion,
    required this.lastModified,
    required this.isEnabled,
  });

  static String? _extractVersionFromName(String name) {
    // Regex mejorada para admitir versiones con letras (ej: v1.a, 1.0.5)
    final regex = RegExp(r'[vV]?([0-9]+(\.[0-9a-zA-Z]+)*)');
    final match = regex.firstMatch(name);
    return match?.group(1);
  }
}

void main() {
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
    String? languageCode = prefs.getString('languageCode');
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

// Clase auxiliar para mapear los resultados de la búsqueda de actualizaciones a los mods
class _UpdateCheckJob {
  final ModInfo? mod;
  final bool isCns;
  _UpdateCheckJob({this.mod, this.isCns = false});
}

// Clase auxiliar para mods preparados para la instalación
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

enum ModFilter { all, enabled, disabled }
enum ModSort { name, date }

class _ModInstallerHomePageState extends State<ModInstallerHomePage> {
  List<_PreparedMod> _preparedMods = [];
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

  List<String> _lastInstalledModNames = [];

  String _appVersion = '';

  // Variables específicas para el CNS
  String? _cnsVersion;
  String? _cnsNexusId;
  Map<String, dynamic>? _cnsUpdateInfo; // {'version': '1.1', 'fileId': 12345}

  // Nuevas variables para la comprobación de actualizaciones
  final Map<String, Map<String, dynamic>> _modUpdates = {}; // Key: mod directory path, Value: {'version': '1.1', 'fileId': 12345}
  final Set<String> _ignoredUpdates = {}; // Almacena identificadores para las actualizaciones ignoradas
  bool _isCheckingForUpdates = false;
  
  // Variables para el progreso de extracción
  bool _isExtracting = false;
  double _extractionProgress = 0.0;
  String _extractionStatus = '';

  // Variables para filtrado y ordenamiento
  ModFilter _currentFilter = ModFilter.all;
  ModSort _currentSort = ModSort.date;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_statusMessage.isEmpty) {
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
      print('No se pudo limpiar el directorio temporal al cerrar: $e');
    }
    super.dispose();
  }

  Future<void> _initialize() async {
    await _getAppVersion();
    await _find7zipPath();
    await _findGamePath();
    if (_finalModsPath != null) {
      await _loadAllMods();
      await _readCNSData();
    }
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  Future<void> _find7zipPath() async {
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

  Future<void> _findGamePath() async {
    setState(() {
      _isLoading = true;
      _statusMessage = AppLocalizations.of(context)!.statusSearchingGame;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      String? savedPath = prefs.getString('gameRootPath');
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
          _statusMessage = AppLocalizations.of(context)!.statusGamePathFound;
        });
      } else {
        setState(() {
          _finalModsPath = null;
          _statusMessage =
              AppLocalizations.of(context)!.statusGamePathNotFound;
          _statusColor = Colors.orangeAccent;
        });
      }
    } catch (e) {
      setState(() {
        _finalModsPath = null;
        _statusMessage =
            AppLocalizations.of(context)!.statusErrorFindingGame(e.toString());
        _statusColor = Colors.redAccent;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<String?> _findSteamInstallation() async {
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
      print("Error buscando en el registro de Steam: $e");
      return null;
    }
    return null;
  }

  Future<String?> _readCNSData() async {
    if (_gameRootPath == null) return null;

    String? newVersion;
    // Leer nexus_info.json para el ID y la versión instalada
    try {
      final infoFile = File(p.join(
          _gameRootPath!, 'SB', 'Binaries', 'Win64', 'ue4ss', 'nexus_info.json'));
      if (await infoFile.exists()) {
        final content = await infoFile.readAsString();
        final data = json.decode(content);
        setState(() {
          _cnsNexusId = data['nexusId'];
          _cnsVersion = data['installedVersion'];
        });
        newVersion = data['installedVersion'];
      }
    } catch (e) {
      print('Error al leer nexus_info.json del CNS: $e');
    }

    // Si no se encontró la versión en el JSON, intentar leerla desde el LUA como fallback
    if (_cnsVersion == null) {
      try {
        final luaFile = File(p.join(_gameRootPath!, 'SB', 'Binaries', 'Win64',
            'ue4ss', 'Mods', 'DekCNS', 'Scripts', 'main.lua'));
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
        } else {
          setState(() => _cnsVersion = null);
        }
      } catch (e) {
        print('Error al leer la versión del CNS desde LUA: $e');
        setState(() => _cnsVersion = null);
      }
    }
    return newVersion;
  }

  Future<void> _selectGamePathManually() async {
    try {
      String? result = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Por favor, selecciona la carpeta principal de StellarBlade',
      );
      if (result != null) {
        final validationPath = p.join(result, 'SB', 'Content', 'Paks');
        if (await Directory(validationPath).exists()) {
          final modPath = p.join(
              result, 'SB', 'Content', 'Paks', '~mods', 'CustomNanosuitSystem');
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('gameRootPath', result);
          setState(() {
            _gameRootPath = result;
            _finalModsPath = modPath;
          });
          await _loadAllMods();
          await _readCNSData();
        } else {
          setState(() {
            _statusMessage =
                'La carpeta seleccionada no parece ser la correcta. Inténtalo de nuevo.';
            _statusColor = Colors.redAccent;
          });
        }
      }
    } catch (e) {
      setState(() => _statusMessage = 'Error al seleccionar la carpeta: $e');
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

    Future<List<ModInfo>> getModsFromDirectory(String path, bool isEnabled) async {
      final dir = Directory(path);
      if (!await dir.exists()) return [];

      final modDirs = dir.listSync().whereType<Directory>().toList();
      final List<ModInfo> mods = [];
      for (final modDir in modDirs) {
        if (p.basename(modDir.path) == '__MOD_BACKUPS__') continue;

        String? nexusId;
        String? installedVersion;

        final infoFile = File(p.join(modDir.path, 'nexus_info.json'));
        if (await infoFile.exists()) {
          try {
            final content = await infoFile.readAsString();
            final data = json.decode(content);
            nexusId = data['nexusId'];
            installedVersion = data['installedVersion'];
          } catch (e) {
            print("Error al leer nexus_info.json en ${modDir.path}: $e");
          }
        }

        installedVersion ??=
            ModInfo._extractVersionFromName(p.basename(modDir.path));
        
        final fileStat = await modDir.stat();

        mods.add(ModInfo(
            directory: modDir,
            nexusId: nexusId,
            localVersion: installedVersion,
            lastModified: fileStat.modified,
            isEnabled: isEnabled));
      }
      return mods;
    }

    try {
      final enabledMods = await getModsFromDirectory(_finalModsPath!, true);

      final exePath = Platform.resolvedExecutable;
      final exeDir = p.dirname(exePath);
      final backupDirPath = p.join(exeDir, '__MOD_BACKUPS__');
      final disabledMods = await getModsFromDirectory(backupDirPath, false);

      setState(() {
        _allMods = [...enabledMods, ...disabledMods];
        if (clearHighlight) {
          _statusMessage = AppLocalizations.of(context)!
              .statusModsFound(disabledMods.length, enabledMods.length);
          _statusColor = Colors.white;
        }
      });
    } catch (e) {
      setState(() {
        _statusMessage =
            AppLocalizations.of(context)!.statusErrorReadingMods(e.toString());
        _statusColor = Colors.redAccent;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickArchive() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip', 'rar', '7z'],
        allowMultiple: true, // Permitir selección múltiple
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

  Map<String, String>? _extractNexusInfoFromName(String name) {
    try {
      // Regex mejorada para admitir letras en la versión (ej: 1-a)
      final regex = RegExp(r'-(\d+)-([0-9a-zA-Z]+)-([0-9a-zA-Z]+)-');
      final match = regex.firstMatch(name);
      if (match != null && match.groupCount >= 3) {
        final id = match.group(1);
        final versionPart1 = match.group(2);
        final versionPart2 = match.group(3);
        final version = 'v$versionPart1.$versionPart2';
        if (id != null) {
          return {'id': id, 'version': version};
        }
      }
    } catch (e) {
      print(
          'No se pudo extraer la información de Nexus del nombre: $name. Error: $e');
    }
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
    // La variable l10n ahora se obtiene aquí para acceder a los textos.
    final l10n = AppLocalizations.of(context)!; 
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: Text(l10n.dialogTitleUE4SS), 
        content: Text(l10n.dialogContentUE4SS),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.dialogActionCancel)),
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

    setState(() {
      _isLoading = true;
      _statusMessage = l10n.statusInstallingUE4SS;
    });

    try {
      if (_gameRootPath == null) {
        throw Exception(l10n.errorGamePathUndefined);
      }
      final destinationDir = Directory(p.join(_gameRootPath!, 'SB', 'Binaries', 'Win64'));
      if (!await destinationDir.exists()) {
        await destinationDir.create(recursive: true);
      }

      await _copyDirectory(sourceDir, destinationDir);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l10n.snackBarUE4SSInstalled),
        backgroundColor: Colors.green,
      ));
      setState(() {
        _statusMessage = l10n.statusUE4SSInstallComplete;
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
        print('No se pudo limpiar el directorio temporal anterior: $e');
      }
      _tempExtractionDir =
          Directory.systemTemp.createTempSync('mod_manager_');
      
      _preparedMods.clear();

      for (int i = 0; i < archives.length; i++) {
        final archiveFile = archives[i];
        final fileName = p.basename(archiveFile.path);

        setState(() {
          _extractionProgress = (i + 1) / archives.length;
          _extractionStatus = l10n.statusExtractingMultipleFiles(i + 1, archives.length, fileName);
        });

        final nexusInfo = _extractNexusInfoFromName(fileName);
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

        final ue4ssDir = Directory(p.join(archiveTempDir.path, 'ue4ss'));
        final dwmapiFile = File(p.join(archiveTempDir.path, 'dwmapi.dll'));

        if (await ue4ssDir.exists() && await dwmapiFile.exists()) {
          _preparedUE4SS = _PreparedUE4SS(sourceDir: archiveTempDir);
          continue; 
        }

        final sbDir = Directory(p.join(archiveTempDir.path, 'SB'));
        if (await sbDir.exists() &&
            await Directory(p.join(sbDir.path, 'Binaries')).exists() &&
            await Directory(p.join(sbDir.path, 'Content')).exists()) {
          await _promptAndUpdateCNS(sbDir);
          cnsUpdateInitiated = true;
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

      if (_preparedUE4SS != null) {
        // Limpiamos los mods normales si se va a instalar UE4SS para evitar confusiones.
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

    // Comprueba si el directorio actual es un mod.
    // Bucle para no listar todo el directorio si encontramos el json.
    await for (final entity in root.list(followLinks: false)) {
      if (entity is File && p.extension(entity.path).toLowerCase() == '.json') {
        isRootAMod = true;
        break;
      }
    }

    if (isRootAMod) {
      // Si el directorio actual es un mod, lo añadimos.
      found.add(root);
      return found;
    }

    // Si no es un mod, buscamos en sus subdirectorios.
    await for (final entity in root.list(followLinks: false)) {
      if (entity is Directory) {
        // Ignoramos carpetas comunes que no contienen mods.
        final basename = p.basename(entity.path);
        if (basename.startsWith('__') || basename.startsWith('.')) continue;

        // Llamada recursiva para buscar dentro de esta subcarpeta.
        final nestedMods = await _findValidModDirectories(entity);
        found.addAll(nestedMods);
      }
    }

    return found;
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
          finalFolderName = '$finalFolderName ${preparedMod.nexusVersion}';
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
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: Text(l10n.dialogTitleCNSUpdate),
        content: Text(l10n.dialogContentCNSUpdate),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.dialogActionCancel)),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.tealAccent),
            child: Text(l10n.dialogActionUpdateSystem),
          ),
        ],
      ),
    );

    if (confirm != true) {
      setState(() => _statusMessage = l10n.statusUpdateSystemCancelled);
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = l10n.statusUpdatingCNS;
    });

    try {
      if (_gameRootPath == null) {
        throw Exception(l10n.errorGamePathUndefined);
      }
      final destinationSBDir = Directory(p.join(_gameRootPath!, 'SB'));
      if (!await destinationSBDir.exists()) {
        throw Exception(l10n.errorDestinationNotFound);
      }

      await _copyDirectory(sourceSBDir, destinationSBDir);
      
      // 1. Siempre leemos 'main.lua' para obtener la versión real instalada.
      String? versionFromLua;
      try {
        final luaFile = File(p.join(_gameRootPath!, 'SB', 'Binaries', 'Win64',
            'ue4ss', 'Mods', 'DekCNS', 'Scripts', 'main.lua'));
        
        if (await luaFile.exists()) {
          final content = await luaFile.readAsString();
          final regex = RegExp(r'local CNS_Version = "(.+)"');
          final match = regex.firstMatch(content);
          if (match != null && match.group(1) != null) {
            versionFromLua = match.group(1);
            print('Versión leída desde main.lua: $versionFromLua');
          }
        }
      } catch (e) {
        print('No se pudo leer la versión del main.lua recién instalado: $e');
      }

      // 2. Intentamos obtener info del nombre del archivo, pero ya no es un requisito.
      final nexusInfo = _extractNexusInfoFromName(p.basename(sourceSBDir.parent.path));

      // 3. LA CONDICIÓN CLAVE: Si pudimos leer la versión desde LUA, entonces
      //    PROCEDEMOS a crear/actualizar el 'nexus_info.json'.
      if (versionFromLua != null) {
        final ue4ssDir = Directory(
            p.join(_gameRootPath!, 'SB', 'Binaries', 'Win64', 'ue4ss'));
        if (await ue4ssDir.exists()) {
          final infoFile = File(p.join(ue4ssDir.path, 'nexus_info.json'));

          // 4. VALORES POR DEFECTO: Usamos el ID de Nexus del nombre del archivo si existe,
          //    si no, usamos el ID conocido del CNS ('1496') como respaldo.
          final String nexusIdForFile = nexusInfo?['id'] ?? '1496';

          final Map<String, dynamic> modData = {
            'nexusId': nexusIdForFile,
            'installedVersion': versionFromLua, // Siempre usamos la versión de LUA.
            'installDate': DateTime.now().toIso8601String(),
          };

          final galleryData = await _fetchModImages(nexusIdForFile);
          if (galleryData != null) {
            modData['gallery'] = galleryData;
          }

          final encoder = JsonEncoder.withIndent('  ');
          await infoFile.writeAsString(encoder.convert(modData));
          print('nexus_info.json para CNS creado/actualizado correctamente.');
        }
      } else {
        // Si no se encontró la versión en LUA, no creamos el archivo para evitar datos corruptos.
        print('ADVERTENCIA: No se pudo determinar la versión del CNS desde main.lua. No se creará nexus_info.json.');
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l10n.snackBarCNSUpdated),
        backgroundColor: Colors.green,
      ));
      setState(() {
        _statusMessage = l10n.statusUpdateComplete;
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  l10n.snackBarBatchInstallComplete(successCount, failCount)),
              backgroundColor: snackBarColor));
        } else if (successCount == 1) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(l10n.snackBarModInstalled(installedNames.first)),
            backgroundColor: Colors.green[600]));
        }
      }
    } catch (e) {
      errorMessage = e.toString();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(l10n.statusError(errorMessage)),
            backgroundColor: Colors.red));
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
      print("No se pudo leer el DisplayName de ${modDir.path}: $e");
    }
    return null;
  }

  Future<String> _installSingleModFromListOfFiles(List<File> files,
      {String? nexusId, String? nexusVersion}) async {
    final l10n = AppLocalizations.of(context)!;
    final jsonFiles =
        files.where((f) => p.extension(f.path).toLowerCase() == '.json').toList();

    if (jsonFiles.isEmpty) {
      throw Exception(l10n.errorNoJsonFound);
    }

    if (jsonFiles.length > 1) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF2a2a2a),
          title: Text(l10n.dialogTitleMultipleJsons),
          content: Text(l10n.dialogContentMultipleJsons(jsonFiles.length)),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.dialogActionCancel)),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.tealAccent),
              child: Text(l10n.dialogActionInstallAnyway),
            ),
          ],
        ),
      );

      if (confirm != true) {
        throw Exception(l10n.statusInstallationCancelledByUser);
      }
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
          } else {
            throw FormatException(
                l10n.errorNoDisplayName(p.basename(jsonFile.path)));
          }
        } else {
          throw FormatException(
              l10n.errorInvalidJsonFormat(p.basename(jsonFile.path)));
        }
      } catch (e) {
        rethrow;
      }
    }

    if (displayNames.isEmpty) {
      throw FormatException(l10n.errorNoValidDisplayName);
    }

    String baseDisplayName = displayNames.join(' ~ ');
    String finalFolderName = baseDisplayName;
    if (nexusVersion != null) {
      finalFolderName = '$finalFolderName $nexusVersion';
    }

    ModInfo? oldVersionMod;

    if (nexusId != null) {
      for (final mod in _allMods) {
        if (mod.nexusId == nexusId) {
          oldVersionMod = mod;
          break;
        }
      }
    }

    if (oldVersionMod == null) {
      for (final existingMod in _allMods) {
        String? existingDisplayName =
            await _getDisplayNameForMod(existingMod.directory);
        if (existingDisplayName != null &&
            existingDisplayName == baseDisplayName) {
          oldVersionMod = existingMod;
          break;
        }
      }
    }

    if (oldVersionMod != null) {
      final oldModName = p.basename(oldVersionMod.directory.path);
      final confirmUpdate = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF2a2a2a),
          title: Text(l10n.dialogTitleModExists),
          content: Text(l10n.dialogContentModUpdate(oldModName, finalFolderName)),
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

      if (confirmUpdate == true) {
        final bool deleted =
            await _deleteDirectoryWithRetry(oldVersionMod.directory);
        if (!deleted) {
          throw Exception(
              'No se pudo borrar la versión antigua del mod ($oldModName) después de varios intentos.');
        }
      } else {
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
        final bool deleted =
            await _deleteDirectoryWithRetry(Directory(newModPath));
        if (!deleted) {
          throw Exception(
              'No se pudo borrar el mod existente ($finalFolderName) para reinstalar después de varios intentos.');
        }
      }
    }

    await Directory(newModPath).create(recursive: true);

    if (nexusId != null) {
      final infoFile = File(p.join(newModPath, 'nexus_info.json'));
      final versionForFile =
          nexusVersion ?? ModInfo._extractVersionFromName(finalFolderName);

      // CORRECCIÓN 2: Tipar el mapa explícitamente
      final Map<String, dynamic> modData = {
        'nexusId': nexusId,
        'installedVersion': versionForFile,
        'installDate': DateTime.now().toIso8601String()
      };

      // CAMBIO: Obtener y añadir la galería al objeto principal
      final galleryData = await _fetchModImages(nexusId);
      if (galleryData != null) {
        modData['gallery'] = galleryData;
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
    setState(() {
      _isLoading = true;
      _lastInstalledModNames.clear();
    });
    try {
      await _moveMod(modInfo.directory, _finalModsPath!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!
                .snackBarModEnabled(p.basename(modInfo.directory.path))),
            backgroundColor: Colors.green));
      }
      await _loadAllMods();
    } catch (e) {
      setState(() {
        _statusMessage =
            AppLocalizations.of(context)!.errorEnableMod(e.toString());
        _statusColor = Colors.redAccent;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _disableMod(ModInfo modInfo) async {
    setState(() {
      _isLoading = true;
      _lastInstalledModNames.clear();
    });
    try {
      final exePath = Platform.resolvedExecutable;
      final exeDir = p.dirname(exePath);
      final backupDir = Directory(p.join(exeDir, '__MOD_BACKUPS__'));
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }
      await _moveMod(modInfo.directory, backupDir.path);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!
                .snackBarModDisabled(p.basename(modInfo.directory.path))),
            backgroundColor: Colors.orange));
      }
      await _loadAllMods();
    } catch (e) {
      setState(() {
        _statusMessage =
            AppLocalizations.of(context)!.errorDisableMod(e.toString());
        _statusColor = Colors.redAccent;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteModPermanently(ModInfo modInfo) async {
    final l10n = AppLocalizations.of(context)!;
    final modName = p.basename(modInfo.directory.path);
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(l10n.snackBarModDeleted(modName)),
            backgroundColor: Colors.red[800]));
      } else if (!deleted) {
        throw Exception('No se pudo borrar el directorio.');
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
            'Acceso denegado al borrar ${dir.path}. Reintentando (${i + 1}/$retries)...');
        await Future.delayed(const Duration(milliseconds: 300));
      } catch (e) {
        rethrow;
      }
    }
    print('No se pudo borrar el directorio ${dir.path} después de $retries intentos.');
    return false; // Falló después de todos los reintentos
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
      _statusMessage =
          message ?? AppLocalizations.of(context)!.statusSelectionCancelled;
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

  /// Compara dos strings de versión (ej: "1.10.1" vs "1.9.2" o "1.a")
  /// Devuelve > 0 si v1 es mayor, < 0 si v2 es mayor, 0 si son iguales.
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

  // CAMBIO: La función ahora DEVUELVE los datos de la galería, no escribe un archivo.
  Future<List<Map<String, dynamic>>?> _fetchModImages(String nexusId) async {
    const String apiKey =
        "Gstf7M2Sep0cumb7+FefEN5790jgkFUqytRNr5yMXIZJIH5A--iHhrBgPf1FnuQ9Mz--7uj2b1tAp0MgiJi+2bCgGQ==";
    final headers = {'apikey': apiKey, 'accept': 'application/json'};

    try {
      // --- ESTRATEGIA 1: Intentar el endpoint específico de imágenes ---
      final imagesUrl = Uri.parse(
          'https://api.nexusmods.com/v1/games/stellarblade/mods/$nexusId/images.json');
      var response = await http.get(imagesUrl, headers: headers);

      if (response.statusCode == 200) {
        final images = json.decode(response.body);
        if (images is List && images.isNotEmpty) {
          print(
              "Estrategia 1 exitosa: Se encontró la galería de imágenes completa para el mod $nexusId.");
          return List<Map<String, dynamic>>.from(images);
        }
      }

      // --- ESTRATEGIA 2: Fallback si el primero falla (p. ej. con 404) ---
      print(
          "Estrategia 1 falló para el mod $nexusId (código: ${response.statusCode}). Intentando Estrategia 2 (detalles del mod)...");
      final modDetailsUrl = Uri.parse(
          'https://api.nexusmods.com/v1/games/stellarblade/mods/$nexusId.json');
      response = await http.get(modDetailsUrl, headers: headers);

      if (response.statusCode == 200) {
        final modDetails = json.decode(response.body);
        final pictureUrl = modDetails['picture_url'] as String?;

        if (pictureUrl != null && pictureUrl.isNotEmpty) {
          print(
              "Estrategia 2 exitosa: Se encontró 'picture_url' para el mod $nexusId.");
          return [
            {
              "image": pictureUrl,
              "thumbnail": pictureUrl,
              "description": "Imagen principal del mod"
            }
          ];
        }
      }

      print("Ambas estrategias para obtener imágenes fallaron para el mod $nexusId.");
      return null;
    } catch (e) {
      print("Ocurrió una excepción al obtener imágenes para el mod $nexusId: $e");
      return null;
    }
  }

  // Esta función lee, actualiza y escribe el archivo nexus_info.json unificado.
  Future<void> _updateNexusInfoFile(Directory modDirectory,
      {Map<String, dynamic>? updateCheckData,
      List<Map<String, dynamic>>? galleryData}) async {
    final infoFile = File(p.join(modDirectory.path, 'nexus_info.json'));
    Map<String, dynamic> modData = {};

    try {
      if (await infoFile.exists()) {
        modData = json.decode(await infoFile.readAsString());
      }
    } catch (e) {
      print(
          "No se pudo leer el nexus_info.json existente, se creará uno nuevo. Error: $e");
    }

    if (updateCheckData != null) {
      modData['lastUpdateCheck'] = updateCheckData;
    }
    if (galleryData != null) {
      modData['gallery'] = galleryData;
    }

    final encoder = JsonEncoder.withIndent('  ');
    await infoFile.writeAsString(encoder.convert(modData));
  }

  Future<void> _checkForUpdates() async {
    final l10n = AppLocalizations.of(context)!;
    const String apiKey =
        "Gstf7M2Sep0cumb7+FefEN5790jgkFUqytRNr5yMXIZJIH5A--iHhrBgPf1FnuQ9Mz--7uj2b1tAp0MgiJi+2bCgGQ==";

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

    final headers = {'apikey': apiKey, 'accept': 'application/json'};
    final List<Future<Map<String, dynamic>?>> futures = [];

    for (final job in jobs) {
      if (job.isCns) {
        futures.add(_checkSingleModUpdate(
            headers: headers,
            nexusId: _cnsNexusId!,
            localVersion: _cnsVersion!,
            modName: "Custom Nanosuit System",
            modDirectory: Directory(
                p.join(_gameRootPath!, 'SB', 'Binaries', 'Win64', 'ue4ss'))));
      } else if (job.mod != null) {
        futures.add(_checkSingleModUpdate(
            headers: headers,
            nexusId: job.mod!.nexusId!,
            localVersion: job.mod!.localVersion!,
            modName: p.basename(job.mod!.directory.path),
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
    required String modName,
    required Directory modDirectory,
  }) async {
    final url = Uri.parse(
        'https://api.nexusmods.com/v1/games/stellarblade/mods/$nexusId/files.json');
    final response = await http.get(url, headers: headers);

    // Actualizar nexus_info.json con el resultado de la comprobación y la galería.
    try {
      final updateCheckData = {
        'timestamp': DateTime.now().toIso8601String(),
        'statusCode': response.statusCode,
      };
      final galleryData = await _fetchModImages(nexusId);

      await _updateNexusInfoFile(modDirectory,
          updateCheckData: updateCheckData, galleryData: galleryData);
    } catch (e) {
      print(
          'No se pudo actualizar el archivo nexus_info.json para $modName: $e');
    }

    if (response.statusCode != 200) {
      print('Error for mod $nexusId: ${response.statusCode} - ${response.body}');
      return null;
    }

    final jsonResponse = json.decode(response.body);
    final allFiles = jsonResponse['files'] as List;
    final mainFiles =
        allFiles.where((file) => file['category_name'] == 'MAIN').toList();

    if (mainFiles.isNotEmpty) {
      List<dynamic> filesToConsider;
      final cnsFiles = mainFiles
          .where((file) =>
              (file['file_name'] as String).toLowerCase().contains('cns'))
          .toList();

      filesToConsider = cnsFiles.isNotEmpty ? cnsFiles : mainFiles;

      dynamic highestVersionFile;
      String highestVersion = "0";
      for (final file in filesToConsider) {
        final currentVersion = file['version'] as String;
        if (_compareVersions(currentVersion, highestVersion) > 0) {
          highestVersion = currentVersion;
          highestVersionFile = file;
        }
      }

      if (highestVersionFile != null) {
        final latestVersion = highestVersionFile['version'] as String;
        if (_compareVersions(latestVersion, localVersion) > 0) {
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
    const String apiKey =
        "Gstf7M2Sep0cumb7+FefEN5790jgkFUqytRNr5yMXIZJIH5A--iHhrBgPf1FnuQ9Mz--7uj2b1tAp0MgiJi+2bCgGQ==";
    final headers = {'apikey': apiKey, 'accept': 'application/json'};

    if (_cnsNexusId == nexusId) {
      final versionToCheck = newVersion ?? _cnsVersion;
      if (versionToCheck == null) return;
      final updateInfo = await _checkSingleModUpdate(
        headers: headers,
        nexusId: _cnsNexusId!,
        localVersion: versionToCheck,
        modName: "Custom Nanosuit System",
        modDirectory: Directory(
            p.join(_gameRootPath!, 'SB', 'Binaries', 'Win64', 'ue4ss')),
      );
      setState(() => _cnsUpdateInfo = updateInfo);
    } else {
      try {
        final modToRecheck = _allMods
            .firstWhere((m) => m.nexusId == nexusId);
        final versionToCheck = newVersion ?? modToRecheck.localVersion;
        if (versionToCheck != null) {
          final updateInfo = await _checkSingleModUpdate(
              headers: headers,
              nexusId: modToRecheck.nexusId!,
              localVersion: versionToCheck,
              modName: p.basename(modToRecheck.directory.path),
              modDirectory: modToRecheck.directory);
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

  // Lee el archivo unificado `nexus_info.json` y busca la clave "gallery".
  void _showImageGalleryDialog(ModInfo modInfo) async {
    final l10n = AppLocalizations.of(context)!;
    final infoFile = File(p.join(modInfo.directory.path, 'nexus_info.json'));
    List<dynamic> images = [];

    if (await infoFile.exists()) {
      try {
        final content = await infoFile.readAsString();
        final data = json.decode(content);
        // Busca la lista de imágenes dentro de la clave "gallery"
        if (data['gallery'] is List) {
          images = data['gallery'];
        }
      } catch (e) {
        print("Error al leer la galería desde nexus_info.json: $e");
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
                child: images.isNotEmpty
                    ? InteractiveViewer(
                        panEnabled: true,
                        minScale: 1.0,
                        maxScale: 4.0,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Image.network(
                            images.first['image'],
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                  child: Icon(Icons.error,
                                      color: Colors.redAccent));
                            },
                          ),
                        ),
                      )
                    : Center(child: Text(l10n.noImagesFound)),
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

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: Text(l10n.updateAvailable(newVersion)),
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

  List<ModInfo> _getFilteredAndSortedMods() {
    List<ModInfo> mods = List.from(_allMods);

    // Filtrado
    switch (_currentFilter) {
      case ModFilter.enabled:
        mods.retainWhere((mod) => mod.isEnabled);
        break;
      case ModFilter.disabled:
        mods.retainWhere((mod) => !mod.isEnabled);
        break;
      case ModFilter.all:
      default:
        // No hacer nada
        break;
    }
    
    // Búsqueda por texto
    if (_searchQuery.isNotEmpty) {
      mods.retainWhere((mod) => p.basename(mod.directory.path).toLowerCase().contains(_searchQuery.toLowerCase()));
    }

    // Ordenamiento
    switch (_currentSort) {
      case ModSort.name:
        mods.sort((a, b) => p.basename(a.directory.path).toLowerCase().compareTo(p.basename(b.directory.path).toLowerCase()));
        break;
      case ModSort.date:
      default:
        mods.sort((a, b) => b.lastModified.compareTo(a.lastModified));
        break;
    }

    return mods;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canInstall = _preparedMods.isNotEmpty && !_isLoading;
    final filteredAndSortedMods = _getFilteredAndSortedMods();

    final cnsUpdateIdentifier = _cnsUpdateInfo != null ? 'CNS_' + _cnsUpdateInfo!['version'] : '';
    final cnsIsIgnored = _ignoredUpdates.contains(cnsUpdateIdentifier);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(_cnsVersion != null
                ? l10n.appTitleWithVersion(_cnsVersion!)
                : l10n.appTitle),
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
            icon: const Icon(Icons.help_outline),
            tooltip: l10n.aboutTitle,
            onPressed: _showAboutDialog,
          ),
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: l10n.language,
            onPressed: _showLanguageDialog,
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
                        _buildSearchSection(l10n),
                        const SizedBox(height: 16),
                        Expanded(
                          child: _buildModsListSection(l10n.installedMods, filteredAndSortedMods, l10n),
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
                                value: null, // Indeterminate progress
                                backgroundColor: Colors.grey[800],
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.tealAccent),
                              ),
                            ],
                          )
                        else if (_isLoading)
                          const Center(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator()))
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.installNewMod,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.tealAccent)),
        const SizedBox(height: 16),
        ElevatedButton.icon(
            icon: const Icon(Icons.archive),
            label: Text(l10n.selectModArchive),
            onPressed: _isLoading ? null : _pickArchive),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          icon: const Icon(Icons.download_for_offline),
          label: Text(l10n.installSelectedMod),
          onPressed: canInstall ? _installMod : null,
          style: ElevatedButton.styleFrom(
              backgroundColor:
                  canInstall ? Colors.tealAccent : Colors.grey[700],
              foregroundColor: Colors.black87),
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

  Widget _buildSearchSection(AppLocalizations l10n) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: l10n.searchMods,
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.black.withOpacity(0.3),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
    );
  }

  Widget _buildModsListSection(
      String title, List<ModInfo> mods, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent)),
            Row(
              children: [
                PopupMenuButton<ModFilter>(
                  icon: const Icon(Icons.filter_list),
                  onSelected: (ModFilter result) {
                    setState(() {
                      _currentFilter = result;
                    });
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<ModFilter>>[
                    PopupMenuItem<ModFilter>(
                      value: ModFilter.all,
                      child: Text(l10n.filterAll),
                    ),
                    PopupMenuItem<ModFilter>(
                      value: ModFilter.enabled,
                      child: Text(l10n.filterEnabled),
                    ),
                    PopupMenuItem<ModFilter>(
                      value: ModFilter.disabled,
                      child: Text(l10n.filterDisabled),
                    ),
                  ],
                ),
                PopupMenuButton<ModSort>(
                  icon: const Icon(Icons.sort),
                  onSelected: (ModSort result) {
                    setState(() {
                      _currentSort = result;
                    });
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<ModSort>>[
                    PopupMenuItem<ModSort>(
                      value: ModSort.date,
                      child: Text(l10n.sortByDate),
                    ),
                    PopupMenuItem<ModSort>(
                      value: ModSort.name,
                      child: Text(l10n.sortByName),
                    ),
                  ],
                ),
                IconButton(
                    icon: const Icon(Icons.folder_special_outlined),
                    onPressed: _isLoading
                        ? null
                        : () => _showInExplorer(Directory(_finalModsPath!)),
                    tooltip: l10n.openModsFolder),
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
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[700]!)),
            child: mods.isEmpty
                ? Center(
                    child: Text(
                        l10n.noModsFound,
                        style: const TextStyle(color: Colors.grey)))
                : ListView.builder(
                    itemCount: mods.length,
                    itemBuilder: (context, index) {
                      final modInfo = mods[index];
                      final modName = p.basename(modInfo.directory.path);
                      final isHighlighted = _lastInstalledModNames.contains(modName);
                      final updateInfo = _modUpdates[modInfo.directory.path];
                      final hasUpdate = updateInfo != null;
                      final updateIdentifier = hasUpdate ? modInfo.directory.path + updateInfo!['version'] : '';
                      final isIgnored = _ignoredUpdates.contains(updateIdentifier);

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        color: isHighlighted
                            ? Colors.teal.withOpacity(0.3)
                            : (modInfo.isEnabled ? Colors.grey[850] : Colors.orange[900]?.withOpacity(0.2)),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: hasUpdate && !isIgnored
                                    ? Colors.yellowAccent
                                    : (isHighlighted
                                        ? Colors.tealAccent
                                        : Colors.transparent),
                                width: hasUpdate && !isIgnored ? 2.0 : 1.5),
                            borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          leading: Icon(Icons.extension,
                              color: modInfo.isEnabled
                                  ? Colors.tealAccent
                                  : Colors.grey),
                          title: Row(
                            children: [
                              Flexible(
                                  child: Text(modName,
                                      style: TextStyle(
                                          color: modInfo.isEnabled
                                              ? Colors.white
                                              : Colors.grey))),
                              if (isHighlighted)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Icon(Icons.new_releases,
                                      color: Colors.yellow[700], size: 18),
                                ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 6. Botón Basura (solo si está desactivado)
                              if (!modInfo.isEnabled)
                                IconButton(
                                  icon: const Icon(Icons.delete_forever,
                                      color: Colors.redAccent),
                                  onPressed: _isLoading
                                      ? null
                                      : () => _deleteModPermanently(modInfo),
                                  tooltip: l10n.deletePermanently,
                                ),
                              // 5. Botón Campana (si hay actualización y no está ignorada)
                              if (hasUpdate && !isIgnored)
                                IconButton(
                                  icon: const Icon(
                                      Icons.notification_important,
                                      color: Colors.yellowAccent),
                                  tooltip: l10n
                                      .updateAvailable(updateInfo!['version']),
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
                              // 4. Botón Carpeta
                              IconButton(
                                icon: const Icon(Icons.folder_open,
                                    color: Colors.white70),
                                onPressed: _isLoading
                                    ? null
                                    : () => _showInExplorer(modInfo.directory),
                                tooltip: l10n.showInFolder,
                              ),
                              // 3. Botón Galería (si tiene nexusId)
                              if (modInfo.nexusId != null)
                                IconButton(
                                  icon: const Icon(
                                      Icons.photo_library_outlined,
                                      color: Colors.purpleAccent),
                                  onPressed: () =>
                                      _showImageGalleryDialog(modInfo),
                                  tooltip: l10n.viewImageGallery,
                                ),
                              // 2. Botón Enlace (si tiene nexusId)
                              if (modInfo.nexusId != null)
                                IconButton(
                                  icon: const Icon(Icons.link,
                                      color: Colors.lightBlueAccent),
                                  onPressed: () async {
                                    final url = Uri.parse(
                                        'https://www.nexusmods.com/stellarblade/mods/${modInfo.nexusId}');
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url);
                                    }
                                  },
                                  tooltip: l10n.openInNexusMods,
                                ),
                              // 1. Botón Encendido/Apagado
                              if (modInfo.isEnabled)
                                IconButton(
                                  icon: const Icon(Icons.power_settings_new,
                                      color: Colors.orangeAccent),
                                  onPressed: _isLoading
                                      ? null
                                      : () => _disableMod(modInfo),
                                  tooltip: l10n.disableMod,
                                )
                              else
                                IconButton(
                                  icon: const Icon(Icons.power_settings_new,
                                      color: Colors.greenAccent),
                                  onPressed: _isLoading
                                      ? null
                                      : () => _enableMod(modInfo),
                                  tooltip: l10n.enableMod,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}