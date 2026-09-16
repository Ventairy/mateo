part of '../../base_mateo_surface.dart';

final class _SurfaceTransformAnimationContentSwitch extends _SurfaceTransformAnimationContentEffect {
  const _SurfaceTransformAnimationContentSwitch();

  @override
  _SurfaceTransformAnimationContentEndpoints apply(
    _SurfaceTransformAnimationContentEndpoints content, {
    required ({Size source, Size destination}) sizes,
    required MorphFlightProgress progress,
  }) => progress.curvedProgress < .5
      ? (source: content.source, destination: content.destination.fade(0))
      : (source: content.source.fade(0), destination: content.destination);
}
