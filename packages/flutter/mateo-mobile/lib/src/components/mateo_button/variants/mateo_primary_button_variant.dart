part of 'mateo_button_variant.dart';

/// The supported prominent button treatments.
enum MateoPrimaryButtonVariant implements MateoButtonVariant {
  _accent,
  _neutral,
  _base;

  /// The product-accent surface and its matching foreground.
  MateoButtonVariant get accent => _accent;

  /// The dark neutral surface with a light foreground.
  MateoButtonVariant get neutral => _neutral;

  /// The white surface with a dark foreground.
  MateoButtonVariant get base => _base;

  /// The colors of this treatment from [colors].
  @override
  MateoButtonColorScheme resolveColorScheme(MateoButtonsColorScheme colors) => switch (this) {
    ._accent => colors.primary.accent,
    ._neutral => colors.primary.neutral,
    ._base => colors.primary.base,
  };

  /// The press feedback associated with this treatment.
  @override
  MateoPressAnimationType get pressAnimation => .scale;
}
