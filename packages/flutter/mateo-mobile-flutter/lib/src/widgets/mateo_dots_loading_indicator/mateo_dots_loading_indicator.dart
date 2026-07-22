library;

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mateo_mobile/src/theme/mateo_theme_context.dart';

part 'mateo_dots_loading_indicator_painter.dart';

/// A Mateo Mobile loading indicator made of three smoothly jumping dots.
///
/// `MateoDotsLoadingIndicator` is designed for compact loading states where a
/// spinner would feel too mechanical. The three dots jump one after another in
/// a continuous loop, with the first dot beginning its next jump as the last
/// dot settles back toward the baseline.
///
/// The indicator exposes only [color] and [dotRadius]. Spacing, jump height,
/// and timing are derived internally from [dotRadius] so the motion keeps the
/// same proportions at every size.
///
/// ## Performance
///
/// The indicator is a single [CustomPaint] inside a [RepaintBoundary]. A single
/// ticker repaints the painter directly; there are no per-dot widgets, layout
/// animations, gradients, blur effects, or off-screen layers. The widget
/// respects [MediaQuery.disableAnimationsOf] and pauses its ticker while the app
/// is backgrounded.
///
/// ```dart
/// MateoDotsLoadingIndicator()
/// ```
class MateoDotsLoadingIndicator extends StatefulWidget {
  /// Creates a Mateo loading indicator with three animated dots.
  const MateoDotsLoadingIndicator({
    super.key,
    this.color,
    this.dotRadius = _defaultDotRadius,
  }) : assert(
         dotRadius >= 0,
         'dotRadius must be non-negative, but got $dotRadius.',
       );

  static const double _defaultDotRadius = 5;
  static const double _spacingMultiplier = 1.35;
  static const double _jumpHeightMultiplier = 1.9;
  static const Duration _cycleDuration = Duration(milliseconds: 1100);

  /// The color used to paint each dot.
  ///
  /// When omitted, the primary color of the current theme is used.
  final Color? color;

  /// The radius of each dot in logical pixels.
  ///
  /// Spacing and jump height are derived from this value so the indicator keeps
  /// a consistent rhythm at compact and large sizes.
  final double dotRadius;

  @override
  State<MateoDotsLoadingIndicator> createState() =>
      _MateoDotsLoadingIndicatorState();
}

class _MateoDotsLoadingIndicatorState extends State<MateoDotsLoadingIndicator>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _controller;

  double get _spacing =>
      widget.dotRadius * MateoDotsLoadingIndicator._spacingMultiplier;
  double get _jumpHeight =>
      widget.dotRadius * MateoDotsLoadingIndicator._jumpHeightMultiplier;

  Size get _indicatorSize {
    final diameter = widget.dotRadius * 2;
    return Size(diameter * 3 + _spacing * 2, diameter + _jumpHeight);
  }

  void _syncControllerState() {
    final disabled = MediaQuery.disableAnimationsOf(context);

    if (disabled) {
      if (_controller.isAnimating) _controller.stop();
      return;
    }

    if (!_controller.isAnimating) unawaited(_controller.repeat());
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: MateoDotsLoadingIndicator._cycleDuration,
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _syncControllerState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        _controller.stop();
      case AppLifecycleState.resumed:
        _syncControllerState();
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? context.mateo.palette.primary[9];
    final disabled = MediaQuery.disableAnimationsOf(context);
    final size = _indicatorSize;

    return SizedBox.fromSize(
      size: size,
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _MateoDotsLoadingIndicatorPainter(
            color: color,
            dotRadius: widget.dotRadius,
            jumpHeight: _jumpHeight,
            spacing: _spacing,
            progress: disabled ? null : _controller,
          ),
          size: size,
        ),
      ),
    );
  }
}
