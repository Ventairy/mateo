part of '../../base_mateo_surface.dart';

final class _SurfaceTransformAnimationContentCrossfade extends _SurfaceTransformAnimationContentEffect {
  const _SurfaceTransformAnimationContentCrossfade({super.curve});

  @override
  _SurfaceTransformAnimationContentEndpoints apply(
    _SurfaceTransformAnimationContentEndpoints content, {
    required ({Size source, Size destination}) sizes,
    required MorphFlightProgress progress,
  }) {
    final visibility = progressFor(progress).clamp(0.0, 1.0);
    return (source: content.source.fade(1 - visibility), destination: content.destination.fade(visibility));
  }
}
