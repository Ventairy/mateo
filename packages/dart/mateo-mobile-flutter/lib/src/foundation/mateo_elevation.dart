import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../theme/palette/mateo_palette.dart';

/// The authored shadow treatments for Mateo elevations.
///
/// Elevation ranges from zero (flat) through one (lifted) to two (maximum lift).
/// Fractional values provide continuous shadow changes between these levels.
/// Use this foundation when a custom component paints its own surface.
@immutable
final class MateoElevation {
  /// Creates an elevation with a finite [level] from zero through two.
  ///
  /// Fractional levels are supported. Throws [ArgumentError] for invalid
  /// levels in every build mode.
  MateoElevation({required this.level}) {
    if (!level.isFinite || level < 0 || level > 2) {
      throw ArgumentError.value(level, 'level', 'Must be finite and between 0 and 2, inclusive.');
    }
  }

  /// The authored lift from zero (flat) through two (maximum lift).
  final double level;

  /// The shadow layers for this level, colored from [palette].
  ///
  /// Returns an empty list at zero. Colors resolve when this method is called
  /// so the value can be reused across themes.
  List<BoxShadow> toShadowList({required MateoPalette palette}) {
    if (level == 0) return const [];

    final shadowColor = palette.neutral[12];
    final ambientOpacity = level * (0.1 + 0.02 * (1 - level));
    final ambientBlur = level * (24 + 5 * (1 - level));
    final directionalDistance = (level - 1).clamp(0.0, 1.0);
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
    if (level > 1) {
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

  /// Whether the other elevation has the same level.
  @override
  bool operator ==(Object other) => identical(this, other) || other is MateoElevation && level == other.level;

  /// The hash of this elevation's level.
  @override
  int get hashCode => level.hashCode;
}
