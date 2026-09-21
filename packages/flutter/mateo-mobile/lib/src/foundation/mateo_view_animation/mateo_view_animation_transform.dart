part of 'mateo_view_animation.dart';

/// A transform connecting a Mateo view to another Mateo element.
final class MateoViewAnimationTransform extends MateoViewAnimation {
  /// Creates a transform through a shared [target].
  const MateoViewAnimationTransform({
    required this.target,
    this.shape,
    this.contentEffects = const [.crossfade(), .scale()],
  }) : super._();

  /// The connection shared by the participating elements.
  final MateoTransformTarget target;

  /// The shape this view uses while transforming.
  ///
  /// When omitted, uses the view surface's resting shape.
  final MateoShape? shape;

  /// Effects applied to the captured view content during the transform.
  final List<MateoTransformAnimationContentEffect> contentEffects;

  /// The timing used when moving to a newer appearance.
  MateoTransformDuration get duration => target.duration;

  /// The timing used when returning to an earlier appearance.
  MateoTransformDuration get reverseDuration => target.reverseDuration;

  /// The easing used when moving to a newer appearance.
  Curve get curve => target.curve;

  /// The easing used when returning to an earlier appearance.
  Curve get reverseCurve => target.reverseCurve;

  /// Whether both transforms have a shared target and configuration.
  @override
  bool operator ==(Object other) =>
      other is MateoViewAnimationTransform &&
      identical(target, other.target) &&
      shape == other.shape &&
      listEquals(
        contentEffects.toSet().toList(),
        other.contentEffects.toSet().toList(),
      );

  /// The hash of this view animation.
  @override
  int get hashCode => Object.hash(
    MateoViewAnimationTransform,
    target,
    shape,
    Object.hashAll(contentEffects.toSet()),
  );
}
