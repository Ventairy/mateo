part of 'mateo_color_scheme.dart';

/// Theme-authored semantic color variants.
@immutable
class MateoColorsColorScheme {
  /// Creates the complete semantic color-variant collection.
  const MateoColorsColorScheme({required this.neutral});

  /// {@macro mateo_color_scheme_lerp}
  factory MateoColorsColorScheme.lerp(
    MateoColorsColorScheme a,
    MateoColorsColorScheme b,
    double t,
  ) => MateoColorsColorScheme(
    neutral: MateoColorVariantColorScheme.lerp(a.neutral, b.neutral, t),
  );

  /// Neutral solid color variant.
  final MateoColorVariantColorScheme neutral;

  /// {@macro mateo_color_scheme_copy_with}
  MateoColorsColorScheme copyWith({MateoColorVariantColorScheme? neutral}) =>
      MateoColorsColorScheme(neutral: neutral ?? this.neutral);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoColorsColorScheme && neutral == other.neutral;

  @override
  int get hashCode => neutral.hashCode;
}
