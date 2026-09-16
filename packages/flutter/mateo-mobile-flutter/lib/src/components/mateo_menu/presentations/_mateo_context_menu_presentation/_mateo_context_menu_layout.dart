part of '../../mateo_menu_button.dart';

class _MateoContextMenuLayout extends SingleChildRenderObjectWidget {
  const _MateoContextMenuLayout({
    required this.triggerBounds,
    required this.mediaQuery,
    required this.textDirection,
    required super.child,
  });

  final Rect triggerBounds;
  final MediaQueryData mediaQuery;
  final TextDirection textDirection;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderMateoContextMenuLayout(triggerBounds, mediaQuery, textDirection);

  @override
  void updateRenderObject(BuildContext context, _RenderMateoContextMenuLayout renderObject) => renderObject.update(
    triggerBounds: triggerBounds,
    mediaQuery: mediaQuery,
    textDirection: textDirection,
  );
}
