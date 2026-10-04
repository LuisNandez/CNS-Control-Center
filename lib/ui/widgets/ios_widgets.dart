// ignore_for_file: deprecated_member_use
import 'dart:ui' show ImageFilter;
import 'package:flutter/cupertino.dart'
    show
        CupertinoActivityIndicator,
        CupertinoSearchTextField,
        CupertinoSlidingSegmentedControl,
        CupertinoSwitch,
        OverlayVisibilityMode;
import 'package:flutter/material.dart';
import '../theme/ios_theme.dart';

/// Botón de icono de barra de herramientas (como en macOS):
/// sin borde, con un resaltado redondeado al pasar el cursor.
/// Si [background] no es null se dibuja como cápsula rellena (p. ej. "Jugar").
class IosToolbarButton extends StatefulWidget {
  const IosToolbarButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.background,
    this.width = 32,
    this.height = 32,
    this.busy = false,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? background;
  final double width;
  final double height;

  /// Mientras es true el botón ignora los clics pero NO se atenúa, para que
  /// el indicador de carga que lleva dentro se vea con total nitidez.
  final bool busy;

  @override
  State<IosToolbarButton> createState() => _IosToolbarButtonState();
}

class _IosToolbarButtonState extends State<IosToolbarButton> {
  bool _hover = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.busy;
    final bg = widget.background;

    Color fill;
    if (bg != null) {
      fill = _pressed
          ? Color.lerp(bg, Colors.black, 0.2)!
          : (_hover && enabled ? Color.lerp(bg, Colors.white, 0.12)! : bg);
    } else {
      fill = _pressed && enabled
          ? const Color(0x24FFFFFF)
          : (_hover && enabled ? const Color(0x14FFFFFF) : Colors.transparent);
    }

    Widget box = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      width: widget.width,
      height: widget.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(
          bg != null ? widget.height / 2 : 8,
        ),
      ),
      child: Opacity(
        opacity: (enabled || widget.busy) ? 1 : 0.35,
        child: widget.icon,
      ),
    );

    box = MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _pressed = false;
      }),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        onTap: widget.onPressed,
        child: box,
      ),
    );

    return widget.tooltip == null
        ? box
        : Tooltip(message: widget.tooltip!, child: box);
  }
}

/// Botón principal relleno (acción destacada, p. ej. "Instalar nuevo mod").
class IosButton extends StatefulWidget {
  const IosButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.color = IosColors.blue,
    this.height = 34,
  });

  final String label;
  final Widget? icon;
  final VoidCallback? onPressed;
  final Color color;
  final double height;

  @override
  State<IosButton> createState() => _IosButtonState();
}

class _IosButtonState extends State<IosButton> {
  bool _hover = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    Color fill = widget.color;
    if (_pressed) {
      fill = Color.lerp(fill, Colors.black, 0.2)!;
    } else if (_hover) {
      fill = Color.lerp(fill, Colors.white, 0.1)!;
    }
    if (!enabled) fill = fill.withOpacity(0.4);

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _pressed = false;
      }),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: widget.height,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                widget.icon!,
                const SizedBox(width: 6),
              ],
              Text(
                widget.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.1,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Campo de búsqueda al estilo iOS (cápsula gris con lupa y botón de borrar).
/// Usa iconos de Material para no depender del paquete cupertino_icons.
class IosSearchField extends StatelessWidget {
  const IosSearchField({
    super.key,
    required this.controller,
    required this.placeholder,
    this.onChanged,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final String placeholder;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: CupertinoSearchTextField(
        controller: controller,
        placeholder: placeholder,
        onChanged: onChanged,
        autofocus: autofocus,
        style: const TextStyle(
          color: IosColors.label,
          fontSize: 13.5,
          letterSpacing: -0.1,
        ),
        placeholderStyle: const TextStyle(
          color: IosColors.secondaryLabel,
          fontSize: 13.5,
          letterSpacing: -0.1,
        ),
        backgroundColor: IosColors.fill,
        borderRadius: BorderRadius.circular(10),
        prefixIcon: const Icon(
          Icons.search_rounded,
          size: 17,
          color: IosColors.secondaryLabel,
        ),
        suffixIcon: const Icon(
          Icons.cancel_rounded,
          size: 16,
          color: IosColors.secondaryLabel,
        ),
        suffixMode: OverlayVisibilityMode.editing,
      ),
    );
  }
}

/// Control segmentado de iOS (con "píldora" deslizante).
class IosSegmented<T extends Object> extends StatelessWidget {
  const IosSegmented({
    super.key,
    required this.value,
    required this.children,
    required this.onChanged,
    this.segmentPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  });

  final T value;
  final Map<T, Widget> children;
  final ValueChanged<T> onChanged;
  final EdgeInsetsGeometry segmentPadding;

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl<T>(
      groupValue: value,
      backgroundColor: IosColors.fill,
      thumbColor: const Color(0xFF636366),
      padding: const EdgeInsets.all(2),
      children: {
        for (final e in children.entries)
          e.key: Padding(
            padding: segmentPadding,
            child: e.value,
          ),
      },
      onValueChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}

/// Chip de filtro (cápsula). Seleccionado = relleno con el color de acento.
class IosChip extends StatefulWidget {
  const IosChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<IosChip> createState() => _IosChipState();
}

class _IosChipState extends State<IosChip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final Color fill = widget.selected
        ? IosColors.blue
        : (_hover ? IosColors.chipHover : IosColors.chip);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.1,
              color: widget.selected ? Colors.white : const Color(0xCCEBEBF5),
            ),
          ),
        ),
      ),
    );
  }
}

