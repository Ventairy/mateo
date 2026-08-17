part of '../mateo_page.dart';

final class _MateoWashPageTransitionView extends StatefulWidget {
  const _MateoWashPageTransitionView({
    required this.animation,
    required this.direction,
    required this.allowSnapshotting,
    required this.useLinearProgress,
    required this.child,
  });

  final Animation<double> animation;
  final MateoPageTransitionDirection direction;
  final bool allowSnapshotting;
  final bool useLinearProgress;
  final Widget child;

  @override
  State<_MateoWashPageTransitionView> createState() => _MateoWashPageTransitionViewState();
}

final class _MateoWashPageTransitionViewState extends State<_MateoWashPageTransitionView> {
  final _snapshotController = SnapshotController();
  late _MateoWashPageTransitionPainter _painter;

  bool get _canSnapshot => !kIsWeb && widget.allowSnapshotting;

  @override
  void initState() {
    super.initState();
    _painter = _createPainter();
    widget.animation.addStatusListener(_handleAnimationStatus);
    _updateSnapshotting();
  }

  @override
  void didUpdateWidget(covariant _MateoWashPageTransitionView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.animation != widget.animation) {
      oldWidget.animation.removeStatusListener(_handleAnimationStatus);
      widget.animation.addStatusListener(_handleAnimationStatus);
      _replacePainter();
    } else {
      _painter.updateConfiguration(
        direction: widget.direction,
        useLinearProgress: widget.useLinearProgress,
      );
    }

    _updateSnapshotting();
  }

  void _handleAnimationStatus(AnimationStatus _) {
    _updateSnapshotting();
  }

  void _updateSnapshotting() {
    _snapshotController.allowSnapshotting = _canSnapshot && widget.animation.isAnimating;
  }

  _MateoWashPageTransitionPainter _createPainter() {
    return _MateoWashPageTransitionPainter(
      animation: widget.animation,
      direction: widget.direction,
      useLinearProgress: widget.useLinearProgress,
    );
  }

  void _replacePainter() {
    _painter.dispose();
    _painter = _createPainter();
  }

  @override
  Widget build(BuildContext context) {
    return SnapshotWidget(
      controller: _snapshotController,
      painter: _painter,
      // Live platform views can escape above the shader-based reveal.
      mode: SnapshotMode.forced,
      autoresize: true,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    widget.animation.removeStatusListener(_handleAnimationStatus);
    _painter.dispose();
    _snapshotController.dispose();
    super.dispose();
  }
}

final class _MateoWashPageTransitionPainter extends SnapshotPainter {
  _MateoWashPageTransitionPainter({
    required this.animation,
    required this._direction,
    required this._useLinearProgress,
  }) {
    animation
      ..addListener(notifyListeners)
      ..addStatusListener(_handleAnimationStatus);
  }

  static const _edgeSoftness = 280.0;
  static const _activeBoundsPadding = 1.0;
  static const _featherSampleCount = 16;
  static const _openingRadiusStart = 0.35;
  static const _openingFadeEnd = 0.06;
  static const _closingRadiusBrakeStart = 0.65;
  static const _closingRadiusHold = 0.35;
  static const _closingFadeStart = 0.55;
  // Sixteen equal samples and their inverse smoothstep opacity values avoid
  // building lookup tables during the first transition frame.
  static const _featherProgress = <double>[
    0,
    0.0625,
    0.125,
    0.1875,
    0.25,
    0.3125,
    0.375,
    0.4375,
    0.5,
    0.5625,
    0.625,
    0.6875,
    0.75,
    0.8125,
    0.875,
    0.9375,
    1,
  ];
  static const _featherOpacity = <double>[
    1,
    0.98876953125,
    0.95703125,
    0.90771484375,
    0.84375,
    0.76806640625,
    0.68359375,
    0.59326171875,
    0.5,
    0.40673828125,
    0.31640625,
    0.23193359375,
    0.15625,
    0.09228515625,
    0.04296875,
    0.01123046875,
    0,
  ];
  static final _opacityRamps = List<List<Color>?>.filled(
    256,
    null,
    growable: false,
  );

  final Animation<double> animation;
  Paint? _snapshotPaint;
  final LayerHandle<ShaderMaskLayer> _gradientLayer = LayerHandle<ShaderMaskLayer>();
  LayerHandle<ClipRectLayer>? _clipLayer;
  late final PaintingContextCallback _paintLiveCallback = _paintLiveChild;
  late final PaintingContextCallback _paintSnapshotCallback = _paintSnapshotChild;
  final _gradientStops = List<double>.filled(
    _featherSampleCount + 1,
    0,
    growable: false,
  );

