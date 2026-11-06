part of 'base_mateo_transform.dart';

enum _MateoTransformFlightEngine { surface, view }

@internal
@immutable
final class BaseMateoTransformCandidate {
  new surface({
    required this.target,
    required this.shape,
    required List<MateoTransformAnimationContentEffect> contentEffects,
  }) : _contentEffects = _MateoTransformAnimationContentEffects(contentEffects),
       _engine = .surface;

  new view({
    required this.target,
    required this.shape,
    required List<MateoTransformAnimationContentEffect> contentEffects,
  }) : _contentEffects = _MateoTransformAnimationContentEffects(contentEffects),
       _engine = .view;

  final MorphTarget target;
  final MateoRoundedShapeBorder shape;
  final _MateoTransformAnimationContentEffects _contentEffects;
  final _MateoTransformFlightEngine _engine;
}
