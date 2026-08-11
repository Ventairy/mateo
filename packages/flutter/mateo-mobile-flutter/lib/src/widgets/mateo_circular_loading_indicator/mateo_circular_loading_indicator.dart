import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:mateo_mobile/src/theme/mateo_theme_context.dart';

part '_mateo_circular_loading_indicator_painter.dart';

/// A circular Mateo indicator for work whose completion cannot be measured.
///
/// [MateoCircularLoadingIndicator] paints a rounded arc that moves clockwise
/// over a complete circular track. The arc and track use the same proportional
/// stroke width, so the moving arc completely covers its part of the track.
///
/// When [size] is omitted, the indicator uses the largest circle permitted by
/// its parent. If neither axis is bounded, it uses a 24 logical-pixel fallback.
/// The indicator remains circular inside rectangular constraints.
///
///
/// ```dart
/// const MateoCircularLoadingIndicator(size: 24)
/// ```
class MateoCircularLoadingIndicator extends StatefulWidget {
  /// Creates a circular Mateo loading indicator.
  ///
  /// The optional [color] paints the moving arc and defaults to primary step 9
  /// from the active Mateo palette. The optional [trackColor] paints the full
  /// track and defaults to primary step 4.
  ///
  /// The optional [size] is the indicator diameter in logical pixels. It must
  /// be finite and non-negative when supplied. When omitted, the parent
  /// constraints determine the diameter.
  const MateoCircularLoadingIndicator({
    super.key,
    this.color,
    this.trackColor,
    this.size,
  }) : assert(
         size == null || (size >= 0 && size < double.infinity),
         'size must be finite and non-negative, but got $size.',
       );

  static const double _fallbackSize = 24;
  static const Duration _cycleDuration = Duration(milliseconds: 800);

  /// The color used to paint the moving arc.
  ///
  /// When omitted, primary step 9 from the active Mateo palette is used.
  final Color? color;

  /// The color used to paint the circular track.
  ///
  /// When omitted, primary step 4 from the active Mateo palette is used.
  final Color? trackColor;

  /// The optional diameter of the indicator in logical pixels.
  ///
  /// When omitted, the largest bounded parent dimension that keeps the
  /// indicator circular is used. If both dimensions are unbounded, the
  /// indicator uses 24 logical pixels.
  final double? size;

  /// The mutable state that owns the indicator animation.
  @override
  State<MateoCircularLoadingIndicator> createState() =>
      _MateoCircularLoadingIndicatorState();
}

class _MateoCircularLoadingIndicatorState
    extends State<MateoCircularLoadingIndicator>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _controller;
  late bool _applicationIsActive;

  @override
  void initState() {
    super.initState();

    final initialLifecycleState = WidgetsBinding.instance.lifecycleState;

    _applicationIsActive =
        initialLifecycleState == null ||
        initialLifecycleState == AppLifecycleState.resumed;

    _controller = AnimationController(
      vsync: this,
      duration: MateoCircularLoadingIndicator._cycleDuration,
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _synchronizeAnimation();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        _applicationIsActive = false;
        _controller.stop();
      case AppLifecycleState.resumed:
        _applicationIsActive = true;
        _synchronizeAnimation();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();

    super.dispose();
  }

  void _synchronizeAnimation() {
    final animationsDisabled = MediaQuery.disableAnimationsOf(context);
    if (!_applicationIsActive || animationsDisabled) {
      _controller.stop();
      return;
    }

    if (!_controller.isAnimating) unawaited(_controller.repeat());
  }

  @override
  Widget build(BuildContext context) {
    final animationsDisabled = MediaQuery.disableAnimationsOf(context);
    final palette = context.mateo.palette;

    final painter = _MateoCircularLoadingIndicatorPainter(
      color: widget.color ?? palette.primary[9],
      trackColor: widget.trackColor ?? palette.primary[4],
      progress: animationsDisabled ? null : _controller,
    );

    return Semantics(
      role: SemanticsRole.loadingSpinner,
      child: _MateoCircularLoadingIndicatorLayout(
        requestedSize: widget.size,
        child: RepaintBoundary(child: CustomPaint(painter: painter)),
      ),
    );
  }
}

class _MateoCircularLoadingIndicatorLayout extends StatelessWidget {
  const _MateoCircularLoadingIndicatorLayout({
    required this.requestedSize,
    required this.child,
  });

  final double? requestedSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final requestedSize = this.requestedSize;
    if (requestedSize != null) {
      return _buildSizedIndicator(requestedSize);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : double.infinity;

        final height = constraints.hasBoundedHeight
            ? constraints.maxHeight
            : double.infinity;

        final availableSize = math.min(width, height);
        final resolvedSize = availableSize.isFinite
            ? availableSize
            : MateoCircularLoadingIndicator._fallbackSize;

        return _buildSizedIndicator(resolvedSize);
      },
    );
  }

  Widget _buildSizedIndicator(double size) {
    return Align(
      widthFactor: 1,
      heightFactor: 1,
      child: SizedBox.square(dimension: size, child: child),
    );
  }
}
