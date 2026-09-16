import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/mateo_rounded_shape_border/mateo_rounded_shape_border.dart';
import '../../theme/color_scheme/mateo_color_scheme.dart';
import '../../theme/mateo_theme.dart';

part '_mateo_toggle_painter.dart';
part 'mateo_toggle_controller.dart';

/// An on/off control for an immediately applied setting.
///
/// The controller is optional; without one, the toggle owns its state.
///
/// ```dart
/// MateoToggle(
///   semanticsLabel: 'Notifications',
///   onChanged: (value) => saveNotifications(value),
/// )
/// ```
class MateoToggle extends StatefulWidget {
  /// Creates an on/off control, initially off without a [controller].
  const MateoToggle({super.key, this.controller, this.onChanged, this.semanticsLabel});

  /// The optional state controller, owned and disposed by its caller.
  final MateoToggleController? controller;

  /// The action receiving a user-selected value.
  ///
  /// Null disables user interaction. Programmatic changes do not call this.
  /// Returning a future does not lock interaction or introduce loading.
  // Matches Flutter's positional value-change callbacks.
  // ignore: avoid_positional_boolean_parameters
  final FutureOr<void> Function(bool value)? onChanged;

  /// The accessible name describing the setting this control changes.
  final String? semanticsLabel;

  @override
  State<MateoToggle> createState() => _MateoToggleState();
}

class _MateoToggleState extends State<MateoToggle>
    with SingleTickerProviderStateMixin
    implements _MateoToggleControllerClient {
  static const _spring = SpringDescription(mass: 1, stiffness: 900, damping: 36);
  late MateoToggleController _controller;
  late final AnimationController _position;
  late bool _ownsController;
  FlutterError? _attachmentError;
  Completer<void>? _completion;
  bool _animates = false;
  bool _dragging = false;
  int? _pointer;

  bool get _enabled => widget.onChanged != null;
  double get _direction => Directionality.of(context) == TextDirection.ltr ? 1 : -1;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? MateoToggleController();
    _ownsController = widget.controller == null;
    _attachmentError = _controller._attach(this);
    _position = AnimationController.unbounded(vsync: this, value: _controller.value ? 1 : 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animates = !MediaQuery.disableAnimationsOf(context) && TickerMode.valuesOf(context).enabled;
    if (!_animates) _settle();
  }

  @override
  void didUpdateWidget(MateoToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(widget.controller, oldWidget.controller)) {
      final previousValue = _controller.value;
      _controller._detach(this);
      if (_ownsController) _controller.dispose();
      _controller = widget.controller ?? MateoToggleController(value: previousValue);
      _ownsController = widget.controller == null;
      _attachmentError = _controller._attach(this);
      _settle();
    }
    if (!_enabled && oldWidget.onChanged != null) _settle();
  }

  void _interrupt() {
    _position.stop();
    _completion?.complete();
    _completion = null;
  }

  void _settle() {
    _dragging = false;
    _interrupt();
    _position.value = _controller.value ? 1 : 0;
  }

  Future<void> _animate({double? velocity}) {
    final initialVelocity = velocity ?? _position.velocity;
    _interrupt();
    final destination = _controller.value ? 1.0 : 0.0;
    if (!_animates || ((_position.value - destination).abs() < 0.001 && initialVelocity.abs() < 0.001)) {
      _position.value = destination;
      return Future<void>.value();
    }
    final completion = Completer<void>();
    _completion = completion;
    _position
        .animateWith(
          SpringSimulation(
            _spring,
            _position.value,
            destination,
            initialVelocity,
            tolerance: const Tolerance(distance: 0.001, velocity: 0.01),
            snapToEnd: true,
          ),
        )
        .whenCompleteOrCancel(() {
          if (!identical(_completion, completion)) return;
          _completion = null;
          completion.complete();
        });
    return completion.future;
  }

  @override
  Future<void> setToggleValue(bool value, {double? velocity}) {
    _dragging = false;
    final animation = _animate(velocity: velocity);
    setState(() {});
    return animation;
  }

  void _change(bool value, {double? velocity}) {
    if (!_enabled || value == _controller.value) return;
    unawaited(_controller._setValue(value, velocity: velocity));
    unawaited(HapticFeedback.lightImpact());
    final result = widget.onChanged?.call(value);
    if (result is Future<void>) unawaited(result);
  }

  void _activate() => _change(!_controller.value);

  void _dragStart(DragStartDetails details) {
    _interrupt();
    _dragging = true;
  }

  void _dragUpdate(DragUpdateDetails details) {
    if (!_dragging || !_enabled) return;
    // A grabbed rebound must not jump to an endpoint on the first update.
    final lowerBound = _position.value < 0 ? _position.value : 0.0;
    final upperBound = _position.value > 1 ? _position.value : 1.0;
    _position.value = (_position.value + _direction * (details.primaryDelta ?? 0) / _MateoTogglePainter.travel).clamp(
      lowerBound,
      upperBound,
    );
  }

  void _dragEnd(DragEndDetails details) {
    if (!_dragging || !_enabled) return;
    _dragging = false;
    final velocity = _direction * details.velocity.pixelsPerSecond.dx / _MateoTogglePainter.travel;
    final target = velocity.abs() >= 5 ? velocity > 0 : _position.value >= 0.5;
    // Start the controller transition with the release velocity, without a
    // second transition or a second completion future.
    final releaseVelocity = velocity.clamp(-20.0, 20.0);
    if (target != _controller.value) {
      _change(target, velocity: releaseVelocity);
    } else {
      unawaited(_animate(velocity: releaseVelocity));
    }
  }

  void _dragCancel() {
    if (!_dragging) return;
    _dragging = false;
    unawaited(_animate(velocity: 0));
  }

  @override
  void dispose() {
    _interrupt();
    _controller._detach(this);
    if (_ownsController) _controller.dispose();
    _position.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_attachmentError case final error?) throw error;
    final colors = MateoTheme.of(context).colorScheme.toggle;
    return Semantics(
      label: widget.semanticsLabel,
      toggled: _controller.value,
      enabled: _enabled,
      onTap: _enabled ? _activate : null,
      child: Listener(
        onPointerDown: (event) => _pointer ??= event.pointer,
        onPointerUp: (event) {
          if (_pointer == event.pointer) _pointer = null;
        },
        onPointerCancel: (event) {
          if (_pointer != event.pointer) return;
          _pointer = null;
          _dragCancel();
        },
        child: GestureDetector(
          behavior: .opaque,
          excludeFromSemantics: true,
          onTap: _enabled ? _activate : null,
          onHorizontalDragStart: _enabled ? _dragStart : null,
          onHorizontalDragUpdate: _enabled ? _dragUpdate : null,
          onHorizontalDragEnd: _enabled ? _dragEnd : null,
          onHorizontalDragCancel: _enabled ? _dragCancel : null,
          child: RepaintBoundary(
            child: CustomPaint(
              size: const Size(78, 48),
              painter: _MateoTogglePainter(
                position: _position,
                colors: colors,
                enabled: _enabled,
                direction: _direction,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
