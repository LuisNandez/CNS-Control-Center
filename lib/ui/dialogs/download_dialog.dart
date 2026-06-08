import 'dart:io';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../services/nexus_api_service.dart';
import '../../services/download_service.dart';

class DownloadModDialog extends StatefulWidget {
  final String nxmUrl;
  final String apiKey;
  final Function(File downloadedFile) onDownloadComplete;

  const DownloadModDialog({
    super.key,
    required this.nxmUrl,
    required this.apiKey,
    required this.onDownloadComplete,
  });

  @override
  State<DownloadModDialog> createState() => _DownloadModDialogState();
}

class _DownloadModDialogState extends State<DownloadModDialog> {
  bool _isFetchingLink = true;
  bool _isDownloading = false;
  String? _statusMessage; // Se inicializa como null
  String _fileName = "";
  double _progress = 0.0;
  String _speed = "";
  String _downloaded = "";
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _startProcess();
  }

  Future<void> _startProcess() async {
    try {
      // 1. Obtener el enlace directo del CDN
      final linkData = await NexusApiService.getDownloadLinkFromNxm(widget.nxmUrl, widget.apiKey);
      
      if (!mounted) return;

      if (linkData == null) {
        setState(() {
          _isFetchingLink = false;
          _hasError = true;
          _statusMessage = AppLocalizations.of(context)!.downloadStatusFetchingFailed;
        });
        return;
      }

      setState(() {
        _isFetchingLink = false;
        _isDownloading = true;
        _fileName = linkData['fileName']!;
        _statusMessage = AppLocalizations.of(context)!.downloadStatusDownloading(_fileName);
      });

      // 2. Descargar el archivo
      final downloadedFile = await DownloadService.downloadFile(
        url: linkData['url']!,
        fileName: _fileName,
        onProgress: (progress, speed, downloadedStr) {
          if (mounted) {
            setState(() {
              _progress = progress;
              _speed = speed;
              _downloaded = downloadedStr;
            });
          }
        },
      );

      if (!mounted) return;

      if (downloadedFile != null) {
        widget.onDownloadComplete(downloadedFile);
      } else {
        setState(() {
          _isDownloading = false;
          _hasError = true;
          _statusMessage = AppLocalizations.of(context)!.downloadStatusError;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isFetchingLink = false;
          _isDownloading = false;
          _hasError = true;
          _statusMessage = AppLocalizations.of(context)!.downloadStatusException(e.toString());
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Si el mensaje es null, mostramos el mensaje por defecto (obteniendo datos)
    final displayMessage = _statusMessage ?? l10n.downloadStatusFetching;

    return AlertDialog(
      backgroundColor: const Color(0xFF2a2a2a),
      title: Text(l10n.dialogTitleDownloadModManager),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              displayMessage,
              style: TextStyle(
                color: _hasError ? Colors.redAccent : Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            if (_isFetchingLink)
              const Center(child: CircularProgressIndicator(color: Colors.tealAccent))
            else if (_isDownloading)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.grey[800],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.tealAccent),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_downloaded, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(_speed, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
      actions: [
        if (_hasError)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.dialogActionClose), // Se reutiliza "Cerrar" existente
          ),
      ],
    );
  }
}