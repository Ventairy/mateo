part of 'mateo_color_scheme.dart';

/// The colors of the prominent button treatments.
@immutable
final class MateoPrimaryButtonColorScheme {
  const MateoPrimaryButtonColorScheme._({required this.accent, required this.neutral, required this.base});

  /// The product-accent treatment.
  final MateoButtonColorScheme accent;

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
          neutral == other.neutral &&
          base == other.base;

  /// The hash of this scheme's color roles.
  @override
  int get hashCode => Object.hash(accent, neutral, base);
}
