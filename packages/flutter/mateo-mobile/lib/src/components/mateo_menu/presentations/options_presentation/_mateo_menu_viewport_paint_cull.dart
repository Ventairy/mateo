part of '../../mateo_menu.dart';

class _MateoMenuViewportPaintCull extends SingleChildRenderObjectWidget {
  const _MateoMenuViewportPaintCull({required this.enabled, required super.child});

  final bool enabled;

  @override
  _RenderMateoMenuViewportPaintCull createRenderObject(BuildContext context) =>
      _RenderMateoMenuViewportPaintCull(enabled: enabled);

  @override
  void updateRenderObject(BuildContext context, _RenderMateoMenuViewportPaintCull renderObject) {
    renderObject.enabled = enabled;
  }
}
