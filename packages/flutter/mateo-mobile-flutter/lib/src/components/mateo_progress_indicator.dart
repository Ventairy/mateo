/// @docImport 'package:mateo_mobile_old/src/components/mateo_dots_loading_indicator/mateo_dots_loading_indicator.dart';
library;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:mateo_mobile_old/src/theme/mateo_theme_context.dart';

/// A determinate Mateo progress bar for measurable work and stepped flows.
///
/// [MateoProgressIndicator] fills a compact pill from its leading edge to show
/// the completed proportion represented by [value]. The first value animates
/// from zero, and later values animate continuously from the currently visible
/// progress.
///
/// The indicator expands to the width supplied by its parent and keeps its
/// height, colors, timing, and curve aligned with Mateo. Place it in an
/// [Expanded] when it is used inside a [Row].
///
/// Motion is limited to paint work inside a [RepaintBoundary]. When
/// [MediaQuery.disableAnimationsOf] is enabled, the destination value is
/// painted immediately.
///
/// ```dart
/// MateoProgressIndicator(
///   value: completedSteps / totalSteps,
///   width: 240,
///   semanticsLabel: 'Profile setup progress',
///   semanticsValue: 'Step 2 of 4',
/// )
/// ```
///
/// See also:
///  * [MateoDotsLoadingIndicator], for work whose completion cannot be
///    measured.
class MateoProgressIndicator extends StatefulWidget {
  /// Creates a determinate Mateo progress indicator.
  ///
  /// The [value] must be between `0.0` and `1.0`, where `0.0` is empty and
  /// `1.0` is complete. Invalid values assert in debug builds and are
  /// defensively clamped when assertions are disabled.
  ///
  /// The optional [semanticsLabel] identifies the work for assistive
  /// technologies. The optional [semanticsValue] adds a more specific
  /// description alongside the automatically generated percentage.
  const MateoProgressIndicator({
    required this.value,
    super.key,
    this.width = double.infinity,
    this.semanticsLabel,
    this.semanticsValue,
  }) : assert(
         value >= 0 && value <= 1,
         'value must be between 0.0 and 1.0, but got $value.',
       ),
       assert(
         width >= 0,
         'width must be non-negative, but got $width.',
       );

  static const double _height = 5;
  static const Duration _animationDuration = Duration(milliseconds: 1000);

  /// The completed proportion from `0.0` through `1.0`.
  final double value;

  /// The width of the progress bar in logical pixels.
  ///
  /// Defaults to [double.infinity] so the indicator fills the width supplied
  /// by its parent. A finite value gives the indicator an explicit width.
  final double width;

  /// The optional accessible name of the work represented by the indicator.
  final String? semanticsLabel;

  /// The optional accessible description announced with the current progress.
  ///
  /// The current [value] is always exposed as a rounded percentage so the
  /// platform can preserve numeric progress-bar semantics.
  final String? semanticsValue;

  @override
  State<MateoProgressIndicator> createState() => _MateoProgressIndicatorState();
}

class _MateoProgressIndicatorState extends State<MateoProgressIndicator> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool? _animationsDisabled;

  double get _targetValue => _normalize(widget.value);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: MateoProgressIndicator._animationDuration,
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final animationsDisabled = MediaQuery.disableAnimationsOf(context);
    if (_animationsDisabled == null) {
      _animationsDisabled = animationsDisabled;
      _setProgress(_targetValue, animate: !animationsDisabled);
      return;
    }

    if (_animationsDisabled != animationsDisabled) {
      _animationsDisabled = animationsDisabled;
      _setProgress(_targetValue, animate: false);
    }
  }

  @override
  void didUpdateWidget(covariant MateoProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_normalize(oldWidget.value) == _targetValue) return;

    _setProgress(
      _targetValue,
      animate: !(_animationsDisabled ?? true),
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _setProgress(double value, {required bool animate}) {
    if (!animate || value == _controller.value) {
      _controller
        ..stop()
        ..value = value;
      return;
    }

    _controller.animateTo(
      value,
      duration: MateoProgressIndicator._animationDuration,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.mateo.colorScheme;
    final targetValue = _targetValue;

    return Semantics(
      label: widget.semanticsLabel,
      value: '${(targetValue * 100).round()}%',
      hint: widget.semanticsValue,
      minValue: '0',
      maxValue: '100',
      role: SemanticsRole.progressBar,
      child: SizedBox(
        width: widget.width,
        height: MateoProgressIndicator._height,
        child: RepaintBoundary(
          child: CustomPaint(
            painter: _MateoProgressIndicatorPainter(
              progress: _controller,
              trackColor: colorScheme.controls.track,
              fillColor: colorScheme.controls.trackFilled,
              textDirection: Directionality.of(context),
            ),
          ),
        ),
      ),
    );
  }
}

class _MateoProgressIndicatorPainter extends CustomPainter {
  _MateoProgressIndicatorPainter({
    required this.progress,
    required this.trackColor,
    required this.fillColor,
    required this.textDirection,
  }) : super(repaint: progress);

  final Animation<double> progress;
  final Color trackColor;
  final Color fillColor;
  final TextDirection textDirection;
  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final bounds = Offset.zero & size;
    final pill = RRect.fromRectAndRadius(
      bounds,
      Radius.circular(size.height / 2),
    );

    canvas.drawRRect(pill, _paint..color = trackColor);

    final fillWidth = size.width * _normalize(progress.value);
    if (fillWidth <= 0) return;

    final fillBounds = switch (textDirection) {
      TextDirection.ltr => Rect.fromLTWH(0, 0, fillWidth, size.height),
      TextDirection.rtl => Rect.fromLTWH(
        size.width - fillWidth,
        0,
        fillWidth,
        size.height,
      ),
    };

    canvas
      ..save()
      ..clipRect(fillBounds)
      ..drawRRect(pill, _paint..color = fillColor)
      ..restore();
  }

  @override
  bool shouldRepaint(covariant _MateoProgressIndicatorPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.textDirection != textDirection;
  }
}

double _normalize(double value) {
  if (value.isNaN) return 0;
  return value.clamp(0.0, 1.0);
}
