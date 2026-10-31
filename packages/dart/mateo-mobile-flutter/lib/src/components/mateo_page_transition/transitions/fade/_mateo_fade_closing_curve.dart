part of '../../mateo_page_transition.dart';

final class _MateoFadeClosingCurve extends Curve {
  const _MateoFadeClosingCurve();

  @override
  double transformInternal(double t) {
    if (t <= .5) return t * t * t * (20 + t * (-45 + t * (36 - 10 * t)));

    final remaining = 1 - t;
    final remainingSquared = remaining * remaining;
    return 1 - remainingSquared * remainingSquared * (1 + t * (4 + 10 * t));
  }
}
