part of 'base_mateo_view.dart';

class _MateoViewLayout extends MultiChildRenderObjectWidget {
  const _MateoViewLayout({
    required this.padding,
    required this.layout,
    required this.fitHeight,
    required this.reserveHeaderSpace,
    required super.children,
  });

  final _MateoViewLayoutData layout;
  final bool fitHeight;
  final bool reserveHeaderSpace;
  final EdgeInsets padding;

  @override
  _RenderMateoViewLayout createRenderObject(BuildContext context) => _RenderMateoViewLayout(
    layout: layout,
    fitHeight: fitHeight,
    reserveHeaderSpace: reserveHeaderSpace,
    padding: padding,
  );

  @override
  void updateRenderObject(BuildContext context, _RenderMateoViewLayout renderObject) => renderObject
    ..padding = padding
    ..layoutData = layout
    ..fitHeight = fitHeight
    ..reserveHeaderSpace = reserveHeaderSpace;
}
