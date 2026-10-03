part of '../../base_mateo_transform.dart';

final class _MateoTransformAnimationContentEffects {
  factory _MateoTransformAnimationContentEffects(
    List<MateoTransformAnimationContentEffect> configuration,
  ) {
    final unique = <Type, MateoTransformAnimationContentEffect>{};
    for (final effect in configuration) {
      final previous = unique[effect.runtimeType];
      if (previous != null && previous != effect) {
        throw ArgumentError.value(
          configuration,
          'contentEffects',
          'Conflicting ${effect.runtimeType} configurations.',
        );
      }
      unique[effect.runtimeType] = effect;
    }
    return _MateoTransformAnimationContentEffects._([
      if (!unique.containsKey(MateoTransformAnimationContentEffectCrossfade))
        const _MateoTransformAnimationContentSwitch(),
      for (final effect in unique.values) _MateoTransformAnimationContentEffect.from(effect),
    ]);
  }

  _MateoTransformAnimationContentEffects._(
    List<_MateoTransformAnimationContentEffect> effects,
  ) : _effects = List.unmodifiable(effects);

  final List<_MateoTransformAnimationContentEffect> _effects;

  _MateoTransformAnimationFlightContent interpolate(
    _MateoTransformAnimationFlightContent source,
    _MateoTransformAnimationFlightContent destination,
    MorphFlightProgress progress,
  ) {
    final size = Size.lerp(
      source.size,
      destination.size,
      progress.curvedProgress,
    )!;
    var content = (
      source: source.centeredIn(size),
      destination: destination.centeredIn(size),
    );
    for (final effect in _effects) {
      content = effect.apply(
        content,
        sizes: (source: source.size, destination: destination.size),
        progress: progress,
      );
    }
    return .combine(content.source, content.destination);
  }
}
