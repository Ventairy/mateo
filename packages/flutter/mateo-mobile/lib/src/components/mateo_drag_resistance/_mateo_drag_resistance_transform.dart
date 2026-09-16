part of 'mateo_drag_resistance.dart';

class _MateoDragResistanceTransform extends SingleChildRenderObjectWidget {
  const _MateoDragResistanceTransform({required this.translation, required super.child});

  final ValueListenable<Offset> translation;

  @override
  _RenderMateoDragResistanceTransform createRenderObject(BuildContext context) =>
      _RenderMateoDragResistanceTransform(translation);

  @override
  void updateRenderObject(BuildContext context, _RenderMateoDragResistanceTransform renderObject) {
    renderObject.translation = translation;
  }
}
