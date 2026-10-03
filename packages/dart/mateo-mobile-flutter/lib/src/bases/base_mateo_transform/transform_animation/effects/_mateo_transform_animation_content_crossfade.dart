part of '../../base_mateo_transform.dart';

final class _MateoTransformAnimationContentCrossfade extends _MateoTransformAnimationContentEffect {
  const _MateoTransformAnimationContentCrossfade({super.curve});

  @override
  _MateoTransformAnimationContentEndpoints apply(
    _MateoTransformAnimationContentEndpoints content, {
    required ({Size source, Size destination}) sizes,
    required MorphFlightProgress progress,
  }) {
    final visibility = progressFor(progress).clamp(0.0, 1.0);
    return (
      source: content.source.fade(1 - visibility),
      destination: content.destination.fade(visibility),
    );
  }
}
