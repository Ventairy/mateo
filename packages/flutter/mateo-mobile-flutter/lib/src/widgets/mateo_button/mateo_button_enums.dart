part of 'mateo_button.dart';

/// Visual style variants available to [MateoButton].
///
/// Each variant resolves a [MateoButtonColorScheme] from the active
/// [MateoColorScheme].
enum MateoButtonVariant {
  /// Primary action style for the most important action in a view.
  primary,

  /// Secondary action style for supportive or lower-emphasis actions.
  secondary;

  /// The themed [MateoButtonColorScheme] for this variant.
  MateoButtonColorScheme colorScheme(MateoColorScheme colorScheme) {
    switch (this) {
      case MateoButtonVariant.primary:
        return colorScheme.buttons.primary;
      case MateoButtonVariant.secondary:
        return colorScheme.buttons.secondary;
    }
  }
}
