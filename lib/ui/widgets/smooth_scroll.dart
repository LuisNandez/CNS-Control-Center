import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// ============================================================================
//  SCROLL SUAVE CON LA RUEDA DEL RATÓN
// ============================================================================
//
// En escritorio cada "muesca" de la rueda mueve la vista de golpe (~100 px de
// un salto), y eso se ve a tirones. Aquí cada muesca solo MUEVE EL DESTINO, y
// la vista lo persigue con un muelle críticamente amortiguado (sin rebote):
//
//  * Arranque suave y frenado largo, como en macOS.
//  * Varias muescas seguidas se acumulan en un único movimiento continuo; la
//    velocidad nunca se corta ni se reinicia entre muescas (antes cada muesca
//    relanzaba una animación desde cero y eso se notaba como tirón).
//  * Si el usuario cambia de sentido, el movimiento gira sin saltos.
//
// Hay tres formas de usarlo:
//  * [IosSmoothScrollController]: para scroll views que crean su propio
//    controlador (la cuadrícula y la lista de mods).
//  * [IosSmoothWheel]: para scroll views cuyo controlador viene dado por otro
//    widget y no se puede cambiar (el DraggableScrollableSheet del panel).
//  * [IosSmoothScrollbarGuard]: complemento del anterior para que la rueda
//    también sea suave con el puntero encima de la barra de scroll.
//
// El touchpad y el arrastre no se tocan: siguen funcionando como siempre.

/// Convierte los saltos de la rueda en un desplazamiento suave por muelle.
class IosWheelSmoother {
  /// Rigidez del muelle (rad/s). Más alto = más rápido y "seco"; más bajo =
  /// más flotante. 15 se asienta en ~0,3 s.
  static const double _omega = 15.0;

  ScrollPosition? _position;
  double _target = 0;
  double _velocity = 0;
  double _lastSet = 0;
  Duration? _lastTick;
  bool _running = false;
  int _generation = 0;

  /// Desplaza [position] [delta] píxeles más allá del destino actual.
  void scrollBy(ScrollPosition position, double delta) {
    if (delta == 0 || !position.hasPixels || !position.hasContentDimensions) {
      return;
    }

    final double pixels = position.pixels;
    // ¿Seguimos con el mismo movimiento? No si alguien más movió la vista
    // (arrastre de la barra, teclado...) o si es otra posición.
    final bool continuing =
        _running &&
        identical(_position, position) &&
        (pixels - _lastSet).abs() <= 1.0;

    // Si es un movimiento nuevo, o el usuario cambió de sentido, se parte de
    // la posición actual y sin inercia.
    if (!continuing || (_target - pixels) * delta < 0) {
      _target = pixels;
      _velocity = 0;
    }

    _position = position;
    _lastSet = pixels;
    _target = (_target + delta)
        .clamp(position.minScrollExtent, position.maxScrollExtent)
        .toDouble();

    if (!_running) _start();
  }

  /// Detiene cualquier movimiento en curso (al destruir el scroll view).
  void cancel() {
    _running = false;
    _position = null;
    _velocity = 0;
    _lastTick = null;
    _generation++;
  }

  void _start() {
    _running = true;
    _lastTick = null;
    final int generation = ++_generation;
    SchedulerBinding.instance.scheduleFrameCallback(
      (Duration timeStamp) => _tick(timeStamp, generation),
    );
  }

  void _tick(Duration timeStamp, int generation) {
    if (generation != _generation || !_running) return;

    final ScrollPosition? position = _position;
    if (position == null || !position.hasPixels || !position.hasContentDimensions) {
      cancel();
      return;
    }

    final Duration? last = _lastTick;
    _lastTick = timeStamp;
    final double dt = last == null
        ? 1 / 60
        : ((timeStamp - last).inMicroseconds / 1e6).clamp(0.001, 0.05).toDouble();

    final double current = position.pixels;
    // Alguien más movió la vista entre fotogramas: se cede el control.
    if ((current - _lastSet).abs() > 1.0) {
      cancel();
      return;
    }

    final double min = position.minScrollExtent;
    final double max = position.maxScrollExtent;
    _target = _target.clamp(min, max).toDouble();

    // Muelle críticamente amortiguado, solución exacta para este paso (así el
    // resultado no depende de la tasa de refresco: 60, 120, 144 Hz...).
    final double e0 = current - _target;
    final double decay = math.exp(-_omega * dt);
    final double k = _velocity + _omega * e0;
    double next = _target + (e0 + k * dt) * decay;
    _velocity = (_velocity - _omega * k * dt) * decay;

    final bool done = (next - _target).abs() < 0.25 && _velocity.abs() < 10;
    if (done) {
      next = _target;
    } else if (next < min || next > max) {
      next = next.clamp(min, max).toDouble();
      _velocity = 0;
    }

    if (next != current) position.jumpTo(next);
    _lastSet = position.pixels;

    if (done) {
      cancel();
      return;
    }
    SchedulerBinding.instance.scheduleFrameCallback(
      (Duration t) => _tick(t, generation),
    );
  }
}

/// Controlador cuya posición suaviza el desplazamiento de la rueda del ratón.
///
/// Se usa igual que un [ScrollController] normal:
/// `ListView(controller: IosSmoothScrollController(), ...)`.
class IosSmoothScrollController extends ScrollController {
  IosSmoothScrollController({
    super.initialScrollOffset,
    super.keepScrollOffset,
    super.debugLabel,
  });

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return _IosSmoothScrollPosition(
      physics: physics,
      context: context,
      initialPixels: initialScrollOffset,
      keepScrollOffset: keepScrollOffset,
      oldPosition: oldPosition,
      debugLabel: debugLabel,
    );
  }
}

