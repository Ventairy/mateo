import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'mateo_drag_resistance_config.dart';

part '_mateo_drag_resistance_return_curve.dart';
part '_mateo_drag_resistance_transform.dart';
part '_render_mateo_drag_resistance_transform.dart';

/// A visual boundary that yields slightly with a drag and settles on release.
///
/// Enable only directions without an active scroll, dismiss, or other action.
/// This wrapper observes pointers without claiming the child's gestures. Use
/// [MateoDragResistance.driven] when another component owns the drag boundary.
///
/// ```dart
/// MateoDragResistance(
///   resistance: .symmetric(horizontal: 6),
///   child: child,
/// )
/// ```
///
/// See [Drag resistance](https://github.com/Ventairy/mateo/blob/main/design-system/mobile/drag-resistance.md).
class MateoDragResistance extends StatefulWidget {
  /// Creates a boundary that observes pointer movement around [child].
  const MateoDragResistance({required this.child, this.resistance = const .all(6), super.key})
    : dragOffset = null,
      _driven = false;

  /// Creates a boundary controlled by an existing drag interaction.
  ///
  /// Supply total unresisted travel through [dragOffset], and null on release
  /// or cancellation. No pointer listener is installed by this constructor.
  /// An overdrag callback that reports zero on release also needs gesture-end
  /// tracking: zero means active movement at the boundary, not release.
  ///
  /// ```dart
  /// MateoDragResistance.driven(
  ///   resistance: .only(top: 6, left: 6, right: 6),
  ///   dragOffset: overdrag,
  ///   child: child,
  /// )
  /// ```
  const MateoDragResistance.driven({
    required this.child,
    required this.dragOffset,
    this.resistance = const .all(6),
    super.key,
  }) : _driven = true;

  /// The content translated without changing its layout.
  final Widget child;

  /// The maximum movement allowed in each physical direction.
  final MateoDragResistanceConfig resistance;

  /// The total unresisted drag distance in logical pixels, or null to settle.
  ///
  /// Used only by [MateoDragResistance.driven]. Components must be finite.
  /// Zero restores the boundary immediately while dragging. Non-null input is
  /// authoritative and interrupts any return animation. Report only movement
  /// beyond the boundary, after the owning action has returned to rest.
  final Offset? dragOffset;

  final bool _driven;

  @override
  State<MateoDragResistance> createState() => _MateoDragResistanceState();
}

class _MateoDragResistanceState extends State<MateoDragResistance> with SingleTickerProviderStateMixin {
  static const _dampingDistance = 96.0;
  static const _returnDuration = Duration(milliseconds: 180);
  static const _returnCurve = _MateoDragResistanceReturnCurve();
  final _translation = ValueNotifier<Offset>(.zero);
  AnimationController? _returnController;
  Offset _returnStart = .zero;
  Offset _dragDistance = .zero;
  int? _pointer;
  bool _reducedMotion = false;

  bool get _enabled => !_reducedMotion && widget.resistance != MateoDragResistanceConfig.zero;

  double _resolveAxis(double distance, double negative, double positive) {
    final maximum = distance < 0 ? negative : positive;
    if (distance == 0 || maximum == 0) return 0;
    return distance.sign * maximum * (1 - 1 / (1 + distance.abs() / _dampingDistance));
  }

  Offset _resolve(Offset distance) => Offset(
    _resolveAxis(distance.dx, widget.resistance.left, widget.resistance.right),
    _resolveAxis(distance.dy, widget.resistance.top, widget.resistance.bottom),
  );

  double _restoreAxisDistance(double offset, double negative, double positive) {
    final maximum = offset < 0 ? negative : positive;
    if (offset == 0 || maximum == 0) return 0;
    final fraction = (offset.abs() / maximum).clamp(0.0, 1 - 1e-15);
    return offset.sign * _dampingDistance * fraction / (1 - fraction);
  }

  void _clear() {
    _returnController?.stop();
    _pointer = null;
    _dragDistance = .zero;
    _translation.value = .zero;
  }

  void _updateDrag(Offset distance) {
    _returnController?.stop();
    _dragDistance = distance;
    _translation.value = _enabled ? _resolve(distance) : .zero;
  }

  void _settle() {
    _dragDistance = .zero;
    if (!_enabled) {
      _clear();
      return;
    }
    if (_translation.value == Offset.zero) return;
    _returnStart = _translation.value;
    (_returnController ??= AnimationController(
      vsync: this,
      duration: _returnDuration,
    )..addListener(_animateReturn)).forward(from: 0);
  }

  void _animateReturn() {
    _translation.value = _returnStart * (1 - _returnCurve.transform(_returnController!.value));
  }

  void _pointerDown(PointerDownEvent event) {
    if (!_enabled || _pointer != null) return;
    _pointer = event.pointer;
    _returnController?.stop();
    // Continue from the grabbed position instead of discarding a partial return.
    _dragDistance = Offset(
      _restoreAxisDistance(_translation.value.dx, widget.resistance.left, widget.resistance.right),
      _restoreAxisDistance(_translation.value.dy, widget.resistance.top, widget.resistance.bottom),
    );
  }

  void _pointerMove(PointerMoveEvent event) {
    if (_pointer != event.pointer) return;
    _updateDrag(_dragDistance + event.delta);
  }

  void _pointerEnd(PointerEvent event) {
    if (_pointer != event.pointer) return;
    _pointer = null;
    _settle();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    if (reducedMotion == _reducedMotion) return;
    _reducedMotion = reducedMotion;
    if (_reducedMotion) {
      _clear();
    } else if (widget._driven && widget.dragOffset != null) {
      _updateDrag(widget.dragOffset!);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget._driven && widget.dragOffset != null) _updateDrag(widget.dragOffset!);
  }

  @override
  void didUpdateWidget(covariant MateoDragResistance oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget._driven != widget._driven) _clear();
    if (!_enabled) {
      _clear();
      return;
    }
    if (widget._driven && widget.dragOffset != null) {
      _updateDrag(widget.dragOffset!);
      return;
    }
    if (widget._driven && oldWidget.dragOffset != null) {
      _settle();
    }
    if (oldWidget.resistance == widget.resistance) return;
    if (_pointer != null) {
      _updateDrag(_dragDistance);
      return;
    }
    final offset = _translation.value;
    _translation.value = Offset(
      offset.dx.clamp(-widget.resistance.left, widget.resistance.right),
      offset.dy.clamp(-widget.resistance.top, widget.resistance.bottom),
    );
    // Restart only when new limits truncate the current return.
    if (offset != _translation.value) {
      _returnController?.stop();
      _settle();
    }
  }

  @override
  void dispose() {
    _returnController?.dispose();
    _translation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.dragOffset?.isFinite ?? true, 'dragOffset components must be finite.');
    return _MateoDragResistanceTransform(
      translation: _translation,
      child: RepaintBoundary(
        child: widget._driven
            ? widget.child
            : Listener(
                behavior: .translucent,
                onPointerDown: _enabled ? _pointerDown : null,
                onPointerMove: _enabled ? _pointerMove : null,
                onPointerUp: _enabled ? _pointerEnd : null,
                onPointerCancel: _enabled ? _pointerEnd : null,
                child: widget.child,
              ),
      ),
    );
  }
}
