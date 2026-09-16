import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:mateo_mobile_old/src/theme/mateo_palette/mateo_palette.dart';

/// Manages the visual treatment for Mateo elevations.
@internal
abstract final class MateoElevation {
  /// Calculates shadow layers for [elevation] using [palette].
  static List<BoxShadow> toShadows({
    required double elevation,
    required MateoPalette palette,
  }) {
    if (!elevation.isFinite || elevation < 0 || elevation > 2) {
      throw ArgumentError.value(
        elevation,
        'elevation',
        'Must be finite and between 0 and 2, inclusive.',
      );
    }
    if (elevation == 0) return const [];

    final shadowColor = palette.neutral[12];
    final ambientOpacity = elevation * (0.1 + 0.02 * (1 - elevation));
    final ambientBlur = elevation * (24 + 5 * (1 - elevation));
    final directionalDistance = (elevation - 1).clamp(0.0, 1.0);
    final directionalProgress =
        3 * directionalDistance * directionalDistance -
        2 * directionalDistance * directionalDistance * directionalDistance;

    final shadows = <BoxShadow>[
      BoxShadow(
        color: shadowColor.withValues(alpha: ambientOpacity),
        blurRadius: ambientBlur,
        spreadRadius: directionalProgress == 0 ? 0 : -8 * directionalProgress,
        offset: Offset(0, 18 * directionalProgress),
      ),
    ];
    if (elevation > 1) {
      shadows.add(
        BoxShadow(
          color: shadowColor.withValues(alpha: 0.08 * directionalProgress),
          blurRadius: 12 * directionalProgress,
          spreadRadius: 4 * directionalProgress,
          offset: Offset(0, 6 * directionalProgress),
        ),
      );
    }
    return shadows;
  }
}
