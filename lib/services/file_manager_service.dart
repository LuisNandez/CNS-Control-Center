import 'dart:io';
import 'package:path/path.dart' as p;

class FileManagerService {
  static Future<bool> deleteDirectoryWithRetry(Directory dir, {int retries = 3}) async {
    for (int i = 0; i < retries; i++) {
      try {
        if (await dir.exists()) {
          await dir.delete(recursive: true);
        }
        return true;
      } on PathAccessException {
        print('Access denied while deleting ${dir.path}. Retrying (${i + 1}/$retries)...');
        await Future.delayed(const Duration(milliseconds: 300));
      } catch (e) {
        rethrow;
      }
    }
    print('Could not delete directory ${dir.path} after $retries attempts.');
    return false;
  }

  static Future<void> copyDirectory(Directory source, Directory destination) async {
    await for (var entity in source.list(recursive: false)) {
      if (entity is Directory) {
        var newDirectory = Directory(
          p.join(destination.absolute.path, p.basename(entity.path)),
        );
        await newDirectory.create();
        await copyDirectory(entity.absolute, newDirectory.absolute);
      } else if (entity is File) {
        await entity.copy(p.join(destination.path, p.basename(entity.path)));
      }
    }
  }

  static Future<void> moveMod(Directory modDir, String toPath) async {
    final modName = p.basename(modDir.path);
    final destinationPath = p.join(toPath, modName);
    await modDir.rename(destinationPath);
  }

  static Future<List<File>> findAllModFilesRecursive(Directory dir) async {
    final List<File> foundFiles = [];
    const validExtensions = ['.json', '.pak', '.ucas', '.utoc', '.bk2', '.lua', '.txt'];
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File && validExtensions.contains(p.extension(entity.path).toLowerCase())) {
        foundFiles.add(entity);
      }
    }
    return foundFiles;
  }
}