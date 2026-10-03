part of 'base_mateo_surface.dart';

class _BaseMateoSurfaceContentLayer extends ContainerLayer {
  _BaseMateoSurfaceContentLayer(this.resolveOffset);

  final ValueGetter<Offset> resolveOffset;
  Offset _offset = Offset.zero;

  @override
  bool get alwaysNeedsAddToScene => true;

  @override
  void addToScene(ui.SceneBuilder builder) {
    // Ancestor motion can update safe-area correction without repainting this
    // retained content. Resolve its translation alongside the header's layer.
    _offset = resolveOffset();
    engineLayer = builder.pushOffset(_offset.dx, _offset.dy, oldLayer: engineLayer as ui.OffsetEngineLayer?);
    addChildrenToScene(builder);
    builder.pop();
  }

  @override
  void applyTransform(Layer? child, Matrix4 transform) => transform.translateByDouble(_offset.dx, _offset.dy, 0, 1);

  @override
  bool findAnnotations<S extends Object>(AnnotationResult<S> result, Offset localPosition, {required bool onlyFirst}) =>
      super.findAnnotations(result, localPosition - _offset, onlyFirst: onlyFirst);
}
