part of 'mateo_color_scheme.dart';

/// Shared text colors in the Mateo mobile color scheme.
@immutable
class MateoTextColorScheme {
  /// Creates the shared Mateo text color contract.
  const MateoTextColorScheme({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.profit,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoTextColorScheme.lerp(
    MateoTextColorScheme a,
    MateoTextColorScheme b,
    double t,
  ) => MateoTextColorScheme(
    primary: Color.lerp(a.primary, b.primary, t)!,
    secondary: Color.lerp(a.secondary, b.secondary, t)!,
    tertiary: Color.lerp(a.tertiary, b.tertiary, t)!,
    profit: Color.lerp(a.profit, b.profit, t)!,
  );

  /// Highest-emphasis text color.
  final Color primary;

  /// Supporting text color.
  final Color secondary;

  /// Lower-emphasis text color.
  final Color tertiary;

  /// Accent for money or profit amounts such as `$1,200`.
  ///
  /// This color is not suitable for body text because it does not meet the
  /// required WCAG contrast against Mateo's default background.
  final Color profit;

  /// {@macro mateo_color_scheme_copy_with}
  MateoTextColorScheme copyWith({
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? profit,
  }) => MateoTextColorScheme(
    primary: primary ?? this.primary,
    secondary: secondary ?? this.secondary,
    tertiary: tertiary ?? this.tertiary,
    profit: profit ?? this.profit,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoTextColorScheme &&
          primary == other.primary &&
          secondary == other.secondary &&
          tertiary == other.tertiary &&
          profit == other.profit;

  @override
  int get hashCode => Object.hash(primary, secondary, tertiary, profit);
}
