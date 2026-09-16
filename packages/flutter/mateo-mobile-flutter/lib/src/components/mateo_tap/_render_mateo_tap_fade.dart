part of 'mateo_tap.dart';

class _RenderMateoTapFade extends RenderProxyBox {
  _RenderMateoTapFade(Animation<double> opacity)
    : _opacity = opacity,
      _alpha = Color.getAlphaFromOpacity(opacity.value);

  Animation<double> _opacity;
  int _alpha;

  Animation<double> get opacity => _opacity;
  set opacity(Animation<double> value) {
    if (_opacity == value) return;
    if (attached) _opacity.removeListener(_updateOpacity);
    _opacity = value;
    if (attached) _opacity.addListener(_updateOpacity);
    _updateOpacity();
  }

  @override
  bool get isRepaintBoundary => child != null && _alpha > 0 && _alpha < 255;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _opacity.addListener(_updateOpacity);
    _updateOpacity();
  }

  @override
  void detach() {
    _opacity.removeListener(_updateOpacity);
    super.detach();
  }

  void _updateOpacity() {
    final alpha = Color.getAlphaFromOpacity(_opacity.value);
    if (_alpha == alpha) return;
    final wasRepaintBoundary = isRepaintBoundary;
    final wasVisible = _alpha > 0;
    _alpha = alpha;
    if (wasRepaintBoundary != isRepaintBoundary) markNeedsCompositingBitsUpdate();
    markNeedsCompositedLayerUpdate();
    if (wasVisible != (_alpha > 0)) markNeedsSemanticsUpdate();
  }

  @override
  OffsetLayer updateCompositedLayer({required covariant OpacityLayer? oldLayer}) {
    return (oldLayer ?? OpacityLayer())..alpha = _alpha;
  }

  @override
  bool paintsChild(RenderObject child) => _alpha > 0;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_alpha > 0) super.paint(context, offset);
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    if (child != null && _alpha > 0) visitor(child!);
  }
}
