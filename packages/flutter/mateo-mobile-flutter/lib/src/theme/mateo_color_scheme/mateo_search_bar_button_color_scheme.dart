part of 'mateo_color_scheme.dart';

/// Color roles for the Mateo search bar button.
@immutable
class MateoSearchBarButtonColorScheme {
  /// Creates the complete color contract for a search bar button.
  const MateoSearchBarButtonColorScheme({
    required this.background,
    required this.backgroundPressed,
    required this.foreground,
    required this.border,
    required this.shadow,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoSearchBarButtonColorScheme.lerp(
    MateoSearchBarButtonColorScheme a,
    MateoSearchBarButtonColorScheme b,
    double t,
  ) => MateoSearchBarButtonColorScheme(
    background: Color.lerp(a.background, b.background, t)!,
    backgroundPressed: Color.lerp(
      a.backgroundPressed,
      b.backgroundPressed,
      t,
    )!,
    foreground: Color.lerp(a.foreground, b.foreground, t)!,
    border: Color.lerp(a.border, b.border, t)!,
    shadow: Color.lerp(a.shadow, b.shadow, t)!,
  );

  /// Background color at rest.
  final Color background;

  /// Background color while pressed.
  final Color backgroundPressed;

  /// Search icon and title color.
  final Color foreground;

  /// Border color around the search surface.
  final Color border;

  /// Shadow color below the search surface.
  final Color shadow;

  /// {@macro mateo_color_scheme_copy_with}
  MateoSearchBarButtonColorScheme copyWith({
    Color? background,
    Color? backgroundPressed,
    Color? foreground,
    Color? border,
    Color? shadow,
  }) => MateoSearchBarButtonColorScheme(
    background: background ?? this.background,
    backgroundPressed: backgroundPressed ?? this.backgroundPressed,
    foreground: foreground ?? this.foreground,
    border: border ?? this.border,
    shadow: shadow ?? this.shadow,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoSearchBarButtonColorScheme &&
          background == other.background &&
          backgroundPressed == other.backgroundPressed &&
          foreground == other.foreground &&
          border == other.border &&
          shadow == other.shadow;

  @override
  int get hashCode => Object.hash(
    background,
    backgroundPressed,
    foreground,
    border,
    shadow,
  );
}
