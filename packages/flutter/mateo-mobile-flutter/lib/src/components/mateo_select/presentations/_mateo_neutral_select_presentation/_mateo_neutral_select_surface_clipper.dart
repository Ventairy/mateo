part of '../../mateo_select.dart';

final class _MateoNeutralSelectSurfaceClipper extends CustomClipper<RRect> {
  _MateoNeutralSelectSurfaceClipper({
    required this.animation,
    required this.triggerRect,
  }) : super(reclip: animation);

  final Animation<double> animation;
  final Rect triggerRect;

  @override
  RRect getClip(Size size) {
    final rect = Rect.lerp(triggerRect, Offset.zero & size, animation.value)!;
    return _MateoNeutralSelectPresentation._borderRadius.toRRect(rect);
  }

  @override
  bool shouldReclip(_MateoNeutralSelectSurfaceClipper oldClipper) =>
      oldClipper.animation != animation || oldClipper.triggerRect != triggerRect;
}
