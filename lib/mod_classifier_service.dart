import 'dart:io';
import 'package:path/path.dart' as p;

enum ModDirectoryType {
  cns,
  genericPak,
  movies,
  logicMod,
  save,       // <-- NUEVO
  config,     // <-- NUEVO
  splash,     // <-- NUEVO
  unknown
}

class ModClassifierService {
  static Future<ModDirectoryType> classifyModDirectory(Directory modDir) async {
    bool hasJson = false;
    bool hasPakFile = false;
    bool hasMovieFile = false; // Cambiado para abarcar .bk2 y .webm
    bool hasSaveFile = false;   // <-- NUEVO
    bool hasConfigFile = false; // <-- NUEVO
    bool hasSplashFile = false; // <-- NUEVO

    await for (final entity in modDir.list(recursive: false, followLinks: false)) {
      if (entity is File) {
        final extension = p.extension(entity.path).toLowerCase();
        final basename = p.basename(entity.path).toLowerCase();

        if (extension == '.json') {
          hasJson = true;
        } else if (extension == '.pak' || extension == '.ucas' || extension == '.utoc') {
          hasPakFile = true;
        } else if (extension == '.bk2' || extension == '.webm') {
          hasMovieFile = true; // Ahora detecta ambos formatos
        } else if (extension == '.sav') {
          hasSaveFile = true; // <-- NUEVO
        } else if (['engine.ini', 'scalability.ini', 'input.ini', 'game.ini'].contains(basename)) {
          hasConfigFile = true; // <-- NUEVO
        } else if (basename == 'splash.bmp' || extension == '.bat' || (['.bmp', '.jpg', '.jpeg', '.png'].contains(extension) && entity.path.toLowerCase().contains('splash'))) {
          hasSplashFile = true; // <-- AHORA DETECTA IMÁGENES DENTRO DE CARPETAS "SPLASH"
        }
      }
    }

    if (hasJson && hasPakFile) return ModDirectoryType.cns;
    if (!hasJson && hasPakFile) return ModDirectoryType.genericPak;
    
    // Si tiene archivos de vídeo y no tiene paks ni json, es de películas
    if (hasMovieFile && !hasJson && !hasPakFile) return ModDirectoryType.movies;
    if (hasSaveFile) return ModDirectoryType.save;     // <-- NUEVO
    if (hasConfigFile) return ModDirectoryType.config; // <-- NUEVO
    if (hasSplashFile) return ModDirectoryType.splash; // <-- NUEVO
    
    return ModDirectoryType.unknown;
  }
}