/// Fila de menú estilo macOS: icono opcional, texto y marca de selección.
PopupMenuItem<T> iosMenuItem<T>({
  required T value,
  required String label,
  Widget? leading,
  bool selected = false,
  bool destructive = false,
  bool enabled = true,
}) {
  final Color color = !enabled
      ? IosColors.tertiaryLabel
      : (destructive ? IosColors.red : IosColors.label);

  return PopupMenuItem<T>(
    value: value,
    enabled: enabled,
    height: 34,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Row(
      children: [
        if (leading != null) ...[
          Opacity(opacity: enabled ? 1 : 0.4, child: leading),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13, color: color, letterSpacing: -0.1),
          ),
        ),
        if (selected)
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Icon(Icons.check_rounded, size: 16, color: IosColors.blue),
          ),
      ],
    ),
  );
}

/// Botón de barra que abre un menú justo debajo de él.
class IosMenuButton<T> extends StatelessWidget {
  const IosMenuButton({
    super.key,
    required this.icon,
    required this.itemBuilder,
    required this.onSelected,
    this.tooltip,
    this.enabled = true,
    this.width = 32,
    this.height = 32,
  });

  final Widget icon;
  final String? tooltip;
  final bool enabled;
  final double width;
  final double height;
  final List<PopupMenuEntry<T>> Function(BuildContext context) itemBuilder;
  final ValueChanged<T> onSelected;

  Future<void> _open(BuildContext context) async {
    final button = context.findRenderObject() as RenderBox;
    final overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final topLeft = button.localToGlobal(
      Offset(0, button.size.height + 4),
      ancestor: overlay,
    );
    final position = RelativeRect.fromLTRB(
      topLeft.dx,
      topLeft.dy,
      overlay.size.width - topLeft.dx - button.size.width,
      overlay.size.height - topLeft.dy,
    );

    final result = await showMenu<T>(
      context: context,
      position: position,
      items: itemBuilder(context),
      constraints: const BoxConstraints(minWidth: 190),
    );
    if (result != null) onSelected(result);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (buttonContext) => IosToolbarButton(
        icon: icon,
        tooltip: tooltip,
        width: width,
        height: height,
        onPressed: enabled ? () => _open(buttonContext) : null,
      ),
    );
  }
}


// ============================================================================
//  COMPONENTES NUEVOS (panel de detalles, hojas y diálogos)
// ============================================================================

/// Superficie de "vidrio" (material translúcido de iOS/macOS): desenfoca lo que
/// hay detrás, aplica un tinte semitransparente y un filo de 0.8 px.
class IosGlass extends StatelessWidget {
  const IosGlass({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
    this.blur = 30,
    this.blurEnabled = true,
    this.color = const Color(0xD92C2C2E),
    this.borderColor = const Color(0x24FFFFFF),
    this.shadow = false,
  });

  final Widget child;
  final BorderRadiusGeometry borderRadius;
  final double blur;

