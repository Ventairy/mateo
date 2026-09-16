import 'package:flutter/foundation.dart';

import '../../theme/color_scheme/mateo_color_scheme.dart';

part 'mateo_filled_text_input_variant.dart';

/// The visual treatment of a Mateo text input.
@immutable
sealed class MateoTextInputVariant {
  /// An opaque filled surface
  static const MateoFilledTextInputVariant filled = MateoFilledTextInputVariant._neutral;

  /// The colors of this treatment from [colors].
  MateoTextInputColorScheme resolveColorScheme(MateoTextInputsColorScheme colors);
}
