part of 'base_mateo_surface.dart';

class _BaseMateoSurfaceRepaintBoundary extends SingleChildRenderObjectWidget {
  const new({required this.controller, required super.child});

  final _BaseMateoSurfaceScrollController controller;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderBaseMateoSurfaceRepaintBoundary(controller);

  @override
  void updateRenderObject(BuildContext context, _RenderBaseMateoSurfaceRepaintBoundary renderObject) =>
      renderObject.controller = controller;
}
