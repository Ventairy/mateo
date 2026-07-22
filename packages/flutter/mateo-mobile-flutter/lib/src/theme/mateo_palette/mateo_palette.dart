library;

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

part 'mateo_color_scale.dart';

/// The raw primitive color palette for the Mateo Mobile design system.
///
/// Contains 12-step color scales for [primary], [neutral], [green],
/// [amber], [red], [blue], [whatsapp], and six accent colors ([cyan],
/// [violet], [teal], [orange], [pink], [yellow]).
///
/// The [primary] and [neutral] scales are **auto-derived** from the
/// `primaryColor` parameter using OKLCH color space generation. All other scales
/// are fixed values from the Mateo Mobile palette specification.
///
/// This primitive palette is appearance-independent and has no semantic token
/// assignments. Build semantic color schemes on top of these primitives.
///
/// ```dart
/// final palette = MateoPalette(primaryColor: Color(0xFF4A5CFF));
/// final primary = palette.primary;
/// final neutral = palette.neutral[12];
/// ```
@immutable
class MateoPalette {
  /// Creates a Mateo Mobile color palette generated from [primaryColor].
  ///
  /// The [primary] and [neutral] scales are derived from [primaryColor]
  /// using OKLCH color space generation. The color must be fully opaque, and
  /// it is preserved exactly at primary step 9. All other scales are fixed.
  ///
  /// When [primaryColor] is omitted, the default Mateo Colors are used
  ///
  /// Throws [ArgumentError] when [primaryColor] is not fully opaque.
  factory MateoPalette({Color? primaryColor}) {
    final mainColor = primaryColor ?? _defaultBrandColor;
    if (mainColor.a != 1) {
      throw ArgumentError.value(
        mainColor,
        'primaryColor',
        'must be fully opaque',
      );
    }

    final isDefault = mainColor == _defaultBrandColor;
    if (isDefault) return _defaultPalette;

    final oklch = Oklch.fromColor(mainColor);
    final hue = oklch.h;
    final primaryLightness = <double>[
      for (final amount in _primaryLighten) oklch.l + (1 - oklch.l) * amount,
      oklch.l,
      for (final amount in _primaryDarken) 0.21 + (oklch.l - 0.21) * amount,
    ];

    final primaryChroma = [
      for (final multiplier in _primaryChromaMultipliers) oklch.c * multiplier,
    ];

    final neutralTint = oklch.c <= 0.000004
        ? 0.0
        : (oklch.c / 0.20).clamp(0.0, 1.0);

    return MateoPalette._(
      primaryColor: mainColor,
      primary: _generateScale(
        lightness: primaryLightness,
        chroma: primaryChroma,
        baseHue: hue,
        anchor: mainColor,
      ),
      neutral: _generateScale(
        lightness: _neutralLightness,
        chroma: _neutralChroma.map((c) => c * neutralTint).toList(),
        baseHue: hue,
      ),
      green: _greenScale,
      amber: _amberScale,
      red: _redScale,
      blue: _blueScale,
      whatsapp: _whatsappScale,
      cyan: _cyanScale,
      violet: _violetScale,
      teal: _tealScale,
      orange: _orangeScale,
      pink: _pinkScale,
      yellow: _yellowScale,
    );
  }

  const MateoPalette._({
    required this._primaryColor,
    required this.primary,
    required this.neutral,
    required this.green,
    required this.amber,
    required this.red,
    required this.blue,
    required this.whatsapp,
    required this.cyan,
    required this.violet,
    required this.teal,
    required this.orange,
    required this.pink,
    required this.yellow,
  });

  final Color _primaryColor;

  static const Color _defaultBrandColor = Color(0xFF4A5CFF);

  static final MateoPalette _defaultPalette = MateoPalette._(
    primaryColor: _defaultBrandColor,
    primary: _defaultPrimaryScale,
    neutral: _defaultNeutralScale,
    green: _greenScale,
    amber: _amberScale,
    red: _redScale,
    blue: _blueScale,
    whatsapp: _whatsappScale,
    cyan: _cyanScale,
    violet: _violetScale,
    teal: _tealScale,
    orange: _orangeScale,
    pink: _pinkScale,
    yellow: _yellowScale,
  );

  static final MateoColorScale _defaultPrimaryScale = MateoColorScale._(
    steps: const [
      Color(0xFFF9FBFE),
      Color(0xFFF2F4FB),
      Color(0xFFE5EAFA),
      Color(0xFFDAE1F7),
      Color(0xFFCBD7FC),
      Color(0xFFBECDFF),
      Color(0xFFADC0FF),
      Color(0xFF718CFC),
      Color(0xFF4A5CFF),
      Color(0xFF3F4CE7),
      Color(0xFF273392),
      Color(0xFF0C123E),
    ],
  );