  /// Apaga el desenfoque SIN quitar el BackdropFilter del árbol (si se quitara,
  /// Flutter reconstruiría todo el contenido y perdería su estado: scroll,
  /// animaciones...). Sirve para pausarlo mientras algo lo tapa por completo.
  final bool blurEnabled;
  final Color color;
  final Color borderColor;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    final Widget panel = DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        border: Border.all(color: borderColor, width: 0.8),
      ),
      child: child,
    );

    // Con blur <= 0 no se crea el BackdropFilter: desenfocar lo que hay detrás
    // se repite en cada fotograma y es lo más caro de pintar, así que las
    // superficies grandes que se desplazan lo evitan (y usan un color casi
    // opaco).
    final Widget glass = ClipRRect(
      borderRadius: borderRadius,
      child: blur > 0
          ? BackdropFilter(
              enabled: blurEnabled,
              filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
              child: panel,
            )
          : panel,
    );

    if (!shadow) return glass;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: glass,
    );
  }
}

/// Sección agrupada (como en Ajustes de iOS): título pequeño arriba, a la
/// izquierda, con acciones a la derecha, y una tarjeta translúcida debajo.
class IosGroup extends StatelessWidget {
  const IosGroup({
    super.key,
    required this.child,
    this.title,
    this.icon,
    this.actions = const [],
    this.padding = const EdgeInsets.all(14),
  });

  final Widget child;
  final String? title;
  final Widget? icon;
  final List<Widget> actions;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null)
          SizedBox(
            height: 32,
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Row(
                children: [
                  if (icon != null) ...[icon!, const SizedBox(width: 6)],
                  Expanded(
                    child: Text(
                      title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.1,
                        color: IosColors.secondaryLabel,
                      ),
                    ),
                  ),
                  ...actions,
                ],
              ),
            ),
          ),
        Container(
          padding: padding,
          decoration: BoxDecoration(
            color: const Color(0x14FFFFFF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x14FFFFFF), width: 0.5),
          ),
          child: child,
        ),
      ],
    );
  }
}

enum IosButtonStyle { filled, tinted, gray }

/// Botón ancho con tres estilos de iOS: relleno, tintado y gris.
/// [iconBuilder] recibe el color correcto para el icono según el estilo.
class IosActionButton extends StatefulWidget {
  const IosActionButton({
    super.key,
    required this.label,
    this.iconBuilder,
    this.onPressed,
    this.style = IosButtonStyle.tinted,
    this.color = IosColors.blue,
    this.height = 38,
  });

  final String label;
  final Widget Function(Color color)? iconBuilder;
  final VoidCallback? onPressed;
  final IosButtonStyle style;
  final Color color;
  final double height;

  @override
  State<IosActionButton> createState() => _IosActionButtonState();
}

class _IosActionButtonState extends State<IosActionButton> {
  bool _hover = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final Color c = widget.color;

    Color bg;
    Color fg;
    switch (widget.style) {
      case IosButtonStyle.filled:
        bg = _pressed
            ? Color.lerp(c, Colors.black, 0.2)!
            : (_hover ? Color.lerp(c, Colors.white, 0.1)! : c);
        fg = Colors.white;
        break;
      case IosButtonStyle.tinted:
        bg = c.withOpacity(_pressed ? 0.30 : (_hover ? 0.24 : 0.16));
        fg = c;
        break;
      case IosButtonStyle.gray:
        bg = _pressed
            ? const Color(0x38FFFFFF)
            : (_hover ? IosColors.chipHover : IosColors.chip);
        fg = c;
        break;
    }

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _pressed = false;
      }),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _pressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 90),
          child: Opacity(
            opacity: enabled ? 1 : 0.4,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              height: widget.height,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.iconBuilder != null) ...[
                    widget.iconBuilder!(fg),
                    const SizedBox(width: 7),
                  ],
                  Flexible(
                    child: Text(
                      widget.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.1,
                        color: fg,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Botón de texto sin fondo (azul), con resaltado redondeado al pasar el cursor.
class IosTextButton extends StatefulWidget {
  const IosTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color = IosColors.blue,
    this.fontSize = 13.5,
    this.bold = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final double fontSize;
  final bool bold;

  @override
  State<IosTextButton> createState() => _IosTextButtonState();
}

class _IosTextButtonState extends State<IosTextButton> {
  bool _hover = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _pressed = false;
      }),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: _pressed && enabled
                ? const Color(0x24FFFFFF)
                : (_hover && enabled
                    ? const Color(0x14FFFFFF)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            widget.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: widget.bold ? FontWeight.w600 : FontWeight.w500,
              letterSpacing: -0.1,
              color: enabled ? widget.color : IosColors.tertiaryLabel,
            ),
          ),
        ),
      ),
    );
  }
}

