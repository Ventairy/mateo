part of '../mateo_view.dart';

final class _MateoViewSafeAreaPaintCompensator extends SingleChildRenderObjectWidget {
  const _MateoViewSafeAreaPaintCompensator({
    required this.top,
    required this.layoutInsets,
    required this.paintInsets,
    required super.child,
  });

  final bool top;
  final EdgeInsets layoutInsets;
  final ValueGetter<EdgeInsets> paintInsets;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMateoViewSafeAreaPaintCompensator(
      top: top,
      layoutInsets: layoutInsets,
      paintInsets: paintInsets,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderMateoViewSafeAreaPaintCompensator renderObject,
  ) {
    renderObject.update(
      top: top,
      layoutInsets: layoutInsets,
      paintInsets: paintInsets,
    );
  }
}

final class _RenderMateoViewSafeAreaPaintCompensator extends RenderProxyBox {
  _RenderMateoViewSafeAreaPaintCompensator({
    required this.top,
    required this.layoutInsets,
    required this.paintInsets,
  });

  bool top;
  EdgeInsets layoutInsets;
  ValueGetter<EdgeInsets> paintInsets;

  void update({
    required bool top,
    required EdgeInsets layoutInsets,
    required ValueGetter<EdgeInsets> paintInsets,
  }) {
    final geometryChanged =
        this.top != top || this.layoutInsets != layoutInsets || !identical(this.paintInsets, paintInsets);
    this.top = top;
    this.layoutInsets = layoutInsets;
    this.paintInsets = paintInsets;
    if (!geometryChanged) return;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  Offset get _correction {
    final painted = paintInsets();
    return Offset(
      0,
      top ? painted.top - layoutInsets.top : layoutInsets.bottom - painted.bottom,
    );
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return result.addWithPaintOffset(
      offset: _correction,
      position: position,
      hitTest: (result, transformed) => super.hitTestChildren(
        result,
        position: transformed,
      ),
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final child = this.child;
    if (child != null) context.paintChild(child, offset + _correction);
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    final correction = _correction;
    transform.translateByDouble(correction.dx, correction.dy, 0, 1);
  }
}
