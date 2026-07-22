part of 'mateo_color_scheme.dart';

/// Component-pattern roles for a single button treatment.
///
/// Each value maps directly to a state defined by the Mateo mobile color scheme.
@immutable
class MateoButtonColorScheme {
  /// Creates component-pattern roles for a single button treatment.
  const MateoButtonColorScheme({
    required this.background,
    required this.backgroundPressed,
    required this.backgroundDisabled,
    required this.foreground,
    required this.foregroundDisabled,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoButtonColorScheme.lerp(
    MateoButtonColorScheme a,
    MateoButtonColorScheme b,
    double t,
  ) {
    return MateoButtonColorScheme(
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
    );
  }

  /// Background color for the resting button surface.
  final Color background;

  /// Background color while the button is pressed.
  final Color backgroundPressed;

  /// Background color for the disabled button surface.
  final Color backgroundDisabled;

  /// Foreground color for text and icons on the resting button surface.
  final Color foreground;

  /// Foreground color for text and icons on the disabled button surface.
  final Color foregroundDisabled;

  /// {@macro mateo_color_scheme_copy_with}
  MateoButtonColorScheme copyWith({
    Color? background,
    Color? backgroundPressed,
    Color? backgroundDisabled,
    Color? foreground,
    Color? foregroundDisabled,
  }) {
    return MateoButtonColorScheme(
      background: background ?? this.background,
      backgroundPressed: backgroundPressed ?? this.backgroundPressed,
      backgroundDisabled: backgroundDisabled ?? this.backgroundDisabled,
      foreground: foreground ?? this.foreground,
      foregroundDisabled: foregroundDisabled ?? this.foregroundDisabled,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoButtonColorScheme &&
          background == other.background &&
          backgroundPressed == other.backgroundPressed &&
          backgroundDisabled == other.backgroundDisabled &&
          foreground == other.foreground &&
          foregroundDisabled == other.foregroundDisabled;

  @override
  int get hashCode => Object.hash(
    background,
    backgroundPressed,
    backgroundDisabled,
    foreground,
    foregroundDisabled,
  );
}
