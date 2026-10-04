import 'package:flutter/material.dart';
import '../theme/ios_theme.dart';

/// Barra de progreso fina con extremos redondeados (como en iOS / macOS).
/// Con [value] == null se muestra indeterminada.
class IosProgressBar extends StatelessWidget {
  const IosProgressBar({
    super.key,
    this.value,
    this.color = IosColors.blue,
    this.height = 4,
  });

  final double? value;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: LinearProgressIndicator(
        value: value,
        minHeight: height,
        backgroundColor: const Color(0x1FFFFFFF),
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}