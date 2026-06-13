// En lib/ui/dialogs/splash_mod_dialog.dart
import 'package:flutter/material.dart';
import 'dart:io';
import '../../services/splash_mods_handler.dart';

class SplashModSelectionDialog extends StatefulWidget {
  final SplashSelectionData modData;

  const SplashModSelectionDialog({super.key, required this.modData});

  static Future<bool> show(BuildContext context, SplashSelectionData modData) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => SplashModSelectionDialog(modData: modData),
    );
    return result ?? false;
  }

  @override
  State<SplashModSelectionDialog> createState() => _SplashModSelectionDialogState();
}

class _SplashModSelectionDialogState extends State<SplashModSelectionDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF2a2a2a),
      title: const Text('Opciones de Splash (Imágenes)', style: TextStyle(color: Colors.white)),
      content: SizedBox(
        width: double.maxFinite,
        height: 450,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecciona las imágenes que deseas instalar. Puedes elegir por carpetas completas (lotes) o imágenes individuales.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: widget.modData.folders.length,
                itemBuilder: (context, index) {
                  final folder = widget.modData.folders[index];
                  return Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      iconColor: Colors.tealAccent,
                      collapsedIconColor: Colors.grey,
                      title: Row(
                        children: [
                          Checkbox(
                            value: folder.isAllSelected ? true : (folder.isAnySelected ? null : false),
                            tristate: true,
                            activeColor: Colors.tealAccent,
                            checkColor: Colors.black,
                            onChanged: (val) {
                              setState(() {
                                folder.toggleAll(val == null ? false : val);
                              });
                            }
                          ),
                          const Icon(Icons.folder, color: Colors.tealAccent, size: 20),
                          const SizedBox(width: 8),
                          Expanded(child: Text(folder.folderName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                        ],
                      ),
                      children: folder.images.map((img) {
                        final isImage = ['.bmp', '.jpg', '.jpeg', '.png'].contains(img.file.path.split('.').last.toLowerCase().padLeft(4, '.'));
                        return Padding(
                          padding: const EdgeInsets.only(left: 32.0, right: 8.0, top: 4.0, bottom: 4.0),
                          child: Row(
                            children: [
                              Checkbox(
                                value: img.isSelected,
                                activeColor: Colors.tealAccent,
                                checkColor: Colors.black,
                                onChanged: (val) {
                                  setState(() {
                                    img.isSelected = val ?? false;
                                  });
                                }
                              ),
                              if (isImage)
                                Container(
                                  width: 45,
                                  height: 45,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: Colors.black54, width: 1),
                                    image: DecorationImage(
                                      image: FileImage(img.file),
                                      fit: BoxFit.cover,
                                    )
                                  ),
                                )
                              else
                                Container(
                                  width: 45,
                                  height: 45,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(Icons.settings, color: Colors.white54),
                                ),
                              Expanded(child: Text(img.name, style: const TextStyle(fontSize: 13, color: Colors.white70))),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            if (!widget.modData.hasSelection) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Por favor, selecciona al menos una imagen.'), backgroundColor: Colors.redAccent),
              );
              return;
            }
            Navigator.of(context).pop(true);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: Colors.black),
          child: const Text('Instalar Selección'),
        ),
      ],
    );
  }
}