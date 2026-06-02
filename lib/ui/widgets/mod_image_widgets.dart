import 'dart:io';
import 'package:flutter/material.dart';
import '../../thumbnail_service.dart';

class ModImage extends StatelessWidget {
  final String imageUrl;
  final bool isLocal;
  final DateTime? lastModified;
  final BoxFit fit;
  final double? height;

  const ModImage({
    super.key,
    required this.imageUrl,
    this.isLocal = false,
    this.lastModified,
    this.fit = BoxFit.cover,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (isLocal) {
      return Image.file(
        File(imageUrl),
        key: ValueKey(lastModified),
        height: height,
        width: double.infinity,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 50, color: Colors.grey),
      );
    }
    return Image.network(
      imageUrl,
      height: height,
      width: double.infinity,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.broken_image, size: 50, color: Colors.grey),
    );
  }
}

class ModThumbnailImage extends StatefulWidget {
  final String? imageUrl;
  final String? imagePathToProcess;
  final ThumbnailService thumbnailService;
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool isLocal;
  final Alignment alignment;

  const ModThumbnailImage({
    super.key,
    required this.imageUrl,
    this.imagePathToProcess,
    required this.thumbnailService,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.isLocal = false,
    this.alignment = Alignment.center,
  });

  @override
  State<ModThumbnailImage> createState() => _ModThumbnailImageState();
}

class _ModThumbnailImageState extends State<ModThumbnailImage> {
  File? _imageFile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(covariant ModThumbnailImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageUrl != oldWidget.imageUrl ||
        widget.imagePathToProcess != oldWidget.imagePathToProcess) {
      _loadImage();
    }
  }

  void _loadImage() async {
    final String? cacheKey = widget.imageUrl;
    final String? sourcePath = widget.imagePathToProcess;

    if (cacheKey == null || sourcePath == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    final File? cachedFile =
        widget.thumbnailService.getFromMemoryCache(cacheKey);
    if (cachedFile != null && mounted) {
      setState(() {
        _imageFile = cachedFile;
        _isLoading = false;
      });
      return;
    }
    
    setState(() => _isLoading = true);
    final file = await widget.thumbnailService.getThumbnail(
      cacheKey,
      sourcePath,
      isLocalFile: widget.isLocal,
    );
    if (mounted) {
      setState(() {
        _imageFile = file;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2.0));
    }

    if (_imageFile != null && _imageFile!.existsSync()) {
      return Image.file(
        _imageFile!,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        alignment: widget.alignment,
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.black26,
      child: const Icon(Icons.extension, size: 60, color: Colors.white38),
    );
  }
}

class CropOverlayPainter extends CustomPainter {
  final Rect cropRect;

  CropOverlayPainter({required this.cropRect});

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = Colors.black.withOpacity(0.6);
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final backgroundPath = Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      Path()..addRect(cropRect),
    );
    canvas.drawPath(backgroundPath, backgroundPaint);

    canvas.drawRect(cropRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}