part of 'mateo_button_variant.dart';

/// The supported quieter filled button treatments.
enum MateoSecondaryButtonVariant implements MateoButtonVariant {
  _accent,
  _neutral;

  /// The soft accent surface with an accent foreground.
  MateoButtonVariant get accent => _accent;

  /// The soft neutral surface with a dark foreground.
  MateoButtonVariant get neutral => _neutral;

  /// The colors of this treatment from [colors].
  @override
  MateoButtonColorScheme resolveColorScheme(MateoButtonsColorScheme colors) => switch (this) {
    ._accent => colors.secondary.accent,
    ._neutral => colors.secondary.neutral,
  };

  /// The press feedback associated with this treatment.
  @override
  MateoPressAnimationType get pressAnimation => .scale;
}
