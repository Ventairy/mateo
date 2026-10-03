part of 'mateo_drag_resistance.dart';

// A critically damped release from rest, reaching 95% at 60% of the duration.
// The remaining-distance polynomial matches the spring's position, velocity,
// acceleration and jerk at the join. Its r^4 factor brings the last three to
// zero at landing, without truncating the spring's nonzero exponential tail.
// Keep these coefficients together; they solve those boundary conditions.
class _MateoDragResistanceReturnCurve extends Curve {
  const _MateoDragResistanceReturnCurve();

  @override
  double transformInternal(double t) {
    if (t <= 0.6) {
      final springTime = 7.906440863984298 * t;
      return 1 - (1 + springTime) * math.exp(-springTime);
    }

    final remainingTime = (1 - t) / 0.4;
    final squaredTime = remainingTime * remainingTime;
    return 1 -
        squaredTime *
            squaredTime *
            (0.48000360240464635 +
                remainingTime *
                    (-1.0106220969636555 + remainingTime * (0.8006346089695058 - remainingTime * 0.22001611441049676)));
  }
}
