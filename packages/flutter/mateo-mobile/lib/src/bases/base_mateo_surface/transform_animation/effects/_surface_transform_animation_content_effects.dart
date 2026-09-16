part of '../../base_mateo_surface.dart';

final class _SurfaceTransformAnimationContentEffects {
  factory _SurfaceTransformAnimationContentEffects(List<MateoSurfaceTransformAnimationContentEffect> configuration) {
    final unique = <Type, MateoSurfaceTransformAnimationContentEffect>{};
    for (final effect in configuration) {
      final previous = unique[effect.runtimeType];

      if (previous != null && previous != effect) {
        throw ArgumentError.value(configuration, 'contentEffects', 'Conflicting ${effect.runtimeType} configurations.');
      }

      unique[effect.runtimeType] = effect;
    }
    return _SurfaceTransformAnimationContentEffects._([
      if (!unique.containsKey(MateoSurfaceTransformAnimationContentEffectCrossfade))
        const _SurfaceTransformAnimationContentSwitch(),

      for (final effect in unique.values) _SurfaceTransformAnimationContentEffect.from(effect),
    ]);
  }

  _SurfaceTransformAnimationContentEffects._(List<_SurfaceTransformAnimationContentEffect> effects)
    : _effects = List.unmodifiable(effects);

  final List<_SurfaceTransformAnimationContentEffect> _effects;

  _SurfaceTransformAnimationFlightContent interpolate(
    _SurfaceTransformAnimationFlightContent source,
    _SurfaceTransformAnimationFlightContent destination,
    MorphFlightProgress progress,
  ) {
    final size = Size.lerp(source.size, destination.size, progress.curvedProgress)!;
    var content = (source: source.centeredIn(size), destination: destination.centeredIn(size));
    for (final effect in _effects) {
      content = effect.apply(content, sizes: (source: source.size, destination: destination.size), progress: progress);
    }
    return .combine(content.source, content.destination);
  }
}
