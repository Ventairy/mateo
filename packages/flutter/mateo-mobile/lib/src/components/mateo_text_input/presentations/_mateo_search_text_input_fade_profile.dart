part of '../mateo_text_input.dart';

final class _MateoSearchTextInputFadeProfile {
  static const _segments = 32;

  // Distribute the transition across the whole band, including beneath
  // the icon. Only the field edge fully hides overflowing text.
  static final MateoEdgeFadeProfile _leadingProfile = _createProfile(leading: true);
  static final MateoEdgeFadeProfile _trailingProfile = _createProfile(leading: false);

  static MateoEdgeFadeProfile _createProfile({required bool leading}) => MateoEdgeFadeProfile(
    stops: List.generate(_segments + 1, (index) => index / _segments),
    visibility: List.generate(_segments + 1, (index) {
      final x = index / _segments;
      final visibility = x * x * (3 - 2 * x);
      // Keep text faint beneath the icons, then restore readability smoothly
      // across the band without introducing an opaque plateau.
      final squared = visibility * visibility;
      final baseline = squared * squared * visibility;
      if (!leading) return baseline;
      final leadingVisibility = baseline * baseline;
      return leadingVisibility * leadingVisibility;
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
    final leading = _extent(textInsets.start, scrollMatchesLayout ? before : after, bounds.width, leading: true);
    final trailing = _extent(textInsets.end, scrollMatchesLayout ? after : before, bounds.width);
    return [
      .left(
        extent: direction == .ltr ? leading : trailing,
        profile: direction == .ltr ? _leadingProfile : _trailingProfile,
      ),
      .right(
        extent: direction == .ltr ? trailing : leading,
        profile: direction == .ltr ? _trailingProfile : _leadingProfile,
      ),
    ];
  }

  static double _extent(double restingDepth, double hiddenDistance, double width, {bool leading = false}) {
    // End at the actual text inset when this edge has no hidden content.
    // Extend inward smoothly as text scrolls beneath the icon.
    final resting = restingDepth.clamp(0.0, width / 3);
    final complete = (restingDepth * (leading ? 1.15 : 1.25)).clamp(resting, width / 3);
    final extension = complete - resting;
    if (extension == 0) return resting;
    final progress = (hiddenDistance / extension).clamp(0.0, 1.0);
    return resting + extension * progress * (2 - progress);
  }
}
