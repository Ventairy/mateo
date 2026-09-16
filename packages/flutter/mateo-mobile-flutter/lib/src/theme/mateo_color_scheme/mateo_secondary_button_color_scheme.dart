part of 'mateo_color_scheme.dart';

/// Authored colors for the supported secondary button presets.
@immutable
class MateoSecondaryButtonColorScheme {
  /// Creates the complete secondary color collection.
  const MateoSecondaryButtonColorScheme({
    required this.accent,
    required this.neutral,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoSecondaryButtonColorScheme.lerp(
    MateoSecondaryButtonColorScheme a,
    MateoSecondaryButtonColorScheme b,
    double t,
  ) => MateoSecondaryButtonColorScheme(
    accent: MateoButtonColorScheme.lerp(a.accent, b.accent, t),
    neutral: MateoButtonColorScheme.lerp(a.neutral, b.neutral, t),
  );

  /// Colors for the accent treatment.
  final MateoButtonColorScheme accent;

  /// Colors for the neutral treatment.
  final MateoButtonColorScheme neutral;

  /// {@macro mateo_color_scheme_copy_with}
  MateoSecondaryButtonColorScheme copyWith({MateoButtonColorScheme? accent, MateoButtonColorScheme? neutral}) =>
      MateoSecondaryButtonColorScheme(
        accent: accent ?? this.accent,
        neutral: neutral ?? this.neutral,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoSecondaryButtonColorScheme && accent == other.accent && neutral == other.neutral;

  @override
  int get hashCode => Object.hash(accent, neutral);
}
