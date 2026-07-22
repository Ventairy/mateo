// GENERATED CODE - DO NOT MODIFY BY HAND
// *****************************************************
//  dotdart
// *****************************************************

// coverage:ignore-file
// Generated canvas and paint sequences intentionally use repeated receiver calls.
// ignore_for_file: cascade_invocations, unused_element, unused_element_parameter

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show OverflowBoxFit;

Color _dotdartApplyOpacity(Color color, double opacity) {
  if (opacity == 1) return color;
  return color.withValues(alpha: math.min(1, math.max(0, color.a * opacity)));
}

mixin _DotdartLottieAnimationState<T extends StatefulWidget>
    on State<T>, SingleTickerProviderStateMixin<T>, WidgetsBindingObserver {
  double? get lottieWidgetWidth;
  double? get lottieWidgetHeight;
  double? get lottieProgress;
  bool get lottieRespectDisableAnimations;
  bool get lottieMaintainAspectRatio;
  Duration get lottieLoopDuration;
  double get lottieCanvasWidth;
  double get lottieCanvasHeight;

  Widget buildPainter({required double width, required double height});

  late final AnimationController _controller;
  bool _canAnimateForLifecycle = true;

  bool _shouldAnimate() {
    final disableAnimations =
        lottieRespectDisableAnimations &&
        (MediaQuery.maybeDisableAnimationsOf(context) ?? false);
    return lottieProgress == null &&
        _canAnimateForLifecycle &&
        !disableAnimations;
  }

  void _syncController() {
    if (_shouldAnimate()) {
      if (!_controller.isAnimating) unawaited(_controller.repeat());
      return;
    }
    _controller.stop();
  }

  Size _defaultSizeFor(BoxConstraints constraints) {
    final aspect = lottieCanvasHeight / lottieCanvasWidth;
    var w = lottieCanvasWidth;
    if (constraints.hasBoundedWidth) {
      w = math.min(w, constraints.maxWidth);
    }
    if (constraints.hasBoundedHeight) {
      w = math.min(w, constraints.maxHeight / aspect);
    }
    return Size(w, w * aspect);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: lottieLoopDuration,
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncController();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncController();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _canAnimateForLifecycle = state == AppLifecycleState.resumed;
    _syncController();
  }

  Size _resolveSize(double aspect) {
    if (lottieWidgetWidth != null && lottieWidgetHeight != null) {
      if (!lottieMaintainAspectRatio) {
        return Size(lottieWidgetWidth!, lottieWidgetHeight!);
      }
      return lottieWidgetWidth! >= lottieWidgetHeight!
          ? Size(lottieWidgetWidth!, lottieWidgetWidth! * aspect)
          : Size(lottieWidgetHeight! / aspect, lottieWidgetHeight!);
    }

    final w = lottieWidgetWidth ?? lottieWidgetHeight! / aspect;
    return Size(w, lottieWidgetHeight ?? w * aspect);
  }

  @override
  Widget build(BuildContext context) {
    final hasExplicitSize =
        lottieWidgetWidth != null || lottieWidgetHeight != null;

    if (!hasExplicitSize) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final size = _defaultSizeFor(constraints);
          return buildPainter(width: size.width, height: size.height);
        },
      );
    }

    final aspect = lottieCanvasHeight / lottieCanvasWidth;
    final size = _resolveSize(aspect);

    return OverflowBox(
      alignment: Alignment.topLeft,
      fit: OverflowBoxFit.deferToChild,
      minWidth: size.width,
      maxWidth: size.width,
      minHeight: size.height,
      maxHeight: size.height,
      child: buildPainter(width: size.width, height: size.height),
    );
  }
}

/// Namespace for dotdart-generated widgets from `lotties/`.
///
/// Call a method named after each asset to render it:
///
/// ```dart
/// $Lotties.swipeUpPhoneAnimation(<params>);
/// ```
abstract final class $Lotties {
  $Lotties._();

