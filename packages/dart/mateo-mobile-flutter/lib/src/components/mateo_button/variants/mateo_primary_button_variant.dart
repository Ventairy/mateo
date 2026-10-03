part of 'mateo_button_variant.dart';

/// The supported prominent button treatments.
enum MateoPrimaryButtonVariant implements MateoButtonVariant {
  _accent,
  _success,
  _warning,
  _neutral,
  _base;

  /// The product-accent surface and its matching foreground.
  MateoButtonVariant get accent => _accent;

  /// The green surface for a clearly positive action.
  MateoButtonVariant get success => _success;

  /// The amber surface with white content for an action that needs attention.
  MateoButtonVariant get warning => _warning;

  /// The dark neutral surface with a light foreground.
  MateoButtonVariant get neutral => _neutral;

  /// The white surface with a dark foreground.
  MateoButtonVariant get base => _base;

  /// The colors of this treatment from [colors].
  @override
  MateoButtonColorScheme resolveColorScheme(MateoButtonsColorScheme colors) => switch (this) {
    ._accent => colors.primary.accent,
    ._success => colors.primary.success,
    ._warning => colors.primary.warning,
    ._neutral => colors.primary.neutral,
    ._base => colors.primary.base,
  };

  /// The press feedback associated with this treatment.
  @override
  MateoPressAnimationType get pressAnimation => .scale;
}
