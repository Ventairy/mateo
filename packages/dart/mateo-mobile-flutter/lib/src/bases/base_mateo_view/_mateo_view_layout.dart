part of 'base_mateo_view.dart';

class _MateoViewLayout extends MultiChildRenderObjectWidget {
  const _MateoViewLayout({
    required this.layout,
    required this.fitHeight,
    required this.reserveHeaderSpace,
    required super.children,
  });

  final _MateoViewLayoutData layout;
  final bool fitHeight;
  final bool reserveHeaderSpace;

  @override
  _RenderMateoViewLayout createRenderObject(BuildContext context) => _RenderMateoViewLayout(
    layout: layout,
    fitHeight: fitHeight,
    reserveHeaderSpace: reserveHeaderSpace,
  );

  @override
  void updateRenderObject(BuildContext context, _RenderMateoViewLayout renderObject) => renderObject
    ..layoutData = layout
    ..fitHeight = fitHeight
    ..reserveHeaderSpace = reserveHeaderSpace;
}
