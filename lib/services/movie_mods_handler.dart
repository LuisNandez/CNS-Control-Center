import 'dart:io';
import 'package:path/path.dart' as p;
import 'special_mods_handler.dart';

class MovieModsHandler {
  /// Analiza si el mod de películas tiene varias carpetas para dar a elegir,
  /// o si es de instalación directa. Usa las mismas estructuras que SpecialModsHandler.
  static Future<SpecialModData> parseMovieMod(String archiveName, Directory sourceDir) async {
    List<File> mainFiles = [];
    List<SpecialModOption> options = [];

    await for (final entity in sourceDir.list(recursive: false)) {
      if (entity is File) {
        final ext = p.extension(entity.path).toLowerCase();
        if (ext == '.bk2' || ext == '.webm') {
          mainFiles.add(entity);
        }
      } else if (entity is Directory) {
        // Revisamos si la subcarpeta contiene vídeos
        bool hasVideos = false;
        await for (final subEntity in entity.list(recursive: true)) {
          if (subEntity is File) {
            final ext = p.extension(subEntity.path).toLowerCase();
            if (ext == '.bk2' || ext == '.webm') {
              hasVideos = true;
              break;
            }
          }
        }
        if (hasVideos) {
          options.add(SpecialModOption(name: p.basename(entity.path), directory: entity));
        }
      }
    }
    
    options.sort((a, b) => a.name.compareTo(b.name));

    return SpecialModData(
      nexusId: 'movie_$archiveName', // ID ficticio para mantener compatibilidad con la UI
      mainFiles: mainFiles,
      options: options,
      originalDir: sourceDir,
    );
  }

  /// Compacta la numeración de los vídeos en la carpeta Menu.
  /// Ej: Si existen menu_0.bk2 y menu_2.webm, renombrará el 2 a menu_1.webm.
  static Future<int> getNextAvailableIndex(Directory menuDir) async {
    if (!await menuDir.exists()) return 0;

    Set<int> usedIndices = {};
    final regex = RegExp(r'^menu_(\d+)\.(bk2|webm)$', caseSensitive: false);

    await for (final entity in menuDir.list()) {
      final match = regex.firstMatch(p.basename(entity.path));
      if (match != null) {
        usedIndices.add(int.parse(match.group(1)!));
      }
    }

    int index = 0;
    while (usedIndices.contains(index)) {
      index++;
    }
    return index;
  }

  /// Procesa los archivos según la política clásica (Sin Mod 529)
  /// Retorna un mapa indicando {RutaOrigen: NombreFinalDeseado}
  static Map<File, String> mapFilesForClassicReplacement(List<File> sourceFiles) {
    Map<File, String> mappings = {};
    // El método clásico ignora absolutamente los .webm
    final bk2Files = sourceFiles.where((f) => p.extension(f.path).toLowerCase() == '.bk2').toList();
    
    if (bk2Files.isEmpty) return mappings;

    // Buscamos los archivos específicos sin importar cuántos archivos extra haya
    File? titleFile;
    File? fusionFile;

    for (var file in bk2Files) {
      final name = p.basename(file.path).toLowerCase();
      if (name == 'eve_title.bk2') {
        titleFile = file;
      } else if (name == 'eve_title_fusion.bk2') {
        fusionFile = file;
      }
    }

    if (titleFile != null && fusionFile != null) {
      // Si encontramos ambos, respetamos sus nombres y mapeamos los dos.
      // Se ignoran automáticamente otros .bk2 (como los de menú).
      mappings[titleFile] = p.basename(titleFile.path);
      mappings[fusionFile] = p.basename(fusionFile.path);
    } else if (titleFile != null) {
      // Si solo encontramos el título normal
      mappings[titleFile] = p.basename(titleFile.path);
    } else {
      // Situación pragmática: archivos con nombres al azar o que eran para el menú.
      // Tomamos el primer archivo .bk2 de la lista y lo forzamos a ser el título principal.
      mappings[bk2Files.first] = 'EVE_Title.bk2';
    }

    return mappings;
  }
}