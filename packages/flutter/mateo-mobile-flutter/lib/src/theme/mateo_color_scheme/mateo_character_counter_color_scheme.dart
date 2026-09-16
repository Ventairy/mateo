part of 'mateo_color_scheme.dart';

/// Character-counter colors grouped by Mateo character-counter variant.
@immutable
class MateoCharacterCounterColorScheme {
  /// Creates grouped color roles for Mateo character-counter variants.
  const MateoCharacterCounterColorScheme({
    required this.floating,
    required this.text,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoCharacterCounterColorScheme.lerp(
    MateoCharacterCounterColorScheme a,
    MateoCharacterCounterColorScheme b,
    double t,
  ) => MateoCharacterCounterColorScheme(
    floating: MateoCharacterCounterVariantColorScheme.lerp(a.floating, b.floating, t),
    text: MateoCharacterCounterVariantColorScheme.lerp(a.text, b.text, t),
  );

  /// Floating character-counter color roles.
  final MateoCharacterCounterVariantColorScheme floating;

  /// Text-only character-counter color roles.
  final MateoCharacterCounterVariantColorScheme text;

  /// {@macro mateo_color_scheme_copy_with}
  MateoCharacterCounterColorScheme copyWith({
    MateoCharacterCounterVariantColorScheme? floating,
    MateoCharacterCounterVariantColorScheme? text,
  }) => MateoCharacterCounterColorScheme(
    floating: floating ?? this.floating,
    text: text ?? this.text,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoCharacterCounterColorScheme && floating == other.floating && text == other.text;

  @override
  int get hashCode => Object.hash(floating, text);
}
