part of 'mateo_button.dart';

/// Supported secondary button presets. The group itself selects accent.
enum MateoSecondaryButtonVariant implements MateoButtonVariant {
  _accent,
  _neutral;

  /// The accent secondary treatment.
  MateoButtonVariant get accent => _accent;

  /// The neutral secondary treatment.
  MateoButtonVariant get neutral => _neutral;

  @override
  MateoButtonColorScheme colorScheme(MateoColorScheme colorScheme) => switch (this) {
    _accent => colorScheme.buttons.secondary.accent,
    _neutral => colorScheme.buttons.secondary.neutral,
  };
}
