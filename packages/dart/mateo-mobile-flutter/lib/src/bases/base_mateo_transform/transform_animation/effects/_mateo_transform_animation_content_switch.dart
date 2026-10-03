part of '../../base_mateo_transform.dart';

final class _MateoTransformAnimationContentSwitch extends _MateoTransformAnimationContentEffect {
  const _MateoTransformAnimationContentSwitch();

  @override
  _MateoTransformAnimationContentEndpoints apply(
    _MateoTransformAnimationContentEndpoints content, {
    required ({Size source, Size destination}) sizes,
    required MorphFlightProgress progress,
  }) => progress.curvedProgress < .5
      ? (source: content.source, destination: content.destination.fade(0))
      : (source: content.source.fade(0), destination: content.destination);
}
