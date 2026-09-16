part of 'mateo_color_scheme.dart';

/// Semantic colors for one closed Mateo select presentation.
@immutable
class MateoSelectVariantColorScheme {
  /// Creates the complete color contract for a select.
  const MateoSelectVariantColorScheme({
    required this.background,
    required this.title,
    required this.icon,
    required this.chevron,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoSelectVariantColorScheme.lerp(
    MateoSelectVariantColorScheme a,
    MateoSelectVariantColorScheme b,
    double t,
  ) => MateoSelectVariantColorScheme(
    background: Color.lerp(a.background, b.background, t)!,
    title: Color.lerp(a.title, b.title, t)!,
    icon: Color.lerp(a.icon, b.icon, t)!,
    chevron: Color.lerp(a.chevron, b.chevron, t)!,
  );

  /// Surface color behind the closed control.
  final Color background;

  /// Primary option-title color.
  final Color title;

  /// Recommended default color for option icons.
  ///
  /// Option builders may use another color when the icon communicates a
  /// category, status, brand, or other meaning that benefits from color.
  final Color icon;

  /// Disclosure-chevron color on the closed control.
  final Color chevron;

  /// {@macro mateo_color_scheme_copy_with}
  MateoSelectVariantColorScheme copyWith({
    Color? background,
    Color? title,
    Color? icon,
    Color? chevron,
  }) => MateoSelectVariantColorScheme(
    background: background ?? this.background,
    title: title ?? this.title,
    icon: icon ?? this.icon,
    chevron: chevron ?? this.chevron,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoSelectVariantColorScheme &&
          background == other.background &&
          title == other.title &&
          icon == other.icon &&
          chevron == other.chevron;

  @override
  int get hashCode => Object.hash(
    background,
    title,
    icon,
    chevron,
  );
}