  MateoPageTransitionDirection _direction;
  bool _useLinearProgress;
  int _centerAlpha = 0;
  double _maximumRadius = 0;
  double _activeBoundsRadius = -1;
  double _gradientStopsRadius = -1;
  double _shaderRadius = -1;
  int _shaderCenterAlpha = -1;
  double _snapshotPixelRatio = 1;
  double _snapshotSourcePixelRatio = -1;
  PaintingContextCallback? _livePainter;
  ui.Image? _snapshotImage;
  Offset _origin = Offset.zero;
  Offset _gradientCenter = Offset.zero;
  ui.Shader? _revealShader;
  Size? _geometrySize;
  Rect _activeLocalRect = Rect.zero;
  Rect _activeRect = Rect.zero;
  Rect _snapshotSourceLocalRect = Rect.zero;
  Rect _snapshotSourceRect = Rect.zero;
  Offset? _activeBoundsOffset;

  void updateConfiguration({
    required MateoPageTransitionDirection direction,
    required bool useLinearProgress,
  }) {
    if (_direction == direction && _useLinearProgress == useLinearProgress) {
      return;
    }
    if (_direction != direction) _geometrySize = null;
    _direction = direction;
    _useLinearProgress = useLinearProgress;
    notifyListeners();
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (!status.isAnimating) {
      _gradientLayer.layer = null;
      _clipLayer?.layer = null;
      _revealShader = null;
    }
    notifyListeners();
  }

  @override
  void paintSnapshot(
    PaintingContext context,
    Offset offset,
    Size size,
    ui.Image image,
    Size sourceSize,
    double pixelRatio,
  ) {
    _clipLayer?.layer = null;
    _snapshotImage = image;
    _snapshotPixelRatio = pixelRatio;
    _paintWithGradient(context, offset, size, _paintSnapshotCallback);
    _snapshotImage = null;
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset,
    Size size,
    PaintingContextCallback painter,
  ) {
    if (!animation.isAnimating) {
      if (animation.isCompleted) painter(context, offset);
      return;
    }

    _livePainter = painter;
    _paintWithGradient(context, offset, size, _paintLiveCallback);
    _livePainter = null;
  }

  void _paintLiveChild(PaintingContext context, Offset offset) {
    final clipLayer = _clipLayer ??= LayerHandle<ClipRectLayer>();
    clipLayer.layer = context.pushClipRect(
      true,
      offset,
      _activeLocalRect,
      _livePainter!,
      clipBehavior: Clip.hardEdge,
      oldLayer: clipLayer.layer,
    );
  }

  void _paintSnapshotChild(PaintingContext context, Offset offset) {
    final pixelRatio = _snapshotPixelRatio;
    if (_snapshotSourceLocalRect != _activeLocalRect || _snapshotSourcePixelRatio != pixelRatio) {
      _snapshotSourceLocalRect = _activeLocalRect;
      _snapshotSourcePixelRatio = pixelRatio;
      _snapshotSourceRect = Rect.fromLTRB(
        _activeLocalRect.left * pixelRatio,
        _activeLocalRect.top * pixelRatio,
        _activeLocalRect.right * pixelRatio,
        _activeLocalRect.bottom * pixelRatio,
      );
    }
    context.canvas.drawImageRect(
      _snapshotImage!,
      _snapshotSourceRect,
      _activeRect,
      _snapshotPaint ??= Paint(),
    );
  }

  void _paintWithGradient(
    PaintingContext context,
    Offset offset,
    Size size,
    PaintingContextCallback painter,
  ) {
    _updateGradient(offset: offset, size: size);
    if (_centerAlpha == 0) return;

    final layer = (_gradientLayer.layer ??= ShaderMaskLayer())
      ..shader = _revealShader
      ..maskRect = _activeRect
      ..blendMode = BlendMode.dstIn;
    context.pushLayer(
      layer,
      painter,
      offset,
      childPaintBounds: _activeRect,
    );
  }

