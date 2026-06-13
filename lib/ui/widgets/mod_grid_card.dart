import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import '../../models/mod_info.dart';
import '../../l10n/app_localizations.dart';
import '../../thumbnail_service.dart';
import 'mod_image_widgets.dart';
import 'animated_mod_switch.dart';
import 'package:hugeicons/hugeicons.dart';

class ModGridCard extends StatelessWidget {
  final ModInfo modInfo;
  final AppLocalizations l10n;
  final ThumbnailService thumbnailService;
  final Map<String, dynamic>? updateInfo;
  final bool isIgnored;
  final bool isHighlighted;
  final bool showModTypeTags;
  final bool isLoading;

  final VoidCallback onTapDetails;
  final VoidCallback onUpdateAvailableTap;
  final VoidCallback onEditVersionTap;
  final VoidCallback onEditTagTap;
  final void Function(Offset, String) onHoverEnter;
  final void Function(Offset) onHoverMove;
  final VoidCallback onHoverExit;
  
  final Future<bool> Function(ModInfo) onEnable;
  final Future<bool> Function(ModInfo) onDisable;

  final VoidCallback onEditNameTap;
  final VoidCallback onSetCoverTap;
  final VoidCallback onRevertCoverTap;
  final VoidCallback onShowFolderTap;
  final VoidCallback onShowGalleryTap;
  final VoidCallback onOpenNexusTap;
  final VoidCallback onDeleteTap;

  const ModGridCard({
    super.key,
    required this.modInfo,
    required this.l10n,
    required this.thumbnailService,
    required this.updateInfo,
    required this.isIgnored,
    required this.isHighlighted,
    required this.showModTypeTags,
    required this.isLoading,
    required this.onTapDetails,
    required this.onUpdateAvailableTap,
    required this.onEditVersionTap,
    required this.onEditTagTap,
    required this.onHoverEnter,
    required this.onHoverMove,
    required this.onHoverExit,
    required this.onEnable,
    required this.onDisable,
    required this.onEditNameTap,
    required this.onSetCoverTap,
    required this.onRevertCoverTap,
    required this.onShowFolderTap,
    required this.onShowGalleryTap,
    required this.onOpenNexusTap,
    required this.onDeleteTap,
  });

