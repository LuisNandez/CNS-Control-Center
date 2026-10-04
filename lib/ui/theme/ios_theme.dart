// ignore_for_file: deprecated_member_use
import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

/// Paleta tomada de los colores de sistema de iOS / macOS en modo oscuro.
/// Para cambiar el color de acento de TODA la app, edita solo [blue].
class IosColors {
  IosColors._();

  // Superficies
  static const Color background = Color(0xFF1C1C1E); // fondo de ventana
  static const Color bar = Color(0xFF252527); // barra superior
  static const Color card = Color(0xFF2C2C2E); // tarjetas / filas
  static const Color elevated = Color(0xFF3A3A3C); // menús, popovers
  static const Color separator = Color(0xFF38383A);

  // Rellenos translúcidos (campos de búsqueda, segmentados, chips)
  static const Color fill = Color(0x3D767680);
  static const Color chip = Color(0x1FFFFFFF);
  static const Color chipHover = Color(0x2EFFFFFF);

  // Texto
  static const Color label = Color(0xFFFFFFFF);
  static const Color secondaryLabel = Color(0x99EBEBF5);
  static const Color tertiaryLabel = Color(0x4DEBEBF5);
  static const Color icon = Color(0xFFD1D1D6);

  // Colores de sistema
  static const Color blue = Color(0xFF0A84FF);
  static const Color green = Color(0xFF30D158);
  static const Color red = Color(0xFFFF453A);
  static const Color orange = Color(0xFFFF9F0A);
  static const Color yellow = Color(0xFFFFD60A);
  static const Color purple = Color(0xFFBF5AF2);
  static const Color teal = Color(0xFF40C8E0);
  static const Color gray = Color(0xFF8E8E93);
}

class IosTheme {
  IosTheme._();

  static ThemeData dark() {
    const scheme = ColorScheme.dark(
      primary: IosColors.blue,
      onPrimary: Colors.white,
      secondary: IosColors.blue,
      onSecondary: Colors.white,
      surface: IosColors.card,
      onSurface: IosColors.label,
      error: IosColors.red,
    );

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: IosColors.background,
      canvasColor: IosColors.card,
      cardColor: IosColors.card,
      primaryColor: IosColors.blue,
      dividerColor: IosColors.separator,
      dividerTheme: const DividerThemeData(
        color: IosColors.separator,
        thickness: 0.5,
        space: 1,
      ),

      // Sin ondas de Material: iOS/macOS usan resaltados suaves.
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: const Color(0x0FFFFFFF),

      // SF Pro si existe en el sistema; si no, la mejor fuente disponible.
      fontFamily: 'SF Pro Text',
      fontFamilyFallback: const [
        'SF Pro Display',
        '.AppleSystemUIFont',
        'Segoe UI Variable Text',
        'Segoe UI',
      ],

      appBarTheme: const AppBarTheme(
        backgroundColor: IosColors.bar,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: IosColors.label,
        ),
        iconTheme: IconThemeData(color: IosColors.icon),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: IosColors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: IosColors.blue,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Menús desplegables estilo macOS.
      popupMenuTheme: PopupMenuThemeData(
        color: IosColors.elevated,
        elevation: 16,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0x1FFFFFFF), width: 0.5),
        ),
        textStyle: const TextStyle(
          fontSize: 13,
          color: IosColors.label,
          letterSpacing: -0.1,
        ),
      ),

      tooltipTheme: TooltipThemeData(
        waitDuration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xF2323234),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: const Color(0x1FFFFFFF), width: 0.5),
        ),
        textStyle: const TextStyle(fontSize: 12, color: IosColors.label),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: IosColors.elevated,
        behavior: SnackBarBehavior.floating,
        contentTextStyle: const TextStyle(fontSize: 13, color: IosColors.label),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Al abrir otra pantalla (p. ej. Ajustes) se desliza como en iOS.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
