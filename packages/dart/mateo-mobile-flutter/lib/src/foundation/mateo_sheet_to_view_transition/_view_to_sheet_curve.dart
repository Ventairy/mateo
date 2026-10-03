part of 'mateo_sheet_to_view_transition.dart';

class _ViewToSheetCurve extends Curve {
  const _ViewToSheetCurve();

  static const _landingStart = 0.5;

  @override
  double transformInternal(double t) {
    final progress = _sheetViewSpring.x(t);
    if (t <= _landingStart) return progress;

    // Preserve the spring through the energetic half of the return, then use
    // a seventh-order landing blend. Its velocity, acceleration, and jerk are
    // continuous at the handoff and all reach zero at the sheet endpoint.
    final landingProgress = (t - _landingStart) / (1 - _landingStart);
    final landingProgressSquared = landingProgress * landingProgress;
    final landingProgressFourth = landingProgressSquared * landingProgressSquared;
    final landingBlend =
        landingProgressFourth * (35 + landingProgress * (-84 + landingProgress * (70 - 20 * landingProgress)));
    return progress + (1 - progress) * landingBlend;
  }
}
