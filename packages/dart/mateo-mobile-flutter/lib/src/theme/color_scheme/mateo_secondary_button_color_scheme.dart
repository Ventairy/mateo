part of 'mateo_color_scheme.dart';

/// The colors of the quieter button treatments.
@immutable
final class MateoSecondaryButtonColorScheme {
  const MateoSecondaryButtonColorScheme._({required this.accent, required this.neutral});

  /// The soft accent treatment.
  final MateoButtonColorScheme accent;

  /// The soft neutral treatment.
  final MateoButtonColorScheme neutral;

  /// Whether every color role equals the other scheme.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoSecondaryButtonColorScheme && accent == other.accent && neutral == other.neutral;

  /// The hash of this scheme's color roles.
  @override
  int get hashCode => Object.hash(accent, neutral);
}
