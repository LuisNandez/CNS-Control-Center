// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../models/mod_info.dart';
import '../../l10n/app_localizations.dart';
import '../theme/ios_theme.dart';
import '../widgets/ios_widgets.dart';
import '../widgets/mod_image_widgets.dart';

class EditDialogs {
  /// Libera un controlador una vez terminada la animación de salida del
  /// diálogo (el campo sigue montado unos milisegundos tras cerrarlo).
  static void _disposeLater(List<TextEditingController> controllers) {
    Future.delayed(const Duration(milliseconds: 400), () {
      for (final c in controllers) {
        c.dispose();
      }
    });
  }

  /// Alerta de vidrio con un único campo de texto (nombre, versión, etiqueta…).
  static Future<String?> _showTextFieldDialog({
    required BuildContext context,
    required String title,
    required String label,
    required String initialValue,
    String? hint,
    String? defaultValue,
    int? maxLength,
  }) async {
    final controller = TextEditingController(text: initialValue);
    final l10n = AppLocalizations.of(context)!;

    final result = await showIosDialog<String>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return IosDialogShell(
              title: title,
              width: 380,
              content: IosFormField(
                label: label,
                controller: controller,
                hint: hint,
                autofocus: true,
                maxLength: maxLength,
                onChanged: (_) => setDialogState(() {}),
                onSubmitted: (v) => Navigator.of(dialogContext).pop(v),
                resetLabel: l10n.dialogActionResetToDefault,
                onReset: defaultValue == null
                    ? null
                    : () => setDialogState(() {
                        controller.text = defaultValue;
                        controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.text.length),
                        );
                      }),
                canReset: controller.text != (defaultValue ?? ''),
              ),
              actions: [
                IosDialogButton(
                  label: l10n.dialogActionCancel,
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
                IosDialogButton(
                  label: l10n.dialogActionSave,
                  bold: true,
                  onPressed: () =>
                      Navigator.of(dialogContext).pop(controller.text),
                ),
              ],
            );
          },
        );
      },
    );

    _disposeLater([controller]);
    return result;
  }

  static Future<String?> showEditModNameDialog(
    BuildContext context,
    ModInfo modInfo,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return _showTextFieldDialog(
      context: context,
      title: l10n.dialogTitleEditModName,
      label: l10n.dialogLabelNewName,
      initialValue: modInfo.customName,
      hint: modInfo.customName,
      defaultValue: modInfo.displayName,
    );
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
    final newValue = await _showTextFieldDialog(
      context: context,
      title: title,
      label: label,
      initialValue: initialValue,
      defaultValue: defaultValue,
      maxLength: maxLength,
    );

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

    final updatedData = await showIosDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final bool canResetName =
                nameController.text != modInfo.displayName;
            final bool canResetAuthor =
                authorController.text != (modInfo.author ?? '');
            final bool canResetUrl = urlController.text != defaultUrl;
            final double maxContentHeight =
                MediaQuery.of(ctx).size.height * 0.6;

            return IosDialogShell(
              title: l10n.editModTitle,
              width: 520,
              content: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxContentHeight),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      IosFormField(
                        label: l10n.modNameLabel,
                        controller: nameController,
                        onChanged: (_) => setDialogState(() {}),
                        resetLabel: l10n.dialogActionResetToDefault,
                        canReset: canResetName,
                        onReset: () => setDialogState(
                          () => nameController.text = modInfo.displayName,
                        ),
                      ),
                      const SizedBox(height: 12),
                      IosFormField(
                        label: l10n.authorLabel,
                        controller: authorController,
                        onChanged: (_) => setDialogState(() {}),
                        resetLabel: l10n.dialogActionResetToDefault,
                        canReset: canResetAuthor,
                        onReset: () => setDialogState(
                          () => authorController.text = modInfo.author ?? '',
                        ),
                      ),
                      const SizedBox(height: 12),
                      IosFormField(
                        label: l10n.urlLabel,
                        controller: urlController,
                        onChanged: (_) => setDialogState(() {}),
                        resetLabel: l10n.dialogActionResetToDefault,
                        canReset: canResetUrl,
                        onReset: () => setDialogState(
                          () => urlController.text = defaultUrl,
                        ),
                      ),
                      const SizedBox(height: 18),
                      if (newCoverFile != null) ...[
                        Container(
                          height: 110,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0x1FFFFFFF),
                              width: 0.5,
                            ),
                          ),
                          child: Image.file(newCoverFile!, fit: BoxFit.contain),
                        ),
                        const SizedBox(height: 10),
                      ],
                      IosActionButton(
                        label: l10n.changeCoverButton,
                        style: IosButtonStyle.gray,
                        iconBuilder: (c) => HugeIcon(
                          icon: HugeIcons.strokeRoundedImageAdd02,
                          size: 18,
                          color: c,
                        ),
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: [
                                  'png',
                                  'jpg',
                                  'jpeg',
                                  'webp',
                                  'bmp',
                                  'pwebp',
                                  'tiff',
                                ],
                              );
                          if (result != null &&
                              result.files.single.path != null) {
                            final pickedFile = File(result.files.single.path!);
                            final alignment = await showCoverAlignmentDialog(
                              ctx,
                              pickedFile,
                            );
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
                IosDialogButton(
                  label: l10n.dialogActionCancel,
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
                IosDialogButton(
                  label: l10n.dialogActionSave,
                  bold: true,
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
                    Navigator.of(dialogContext).pop(dataToSave);
                  },
                ),
              ],
            );
          },
        );
      },
    );

    _disposeLater([nameController, authorController, urlController]);

    return updatedData;
  }

  static Future<Alignment?> showCoverAlignmentDialog(
    BuildContext context,
    File imageFile,
  ) async {
    final image = await decodeImageFromList(imageFile.readAsBytesSync());
    final imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final l10n = AppLocalizations.of(context)!;
    Offset offset = Offset.zero;

    return showIosDialog<Alignment>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            Size? containerSize;
            Size? scaledImageSize;
            Rect? initialImageRect;
            double? cropWidth;
            double? cropHeight;

            // El recuadro se adapta al tamaño de la ventana.
            final Size screen = MediaQuery.of(ctx).size;
            final double boxWidth = min(500.0, max(260.0, screen.width - 120));
            final double boxHeight = min(560.0, max(260.0, screen.height * 0.6));

            return IosDialogShell(
              title: l10n.setCoverText,
              width: boxWidth + 40,
              content: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: boxWidth,
                  height: boxHeight,
                  decoration: const BoxDecoration(color: Color(0xFF1C1C1E)),
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
              ),
              actions: [
                IosDialogButton(
                  label: l10n.dialogActionCancel,
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
                IosDialogButton(
                  label: l10n.dialogActionSave,
                  bold: true,
                  onPressed: () {
                    if (scaledImageSize == null ||
                        initialImageRect == null ||
                        cropWidth == null ||
                        cropHeight == null) {
                      return;
                    }
                    final extraWidth = scaledImageSize!.width - cropWidth!;
                    final extraHeight = scaledImageSize!.height - cropHeight!;
                    final centerOffset = offset;
                    final alignmentX = extraWidth > 0
                        ? (centerOffset.dx / (extraWidth / 2)) * -1
                        : 0.0;
                    final alignmentY = extraHeight > 0
                        ? (centerOffset.dy / (extraHeight / 2)) * -1
                        : 0.0;
                    final finalAlignment = Alignment(
                      alignmentX.clamp(-1.0, 1.0),
                      alignmentY.clamp(-1.0, 1.0),
                    );
                    Navigator.of(dialogContext).pop(finalAlignment);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}