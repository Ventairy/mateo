part of 'base_mateo_surface.dart';

class _BaseMateoSurfacePopScale extends Animatable<double> {
  _BaseMateoSurfacePopScale(this.animation);

  final MateoSurfaceAnimationPop animation;

  @override
  double transform(double t) {
    final scale = animation.beginScale + (1 - animation.beginScale) * animation.curve.transform(t);
    // Motion omits non-finite scales from painting and hit testing. A singular
    // transform plus zero opacity preserves that behavior with native widgets.
    return scale.isFinite ? scale : 0;
  }
}
