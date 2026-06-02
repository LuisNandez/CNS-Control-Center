import 'dart:io';
import '../mod_classifier_service.dart';

class PreparedMod {
  final Directory sourceDir;
  final Directory? ue4ssDir;
  final Directory? tildeModsDir;
  final String? nexusId;
  final String? nexusVersion;
  final String archiveName;
  final ModDirectoryType modType;

  PreparedMod({
    required this.sourceDir,
    this.ue4ssDir,
    this.tildeModsDir,
    this.nexusId,
    this.nexusVersion,
    required this.archiveName,
    required this.modType,
  });
}

class PreparedUE4SS {
  final Directory sourceDir;
  PreparedUE4SS({required this.sourceDir});
}

class ArchiveProcessingResult {
  final List<PreparedMod> preparedMods;
  final PreparedUE4SS? preparedUE4SS;
  final Directory? cnsUpdateDir;

  ArchiveProcessingResult({
    required this.preparedMods,
    this.preparedUE4SS,
    this.cnsUpdateDir,
  });
}