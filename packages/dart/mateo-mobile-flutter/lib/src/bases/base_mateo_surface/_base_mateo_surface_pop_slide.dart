part of 'base_mateo_surface.dart';

class _BaseMateoSurfacePopSlide extends Animatable<Offset> {
  new(this.animation);

  final MateoSurfaceAnimationPop animation;

  // A quarter of the laid-out surface makes its direction clear at pop speed.
  static const double _distance = 0.25;

  @override
  Offset transform(double t) {
    final remaining = 1 - animation.curve.transform(t);
    if (!remaining.isFinite) return Offset.zero;
    final begin = switch (animation.direction) {
      .center => Offset.zero,
      .top => const Offset(0, _distance),
      .topRight => const Offset(-_distance, _distance),
      .right => const Offset(-_distance, 0),
      .bottomRight => const Offset(-_distance, -_distance),
      .bottom => const Offset(0, -_distance),
      .bottomLeft => const Offset(_distance, -_distance),
      .left => const Offset(_distance, 0),
      .topLeft => const Offset(_distance, _distance),
    };
    return begin * remaining;
  }
}
