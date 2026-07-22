part of 'mateo_color_scheme.dart';

/// Button roles for floating action surfaces.
///
/// Floating actions have extra visual needs beyond a standard button, such as
/// a dedicated border and shadow. This group gives consumers the complete color
/// set needed to render a floating action consistently.
@immutable
class MateoFloatingButtonColorScheme {
  /// Creates button roles for floating action surfaces.
  const MateoFloatingButtonColorScheme({
    required this.background,
    required this.backgroundPressed,
    required this.backgroundDisabled,
    required this.foreground,
    required this.foregroundDisabled,
    required this.border,
    required this.shadow,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoFloatingButtonColorScheme.lerp(
    MateoFloatingButtonColorScheme a,
    MateoFloatingButtonColorScheme b,
    double t,
  ) {
    return MateoFloatingButtonColorScheme(
      background: Color.lerp(a.background, b.background, t)!,
      backgroundPressed: Color.lerp(
        a.backgroundPressed,
        b.backgroundPressed,
        t,
      )!,
      backgroundDisabled: Color.lerp(
        a.backgroundDisabled,
        b.backgroundDisabled,
        t,
      )!,
      foreground: Color.lerp(a.foreground, b.foreground, t)!,
      foregroundDisabled: Color.lerp(
        a.foregroundDisabled,
        b.foregroundDisabled,
        t,
      )!,
      border: Color.lerp(a.border, b.border, t)!,
      shadow: Color.lerp(a.shadow, b.shadow, t)!,
    );
  }

  /// Background color for the resting floating button surface.
  final Color background;

  /// Background color while the floating button is pressed.
  final Color backgroundPressed;

  /// Background color for the disabled floating button surface.
  final Color backgroundDisabled;

  /// Foreground color for text and icons on the resting floating button surface.
  final Color foreground;

  /// Foreground color for text and icons on the disabled floating button surface.
  final Color foregroundDisabled;

  /// Border color that keeps the floating surface legible over variable content.
  final Color border;

  /// Shadow color used to separate the floating surface from underlying content.
  final Color shadow;

  /// {@macro mateo_color_scheme_copy_with}
  MateoFloatingButtonColorScheme copyWith({
    Color? background,
    Color? backgroundPressed,
    Color? backgroundDisabled,
    Color? foreground,
    Color? foregroundDisabled,
    Color? border,
    Color? shadow,
  }) {
    return MateoFloatingButtonColorScheme(
      background: background ?? this.background,
      backgroundPressed: backgroundPressed ?? this.backgroundPressed,
      backgroundDisabled: backgroundDisabled ?? this.backgroundDisabled,
      foreground: foreground ?? this.foreground,
      foregroundDisabled: foregroundDisabled ?? this.foregroundDisabled,
      border: border ?? this.border,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoFloatingButtonColorScheme &&
          background == other.background &&
          backgroundPressed == other.backgroundPressed &&
          backgroundDisabled == other.backgroundDisabled &&
          foreground == other.foreground &&
          foregroundDisabled == other.foregroundDisabled &&
          border == other.border &&
          shadow == other.shadow;

  @override
  int get hashCode => Object.hash(
    background,
    backgroundPressed,
    backgroundDisabled,
    foreground,
    foregroundDisabled,
    border,
    shadow,
  );
}
