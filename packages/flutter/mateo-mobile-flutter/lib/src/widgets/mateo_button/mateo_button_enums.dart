part of 'mateo_button.dart';

/// Color tones available to [MateoButton].
enum MateoButtonTone {
  /// The active Mateo accent color family.
  accent;

  /// The themed button variants for this tone.
  MateoButtonToneColorScheme colorScheme(MateoColorScheme colorScheme) {
    switch (this) {
      case MateoButtonTone.accent:
        return colorScheme.buttons.accent;
    }
  }
}

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
  MateoButtonColorScheme colorScheme(MateoButtonToneColorScheme colorScheme) {
    switch (this) {
      case MateoButtonVariant.primary:
        return colorScheme.primary;
      case MateoButtonVariant.secondary:
        return colorScheme.secondary;
    }
  }
}
