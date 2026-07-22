part of 'mateo_color_scheme.dart';

/// High-contrast inverse surface roles.
///
/// Use this group when a surface intentionally flips away from the default page
/// background, such as dark chips, inverse banners, or emphasized containers.
/// These roles stay separate from [MateoColorScheme.text] and
/// [MateoColorScheme.background] so consumers can style inverse surfaces without
/// mixing default-surface roles into them.
@immutable
class MateoInverseColorScheme {
  /// Creates high-contrast inverse surface roles.
  const MateoInverseColorScheme({
    required this.background,
    required this.onBackground,
    required this.primary,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoInverseColorScheme.lerp(
    MateoInverseColorScheme a,
    MateoInverseColorScheme b,
    double t,
  ) {
    return MateoInverseColorScheme(
      background: Color.lerp(a.background, b.background, t)!,
      onBackground: Color.lerp(a.onBackground, b.onBackground, t)!,
      primary: Color.lerp(a.primary, b.primary, t)!,
    );
  }

  /// Background color for the inverse surface.
  final Color background;

  /// Readable foreground color placed on [background].
  final Color onBackground;

  /// Primary accent color intended for use within inverse surfaces.
  final Color primary;

  /// {@macro mateo_color_scheme_copy_with}
  MateoInverseColorScheme copyWith({
    Color? background,
    Color? onBackground,
    Color? primary,
  }) {
    return MateoInverseColorScheme(
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      primary: primary ?? this.primary,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoInverseColorScheme &&
          background == other.background &&
          onBackground == other.onBackground &&
          primary == other.primary;

  @override
  int get hashCode => Object.hash(background, onBackground, primary);
}
