import 'package:flutter/material.dart';

import 'mateo_color_scheme/mateo_color_scheme.dart';
import 'mateo_palette/mateo_palette.dart';

@immutable
/// The reusable Mateo tokens registered on a Material [ThemeData].
class MateoThemeData extends ThemeExtension<MateoThemeData> {
  /// Creates theme data from the required semantic [colorScheme] and [palette].
  const MateoThemeData({
    required this.colorScheme,
    required this.palette,
  });

  /// The semantic color contract shared by Mateo and Material components.
  final MateoColorScheme colorScheme;

  /// The raw primitive color palette used to build the color scheme.
  final MateoPalette palette;

  @override
  MateoThemeData copyWith({
    MateoColorScheme? colorScheme,
    MateoPalette? palette,
  }) {
    return MateoThemeData(
      colorScheme: colorScheme ?? this.colorScheme,
      palette: palette ?? this.palette,
    );
  }

  @override
  MateoThemeData lerp(covariant MateoThemeData? other, double t) {
    if (other == null) return this;
    return MateoThemeData(
      colorScheme: MateoColorScheme.lerp(colorScheme, other.colorScheme, t),
      palette: t < 0.5 ? palette : other.palette,
    );
  }
}
