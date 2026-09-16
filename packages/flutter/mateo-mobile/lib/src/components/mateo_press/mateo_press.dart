import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'mateo_press_animation_type.dart';

part '_mateo_press_fade.dart';
part '_mateo_press_feedback.dart';
part '_mateo_press_scale.dart';
part '_render_mateo_press_fade.dart';
part '_render_mateo_press_scale.dart';

/// A press target that adds tactile feedback to its content.
///
/// Use this when composing a custom action. The child supplies its appearance;
/// this control supplies pointer feedback and button semantics.
///
/// ```dart
/// MateoPress(
///   onPressed: (animation) async {
///     await animation;
///     // Open the destination after feedback settles.
///   },
///   child: const Padding(
///     padding: EdgeInsets.all(16),
///     child: Text('Open'),
///   ),
/// )
/// ```
///
/// See also:
///  * [MateoPressAnimationType], the available feedback styles.
///  * [Press areas](https://github.com/Ventairy/mateo/blob/main/design-system/foundation/press-area.md),
///    the guidance for assigning spacing to actions.
class MateoPress extends StatefulWidget {
  /// Creates a press target around [child].
  const MateoPress({
    required this.child,
    this.onPressed,
    this.onPressChanged,
    this.semanticLabel,
    this.animation = .scale,
    this.fireHapticFeedback = true,
    super.key,
  });

  /// The content and inner spacing belonging to this action.
  final Widget child;

  /// The action invoked on a successful press, or null to disable this control.
  ///
  /// The callback runs immediately and may return synchronously or asynchronously.
  /// Its animation argument completes when release feedback finishes or is interrupted,
  /// including when this control is removed. Await it to sequence navigation
  /// after feedback; check the caller's mounted state before using its context.
  ///
  /// With no animation, reduced motion, or screen-reader activation, the
  /// argument is an already completed future.
  /// Disabling new presses after activation lets the accepted tap finish its
  /// feedback. Disabling while held cancels the press without activation.
  final FutureOr<void> Function(Future<void> animation)? onPressed;

  /// Reports changes to whether a pointer is pressing this control.
  ///
  /// Release, cancellation, and disabling end the press. Disabling reports the
  /// change after the current frame. Removal does not invoke this callback;
  /// callers owning resources such as hold timers must dispose them themselves.
  final ValueChanged<bool>? onPressChanged;

  /// The accessibility label replacing descendant semantics when supplied.
  ///
  /// When null, the child's semantics supply the label.
  final String? semanticLabel;

  /// The visual feedback applied while pressed.
  final MateoPressAnimationType animation;

  /// Whether pointer press-down produces light-impact haptic feedback.
  final bool fireHapticFeedback;

  /// Creates the state coordinating press feedback.
  @override
  State<MateoPress> createState() => _MateoPressState();
}

class _MateoPressState extends State<MateoPress> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _pressed = false;
  bool _resetAfterDeactivate = false;
  bool _releaseRequested = false;
  bool _disableAnimations = false;
  bool _tickerEnabled = true;
  ValueChanged<bool>? _pressChanged;
  Completer<void>? _release;

  bool get _enabled => widget.onPressed != null;
  bool get _animates => widget.animation != .none && !_disableAnimations && _tickerEnabled;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animation.pressDuration,
      reverseDuration: widget.animation.releaseDuration,
      vsync: this,
    )..addStatusListener(_animationStatusChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final disableAnimations = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final tickerEnabled = TickerMode.valuesOf(context).enabled;
    if (_resetAfterDeactivate || disableAnimations != _disableAnimations || tickerEnabled != _tickerEnabled) {
      _resetAfterDeactivate = false;
      _disableAnimations = disableAnimations;
      _tickerEnabled = tickerEnabled;
      _resetFeedback();
      if (!tickerEnabled) _endPress(afterFrame: true);
    }
  }

  @override
  void didUpdateWidget(covariant MateoPress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((!_enabled && _release == null) || widget.animation != oldWidget.animation) _resetFeedback();
    if (widget.animation != oldWidget.animation) {
      _controller.duration = widget.animation.pressDuration;
      _controller.reverseDuration = widget.animation.releaseDuration;
    }
    if (!_enabled) _endPress(afterFrame: true);
  }

  void _completeRelease() {
    final release = _release;
    _release = null;
    release?.complete();
  }

  void _resetFeedback() {
    _releaseRequested = false;
    _completeRelease();
    _controller.reset();
  }

  void _animationStatusChanged(AnimationStatus status) {
    if (status == .completed && _releaseRequested) {
      _releaseRequested = false;
      _controller.reverse();
    } else if (status == .dismissed) {
      _completeRelease();
    }
  }

  void _endPress({bool afterFrame = false}) {
    if (!_pressed) return;
    _pressed = false;
    final changed = _pressChanged;
    _pressChanged = null;
    if (afterFrame) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) changed?.call(false);
      });
    } else {
      changed?.call(false);
    }
  }

  void _tapDown(TapDownDetails details) {
    if (!_enabled || _pressed) return;
    _completeRelease();
    _releaseRequested = false;
    _pressed = true;
    _pressChanged = widget.onPressChanged;
    if (_animates) _controller.forward();
    if (widget.fireHapticFeedback) unawaited(HapticFeedback.lightImpact());
    _pressChanged?.call(true);
  }

  Future<void> _releaseFeedback() {
    if (!_animates || _controller.isDismissed) {
      _resetFeedback();
      return Future<void>.value();
    }
    _release ??= Completer<void>();
    final future = _release!.future;
    if (_controller.isCompleted) {
      _controller.reverse();
    } else if (_controller.status == .forward) {
      // Quick presses still reach their full feedback before returning.
      _releaseRequested = true;
    }
    return future;
  }

  void _tapUp(TapUpDetails details) {
    if (!_enabled || !_pressed) return;
    final animation = _releaseFeedback();
    try {
      _endPress();
    } finally {
      _activate(animation);
    }
  }

  void _tapCancel() {
    if (!_pressed) return;
    unawaited(_releaseFeedback());
    _endPress();
  }

  void _activate(Future<void> animation) {
    final result = widget.onPressed?.call(animation);
    if (result is Future<void>) unawaited(result);
  }

  @override
  void deactivate() {
    // Descendant gesture recognizers may cancel while being removed. Clear the
    // contact first so their teardown cannot call application code.
    _pressed = false;
    _pressChanged = null;
    _releaseRequested = false;
    _completeRelease();
    _controller.stop();
    _resetAfterDeactivate = true;
    super.deactivate();
  }

  @override
  void dispose() {
    _completeRelease();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.semanticLabel,
      excludeSemantics: widget.semanticLabel != null,
      onTap: _enabled ? () => _activate(Future<void>.value()) : null,
      child: MouseRegion(
        cursor: _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: GestureDetector(
          excludeFromSemantics: true,
          behavior: .opaque,
          onTapDown: _enabled ? _tapDown : null,
          onTapUp: _enabled ? _tapUp : null,
          onTapCancel: _enabled ? _tapCancel : null,
          child: _MateoPressFeedback(
            animation: _controller,
            type: widget.animation,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
