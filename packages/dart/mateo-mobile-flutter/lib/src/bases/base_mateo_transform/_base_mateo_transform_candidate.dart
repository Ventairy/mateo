part of 'base_mateo_transform.dart';

enum _MateoTransformFlightEngine { surface, view }

@internal
@immutable
final class BaseMateoTransformCandidate {
  BaseMateoTransformCandidate.surface({
    required this.target,
    required this.shape,
    required List<MateoTransformAnimationContentEffect> contentEffects,
  }) : _contentEffects = _MateoTransformAnimationContentEffects(contentEffects),
       _engine = .surface;

  BaseMateoTransformCandidate.view({
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
