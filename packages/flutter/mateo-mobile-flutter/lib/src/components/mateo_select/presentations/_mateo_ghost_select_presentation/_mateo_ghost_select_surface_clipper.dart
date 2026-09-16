part of '../../mateo_select.dart';

final class _MateoGhostSelectSurfaceClipper extends CustomClipper<RRect> {
  _MateoGhostSelectSurfaceClipper({
    required this.animation,
    required this.triggerRect,
  }) : super(reclip: animation);

  final Animation<double> animation;
  final Rect triggerRect;

  @override
  RRect getClip(Size size) {
    final rect = Rect.lerp(triggerRect, Offset.zero & size, animation.value)!;
    return _MateoGhostSelectPresentation._borderRadius.toRRect(rect);
  }

  @override
  bool shouldReclip(_MateoGhostSelectSurfaceClipper oldClipper) =>
      oldClipper.animation != animation || oldClipper.triggerRect != triggerRect;
}
