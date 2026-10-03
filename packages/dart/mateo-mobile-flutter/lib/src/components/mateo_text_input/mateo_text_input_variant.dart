import 'package:flutter/foundation.dart';

import '../../theme/color_scheme/mateo_color_scheme.dart';
import 'mateo_text_input_size.dart';

part '_mateo_plain_text_input_variant.dart';
part 'mateo_filled_text_input_variant.dart';

/// The visual treatment of a Mateo text input.
@immutable
sealed class MateoTextInputVariant {
  /// An opaque filled surface.
  static const MateoFilledTextInputVariant filled = MateoFilledTextInputVariant._neutral;

  /// A plain treatment with no visible background or shadow.
  static const MateoTextInputVariant plain = _MateoPlainTextInputVariant._plain;

  /// Resolves the text size and line height for [size] in logical pixels.
  ///
  /// Values are measured before accessibility text scaling. The filled treatment
  /// rejects [MateoTextInputSize.large] with an assertion in debug mode and an
  /// [UnsupportedError] when assertions are disabled.
  ({double fontSize, double lineHeight}) resolveTypography(MateoTextInputSize size);

  /// The colors of this treatment from [colors].
  MateoTextInputColorScheme resolveColorScheme(MateoTextInputsColorScheme colors);
}
