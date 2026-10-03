part of 'show_mateo_sheet.dart';

// Follows cubic (0.32, 0.72, 0, 1) through 95% of travel. The quintic tail
// matches position, velocity, and acceleration at the join and ends at rest
// with zero velocity and acceleration. Keep the full-precision coefficients
// together: they encode those boundary conditions.
class _MateoSheetLandingCurve extends Curve {
  const _MateoSheetLandingCurve();

  @override
  double transformInternal(double t) {
    const splice = 0.48300052620708006;
    if (t <= splice) {
      var u = t;
      for (var i = 0; i < 6; i++) {
        final remaining = 1 - u;
        final x = 0.96 * remaining * remaining * u + u * u * u;
        final derivative = 0.96 + u * (-3.84 + 5.88 * u);
        u -= (x - t) / derivative;
      }
      return 2.16 * (1 - u) * (1 - u) * u + 3 * (1 - u) * u * u + u * u * u;
    }
    final q = (t - splice) / (1 - splice);
    return 0.95 +
        q *
            (0.1532062484012988 +
                q *
                    (-0.21919505572241027 +
                        q * (0.23834767675943813 + q * (-0.1819351799568405 + q * 0.059576310518513975))));
  }
}
