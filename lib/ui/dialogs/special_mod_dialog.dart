import 'package:flutter/material.dart';
import '../../services/special_mods_handler.dart';
import '../../l10n/app_localizations.dart';

class SpecialModSelectionDialog extends StatefulWidget {
  final SpecialModData modData;

  const SpecialModSelectionDialog({super.key, required this.modData});

  /// Muestra el diálogo y devuelve 'true' si el usuario confirmó la selección
  static Future<bool> show(BuildContext context, SpecialModData modData) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => SpecialModSelectionDialog(modData: modData),
    );
    return result ?? false;
  }

  @override
  State<SpecialModSelectionDialog> createState() => _SpecialModSelectionDialogState();
}

class _SpecialModSelectionDialogState extends State<SpecialModSelectionDialog> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return AlertDialog(
      backgroundColor: const Color(0xFF2a2a2a),
      title: Text(l10n.dialogTitleSpecialModSelection(widget.modData.nexusId)),
      content: SizedBox(
        width: double.maxFinite,
        height: 400, // Altura fija para que la lista sea scrolleable
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // Si quieres, puedes poner un texto diferente dependiendo de si es selección única
              widget.modData.isSingleSelection 
                  ? "Selecciona una única opción para instalar." 
                  : l10n.dialogContentSpecialModSelection,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.modData.options.length,
                itemBuilder: (context, index) {
                  final option = widget.modData.options[index];
                  return CheckboxListTile(
                    title: Text(
                      option.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    value: option.isSelected,
                    activeColor: Colors.tealAccent,
                    checkColor: Colors.black,
                    // NUEVO: Le damos forma de círculo si es de selección única
                    checkboxShape: widget.modData.isSingleSelection 
                        ? const CircleBorder() 
                        : null,
                    onChanged: (bool? value) {
                      setState(() {
                        if (widget.modData.isSingleSelection) {
                          // Lógica de selección única (Radio Button)
                          for (var o in widget.modData.options) {
                            o.isSelected = false; // Desmarcamos todos
                          }
                          option.isSelected = true; // Marcamos solo el actual
                        } else {
                          // Lógica normal de selección múltiple
                          option.isSelected = value ?? false;
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), // Cancela
          child: Text(l10n.dialogActionCancel, style: const TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            // Verifica que haya seleccionado al menos una opción
            final hasSelection = widget.modData.options.any((o) => o.isSelected);
            if (!hasSelection) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.snackBarSpecialModNoSelection)),
              );
              return;
            }
            Navigator.of(context).pop(true); // Confirma
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.tealAccent,
            foregroundColor: Colors.black,
          ),
          child: Text(l10n.dialogActionInstallSelection),
        ),
      ],
    );
  }
}