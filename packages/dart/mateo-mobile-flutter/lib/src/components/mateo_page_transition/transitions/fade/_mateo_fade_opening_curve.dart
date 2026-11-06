part of '../../mateo_page_transition.dart';

final class _MateoFadeOpeningCurve extends Curve {
  const new();

  @override
  double transformInternal(double t) {
    if (t <= .5) return t * t * t * (35 + t * (-105 + t * (126 + t * (-70 + 15 * t))));

    final remaining = 1 - t;
    final remainingSquared = remaining * remaining;
    return 1 - remainingSquared * remainingSquared * remaining * (1 + t * (5 + 15 * t));
  }
}
