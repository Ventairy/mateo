part of '../../mateo_menu.dart';

class _RenderMateoMenuViewportPaintCull extends RenderProxyBox {
  _RenderMateoMenuViewportPaintCull({required this._enabled});

  bool _enabled;

  bool get enabled => _enabled;

  set enabled(bool value) {
    if (_enabled == value) return;
    _enabled = value;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!_enabled) {
      super.paint(context, offset);
      return;
    }

    var ancestor = parent;
    while (ancestor != null && ancestor is! RenderView) {
      ancestor = ancestor.parent;
    }
    if (ancestor case final RenderView view) {
      // Both values use the view's physical-pixel coordinate space.
      final rowBounds = MatrixUtils.transformRect(getTransformTo(view), Offset.zero & size);
      if (rowBounds.isFinite && !rowBounds.overlaps(view.paintBounds)) return;
    }
    super.paint(context, offset);
  }
}
