part of 'mateo_skeleton.dart';

class _RenderMateoSkeleton extends RenderProxyBox {
  _RenderMateoSkeleton({
    required this._colorScheme,
    required this._style,
    required this._boneColor,
    required this._effectAnimation,
  }) {
    _solidSkeletonPaint.color = _boneColor;
  }

  final Paint _solidSkeletonPaint = Paint();
  final _MateoSkeletonLeafRegistry _leafRegistry = _MateoSkeletonLeafRegistry();

  MateoColorScheme _colorScheme;
  MateoSkeletonStyle? _style;
  Color _boneColor;
  Animation<double>? _effectAnimation;

  MateoColorScheme get colorScheme => _colorScheme;
  MateoSkeletonStyle? get style => _style;
  Color get boneColor => _boneColor;
  MateoSkeletonEffect? get effect => _style?.effect;
  Radius? get textRadius => _style?.textRadius;
  Animation<double>? get effectAnimation => _effectAnimation;

  set colorScheme(MateoColorScheme value) {
    if (value == _colorScheme) return;
    _colorScheme = value;

    markNeedsPaint();
  }

  set style(MateoSkeletonStyle? value) {
    if (value == _style) return;
    _style = value;
    markNeedsPaint();
  }

  set boneColor(Color value) {
    if (value == _boneColor) return;
    _boneColor = value;
    _solidSkeletonPaint.color = value;
    markNeedsPaint();
  }

  set effectAnimation(Animation<double>? value) {
    if (identical(value, _effectAnimation)) return;
    _effectAnimation?.removeListener(markNeedsPaint);
    _effectAnimation = value;
    _effectAnimation?.addListener(markNeedsPaint);
    if (value != null) markNeedsPaint();
  }

  @override
  bool get alwaysNeedsCompositing => true;

  @override
  bool get isRepaintBoundary => true;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _effectAnimation?.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _effectAnimation?.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final bounds = offset & size;
    _leafRegistry.clear();

    final skeletonPaint = _buildSkeletonPaint(bounds);
    final skeletonLayer = OffsetLayer();

    context.pushLayer(
      skeletonLayer,
      (layerContext, layerOffset) {
        final skeletonContext = _MateoSkeletonPaintingContext(
          skeletonLayer,
          bounds,
          _leafRegistry,
          skeletonPaint,
          _style?.textRadius,
        );

        if (_style?.effect != null && _effectAnimation != null) {
          skeletonContext.setWillChangeHint();
        }

        super.paint(skeletonContext, layerOffset);
        skeletonContext.finish();
      },
      offset,
      childPaintBounds: bounds,
    );
  }

  Paint _buildSkeletonPaint(Rect bounds) {
    final effect = _style?.effect;
    if (effect == null) return _solidSkeletonPaint;

    final t = _effectAnimation?.value ?? 0.0;
    return effect.buildPaint(
      bounds: bounds,
      t: t,
      colorScheme: _colorScheme,
      style: _style!,
    );
  }
}
