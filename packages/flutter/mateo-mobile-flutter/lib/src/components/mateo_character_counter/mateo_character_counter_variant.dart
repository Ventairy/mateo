part of 'mateo_character_counter.dart';

/// Visual variants available to Mateo character counters.
enum MateoCharacterCounterVariant {
  /// A pill-shaped counter with a floating surface at elevation one.
  floating,

  /// A counter rendered as text without a visible surface.
  text;

  EdgeInsetsGeometry get _defaultPadding => switch (this) {
    MateoCharacterCounterVariant.floating => const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    MateoCharacterCounterVariant.text => EdgeInsets.zero,
  };

  MateoCharacterCounterVariantColorScheme _colors(MateoCharacterCounterColorScheme colors) => switch (this) {
    MateoCharacterCounterVariant.floating => colors.floating,
    MateoCharacterCounterVariant.text => colors.text,
  };
}
