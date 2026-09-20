// GENERATED CODE - DO NOT MODIFY BY HAND
// *****************************************************
//  dotdart
// *****************************************************

// coverage:ignore-file
// Generated canvas and paint sequences intentionally use repeated receiver calls.
// ignore_for_file: cascade_invocations, unused_element, unused_element_parameter

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/rendering.dart' show OverflowBoxFit;
import 'package:flutter/widgets.dart';

import 'dotdart.g.dart' show LottiePlayback;
export 'dotdart.g.dart' show LottiePlayback;

Color _dotdartApplyOpacity(Color color, double opacity) {
  if (opacity == 1) return color;
  return color.withValues(alpha: math.min(1, math.max(0, color.a * opacity)));
}

mixin _DotdartLottieAnimationState<T extends StatefulWidget>
    on State<T>, SingleTickerProviderStateMixin<T>, WidgetsBindingObserver {
  double? get lottieWidgetWidth;
  double? get lottieWidgetHeight;
  double? get lottieProgress;
  Duration get lottieDelay;
  Duration? get lottieDuration;
  LottiePlayback get lottiePlayback;
  bool get lottieRespectDisableAnimations;
  bool get lottieMaintainAspectRatio;
  Duration get lottieNativeDuration;
  double get lottieCanvasWidth;
  double get lottieCanvasHeight;

  Widget buildPainter({required double width, required double height});

  late final AnimationController _controller;
  Timer? _delayTimer;
  Duration? _scheduledDelay;
  Duration? _activeDuration;
  LottiePlayback? _activePlayback;
  bool _hasCompletedInitialDelay = false;
  bool _canAnimateForLifecycle = true;

  bool _shouldAnimate() {
    final disableAnimations = lottieRespectDisableAnimations && (MediaQuery.maybeDisableAnimationsOf(context) ?? false);
    return lottieProgress == null && _canAnimateForLifecycle && !disableAnimations;
  }

  void _validateTiming() {
    if (lottieDelay.isNegative) {
      throw ArgumentError.value(lottieDelay, 'delay', 'must not be negative');
    }
    if (lottieDuration != null && lottieDuration! <= Duration.zero) {
      throw ArgumentError.value(
        lottieDuration,
        'duration',
        'must be greater than zero',
      );
    }
  }

  void _startPlayback() {
    final duration = lottieDuration ?? lottieNativeDuration;
    if (_controller.isAnimating && _activeDuration == duration && _activePlayback == lottiePlayback) {
      return;
    }
    _controller.stop();
    _controller.duration = duration;
    _activeDuration = duration;
    _activePlayback = lottiePlayback;
    switch (lottiePlayback) {
      case LottiePlayback.once:
        unawaited(_controller.forward());
      case LottiePlayback.loop:
        unawaited(_controller.repeat());
    }
  }

  void _syncController() {
    _validateTiming();
    if (!_shouldAnimate()) {
      _delayTimer?.cancel();
      _delayTimer = null;
      _scheduledDelay = null;
      _controller.stop();
      return;
    }

    if (_hasCompletedInitialDelay || lottieDelay == Duration.zero) {
      _hasCompletedInitialDelay = true;
      _delayTimer?.cancel();
      _delayTimer = null;
      _scheduledDelay = null;
      _startPlayback();
      return;
    }

    if ((_delayTimer?.isActive ?? false) && _scheduledDelay == lottieDelay) {
      return;
    }
    _delayTimer?.cancel();
    _scheduledDelay = lottieDelay;
    _delayTimer = Timer(lottieDelay, () {
      _delayTimer = null;
      _scheduledDelay = null;
      if (!_shouldAnimate()) return;
      _hasCompletedInitialDelay = true;
      _startPlayback();
    });
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
      duration: lottieNativeDuration,
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
    _delayTimer?.cancel();
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
    final hasExplicitSize = lottieWidgetWidth != null || lottieWidgetHeight != null;

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

/// Namespace for dotdart-generated widgets from `animated_icons/`.
///
/// Call a method named after each asset to render it:
///
/// ```dart
/// $AnimatedIcons.earthRotating(<params>);
/// ```
abstract final class $AnimatedIcons {
  $AnimatedIcons._();

  /// Builds the `EarthRotating` widget from `earthRotating.json`.
  static Widget earthRotating({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    bool clip = true,
    double? progress,
    Duration delay = Duration.zero,
    Duration? duration,
    LottiePlayback playback = LottiePlayback.once,
    bool respectDisableAnimations = true,
    EarthRotatingOverrides overrides = const EarthRotatingOverrides(),
  }) => _EarthRotating(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    clip: clip,
    progress: progress,
    delay: delay,
    duration: duration,
    playback: playback,
    respectDisableAnimations: respectDisableAnimations,
    overrides: overrides,
  );

  /// Builds the asset matching [fileName], or returns null if it is absent.
  ///
  /// Pass the original filename, including its extension and exact case.
  /// Directory paths and extensionless names do not match.
  /// [key] is forwarded to the generated widget. [width] and [height] are
  /// logical pixels and use the same sizing rules as the named accessor.
  /// All asset-specific options keep their defaults.
  static Widget? findByName(
    String fileName, {
    Key? key,
    double? width,
    double? height,
  }) => switch (fileName) {
    'earth-rotating.json' => earthRotating(
      key: key,
      width: width,
      height: height,
    ),
    _ => null,
  };
}

/// Text and color values that replace defaults in `earth-rotating.json`.
final class EarthRotatingOverrides {
  /// Creates Lottie value overrides.
  const EarthRotatingOverrides({this.color1, this.color2, this.color3});

  /// Replacement color for the `unnamed shape` Lottie layer.
  final Color? color1;

  /// Replacement color for the `unnamed shape` Lottie layer.
  final Color? color2;

  /// Replacement color for the `unnamed shape` Lottie layer.
  final Color? color3;
}

/// A dotdart-generated animated widget from `assets/animated_icons/earth-rotating.json`.
///
/// Renders a 6000ms animation
/// (360 frames at 60.0Hz)
/// on a 20×20 canvas.
/// No Lottie runtime dependency — the animation is drawn
/// entirely via [CustomPainter].
class _EarthRotating extends StatefulWidget {
  const _EarthRotating({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.clip = true,
    this.progress,
    this.delay = Duration.zero,
    this.duration,
    this.playback = LottiePlayback.once,
    this.respectDisableAnimations = true,
    this.overrides = const EarthRotatingOverrides(),
  });

  static const double _lottieWidth = 20;
  static const double _lottieHeight = 20;
  static const int _totalFrames = 360;
  static const Duration _nativeDuration = Duration(milliseconds: 6000);

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Whether painting is clipped to the Lottie canvas bounds.
  final bool clip;

  /// Fixed animation progress from 0 to 1.
  final double? progress;

  /// Non-negative time to wait once before automatic playback starts.
  final Duration delay;

  /// Positive total playback time. When null, uses the duration from the Lottie file.
  final Duration? duration;

  /// Whether automatic playback runs once or loops continuously.
  final LottiePlayback playback;

  /// Whether reduced-motion settings pause playback.
  final bool respectDisableAnimations;

  /// Text and color values that replace defaults from the Lottie file.
  final EarthRotatingOverrides overrides;

  @override
  State<_EarthRotating> createState() => _EarthRotatingState();
}

class _EarthRotatingState extends State<_EarthRotating>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver, _DotdartLottieAnimationState<_EarthRotating> {
  @override
  double? get lottieWidgetWidth => widget.width;

  @override
  double? get lottieWidgetHeight => widget.height;

  @override
  bool get lottieMaintainAspectRatio => widget.maintainAspectRatio;

  @override
  double? get lottieProgress => widget.progress;

  @override
  Duration get lottieDelay => widget.delay;

  @override
  Duration? get lottieDuration => widget.duration;

  @override
  LottiePlayback get lottiePlayback => widget.playback;

  @override
  bool get lottieRespectDisableAnimations => widget.respectDisableAnimations;

  @override
  Duration get lottieNativeDuration => _EarthRotating._nativeDuration;

  @override
  double get lottieCanvasWidth => _EarthRotating._lottieWidth;

  @override
  double get lottieCanvasHeight => _EarthRotating._lottieHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _EarthRotatingPainter(
            animationProgress: widget.progress == null ? _controller : null,
            fixedProgress: (widget.progress ?? 0).clamp(0, 1).toDouble(),
            canvasScaleX: width / _EarthRotating._lottieWidth,
            canvasScaleY: height / _EarthRotating._lottieHeight,
            canvasRect: Rect.fromLTWH(0, 0, width, height),
            clip: widget.clip,
            overrides: widget.overrides,
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _EarthRotatingPainter extends CustomPainter {
  _EarthRotatingPainter({
    required this._fixedProgress,
    required this._canvasScaleX,
    required this._canvasScaleY,
    required this._canvasRect,
    required this.clip,
    required this.overrides,
    this._animationProgress,
  }) : super(repaint: _animationProgress);

  final double _fixedProgress;
  final double _canvasScaleX;
  final double _canvasScaleY;
  final Rect _canvasRect;
  final Animation<double>? _animationProgress;

  final bool clip;

  final EarthRotatingOverrides overrides;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;
  final Paint _strokePaint = Paint()..style = PaintingStyle.stroke;
  final Paint _eraseFillPaint = Paint()
    ..style = PaintingStyle.fill
    ..blendMode = BlendMode.dstOut;
  final Paint _matteContentPaint = Paint();
  final Paint _invertedAlphaPaint = Paint()..blendMode = BlendMode.dstOut;

  double _keyframes0PositionX(double frame) {
    if (frame <= 0) return 11.1618;
    if (frame >= 360) return -19.0328;
    if (frame < 360) {
      final t = frame / 360;
      final eased = t;
      return 11.1618 + -30.1946 * eased;
    }
    return -19.0328;
  }

  static final Path __treePath0_0_0 = Path()
    ..moveTo(-55, 107)
    ..cubicTo(-38.1, 107.6, -25.5, 122, -9, 122)
    ..cubicTo(8, 122, 38.2, 89.3, 51.1, 119.7)
    ..cubicTo(56.5, 132.5, 33.4, 146, 26.1, 153.3)
    ..cubicTo(14.9, 164.6, 2.4, 201.6, -8.4, 208)
    ..cubicTo(-25.5, 218.1, -45.3, 188.6, -63.1, 213.4)
    ..cubicTo(-75.7, 231, -48.3, 230.1, -41, 236.8)
    ..cubicTo(-37.5, 240.1, -16.8, 266.1, -30.3, 267)
    ..cubicTo(-40.6, 267.7, -46.8, 254.9, -56, 252.4)
    ..cubicTo(-90, 243.3, -113.2, 244.8, -132.4, 208.5)
    ..cubicTo(-156.3, 163.5, -98.2, 108.6, -55, 107)
    ..close();

  static final Path __treePath0_0_1 = Path()
    ..moveTo(271, 125)
    ..cubicTo(286.7, 125, 259.4, 150.5, 252, 151)
    ..cubicTo(236.7, 152.1, 264.3, 126, 271, 125)
    ..close();

  static final Path __treePath0_0_2 = Path()
    ..moveTo(459, 323)
    ..cubicTo(531.5, 324.8, 498.9, 409.4, 473, 409)
    ..cubicTo(460.9, 408.8, 464.2, 392.5, 455.5, 390.4)
    ..cubicTo(440.8, 386.8, 421.5, 403.1, 411.6, 385)
    ..cubicTo(399.1, 362, 443, 323.6, 459, 323)
    ..close();

  static final Path __treePath0_0_3 = Path()
    ..moveTo(509, 299)
    ..cubicTo(521.6, 302.6, 529.1, 332.6, 517.3, 329.9)
    ..cubicTo(505, 327, 491.7, 295.8, 509, 299)
    ..close();

  static final Path __treePath0_0_4 = Path()
    ..moveTo(19, 258.7)
    ..cubicTo(36, 259.8, 51.6, 272.5, 66.2, 280.1)
    ..cubicTo(76.1, 285.2, 88.9, 286, 97.7, 292.8)
    ..cubicTo(129.5, 317.4, 72.2, 371.2, 56.1, 387.8)
    ..cubicTo(46.2, 398, 33.4, 424.7, 17.7, 424.6)
    ..cubicTo(-9.9, 424.5, 7, 372.2, 2.7, 357.3)
    ..cubicTo(-1.2, 344.1, -14.3, 335.3, -18.9, 322)
    ..cubicTo(-28, 295.9, -10.7, 260.4, 19, 258.7)
    ..close();

  static final Path __treePath0_0_5 = Path()
    ..moveTo(396, 104)
    ..cubicTo(419, 104.4, 500.3, 113.9, 505.9, 143.5)
    ..cubicTo(509.1, 160.6, 490.8, 158.7, 485.6, 169.4)
    ..cubicTo(481.6, 177.7, 488, 187.8, 482.6, 196.7)
    ..cubicTo(475.2, 208.9, 452.8, 215.6, 451.1, 231.1)
    ..cubicTo(449.8, 242.9, 463.3, 250.9, 461.9, 262.3)
    ..cubicTo(460.9, 269.9, 449.9, 272.4, 451.1, 280.5)
    ..cubicTo(455.2, 307.8, 481.3, 273.5, 484.7, 275.8)
    ..cubicTo(494.6, 282.4, 486.1, 296.1, 480.2, 302)
    ..cubicTo(458.1, 324.1, 444.3, 285.4, 433.4, 272.1)
    ..cubicTo(428.4, 266, 420.6, 265, 416.1, 259)
    ..cubicTo(409.5, 250.2, 404.7, 236.2, 393.6, 231.9)
    ..cubicTo(369, 222.4, 358.3, 282.6, 333.1, 271)
    ..cubicTo(324.3, 266.9, 319.6, 231, 312.1, 235.8)
    ..cubicTo(302.9, 241.7, 320.9, 274.3, 321.7, 282.5)
    ..cubicTo(324.4, 309.7, 311.6, 330, 298.1, 352.8)
    ..cubicTo(292.5, 362.3, 282.2, 382.7, 269, 383)
    ..cubicTo(246.7, 383.4, 240.1, 326.8, 229, 311)
    ..cubicTo(216, 292.3, 167.2, 285.9, 180, 254.2)
    ..cubicTo(188.2, 233.8, 214.4, 219.5, 235.8, 220)
    ..cubicTo(245, 220.2, 293.2, 242.9, 289.9, 221.5)
    ..cubicTo(288.9, 214.6, 281.2, 210.4, 276.8, 205.8)
    ..cubicTo(246.8, 174.5, 212.3, 222.2, 213, 195)
    ..cubicTo(213.8, 165.1, 254.4, 165.3, 271.7, 154.6)
    ..cubicTo(284.8, 146.5, 294.2, 133.3, 308.7, 127.1)
    ..cubicTo(318.8, 122.8, 329.5, 127.2, 339.7, 124.1)
    ..cubicTo(359.9, 118, 373.4, 104.4, 396, 104)
    ..close();

  static final Path __treePath0_0_6 = Path()
    ..moveTo(785, 107)
    ..cubicTo(801.9, 107.6, 814.5, 122, 831, 122)
    ..cubicTo(848, 122, 878.2, 89.3, 891.1, 119.7)
    ..cubicTo(896.5, 132.5, 873.4, 146, 866.1, 153.3)
    ..cubicTo(854.9, 164.6, 842.4, 201.6, 831.6, 208)
    ..cubicTo(814.5, 218.1, 794.7, 188.6, 776.9, 213.4)
    ..cubicTo(764.3, 231, 791.7, 230.1, 799, 236.8)
    ..cubicTo(802.5, 240.1, 823.2, 266.1, 809.7, 267)
    ..cubicTo(799.4, 267.7, 793.2, 254.9, 784, 252.4)
    ..cubicTo(750, 243.3, 726.8, 244.8, 707.6, 208.5)
    ..cubicTo(683.7, 163.5, 741.8, 108.6, 785, 107)
    ..close();

  static final Path __treePath0_0_7 = Path()
    ..moveTo(859, 258.7)
    ..cubicTo(876, 259.8, 891.6, 272.5, 906.2, 280.1)
    ..cubicTo(916.1, 285.2, 928.9, 286, 937.7, 292.8)
    ..cubicTo(969.5, 317.4, 912.2, 371.2, 896.1, 387.8)
    ..cubicTo(886.2, 398, 873.4, 424.7, 857.7, 424.6)
    ..cubicTo(830.1, 424.5, 847, 372.2, 842.7, 357.3)
    ..cubicTo(838.8, 344.1, 825.7, 335.3, 821.1, 322)
    ..cubicTo(812, 295.9, 829.3, 260.4, 859, 258.7)
    ..close();

  static final Path _treePaintPath0_0_8 = Path()
    ..addPath(__treePath0_0_0, Offset.zero)
    ..addPath(__treePath0_0_1, Offset.zero)
    ..addPath(__treePath0_0_2, Offset.zero)
    ..addPath(__treePath0_0_3, Offset.zero)
    ..addPath(__treePath0_0_4, Offset.zero)
    ..addPath(__treePath0_0_5, Offset.zero)
    ..addPath(__treePath0_0_6, Offset.zero)
    ..addPath(__treePath0_0_7, Offset.zero);

  static final Path _treePaintPath1_0_1 = Path()
    ..addOval(
      Rect.fromCenter(
        center: const Offset(10.0086, 9.9886),
        width: 14.0849,
        height: 14.0849,
      ),
    );

  static final Path _treePaintPath2_0_1 = Path()
    ..addOval(
      Rect.fromCenter(
        center: const Offset(10.0086, 9.9886),
        width: 14.0849,
        height: 14.0849,
      ),
    );

  @override
  void paint(Canvas canvas, Size size) {
    final progress = _animationProgress?.value ?? _fixedProgress;
    final frame = math.min(359.999999, progress * _EarthRotating._totalFrames);

    canvas.save();
    if (clip) canvas.clipRect(_canvasRect);
    canvas.scale(_canvasScaleX, _canvasScaleY);

    _draw2(canvas, frame, 1);
    final matteBounds1 = canvas.getLocalClipBounds();
    canvas.saveLayer(matteBounds1, _matteContentPaint);
    _draw1(canvas, frame, 1);
    _erase0(canvas, frame, 1);
    canvas.restore();

    canvas.restore();
  }

  void _draw0(Canvas canvas, double frame, double inheritedOpacity) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    final posX = _keyframes0PositionX(frame);
    canvas.save();
    canvas.translate(posX, 0.7861);
    canvas.scale(0.0359, 0.0359);
    // Group:
    final treeFillPaint0_8 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.color1 ?? const Color(0xffffffff),
        layerOpacity * 1,
      );
    canvas.drawPath(_treePaintPath0_0_8, treeFillPaint0_8);
    canvas.restore();
  }

  void _draw1(Canvas canvas, double frame, double inheritedOpacity) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    // Group:
    final treeFillPaint0_1 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.color2 ?? const Color(0xff000000),
        layerOpacity * 1,
      );
    canvas.drawPath(_treePaintPath1_0_1, treeFillPaint0_1);
  }

  void _draw2(Canvas canvas, double frame, double inheritedOpacity) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    // Group:
    final treeStrokePaint0_1 = _strokePaint
      ..color = _dotdartApplyOpacity(
        overrides.color3 ?? const Color(0xff000000),
        layerOpacity * 1,
      )
      ..strokeWidth = 1.4319
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    canvas.drawPath(_treePaintPath2_0_1, treeStrokePaint0_1);
  }

  void _erase0(Canvas canvas, double frame, double inheritedOpacity) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    final posX = _keyframes0PositionX(frame);
    canvas.save();
    canvas.translate(posX, 0.7861);
    canvas.scale(0.0359, 0.0359);
    // Group:
    final treeFillPaint0_8 = _eraseFillPaint
      ..color = _dotdartApplyOpacity(
        overrides.color1 ?? const Color(0xffffffff),
        layerOpacity * 1,
      );
    canvas.drawPath(_treePaintPath0_0_8, treeFillPaint0_8);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _EarthRotatingPainter oldDelegate) {
    return oldDelegate._fixedProgress != _fixedProgress ||
        oldDelegate._canvasScaleX != _canvasScaleX ||
        oldDelegate._canvasScaleY != _canvasScaleY ||
        oldDelegate._canvasRect != _canvasRect ||
        oldDelegate._animationProgress != _animationProgress ||
        oldDelegate.clip != clip ||
        oldDelegate.overrides != overrides;
  }
}
