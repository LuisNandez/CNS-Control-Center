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

  SpecialModData({
    required this.nexusId,
    required this.mainFiles,
    required this.options,
    required this.originalDir,
  });
}

class SpecialModsHandler {
  // Lista de IDs de Nexus que requieren este trato especial
  static const List<String> supportedSpecialMods = ['550'];

  /// Verifica si el ID corresponde a un mod especial soportado
  static bool isSpecialMod(String? nexusId) {
    return nexusId != null && supportedSpecialMods.contains(nexusId);
  }

  /// Lee el directorio extraído y separa los archivos principales de las carpetas opcionales
  static Future<SpecialModData> parseMod(String nexusId, Directory sourceDir) async {
    List<File> mainFiles = [];
    List<SpecialModOption> options = [];

    await for (final entity in sourceDir.list(recursive: false)) {
      if (entity is File) {
        // Archivos sueltos en la raíz (los 6 archivos principales)
        mainFiles.add(entity);
      } else if (entity is Directory) {
        // Carpetas de opciones
        final folderName = p.basename(entity.path);
        // Evitamos carpetas ocultas o del sistema
        if (!folderName.startsWith('.') && !folderName.startsWith('__')) {
          options.add(SpecialModOption(name: folderName, directory: entity));
        }
      }
    }

    // Ordenamos las opciones alfabéticamente para mejor presentación en la UI
    options.sort((a, b) => a.name.compareTo(b.name));

    return SpecialModData(
      nexusId: nexusId,
      mainFiles: mainFiles,
      options: options,
      originalDir: sourceDir,
    );
  }

  /// Construye un nuevo directorio temporal fusionando los archivos principales 
  /// con el contenido de las subcarpetas de las opciones seleccionadas.
  static Future<Directory> buildSelectedInstallation(
    SpecialModData modData,
    Directory tempRoot,
  ) async {
    final destDir = Directory(p.join(tempRoot.path, 'custom_install_${modData.nexusId}'));
    if (await destDir.exists()) {
      await destDir.delete(recursive: true);
    }
    await destDir.create(recursive: true);

    // 1. Copiar archivos principales a la raíz del nuevo directorio
    for (final file in modData.mainFiles) {
      final destPath = p.join(destDir.path, p.basename(file.path));
      await file.copy(destPath);
    }

    // 2. Copiar el contenido de las subcarpetas seleccionadas
    for (final option in modData.options.where((o) => o.isSelected)) {
      // Entramos a la opción y buscamos su subcarpeta
      await for (final subEntity in option.directory.list(recursive: false)) {
        if (subEntity is Directory) {
          // Es la subcarpeta (donde están los archivos reales)
          // Copiamos su contenido a la raíz de la instalación
          await _copyDirectoryContents(subEntity, destDir);
        }
      }
    }

    return destDir;
  }

  /// Función auxiliar para copiar recursivamente el contenido de una carpeta
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