/// Botón circular gris con una "x" (cerrar hojas y paneles, como en iOS).
class IosCloseButton extends StatefulWidget {
  const IosCloseButton({super.key, required this.onPressed, this.tooltip});

  final VoidCallback onPressed;
  final String? tooltip;

  @override
  State<IosCloseButton> createState() => _IosCloseButtonState();
}

class _IosCloseButtonState extends State<IosCloseButton> {
  bool _hover = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    Widget btn = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _pressed = false;
      }),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _pressed
                ? const Color(0x66767680)
                : (_hover ? const Color(0x52767680) : const Color(0x3D767680)),
          ),
          child: const Icon(
            Icons.close_rounded,
            size: 16,
            color: IosColors.secondaryLabel,
          ),
        ),
      ),
    );
    return widget.tooltip == null
        ? btn
        : Tooltip(message: widget.tooltip!, child: btn);
  }
}

/// Fila con título, subtítulo opcional e interruptor estilo iOS.
class IosSwitchRow extends StatelessWidget {
  const IosSwitchRow({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.2,
                  color: IosColors.label,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.3,
                    color: IosColors.secondaryLabel,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        CupertinoSwitch(
          value: value,
          activeColor: IosColors.green,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// Fila seleccionable con círculo de verificación (lista de selección múltiple).
class IosCheckRow extends StatefulWidget {
  const IosCheckRow({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.onEnter,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onEnter;

  @override
  State<IosCheckRow> createState() => _IosCheckRowState();
}

class _IosCheckRowState extends State<IosCheckRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _hover = true);
        widget.onEnter?.call();
      },
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: _hover ? const Color(0x14FFFFFF) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 140),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.selected ? IosColors.blue : Colors.transparent,
                  border: Border.all(
                    color: widget.selected
                        ? IosColors.blue
                        : IosColors.tertiaryLabel,
                    width: 1.5,
                  ),
                ),
                child: widget.selected
                    ? const Icon(Icons.check_rounded,
                        size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    letterSpacing: -0.2,
                    color: IosColors.label,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Decoración de campo de texto estilo iOS (relleno gris, sin borde).
InputDecoration iosInputDecoration({String? hint}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: IosColors.tertiaryLabel, fontSize: 14),
    filled: true,
    fillColor: IosColors.fill,
    isDense: true,
    counterStyle: const TextStyle(
      fontSize: 11,
      color: IosColors.secondaryLabel,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: IosColors.blue, width: 1.5),
    ),
  );
}

/// Botón de una alerta de iOS/macOS (texto centrado, la acción principal en negrita).
class IosDialogButton extends StatefulWidget {
  const IosDialogButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.bold = false,
    this.destructive = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool bold;
  final bool destructive;

  @override
  State<IosDialogButton> createState() => _IosDialogButtonState();
}

