import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';

/// Modelo que representa una opción seleccionable del mod
class SpecialModOption {
  final String name;
  final Directory directory;
  bool isSelected;

  SpecialModOption({
    required this.name,
    required this.directory,
    this.isSelected = false,
  });
}

/// Datos extraídos de un mod especial soportado
class SpecialModData {
  final String nexusId;
  final List<File> mainFiles;
  final List<SpecialModOption> options;
  final Directory originalDir;
  final bool isSingleSelection;

  SpecialModData({
    required this.nexusId,
    required this.mainFiles,
    required this.options,
    required this.originalDir,
    this.isSingleSelection = false,
  });
}

class SpecialModsHandler {
  static const List<String> supportedSpecialMods = ['30', '390', '550', '801', '1112'];

  static bool isSpecialMod(String? nexusId) {
    return nexusId != null && supportedSpecialMods.contains(nexusId);
  }

  static Future<SpecialModData> parseMod(String nexusId, Directory sourceDir) async {
    List<File> mainFiles = [];
    List<SpecialModOption> options = [];

    // 1. Archivos principales (sueltos en la raíz)
    await for (final entity in sourceDir.list(recursive: false)) {
      if (entity is File) {
        mainFiles.add(entity);
      }
    }

    // 2. Búsqueda profunda de opciones (cualquier carpeta que contenga un .pak, .bat o .bmp)
    await for (final entity in sourceDir.list(recursive: true)) {
      if (entity is File) {
        final ext = p.extension(entity.path).toLowerCase();
        if (ext == '.pak' || ext == '.bat' || ext == '.bmp') {
          final parentDir = entity.parent;
        
        // Si el .pak está en la raíz absoluta, ya es un mainFile
        if (parentDir.path == sourceDir.path) continue;

        // Evita agregar la misma carpeta varias veces si tiene múltiples paks
          if (!options.any((o) => o.directory.path == parentDir.path)) {
            // Genera un nombre jerárquico bonito basado en las carpetas
            final relativePath = p.relative(parentDir.path, from: sourceDir.path);
            String optionName = relativePath.replaceAll(Platform.pathSeparator, ' / ');

            // CORRECCIÓN AQUÍ: Forma nativa de Dart para ignorar mayúsculas/minúsculas
            // Esto transformará "Color Azul / ~mods" en simplemente "Color Azul"
            optionName = optionName.replaceAll(RegExp(r'\s*/\s*~mods$', caseSensitive: false), '');

            options.add(SpecialModOption(name: optionName, directory: parentDir));
         }
        }
      }
    }

    options.sort((a, b) => a.name.compareTo(b.name));
    
    // AÑADIDO: '390' y '30' a la lógica de selección única (Radio Buttons)
    final bool singleSelection = nexusId == '30' || nexusId == '390' || nexusId == '1112';

    return SpecialModData(
      nexusId: nexusId,
      mainFiles: mainFiles,
      options: options,
      originalDir: sourceDir,
      isSingleSelection: singleSelection,
    );
  }

  static Future<Directory> buildSelectedInstallation(
    SpecialModData modData,
    Directory tempRoot,
  ) async {
    final destDir = Directory(p.join(tempRoot.path, 'custom_install_${modData.nexusId}'));
    if (await destDir.exists()) {
      await destDir.delete(recursive: true);
    }
    await destDir.create(recursive: true);

    // 1. Copiar archivos principales
    for (final file in modData.mainFiles) {
      final destPath = p.join(destDir.path, p.basename(file.path));
      await file.copy(destPath);
    }

    // 2. Copiar archivos de las opciones seleccionadas
    for (final option in modData.options.where((o) => o.isSelected)) {
      await for (final subEntity in option.directory.list(recursive: false)) {
        if (subEntity is Directory) {
          await _copyDirectoryContents(subEntity, destDir);
        } else if (subEntity is File) {
          // Copiamos los archivos (.pak, .ucas) directamente a la raíz de la instalación
          // Sin importar si vinieron de una carpeta llamada ~mods o no.
          final destPath = p.join(destDir.path, p.basename(subEntity.path));
          await subEntity.copy(destPath);
        }
      }
    }

    return destDir;
  }

  static Future<void> _copyDirectoryContents(Directory source, Directory destination) async {
    await for (var entity in source.list(recursive: true)) {
      if (entity is File) {
        final relativePath = p.relative(entity.path, from: source.path);
        final destFile = File(p.join(destination.path, relativePath));
        await destFile.parent.create(recursive: true);
        await entity.copy(destFile.path);
      }
    }
  }
}