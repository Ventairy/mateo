part of 'mateo_color_scheme.dart';

/// Semantic colors for a Mateo toggle.
@immutable
class MateoToggleColorScheme {
  /// Creates the complete color contract for a Mateo toggle.
  const MateoToggleColorScheme({
    required this.trackOn,
    required this.trackOff,
    required this.trackDisabled,
    required this.circleOn,
    required this.circleOff,
    required this.circleDisabled,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoToggleColorScheme.lerp(
    MateoToggleColorScheme a,
    MateoToggleColorScheme b,
    double t,
  ) => MateoToggleColorScheme(
    trackOn: Color.lerp(a.trackOn, b.trackOn, t)!,
    trackOff: Color.lerp(a.trackOff, b.trackOff, t)!,
    trackDisabled: Color.lerp(a.trackDisabled, b.trackDisabled, t)!,
    circleOn: Color.lerp(a.circleOn, b.circleOn, t)!,
    circleOff: Color.lerp(a.circleOff, b.circleOff, t)!,
    circleDisabled: Color.lerp(a.circleDisabled, b.circleDisabled, t)!,
  );

  /// Track color when the toggle is on.
  final Color trackOn;

  /// Track color when the toggle is off.
  final Color trackOff;

  /// Track color when the toggle is disabled.
  final Color trackDisabled;

  /// Circle color when the toggle is on.
  final Color circleOn;

  /// Circle color when the toggle is off.
  final Color circleOff;

  /// Circle color when the toggle is disabled.
  final Color circleDisabled;

  /// {@macro mateo_color_scheme_copy_with}
  MateoToggleColorScheme copyWith({
    Color? trackOn,
    Color? trackOff,
    Color? trackDisabled,
    Color? circleOn,
    Color? circleOff,
    Color? circleDisabled,
  }) => MateoToggleColorScheme(
    trackOn: trackOn ?? this.trackOn,
    trackOff: trackOff ?? this.trackOff,
    trackDisabled: trackDisabled ?? this.trackDisabled,
    circleOn: circleOn ?? this.circleOn,
    circleOff: circleOff ?? this.circleOff,
    circleDisabled: circleDisabled ?? this.circleDisabled,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoToggleColorScheme &&
          trackOn == other.trackOn &&
          trackOff == other.trackOff &&
          trackDisabled == other.trackDisabled &&
          circleOn == other.circleOn &&
          circleOff == other.circleOff &&
          circleDisabled == other.circleDisabled;

  @override
  int get hashCode => Object.hash(
    trackOn,
    trackOff,
    trackDisabled,
    circleOn,
    circleOff,
    circleDisabled,
  );
}
