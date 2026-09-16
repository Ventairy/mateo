part of 'mateo_color_scheme.dart';

/// Button roles grouped by the component patterns used across Mateo.
///
/// Read this group when styling a concrete Mateo button pattern.
@immutable
class MateoButtonsColorScheme {
  /// Creates grouped button roles for the button patterns used across Mateo.
  const MateoButtonsColorScheme({
    required this.primary,
    required this.secondary,
    required this.tertiary,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoButtonsColorScheme.lerp(
    MateoButtonsColorScheme a,
    MateoButtonsColorScheme b,
    double t,
  ) {
    return MateoButtonsColorScheme(
      primary: MateoPrimaryButtonColorScheme.lerp(a.primary, b.primary, t),
      secondary: MateoSecondaryButtonColorScheme.lerp(a.secondary, b.secondary, t),
      tertiary: MateoTertiaryButtonColorScheme.lerp(a.tertiary, b.tertiary, t),
    );
  }

  /// Primary button colors.
  final MateoPrimaryButtonColorScheme primary;

  /// Secondary button colors.
  final MateoSecondaryButtonColorScheme secondary;

  /// Compact text-action colors.
  final MateoTertiaryButtonColorScheme tertiary;

  /// {@macro mateo_color_scheme_copy_with}
  MateoButtonsColorScheme copyWith({
    MateoPrimaryButtonColorScheme? primary,
    MateoSecondaryButtonColorScheme? secondary,
    MateoTertiaryButtonColorScheme? tertiary,
  }) {
    return MateoButtonsColorScheme(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoButtonsColorScheme &&
          primary == other.primary &&
          secondary == other.secondary &&
          tertiary == other.tertiary;

  @override
  int get hashCode => Object.hashAll([
    primary,
    secondary,
    tertiary,
  ]);
}
