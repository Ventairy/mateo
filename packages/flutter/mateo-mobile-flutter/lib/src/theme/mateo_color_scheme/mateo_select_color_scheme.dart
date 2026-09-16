part of 'mateo_color_scheme.dart';

/// Semantic colors grouped by closed Mateo select presentation.
@immutable
class MateoSelectColorScheme {
  /// Creates the color groups for a Mateo select.
  const MateoSelectColorScheme({required this.neutral, required this.ghost});

  /// {@macro mateo_color_scheme_lerp}
  factory MateoSelectColorScheme.lerp(MateoSelectColorScheme a, MateoSelectColorScheme b, double t) =>
      MateoSelectColorScheme(
        neutral: MateoSelectVariantColorScheme.lerp(a.neutral, b.neutral, t),
        ghost: MateoSelectVariantColorScheme.lerp(a.ghost, b.ghost, t),
      );

  /// Colors for the subtle filled control.
  final MateoSelectVariantColorScheme neutral;

  /// Colors for the transparent control.
  final MateoSelectVariantColorScheme ghost;

  /// {@macro mateo_color_scheme_copy_with}
  MateoSelectColorScheme copyWith({MateoSelectVariantColorScheme? neutral, MateoSelectVariantColorScheme? ghost}) =>
      MateoSelectColorScheme(neutral: neutral ?? this.neutral, ghost: ghost ?? this.ghost);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MateoSelectColorScheme && neutral == other.neutral && ghost == other.ghost;

  @override
  int get hashCode => Object.hash(neutral, ghost);
}