  Widget _buildModTypeBadge() {
    final String modTypeString;
    final Color modTypeColor;
    final String? modType = modInfo.modType;

    if (modType == 'replacement') {
      modTypeString = l10n.modTypeReplacement;
      modTypeColor = const Color.fromARGB(255, 182, 33, 135);
    } else if (modType == 'genericPak') {
      modTypeString = l10n.modTypeGeneric;
      modTypeColor = const Color.fromARGB(255, 63, 63, 63);
    } else if (modType == 'movies') {
      modTypeString = l10n.modTypeMovies;
      modTypeColor = const Color.fromARGB(255, 153, 49, 49);
    } else if (modType == 'logicMod') {
      modTypeString = l10n.modTypeLogic;
      modTypeColor = const Color.fromARGB(255, 26, 99, 151);
    } else if (modType == 'save') {
      modTypeString = l10n.modTypeSave;
      modTypeColor = Colors.green.shade600; // Puedes ajustar el color
    } else if (modType == 'config') {
      modTypeString = l10n.modTypeConfig;
      modTypeColor = Colors.blueGrey.shade600; // Puedes ajustar el color
    } else if (modType == 'splash') {
      modTypeString = l10n.modTypeSplash;
      modTypeColor = Colors.deepOrange.shade600; // Puedes ajustar el color
    } else {
      modTypeString = l10n.modTypeCNS;
      modTypeColor = Colors.teal.shade600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: modTypeColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        modTypeString,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? coverImagePath;
    String? cacheKey;
    bool isLocalFile = false;

    if (modInfo.customCoverPath != null && modInfo.customCoverPath!.isNotEmpty) {
      coverImagePath = p.join(modInfo.directory.path, modInfo.customCoverPath!);
      cacheKey = p.basename(modInfo.directory.path) + modInfo.customCoverPath!;
      isLocalFile = true;
    } else if (modInfo.gallery != null && modInfo.gallery!.isNotEmpty) {
      coverImagePath = modInfo.gallery!.first['thumbnail'] as String?;
      cacheKey = coverImagePath;
      isLocalFile = false;
    }

    final hasUpdate = updateInfo != null;
    final hasCustomCover = modInfo.customCoverPath != null && modInfo.customCoverPath!.isNotEmpty;
    final displayVersion = modInfo.customVersion ?? modInfo.localVersion;
    final bool isReplacement = modInfo.replacesOutfits != null && modInfo.replacesOutfits!.isNotEmpty;
    final String displayTag = isReplacement
        ? (modInfo.replacesOutfits!.length > 1 
            ? '${modInfo.replacesOutfits!.length} Outfits' 
            : modInfo.replacesOutfits!.first)
        : (modInfo.customFitMeshType ?? modInfo.fitMeshType ?? l10n.modCategoryOther);

    return Card(
      key: ValueKey(modInfo.directory.path),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: hasUpdate && !isIgnored
              ? Colors.yellowAccent
              : (isHighlighted ? Colors.tealAccent : Colors.transparent),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: InkWell(
              onTap: onTapDetails,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: ModThumbnailImage(
                      imageUrl: cacheKey,
                      imagePathToProcess: coverImagePath,
                      thumbnailService: thumbnailService,
                      isLocal: isLocalFile,
                      fit: BoxFit.cover,
                      alignment: modInfo.customCoverAlignment ?? Alignment.center,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (!modInfo.isEnabled)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orangeAccent.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              l10n.modDisabledBadge,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (!modInfo.isEnabled) const SizedBox(height: 4),
                        if (showModTypeTags) _buildModTypeBadge(),
                      ],
                    ),
                  ),
                  if (hasUpdate && !isIgnored)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: IconButton(
                        icon: const Icon(
                          Icons.notification_important_rounded,
                          color: Colors.yellowAccent,
                        ),
                        tooltip: l10n.updateAvailable(
                          (updateInfo!['version'] as String).toLowerCase().startsWith('v')
                              ? (updateInfo!['version'] as String).substring(1)
                              : updateInfo!['version'],
                        ),
                        onPressed: onUpdateAvailableTap,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: Tooltip(
                    message: modInfo.customName,
                    child: Text(
                      modInfo.customName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (displayVersion != null)
                  InkWell(
                    onTap: onEditVersionTap,
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                      child: Text(
                        'v$displayVersion',
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Listener(
                    onPointerMove: (event) => onHoverMove(event.position),
                    child: MouseRegion(
                      onEnter: (event) {
                        if (isReplacement) {
                          onHoverEnter(event.position, modInfo.replacesOutfits!.first);
                        }
                      },
                      onExit: (_) => onHoverExit(),
                      child: InkWell(
                        onTap: isReplacement ? null : onEditTagTap,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isReplacement ? Colors.black.withOpacity(0.4) : Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isReplacement)
                                HugeIcon(icon: HugeIcons.strokeRoundedDress04, size: 10, color: Colors.purpleAccent.shade100),
                              if (isReplacement) const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  displayTag,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isReplacement ? const Color.fromARGB(255, 153, 151, 153) : Colors.white70,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    AnimatedModSwitch(
                      key: ValueKey('switch-grid-${modInfo.directory.path}'),
                      modInfo: modInfo,
                      isLoading: isLoading,
                      onEnable: onEnable,
                      onDisable: onDisable,
                      scale: 0.6,
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 20),
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            onEditNameTap();
                            break;
                          case 'set_cover':
                            onSetCoverTap();
                            break;
                          case 'revert_cover':
                            onRevertCoverTap();
                            break;
                          case 'folder':
                            onShowFolderTap();
                            break;
                          case 'gallery':
                            onShowGalleryTap();
                            break;
                          case 'nexus':
                            onOpenNexusTap();
                            break;
                          case 'delete':
                            onDeleteTap();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 'edit', child: Row(children: [const HugeIcon(icon: HugeIcons.strokeRoundedEdit01, size: 20), const SizedBox(width: 12), Flexible(child: Text(l10n.editModNameTooltip))])),
                        PopupMenuItem(value: 'set_cover', child: Row(children: [const HugeIcon(icon: HugeIcons.strokeRoundedImageAdd02, size: 20), const SizedBox(width: 12), Flexible(child: Text(l10n.setCoverTooltip))])),
                        if (hasCustomCover) PopupMenuItem(value: 'revert_cover', child: Row(children: [const HugeIcon(icon: HugeIcons.strokeRoundedImageCounterClockwise, size: 20), const SizedBox(width: 12), Flexible(child: Text(l10n.restoreOriginalCoverText))])),
                        PopupMenuItem(value: 'folder', child: Row(children: [const HugeIcon(icon: HugeIcons.strokeRoundedFolderInput, size: 20), const SizedBox(width: 12), Flexible(child: Text(l10n.showInFolder))])),
                        if (modInfo.nexusId != null) PopupMenuItem(value: 'gallery', child: Row(children: [const HugeIcon(icon: HugeIcons.strokeRoundedAlbum02, size: 20), const SizedBox(width: 12), Flexible(child: Text(l10n.viewImageGallery))])),
                        if (modInfo.nexusId != null) PopupMenuItem(value: 'nexus', child: Row(children: [const HugeIcon(icon: HugeIcons.strokeRoundedLinkSquare02, size: 20), const SizedBox(width: 12), Flexible(child: Text(l10n.openInNexusMods))])),
                        if (!modInfo.isEnabled) const PopupMenuDivider(),
                        if (!modInfo.isEnabled) PopupMenuItem(value: 'delete', child: Row(children: [const HugeIcon(icon: HugeIcons.strokeRoundedDelete04, size: 20), const SizedBox(width: 12), Flexible(child: Text(l10n.deletePermanently, style: const TextStyle(color: Colors.redAccent)))])),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}