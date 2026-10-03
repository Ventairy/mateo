part of 'show_mateo_sheet.dart';

// Begins with visible motion, then changes velocity smoothly before reaching
// the device edge. The seventh-degree trajectory has zero acceleration and
// jerk at both endpoints, and finishes with zero velocity. Keep the
// coefficients together: they encode those boundary conditions.
class _MateoSheetExitCurve extends Curve {
  const _MateoSheetExitCurve();

  @override
  double transformInternal(double t) {
    final t2 = t * t;
    final t3 = t2 * t;
    return t * (.75 + t3 * (20 + t * (-50.25 + t * (43 - 12.5 * t))));
  }
}
