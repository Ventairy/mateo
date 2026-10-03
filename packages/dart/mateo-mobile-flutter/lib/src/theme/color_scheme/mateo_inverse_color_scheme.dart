part of 'mateo_color_scheme.dart';

/// The shared inverse color roles in a Mateo scheme.
@immutable
final class MateoInverseColorScheme {
  const MateoInverseColorScheme._({required this.background, required this.onBackground, required this.accent});

  /// The background for an inverse surface.
  final Color background;

  /// The foreground for the inverse background.
  final Color onBackground;

  /// The accent intended for inverse surfaces.
  final Color accent;

  /// Whether every color equals the other group's color.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoInverseColorScheme &&
          background == other.background &&
          onBackground == other.onBackground &&
          accent == other.accent;

  /// The hash of this group's colors.
  @override
  int get hashCode => Object.hash(background, onBackground, accent);
}
