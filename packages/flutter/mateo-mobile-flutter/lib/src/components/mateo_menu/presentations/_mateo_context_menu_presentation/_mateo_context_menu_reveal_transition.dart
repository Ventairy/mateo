part of '../../mateo_menu_button.dart';

class _MateoContextMenuRevealTransition extends SingleChildRenderObjectWidget {
  const _MateoContextMenuRevealTransition({
    required this.progress,
    required this.contentFadeStart,
    required this.backgroundColor,
    required this.radius,
    required super.child,
  });

  final Animation<double> progress;
  final double contentFadeStart;
  final Color backgroundColor;
  final double radius;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderMateoContextMenuRevealTransition(progress, backgroundColor, contentFadeStart, radius);

  @override
  void updateRenderObject(BuildContext context, _RenderMateoContextMenuRevealTransition renderObject) => renderObject
    ..progress = progress
    ..contentFadeStart = contentFadeStart
    ..backgroundColor = backgroundColor;
}
