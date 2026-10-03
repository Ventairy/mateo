part of 'mateo_button_variant.dart';

/// The supported transparent button treatments.
enum MateoTertiaryButtonVariant implements MateoButtonVariant {
  _neutral;

  /// The transparent surface with a neutral foreground.
  MateoButtonVariant get neutral => _neutral;

  /// The colors of this treatment from [colors].
  @override
  MateoButtonColorScheme resolveColorScheme(MateoButtonsColorScheme colors) => colors.tertiary;

  /// The press feedback associated with this treatment.
  @override
  MateoPressAnimationType get pressAnimation => .scaleFade;
}
