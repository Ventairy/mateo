part of 'mateo_press.dart';

class _RenderMateoPressScale extends RenderProxyBox {
  _RenderMateoPressScale(Animation<double> scale) : _scale = scale, _value = scale.value;

  Animation<double> _scale;
  double _value;
  final Matrix4 _transform = Matrix4.identity();
  bool _transformNeedsUpdate = true;

  Animation<double> get scale => _scale;
  set scale(Animation<double> value) {
    if (identical(value, _scale)) return;
    if (attached) _scale.removeListener(_updateScale);
    _scale = value;
    if (attached) _scale.addListener(_updateScale);
    _updateScale();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _scale.addListener(_updateScale);
    _updateScale();
  }

  @override
  void detach() {
    _scale.removeListener(_updateScale);
    super.detach();
  }

  void _updateScale() {
    final value = _scale.value;
    if (_value == value) return;
    _value = value;
    _transformNeedsUpdate = true;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  @override
  void performLayout() {
    super.performLayout();
    _transformNeedsUpdate = true;
  }

  Matrix4 get _centeredTransform {
    if (_transformNeedsUpdate) {
      // Only these entries change for a centered, uniform two-dimensional scale.
      final storage = _transform.storage;
      storage[0] = _value;
      storage[5] = _value;
      storage[12] = size.width * (1 - _value) / 2;
      storage[13] = size.height * (1 - _value) / 2;
      _transformNeedsUpdate = false;
    }
    return _transform;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) => hitTestChildren(result, position: position);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    if (_value == 1) return super.hitTestChildren(result, position: position);
    return result.addWithPaintTransform(
      transform: _centeredTransform,
      position: position,
      hitTest: (result, position) => super.hitTestChildren(result, position: position),
    );
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    if (_value != 1) transform.multiply(_centeredTransform);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null || _value == 1) {
      layer = null;
      super.paint(context, offset);
      return;
    }
    layer = context.pushTransform(
      needsCompositing,
      offset,
      _centeredTransform,
      super.paint,
      oldLayer: layer is TransformLayer ? layer! as TransformLayer : null,
    );
  }
}
