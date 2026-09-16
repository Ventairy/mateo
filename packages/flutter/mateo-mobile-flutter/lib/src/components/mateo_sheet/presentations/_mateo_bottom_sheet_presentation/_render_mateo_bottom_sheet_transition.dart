part of '../../mateo_sheet.dart';

class _RenderMateoBottomSheetTransition extends RenderProxyBox {
  _RenderMateoBottomSheetTransition(this._animation, this._isInteractive);

  final Matrix4 _transform = Matrix4.identity();
  Animation<double> _animation;
  ValueGetter<bool> _isInteractive;
  double _cachedProgress = double.nan;
  Size _cachedSize = Size.zero;

  Animation<double> get animation => _animation;

  set animation(Animation<double> value) {
    if (identical(value, _animation)) return;

    if (attached) _animation.removeListener(_handleAnimationChanged);
    _animation = value;
    if (attached) _animation.addListener(_handleAnimationChanged);
    _invalidateTransform();
  }

  ValueGetter<bool> get isInteractive => _isInteractive;

  set isInteractive(ValueGetter<bool> value) {
    if (identical(value, _isInteractive)) return;

    _isInteractive = value;
    _invalidateTransform();
  }

  double _scaleAt(double progress) =>
      _MateoBottomSheetPresentation._initialScale + (1 - _MateoBottomSheetPresentation._initialScale) * progress;

  Offset _translationAt(double progress, Size size) {
    final scaleOffset = 1 - _scaleAt(progress);
    return Offset(
      (scaleOffset * (_MateoBottomSheetPresentation._alignment.x + 1) / 2 +
              _MateoBottomSheetPresentation._exitDirection.dx * (1 - progress)) *
          size.width,
      (scaleOffset * (_MateoBottomSheetPresentation._alignment.y + 1) / 2 +
              _MateoBottomSheetPresentation._exitDirection.dy * (1 - progress)) *
          size.height,
    );
  }

  @visibleForTesting
  double get currentScale => _scaleAt(_resolveProgress());

  @visibleForTesting
  double get currentVerticalTranslation => 1 - _resolveProgress();

  double _resolveProgress() {
    final value = _animation.value;
    if (_isInteractive()) return value;

    final curve = _animation.status == AnimationStatus.reverse
        ? _MateoBottomSheetPresentation._exitCurve
        : _MateoBottomSheetPresentation._entranceCurve;
    return curve.transform(value);
  }

  void _handleAnimationChanged() {
    _cachedProgress = double.nan;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  void _invalidateTransform() {
    _cachedProgress = double.nan;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  Matrix4 _resolveTransform() {
    final progress = _resolveProgress();
    if (_cachedProgress == progress && _cachedSize == size) return _transform;

    _cachedProgress = progress;
    _cachedSize = size;
    final scale = _scaleAt(progress);
    final translation = _translationAt(progress, size);
    final storage = _transform.storage;
    storage[0] = scale;
    storage[5] = scale;
    storage[12] = translation.dx;
    storage[13] = translation.dy;
    return _transform;
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _animation.addListener(_handleAnimationChanged);
  }

  @override
  void detach() {
    _animation.removeListener(_handleAnimationChanged);
    super.detach();
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) => hitTestChildren(result, position: position);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) => result.addWithPaintTransform(
    transform: _resolveTransform(),
    position: position,
    hitTest: (result, position) => super.hitTestChildren(result, position: position),
  );

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;

    final transform = _resolveTransform();
    if (_cachedProgress == 1) {
      super.paint(context, offset);
      layer = null;
      return;
    }

    layer = context.pushTransform(
      needsCompositing,
      offset,
      transform,
      super.paint,
      oldLayer: layer is TransformLayer ? layer as TransformLayer? : null,
    );
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    transform.multiply(_resolveTransform());
  }
}
