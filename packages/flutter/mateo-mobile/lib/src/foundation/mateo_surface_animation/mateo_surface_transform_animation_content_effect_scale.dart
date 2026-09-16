part of 'mateo_surface_animation.dart';

/// Scales captured content proportionally during a surface transform animation.
///
/// Content stays centered and clips to the moving surface. The effect's curve
/// controls its scale independently of the surface's outline. Allows scale overshoot,
/// but clamps negative scales to zero so content never flips.
final class MateoSurfaceTransformAnimationContentEffectScale extends MateoSurfaceTransformAnimationContentEffect {
  /// Creates a surface transform content scale effect.
  const MateoSurfaceTransformAnimationContentEffectScale({this.curve}) : super._();

  /// The effect's easing, or null to follow the surface transform animation's timing.
  final Curve? curve;

  @override
  bool operator ==(Object other) => other is MateoSurfaceTransformAnimationContentEffectScale && curve == other.curve;

  @override
  int get hashCode => Object.hash(MateoSurfaceTransformAnimationContentEffectScale, curve);
}
