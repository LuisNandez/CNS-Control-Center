import 'dart:io';
import 'package:path/path.dart' as p;

enum ModDirectoryType {
  cns,
  genericPak,
  movies,
  logicMod,
  unknown
}

class ModClassifierService {
  static Future<ModDirectoryType> classifyModDirectory(Directory modDir) async {
    bool hasJson = false;
    bool hasPakFile = false;
    bool hasMovieFile = false; // Cambiado para abarcar .bk2 y .webm

    await for (final entity in modDir.list(recursive: false, followLinks: false)) {
      if (entity is File) {
        final extension = p.extension(entity.path).toLowerCase();

        if (extension == '.json') {
          hasJson = true;
        } else if (extension == '.pak' || extension == '.ucas' || extension == '.utoc') {
          hasPakFile = true;
        } else if (extension == '.bk2' || extension == '.webm') {
          hasMovieFile = true; // Ahora detecta ambos formatos
        }
      }
    }

    if (hasJson && hasPakFile) return ModDirectoryType.cns;
    if (!hasJson && hasPakFile) return ModDirectoryType.genericPak;
    
    // Si tiene archivos de vídeo y no tiene paks ni json, es de películas
    if (hasMovieFile && !hasJson && !hasPakFile) return ModDirectoryType.movies;
    
    return ModDirectoryType.unknown;
  }
}