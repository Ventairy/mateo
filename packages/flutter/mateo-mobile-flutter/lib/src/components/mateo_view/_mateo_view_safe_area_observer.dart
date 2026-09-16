part of '../mateo_view.dart';

final class _MateoViewSafeAreaObserver extends SingleChildRenderObjectWidget {
  const _MateoViewSafeAreaObserver({
    required this.inputs,
    required this.onChanged,
    required super.child,
  });

  final _MateoViewSafeAreaInputs inputs;
  final ValueChanged<_MateoViewSafeAreaGeometry> onChanged;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMateoViewSafeAreaObserver(
      inputs: inputs,
      onChanged: onChanged,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderMateoViewSafeAreaObserver renderObject,
  ) {
    renderObject
      ..inputs = inputs
      ..onChanged = onChanged;
  }
}

final class _RenderMateoViewSafeAreaObserver extends RenderProxyBox {
  _RenderMateoViewSafeAreaObserver({
    required this._inputs,
    required this.onChanged,
  });

  _MateoViewSafeAreaInputs get inputs => _inputs;
  _MateoViewSafeAreaInputs _inputs;
  set inputs(_MateoViewSafeAreaInputs value) {
    if (_inputs == value) return;
    _inputs = value;
    _preservedSize = null;
    markNeedsPaint();
  }

  ValueChanged<_MateoViewSafeAreaGeometry> onChanged;

  Size? _preservedSize;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_preservedSize != size) {
      _preservedSize = size;
      final transform = getTransformTo(null);
      final bounds = MatrixUtils.transformRect(transform, Offset.zero & size);
      onChanged(
        _MateoViewSafeAreaGeometry.resolve(
          inputs: inputs,
          viewBounds: bounds,
        ),
      );
    }
    super.paint(context, offset);
  }
}
