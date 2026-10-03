part of 'base_mateo_surface.dart';

class _BaseMateoSurfaceContentLayout extends SingleChildRenderObjectWidget {
  const _BaseMateoSurfaceContentLayout({
    required this.obstruction,
    required this.padding,
    required this.alignment,
    required super.child,
  });

  final MateoSurfaceObstruction? obstruction;
  final EdgeInsets padding;
  final Alignment? alignment;

  @override
  _RenderBaseMateoSurfaceContentLayout createRenderObject(BuildContext context) => _RenderBaseMateoSurfaceContentLayout(
    obstruction: obstruction,
    padding: padding,
    alignment: alignment,
  );

  @override
  void updateRenderObject(BuildContext context, _RenderBaseMateoSurfaceContentLayout renderObject) => renderObject
    ..obstruction = obstruction
    ..padding = padding
    ..alignment = alignment;
}