  /// Builds the `SwipeUpPhoneAnimation` widget from `swipeUpPhoneAnimation.json`.
  static Widget swipeUpPhoneAnimation({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    double? progress,
    bool respectDisableAnimations = true,
    Color? color1,
    Color? color2,
  }) => _SwipeUpPhoneAnimation(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    progress: progress,
    respectDisableAnimations: respectDisableAnimations,
    color1: color1,
    color2: color2,
  );
}

/// A dotdart-generated animated widget from `assets/lotties/swipe_up_phone_animation.json`.
///
/// Renders a 2200ms looping animation
/// (132 frames at 60.0Hz)
/// on a 447×364 canvas.
/// No Lottie runtime dependency — the animation is drawn
/// entirely via [CustomPainter].
class _SwipeUpPhoneAnimation extends StatefulWidget {
  const _SwipeUpPhoneAnimation({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.progress,
    this.respectDisableAnimations = true,
    this.color1,
    this.color2,
  });

  static const double _lottieWidth = 447;
  static const double _lottieHeight = 364;
  static const int _totalFrames = 132;
  static const Duration _loopDuration = Duration(milliseconds: 2200);

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Fixed animation progress from 0 to 1.
  final double? progress;

  /// Whether reduced-motion settings pause playback.
  final bool respectDisableAnimations;

  /// Color 1 — defaults to 0xffffffff.
  final Color? color1;

  /// Color 2 — defaults to 0xff999999.
  final Color? color2;

  @override
  State<_SwipeUpPhoneAnimation> createState() => _SwipeUpPhoneAnimationState();
}

