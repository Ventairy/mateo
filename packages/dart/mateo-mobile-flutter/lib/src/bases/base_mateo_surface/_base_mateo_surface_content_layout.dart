part of 'base_mateo_surface.dart';

class _BaseMateoSurfaceContentLayout extends SingleChildRenderObjectWidget {
  const _BaseMateoSurfaceContentLayout({
    required this.obstruction,
    required this.padding,
    required this.alignment,
    required this.revealBottomInset,
    required this.onCaretReveal,
    required super.child,
  });

  final MateoSurfaceObstruction? obstruction;
  final EdgeInsets padding;
  final Alignment? alignment;
  final double revealBottomInset;
  final bool Function(RenderObject? descendant)? onCaretReveal;

  @override
  _RenderBaseMateoSurfaceContentLayout createRenderObject(BuildContext context) => _RenderBaseMateoSurfaceContentLayout(
    obstruction: obstruction,
    padding: padding,
    alignment: alignment,
    revealBottomInset: revealBottomInset,
    onCaretReveal: onCaretReveal,
  );

  @override
  void updateRenderObject(BuildContext context, _RenderBaseMateoSurfaceContentLayout renderObject) => renderObject
    ..obstruction = obstruction
    ..padding = padding
    ..alignment = alignment
    ..revealBottomInset = revealBottomInset
    ..onCaretReveal = onCaretReveal;
}
