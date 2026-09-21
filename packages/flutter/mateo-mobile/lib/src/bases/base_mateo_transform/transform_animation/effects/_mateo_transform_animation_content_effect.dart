part of '../../base_mateo_transform.dart';

typedef _MateoTransformAnimationContentEndpoints = ({
  _MateoTransformAnimationFlightContent source,
  _MateoTransformAnimationFlightContent destination,
});

abstract class _MateoTransformAnimationContentEffect {
  const _MateoTransformAnimationContentEffect({this.curve});

  factory _MateoTransformAnimationContentEffect.from(
    MateoTransformAnimationContentEffect effect,
  ) => switch (effect) {
    MateoTransformAnimationContentEffectCrossfade(:final curve) => _MateoTransformAnimationContentCrossfade(
      curve: curve,
    ),
    MateoTransformAnimationContentEffectScale(:final curve) => _MateoTransformAnimationContentScale(curve: curve),
  };

  final Curve? curve;

  double progressFor(MorphFlightProgress progress) =>
      curve?.transform(progress.uncurvedProgress) ?? progress.curvedProgress;

  _MateoTransformAnimationContentEndpoints apply(
    _MateoTransformAnimationContentEndpoints content, {
    required ({Size source, Size destination}) sizes,
    required MorphFlightProgress progress,
  });
}
