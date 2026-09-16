part of '../mateo_surface.dart';

final class _RenderMateoSurfaceBoundaryReveal extends RenderProxyBox {
  _RenderMateoSurfaceBoundaryReveal({
    required this._repaint,
    required this._position,
    required this._maximumExtent,
    required this._resolveExtent,
  });

  final Matrix4 _firstTransform = Matrix4.identity();
  final Matrix4 _secondTransform = Matrix4.identity();
  Listenable? _repaint;
  _MateoSurfaceBoundaryPosition _position;
  double _maximumExtent;
  double Function(
    _MateoSurfaceBoundaryPosition position,
    double maximumExtent,
  )
  _resolveExtent;
  double? _paintExtent;

  Listenable? get repaint => _repaint;

  _MateoSurfaceBoundaryPosition get position => _position;

  double get maximumExtent => _maximumExtent;

  double Function(
    _MateoSurfaceBoundaryPosition position,
    double maximumExtent,
  )
  get resolveExtent => _resolveExtent;

  set repaint(Listenable? value) {
    if (identical(value, _repaint)) return;
    if (attached) _repaint?.removeListener(_handleRepaint);
    _repaint = value;
    if (attached) _repaint?.addListener(_handleRepaint);
    _invalidatePaintExtent();
  }

  set position(_MateoSurfaceBoundaryPosition value) {
    if (value == _position) return;
    _position = value;
    _invalidatePaintExtent();
  }

  set maximumExtent(double value) {
    if (value == _maximumExtent) return;
    _maximumExtent = value;
    _invalidatePaintExtent();
  }

  set resolveExtent(
    double Function(
      _MateoSurfaceBoundaryPosition position,
      double maximumExtent,
    )
    value,
  ) {
    if (value == _resolveExtent) return;
    _resolveExtent = value;
    _invalidatePaintExtent();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  bool paintsChild(RenderBox child) {
    return (_paintExtent ??= _resolvedPaintExtent()) > 0;
  }

  double _resolvedPaintExtent() {
    return _resolveExtent(_position, _maximumExtent).clamp(0.0, _maximumExtent);
  }

  void _invalidatePaintExtent() {
    _paintExtent = null;
    markNeedsPaint();
  }

  void _handleRepaint() {
    final nextExtent = _resolvedPaintExtent();
    final previousExtent = _paintExtent;
    if (nextExtent == previousExtent) return;
    _paintExtent = nextExtent;
    if (previousExtent == 0 || nextExtent == 0) {
      markNeedsPaint();
    } else {
      markNeedsCompositedLayerUpdate();
    }
  }

  void _applyRevealTransform(Matrix4 transform, double extent) {
    transform
      ..translateByDouble(
        0,
        _position == _MateoSurfaceBoundaryPosition.bottom ? _maximumExtent - extent : 0,
        0,
        1,
      )
      ..scaleByDouble(1, extent / _maximumExtent, 1, 1);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _repaint?.addListener(_handleRepaint);
    _invalidatePaintExtent();
  }

  @override
  void detach() {
    _repaint?.removeListener(_handleRepaint);
    super.detach();
  }

  @override
  TransformLayer updateCompositedLayer({
    required covariant TransformLayer? oldLayer,
  }) {
    final layer = oldLayer ?? TransformLayer();
    final transform = (identical(layer.transform, _firstTransform) ? _secondTransform : _firstTransform)..setIdentity();
    final extent = _paintExtent ??= _resolvedPaintExtent();
    if (extent > 0 && extent < _maximumExtent) {
      _applyRevealTransform(transform, extent);
    }
    return layer..transform = transform;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final child = this.child;
    final extent = _paintExtent ??= _resolvedPaintExtent();
    if (child != null && extent > 0) context.paintChild(child, offset);
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    final extent = _paintExtent ??= _resolvedPaintExtent();
    if (extent < _maximumExtent) {
      _applyRevealTransform(transform, extent);
    }
  }
}
