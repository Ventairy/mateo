library;

import 'dart:async';

import 'package:flutter/foundation.dart' show ChangeNotifier, FlutterError, ValueListenable;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mateo_mobile_old/src/theme/mateo_color_scheme/mateo_color_scheme.dart';
import 'package:mateo_mobile_old/src/theme/mateo_theme_context.dart';

part '_mateo_toggle_painter.dart';
part 'mateo_toggle_controller.dart';
part 'mateo_toggle_types.dart';

/// A Mateo on-and-off toggle for mobile interfaces.
///
/// [MateoToggle] displays a compact pill with a movable circle. Tapping or
/// horizontally dragging the control changes its state and reports the new
/// value through [onChanged]. The callback receives the same animation future
/// returned by the controller operation and may await the circle settling.
/// Supply a [controller] to observe or change the state from parent code;
/// otherwise the toggle retains its own state, initially off.
///
/// When [onChanged] is null, the toggle is disabled and uses its disabled
/// colors. The visual toggle is `58 × 30` logical pixels inside a `58 × 48`
/// press and accessibility target. Motion is removed when
/// [MediaQuery.disableAnimationsOf] is enabled.
///
/// ```dart
/// MateoToggle(
///   semanticsLabel: 'Notifications',
///   onChanged: (value, animation) async {
///     await animation;
///     // Continue after the toggle has visually settled.
///   },
/// )
/// ```
///
/// See also:
///  * [MateoToggleController], which adds observation and programmatic control
///    when local ownership is not enough.
class MateoToggle extends StatefulWidget {
  /// Creates a Mateo toggle.
  ///
  /// When [controller] is null, the toggle owns an internal controller that
  /// starts off. [onChanged] receives the new value and its visual animation
  /// after an enabled tap or completed drag. When [colorScheme] is null,
  /// colors resolve from `context.mateo.colorScheme.toggle`.
  const MateoToggle({
    super.key,
    this.controller,
    this.onChanged,
    this.colorScheme,
    this.semanticsLabel,
  });

  /// Optional controller for reading and changing the toggle state.
  ///
  /// The caller owns a supplied controller and must dispose it after this
  /// toggle has been removed. When null, the toggle owns its controller.
  final MateoToggleController? controller;

  /// Callback that receives the requested value and visible transition.
  ///
  /// The `animation` future completes when the toggle settles after the
  /// request. Programmatic controller changes do not call this callback.
  ///
  /// When null, the toggle is disabled and ignores pointer and accessibility
  /// activation.
  final MateoToggleChanged? onChanged;

  /// Complete color scheme used by this toggle.
  ///
  /// When null, the scheme resolves from `context.mateo.colorScheme.toggle`.
  final MateoToggleColorScheme? colorScheme;

  /// Optional accessible name that identifies what the toggle controls.
  final String? semanticsLabel;

  @override
  State<MateoToggle> createState() => _MateoToggleState();
}

