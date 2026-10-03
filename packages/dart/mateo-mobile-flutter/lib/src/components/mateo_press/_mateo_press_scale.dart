part of 'mateo_press.dart';

class _MateoPressScale extends SingleChildRenderObjectWidget {
  const _MateoPressScale({required this.scale, required super.child});

  final Animation<double> scale;

  @override
  _RenderMateoPressScale createRenderObject(BuildContext context) => _RenderMateoPressScale(scale);

  @override
  void updateRenderObject(BuildContext context, _RenderMateoPressScale renderObject) {
    renderObject.scale = scale;
  }
}
