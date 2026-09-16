part of 'mateo_surface_animation.dart';

/// Blends captured outgoing and incoming content during a surface transform animation.
final class MateoSurfaceTransformAnimationContentEffectCrossfade extends MateoSurfaceTransformAnimationContentEffect {
  /// Creates a surface transform content crossfade effect.
  const MateoSurfaceTransformAnimationContentEffectCrossfade({this.curve}) : super._();

  /// The effect's easing, or null to follow the surface transform animation's timing.
  final Curve? curve;

  @override
  bool operator ==(Object other) =>
      other is MateoSurfaceTransformAnimationContentEffectCrossfade && curve == other.curve;

  @override
  int get hashCode => Object.hash(MateoSurfaceTransformAnimationContentEffectCrossfade, curve);
}
