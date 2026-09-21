part of '../../mateo_page_transition.dart';

// Matches the sheet's measured exit pacing: visible movement begins
// immediately, then velocity changes smoothly before the page reaches the
// device edge. The seventh-degree trajectory has zero acceleration and jerk at
// both endpoints, and finishes with zero velocity. Keep the coefficients
// together: they encode those boundary conditions.
final class _MateoSlideClosingCurve extends Curve {
  const _MateoSlideClosingCurve();

  @override
  double transformInternal(double t) {
    final t2 = t * t;
    final t3 = t2 * t;
    return t * (.75 + t3 * (20 + t * (-50.25 + t * (43 - 12.5 * t))));
  }
}
