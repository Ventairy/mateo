part of '../../base_mateo_transform.dart';

final class _MateoTransformAnimationContentScale extends _MateoTransformAnimationContentEffect {
  const _MateoTransformAnimationContentScale({super.curve});

  double _fittedScale(Size content, Size bounds) =>
      applyBoxFit(BoxFit.contain, content, bounds).destination.width / content.width;

  double _interpolateScale(double begin, double end, double progress) =>
      ui.lerpDouble(begin, end, progress)!.clamp(0.0, double.infinity);

  @override
  _MateoTransformAnimationContentEndpoints apply(
    _MateoTransformAnimationContentEndpoints content, {
    required ({Size source, Size destination}) sizes,
    required MorphFlightProgress progress,
  }) {
    final value = progressFor(progress);
    return (
      source: content.source.scale(
        _interpolateScale(
          1,
          _fittedScale(sizes.source, sizes.destination),
          value,
        ),
      ),
      destination: content.destination.scale(
        _interpolateScale(
          _fittedScale(sizes.destination, sizes.source),
          1,
          value,
        ),
      ),
    );
  }
}