class _IosSmoothScrollPosition extends ScrollPositionWithSingleContext {
  _IosSmoothScrollPosition({
    required super.physics,
    required super.context,
    super.initialPixels,
    super.keepScrollOffset,
    super.oldPosition,
    super.debugLabel,
  });

  final IosWheelSmoother _smoother = IosWheelSmoother();

  /// El framework llama aquí por cada evento de la rueda del ratón (también
  /// cuando el puntero está sobre la barra de scroll).
  @override
  void pointerScroll(double delta) {
    if (delta == 0.0) {
      goBallistic(0.0);
      return;
    }
    _smoother.scrollBy(this, delta);
  }

  @override
  void dispose() {
    _smoother.cancel();
    super.dispose();
  }
}

/// Atiende un evento de la rueda sobre un scroll vertical gobernado por
/// [controller]. Devuelve sin hacer nada si no le corresponde (gesto
/// horizontal, nada que desplazar...), para dejar pasar el evento.
void _handleWheelSignal(
  PointerSignalEvent event,
  ScrollController controller,
  IosWheelSmoother smoother,
) {
  if (event is! PointerScrollEvent) return;

  if (controller.positions.length != 1) return;
  final ScrollPosition position = controller.positions.first;
  if (position.axis != Axis.vertical) return;

  final double dy = event.scrollDelta.dy;
  // Gestos horizontales: los gestiona el propio scroll view.
  if (dy == 0 || event.scrollDelta.dx.abs() > dy.abs()) return;

  // Nada que desplazar en esa dirección: se deja pasar la rueda.
  if (position.maxScrollExtent <= position.minScrollExtent) return;
  if ((dy > 0 && position.pixels >= position.maxScrollExtent) ||
      (dy < 0 && position.pixels <= position.minScrollExtent)) {
    return;
  }

  // Solo el primero que se registra se queda con el evento.
  GestureBinding.instance.pointerSignalResolver.register(event, (
    PointerSignalEvent e,
  ) {
    if (e is PointerScrollEvent) {
      smoother.scrollBy(position, e.scrollDelta.dy);
    }
  });
}

/// Suaviza la rueda del ratón en un scroll vertical cuyo controlador no se
/// puede sustituir (p. ej. el que entrega `DraggableScrollableSheet`).
///
/// Debe colocarse DENTRO del scroll view (envolviendo su contenido), no fuera:
/// así recibe la rueda antes que el scroll view y, a la vez, cualquier widget
/// anidado que quiera la rueda (como el carrusel horizontal de trajes) sigue
/// teniendo prioridad sobre él.
///
/// Con el puntero encima de la barra de scroll este widget no recibe nada (la
/// barra tapa al contenido): para eso está [IosSmoothScrollbarGuard].
class IosSmoothWheel extends StatefulWidget {
  const IosSmoothWheel({
    super.key,
    required this.controller,
    required this.child,
    this.smoother,
  });

  final ScrollController controller;
  final Widget child;

  /// Suavizador compartido con un [IosSmoothScrollbarGuard]. Si es null se crea
  /// uno propio.
  final IosWheelSmoother? smoother;

  @override
  State<IosSmoothWheel> createState() => _IosSmoothWheelState();
}

class _IosSmoothWheelState extends State<IosSmoothWheel> {
  late final IosWheelSmoother _smoother = widget.smoother ?? IosWheelSmoother();

  @override
  void dispose() {
    // Si el suavizador es de otro widget, lo cancela su dueño.
    if (widget.smoother == null) _smoother.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerSignal: (PointerSignalEvent event) =>
          _handleWheelSignal(event, widget.controller, _smoother),
      child: widget.child,
    );
  }
}

/// Hace que la rueda también sea suave con el puntero encima de la barra de
/// scroll.
///
/// La barra de scroll de escritorio atiende la rueda por su cuenta y mueve la
/// vista de golpe (sin pasar por [IosSmoothWheel]). Este widget coloca, POR
/// ENCIMA del scroll view, una franja invisible en cada borde: al estar encima
/// recibe la rueda antes que la barra y la suaviza. La franja es translúcida
/// para los toques, así que arrastrar la barra o hacer clic en ella sigue
/// funcionando igual.
///
/// Envuelve al scroll view (con su barra) y comparte el mismo [smoother] que el
/// [IosSmoothWheel] de su contenido.
class IosSmoothScrollbarGuard extends StatelessWidget {
  const IosSmoothScrollbarGuard({
    super.key,
    required this.controller,
    required this.smoother,
    required this.child,
    this.edgeWidth = 24,
  });

  final ScrollController controller;
  final IosWheelSmoother smoother;
  final Widget child;

  /// Ancho de cada franja (debe cubrir el grosor de la barra de scroll).
  final double edgeWidth;

  Widget _strip() {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerSignal: (PointerSignalEvent event) =>
          _handleWheelSignal(event, controller, smoother),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        // Se cubren los dos bordes: la barra queda a un lado u otro según la
        // dirección del texto.
        Positioned(left: 0, top: 0, bottom: 0, width: edgeWidth, child: _strip()),
        Positioned(right: 0, top: 0, bottom: 0, width: edgeWidth, child: _strip()),
      ],
    );
  }
}