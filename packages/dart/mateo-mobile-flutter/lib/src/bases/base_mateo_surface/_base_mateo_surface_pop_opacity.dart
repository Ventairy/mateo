part of 'base_mateo_surface.dart';

class _BaseMateoSurfacePopOpacity extends Animatable<double> {
  _BaseMateoSurfacePopOpacity(this.curve);

  final Curve curve;

  @override
  double transform(double t) {
    final opacity = curve.transform(t);
    return opacity.isFinite ? opacity.clamp(0, 1) : 0;
  }
}
