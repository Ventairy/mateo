part of 'mateo_color_scheme.dart';

/// Authored colors for the supported tertiary button presets.
@immutable
class MateoTertiaryButtonColorScheme {
  /// Creates the complete tertiary color collection.
  const MateoTertiaryButtonColorScheme({required this.neutral});

  /// {@macro mateo_color_scheme_lerp}
  factory MateoTertiaryButtonColorScheme.lerp(
    MateoTertiaryButtonColorScheme a,
    MateoTertiaryButtonColorScheme b,
    double t,
  ) => MateoTertiaryButtonColorScheme(neutral: MateoButtonColorScheme.lerp(a.neutral, b.neutral, t));

  /// Colors for the neutral treatment.
  final MateoButtonColorScheme neutral;

  /// {@macro mateo_color_scheme_copy_with}
  MateoTertiaryButtonColorScheme copyWith({MateoButtonColorScheme? neutral}) =>
      MateoTertiaryButtonColorScheme(neutral: neutral ?? this.neutral);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MateoTertiaryButtonColorScheme && neutral == other.neutral;

  @override
  int get hashCode => neutral.hashCode;
}
