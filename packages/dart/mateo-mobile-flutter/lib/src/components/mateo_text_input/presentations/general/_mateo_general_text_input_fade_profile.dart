part of '../../mateo_text_input.dart';

final class _MateoGeneralTextInputFadeProfile {
  static final _fadeProfile = MateoEdgeFadeProfile(
    stops: List.generate(33, (index) => index / 32),
    visibility: List.generate(33, (index) {
      final x = index / 32;
      final q = x * x * x * (x * (6 * x - 15) + 10);
      return q * (0.12 + 0.88 * q) - 0.4 * q * (1 - q) * (q - 0.5) * (q - 0.5);
    }),
  );

  static List<MateoEdgeFadeBand> resolve({
    required Size bounds,
    required EdgeInsetsDirectional textInsets,
    required TextDirection direction,
    required ScrollMetrics? metrics,
  }) {
    final before = metrics?.extentBefore ?? 0;
    final after = metrics?.extentAfter ?? 0;
    final scrollMatchesLayout =
        metrics == null || (direction == .ltr ? metrics.axisDirection == .right : metrics.axisDirection == .left);
    final leading = _extent(textInsets.start, scrollMatchesLayout ? before : after, bounds.width);
    final trailing = _extent(textInsets.end, scrollMatchesLayout ? after : before, bounds.width);
    return [
      .left(extent: direction == .ltr ? leading : trailing, profile: _fadeProfile),
      .right(extent: direction == .ltr ? trailing : leading, profile: _fadeProfile),
    ];
  }

  static double _extent(double restingDepth, double hiddenDistance, double width) {
    final resting = restingDepth.clamp(0.0, width / 3);
    final complete = (width / 9).clamp(64.0, 96.0).clamp(resting, width / 3);
    final extension = complete - resting;
    if (extension == 0) return resting;
    final progress = (hiddenDistance / extension).clamp(0.0, 1.0);
    return resting + extension * progress * (2 - progress);
  }
}