  static final MateoColorScale _defaultNeutralScale = MateoColorScale._(
    steps: const [
      Color(0xFFFBFCFD),
      Color(0xFFF4F5F7),
      Color(0xFFEAEBEF),
      Color(0xFFE0E1E5),
      Color(0xFFD6D7DC),
      Color(0xFFCCCDD3),
      Color(0xFFBFC1C6),
      Color(0xFF909297),
      Color(0xFF707175),
      Color(0xFF626367),
      Color(0xFF3E4043),
      Color(0xFF17181B),
    ],
  );

  static final MateoColorScale _greenScale = MateoColorScale._(
    steps: const [
      Color(0xFFFBFEFB),
      Color(0xFFF5FBF6),
      Color(0xFFECF8ED),
      Color(0xFFE3F5E5),
      Color(0xFFD5F4D8),
      Color(0xFFC8F2CD),
      Color(0xFFB2F1BA),
      Color(0xFF78E18A),
      Color(0xFF00D757),
      Color(0xFF00B849),
      Color(0xFF006F29),
      Color(0xFF001F06),
    ],
  );

  static final MateoColorScale _amberScale = MateoColorScale._(
    steps: const [
      Color(0xFFFFFDFB),
      Color(0xFFFDFAF5),
      Color(0xFFFCF5EB),
      Color(0xFFFBF0E2),
      Color(0xFFFDEAD2),
      Color(0xFFFEE5C4),
      Color(0xFFFFDDB2),
      Color(0xFFFDC171),
      Color(0xFFFFAA00),
      Color(0xFFDA9100),
      Color(0xFF835500),
      Color(0xFF241400),
    ],
  );

  static final MateoColorScale _redScale = MateoColorScale._(
    steps: const [
      Color(0xFFFFFAFA),
      Color(0xFFFCF4F3),
      Color(0xFFFCE9E7),
      Color(0xFFFBDFDC),
      Color(0xFFFFD3CE),
      Color(0xFFFFC7C2),
      Color(0xFFFFB8B0),
      Color(0xFFFE776F),
      Color(0xFFFB2C36),
      Color(0xFFE00F26),
      Color(0xFF8B1219),
      Color(0xFF360103),
    ],
  );

  static final MateoColorScale _blueScale = MateoColorScale._(
    steps: const [
      Color(0xFFFAFBFE),
      Color(0xFFF2F6FB),
      Color(0xFFE6EEFA),
      Color(0xFFDBE6F8),
      Color(0xFFCBDEFC),
      Color(0xFFBDD7FF),
      Color(0xFFABCCFF),
      Color(0xFF69A2FB),
      Color(0xFF2B7FFF),
      Color(0xFF1A6CE5),
      Color(0xFF13448F),
      Color(0xFF031639),
    ],
  );

  static final MateoColorScale _whatsappScale = MateoColorScale._(
    steps: const [
      Color(0xFFF9FDFA),
      Color(0xFFF4FAF5),
      Color(0xFFECF7ED),
      Color(0xFFE2F3E5),
      Color(0xFFD6F2DA),
      Color(0xFFC9F0CE),
      Color(0xFFB5EFBE),
      Color(0xFF7FDE92),
      Color(0xFF25D366),
      Color(0xFF01B950),
      Color(0xFF126E2A),
      Color(0xFF002002),
    ],
  );

  static final MateoColorScale _cyanScale = MateoColorScale._(
    steps: const [
      Color(0xFFFBFDFE),
      Color(0xFFF5FAFB),
      Color(0xFFEBF6F9),
      Color(0xFFE2F1F6),
      Color(0xFFD4EEF6),
      Color(0xFFC7EBF5),
      Color(0xFFB0E6F6),
      Color(0xFF75D1EA),
      Color(0xFF00C2E6),
      Color(0xFF00A6C5),
      Color(0xFF006478),
      Color(0xFF001C24),
    ],
  );

  static final MateoColorScale _violetScale = MateoColorScale._(
    steps: const [
      Color(0xFFFBFAFE),
      Color(0xFFF5F4FA),
      Color(0xFFEDEAFA),
      Color(0xFFE5E0F8),
      Color(0xFFDDD5FC),
      Color(0xFFD5CAFF),
      Color(0xFFCABCFF),
      Color(0xFFA585FC),
      Color(0xFF8E51FF),
      Color(0xFF7D40E5),
      Color(0xFF4E2A90),
      Color(0xFF1C0C3A),
    ],
  );

  static final MateoColorScale _tealScale = MateoColorScale._(
    steps: const [
      Color(0xFFFBFDFD),
      Color(0xFFF5FAF9),
      Color(0xFFEBF6F4),
      Color(0xFFE2F2EE),
      Color(0xFFD4EFE9),
      Color(0xFFC7ECE4),
      Color(0xFFB1E9DE),
      Color(0xFF75D4C4),
      Color(0xFF00C7B2),
      Color(0xFF00AB99),
      Color(0xFF00675C),
      Color(0xFF001E19),
    ],
  );

