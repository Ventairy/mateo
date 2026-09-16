part of '../../mateo_menu_button.dart';

class _MateoContextMenuContentLayout extends MultiChildRenderObjectWidget {
  const _MateoContextMenuContentLayout({required this.textDirection, required super.children});

  final TextDirection textDirection;

  @override
  _RenderMateoContextMenuContentLayout createRenderObject(BuildContext context) =>
      _RenderMateoContextMenuContentLayout(textDirection);

  @override
  void updateRenderObject(BuildContext context, _RenderMateoContextMenuContentLayout renderObject) {
    renderObject.textDirection = textDirection;
  }
}