class _IosDialogButtonState extends State<IosDialogButton> {
  bool _hover = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final Color color = !enabled
        ? IosColors.tertiaryLabel
        : (widget.destructive ? IosColors.red : IosColors.blue);

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _pressed = false;
      }),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: 46,
          alignment: Alignment.center,
          color: _pressed && enabled
              ? const Color(0x24FFFFFF)
              : (_hover && enabled
                  ? const Color(0x0FFFFFFF)
                  : Colors.transparent),
          child: Text(
            widget.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: widget.bold ? FontWeight.w600 : FontWeight.w400,
              letterSpacing: -0.2,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

/// Cuerpo de una alerta de vidrio: título, contenido y fila de botones
/// separados por filos de 0.5 px.
class IosDialogShell extends StatelessWidget {
  const IosDialogShell({
    super.key,
    required this.title,
    required this.actions,
    this.message,
    this.content,
    this.width = 320,
    this.stacked = false,
  });

  final String title;
  final String? message;
  final Widget? content;
  final List<IosDialogButton> actions;
  final double width;

  /// Si es true, los botones se apilan en vertical (3 o más acciones / textos largos),
  /// como en las alertas de iOS.
  final bool stacked;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width),
      child: IosGlass(
        shadow: true,
        borderRadius: BorderRadius.circular(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                      color: IosColors.label,
                    ),
                  ),
                  if (message != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      message!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.3,
                        color: IosColors.secondaryLabel,
                      ),
                    ),
                  ],
                  if (content != null) ...[
                    const SizedBox(height: 14),
                    content!,
                  ],
                ],
              ),
            ),
            Container(height: 0.5, color: const Color(0x38FFFFFF)),
            if (stacked)
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (int i = 0; i < actions.length; i++) ...[
                    if (i > 0)
                      Container(height: 0.5, color: const Color(0x38FFFFFF)),
                    actions[i],
                  ],
                ],
              )
            else
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < actions.length; i++) ...[
                      if (i > 0)
                        Container(width: 0.5, color: const Color(0x38FFFFFF)),
                      Expanded(child: actions[i]),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Muestra una alerta de vidrio con la animación de iOS (fundido + escala suave).
Future<T?> showIosDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: 'dismiss',
    barrierColor: const Color(0x66000000),
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (ctx, _, __) => SafeArea(
      child: Center(
        child: Material(
          type: MaterialType.transparency,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: builder(ctx),
          ),
        ),
      ),
    ),
    transitionBuilder: (ctx, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeIn,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 1.08, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// Indicador de actividad pequeño (rueda de iOS) para botones y cabeceras.
class IosSpinner extends StatelessWidget {
  const IosSpinner({super.key, this.radius = 8});

  final double radius;

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(
      radius: radius,
      color: IosColors.secondaryLabel,
    );
  }
}


// ============================================================================
//  SEGMENTADO ADAPTABLE
// ============================================================================

/// Control segmentado que se adapta al ancho disponible, como haría Apple:
///  1. Si cabe, se muestra completo y centrado (con la píldora deslizante).
///  2. Si no cabe, reduce progresivamente la tipografía y el espaciado.
///  3. Si ni así cabe, se convierte en un selector desplegable (pop-up).
/// El ancho se calcula midiendo los textos reales, así que funciona con
/// cualquier idioma o número de categorías.
class IosAdaptiveSegmented<T extends Object> extends StatelessWidget {
  const IosAdaptiveSegmented({
    super.key,
    required this.value,
    required this.labels,
    required this.onChanged,
  });

  final T value;
  final Map<T, String> labels;
  final ValueChanged<T> onChanged;

  // (tamaño de letra, padding horizontal por segmento), de mayor a menor.
  static const List<(double, double)> _levels = [
    (12.5, 12),
    (12.5, 9),
    (12.0, 7),
    (11.5, 5),
    (11.0, 4),
  ];

  // Padding interno del CupertinoSlidingSegmentedControl (2 + 2) + holgura.
  static const double _controlChrome = 4 + 8;

  double _requiredWidth(BuildContext context, double fontSize, double hPad) {
    final base = DefaultTextStyle.of(context).style;
    final scaler = MediaQuery.textScalerOf(context);
    double widest = 0;
    for (final label in labels.values) {
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          // Se mide en negrita (el caso más ancho) para no desbordar al seleccionar.
          style: base.merge(
            TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.1,
            ),
          ),
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr,
        textScaler: scaler,
      )..layout();
      if (tp.width > widest) widest = tp.width;
    }
    // Todos los segmentos miden lo mismo: el ancho del más largo.
    final segment = widest.ceilToDouble() + hPad * 2 + 2;
    return segment * labels.length + _controlChrome;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double available = constraints.maxWidth;

        for (final (fontSize, hPad) in _levels) {
          if (_requiredWidth(context, fontSize, hPad) <= available) {
            return Center(
              child: IosSegmented<T>(
                value: value,
                onChanged: onChanged,
                segmentPadding: EdgeInsets.symmetric(
                  horizontal: hPad,
                  vertical: 6,
                ),
                children: {
                  for (final e in labels.entries)
                    e.key: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 180),
                      style: TextStyle(
                        fontSize: fontSize,
                        letterSpacing: -0.1,
                        fontWeight: e.key == value
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: e.key == value
                            ? IosColors.label
                            : IosColors.secondaryLabel,
                      ),
                      child: Text(
                        e.value,
                        maxLines: 1,
                        softWrap: false,
                        textAlign: TextAlign.center,
                      ),
                    ),
                },
              ),
            );
          }
        }

        // No cabe ni en el nivel más compacto: selector desplegable.
        return Center(
          child: _IosPopupSelector<T>(
            value: value,
            labels: labels,
            onChanged: onChanged,
            maxWidth: available,
          ),
        );
      },
    );
  }
}

