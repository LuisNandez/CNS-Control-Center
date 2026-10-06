// lib/services/config_mod_detector.dart
//
// Reconocimiento de mods tipo CONFIG: archivos .ini de Unreal que se copian a
// %LOCALAPPDATA%\SB\Saved\Config\WindowsNoEditor (con copia de seguridad del
// original, ver _enableCustomFileMod en main.dart).
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:path/path.dart' as p;

class ConfigModDetector {
  /// Nombres (en minúsculas) de los .ini que el juego lee desde su carpeta
  /// Saved/Config/WindowsNoEditor.
  static const Set<String> knownConfigFiles = {
    'engine.ini',
    'scalability.ini',
    'input.ini',
    'game.ini',
    'gameusersettings.ini',
    'deviceprofiles.ini',
    'compat.ini',
    'hardware.ini',
  };

  /// .ini que NUNCA son un mod de config (pertenecen a UE4SS, al sistema o al
  /// propio juego).
  static const Set<String> _neverConfig = {
    'ue4ss-settings.ini',
    'vtablelayout.ini',
    'desktop.ini',
    'manifest.ini',
  };

  static const int _sniffBytes = 16 * 1024;

  /// ¿El nombre de archivo es un .ini de configuración del juego?
  static bool isConfigFileName(String pathOrName) {
    final name = p.basename(pathOrName).toLowerCase();
    if (_neverConfig.contains(name)) return false;
    return knownConfigFiles.contains(name);
  }

  /// Comprueba que el archivo es texto (no un binario renombrado a .ini).
  /// Acepta ASCII/UTF-8 y UTF-16 con BOM (el formato que usa Unreal).
  static Future<bool> isValidIni(File f) async {
    try {
      final len = await f.length();
      if (len == 0) return true; // un .ini vacío es válido (restablece ajustes)
      final raf = await f.open();
      List<int> bytes;
      try {
        bytes = await raf.read(math.min(len, _sniffBytes));
      } finally {
        await raf.close();
      }
      if (bytes.length >= 2 &&
          ((bytes[0] == 0xFF && bytes[1] == 0xFE) ||
              (bytes[0] == 0xFE && bytes[1] == 0xFF))) {
        return true; // UTF-16 con BOM
      }
      // Texto normal: no puede contener bytes nulos.
      return !bytes.contains(0);
    } catch (_) {
      return false;
    }
  }

  /// Archivos de configuración válidos dentro de [dir].
  static Future<List<File>> findConfigFiles(Directory dir,
      {bool recursive = false}) async {
    final out = <File>[];
    try {
      await for (final e in dir.list(recursive: recursive, followLinks: false)) {
        if (e is! File) continue;
        if (!isConfigFileName(e.path)) continue;
        if (_insideIgnoredFolder(e.path, dir.path)) continue;
        if (await isValidIni(e)) out.add(e);
      }
    } catch (_) {}
    return out;
  }

  static Future<bool> hasConfigFiles(Directory dir,
      {bool recursive = false}) async {
    return (await findConfigFiles(dir, recursive: recursive)).isNotEmpty;
  }

  /// Ignora carpetas de metadatos (__MACOSX, .git...) y las que usa la propia
  /// app para sus copias (__...).
  static bool _insideIgnoredFolder(String filePath, String rootPath) {
    final rel = p.relative(p.dirname(filePath), from: rootPath);
    if (rel == '.' || rel.isEmpty) return false;
    return p.split(rel).any((s) => s.startsWith('__') || s.startsWith('.'));
  }

  /// Vista previa de texto de un .ini (para depurar o mostrar en la UI).
  static Future<String> preview(File f, {int maxChars = 400}) async {
    try {
      final text = await f.readAsString(encoding: latin1);
      return text.length <= maxChars ? text : text.substring(0, maxChars);
    } catch (_) {
      return '';
    }
  }
}