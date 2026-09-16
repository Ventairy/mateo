part of 'mateo_button.dart';

/// A button treatment and color selection resolved from the current theme.
///
/// Use [primary] or [secondary] for filled actions and [tertiary] for compact
/// text actions. Each group exposes only the colors supported by that
/// treatment; elevation is configured independently by [MateoButtonPresentation].
@immutable
sealed class MateoButtonVariant {
  /// Primary presets, defaulting to accent.
  static const MateoPrimaryButtonVariant primary = MateoPrimaryButtonVariant._accent;

  /// Secondary presets, defaulting to accent.
  static const MateoSecondaryButtonVariant secondary = MateoSecondaryButtonVariant._accent;

  /// A compact text action, defaulting to the neutral foreground.
  static const MateoTertiaryButtonVariant tertiary = MateoTertiaryButtonVariant._neutral;

  /// Resolves this preset against the current [colorScheme].
  MateoButtonColorScheme colorScheme(MateoColorScheme colorScheme);
}
