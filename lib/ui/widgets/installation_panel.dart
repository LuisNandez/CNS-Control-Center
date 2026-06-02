import 'dart:io';
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import '../../l10n/app_localizations.dart';

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
    final canInstall = hasPreparedMods && !isLoading && !isExtracting && !isInstalling;

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
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    height: 5,
                    width: 40,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                Text(
                  l10n.installNewMod,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.archive),
                        label: Text(l10n.selectModArchive),
                        onPressed: (isLoading || isExtracting || isInstalling)
                            ? null
                            : onPickArchive,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.download_for_offline),
                        label: Text(l10n.installSelectedMod),
                        onPressed: canInstall ? onInstallMod : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: canInstall ? Colors.tealAccent : Colors.grey[700],
                          foregroundColor: Colors.black87,
                        ),
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
                const SizedBox(height: 20),
                if (isExtracting)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          extractionStatus,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white70),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: extractionProgress,
                        backgroundColor: Colors.grey[800],
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.tealAccent),
                      ),
                    ],
                  )
                else if (isInstalling)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          installationStatus,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white70),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: installationProgress,
                        backgroundColor: Colors.grey[800],
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                      ),
                    ],
                  )
                else if (hasPreparedMods || statusColor != Colors.white)
                  Text(
                    statusMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: statusColor,
                    ),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          if (isDragging)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                border: Border.all(color: Colors.tealAccent, width: 3),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.download_for_offline,
                      size: 80,
                      color: Colors.tealAccent,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.dropTargetOverlay,
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class InstallationPreviewSection extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final modEntries = modsToInstallPreviewMap.entries.toList();
    final scrollController = ScrollController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              l10n.previewInstallTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.cancel_outlined, size: 20),
              label: Text(l10n.cancelSelection),
              onPressed: isInstalling ? null : onCancel,
              style: TextButton.styleFrom(
                disabledForegroundColor: Colors.redAccent.withOpacity(0.4),
                foregroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
        const Divider(height: 20, color: Colors.white24),
        Container(
          constraints: const BoxConstraints(maxHeight: 280),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Scrollbar(
            controller: scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: List.generate(modEntries.length, (index) {
                  final entry = modEntries[index];
                  final folderName = entry.key;
                  final files = entry.value;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.folder_zip_outlined,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                folderName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: files.map((file) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.insert_drive_file_outlined,
                                      size: 14,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        file,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[300],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        if (index < modEntries.length - 1)
                          const Divider(height: 24, color: Colors.white10),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}