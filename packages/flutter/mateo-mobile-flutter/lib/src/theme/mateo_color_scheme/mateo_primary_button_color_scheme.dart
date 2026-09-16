part of 'mateo_color_scheme.dart';

/// Authored colors for the supported primary button presets.
@immutable
class MateoPrimaryButtonColorScheme {
  /// Creates the complete primary color collection.
  const MateoPrimaryButtonColorScheme({
    required this.accent,
    required this.neutral,
    required this.base,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoPrimaryButtonColorScheme.lerp(
    MateoPrimaryButtonColorScheme a,
    MateoPrimaryButtonColorScheme b,
    double t,
  ) => MateoPrimaryButtonColorScheme(
    accent: MateoButtonColorScheme.lerp(a.accent, b.accent, t),
    neutral: MateoButtonColorScheme.lerp(a.neutral, b.neutral, t),
    base: MateoButtonColorScheme.lerp(a.base, b.base, t),
  );

  /// Colors for the accent treatment.
  final MateoButtonColorScheme accent;

  /// Colors for the neutral treatment.
  final MateoButtonColorScheme neutral;

  /// Colors for the base treatment.
  final MateoButtonColorScheme base;

  /// {@macro mateo_color_scheme_copy_with}
  MateoPrimaryButtonColorScheme copyWith({
    MateoButtonColorScheme? accent,
    MateoButtonColorScheme? neutral,
    MateoButtonColorScheme? base,
  }) => MateoPrimaryButtonColorScheme(
    accent: accent ?? this.accent,
    neutral: neutral ?? this.neutral,
    base: base ?? this.base,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoPrimaryButtonColorScheme &&
          accent == other.accent &&
          neutral == other.neutral &&
          base == other.base;

  @override
  int get hashCode => Object.hash(accent, neutral, base);
}
