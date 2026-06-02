import 'package:flutter/material.dart';
import '../../models/mod_info.dart';

/// Un widget Switch que maneja su propio estado de animación localmente
/// para permitir una transición visual suave (deslizamiento) al cambiar,
/// mientras sigue llamando a los callbacks del widget principal para
/// ejecutar la lógica de habilitación/deshabilitación.
class AnimatedModSwitch extends StatefulWidget {
  final ModInfo modInfo;
  final bool isLoading;
  final Future<bool> Function(ModInfo) onEnable;
  final Future<bool> Function(ModInfo) onDisable;
  final double scale;

  const AnimatedModSwitch({
    super.key,
    required this.modInfo,
    required this.isLoading,
    required this.onEnable,
    required this.onDisable,
    this.scale = 1.0,
  });

  @override
  State<AnimatedModSwitch> createState() => _AnimatedModSwitchState();
}

class _AnimatedModSwitchState extends State<AnimatedModSwitch> {
  late bool _isEnabled;
  bool _isLocallyLoading = false;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.modInfo.isEnabled;
  }

  @override
  void didUpdateWidget(covariant AnimatedModSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.modInfo.isEnabled != _isEnabled && !_isLocallyLoading) {
      _isEnabled = widget.modInfo.isEnabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.isLoading || _isLocallyLoading;

    Widget switchWidget = Switch(
      value: _isEnabled,
      activeColor: Colors.tealAccent,
      onChanged: isDisabled
          ? null
          : (newValue) async {
              setState(() {
                _isEnabled = newValue;
                _isLocallyLoading = true;
              });

              await Future.delayed(const Duration(milliseconds: 300));

              try {
                bool success;
                if (newValue) {
                  success = await widget.onEnable(widget.modInfo);
                } else {
                  success = await widget.onDisable(widget.modInfo);
                }

                if (!success && mounted) {
                  setState(() {
                    _isEnabled = !newValue;
                  });
                }
              } catch (e) {
                if (mounted) {
                  setState(() {
                    _isEnabled = !newValue;
                  });
                }
              } finally {
                if (mounted) {
                  setState(() {
                    _isLocallyLoading = false;
                  });
                }
              }
            },
    );

    if (widget.scale != 1.0) {
      return Transform.scale(scale: widget.scale, child: switchWidget);
    }

    return switchWidget;
  }
}