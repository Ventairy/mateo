part of 'mateo_tap.dart';

class _MateoTapFade extends SingleChildRenderObjectWidget {
  const _MateoTapFade({required this.opacity, required super.child});

  final Animation<double> opacity;

  @override
  _RenderMateoTapFade createRenderObject(BuildContext context) => _RenderMateoTapFade(opacity);

  @override
  void updateRenderObject(BuildContext context, _RenderMateoTapFade renderObject) {
    renderObject.opacity = opacity;
  }
}
