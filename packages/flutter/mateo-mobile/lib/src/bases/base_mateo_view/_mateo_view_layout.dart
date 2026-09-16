part of 'base_mateo_view.dart';

class _MateoViewLayout extends MultiChildRenderObjectWidget {
  const _MateoViewLayout({
    required this.padding,
    required this.layout,
    required this.fitHeight,
    required super.children,
  });

  final _MateoViewLayoutData layout;
  final bool fitHeight;
  final EdgeInsets padding;

  @override
  _RenderMateoViewLayout createRenderObject(BuildContext context) =>
      _RenderMateoViewLayout(layout: layout, fitHeight: fitHeight, padding: padding);

  @override
  void updateRenderObject(BuildContext context, _RenderMateoViewLayout renderObject) => renderObject
    ..padding = padding
    ..layoutData = layout
    ..fitHeight = fitHeight;
}