class _SwipeUpPhoneAnimationState extends State<_SwipeUpPhoneAnimation>
    with
        SingleTickerProviderStateMixin,
        WidgetsBindingObserver,
        _DotdartLottieAnimationState<_SwipeUpPhoneAnimation> {
  @override
  double? get lottieWidgetWidth => widget.width;

  @override
  double? get lottieWidgetHeight => widget.height;

  @override
  bool get lottieMaintainAspectRatio => widget.maintainAspectRatio;

  @override
  double? get lottieProgress => widget.progress;

  @override
  bool get lottieRespectDisableAnimations => widget.respectDisableAnimations;

  @override
  Duration get lottieLoopDuration => _SwipeUpPhoneAnimation._loopDuration;

  @override
  double get lottieCanvasWidth => _SwipeUpPhoneAnimation._lottieWidth;

  @override
  double get lottieCanvasHeight => _SwipeUpPhoneAnimation._lottieHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _SwipeUpPhoneAnimationPainter(
            animationProgress: _shouldAnimate() ? _controller : null,
            fixedProgress: (widget.progress ?? 0).clamp(0, 1).toDouble(),
            color1: widget.color1 ?? const Color(0xffffffff),
            color2: widget.color2 ?? const Color(0xff999999),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _SwipeUpPhoneAnimationPainter extends CustomPainter {
  _SwipeUpPhoneAnimationPainter({
    required this._fixedProgress,
    required this.color1,
    required this.color2,
    this._animationProgress,
  }) : super(repaint: _animationProgress);

  final double _fixedProgress;
  final Animation<double>? _animationProgress;

  final Color color1;
  final Color color2;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;
  final Paint _strokePaint = Paint()..style = PaintingStyle.stroke;

  double _keyframes0Opacity(double frame) {
    if (frame <= 0) return 0;
    if (frame >= 132) return 0;
    if (frame < 10) {
      final t = frame / 10;
      final eased = _transformCurve0(t);
      return 0 + 100 * eased;
    }
    if (frame < 48) {
      return 100;
    }
    if (frame < 88) {
      final t = (frame - 48) / 40;
      final eased = _transformCurve1(t);
      return 100 + -100 * eased;
    }
    if (frame < 132) {
      return 0;
    }
    return 0;
  }

  double _keyframes0Rotation(double frame) {
    if (frame <= 0) return 0;
    if (frame >= 132) return 23;
    if (frame < 10) {
      return 0;
    }
    if (frame < 24) {
      return 0;
    }
    if (frame < 30) {
      final t = (frame - 24) / 6;
      final eased = _transformCurve2(t);
      return 0 + -3 * eased;
    }
    if (frame < 88) {
      final t = (frame - 30) / 58;
      final eased = _transformCurve1(t);
      return -3 + 26 * eased;
    }
    if (frame < 132) {
      return 23;
    }
    return 23;
  }

  double _keyframes0PositionX(double frame) {
    if (frame <= 0) return 294.8;
    if (frame >= 132) return 292.9;
    if (frame < 10) {
      final t = frame / 10;
      final eased = _transformCurve0(t);
      return 294.8 + -3.7 * eased;
    }
    if (frame < 24) {
      return 291.1;
    }
    if (frame < 30) {
      final t = (frame - 24) / 6;
      final eased = _transformCurve2(t);
      return 291.1 + 1.8 * eased;
    }
    if (frame < 88) {
      return 292.9;
    }
    if (frame < 132) {
      return 292.9;
    }
    return 292.9;
  }

  double _keyframes0PositionY(double frame) {
    if (frame <= 0) return 213.2;
    if (frame >= 132) return 67.3;
    if (frame < 10) {
      final t = frame / 10;
      final eased = _transformCurve0(t);
      return 213.2 + -9.9 * eased;
    }
    if (frame < 24) {
      return 203.3;
    }
    if (frame < 30) {
      final t = (frame - 24) / 6;
      final eased = _transformCurve2(t);
      return 203.3 + 4.8 * eased;
    }
    if (frame < 88) {
      final t = (frame - 30) / 58;
      final eased = _transformCurve1(t);
      return 208.1 + -140.8 * eased;
    }
    if (frame < 132) {
      return 67.3;
    }
    return 67.3;
  }

  double _keyframes0ScaleX(double frame) {
    if (frame <= 0) return 42.3;
    if (frame >= 132) return 43.65;
    if (frame < 10) {
      final t = frame / 10;
      final eased = _transformCurve0(t);
      return 42.3 + 2.7 * eased;
    }
    if (frame < 24) {
      return 45;
    }
    if (frame < 30) {
      final t = (frame - 24) / 6;
      final eased = _transformCurve2(t);
      return 45 + -0.45 * eased;
    }
    if (frame < 88) {
      final t = (frame - 30) / 58;
      final eased = _transformCurve1(t);
      return 44.55 + -0.9 * eased;
    }
    if (frame < 132) {
      return 43.65;
    }
    return 43.65;
  }

  double _keyframes0ScaleY(double frame) {
    if (frame <= 0) return 42.3;
    if (frame >= 132) return 43.65;
    if (frame < 10) {
      final t = frame / 10;
      final eased = _transformCurve0(t);
      return 42.3 + 2.7 * eased;
    }
    if (frame < 24) {
      return 45;
    }
    if (frame < 30) {
      final t = (frame - 24) / 6;
      final eased = _transformCurve2(t);
      return 45 + -1.35 * eased;
    }
    if (frame < 88) {
      return 43.65;
    }
    if (frame < 132) {
      return 43.65;
    }
    return 43.65;
  }

  double _keyframes1Opacity(double frame) {
    if (frame <= 0) return 0;
    if (frame >= 132) return 0;
    if (frame < 27) {
      return 0;
    }
    if (frame < 30) {
      final t = (frame - 27) / 3;
      final eased = _transformCurve0(t);
      return 0 + 55 * eased;
    }
    if (frame < 52) {
      final t = (frame - 30) / 22;
      final eased = _transformCurve3(t);
      return 55 + -55 * eased;
    }
    if (frame < 132) {
      return 0;
    }
    return 0;
  }

  double _keyframes1PositionX(double frame) {
    if (frame <= 0) return 293;
    if (frame >= 132) return 290;
    if (frame < 27) {
      return 293;
    }
    if (frame < 52) {
      final t = (frame - 27) / 25;
      final eased = _transformCurve4(t);
      return 293 + -3 * eased;
    }
    if (frame < 132) {
      return 290;
    }
    return 290;
  }

  double _keyframes1PositionY(double frame) {
    if (frame <= 0) return 208;
    if (frame >= 132) return 162;
    if (frame < 27) {
      return 208;
    }
    if (frame < 52) {
      final t = (frame - 27) / 25;
      final eased = _transformCurve4(t);
      return 208 + -46 * eased;
    }
    if (frame < 132) {
      return 162;
    }
    return 162;
  }

  double _keyframes1ScaleX(double frame) {
    if (frame <= 0) return 25;
    if (frame >= 132) return 140;
    if (frame < 27) {
      return 25;
    }
    if (frame < 52) {
      final t = (frame - 27) / 25;
      final eased = _transformCurve5(t);
      return 25 + 115 * eased;
    }
    if (frame < 132) {
      return 140;
    }
    return 140;
  }

  double _keyframes1ScaleY(double frame) {
    if (frame <= 0) return 25;
    if (frame >= 132) return 140;
    if (frame < 27) {
      return 25;
    }
    if (frame < 52) {
      final t = (frame - 27) / 25;
      final eased = t;
      return 25 + 115 * eased;
    }
    if (frame < 132) {
      return 140;
    }
    return 140;
  }

  double _keyframes2Opacity(double frame) {
    if (frame <= 0) return 0;
    if (frame >= 132) return 0;
    if (frame < 10) {
      final t = frame / 10;
      final eased = _transformCurve0(t);
      return 0 + 100 * eased;
    }
    if (frame < 50) {
      return 100;
    }
    if (frame < 90) {
      final t = (frame - 50) / 40;
      final eased = _transformCurve1(t);
      return 100 + -100 * eased;
    }
    if (frame < 132) {
      return 0;
    }
    return 0;
  }

  double _keyframes2PositionY(double frame) {
    if (frame <= 0) return 175;
    if (frame >= 132) return 63;
    if (frame < 10) {
      final t = frame / 10;
      final eased = _transformCurve0(t);
      return 175 + -10 * eased;
    }
    if (frame < 24) {
      return 165;
    }
    if (frame < 30) {
      final t = (frame - 24) / 6;
      final eased = _transformCurve2(t);
      return 165 + 4 * eased;
    }
    if (frame < 32) {
      return 169;
    }
    if (frame < 90) {
      final t = (frame - 32) / 58;
      final eased = _transformCurve1(t);
      return 169 + -106 * eased;
    }
    if (frame < 132) {
      return 63;
    }
    return 63;
  }

  double _keyframes2ScaleX(double frame) {
    if (frame <= 0) return 90;
    if (frame >= 132) return 98;
    if (frame < 10) {
      final t = frame / 10;
      final eased = _transformCurve0(t);
      return 90 + 10 * eased;
    }
    if (frame < 24) {
      return 100;
    }
    if (frame < 30) {
      final t = (frame - 24) / 6;
      final eased = _transformCurve2(t);
      return 100 + -3 * eased;
    }
    if (frame < 32) {
      return 97;
    }
    if (frame < 90) {
      final t = (frame - 32) / 58;
      final eased = _transformCurve1(t);
      return 97 + 1 * eased;
    }
    if (frame < 132) {
      return 98;
    }
    return 98;
  }

  double _keyframes2ScaleY(double frame) {
    if (frame <= 0) return 90;
    if (frame >= 132) return 98;
    if (frame < 10) {
      final t = frame / 10;
      final eased = _transformCurve0(t);
      return 90 + 10 * eased;
    }
    if (frame < 24) {
      return 100;
    }
    if (frame < 30) {
      final t = (frame - 24) / 6;
      final eased = _transformCurve2(t);
      return 100 + -3 * eased;
    }
    if (frame < 32) {
      return 97;
    }
    if (frame < 90) {
      final t = (frame - 32) / 58;
      final eased = _transformCurve1(t);
      return 97 + 1 * eased;
    }
    if (frame < 132) {
      return 98;
    }
    return 98;
  }

  static final Rect _ellipseRect1_0_0 = Rect.fromCenter(
    center: Offset.zero,
    width: 44,
    height: 44,
  );

  static final Path __path0_0_0 = Path()
    ..moveTo(125.458, 95.2916)
    ..cubicTo(125.458, 95.2916, 176.688, 28.6755, 176.688, 28.6755)
    ..cubicTo(201.837, -4.0272, 249.475, -9.5829, 283.09, 16.268)
    ..cubicTo(283.09, 16.268, 291.903, 23.0451, 291.903, 23.0451)
    ..cubicTo(352.164, 69.3876, 364.466, 154.481, 319.38, 213.108)
    ..cubicTo(289.07, 252.521, 238.811, 271.429, 188.845, 262.216)
    ..cubicTo(188.845, 262.216, 74.2045, 241.079, 74.2045, 241.079)
    ..cubicTo(70.8085, 240.453, 68.0616, 237.902, 67.1971, 234.572)
    ..cubicTo(67.1971, 234.572, 62.8869, 217.958, 62.8869, 217.958)
    ..cubicTo(57.6182, 197.6512, 69.8185, 177.383, 90.1372, 172.688)
    ..cubicTo(90.1372, 172.688, 112.24, 167.582, 112.24, 167.582)
    ..cubicTo(112.24, 167.582, 13.3354, 91.5215, 13.3354, 91.5215)
    ..cubicTo(-1.371, 80.2119, -4.3731, 59.4449, 6.6299, 45.1373)
    ..cubicTo(17.6328, 30.8298, 38.4748, 28.3987, 53.1812, 39.7084)
    ..cubicTo(53.1812, 39.7084, 125.458, 95.2916, 125.458, 95.2916)
    ..close();

  static final Path __path2_0_0 = Path()
    ..moveTo(-40, 10)
    ..cubicTo(-40, 10, 0, -30, 0, -30)
    ..cubicTo(0, -30, 40, 10, 40, 10);

  static final Path __path2_0_1 = Path()
    ..moveTo(0, -30)
    ..cubicTo(0, -30, 0, 75, 0, 75);

  static final Path _compoundStrokePath2_0 = Path()
    ..addPath(__path2_0_0, Offset.zero)
    ..addPath(__path2_0_1, Offset.zero);

  static final Path _compoundFillPath3_0 = Path()
    ..fillType = PathFillType.evenOdd
    ..addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: 197, height: 310),
        const Radius.circular(53),
      ),
    )
    ..addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: const Offset(0, -109), width: 56, height: 21),
        const Radius.circular(10.5),
      ),
    );

  double _curve0T = double.nan;
  double _curve0Value = 0;

  double _transformCurve0(double t) {
    if (t == _curve0T) return _curve0Value;
    _curve0T = t;
    return _curve0Value = const Cubic(0.2, 0.75, 0.34, 0.94).transform(t);
  }

  double _curve1T = double.nan;
  double _curve1Value = 0;

  double _transformCurve1(double t) {
    if (t == _curve1T) return _curve1Value;
    _curve1T = t;
    return _curve1Value = const Cubic(0.35, 0, 0.14, 0.53).transform(t);
  }

  double _curve2T = double.nan;
  double _curve2Value = 0;

  double _transformCurve2(double t) {
    if (t == _curve2T) return _curve2Value;
    _curve2T = t;
    return _curve2Value = const Cubic(0.85, 0.46, 0.14, 0.53).transform(t);
  }

  double _curve3T = double.nan;
  double _curve3Value = 0;

  double _transformCurve3(double t) {
    if (t == _curve3T) return _curve3Value;
    _curve3T = t;
    return _curve3Value = const Cubic(0, 0.65, 0.34, 0.94).transform(t);
  }

  double _curve4T = double.nan;
  double _curve4Value = 0;

  double _transformCurve4(double t) {
    if (t == _curve4T) return _curve4Value;
    _curve4T = t;
    return _curve4Value = const Cubic(1, 0.49, 0, 0.55).transform(t);
  }

  double _curve5T = double.nan;
  double _curve5Value = 0;

  double _transformCurve5(double t) {
    if (t == _curve5T) return _curve5Value;
    _curve5T = t;
    return _curve5Value = const Cubic(0, 0.65, 0.51, 0.99).transform(t);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final progress = _animationProgress?.value ?? _fixedProgress;
    final frame = progress * _SwipeUpPhoneAnimation._totalFrames;
    final scaleX = size.width / _SwipeUpPhoneAnimation._lottieWidth;
    final scaleY = size.height / _SwipeUpPhoneAnimation._lottieHeight;

    canvas
      ..save()
      ..scale(scaleX, scaleY);

    _drawPhone3(canvas, frame);
    _drawUpArrow2(canvas, frame);
    _drawTouchRipple1(canvas, frame);
    _drawPointerHand0(canvas, frame);

    canvas.restore();
  }

  void _drawPointerHand0(Canvas canvas, double frame) {
    final layerOpacity = _keyframes0Opacity(frame) / 100;
    if (layerOpacity <= 0) return;
    final rotation = _keyframes0Rotation(frame);
    final posX = _keyframes0PositionX(frame);
    final posY = _keyframes0PositionY(frame);
    final scaleX = _keyframes0ScaleX(frame) / 100;
    final scaleY = _keyframes0ScaleY(frame) / 100;
    canvas.save();
    canvas.translate(posX, posY);
    canvas.rotate(rotation * math.pi / 180);
    canvas.scale(scaleX, scaleY);
    canvas.translate(-36, -62);
    // Group: Hand Shape
    final fillPaint0_0 = _fillPaint
      ..color = _dotdartApplyOpacity(color1, layerOpacity * 1);
    canvas.drawPath(__path0_0_0, fillPaint0_0);
    canvas.restore();
  }

  void _drawTouchRipple1(Canvas canvas, double frame) {
    final layerOpacity = _keyframes1Opacity(frame) / 100;
    if (layerOpacity <= 0) return;
    final posX = _keyframes1PositionX(frame);
    final posY = _keyframes1PositionY(frame);
    final scaleX = _keyframes1ScaleX(frame) / 100;
    final scaleY = _keyframes1ScaleY(frame) / 100;
    canvas.save();
    canvas.translate(posX, posY);
    canvas.scale(scaleX, scaleY);
    // Group: Ripple Ring
    final strokePaint0_0 = _strokePaint
      ..color = _dotdartApplyOpacity(color1, layerOpacity * 1)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawOval(_ellipseRect1_0_0, strokePaint0_0);
    canvas.restore();
  }

  void _drawUpArrow2(Canvas canvas, double frame) {
    final layerOpacity = _keyframes2Opacity(frame) / 100;
    if (layerOpacity <= 0) return;
    final posY = _keyframes2PositionY(frame);
    final scaleX = _keyframes2ScaleX(frame) / 100;
    final scaleY = _keyframes2ScaleY(frame) / 100;
    canvas.save();
    canvas.translate(73, posY);
    canvas.scale(scaleX, scaleY);
    // Group: Arrow Shape
    final compoundStrokePaint0 = _strokePaint
      ..color = _dotdartApplyOpacity(color1, layerOpacity * 1)
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(_compoundStrokePath2_0, compoundStrokePaint0);
    canvas.restore();
  }

  void _drawPhone3(Canvas canvas, double frame) {
    const double layerOpacity = 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.translate(248, 185);
    // Group: Phone Body With Speaker Cutout
    final compoundFillPaint0 = _fillPaint
      ..color = _dotdartApplyOpacity(color2, layerOpacity * 1);
    canvas.drawPath(_compoundFillPath3_0, compoundFillPaint0);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SwipeUpPhoneAnimationPainter oldDelegate) {
    return oldDelegate._fixedProgress != _fixedProgress ||
        oldDelegate._animationProgress != _animationProgress ||
        oldDelegate.color1 != color1 ||
        oldDelegate.color2 != color2;
  }
}
