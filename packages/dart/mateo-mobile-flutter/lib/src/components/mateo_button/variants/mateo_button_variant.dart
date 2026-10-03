import 'package:flutter/foundation.dart';

import '../../../theme/color_scheme/mateo_color_scheme.dart';
import '../../mateo_press/mateo_press_animation_type.dart';

part 'mateo_primary_button_variant.dart';
part 'mateo_secondary_button_variant.dart';
part 'mateo_tertiary_button_variant.dart';

/// A semantic treatment for a Mateo button.
///
/// Choose emphasis independently of size and elevation. Colors resolve from
/// the nearest Mateo theme.
@immutable
sealed class MateoButtonVariant {
  /// The press feedback associated with this treatment.
  MateoPressAnimationType get pressAnimation;

  /// The colors of this treatment from [colors].
  MateoButtonColorScheme resolveColorScheme(MateoButtonsColorScheme colors);

  /// The prominent filled treatment, defaulting to the product accent.
  static const MateoPrimaryButtonVariant primary = MateoPrimaryButtonVariant._accent;

  /// The quieter filled treatment, defaulting to the product accent.
  static const MateoSecondaryButtonVariant secondary = MateoSecondaryButtonVariant._accent;

  /// The transparent treatment, defaulting to the neutral foreground.
  static const MateoTertiaryButtonVariant tertiary = MateoTertiaryButtonVariant._neutral;
}
