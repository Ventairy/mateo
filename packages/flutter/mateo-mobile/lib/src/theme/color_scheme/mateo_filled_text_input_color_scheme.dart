part of 'mateo_color_scheme.dart';

/// The colors of the filled text input treatments.
@immutable
final class MateoFilledTextInputColorScheme {
  const MateoFilledTextInputColorScheme._({required this.neutral, required this.base});

  /// The gray surface treatment.
  final MateoTextInputColorScheme neutral;

  /// The white surface treatment.
  final MateoTextInputColorScheme base;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoFilledTextInputColorScheme && neutral == other.neutral && base == other.base;

  @override
  int get hashCode => Object.hash(neutral, base);
}
