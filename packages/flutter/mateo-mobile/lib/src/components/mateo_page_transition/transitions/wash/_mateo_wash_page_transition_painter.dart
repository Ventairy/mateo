part of '../../mateo_page_transition.dart';

final class _MateoWashPageTransitionPainter extends SnapshotPainter {
  _MateoWashPageTransitionPainter({
    required this.animation,
    required this._transition,
    required this._useLinearProgress,
  }) {
    animation
      ..addListener(notifyListeners)
      ..addStatusListener(_handleStatus);
  }

  // The feather belongs to reveal geometry, independently of route timing.
  static const _edgeSoftness = 280.0;
  static const _featherSamples = 16;
  static final _opacityRamps = List<List<Color>?>.filled(256, null);

  final Animation<double> animation;
  final _gradientLayer = LayerHandle<ShaderMaskLayer>();
  final _clipLayer = LayerHandle<ClipRectLayer>();
  final _snapshotPaint = Paint();
  final _stops = List<double>.filled(_featherSamples + 1, 0);
  MateoPageTransitionWash _transition;
  bool _useLinearProgress;
  bool? _closing;

  void updateConfiguration({required MateoPageTransitionWash transition, required bool useLinearProgress}) {
    if (_transition == transition && _useLinearProgress == useLinearProgress) return;
    _transition = transition;
    // A cancelled/committed gesture settles with the same mapping as the drag.
    if (useLinearProgress || !animation.isAnimating) _useLinearProgress = useLinearProgress;
    notifyListeners();
  }

  void _handleStatus(AnimationStatus status) {
    if (!status.isAnimating) {
      _closing = null;
      _useLinearProgress = false;
      _gradientLayer.layer = null;
      _clipLayer.layer = null;
    }
    notifyListeners();
  }

  @override
  void paint(PaintingContext context, Offset offset, Size size, PaintingContextCallback painter) {
    if (!animation.isAnimating) {
      if (animation.isCompleted) painter(context, offset);
      return;
    }
    _paintReveal(context, offset, size, (context, offset, bounds) {
      _clipLayer.layer = context.pushClipRect(
        true,
        offset,
        bounds,
        painter,
        clipBehavior: .hardEdge,
        oldLayer: _clipLayer.layer,
      );
    });
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
    _clipLayer.layer = null;
    _paintReveal(context, offset, size, (context, offset, bounds) {
      context.canvas.drawImageRect(
        image,
        Rect.fromLTRB(
          bounds.left * pixelRatio,
          bounds.top * pixelRatio,
          bounds.right * pixelRatio,
          bounds.bottom * pixelRatio,
        ),
        bounds.shift(offset),
        _snapshotPaint,
      );
    });
  }

  void _paintReveal(
    PaintingContext context,
    Offset offset,
    Size size,
    void Function(PaintingContext, Offset, Rect) paintContent,
  ) {
    if (size.isEmpty) return;
    final progress = animation.value.clamp(0.0, 1.0);
    // A reversal before landing retraces the current reveal instead of switching
    // abruptly between the deliberately different opening and closing profiles.
    final closing = _closing ??= animation.status == .reverse;
    final fade = _useLinearProgress ? progress : (progress / (closing ? 0.55 : 0.06)).clamp(0.0, 1.0);
    final alpha = ((_useLinearProgress ? fade : _transition.opacityCurve.transform(fade)) * 255).round();
    if (alpha == 0) return;

    final origin = switch (_transition.direction) {
      .up => Offset(size.width / 2, size.height),
      .down => Offset(size.width / 2, 0),
      .left => Offset(size.width, size.height / 2),
      .right => Offset(0, size.height / 2),
    };
    final distance = Offset(
      math.max(origin.dx, size.width - origin.dx),
      math.max(origin.dy, size.height - origin.dy),
    ).distance;
    final radius = (distance + _edgeSoftness) * _radiusProgress(progress, closing: closing);
    if (radius <= 0) return;
    final bounds = Rect.fromLTRB(
      math.max(0, (origin.dx - radius - 1).floorToDouble()),
      math.max(0, (origin.dy - radius - 1).floorToDouble()),
      math.min(size.width, (origin.dx + radius + 1).ceilToDouble()),
      math.min(size.height, (origin.dy + radius + 1).ceilToDouble()),
    );
    final opaqueStop = math.max(0, radius - _edgeSoftness) / radius;
    for (var index = 0; index <= _featherSamples; index++) {
      _stops[index] = opaqueStop + (1 - opaqueStop) * index / _featherSamples;
    }
    final layer = (_gradientLayer.layer ??= ShaderMaskLayer())
      ..shader = ui.Gradient.radial(origin - bounds.topLeft, radius, _colors(alpha), _stops)
      ..maskRect = bounds.shift(offset)
      ..blendMode = .dstIn;
    context.pushLayer(
      layer,
      (context, offset) => paintContent(context, offset, bounds),
      offset,
      childPaintBounds: bounds.shift(offset),
    );
  }

  double _radiusProgress(double progress, {required bool closing}) {
    if (_useLinearProgress) return progress;
    if (!closing) return 0.35 + 0.65 * _transition.openingCurve.transform(progress);
    final curved = _transition.closingCurve.transform(progress);
    if (curved >= 0.65) return curved;
    if (curved <= 0.35) return 0.35;
    final brake = (curved - 0.35) / 0.30;
    return 0.35 + 0.30 * brake * brake * (2 - brake);
  }

  static List<Color> _colors(int alpha) => _opacityRamps[alpha] ??= List.generate(_featherSamples + 1, (index) {
    final progress = index / _featherSamples;
    final opacity = 1 - progress * progress * (3 - 2 * progress);
    return Color.fromARGB((alpha * opacity).round(), 255, 255, 255);
  }, growable: false);

  @override
  bool shouldRepaint(covariant _MateoWashPageTransitionPainter oldPainter) =>
      animation != oldPainter.animation ||
      _transition != oldPainter._transition ||
      _useLinearProgress != oldPainter._useLinearProgress;

  @override
  void dispose() {
    animation
      ..removeListener(notifyListeners)
      ..removeStatusListener(_handleStatus);
    _gradientLayer.layer = null;
    _clipLayer.layer = null;
    super.dispose();
  }
}
