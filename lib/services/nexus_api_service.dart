import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/version_utils.dart';

class NexusApiService {
  static Future<bool> validateApiKey(String apiKey) async {
    if (apiKey.isEmpty) return false;
    try {
      final response = await http.get(
        Uri.parse('https://api.nexusmods.com/v1/users/validate.json'),
        headers: {'apikey': apiKey, 'accept': 'application/json'},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error validating API key: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> fetchNexusModData(String nexusId, String? apiKey) async {
    if (apiKey == null || apiKey.isEmpty) {
      print("API Key not configured, not fetching Nexus data.");
      return null;
    }
    final headers = {'apikey': apiKey, 'accept': 'application/json'};

    try {
      final modDetailsUrl = Uri.parse(
        'https://api.nexusmods.com/v1/games/stellarblade/mods/$nexusId.json',
      );
      var response = await http.get(modDetailsUrl, headers: headers);

      if (response.statusCode == 200) {
        final modDetails = json.decode(response.body);

        final pictureUrl = modDetails['picture_url'] as String?;
        String? summary = modDetails['summary'] as String?;
        if (summary != null) {
          summary = summary.replaceAll('<br />', '\n');
        }
        String? description = modDetails['description'] as String?;
        if (description != null) {
          description = description.replaceAll('<br />', '\n');
        }
        final author = modDetails['author'] as String?;

        List<Map<String, dynamic>>? gallery;
        if (pictureUrl != null && pictureUrl.isNotEmpty) {
          gallery = [{"image": pictureUrl, "thumbnail": pictureUrl}];
        }

        return {
          'gallery': gallery,
          'summary': summary,
          'author': author,
          'description': description,
        };
      }
      print("Failed to fetch Nexus data for mod $nexusId (code: ${response.statusCode}).");
      return null;
    } catch (e) {
      print("An exception occurred while fetching Nexus data for mod $nexusId: $e");
      return null;
    }
  }

  static Future<String?> fetchLatestModVersion(String nexusId, String? apiKey) async {
    try {
      if (apiKey == null || apiKey.isEmpty) return null;
      final headers = {'apikey': apiKey, 'accept': 'application/json'};
      final url = Uri.parse(
        'https://api.nexusmods.com/v1/games/stellarblade/mods/$nexusId/files.json',
      );
      final response = await http.get(url, headers: headers);

      if (response.statusCode != 200) return null;

      final jsonResponse = json.decode(response.body);
      final allFiles = jsonResponse['files'] as List;

      dynamic highestVersionFile;
      String highestVersion = "0";
      
      for (final file in allFiles) {
        final currentVersion = file['version'] as String?;
        if (currentVersion != null &&
            VersionUtils.compareVersions(currentVersion, highestVersion) > 0) {
          highestVersion = currentVersion;
          highestVersionFile = file;
        }
      }
      return highestVersionFile?['version'];
    } catch (e) {
      print('Error fetching latest version for mod $nexusId: $e');
      return null;
    }
  }

  static Future<bool> isValidNexusId(String modId, String? apiKey) async {
    if (apiKey == null || apiKey.isEmpty) return false;
    try {
      final uri = Uri.parse(
        'https://api.nexusmods.com/v1/games/stellarblade/mods/$modId.json',
      );
      final response = await http.get(
        uri,
        headers: {'apikey': apiKey, 'accept': 'application/json'},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error during API validation for mod ID $modId: $e');
      return false;
    }
  }
}