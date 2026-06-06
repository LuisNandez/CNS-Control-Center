import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';
import 'package:translator/translator.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../models/mod_info.dart';
import '../../l10n/app_localizations.dart';
import '../../thumbnail_service.dart';
import '../../notification_service.dart';
import '../../outfit_data.dart';
import '../../utils/text_utils.dart';
import 'mod_image_widgets.dart';
import 'bbcode_renderer.dart';

class ModDetailsPanel extends StatefulWidget {
  final ModInfo initialModInfo;
  final ThumbnailService thumbnailService;
  // Funciones que necesita del widget principal
  final Future<ModInfo?> Function(ModInfo, Map<String, dynamic>)
  onUpdateDetails;
  final Future<void> Function(Directory) onShowInExplorer;
  final void Function(ModInfo) onShowImageGallery;
  final Future<Map<String, dynamic>?> Function(ModInfo, BuildContext)
  onShowGeneralEditDialog;
  final Function(ModInfo?) onPanelClosed;
  // Nuevas propiedades para gestionar la información de la actualización.
  final Map<String, dynamic>? updateInfo;
  final bool isIgnored;
  final Future<bool> Function({
    required String newVersion,
    required String nexusId,
    required int fileId,
    required String uniqueIdentifier,
  })
  onShowUpdateDialog;

  const ModDetailsPanel({
    required this.initialModInfo,
    required this.thumbnailService,
    required this.onUpdateDetails,
    required this.onShowInExplorer,
    required this.onShowImageGallery,
    required this.onShowGeneralEditDialog,
    required this.onPanelClosed,
    // Añadimos los nuevos parámetros al constructor.
    this.updateInfo,
    required this.isIgnored,
    required this.onShowUpdateDialog,
  });

  @override
  State<ModDetailsPanel> createState() => ModDetailsPanelState();
}

class ModDetailsPanelState extends State<ModDetailsPanel> {
  late ModInfo currentModInfo;
  bool _isTranslating = false;
  bool _showTranslateSummaryButton = false;
  bool _showTranslateDescriptionButton = false;
  bool _needsReloadOnClose = false;
  late bool _isIgnored;
  late bool _isReplacementMod;

