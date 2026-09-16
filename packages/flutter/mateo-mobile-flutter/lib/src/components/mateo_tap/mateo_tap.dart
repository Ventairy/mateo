import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

part '_mateo_tap_fade.dart';
part '_render_mateo_tap_fade.dart';
part 'mateo_tap_enums.dart';

/// Reusable Mateo tap feedback animation.
///
/// Wraps [child] with press-down visual feedback (scale, fade, none etc.)
/// and optional haptic feedback. The [onPressed] callback receives a
/// [Future<void>] that resolves when the release animation completes,
/// allowing callers to wait for visual feedback before navigating.
///
/// Enabled taps expose button semantics automatically. [semanticLabel]
/// replaces the semantics provided by [child] when supplied.
///
/// ```dart
/// MateoTap(
///   onPressed: (animation) async {
///     await animation;
///     // navigate after release animation
///   },
///   child: const Text('Tap me'),
/// )
/// ```
class MateoTap extends StatefulWidget {
  /// Creates tap feedback around [child].
  const MateoTap({
    required this.child,
    super.key,
    this.onPressed,
    this.onPressChanged,
    this.semanticLabel,
    this.animation = MateoTapAnimationType.scaleFade,
    this.fireHapticFeedback = true,
  });

  /// Widget that receives the tap feedback.
  final Widget child;

  /// Called when the child is pressed.
  ///
  /// The [animation] future resolves when the release animation completes.
  /// Callers may `await animation` to wait for the visual feedback before
  /// performing navigation or other side effects.
  ///
  /// The callback may complete synchronously or return a [Future]. It only
  /// needs to be `async` when it awaits the animation or other asynchronous
  /// work.
  ///
  /// When null, the child renders without pointer feedback and ignores taps.
  final FutureOr<void> Function(Future<void> animation)? onPressed;

  /// Accessibility label announced instead of the semantics from [child].
  ///
  /// When null, assistive technologies derive the label from [child].
  final String? semanticLabel;

  /// Reports whether the pointer is actively pressing the child.
  final ValueChanged<bool>? onPressChanged;

  /// Whether haptic feedback fires when the widget is pressed.
  ///
  /// When `false`, [HapticFeedback.lightImpact] is not called. Defaults to
  /// `true`.
  final bool fireHapticFeedback;

  /// The tap feedback style.
  final MateoTapAnimationType animation;

  @override
  State<MateoTap> createState() => _MateoTapState();
}

class _MateoTapState extends State<MateoTap> with TickerProviderStateMixin {
  final _pressedOpacity = 0.4;
  final _pressedScale = 0.96;
  final _pressInDuration = const Duration(milliseconds: 150);
  final _releaseDuration = const Duration(milliseconds: 150);

  late final AnimationController _controller;
  late final CurvedAnimation _scaleCurve;
  late final CurvedAnimation _opacityCurve;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  bool _releaseRequested = false;
  Completer<void>? _releaseCompleter;
  bool get _isEnabled => widget.onPressed != null;
  bool get _hasAnimation => widget.animation != MateoTapAnimationType.none;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: _pressInDuration,
      reverseDuration: _releaseDuration,
      vsync: this,
    );
    _controller.addStatusListener(_onStatusChanged);

    _scaleCurve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.linear,
    );
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: _pressedScale,
    ).animate(_scaleCurve);

    _opacityCurve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeOutCubic,
    );
    _opacityAnimation = Tween<double>(
      begin: 1,
      end: _pressedOpacity,
    ).animate(_opacityCurve);
  }

  @override
  void dispose() {
    _releaseCompleter?.complete();
    _opacityCurve.dispose();
    _scaleCurve.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MateoTap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_isEnabled && _controller.value > 0) {
      _releaseCompleter?.complete();
      _releaseCompleter = null;
      _releaseRequested = false;
      _controller.reset();
    }
  }

  void _onStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed && _releaseRequested) {
      _releaseRequested = false;
      _controller.reverse();
    } else if (status == AnimationStatus.dismissed) {
      _releaseCompleter?.complete();
      _releaseCompleter = null;
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (!_isEnabled) return;
    widget.onPressChanged?.call(true);

    if (widget.fireHapticFeedback) {
      unawaited(HapticFeedback.lightImpact());
    }

    if (!_hasAnimation) return;

    _releaseRequested = false;
    _releaseCompleter?.complete();
    _releaseCompleter = null;

    if (!MediaQuery.disableAnimationsOf(context)) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!_isEnabled) return;
    widget.onPressChanged?.call(false);

    if (!_hasAnimation || MediaQuery.disableAnimationsOf(context)) {
      _callOnPressed(Future<void>.value());
      return;
    }

    _releaseCompleter = Completer<void>();
    _callOnPressed(_releaseCompleter!.future);
    _requestRelease();
  }

  void _callOnPressed(Future<void> animation) {
    final result = widget.onPressed!(animation);
    if (result is Future<void>) unawaited(result);
  }

  void _handleTapCancel() {
    if (!_isEnabled) return;
    widget.onPressChanged?.call(false);
    if (_hasAnimation) {
      _requestRelease();
    }
  }

  void _requestRelease() {
    if (_controller.status == AnimationStatus.dismissed) {
      return;
    }
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else {
      _releaseRequested = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: _isEnabled,
      label: widget.semanticLabel,
      excludeSemantics: widget.semanticLabel != null,
      onTap: _isEnabled ? () => _callOnPressed(Future<void>.value()) : null,
      child: MouseRegion(
        cursor: _isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: GestureDetector(
          onTapDown: _isEnabled ? _handleTapDown : null,
          onTapUp: _isEnabled ? _handleTapUp : null,
          onTapCancel: _isEnabled ? _handleTapCancel : null,
          behavior: HitTestBehavior.opaque,
          child: switch (widget.animation) {
            MateoTapAnimationType.none => widget.child,
            MateoTapAnimationType.scaleFade => ScaleTransition(
              scale: _scaleAnimation,
              child: _MateoTapFade(opacity: _opacityAnimation, child: widget.child),
            ),
            MateoTapAnimationType.scale => ScaleTransition(
              scale: _scaleAnimation,
              child: widget.child,
            ),
          },
        ),
      ),
    );
  }
}