class _MateoToggleState extends State<MateoToggle>
    with TickerProviderStateMixin, ToggleableStateMixin
    implements _MateoToggleControllerClient {
  static const Size _targetSize = Size(58, 48);
  static const double _circleTravel = 28;
  static const Duration _toggleDuration = Duration(milliseconds: 400);

  late MateoToggleController _controller;
  late bool _ownsController;
  late final AnimationController _visualPositionController;

  Completer<void>? _animationCompleter;
  FlutterError? _attachmentError;
  int _animationGeneration = 0;
  bool? _animationsDisabled;
  bool _isDragging = false;

  @override
  ValueChanged<bool?>? get onChanged => widget.onChanged == null ? null : _handleChanged;

  @override
  bool get tristate => false;

  @override
  bool? get value => _controller.value;

  @override
  void initState() {
    _controller = widget.controller ?? MateoToggleController();
    _ownsController = widget.controller == null;
    super.initState();
    _attachmentError = _controller._attach(this);
    _visualPositionController = AnimationController(
      duration: _toggleDuration,
      value: _controller.value ? 1 : 0,
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final animationsDisabled = MediaQuery.disableAnimationsOf(context);
    if (_animationsDisabled == animationsDisabled) return;

    _animationsDisabled = animationsDisabled;
    if (animationsDisabled) {
      _settleImmediately();
    }
  }

  @override
  void didUpdateWidget(covariant MateoToggle oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!identical(widget.controller, oldWidget.controller)) {
      final previousValue = _controller.value;
      _completePendingAnimation();
      _controller._detach(this);
      if (_ownsController) _controller.dispose();

      _controller = widget.controller ?? MateoToggleController(value: previousValue);
      _ownsController = widget.controller == null;
      _attachmentError = _controller._attach(this);
      _settleImmediately();
    }

    if (widget.onChanged == null && oldWidget.onChanged != null) {
      _settleImmediately();
    }
  }

  @override
  void dispose() {
    _completePendingAnimation();
    _controller._detach(this);
    if (_ownsController) _controller.dispose();
    _visualPositionController.dispose();
    super.dispose();
  }

  void _handleChanged(bool? requestedValue) {
    if (requestedValue == null || requestedValue == _controller.value) return;

    final animation = _controller.setValue(requestedValue);
    unawaited(HapticFeedback.lightImpact());
    final result = widget.onChanged?.call(requestedValue, animation);
    if (result is Future<void>) unawaited(result);
  }

  void _handleDragStart(DragStartDetails details) {
    if (!isInteractive) return;

    _isDragging = true;
    _visualPositionController.stop();
    _completePendingAnimation();
    reactionController.forward();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!isInteractive) return;

    final direction = switch (Directionality.of(context)) {
      TextDirection.ltr => 1.0,
      TextDirection.rtl => -1.0,
    };
    _visualPositionController.value += direction * (details.primaryDelta ?? 0) / _circleTravel;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!isInteractive) return;

    _isDragging = false;
    reactionController.reverse();
    final requestedValue = _visualPositionController.value >= 0.5;
    if (requestedValue != _controller.value) {
      _handleChanged(requestedValue);
      return;
    }

    _animateTo(_controller.value);
  }

  void _handleDragCancel() {
    if (!isInteractive || !_isDragging) return;

    _isDragging = false;
    reactionController.reverse();
    _animateTo(_controller.value);
  }

  @override
  Future<void> setToggleValue(bool value) {
    final animationCompleter = Completer<void>();
    _animateTo(value, completion: animationCompleter);
    if (mounted) setState(() {});
    return animationCompleter.future;
  }

  void _animateTo(bool target, {Completer<void>? completion}) {
    if (completion != null) {
      _completePendingAnimation();
      _animationCompleter = completion;
    }
    final animationCompleter = _animationCompleter;
    final animationGeneration = ++_animationGeneration;
    final destination = target ? 1.0 : 0.0;
    if (_animationsDisabled ?? true) {
      _setPosition(destination);
      _completePendingAnimation();
      return;
    }

    final distance = (destination - _visualPositionController.value).abs();
    if (distance == 0) {
      _setPosition(destination);
      _completePendingAnimation();
      return;
    }

    final duration = _toggleDuration * distance;
    _visualPositionController
        .animateTo(
          destination,
          duration: duration,
          curve: Curves.easeOutQuint,
        )
        .whenCompleteOrCancel(() {
          if (_animationGeneration == animationGeneration && identical(_animationCompleter, animationCompleter)) {
            _completePendingAnimation();
          }
        });
  }

  void _settleImmediately() {
    _setPosition(_controller.value ? 1 : 0);
    _completePendingAnimation();
    reactionController
      ..stop()
      ..value = 0;
  }

  void _setPosition(double value) {
    _visualPositionController
      ..stop()
      ..value = value;
  }

  void _completePendingAnimation() {
    final completer = _animationCompleter;
    _animationCompleter = null;
    if (completer != null && !completer.isCompleted) completer.complete();
  }

  @override
  Widget build(BuildContext context) {
    final attachmentError = _attachmentError;
    if (attachmentError != null) throw attachmentError;

    final colorScheme = widget.colorScheme ?? context.mateo.colorScheme.toggle;
    final animationsDisabled = _animationsDisabled ?? true;

    return Semantics(
      label: widget.semanticsLabel,
      toggled: _controller.value,
      child: GestureDetector(
        excludeFromSemantics: true,
        behavior: HitTestBehavior.opaque,
        onHorizontalDragStart: isInteractive ? _handleDragStart : null,
        onHorizontalDragUpdate: isInteractive ? _handleDragUpdate : null,
        onHorizontalDragEnd: isInteractive ? _handleDragEnd : null,
        onHorizontalDragCancel: isInteractive ? _handleDragCancel : null,
        child: RepaintBoundary(
          child: buildToggleable(
            size: _targetSize,
            painter: _MateoTogglePainter(
              position: _visualPositionController,
              press: reactionController,
              colorScheme: colorScheme,
              enabled: isInteractive,
              animationsDisabled: animationsDisabled,
              textDirection: Directionality.of(context),
            ),
          ),
        ),
      ),
    );
  }
}
