part of '../../mateo_page_transition.dart';

// Follows a critically damped spring while the page covers most of its
// distance. The seventh-degree tail matches position, velocity, acceleration,
// and jerk at the join, then brings all three derivatives to zero at landing.
// Keep the full-precision coefficients together: they encode those boundary
// conditions for the opening trajectory.
final class _MateoSlideOpeningCurve extends Curve {
  const _MateoSlideOpeningCurve();

  static const _frequency = 7.5;
  static const double _tailStart = 0.62;
  static const double _tailDuration = 1 - _tailStart;

  @override
  double transformInternal(double t) {
    if (t <= _tailStart) return 1 - (1 + _frequency * t) * math.exp(-_frequency * t);

    final u = (t - _tailStart) / _tailDuration;
    return 0.94597694909242924 +
        u *
            (0.1267151295845278 +
                u *
                    (-0.14173700381753232 +
                        u *
                            (0.097759700578256892 +
                                u *
                                    (0.38283542593671882 +
                                        u *
                                            (-1.0839373178133052 +
                                                u * (0.9548851534369156 - 0.28249803699801102 * u))))));
  }
}
