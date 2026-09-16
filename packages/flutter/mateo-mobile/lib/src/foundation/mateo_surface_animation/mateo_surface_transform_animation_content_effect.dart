part of 'mateo_surface_animation.dart';

/// An effect applied to captured surface content during a surface transform animation.
@immutable
sealed class MateoSurfaceTransformAnimationContentEffect {
  const MateoSurfaceTransformAnimationContentEffect._();

  /// Blends outgoing content into incoming content.
  const factory MateoSurfaceTransformAnimationContentEffect.crossfade({Curve? curve}) =
      MateoSurfaceTransformAnimationContentEffectCrossfade;

  /// Fits content proportionally during the transform.
  const factory MateoSurfaceTransformAnimationContentEffect.scale({Curve? curve}) =
      MateoSurfaceTransformAnimationContentEffectScale;
}
