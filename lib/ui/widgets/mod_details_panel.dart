import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';
import 'package:translator/translator.dart';

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

  @override
  void initState() {
    super.initState();
    currentModInfo = widget.initialModInfo;
    _isIgnored = widget.isIgnored;
    _isReplacementMod =
        currentModInfo.modType == 'replacement' ||
        (currentModInfo.modType == 'genericPak' &&
            (currentModInfo.replacesOutfit != null &&
                currentModInfo.replacesOutfit!.isNotEmpty));
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
                      icon: const Icon(
                        Icons.edit_outlined,
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
  Future<void> _showOutfitSelectionDialog(AppLocalizations l10n) async {
    // --- CAMBIO 1: El Notifier ahora guarda el *nombre* del traje, no el índice ---
    // Esto soluciona la raíz de todos los errores.
    final ValueNotifier<String?> hoveredOutfitNotifier = ValueNotifier<String?>(
      null,
    );
    String searchQuery = ''; // El estado de la búsqueda se manejará localmente
    bool isClosing = false;

    final String? selectedOutfit = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF2d2d2d),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // Hacemos el panel más ancho y alto para que quepan bien las dos columnas
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8,
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      builder: (context) {
        // Usamos un StatefulBuilder para que SÓLO la columna de la lista
        // se reconstruya al escribir en el buscador.
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            // La lista filtrada se calcula aquí, cada vez que el StatefulBuilder se reconstruye
            final filteredOutfits = stellarBladeOutfits
                .where(
                  (outfit) =>
                      outfit.toLowerCase().contains(searchQuery.toLowerCase()),
                )
                .toList(); //

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- LADO IZQUIERDO: BÚSQUEDA Y LISTA (2/3 del espacio) ---
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // Barra de agarre
                      Container(
                        height: 5,
                        width: 40,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      // Barra de búsqueda
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: TextField(
                          autofocus: true,
                          onChanged: (value) {
                            // setDialogState SÓLO se usa para la búsqueda
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
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                          ),
                        ),
                      ),
                      // Lista de trajes (Expandida y con Scroll)
                      Expanded(
                        child: MouseRegion(
                          onExit: (_) {
                            if (isClosing) return;
                            // ++ INICIO DE LA MODIFICACIÓN ++
                            // Solo actualiza el notificador si el valor
                            // no es ya 'null'. Esto previene que
                            // onExit se dispare múltiples veces y
                            // cause el 'Duplicate key' en el AnimatedSwitcher.
                            if (hoveredOutfitNotifier.value != null) {
                              hoveredOutfitNotifier.value = null;
                            }
                            // ++ FIN DE LA MODIFICACIÓN ++
                          },
                          child: ListView.builder(
                            itemCount: filteredOutfits.length,
                            itemBuilder: (context, index) {
                              final outfit = filteredOutfits[index];
                              return MouseRegion(
                                // onEnter sigue aquí para *establecer* la vista previa
                                onEnter: (_) {
                                  if (isClosing) return;
                                  // ++ INICIO DE LA MODIFICACIÓN ++
                                  // Solo actualiza el notificador si el nuevo valor
                                  // es diferente al valor actual.
                                  // Esto previene el crash de "Duplicate key"
                                  // cuando el cursor se mueve rápido sobre el mismo item.
                                  if (hoveredOutfitNotifier.value != outfit) {
                                    hoveredOutfitNotifier.value = outfit;
                                  }
                                  // ++ FIN DE LA MODIFICACIÓN ++
                                },
                                // -- Ya NO necesitamos onExit aquí --
                                child: ListTile(
                                  title: Text(outfit),
                                  onTap: () {
                                    isClosing = true;
                                    Navigator.of(context).pop(outfit);
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

                // --- LADO DERECHO: VISTA PREVIA (1/3 del espacio) ---
                Expanded(
                  flex: 1,
                  // --- CAMBIO 3: Escucha el ValueNotifier<String?> ---
                  child: ValueListenableBuilder<String?>(
                    valueListenable: hoveredOutfitNotifier,
                    builder: (context, hoveredOutfitName, child) {
                      return Container(
                        // Ocupa toda la altura del panel
                        height: double.infinity,
                        color: Colors.black.withOpacity(0.3),
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: AnimatedCrossFade(
                            // 1. Estado: Muestra el placeholder (first) o la imagen (second)
                            crossFadeState: hoveredOutfitName == null
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,

                            duration: const Duration(milliseconds: 200),

                            // 2. Placeholder (Primer hijo)
                            firstChild: Column(
                              key: const ValueKey('outfit_placeholder'),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_search_rounded,
                                  size: 60,
                                  color: Colors.grey[700],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.replacesOutfitHover,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                              ],
                            ),

                            // 3. Imagen (Segundo hijo)
                            // La clave ValueKey(hoveredOutfitName) es crucial.
                            // Le dice al widget que cambie de imagen aunque el estado
                            // (showSecond) sea el mismo.
                            secondChild: ClipRRect(
                              key: ValueKey(hoveredOutfitName),
                              child: Image.asset(
                                // Usamos ?? '' para evitar errores si hoveredOutfitName es nulo
                                // durante el primer frame de la transición.
                                _generateOutfitImagePath(
                                  hoveredOutfitName ?? '',
                                ),
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  final path = _generateOutfitImagePath(
                                    hoveredOutfitName ?? '',
                                  );
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Preview not found at:\n$path",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // 4. (Opcional pero recomendado) Esto evita que el panel "salte"
                            // de tamaño durante la animación de fundido.
                            layoutBuilder:
                                (
                                  topChild,
                                  topChildKey,
                                  bottomChild,
                                  bottomChildKey,
                                ) {
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
    // (Por si el usuario cierra el panel sin seleccionar nada)
    isClosing = true;
    // Limpiamos el "mensajero" después de que el panel se cierra.
    hoveredOutfitNotifier.dispose();

    if (selectedOutfit != null) {
      _onOutfitSelected(selectedOutfit);
    }
  }

  /// Maneja el guardado del traje seleccionado.
  Future<void> _onOutfitSelected(String? outfitName) async {
    // Pasa los nuevos datos a la función de actualización del widget principal
    final updatedMod = await widget.onUpdateDetails(currentModInfo, {
      'replacesOutfit': outfitName, // Será nulo si se está limpiando
    });

    if (updatedMod != null && mounted) {
      setState(() {
        currentModInfo = updatedMod;
        _needsReloadOnClose =
            true; // Marca que la lista principal necesita recargarse
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

  /// Construye la UI para seleccionar un traje de reemplazo.
  Widget _buildOutfitReplacementSection(AppLocalizations l10n) {
    final String? replacedOutfit = currentModInfo.replacesOutfit;

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
              // --- TÍTULO ---
              Row(
                children: [
                  Icon(
                    Icons.swap_horiz_rounded,
                    color: Colors.tealAccent.withOpacity(0.8),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.replacesOutfitTitle, // Necesitarás esta traducción
                    style: const TextStyle(
                      color: Colors.tealAccent,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // --- BOTÓN DE EDITAR / LIMPIAR ---
              IconButton(
                icon: Icon(
                  // Cambia el ícono si ya hay un traje seleccionado
                  replacedOutfit != null
                      ? Icons.cancel_outlined
                      : Icons.checkroom_outlined,
                  color: replacedOutfit != null
                      ? Colors.redAccent
                      : Colors.white70,
                  size: 20,
                ),
                onPressed: () {
                  if (replacedOutfit != null) {
                    // Limpiar la selección
                    _onOutfitSelected(null);
                  } else {
                    // Mostrar el diálogo de selección
                    _showOutfitSelectionDialog(l10n);
                  }
                },
                tooltip: replacedOutfit != null
                    ? l10n.replacesOutfitClearTooltip
                    : l10n.replacesOutfitSelectTooltip, // Necesitarás estas traducciones
                splashRadius: 20,
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),

          // --- "MINI-RETRATO" (El nombre del traje seleccionado) ---
          if (replacedOutfit != null) ...[
            const SizedBox(height: 12),
            // Mantenemos el contenedor original para el fondo y el borde
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(
                12,
              ), // Un poco más de padding para la imagen
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Centra verticalmente
                children: [
                  // 1. Vista previa de la imagen
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      6.0,
                    ), // Bordes redondeados más pequeños
                    child: Image.asset(
                      _generateOutfitImagePath(
                        replacedOutfit,
                      ), // Usamos la función auxiliar
                      width: 92.5, // Proporción 3:4 (como 60x80)
                      height: 167,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Placeholder si la imagen no se encuentra
                        return Container(
                          width: 52.5,
                          height: 70,
                          color: Colors.black.withOpacity(0.2),
                          child: const Icon(
                            Icons.hide_image_outlined,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 2. Nombre del traje
                  Expanded(
                    child: Text(
                      replacedOutfit,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16, // Más grande
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Mensaje de que no hay nada seleccionado
            const SizedBox(height: 10),
            Text(
              l10n.replacesOutfitNone, // Necesitarás esta traducción
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
                  icon: const Icon(Icons.edit_note_rounded),
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
                              child: Icon(
                                Icons.extension,
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
                              icon: const Icon(
                                Icons.fullscreen_outlined,
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
                          icon: const Icon(Icons.folder_open),
                          label: Text(l10n.showInFolder),
                          onPressed: () =>
                              widget.onShowInExplorer(currentModInfo.directory),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(
                            hasLink
                                ? Icons.open_in_browser_outlined
                                : Icons.add_link_rounded,
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
                          currentModInfo.replacesOutfit != null)) ...[
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
                          // Define el nuevo tipo de mod basado en el switch
                          final String newModType = newValue
                              ? 'replacement'
                              : 'genericPak';

                          // Prepara los datos para guardar.
                          final Map<String, dynamic> dataToSave = {
                            'modType': newModType,
                          };

                          // Si el usuario está APAGANDO el switch,
                          // también borramos el traje seleccionado.
                          if (newValue == false) {
                            dataToSave['replacesOutfit'] = null;
                          }

                          // Guardamos los cambios inmediatamente
                          final updatedMod = await widget.onUpdateDetails(
                            currentModInfo,
                            dataToSave,
                          );

                          // Actualizamos la UI local
                          if (updatedMod != null && mounted) {
                            setState(() {
                              currentModInfo = updatedMod;
                              _isReplacementMod =
                                  newValue; // Sincroniza el switch
                              _needsReloadOnClose = true;
                            });
                          } else {
                            // Si falla el guardado, revierte el switch
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
                                Icon(
                                  Icons.description_outlined,
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