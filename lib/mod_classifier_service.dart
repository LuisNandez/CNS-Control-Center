import 'dart:io';
import 'package:path/path.dart' as p;

/// Define el tipo de mod encontrado en un directorio.
enum ModDirectoryType {
  /// Un mod CNS, gestionable por esta app.
  cns,
  /// Un mod Pak genérico, instalable pero no gestionable por la UI.
  genericPak,
  /// Un mod de reemplazo de película (.bk2).
  movies,
  /// Un mod de lógica de scripts (UE4SS + Paks).
  logicMod, // ++ AÑADIDO ++
  /// No es un mod o es desconocido.
  unknown
}

class ModClassifierService {
  /// Clasifica un directorio como un mod CNS, Genérico o de Películas
  /// basado en su contenido.
  static Future<ModDirectoryType> classifyModDirectory(Directory modDir) async {
    bool hasJson = false;
    bool hasPakFile = false; // Variable para .pak, .ucas o .utoc
    bool hasBk2File = false; // Variable para .bk2

    // NOTA: Esta función clasifica mods YA INSTALADOS.
    // La detección de 'logicMod' desde un ZIP se hace en main.dart.
    // Un 'logicMod' instalado se identificará por su 'nexus_info.json'
    // que tendrá "modType": "logicMod".
    // Esta función se usa como fallback o para clasificar mods extraídos.

    // Solo escaneamos la raíz del directorio del mod (no subcarpetas).
    await for (final entity in modDir.list(recursive: false, followLinks: false)) {
      if (entity is File) {
        final extension = p.extension(entity.path).toLowerCase();

        if (extension == '.json') {
          hasJson = true;
        } else if (extension == '.pak' || extension == '.ucas' || extension == '.utoc') {
          hasPakFile = true;
        } else if (extension == '.bk2') {
          hasBk2File = true;
        }
      }
    }

    // --- LÓGICA DE CLASIFICACIÓN (CON PRIORIDAD) ---

    // Regla 1: Mod CNS
    // Si tiene CUALQUIER .json Y al menos un archivo .pak, es CNS.
    if (hasJson && hasPakFile) {
      return ModDirectoryType.cns;
    }

    // Regla 2: Mod Genérico
    // Si NO tiene .json PERO SÍ tiene al menos un .pak, es Genérico.
    if (!hasJson && hasPakFile) {
      return ModDirectoryType.genericPak;
    }

    // Regla 3: Mod de Películas
    // Si tiene un .bk2 Y NO tiene ni .json ni .pak, es un mod de Películas.
    if (hasBk2File && !hasJson && !hasPakFile) {
      return ModDirectoryType.movies;
    }
    
    // Regla 4: Desconocido
    return ModDirectoryType.unknown;
  }
}