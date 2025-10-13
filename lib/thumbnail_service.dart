// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

// NOTE: The resizing logic has been removed. This service now caches
// original images in two layers: on-disk for persistence and in-memory for speed.

class ThumbnailService {
  static final ThumbnailService _instance = ThumbnailService._internal();
  factory ThumbnailService() => _instance;
  ThumbnailService._internal();

  Directory? _imageCacheDir; // Directory for original downloaded images
  bool _isInitialized = false;

  // In-memory cache to store loaded image files for the current session.
  final Map<String, File> _inMemoryCache = {};

  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      // Use getApplicationSupportDirectory for app-managed files that are not user-facing.
      final appDir = await getApplicationSupportDirectory(); 
      
      // Directory for raw downloaded images from the web
      _imageCacheDir = Directory(p.join(appDir.path, 'image_cache'));
      if (!await _imageCacheDir!.exists()) {
        await _imageCacheDir!.create(recursive: true);
      }

      _isInitialized = true;
    } catch (e) {
      print("Failed to initialize ThumbnailService directories: $e");
    }
  }

  // NEW: Synchronous method to get from memory cache.
  File? getFromMemoryCache(String imageUrl) {
    return _inMemoryCache[imageUrl];
  }

  // Generates a safe filename from a URL using a hash.
  String _getHashedFileName(String url) {
    final bytes = utf8.encode(url);
    final digest = sha1.convert(bytes);
    // Try to preserve original extension for content type, fallback to .jpg
    final fileExtension = p.extension(url).isNotEmpty ? p.extension(url) : '.jpg';
    return '$digest$fileExtension';
  }

  // The main method the UI will call. It now fetches the original image directly.
  Future<File?> getThumbnail(String imageUrl) async {
    if (!_isInitialized) await initialize();
    if (_imageCacheDir == null) return null;
      
    // 1. Check in-memory cache first for instant access.
    if (_inMemoryCache.containsKey(imageUrl)) {
      return _inMemoryCache[imageUrl];
    }

    final hashedName = _getHashedFileName(imageUrl);
    final cachedImageFile = File(p.join(_imageCacheDir!.path, hashedName));

    // 2. Check on-disk cache.
    if (await cachedImageFile.exists()) {
        // Load from disk and add to in-memory cache for next time.
        _inMemoryCache[imageUrl] = cachedImageFile;
        return cachedImageFile;
    }

    // 3. Otherwise, download it from the network.
    try {
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
            await cachedImageFile.writeAsBytes(response.bodyBytes);
            // Add to in-memory cache after successful download.
            _inMemoryCache[imageUrl] = cachedImageFile;
            return cachedImageFile;
        } else {
            print("Failed to download image from $imageUrl. Status: ${response.statusCode}");
        }
    } catch (e) {
        print("Error downloading image from $imageUrl: $e");
    }
      
    return null;
  }
}

