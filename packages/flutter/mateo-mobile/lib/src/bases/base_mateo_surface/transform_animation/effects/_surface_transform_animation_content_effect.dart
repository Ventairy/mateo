part of '../../base_mateo_surface.dart';

typedef _SurfaceTransformAnimationContentEndpoints = ({
  _SurfaceTransformAnimationFlightContent source,
  _SurfaceTransformAnimationFlightContent destination,
});

abstract class _SurfaceTransformAnimationContentEffect {
  const _SurfaceTransformAnimationContentEffect({this.curve});

  factory _SurfaceTransformAnimationContentEffect.from(MateoSurfaceTransformAnimationContentEffect effect) =>
      switch (effect) {
        MateoSurfaceTransformAnimationContentEffectCrossfade(:final curve) =>
          _SurfaceTransformAnimationContentCrossfade(curve: curve),
        MateoSurfaceTransformAnimationContentEffectScale(:final curve) => _SurfaceTransformAnimationContentScale(
          curve: curve,
        ),
      };

  final Curve? curve;

  double progressFor(MorphFlightProgress progress) {
    return curve?.transform(progress.uncurvedProgress) ?? progress.curvedProgress;
  }

  _SurfaceTransformAnimationContentEndpoints apply(
    _SurfaceTransformAnimationContentEndpoints content, {
    required ({Size source, Size destination}) sizes,
    required MorphFlightProgress progress,
  });
}
