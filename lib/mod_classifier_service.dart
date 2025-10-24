// lib/mod_classifier_service.dart
import 'dart:io';
import 'package:path/path.dart' as p;

/// Define el tipo de mod encontrado en un directorio.
enum ModDirectoryType {
  /// Un mod CNS, gestionable por esta app.
  cns,
  /// Un mod Pak genérico, instalable pero no gestionable por la UI.
  genericPak,
  /// No es un mod o es desconocido.
  unknown
}

class ModClassifierService {
  /// Clasifica un directorio como un mod CNS o un mod Pak Genérico
  /// basado en su contenido, siguiendo tus definiciones.
  static Future<ModDirectoryType> classifyModDirectory(Directory modDir) async {
    bool hasJson = false;
    bool hasPakFile = false; // Variable para .pak, .ucas o .utoc

    // Solo escaneamos la raíz del directorio del mod (no subcarpetas).
    await for (final entity in modDir.list(recursive: false, followLinks: false)) {
      if (entity is File) {
        final extension = p.extension(entity.path).toLowerCase();

        if (extension == '.json') {
          hasJson = true;
        } else if (extension == '.pak' || extension == '.ucas' || extension == '.utoc') {
          hasPakFile = true;
        }
      }
    }

    // --- NUEVA LÓGICA DE CLASIFICACIÓN ---

    // Regla 1: Mod CNS
    // Si tiene CUALQUIER .json Y al menos un archivo .pak, .ucas, o .utoc,
    // es un mod CNS.
    if (hasJson && hasPakFile) {
      return ModDirectoryType.cns;
    }

    // Regla 2: Mod Genérico
    // Si NO tiene .json PERO SÍ tiene al menos un archivo .pak, .ucas, o .utoc,
    // es un mod Genérico.
    if (!hasJson && hasPakFile) {
      return ModDirectoryType.genericPak;
    }

    // Regla 3: Desconocido
    // Si no tiene archivos .pak o .json, no es un mod que podamos manejar.
    return ModDirectoryType.unknown;
  }
}