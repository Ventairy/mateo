part of 'mateo_color_scheme.dart';

/// The colors of the prominent button treatments.
@immutable
final class MateoPrimaryButtonColorScheme {
  const MateoPrimaryButtonColorScheme._({
    required this.accent,
    required this.success,
    required this.warning,
    required this.neutral,
    required this.base,
  });

  /// The product-accent treatment.
  final MateoButtonColorScheme accent;

  /// The treatment for clearly positive actions.
  final MateoButtonColorScheme success;

  /// The treatment for actions that need attention.
  final MateoButtonColorScheme warning;

  /// The dark neutral treatment.
  final MateoButtonColorScheme neutral;

  /// The white surface treatment.
  final MateoButtonColorScheme base;

  /// Whether every color role equals the other scheme.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoPrimaryButtonColorScheme &&
          accent == other.accent &&
          success == other.success &&
          warning == other.warning &&
          neutral == other.neutral &&
          base == other.base;

  /// The hash of this scheme's color roles.
  @override
  int get hashCode => Object.hash(accent, success, warning, neutral, base);
}
