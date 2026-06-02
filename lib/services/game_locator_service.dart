import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:win32_registry/win32_registry.dart';

class GameLocatorService {
  static Future<String?> findSteamInstallation() async {
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
}