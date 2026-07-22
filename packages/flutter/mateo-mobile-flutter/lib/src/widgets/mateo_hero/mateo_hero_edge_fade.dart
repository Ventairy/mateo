part of 'mateo_hero.dart';

/// The top and bottom edge-fade configuration for a [MateoHeroBackground].
///
/// Each side accepts a [MateoEdgeFadeStyle]. When a side is `null`, no fade is
/// rendered on that edge at rest. During a hero flight, an absent side on one
/// endpoint animates its height to `0` against the present side so the fade
/// gracefully grows in or out instead of jumping.
///
/// See also:
///  * [MateoEdgeFadeStyle], the style of a single fade edge.
///  * [MateoEdgeFade], the widget that renders a single fade edge.
@immutable
class MateoHeroEdgeFade {
  /// Creates a Mateo Mobile hero edge-fade configuration.
  const MateoHeroEdgeFade({this.top, this.bottom, this.switchThreshold = 1.0})
    : assert(
        switchThreshold >= 0.0 && switchThreshold <= 1.0,
        'switchThreshold must be between 0.0 and 1.0.',
      );

  /// Style for the top edge fade. `null` means no top fade at rest.
  final MateoEdgeFadeStyle? top;

  /// Style for the bottom edge fade. `null` means no bottom fade at rest.
  final MateoEdgeFadeStyle? bottom;

  /// The flight progress threshold at which the fade reaches its destination style.
  ///
  /// The threshold belongs to the source side of the flight, matching
  /// [MateoHeroText.switchThreshold]. A value of `0.1` makes the fade interpolate
  /// from source to destination during the first 10% of the flight, then keep
  /// the destination style for the remaining flight.
  final double switchThreshold;

  /// Convenience constant enabling both vertical edges with default
  /// (runtime-resolved) styles — mirrors [MateoEdgeFade]'s out-of-the-box look
  /// on both the top and bottom edges.
  static const vertical = MateoHeroEdgeFade(
    top: MateoEdgeFadeStyle(),
    bottom: MateoEdgeFadeStyle(),
  );

  /// Returns the style for a given [position], or `null` if that side has no
  /// fade configured.
  MateoEdgeFadeStyle? styleFor(MateoEdgeFadePosition position) {
    return switch (position) {
      MateoEdgeFadePosition.top => top,
      MateoEdgeFadePosition.bottom => bottom,
    };
  }

  /// Resolves both sides against [context] so the flight shuttle can
  /// interpolate fully concrete styles. Absent sides become a style with
  /// `height: 0` and the resolved background color, so lerping to/from an
  /// absent side animates height to/from `0` rather than jumping.
  MateoHeroEdgeFade resolve(BuildContext context) {
    final resolvedColor =
        Theme.of(context).extension<MateoThemeData>()?.colorScheme.background ??
        const Color(0xFFFFFFFF);

    return MateoHeroEdgeFade(
      top:
          top?.resolve(context) ??
          MateoEdgeFadeStyle(color: resolvedColor, height: 0),
      bottom:
          bottom?.resolve(context) ??
          MateoEdgeFadeStyle(color: resolvedColor, height: 0),
      switchThreshold: switchThreshold,
    );
  }

  /// Interpolates between two resolved configurations. Both sides are always
  /// lerped; callers should render a side only when its lerped `height > 0`.
  // ignore: prefer_constructors_over_static_methods
  static MateoHeroEdgeFade lerp(
    MateoHeroEdgeFade a,
    MateoHeroEdgeFade b,
    double t,
  ) {
    final thresholdProgress = _switchThresholdProgress(
      lerpValue: t,
      switchThreshold: a.switchThreshold,
    );

    return MateoHeroEdgeFade(
      top: MateoEdgeFadeStyle.lerp(a.top, b.top, thresholdProgress),
      bottom: MateoEdgeFadeStyle.lerp(a.bottom, b.bottom, thresholdProgress),
      switchThreshold: a.switchThreshold,
    );
  }

  static double _switchThresholdProgress({
    required double lerpValue,
    required double switchThreshold,
  }) {
    if (switchThreshold <= 0) return 1;

    return (lerpValue / switchThreshold).clamp(0.0, 1.0);
  }

  /// A copy of this edge-fade configuration with selected fields replaced.
  MateoHeroEdgeFade copyWith({
    MateoEdgeFadeStyle? top,
    MateoEdgeFadeStyle? bottom,
    double? switchThreshold,
  }) {
    return MateoHeroEdgeFade(
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
      switchThreshold: switchThreshold ?? this.switchThreshold,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is MateoHeroEdgeFade &&
      other.top == top &&
      other.bottom == bottom &&
      other.switchThreshold == switchThreshold;

  @override
  int get hashCode => Object.hash(top, bottom, switchThreshold);
}
