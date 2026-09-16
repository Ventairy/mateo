part of 'base_mateo_surface.dart';

class _BaseMateoSurfaceContentLayout extends SingleChildRenderObjectWidget {
  const _BaseMateoSurfaceContentLayout({
    required this.obstructionInsets,
    required this.obstructionInsetsChanges,
    required this.padding,
    required this.alignment,
    required super.child,
  });

  final ValueGetter<EdgeInsets>? obstructionInsets;
  final Listenable? obstructionInsetsChanges;
  final EdgeInsets padding;
  final Alignment? alignment;

  @override
  _RenderBaseMateoSurfaceContentLayout createRenderObject(BuildContext context) => _RenderBaseMateoSurfaceContentLayout(
    obstructionInsets: obstructionInsets,
    obstructionInsetsChanges: obstructionInsetsChanges,
    padding: padding,
    alignment: alignment,
  );

  @override
  void updateRenderObject(BuildContext context, _RenderBaseMateoSurfaceContentLayout renderObject) => renderObject
    ..obstructionInsets = obstructionInsets
    ..obstructionInsetsChanges = obstructionInsetsChanges
    ..padding = padding
    ..alignment = alignment;
}
