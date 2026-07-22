part of 'mateo_skeleton.dart';

class _MateoSkeletonRenderObjectWidget extends SingleChildRenderObjectWidget {
  const _MateoSkeletonRenderObjectWidget({
    required this.colorScheme,
    required this.style,
    required this.boneColor,
    required this.effectAnimation,
    required super.child,
  });

  final MateoColorScheme colorScheme;
  final MateoSkeletonStyle? style;
  final Color boneColor;
  final Animation<double>? effectAnimation;

  @override
  _RenderMateoSkeleton createRenderObject(BuildContext context) {
    return _RenderMateoSkeleton(
      colorScheme: colorScheme,
      style: style,
      boneColor: boneColor,
      effectAnimation: effectAnimation,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    if (renderObject is _RenderMateoSkeleton) {
      renderObject
        ..colorScheme = colorScheme
        ..style = style
        ..boneColor = boneColor
        ..effectAnimation = effectAnimation;
    }
  }
}
