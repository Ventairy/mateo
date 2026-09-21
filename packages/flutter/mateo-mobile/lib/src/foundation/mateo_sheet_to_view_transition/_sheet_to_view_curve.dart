part of 'mateo_sheet_to_view_transition.dart';

class _SheetToViewCurve extends Curve {
  const _SheetToViewCurve();

  static const _landingStart = 0.5;

  @override
  double transformInternal(double t) {
    final progress = _sheetViewSpring.x(t);
    if (t <= _landingStart) return progress;

    // Finish the remaining spring travel without truncating it. Quintic
    // smoothing preserves velocity and acceleration at the join and brings
    // both to zero at the endpoint, without overshoot or a second speed-up.
    final landingProgress = (t - _landingStart) / (1 - _landingStart);
    final landingBlend =
        landingProgress * landingProgress * landingProgress * (landingProgress * (landingProgress * 6 - 15) + 10);
    return progress + (1 - progress) * landingBlend;
  }
}
