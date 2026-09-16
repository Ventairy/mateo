part of '../../mateo_menu_button.dart';

class _MateoActionMenuLayout extends SingleChildRenderObjectWidget {
  const _MateoActionMenuLayout({
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
      _RenderMateoActionMenuLayout(triggerBounds, mediaQuery, textDirection);

  @override
  void updateRenderObject(BuildContext context, _RenderMateoActionMenuLayout renderObject) => renderObject
    ..triggerBounds = triggerBounds
    ..mediaQuery = mediaQuery
    ..textDirection = textDirection;
}