  static final MateoColorScale _orangeScale = MateoColorScale._(
    steps: const [
      Color(0xFFFFFBFA),
      Color(0xFFFDF6F3),
      Color(0xFFFCEEE7),
      Color(0xFFFBE6DD),
      Color(0xFFFFDCCD),
      Color(0xFFFFD3C0),
      Color(0xFFFFC7AE),
      Color(0xFFFF9666),
      Color(0xFFFF6900),
      Color(0xFFDC5A00),
      Color(0xFF893500),
      Color(0xFF2E0C00),
    ],
  );

  static final MateoColorScale _pinkScale = MateoColorScale._(
    steps: const [
      Color(0xFFFFFAFC),
      Color(0xFFFCF4F7),
      Color(0xFFFCE9F0),
      Color(0xFFFAE0E9),
      Color(0xFFFED3E2),
      Color(0xFFFFC7DC),
      Color(0xFFFFB7D3),
      Color(0xFFFA79B1),
      Color(0xFFF6339A),
      Color(0xFFDA1A85),
      Color(0xFF881552),
      Color(0xFF32011B),
    ],
  );

  static final MateoColorScale _yellowScale = MateoColorScale._(
    steps: const [
      Color(0xFFFFFEFB),
      Color(0xFFFEFCF7),
      Color(0xFFFDF9ED),
      Color(0xFFFCF6E5),
      Color(0xFFFDF4D6),
      Color(0xFFFEF1C9),
      Color(0xFFFFEDB4),
      Color(0xFFFDDD79),
      Color(0xFFFFD000),
      Color(0xFFD9B100),
      Color(0xFF7F6700),
      Color(0xFF1F1700),
    ],
  );

  static const List<double> _primaryLighten = [
    0.97,
    0.925,
    0.86,
    0.795,
    0.73,
    0.665,
    0.575,
    0.245,
  ];

  static const List<double> _primaryDarken = [0.85, 0.47, 0];

  static const List<double> _primaryChromaMultipliers = [
    0.02,
    0.04,
    0.09,
    0.13,
    0.22,
    0.30,
    0.44,
    0.70,
    1,
    0.96,
    0.65,
    0.35,
  ];

  static const List<double> _neutralLightness = [
    0.99,
    0.97,
    0.94,
    0.91,
    0.88,
    0.85,
    0.81,
    0.66,
    0.55,
    0.50,
    0.37,
    0.21,
  ];

  static const List<double> _neutralChroma = [
    0.002,
    0.003,
    0.005,
    0.006,
    0.007,
    0.008,
    0.008,
    0.007,
    0.006,
    0.006,
    0.006,
    0.006,
  ];

  static MateoColorScale _generateScale({
    required List<double> lightness,
    required List<double> chroma,
    required double baseHue,
    Color? anchor,
  }) {
    final colors = <Color>[];

    for (var i = 0; i < 12; i++) {
      if (i == 8 && anchor != null) {
        colors.add(anchor);
        continue;
      }

      colors.add(Oklch.toColor(lightness[i], chroma[i], baseHue));
    }

    return MateoColorScale._(steps: colors);
  }

  /// The brand color scale derived from the palette's primary color.
  ///
  /// Step 9 is exactly the supplied primary color. The surrounding steps keep
  /// its OKLCH hue and follow Mateo's documented lightness and chroma recipe.
  final MateoColorScale primary;

  /// The warm neutral scale tinted toward the palette's primary hue.
  ///
  /// Its chroma is capped between 0.002 and 0.008, then scaled by the seed's
  /// chroma so muted primaries do not create exaggerated neutral tinting.
  final MateoColorScale neutral;

  /// The fixed green scale.
  final MateoColorScale green;

  /// The fixed amber scale.
  final MateoColorScale amber;

  /// The fixed red scale.
  final MateoColorScale red;

  /// The fixed blue scale.
  final MateoColorScale blue;

  /// The fixed WhatsApp reference scale.
  final MateoColorScale whatsapp;

  /// The cyan accent scale.
  final MateoColorScale cyan;

  /// The violet accent scale.
  final MateoColorScale violet;

  /// The teal accent scale.
  final MateoColorScale teal;

  /// The orange accent scale.
  final MateoColorScale orange;

  /// The pink accent scale.
  final MateoColorScale pink;

  /// The yellow accent scale.
  final MateoColorScale yellow;

  /// Equality based on the primary color that defines this palette.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MateoPalette) return false;
    return _primaryColor == other._primaryColor;
  }

  /// The hash code derived from the primary color that defines this palette.
  @override
  int get hashCode => _primaryColor.hashCode;
}
