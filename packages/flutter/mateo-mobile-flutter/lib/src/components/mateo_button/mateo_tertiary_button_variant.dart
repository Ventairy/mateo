part of 'mateo_button.dart';

/// Supported tertiary button presets. The group itself selects neutral.
enum MateoTertiaryButtonVariant implements MateoButtonVariant {
  _neutral;

  /// The neutral tertiary treatment.
  MateoButtonVariant get neutral => _neutral;

  @override
  MateoButtonColorScheme colorScheme(MateoColorScheme colorScheme) => colorScheme.buttons.tertiary.neutral;
}
