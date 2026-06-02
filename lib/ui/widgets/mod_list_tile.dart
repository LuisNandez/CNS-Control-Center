import 'package:flutter/material.dart';
import '../../models/mod_info.dart';
import '../../l10n/app_localizations.dart';

class ModListTile extends StatelessWidget {
  final ModInfo modInfo;
  final AppLocalizations l10n;
  final Map<String, dynamic>? updateInfo;
  final bool isIgnored;
  final bool isHighlighted;
  final bool isLoading;

  final VoidCallback onRepairedInfoTap;
  final VoidCallback onDeleteTap;
  final VoidCallback onUpdateAvailableTap;
  final VoidCallback onEditNameTap;
  final VoidCallback onShowFolderTap;
  final VoidCallback onShowGalleryTap;
  final VoidCallback onOpenNexusTap;
  final Future<bool> Function(ModInfo) onEnable;
  final Future<bool> Function(ModInfo) onDisable;

  const ModListTile({
    super.key,
    required this.modInfo,
    required this.l10n,
    required this.updateInfo,
    required this.isIgnored,
    required this.isHighlighted,
    required this.isLoading,
    required this.onRepairedInfoTap,
    required this.onDeleteTap,
    required this.onUpdateAvailableTap,
    required this.onEditNameTap,
    required this.onShowFolderTap,
    required this.onShowGalleryTap,
    required this.onOpenNexusTap,
    required this.onEnable,
    required this.onDisable,
  });

  @override
  Widget build(BuildContext context) {
    final hasUpdate = updateInfo != null;

    return Card(
      key: UniqueKey(), 
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      color: isHighlighted
          ? Colors.teal.withOpacity(0.3)
          : (modInfo.isEnabled ? Colors.grey[850] : Colors.orange[900]?.withOpacity(0.2)),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: hasUpdate && !isIgnored
              ? Colors.yellowAccent
              : (isHighlighted ? Colors.tealAccent : Colors.transparent),
          width: hasUpdate && !isIgnored ? 2.0 : 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        visualDensity: VisualDensity.compact,
        leading: Icon(
          Icons.extension,
          color: modInfo.isEnabled ? Colors.tealAccent : Colors.grey,
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Flexible(
              child: Text(
                modInfo.customName,
                style: TextStyle(
                  color: modInfo.isEnabled ? Colors.white : Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (modInfo.localVersion != null && modInfo.localVersion!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'v${modInfo.localVersion}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Row(
          children: [
            if (isHighlighted)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.new_releases, color: Colors.yellow[700], size: 18),
              ),
            if (modInfo.origin == 'repaired')
              IconButton(
                padding: const EdgeInsets.only(right: 8.0),
                constraints: const BoxConstraints(),
                icon: Icon(Icons.build, color: Colors.amber[700], size: 16),
                onPressed: onRepairedInfoTap,
                tooltip: l10n.repairedModTooltip,
                splashRadius: 16,
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!modInfo.isEnabled)
              IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                onPressed: isLoading ? null : onDeleteTap,
                tooltip: l10n.deletePermanently,
              ),
            if (hasUpdate && !isIgnored)
              IconButton(
                icon: const Icon(Icons.notification_important, color: Colors.yellowAccent),
                tooltip: l10n.updateAvailable(
                  (updateInfo!['version'] as String).toLowerCase().startsWith('v')
                      ? (updateInfo!['version'] as String).substring(1)
                      : updateInfo!['version'],
                ),
                onPressed: onUpdateAvailableTap,
              ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white70),
              onPressed: isLoading ? null : onEditNameTap,
              tooltip: l10n.editModNameTooltip,
            ),
            IconButton(
              icon: const Icon(Icons.folder_open, color: Colors.white70),
              onPressed: isLoading ? null : onShowFolderTap,
              tooltip: l10n.showInFolder,
            ),
            if (modInfo.nexusId != null)
              IconButton(
                icon: const Icon(Icons.photo_library_outlined, color: Colors.purpleAccent),
                onPressed: onShowGalleryTap,
                tooltip: l10n.viewImageGallery,
              ),
            if (modInfo.nexusId != null)
              IconButton(
                icon: const Icon(Icons.open_in_browser_outlined, color: Colors.lightBlueAccent),
                onPressed: onOpenNexusTap,
                tooltip: l10n.openInNexusMods,
              ),
            if (modInfo.isEnabled)
              IconButton(
                icon: const Icon(Icons.power_settings_new, color: Colors.orangeAccent),
                onPressed: isLoading ? null : () => onDisable(modInfo),
                tooltip: l10n.disableMod,
              )
            else
              IconButton(
                icon: const Icon(Icons.power_settings_new, color: Colors.greenAccent),
                onPressed: isLoading ? null : () => onEnable(modInfo),
                tooltip: l10n.enableMod,
              ),
          ],
        ),
      ),
    );
  }
}