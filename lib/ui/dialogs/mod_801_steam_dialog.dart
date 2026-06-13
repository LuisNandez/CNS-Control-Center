import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../l10n/app_localizations.dart';
import '../../notification_service.dart';

class Mod801SteamDialog extends StatefulWidget {
  final String gameRootPath;

  const Mod801SteamDialog({super.key, required this.gameRootPath});

  static Future<void> show(BuildContext context, String gameRootPath) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // Obliga al usuario a interactuar o cerrar explícitamente
      builder: (context) => Mod801SteamDialog(gameRootPath: gameRootPath),
    );
  }

  @override
  State<Mod801SteamDialog> createState() => _Mod801SteamDialogState();
}

class _Mod801SteamDialogState extends State<Mod801SteamDialog> {
  final TextEditingController _pathController = TextEditingController();
  bool _isGenerated = false;

  void _generatePath() {
    final l10n = AppLocalizations.of(context)!;
    // Generamos la ruta dinámica real basada en la instalación del usuario
    // Manteniendo exactamente el formato SplashRandomizer.bat
    final batPath = p.join(widget.gameRootPath, 'SB', 'Content', 'Splash', 'ModSplash', 'SplashRandomizer.bat');
    final command = '"$batPath" %command%';
    
    setState(() {
      _pathController.text = command;
      _isGenerated = true;
    });

    NotificationService.instance.show(
      context: context,
      type: NotificationType.info,
      title: l10n.mod801PathGenerated,
    );
  }

  Future<void> _openSteam() async {
    // Protocolo estándar para abrir la biblioteca de Steam
    final url = Uri.parse('steam://open/games');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _copyToClipboard() async {
    final l10n = AppLocalizations.of(context)!;
    if (_pathController.text.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: _pathController.text));
      if (mounted) {
        NotificationService.instance.show(
          context: context,
          type: NotificationType.success,
          title: l10n.mod801PathCopied,
        );
      }
    }
  }

  @override
  void dispose() {
    _pathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: const Color(0xFF2a2a2a),
      title: Row(
        children: [
          const HugeIcon(icon: HugeIcons.strokeRounded3DView, color: Colors.white, size: 28),
          const SizedBox(width: 10),
          Text(l10n.mod801DialogTitle, style: const TextStyle(color: Colors.white)),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.mod801DialogIntro, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 20),
            
            // Instrucciones paso a paso
            Text(l10n.mod801Step1, style: const TextStyle(color: Colors.tealAccent)),
            const SizedBox(height: 6),
            Text(l10n.mod801Step2, style: const TextStyle(color: Colors.tealAccent)),
            const SizedBox(height: 6),
            Text(l10n.mod801Step3, style: const TextStyle(color: Colors.tealAccent)),
            const SizedBox(height: 6),
            Text(l10n.mod801Step4, style: const TextStyle(color: Colors.tealAccent)),
            
            const SizedBox(height: 24),
            
            // Botones de acción principal (Generar y Steam)
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _generatePath,
                  icon: const HugeIcon(icon: HugeIcons.strokeRoundedSettings02, color: Colors.black, size: 20),
                  label: Text(l10n.mod801BtnGenerate),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                    foregroundColor: Colors.black,
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: _openSteam,
                  icon: const HugeIcon(icon: HugeIcons.strokeRoundedLinkSquare01, color: Colors.white, size: 20),
                  label: Text(l10n.mod801BtnSteam),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.grey),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Campo de texto con ruta generada y botón de copiar integrado
            if (_isGenerated)
              TextField(
                controller: _pathController,
                readOnly: true,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black45,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const HugeIcon(icon: HugeIcons.strokeRoundedCopy01, color: Colors.tealAccent, size: 20),
                    onPressed: _copyToClipboard,
                    tooltip: l10n.mod801BtnCopy,
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.dialogActionClose, style: const TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}