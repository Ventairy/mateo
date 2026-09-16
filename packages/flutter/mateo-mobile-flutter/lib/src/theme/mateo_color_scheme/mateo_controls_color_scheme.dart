part of 'mateo_color_scheme.dart';

/// Track colors for progress controls.
///
/// Defines the unfilled and filled portions of a progress track.
@immutable
class MateoControlsColorScheme {
  /// Creates track colors for progress controls.
  const MateoControlsColorScheme({
    required this.track,
    required this.trackFilled,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoControlsColorScheme.lerp(
    MateoControlsColorScheme a,
    MateoControlsColorScheme b,
    double t,
  ) {
    return MateoControlsColorScheme(
      track: Color.lerp(a.track, b.track, t)!,
      trackFilled: Color.lerp(a.trackFilled, b.trackFilled, t)!,
    );
  }

  /// Unfilled track color for controls such as sliders and toggles.
  final Color track;

  /// Filled track color for selected or progressed control tracks.
  final Color trackFilled;

  /// {@macro mateo_color_scheme_copy_with}
  MateoControlsColorScheme copyWith({
    Color? track,
    Color? trackFilled,
  }) {
    return MateoControlsColorScheme(
      track: track ?? this.track,
      trackFilled: trackFilled ?? this.trackFilled,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoControlsColorScheme && track == other.track && trackFilled == other.trackFilled;

  @override
  int get hashCode => Object.hash(track, trackFilled);
}
