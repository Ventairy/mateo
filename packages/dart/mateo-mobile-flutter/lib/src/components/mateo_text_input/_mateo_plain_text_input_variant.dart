part of 'mateo_text_input_variant.dart';

enum _MateoPlainTextInputVariant implements MateoTextInputVariant {
  _plain;

  @override
  ({double fontSize, double lineHeight}) resolveTypography(MateoTextInputSize size) => switch (size) {
    .small => (fontSize: 16, lineHeight: 20),
    .standard => (fontSize: 18, lineHeight: 24),
    .large => (fontSize: 20, lineHeight: 28),
  };

  @override
  MateoTextInputColorScheme resolveColorScheme(MateoTextInputsColorScheme colors) => colors.plain;
}
