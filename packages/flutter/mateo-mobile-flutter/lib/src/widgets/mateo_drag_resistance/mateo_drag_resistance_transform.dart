part of 'mateo_drag_resistance.dart';

class _MateoDragResistanceTransform extends SingleChildRenderObjectWidget {
  const _MateoDragResistanceTransform({
    required this.resistanceListenable,
    required super.child,
  });

  final Listenable resistanceListenable;

  @override
  _RenderMateoDragResistanceTransform createRenderObject(BuildContext context) {
    return _RenderMateoDragResistanceTransform(resistanceListenable);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderMateoDragResistanceTransform renderObject,
  ) {
    renderObject.resistanceListenable = resistanceListenable;
  }
}
