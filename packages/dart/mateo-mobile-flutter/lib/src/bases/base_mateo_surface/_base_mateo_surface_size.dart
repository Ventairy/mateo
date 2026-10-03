part of 'base_mateo_surface.dart';

class _BaseMateoSurfaceSize extends SingleChildRenderObjectWidget {
  const _BaseMateoSurfaceSize({required this.width, required this.height, required super.child, super.key});

  final MateoSurfaceWidth width;
  final MateoSurfaceHeight height;

  @override
  _RenderBaseMateoSurfaceSize createRenderObject(BuildContext context) {
    return _RenderBaseMateoSurfaceSize(width: width, height: height);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderBaseMateoSurfaceSize renderObject) => renderObject
    ..width = width
    ..height = height;
}
