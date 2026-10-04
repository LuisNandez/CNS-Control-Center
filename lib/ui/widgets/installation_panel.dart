// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'dart:ui' show FontFeature;
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import '../../l10n/app_localizations.dart';
import '../theme/ios_theme.dart';
import 'ios_progress_bar.dart';
import 'ios_widgets.dart';

/// Traduce los colores Material que envía main.dart ("statusColor") a la
/// paleta de sistema de iOS.
Color _iosStatusTone(Color c) {
  final v = c.value;
  if (v == Colors.redAccent.value || v == Colors.red.value) return IosColors.red;
  if (v == Colors.greenAccent.value || v == Colors.green.value) {
    return IosColors.green;
  }
  if (v == Colors.orangeAccent.value || v == Colors.orange.value) {
    return IosColors.orange;
  }
  if (v == Colors.tealAccent.value || v == Colors.lightBlueAccent.value) {
    return IosColors.blue;
  }
  if (v == Colors.white.value) return IosColors.secondaryLabel;
  return c;
}

class InstallationPanelContent extends StatelessWidget {
  final AppLocalizations l10n;
  final bool isDragging;
  final bool isExtracting;
  final bool isInstalling;
  final bool isLoading;
  final double extractionProgress;
  final String extractionStatus;
  final double installationProgress;
  final String installationStatus;
  final String statusMessage;
  final Color statusColor;
  final bool hasPreparedMods;
  final Map<String, List<String>> modsToInstallPreviewMap;

  final Future<void> Function(List<File>) onFilesDropped;
  final void Function(bool) onDragUpdate;
  final VoidCallback onPickArchive;
  final VoidCallback onInstallMod;
  final VoidCallback onCancelSelection;

  const InstallationPanelContent({
    super.key,
    required this.l10n,
    required this.isDragging,
    required this.isExtracting,
    required this.isInstalling,
    required this.isLoading,
    required this.extractionProgress,
    required this.extractionStatus,
    required this.installationProgress,
    required this.installationStatus,
    required this.statusMessage,
    required this.statusColor,
    required this.hasPreparedMods,
    required this.modsToInstallPreviewMap,
    required this.onFilesDropped,
    required this.onDragUpdate,
    required this.onPickArchive,
    required this.onInstallMod,
    required this.onCancelSelection,
  });

  @override
  Widget build(BuildContext context) {
    final busy = isLoading || isExtracting || isInstalling;
    final canInstall = hasPreparedMods && !busy;

    return DropTarget(
      onDragDone: (details) async {
        final files = details.files.map((f) => File(f.path)).toList();
        if (files.isNotEmpty) {
          await onFilesDropped(files);
        }
      },
      onDragEntered: (details) => onDragUpdate(true),
      onDragExited: (details) => onDragUpdate(false),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Indicador de arrastre de la hoja
                Center(
                  child: Container(
                    height: 5,
                    width: 36,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: IosColors.tertiaryLabel,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                Text(
                  l10n.installNewMod,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    color: IosColors.label,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: IosActionButton(
                        label: l10n.selectModArchive,
                        height: 42,
                        style: IosButtonStyle.tinted,
                        iconBuilder: (c) =>
                            Icon(Icons.archive_rounded, size: 18, color: c),
                        onPressed: busy ? null : onPickArchive,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: IosActionButton(
                        label: l10n.installSelectedMod,
                        height: 42,
                        style: IosButtonStyle.filled,
                        iconBuilder: (c) => Icon(
                          Icons.download_for_offline_rounded,
                          size: 18,
                          color: c,
                        ),
                        onPressed: canInstall ? onInstallMod : null,
                      ),
                    ),
                  ],
                ),
                if (modsToInstallPreviewMap.isNotEmpty)
                  InstallationPreviewSection(
                    l10n: l10n,
                    modsToInstallPreviewMap: modsToInstallPreviewMap,
                    isInstalling: isInstalling,
                    onCancel: onCancelSelection,
                  ),
                if (isExtracting)
                  _ProgressBlock(
                    status: extractionStatus,
                    value: extractionProgress,
                    color: IosColors.blue,
                  )
                else if (isInstalling)
                  _ProgressBlock(
                    status: installationStatus,
                    value: installationProgress,
                    color: IosColors.green,
                  )
                else if (hasPreparedMods || statusColor != Colors.white)
                  Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Text(
                      statusMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.3,
                        letterSpacing: -0.1,
                        color: _iosStatusTone(statusColor),
                      ),
                    ),
                  ),
                const SizedBox(height: 6),
              ],
            ),
          ),
          if (isDragging)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xE61C1C1E),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(14)),
                  border: Border.all(color: IosColors.blue, width: 2),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: IosColors.blue.withOpacity(0.18),
                        ),
                        child: const Icon(
                          Icons.file_download_rounded,
                          size: 38,
                          color: IosColors.blue,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.dropTargetOverlay,
                        style: const TextStyle(
                          color: IosColors.label,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Texto de estado + porcentaje y barra fina.
class _ProgressBlock extends StatelessWidget {
  const _ProgressBlock({
    required this.status,
    required this.value,
    required this.color,
  });

  final String status;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  status,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    letterSpacing: -0.1,
                    color: IosColors.secondaryLabel,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${(value.clamp(0.0, 1.0) * 100).round()}%',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: IosColors.secondaryLabel,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          IosProgressBar(value: value, color: color, height: 5),
        ],
      ),
    );
  }
}

class InstallationPreviewSection extends StatefulWidget {
  final AppLocalizations l10n;
  final Map<String, List<String>> modsToInstallPreviewMap;
  final bool isInstalling;
  final VoidCallback onCancel;

  const InstallationPreviewSection({
    super.key,
    required this.l10n,
    required this.modsToInstallPreviewMap,
    required this.isInstalling,
    required this.onCancel,
  });

  @override
  State<InstallationPreviewSection> createState() =>
      _InstallationPreviewSectionState();
}

class _InstallationPreviewSectionState
    extends State<InstallationPreviewSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final modEntries = widget.modsToInstallPreviewMap.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.previewInstallTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                    color: IosColors.label,
                  ),
                ),
              ),
              IosTextButton(
                label: l10n.cancelSelection,
                color: IosColors.red,
                onPressed: widget.isInstalling ? null : widget.onCancel,
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          constraints: const BoxConstraints(maxHeight: 260),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: IosColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x0FFFFFFF), width: 0.5),
          ),
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  for (int index = 0; index < modEntries.length; index++) ...[
                    if (index > 0)
                      Container(height: 0.5, color: IosColors.separator),
                    _PreviewFolder(
                      name: modEntries[index].key,
                      files: modEntries[index].value,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PreviewFolder extends StatelessWidget {
  const _PreviewFolder({required this.name, required this.files});

  final String name;
  final List<String> files;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.folder_zip_rounded,
                size: 20,
                color: IosColors.blue,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                    color: IosColors.label,
                  ),
                ),
              ),
            ],
          ),
          if (files.isNotEmpty) const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final file in files)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.5),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.insert_drive_file_outlined,
                          size: 14,
                          color: IosColors.tertiaryLabel,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            file,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: IosColors.secondaryLabel,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}