  final ScrollController _carouselScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    currentModInfo = widget.initialModInfo;
    _isIgnored = widget.isIgnored;
    _isReplacementMod =
        currentModInfo.modType == 'replacement' ||
        (currentModInfo.modType == 'genericPak' &&
            (currentModInfo.replacesOutfits != null &&
                currentModInfo.replacesOutfits!.isNotEmpty));
    // Comprueba si se puede traducir tan pronto como el widget se renderiza por primera vez.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateTranslationButtonVisibility();
    });
  }

  /// El método dispose() se llama AUTOMÁTICAMENTE cuando el widget se va a destruir.
  // Es el lugar perfecto para nuestra lógica de cierre.
  @override
  void dispose() {
    // Llama al "mensajero" y le entrega el mod actualizado si hubo cambios.
    widget.onPanelClosed(_needsReloadOnClose ? currentModInfo : null);
    _carouselScrollController.dispose();
    super.dispose();
  }

  Future<bool> _checkIfTextNeedsTranslation(String? text) async {
    if (!mounted) return false;
    if (text == null || text.trim().isEmpty) {
      return false;
    }

    final String currentLocale = Localizations.localeOf(context).languageCode;
    try {
      final translator = GoogleTranslator();
      // Usamos un fragmento para no enviar textos enormes a la API de detección
      final snippet = text.length > 150 ? text.substring(0, 150) : text;
      const String pivotLocale = 'de'; // Idioma pivote para forzar la detección
      final translation = await translator.translate(snippet, to: pivotLocale);
      final detectedLanguageCode = translation.sourceLanguage.code
          .toLowerCase();

      // Necesita traducción si el idioma detectado no es el de la app y no es "auto"
      return detectedLanguageCode != currentLocale &&
          detectedLanguageCode != 'auto';
    } catch (e) {
      print("Error detectando el idioma: $e");
      return false;
    }
  }

  /// Comprueba ambos campos (resumen y descripción) y actualiza la visibilidad de sus botones.
  Future<void> _updateTranslationButtonVisibility() async {
    // --- Lógica para el botón del RESUMEN ---
    // Solo mostramos el botón si estamos viendo el resumen original (no uno personalizado).
    final isShowingOriginalSummary =
        currentModInfo.customSummary == null ||
        currentModInfo.customSummary!.isEmpty;
    if (isShowingOriginalSummary) {
      final needsTranslation = await _checkIfTextNeedsTranslation(
        currentModInfo.summary,
      );
      if (mounted) {
        setState(() => _showTranslateSummaryButton = needsTranslation);
      }
    } else {
      if (mounted) {
        setState(() => _showTranslateSummaryButton = false);
      }
    }

    // --- Lógica para el botón de la DESCRIPCIÓN ---
    // Solo mostramos el botón si estamos viendo la descripción original.
    final isShowingOriginalDescription =
        currentModInfo.customDescription == null ||
        currentModInfo.customDescription!.isEmpty;
    if (isShowingOriginalDescription) {
      final needsTranslation = await _checkIfTextNeedsTranslation(
        currentModInfo.description,
      );
      if (mounted) {
        setState(() => _showTranslateDescriptionButton = needsTranslation);
      }
    } else {
      if (mounted) {
        setState(() => _showTranslateDescriptionButton = false);
      }
    }
  }

  // Traduce el resumen
  Future<void> _translateSummary() async {
    final l10n = AppLocalizations.of(context)!;
    if (currentModInfo.summary == null ||
        currentModInfo.summary!.trim().isEmpty)
      return;

    setState(() => _isTranslating = true);

    try {
      final translator = GoogleTranslator();
      final currentLocale = Localizations.localeOf(context).languageCode;
      final translation = await translator.translate(
        TextUtils.stripHtml(currentModInfo.summary!),
        from: 'auto',
        to: currentLocale,
      );

      // Guardamos la traducción en el campo personalizado 'summary' (que en la función onUpdateDetails se mapea a 'customSummary')
      final updatedMod = await widget.onUpdateDetails(currentModInfo, {
        'summary': translation.text,
      });

      if (updatedMod != null && mounted) {
        setState(() {
          currentModInfo = updatedMod;
          // ++ CAMBIO 3: Ocultar solo el botón del resumen ++
          _showTranslateSummaryButton = false;
          _needsReloadOnClose = true;
        });
      }
    } catch (e) {
      NotificationService.instance.show(
        context: context,
        type: NotificationType.error,
        title: l10n.errorTranslation,
        description: e.toString(),
      );
    } finally {
      if (mounted) setState(() => _isTranslating = false);
    }
  }

  // Traduce la descripción
  Future<void> _translateDescription() async {
    final l10n = AppLocalizations.of(context)!;
    if (currentModInfo.description == null ||
        currentModInfo.description!.trim().isEmpty)
      return;

    setState(() => _isTranslating = true);

    try {
      final translator = GoogleTranslator();
      final currentLocale = Localizations.localeOf(context).languageCode;
      final translation = await translator.translate(
        TextUtils.stripHtml(currentModInfo.description!), // Limpiamos el HTML
        from: 'auto',
        to: currentLocale,
      );

      final updatedMod = await widget.onUpdateDetails(currentModInfo, {
        'customDescription': translation.text,
      });

      if (updatedMod != null && mounted) {
        setState(() {
          currentModInfo = updatedMod;
          // ++ CAMBIO 4: Ocultar solo el botón de la descripción ++
          _showTranslateDescriptionButton = false;
          _needsReloadOnClose = true;
        });
      }
    } catch (e) {
      NotificationService.instance.show(
        context: context,
        type: NotificationType.error,
        title: l10n.errorTranslation,
        description: e.toString(),
      );
    } finally {
      if (mounted) setState(() => _isTranslating = false);
    }
  }

  // Muestra diálogo para editar un solo campo (notas, descripción)
  Future<String?> _showSingleFieldEditDialog({
    required String title,
    required String label,
    required String initialValue,
    String? defaultValue,
    int? maxLength,
  }) async {
    final controller = TextEditingController(text: initialValue);
    final l10n = AppLocalizations.of(context)!;
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final bool isCurrentlyDefault =
                controller.text == (defaultValue ?? '');
            return AlertDialog(
              title: Text(title),
              content: TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(labelText: label),
                maxLines: null,
                maxLength: maxLength,
                onChanged: (v) => setDialogState(() {}),
              ),
              actions: [
                if (defaultValue != null)
                  TextButton(
                    onPressed: isCurrentlyDefault
                        ? null
                        : () => setDialogState(
                            () => controller.text = defaultValue,
                          ),
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
  }

  // Construye las secciones de texto
  Widget _buildInfoSection({
    required String title,
    required String content,
    required IconData icon,
    VoidCallback? onEdit,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.tealAccent.withOpacity(0.8),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.tealAccent,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  // Botón para traducir el RESUMEN
                  if (title == l10n.modSummary && _showTranslateSummaryButton)
                    _isTranslating
                        ? const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(
                              Icons.translate,
                              color: Colors.white70,
                              size: 20,
                            ),
                            onPressed: _translateSummary,
                            tooltip: l10n.translateSummary,
                          ),

                  // Botón para traducir la DESCRIPCIÓN
                  if (title == l10n.modDescription &&
                      _showTranslateDescriptionButton)
                    _isTranslating
                        ? const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(
                              Icons.translate,
                              color: Colors.white70,
                              size: 20,
                            ),
                            onPressed: _translateDescription,
                            tooltip: l10n.translateDescription,
                          ),

                  if (onEdit != null)
                    IconButton(
                      icon: const HugeIcon(
                        icon: HugeIcons.strokeRoundedEdit01,
                        color: Colors.white70,
                        size: 20,
                      ),
                      onPressed: onEdit,
                      tooltip: l10n.editButtonTooltip,
                      splashRadius: 20,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            TextUtils.stripHtml(content), // Limpiamos el HTML siempre antes de mostrar
            style: TextStyle(
              color: content.startsWith('No')
                  ? Colors.white.withOpacity(0.5)
                  : Colors.white.withOpacity(0.9),
              fontStyle: content.startsWith('No')
                  ? FontStyle.italic
                  : FontStyle.normal,
              height: 1.5,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  /// Muestra el panel flotante para seleccionar un traje.
  /// Muestra el panel flotante para seleccionar múltiples trajes.
  Future<void> _showOutfitSelectionDialog(AppLocalizations l10n) async {
    final ValueNotifier<String?> hoveredOutfitNotifier = ValueNotifier<String?>(null);
    String searchQuery = ''; 
    bool isClosing = false;

    // Clonamos localmente la lista de trajes que ya están guardados en el mod
    final List<String> localSelectedOutfits = List.from(currentModInfo.replacesOutfits ?? []);

    final List<String>? finalSelection = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF2d2d2d),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8,
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            final filteredOutfits = stellarBladeOutfits
                .where((outfit) => outfit.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- LADO IZQUIERDO: BÚSQUEDA Y LISTA MULTI-SELECCIÓN (2/3) ---
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Container(
                        height: 5,
                        width: 40,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                autofocus: true,
                                onChanged: (value) {
                                  setDialogState(() {
                                    searchQuery = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: l10n.replacesOutfitSearchHint,
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Botón para confirmar la selección múltiple
                            ElevatedButton.icon(
                              icon: const HugeIcon(icon: HugeIcons.strokeRoundedSave, size: 18),
                              label: Text(l10n.dialogActionSave),
                              onPressed: () {
                                isClosing = true;
                                Navigator.of(context).pop(localSelectedOutfits);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.tealAccent,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: MouseRegion(
                          onExit: (_) {
                            if (isClosing) return;
                            if (hoveredOutfitNotifier.value != null) {
                              hoveredOutfitNotifier.value = null;
                            }
                          },
                          child: ListView.builder(
                            itemCount: filteredOutfits.length,
                            itemBuilder: (context, index) {
                              final outfit = filteredOutfits[index];
                              final isSelected = localSelectedOutfits.contains(outfit);
                              
                              return MouseRegion(
                                onEnter: (_) {
                                  if (isClosing) return;
                                  if (hoveredOutfitNotifier.value != outfit) {
                                    hoveredOutfitNotifier.value = outfit;
                                  }
                                },
                                child: CheckboxListTile(
                                  title: Text(outfit),
                                  value: isSelected,
                                  activeColor: Colors.tealAccent,
                                  checkColor: Colors.black,
                                  controlAffinity: ListTileControlAffinity.leading,
                                  onChanged: (bool? checked) {
                                    setDialogState(() {
                                      if (checked == true) {
                                        localSelectedOutfits.add(outfit);
                                      } else {
                                        localSelectedOutfits.remove(outfit);
                                      }
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // --- LADO DERECHO: VISTA PREVIA (1/3) ---
                Expanded(
                  flex: 1,
                  child: ValueListenableBuilder<String?>(
                    valueListenable: hoveredOutfitNotifier,
                    builder: (context, hoveredOutfitName, child) {
                      return Container(
                        height: double.infinity,
                        color: Colors.black.withOpacity(0.3),
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: AnimatedCrossFade(
                            crossFadeState: hoveredOutfitName == null
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            duration: const Duration(milliseconds: 200),
                            firstChild: Column(
                              key: const ValueKey('outfit_placeholder'),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                HugeIcon(icon: HugeIcons.strokeRoundedImageAdd02, size: 60, color: Colors.grey[700]),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.replacesOutfitHover,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                              ],
                            ),
                            secondChild: ClipRRect(
                              key: ValueKey(hoveredOutfitName),
                              child: Image.asset(
                                _generateOutfitImagePath(hoveredOutfitName ?? ''),
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: const HugeIcon(icon: HugeIcons.strokeRoundedImageDelete02, color: Colors.grey, size: 40),
                                    ),
                                  );
                                },
                              ),
                            ),
                            layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [bottomChild, topChild],
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    isClosing = true;
    hoveredOutfitNotifier.dispose();

    if (finalSelection != null) {
      await _onOutfitsSelected(finalSelection);
    }
  }

  /// Despacha y guarda la lista completa de trajes en el archivo JSON.
  Future<void> _onOutfitsSelected(List<String> outfits) async {
    final updatedMod = await widget.onUpdateDetails(currentModInfo, {
      'replacesOutfits': outfits.isEmpty ? null : outfits,
    });

    if (updatedMod != null && mounted) {
      setState(() {
        currentModInfo = updatedMod;
        _needsReloadOnClose = true;
      });
    }
  }

  /// Genera la ruta del asset para la vista previa de un traje.
  String _generateOutfitImagePath(String outfitName) {
    // 1. Minúsculas
    String safeName = outfitName.toLowerCase();
    // 2. Quitar (NG+) y caracteres especiales
    safeName = safeName
        .replaceAll('(ng+)', 'ng_plus')
        .replaceAll(RegExp(r'[^\w\s-]'), '');
    // 3. Reemplazar espacios y guiones con guiones bajos
    safeName = safeName.replaceAll(RegExp(r'[\s-]+'), '_');

    // 4. Devolver la ruta completa del asset
    return 'assets/images/outfits/$safeName.webp'; // Asume .webp
  }

  /// Construye la UI para mostrar y gestionar las múltiples portadas de trajes de reemplazo.
  Widget _buildOutfitReplacementSection(AppLocalizations l10n) {
    final List<String> replacedOutfits = currentModInfo.replacesOutfits ?? [];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedArrowReloadHorizontal,
                    color: Colors.tealAccent.withOpacity(0.8),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.replacesOutfitTitle,
                    style: const TextStyle(
                      color: Colors.tealAccent,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Botón unificado de configuración/edición múltiple
              IconButton(
                icon: HugeIcon(
                  icon: replacedOutfits.isNotEmpty ? HugeIcons.strokeRoundedHanger : HugeIcons.strokeRoundedHanger,
                  color: Colors.white70,
                  size: 20,
                ),
                onPressed: () => _showOutfitSelectionDialog(l10n),
                tooltip: l10n.replacesOutfitSelectTooltip,
                splashRadius: 20,
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),

          if (replacedOutfits.isNotEmpty) ...[
            const SizedBox(height: 12),
            // Carrusel horizontal pulido para listar todas las transformaciones asignadas
            SizedBox(
              height: 235, // <-- Altura aumentada (antes 175)
              child: Scrollbar(
                controller: _carouselScrollController,
                thumbVisibility: true, // Hace visible la barra siempre
                trackVisibility: true, // Muestra el riel sutilmente
                thickness: 6,
                radius: const Radius.circular(10),
                child: ListView.builder(
                  controller: _carouselScrollController,
                  scrollDirection: Axis.horizontal,
                  // Añadimos padding abajo para que el scrollbar no pise las tarjetas
                  padding: const EdgeInsets.only(bottom: 16), 
                  itemCount: replacedOutfits.length,
                  itemBuilder: (context, index) {
                    final outfit = replacedOutfits[index];
                    return Container(
                      width: 125, // <-- Anchura aumentada (antes 105)
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Image.asset(
                                _generateOutfitImagePath(outfit),
                                fit: BoxFit.cover,
                                // <-- ESTO EVITA QUE SE CORTE LA CABEZA:
                                alignment: Alignment.topCenter, 
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.black26,
                                    child: const HugeIcon(icon: HugeIcons.strokeRoundedImageRemove01, color: Colors.grey, size: 24),
                                  );
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                              color: Colors.black26,
                              child: Text(
                                outfit,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 10),
            Text(
              l10n.replacesOutfitNone,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontStyle: FontStyle.italic,
                height: 1.5,
                fontSize: 15,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool hasLink =
        (currentModInfo.customSourceUrl ?? currentModInfo.sourceUrl)
            ?.isNotEmpty ??
        false;
    // Determina el nombre del autor
    final author = currentModInfo.customAuthor ?? currentModInfo.author;
    String? mainImagePath;
    // 1. PRIORITIZE the custom cover path. This now includes our cached '_nexus_cover.jpg'.
    if (currentModInfo.customCoverPath != null &&
        currentModInfo.customCoverPath!.isNotEmpty) {
      // It's a local file, so we build the full path to it.
      mainImagePath = p.join(
        currentModInfo.directory.path,
        currentModInfo.customCoverPath!,
      );
      // 2. FALLBACK to the internet URL from the gallery only if no custom/cached cover exists.
    } else if (currentModInfo.gallery != null &&
        currentModInfo.gallery!.isNotEmpty) {
      mainImagePath = currentModInfo.gallery!.first['image'];
    }

    final displayVersion =
        currentModInfo.customVersion ?? currentModInfo.localVersion;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) {
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFF1e1e1e),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              centerTitle: true,
              leadingWidth:
                  200, // Aumenta el espacio disponible para el `leading`
              leading: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Versión
                    if (displayVersion != null && displayVersion.isNotEmpty)
                      InkWell(
                        onTap: () async {
                          final newVersion = await _showSingleFieldEditDialog(
                            title: l10n.editVersionText,
                            label: l10n.customVersionText,
                            initialValue: displayVersion,
                            defaultValue: currentModInfo.localVersion ?? '',
                            maxLength: 15,
                          );
                          if (newVersion != null) {
                            final updatedMod = await widget.onUpdateDetails(
                              currentModInfo,
                              {'customVersion': newVersion},
                            );
                            if (updatedMod != null) {
                              setState(() {
                                currentModInfo = updatedMod;
                                _needsReloadOnClose = true;
                              });
                            }
                          }
                        },
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 4,
                          ),
                          child: Text(
                            "${l10n.modVersion} $displayVersion",
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    if (displayVersion != null && displayVersion.isNotEmpty)
                      const SizedBox(width: 8),

                    // --- INICIO DE LA MODIFICACIÓN (Descomentado y actualizado) ---
                    /*/ Etiqueta
                    (() { // Usamos un constructor anónimo para definir las variables
                      final bool isReplacement = currentModInfo.replacesOutfit != null && currentModInfo.replacesOutfit!.isNotEmpty;
                      final String displayTag = isReplacement 
                          ? currentModInfo.replacesOutfit! 
                          : (currentModInfo.customFitMeshType ?? currentModInfo.fitMeshType ?? l10n.modCategoryOther);

                      return InkWell(
                        // Deshabilitamos el onTap si es un reemplazo
                        onTap: isReplacement ? null : () async {
                          final newTag = await _showSingleFieldEditDialog(
                            title: l10n.editTagText,
                            label: l10n.customTagText,
                            initialValue: displayTag,
                            defaultValue: currentModInfo.fitMeshType ?? '',
                          );
                          if (newTag != null) {
                            final updatedMod = await widget.onUpdateDetails(
                              currentModInfo,
                              {'customFitMeshType': newTag},
                            );
                            if (updatedMod != null) {
                              setState(() {
                                currentModInfo = updatedMod;
                                _needsReloadOnClose = true;
                              });
                            }
                          }
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isReplacement
                              ? Colors.black.withOpacity(0.4) // Fondo oscuro
                              : Colors.grey.withOpacity(0.2), // Fondo original
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row( // Usamos un Row para el icono
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isReplacement)
                                Icon(
                                  Icons.checkroom_outlined, 
                                  size: 12, 
                                  color: Colors.purpleAccent.shade100, // Color distintivo
                                ),
                              if (isReplacement)
                                const SizedBox(width: 6),
                              Text(
                                displayTag, // Muestra el nombre del traje
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isReplacement
                                    ? Colors.purpleAccent.shade100 // Color distintivo
                                    : Colors.white70, // Color original
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })(), // Fin del constructor anónimo de la etiqueta
                    // --- FIN DE LA MODIFICACIÓN ---*/
                  ],
                ),
              ),
              title: Container(
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              actions: [
                // Si hay una actualización que no está ignorada, muestra el botón.
                // Ahora la visibilidad depende del estado local '_isIgnored'.
                if (widget.updateInfo != null && !_isIgnored)
                  IconButton(
                    icon: const Icon(
                      Icons.notification_important_rounded,
                      color: Colors.yellowAccent,
                    ),
                    tooltip: l10n.updateAvailable(
                      widget.updateInfo!['version'],
                    ),
                    onPressed: () async {
                      if (currentModInfo.nexusId != null) {
                        final updateIdentifier =
                            currentModInfo.directory.path +
                            (widget.updateInfo!['version'] as String);

                        // 1. Llamamos a la función y esperamos su resultado (true/false).
                        final bool wasHidden = await widget.onShowUpdateDialog(
                          newVersion: widget.updateInfo!['version'],
                          nexusId: currentModInfo.nexusId!,
                          fileId: widget.updateInfo!['fileId'],
                          uniqueIdentifier: updateIdentifier,
                        );

                        // 2. Si el resultado es 'true', actualizamos el estado local para ocultar la campana.
                        if (wasHidden && mounted) {
                          setState(() {
                            _isIgnored = true;
                          });
                        }
                      }
                    },
                  ),
                IconButton(
                  icon: const HugeIcon(icon: HugeIcons.strokeRoundedPencilEdit02),
                  tooltip: l10n.editButtonTooltip,
                  onPressed: () async {
                    final updatedData = await widget.onShowGeneralEditDialog(
                      currentModInfo,
                      context,
                    );
                    if (updatedData != null) {
                      final updatedMod = await widget.onUpdateDetails(
                        currentModInfo,
                        updatedData,
                      );
                      if (updatedMod != null) {
                        setState(() => currentModInfo = updatedMod);
                        _needsReloadOnClose = true;
                      }
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            body: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (mainImagePath != null)
                            ModImage(
                              imageUrl: mainImagePath,
                              isLocal: !mainImagePath.startsWith('http'),
                              lastModified:
                                  currentModInfo.customCoverLastModified,
                            )
                          else
                            const Center(
                              child: HugeIcon(
                                icon: HugeIcons.strokeRoundedPuzzle,
                                size: 80,
                                color: Colors.white24,
                              ),
                            ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black.withOpacity(0.4),
                              ),
                              icon: const HugeIcon(
                                icon: HugeIcons.strokeRoundedFullscreen,
                                color: Colors.white,
                              ),
                              onPressed: () =>
                                  widget.onShowImageGallery(currentModInfo),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    currentModInfo.customName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2, // Límite de dos líneas
                    overflow: TextOverflow
                        .ellipsis, // Muestra "..." si el texto es muy largo
                  ),
                  // ++ INICIO DE LA MODIFICACIÓN: AUTOR COMO SUBTÍTULO ++
                  const SizedBox(height: 4),
                  Text(
                    // Verifica si el nombre del autor no es nulo ni está vacío
                    (author?.isNotEmpty ?? false)
                        // Si existe, usa la cadena localizada pasando el autor como argumento
                        ? l10n.byText(author!)
                        // De lo contrario, muestra una cadena vacía
                        : "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // ++ FIN DE LA MODIFICACIÓN ++
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const HugeIcon(icon: HugeIcons.strokeRoundedFolderOpen),
                          label: Text(l10n.showInFolder),
                          onPressed: () =>
                              widget.onShowInExplorer(currentModInfo.directory),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: HugeIcon(
  icon: hasLink ? HugeIcons.strokeRoundedLinkSquare02 : HugeIcons.strokeRoundedLinkSquare02,
  color: Colors.white,
  size: 20,
),
                          label: Text(
                            hasLink
                                ? l10n.openLinkButtonText
                                : l10n.addLinkButtonText,
                          ),
                          onPressed: () async {
                            final urlString =
                                currentModInfo.customSourceUrl ??
                                currentModInfo.sourceUrl;
                            if (urlString != null && urlString.isNotEmpty) {
                              final url = Uri.parse(urlString);
                              if (await canLaunchUrl(url)) await launchUrl(url);
                            } else {
                              final updatedData = await widget
                                  .onShowGeneralEditDialog(
                                    currentModInfo,
                                    context,
                                  );
                              if (updatedData != null) {
                                final updatedMod = await widget.onUpdateDetails(
                                  currentModInfo,
                                  updatedData,
                                );
                                if (updatedMod != null) {
                                  setState(() => currentModInfo = updatedMod);
                                  _needsReloadOnClose = true;
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hasLink
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.grey.withOpacity(0.2),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (currentModInfo.modType == 'genericPak' ||
                      currentModInfo.modType == 'replacement' ||
                      (currentModInfo.modType == null &&
                          currentModInfo.replacesOutfits != null)) ...[
                    const SizedBox(height: 20),
                    // --- Switch para Mod de Reemplazo ---
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: SwitchListTile(
                        title: Text(
                          l10n.replacementModSwitchTitle, // "Mod de Reemplazo"
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          l10n.replacementModSwitchDesc, // "Marca si este mod reemplaza un traje."
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                        value: _isReplacementMod,
                        activeColor: Colors.tealAccent,

                        // ++ INICIO DE LA MODIFICACIÓN: onChanged ++
                        onChanged: (bool newValue) async {
                          final String newModType = newValue ? 'replacement' : 'genericPak';

                          final Map<String, dynamic> dataToSave = {
                            'modType': newModType,
                          };

                          // Si se apaga, borramos la colección completa
                          if (newValue == false) {
                            dataToSave['replacesOutfits'] = null;
                          }

                          final updatedMod = await widget.onUpdateDetails(
                            currentModInfo,
                            dataToSave,
                          );

                          if (updatedMod != null && mounted) {
                            setState(() {
                              currentModInfo = updatedMod;
                              _isReplacementMod = newValue; 
                              _needsReloadOnClose = true;
                            });
                          } else {
                            setState(() {
                              _isReplacementMod = !newValue;
                            });
                          }
                        },
                      ),
                    ),

                    // --- Sección de Selección de Traje (Condicional) ---
                    if (_isReplacementMod) ...[
                      const SizedBox(height: 20),
                      _buildOutfitReplacementSection(l10n),
                    ],
                  ],
                  const SizedBox(height: 30),
                  _buildInfoSection(
                    title: l10n.modSummary,
                    content:
                        currentModInfo.customSummary ??
                        currentModInfo.summary ??
                        l10n.noDescriptionAvailable,
                    icon: Icons.description_outlined,
                    onEdit: () async {
                      final newSummary = await _showSingleFieldEditDialog(
                        title: l10n.modSummary,
                        label: l10n.summaryLabel,
                        initialValue:
                            currentModInfo.customSummary ??
                            currentModInfo.summary ??
                            '',
                        defaultValue: currentModInfo.summary ?? '',
                      );
                      if (newSummary != null) {
                        final updatedMod = await widget.onUpdateDetails(
                          currentModInfo,
                          {'summary': newSummary},
                        );
                        if (updatedMod != null) {
                          setState(() {
                            currentModInfo = updatedMod;
                            _needsReloadOnClose = true;
                          });
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildInfoSection(
                    title: l10n.personalNotes,
                    content: currentModInfo.userNotes?.isNotEmpty ?? false
                        ? currentModInfo.userNotes!
                        : l10n.noNotesAvailable,
                    icon: Icons.edit_note_outlined,
                    onEdit: () async {
                      final newNotes = await _showSingleFieldEditDialog(
                        title: l10n.personalNotes,
                        label: l10n.notesLabel,
                        initialValue: currentModInfo.userNotes ?? '',
                      );
                      if (newNotes != null) {
                        final updatedMod = await widget.onUpdateDetails(
                          currentModInfo,
                          {'userNotes': newNotes},
                        );
                        if (updatedMod != null) {
                          setState(() {
                            currentModInfo = updatedMod;
                            _needsReloadOnClose = true;
                          });
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                HugeIcon(
                                  icon: HugeIcons.strokeRoundedBook04,
                                  color: Colors.tealAccent.withOpacity(0.8),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.modDescription,
                                  style: const TextStyle(
                                    color: Colors.tealAccent,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                /*if (_showTranslateDescriptionButton)
                                  _isTranslating
                                      ? const Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          ),
                                        )
                                      : IconButton(
                                          icon: const Icon(
                                            Icons.translate,
                                            color: Colors.white70,
                                            size: 20,
                                          ),
                                          onPressed: _translateDescription,
                                          tooltip: l10n.translateDescription,
                                        ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    color: Colors.white70,
                                    size: 20,
                                  ),
                                  onPressed: () async {
                                    final newDescription = await _showSingleFieldEditDialog(
                                      title: l10n.modDescription,
                                      label: l10n.summaryLabel,
                                      initialValue: currentModInfo.customDescription ??
                                          _stripHtml(currentModInfo.description) ?? '',
                                      defaultValue: _stripHtml(currentModInfo.description) ?? '',
                                    );
                                    if (newDescription != null) {
                                      final updatedMod = await widget.onUpdateDetails(
                                        currentModInfo,
                                        {'customDescription': newDescription},
                                      );
                                      if (updatedMod != null) {
                                        setState(() {
                                          currentModInfo = updatedMod;
                                          _needsReloadOnClose = true;
                                        });
                                      }
                                    }
                                  },
                                  tooltip: l10n.editButtonTooltip,
                                  splashRadius: 20,
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                ),*/
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Aquí usamos el nuevo Widget
                        BBCodeRenderer(
                          data:
                              currentModInfo.customDescription ??
                              currentModInfo.description ??
                              l10n.noDescriptionAvailable,
                          defaultStyle: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            height: 1.5,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}