/// Botón tipo "pop-up" de macOS: muestra la opción actual con un indicador de
/// menú (⌃⌄) y abre la lista de opciones justo debajo.
class _IosPopupSelector<T extends Object> extends StatefulWidget {
  const _IosPopupSelector({
    required this.value,
    required this.labels,
    required this.onChanged,
    required this.maxWidth,
  });

  final T value;
  final Map<T, String> labels;
  final ValueChanged<T> onChanged;
  final double maxWidth;

  @override
  State<_IosPopupSelector<T>> createState() => _IosPopupSelectorState<T>();
}

class _IosPopupSelectorState<T extends Object>
    extends State<_IosPopupSelector<T>> {
  bool _hover = false;
  bool _pressed = false;

  Future<void> _open(BuildContext context) async {
    final button = context.findRenderObject() as RenderBox;
    final overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final topLeft = button.localToGlobal(
      Offset(0, button.size.height + 4),
      ancestor: overlay,
    );
    final position = RelativeRect.fromLTRB(
      topLeft.dx,
      topLeft.dy,
      overlay.size.width - topLeft.dx - button.size.width,
      overlay.size.height - topLeft.dy,
    );

    final result = await showMenu<T>(
      context: context,
      position: position,
      constraints: BoxConstraints(minWidth: button.size.width.clamp(190, 400)),
      items: [
        for (final e in widget.labels.entries)
          iosMenuItem<T>(
            value: e.key,
            label: e.value,
            selected: e.key == widget.value,
          ),
      ],
    );
    if (result != null) widget.onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    final Color fill = _pressed
        ? const Color(0x66767680)
        : (_hover ? const Color(0x52767680) : IosColors.fill);

    return Builder(
      builder: (buttonContext) => MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() {
          _hover = false;
          _pressed = false;
        }),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: () => _open(buttonContext),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            constraints: BoxConstraints(
              minWidth: 150,
              maxWidth: widget.maxWidth,
            ),
            height: 34,
            padding: const EdgeInsets.only(left: 14, right: 8),
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    widget.labels[widget.value] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.1,
                      color: IosColors.label,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.unfold_more_rounded,
                  size: 17,
                  color: IosColors.secondaryLabel,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// ============================================================================
//  FORMULARIOS
// ============================================================================

/// Campo de formulario estilo iOS: etiqueta pequeña arriba, a la izquierda,
/// con un enlace opcional "Restablecer" a la derecha, y debajo el campo gris.
class IosFormField extends StatelessWidget {
  const IosFormField({
    super.key,
    required this.label,
    required this.controller,
    this.onChanged,
    this.onSubmitted,
    this.hint,
    this.autofocus = false,
    this.maxLength,
    this.maxLines = 1,
    this.resetLabel,
    this.onReset,
    this.canReset = true,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? hint;
  final bool autofocus;
  final int? maxLength;
  final int? maxLines;

  /// Si [onReset] no es null se muestra el enlace [resetLabel].
  final String? resetLabel;
  final VoidCallback? onReset;
  final bool canReset;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 26,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.1,
                      color: IosColors.secondaryLabel,
                    ),
                  ),
                ),
              ),
              if (onReset != null && resetLabel != null)
                IosTextButton(
                  label: resetLabel!,
                  fontSize: 12,
                  onPressed: canReset ? onReset : null,
                ),
            ],
          ),
        ),
        TextField(
          controller: controller,
          autofocus: autofocus,
          minLines: 1,
          maxLines: maxLines,
          maxLength: maxLength,
          cursorColor: IosColors.blue,
          style: const TextStyle(
            fontSize: 14,
            height: 1.35,
            letterSpacing: -0.15,
            color: IosColors.label,
          ),
          decoration: iosInputDecoration(hint: hint),
          onChanged: onChanged,
          onSubmitted: onSubmitted,
        ),
      ],
    );
  }
}