part of 'mateo_press.dart';

class _MateoPressFade extends SingleChildRenderObjectWidget {
  const _MateoPressFade({required this.opacity, required super.child});

  final Animation<double> opacity;

  @override
  _RenderMateoPressFade createRenderObject(BuildContext context) => _RenderMateoPressFade(opacity);

  @override
  void updateRenderObject(BuildContext context, _RenderMateoPressFade renderObject) {
    renderObject.opacity = opacity;
  }
}
