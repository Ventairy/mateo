part of 'mateo_text_input_variant.dart';

/// The supported filled text input treatments.
enum MateoFilledTextInputVariant implements MateoTextInputVariant {
  _neutral,
  _base;

  /// A gray surface with dark text and gray supporting content.
  MateoTextInputVariant get neutral => _neutral;

  /// A white surface with the same content colors as neutral.
  MateoTextInputVariant get base => _base;

  @override
  MateoTextInputColorScheme resolveColorScheme(MateoTextInputsColorScheme colors) => switch (this) {
    _neutral => colors.filled.neutral,
    _base => colors.filled.base,
  };
}
