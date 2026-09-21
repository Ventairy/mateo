part of 'base_mateo_transform.dart';

enum _MateoTransformRelationship {
  surfaceToSurface,
  surfaceToView,
  viewToView,
}

@internal
final class BaseMateoTransformTargets {
  factory BaseMateoTransformTargets(MateoTransformTarget target) =>
      _targets[target] ??= BaseMateoTransformTargets._(target);

  BaseMateoTransformTargets._(MateoTransformTarget target)
    : surfaceToSurface = _target(target, .surfaceToSurface),
      surfaceToView = _target(target, .surfaceToView),
      viewToView = _target(target, .viewToView);

  static final _targets = Expando<BaseMateoTransformTargets>();

  static MorphTarget _target(
    MateoTransformTarget target,
    _MateoTransformRelationship relationship,
  ) => MorphTarget(
    tag: (target: target, relationship: relationship),
    duration: target.duration,
    curve: target.curve,
  );

  final MorphTarget surfaceToSurface;
  final MorphTarget surfaceToView;
  final MorphTarget viewToView;
}
