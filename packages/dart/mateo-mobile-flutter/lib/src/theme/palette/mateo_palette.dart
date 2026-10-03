/// Primitive colors from Mateo's authored palette.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart' show Oklch;

part '_palette_values.dart';
part 'mateo_color_scale.dart';

/// The fixed Mateo color scales and a customizable product accent.
///
/// Values follow the [palette foundation](https://github.com/Ventairy/mateo/blob/main/design-system/foundation/color-palette.md).
/// Use semantic theme colors for UI roles; use this palette for primitives.
///
/// ```dart
/// final palette = MateoPalette(accentColor: const Color(0xFF4A5CFF));
/// final Color solid = palette.accent;
/// final lighter = palette.accent[3];
/// ```
@immutable
final class MateoPalette {
  /// Creates a palette with an optional opaque [accentColor].
  ///
  /// Omitting the seed uses the exact authored Mateo accent table. A custom
  /// seed is preserved at step 9 and generates the other steps in OKLCH.
  /// Pale, muted, and very dark seeds need visual review. Translucent seeds
  /// throw [ArgumentError]. The fixed scales never change with the accent.
  factory MateoPalette({Color accentColor = const Color(0xFF4A5CFF)}) {
    if (accentColor.a != 1) {
      throw ArgumentError.value(accentColor, 'accentColor', 'must be fully opaque');
    }
    if (accentColor == const Color(0xFF4A5CFF)) {
      return MateoPalette._(_defaultAccentScale);
    }
    return MateoPalette._(_generateAccent(accentColor));
  }

  const MateoPalette._(this.accent);

  /// The absolute white primitive outside the numbered scales.
  Color get white => const Color(0xFFFFFFFF);

  /// The absolute black primitive outside the numbered scales.
  Color get black => const Color(0xFF000000);

  /// The product accent, with the supplied seed at step 9.
  final MateoColorScale accent;

  /// The fixed achromatic neutral scale.
  MateoColorScale get neutral => _neutralScale;

  /// The fixed green scale.
  MateoColorScale get green => _greenScale;

  /// The fixed amber scale.
  MateoColorScale get amber => _amberScale;

  /// The fixed red scale.
  MateoColorScale get red => _redScale;

  /// The fixed blue scale.
  MateoColorScale get blue => _blueScale;

  /// The fixed cyan scale.
  MateoColorScale get cyan => _cyanScale;

  /// The fixed violet scale.
  MateoColorScale get violet => _violetScale;

  /// The fixed teal scale.
  MateoColorScale get teal => _tealScale;

  /// The fixed orange scale.
  MateoColorScale get orange => _orangeScale;

  /// The fixed pink scale.
  MateoColorScale get pink => _pinkScale;

  /// The fixed yellow scale.
  MateoColorScale get yellow => _yellowScale;

  static MateoColorScale _generateAccent(Color seed) {
    final oklch = Oklch.fromColor(seed);
    final lightness = <double>[
      for (final amount in [0.970, 0.925, 0.860, 0.795, 0.730, 0.665, 0.575, 0.245]) oklch.l + (1 - oklch.l) * amount,
      oklch.l,
      for (final amount in [0.85, 0.47, 0.0]) 0.21 + (oklch.l - 0.21) * amount,
    ];
    const chroma = [0.02, 0.04, 0.09, 0.13, 0.22, 0.30, 0.44, 0.70, 1.0, 0.96, 0.65, 0.35];
    return MateoColorScale._([
      for (var i = 0; i < 12; i++)
        if (i == 8) seed else Oklch.toColor(lightness[i], oklch.c * chroma[i], oklch.h),
    ]);
  }

  /// Whether every primitive color equals the other palette's colors.
  @override
  bool operator ==(Object other) => identical(this, other) || other is MateoPalette && accent == other.accent;

  /// The hash of this palette's colors.
  @override
  int get hashCode => accent.hashCode;
}