  void _updateGradient({required Offset offset, required Size size}) {
    if (_geometrySize != size) {
      _geometrySize = size;
      _activeBoundsRadius = -1;
      _revealShader = null;
      _origin = switch (_direction) {
        MateoPageTransitionDirection.up => Offset(
          size.width / 2,
          size.height,
        ),
        MateoPageTransitionDirection.down => Offset(size.width / 2, 0),
        MateoPageTransitionDirection.left => Offset(
          size.width,
          size.height / 2,
        ),
        MateoPageTransitionDirection.right => Offset(0, size.height / 2),
      };
      final horizontalDistance = math.max(
        _origin.dx,
        size.width - _origin.dx,
      );
      final verticalDistance = math.max(
        _origin.dy,
        size.height - _origin.dy,
      );
      _maximumRadius =
          math.sqrt(
            horizontalDistance * horizontalDistance + verticalDistance * verticalDistance,
          ) +
          _edgeSoftness;
    }
    final routeProgress = animation.value;
    final isClosing = animation.status == AnimationStatus.reverse;
    final curvedProgress = _useLinearProgress
        ? routeProgress
        : isClosing
        ? _mateoPageEaseOutQuad.transform(routeProgress)
        : _mateoPageEaseInOutSine.transform(routeProgress);
    final radiusProgress = _useLinearProgress
        ? routeProgress
        : _resolveRadiusProgress(
            progress: curvedProgress,
            isClosing: isClosing,
          );
    final fadeProgress = _resolveFadeProgress(
      progress: routeProgress,
      isClosing: isClosing,
    );
    final opacity = _useLinearProgress || fadeProgress == 0 || fadeProgress == 1
        ? fadeProgress
        : _mateoPageEaseInOutCubic.transform(fadeProgress);
    _centerAlpha = (opacity * 255).round();
    if (_centerAlpha == 0) {
      _revealShader = null;
      return;
    }

    final radius = _maximumRadius * radiusProgress;
    if (_activeBoundsRadius != radius || _activeBoundsOffset != offset) {
      _activeBoundsRadius = radius;
      _activeBoundsOffset = offset;
      final paddedRadius = radius + _activeBoundsPadding;
      _activeLocalRect = Rect.fromLTRB(
        math.max(0, (_origin.dx - paddedRadius).floorToDouble()),
        math.max(0, (_origin.dy - paddedRadius).floorToDouble()),
        math.min(size.width, (_origin.dx + paddedRadius).ceilToDouble()),
        math.min(size.height, (_origin.dy + paddedRadius).ceilToDouble()),
      );
      _activeRect = offset == Offset.zero ? _activeLocalRect : _activeLocalRect.shift(offset);
      _gradientCenter = Offset(
        _origin.dx - _activeLocalRect.left,
        _origin.dy - _activeLocalRect.top,
      );
    }
    if (_gradientStopsRadius != radius) {
      _gradientStopsRadius = radius;
      final opaqueStop = math.max(0, radius - _edgeSoftness) / radius;
      final featherSpan = 1 - opaqueStop;
      for (var index = 0; index <= _featherSampleCount; index++) {
        _gradientStops[index] = opaqueStop + featherSpan * _featherProgress[index];
      }
    }
    if (_revealShader == null || _shaderRadius != radius || _shaderCenterAlpha != _centerAlpha) {
      _shaderRadius = radius;
      _shaderCenterAlpha = _centerAlpha;
      _revealShader = ui.Gradient.radial(
        _gradientCenter,
        radius,
        _opacityRampFor(_centerAlpha),
        _gradientStops,
      );
    }
  }

  double _resolveFadeProgress({
    required double progress,
    required bool isClosing,
  }) {
    if (_useLinearProgress) return progress;
    if (isClosing) {
      return progress >= _closingFadeStart ? 1 : progress / _closingFadeStart;
    }
    return progress >= _openingFadeEnd ? 1 : progress / _openingFadeEnd;
  }

  static List<Color> _opacityRampFor(int centerAlpha) {
    final cachedRamp = _opacityRamps[centerAlpha];
    if (cachedRamp != null) return cachedRamp;

    final ramp = List<Color>.filled(
      _featherSampleCount + 1,
      const Color(0x00000000),
      growable: false,
    );
    for (var index = 0; index <= _featherSampleCount; index++) {
      final alpha = (centerAlpha * _featherOpacity[index]).round();
      ramp[index] = _mateoWhiteWithAlpha(alpha);
    }
    return _opacityRamps[centerAlpha] = ramp;
  }

  double _resolveRadiusProgress({
    required double progress,
    required bool isClosing,
  }) {
    if (!isClosing) {
      return _openingRadiusStart + (1 - _openingRadiusStart) * progress;
    }
    if (progress >= _closingRadiusBrakeStart) return progress;
    if (progress <= _closingRadiusHold) return _closingRadiusHold;

    final brakeProgress = (progress - _closingRadiusHold) / (_closingRadiusBrakeStart - _closingRadiusHold);
    final easedBrakeProgress = brakeProgress * brakeProgress * (2 - brakeProgress);

    return _closingRadiusHold + (_closingRadiusBrakeStart - _closingRadiusHold) * easedBrakeProgress;
  }

  @override
  bool shouldRepaint(covariant _MateoWashPageTransitionPainter oldPainter) {
    return animation != oldPainter.animation ||
        _direction != oldPainter._direction ||
        _useLinearProgress != oldPainter._useLinearProgress;
  }

  @override
  void dispose() {
    animation
      ..removeListener(notifyListeners)
      ..removeStatusListener(_handleAnimationStatus);
    _gradientLayer.layer = null;
    _clipLayer?.layer = null;
    _livePainter = null;
    _snapshotImage = null;
    _revealShader = null;
    super.dispose();
  }
}
