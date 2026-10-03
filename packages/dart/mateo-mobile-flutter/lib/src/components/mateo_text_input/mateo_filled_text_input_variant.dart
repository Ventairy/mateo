part of 'mateo_text_input_variant.dart';

/// The supported filled text input treatments.
enum MateoFilledTextInputVariant implements MateoTextInputVariant {
  _neutral,
  _base;

  /// A gray surface with dark text and gray supporting content.
  MateoTextInputVariant get neutral => _neutral;

  /// A white surface with the same content colors as neutral.
  MateoTextInputVariant get base => _base;

  /// Resolves the typography for a supported filled input size.
  @override
  ({double fontSize, double lineHeight}) resolveTypography(MateoTextInputSize size) {
    assert(size != MateoTextInputSize.large, 'Large is not supported by filled');
    return switch (size) {
      .small => (fontSize: 15, lineHeight: 20),
      .standard => (fontSize: 16, lineHeight: 24),
      .large => throw UnsupportedError('Large is not supported by filled'),
    };
  }

  @override
  MateoTextInputColorScheme resolveColorScheme(MateoTextInputsColorScheme colors) => switch (this) {
    _neutral => colors.filled.neutral,
    _base => colors.filled.base,
  };
}
