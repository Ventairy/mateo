part of 'mateo_color_scheme.dart';

/// Text-input colors grouped by Mateo text-input variant.
@immutable
class MateoTextFieldColorScheme {
  /// Creates grouped color roles for Mateo text-input variants.
  ///
  const MateoTextFieldColorScheme({
    required this.floating,
    required this.filled,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoTextFieldColorScheme.lerp(
    MateoTextFieldColorScheme a,
    MateoTextFieldColorScheme b,
    double t,
  ) => MateoTextFieldColorScheme(
    floating: MateoTextFieldVariantColorScheme.lerp(a.floating, b.floating, t),
    filled: MateoTextFieldVariantColorScheme.lerp(a.filled, b.filled, t),
  );

  /// Floating search text-input color roles.
  final MateoTextFieldVariantColorScheme floating;

  /// Filled search text-input color roles.
  final MateoTextFieldVariantColorScheme filled;

  /// {@macro mateo_color_scheme_copy_with}
  MateoTextFieldColorScheme copyWith({
    MateoTextFieldVariantColorScheme? floating,
    MateoTextFieldVariantColorScheme? filled,
  }) => MateoTextFieldColorScheme(
    floating: floating ?? this.floating,
    filled: filled ?? this.filled,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoTextFieldColorScheme && floating == other.floating && filled == other.filled;

  @override
  int get hashCode => Object.hash(floating, filled);
}
