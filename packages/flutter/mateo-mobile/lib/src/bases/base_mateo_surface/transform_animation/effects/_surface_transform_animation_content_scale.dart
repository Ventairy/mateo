part of '../../base_mateo_surface.dart';

final class _SurfaceTransformAnimationContentScale extends _SurfaceTransformAnimationContentEffect {
  const _SurfaceTransformAnimationContentScale({super.curve});

  double _fittedScale(Size content, Size bounds) {
    return applyBoxFit(BoxFit.contain, content, bounds).destination.width / content.width;
  }

  double _interpolateScale(double begin, double end, double progress) {
    return ui.lerpDouble(begin, end, progress)!.clamp(0.0, double.infinity);
  }

  @override
  _SurfaceTransformAnimationContentEndpoints apply(
    _SurfaceTransformAnimationContentEndpoints content, {
    required ({Size source, Size destination}) sizes,
    required MorphFlightProgress progress,
  }) {
    final value = progressFor(progress);
    // Interpolate scale factors directly so the effect curve controls the
    // scale itself, even when the surface follows a different geometry curve.
    return (
      source: content.source.scale(_interpolateScale(1, _fittedScale(sizes.source, sizes.destination), value)),
      destination: content.destination.scale(
        _interpolateScale(_fittedScale(sizes.destination, sizes.source), 1, value),
      ),
    );
  }
}
