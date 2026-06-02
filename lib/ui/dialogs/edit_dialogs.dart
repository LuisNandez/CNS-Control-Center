import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../../models/mod_info.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/mod_image_widgets.dart';

class EditDialogs {
  static Future<String?> showEditModNameDialog(BuildContext context, ModInfo modInfo) async {
    final nameController = TextEditingController(text: modInfo.customName);
    final l10n = AppLocalizations.of(context)!;

    final newName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: const Color(0xFF2a2a2a),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      l10n.dialogTitleEditModName,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      autofocus: true,
                      onChanged: (value) => setDialogState(() {}),
                      decoration: InputDecoration(
                        labelText: l10n.dialogLabelNewName,
                        hintText: modInfo.customName,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(
                          onPressed: nameController.text == modInfo.displayName
                              ? null
                              : () {
                                  setDialogState(
                                    () => nameController.text = modInfo.displayName,
                                  );
                                },
                          child: Text(l10n.dialogActionResetToDefault),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(l10n.dialogActionCancel),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(nameController.text),
                              child: Text(l10n.dialogActionSave),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    return newName;
  }

  static Future<ModInfo?> showEditDialog({
    required BuildContext context,
    required String title,
    required String label,
    required String initialValue,
    required String defaultValue,
    required Future<ModInfo?> Function(String) onSave,
    int? maxLength,
  }) async {
    final controller = TextEditingController(text: initialValue);
    final l10n = AppLocalizations.of(context)!;

    final newValue = await showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final bool isCurrentlyDefault = controller.text == defaultValue;
            return AlertDialog(
              title: Text(title),
              content: TextField(
                controller: controller,
                autofocus: true,
                maxLength: maxLength,
                onChanged: (value) => setDialogState(() {}),
                decoration: InputDecoration(labelText: label),
              ),
              actions: [
                TextButton(
                  onPressed: isCurrentlyDefault
                      ? null
                      : () {
                          setDialogState(() {
                            controller.text = defaultValue;
                            controller.selection = TextSelection.fromPosition(
                              TextPosition(offset: controller.text.length),
                            );
                          });
                        },
                  child: Text(l10n.dialogActionResetToDefault),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.dialogActionCancel),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(controller.text),
                  child: Text(l10n.dialogActionSave),
                ),
              ],
            );
          },
        );
      },
    );

    controller.dispose();

    if (newValue != null) {
      return await onSave(newValue);
    }
    return null;
  }

  static Future<Map<String, dynamic>?> showGeneralEditDialog(
    ModInfo modInfo,
    BuildContext context,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    final nameController = TextEditingController(text: modInfo.customName);
    final authorController = TextEditingController(
      text: modInfo.customAuthor ?? modInfo.author ?? '',
    );
    final String defaultUrl = modInfo.sourceUrl ??
        (modInfo.nexusId != null
            ? 'https://www.nexusmods.com/stellarblade/mods/${modInfo.nexusId}'
            : '');
    final urlController = TextEditingController(
      text: modInfo.customSourceUrl ?? defaultUrl,
    );

    File? newCoverFile;
    Alignment? newCoverAlignment;

    final updatedData = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final bool canResetName = nameController.text != modInfo.displayName;
            final bool canResetAuthor = authorController.text != (modInfo.author ?? '');
            final bool canResetUrl = urlController.text != (modInfo.sourceUrl ?? '');

            return AlertDialog(
              title: Text(l10n.editModTitle),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: nameController,
                              onChanged: (v) => setDialogState(() {}),
                              decoration: InputDecoration(
                                labelText: l10n.modNameLabel,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: !canResetName
                                ? null
                                : () => setDialogState(
                                    () => nameController.text = modInfo.displayName,
                                  ),
                            child: Text(l10n.dialogActionResetToDefault),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: authorController,
                              onChanged: (v) => setDialogState(() {}),
                              decoration: InputDecoration(
                                labelText: l10n.authorLabel,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: !canResetAuthor
                                ? null
                                : () => setDialogState(
                                    () => authorController.text = modInfo.author ?? '',
                                  ),
                            child: Text(l10n.dialogActionResetToDefault),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: urlController,
                              onChanged: (v) => setDialogState(() {}),
                              decoration: InputDecoration(
                                labelText: l10n.urlLabel,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: !canResetUrl
                                ? null
                                : () => setDialogState(
                                    () => urlController.text = defaultUrl,
                                  ),
                            child: Text(l10n.dialogActionResetToDefault),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (newCoverFile != null) Image.file(newCoverFile!, height: 100),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.image_search),
                        label: Text(l10n.changeCoverButton),
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: [
                              'png', 'jpg', 'jpeg', 'webp', 'bmp', 'pwebp', 'tiff'
                            ],
                          );
                          if (result != null && result.files.single.path != null) {
                            final pickedFile = File(result.files.single.path!);
                            final alignment = await showCoverAlignmentDialog(context, pickedFile);
                            if (alignment != null) {
                              setDialogState(() {
                                newCoverFile = pickedFile;
                                newCoverAlignment = alignment;
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.dialogActionCancel),
                ),
                ElevatedButton(
                  onPressed: () {
                    final Map<String, dynamic> dataToSave = {
                      'customName': nameController.text,
                      'author': authorController.text,
                      'customSourceUrl': urlController.text,
                    };
                    if (newCoverFile != null) {
                      dataToSave['newCoverFile'] = newCoverFile;
                      dataToSave['newCoverAlignment'] = newCoverAlignment;
                    }
                    Navigator.of(context).pop(dataToSave);
                  },
                  child: Text(l10n.dialogActionSave),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    authorController.dispose();
    urlController.dispose();

    return updatedData;
  }

  static Future<Alignment?> showCoverAlignmentDialog(BuildContext context, File imageFile) async {
    final image = await decodeImageFromList(imageFile.readAsBytesSync());
    final imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final l10n = AppLocalizations.of(context)!;
    Offset offset = Offset.zero;

    return showDialog<Alignment>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Size? containerSize;
            Size? scaledImageSize;
            Rect? initialImageRect;
            double? cropWidth;
            double? cropHeight;

            return AlertDialog(
              title: Text(l10n.setCoverText),
              contentPadding: EdgeInsets.zero,
              backgroundColor: const Color(0xFF2d2d2d),
              content: SizedBox(
                width: 500,
                height: 600,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    containerSize = Size(constraints.maxWidth, constraints.maxHeight);
                    final fittedSizes = applyBoxFit(BoxFit.contain, imageSize, containerSize!);
                    scaledImageSize = fittedSizes.destination;

                    const cardAspectRatio = 3 / 4.2;

                    if ((scaledImageSize!.width / scaledImageSize!.height) > cardAspectRatio) {
                      cropHeight = scaledImageSize!.height;
                      cropWidth = cropHeight! * cardAspectRatio;
                    } else {
                      cropWidth = scaledImageSize!.width;
                      cropHeight = cropWidth! / cardAspectRatio;
                    }

                    final cropRect = Rect.fromCenter(
                      center: containerSize!.center(Offset.zero),
                      width: cropWidth!,
                      height: cropHeight!,
                    );

                    initialImageRect = Alignment.center.inscribe(
                      scaledImageSize!,
                      Rect.fromLTWH(0, 0, containerSize!.width, containerSize!.height),
                    );

                    final minDx = cropRect.right - (initialImageRect!.left + scaledImageSize!.width);
                    final maxDx = cropRect.left - initialImageRect!.left;
                    final minDy = cropRect.bottom - (initialImageRect!.top + scaledImageSize!.height);
                    final maxDy = cropRect.top - initialImageRect!.top;

                    return GestureDetector(
                      onPanUpdate: (details) {
                        setDialogState(() {
                          offset = Offset(
                            (offset.dx + details.delta.dx).clamp(
                              min(minDx, maxDx),
                              max(minDx, maxDx),
                            ),
                            (offset.dy + details.delta.dy).clamp(
                              min(minDy, maxDy),
                              max(minDy, maxDy),
                            ),
                          );
                        });
                      },
                      child: ClipRect(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              left: initialImageRect!.left + offset.dx,
                              top: initialImageRect!.top + offset.dy,
                              width: scaledImageSize!.width,
                              height: scaledImageSize!.height,
                              child: Image.file(imageFile, fit: BoxFit.fill),
                            ),
                            CustomPaint(
                              size: containerSize!,
                              painter: CropOverlayPainter(cropRect: cropRect),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.dialogActionCancel),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (scaledImageSize == null || initialImageRect == null || cropWidth == null || cropHeight == null) return;
                    final extraWidth = scaledImageSize!.width - cropWidth!;
                    final extraHeight = scaledImageSize!.height - cropHeight!;
                    final centerOffset = offset;
                    final alignmentX = extraWidth > 0 ? (centerOffset.dx / (extraWidth / 2)) * -1 : 0.0;
                    final alignmentY = extraHeight > 0 ? (centerOffset.dy / (extraHeight / 2)) * -1 : 0.0;
                    final finalAlignment = Alignment(
                      alignmentX.clamp(-1.0, 1.0),
                      alignmentY.clamp(-1.0, 1.0),
                    );
                    Navigator.of(context).pop(finalAlignment);
                  },
                  child: Text(l10n.dialogActionSave),
                ),
              ],
            );
          },
        );
      }
    );
  }
}