part of 'mateo_button.dart';

/// Supported primary button presets. The group itself selects accent.
enum MateoPrimaryButtonVariant implements MateoButtonVariant {
  _accent,
  _neutral,
  _base;

  /// The accent primary treatment.
  MateoButtonVariant get accent => _accent;

  /// The neutral primary treatment.
  MateoButtonVariant get neutral => _neutral;

  /// The base primary treatment.
  MateoButtonVariant get base => _base;

  @override
  MateoButtonColorScheme colorScheme(MateoColorScheme colorScheme) => switch (this) {
    _accent => colorScheme.buttons.primary.accent,
    _neutral => colorScheme.buttons.primary.neutral,
    _base => colorScheme.buttons.primary.base,
  };
}
