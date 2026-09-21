part of 'mateo_surface_animation.dart';

/// A transform connecting Mateo surfaces with a shared target.
final class MateoSurfaceAnimationTransform extends MateoSurfaceAnimation {
  /// Creates a transform connecting elements with the same [target].
  const MateoSurfaceAnimationTransform({
    required this.target,
    this.shape,
    this.contentEffects = const [.crossfade(), .scale()],
  }) : super._();

  /// The connection shared by the participating surfaces.
  final MateoTransformTarget target;

  /// The shape this surface uses while transforming.
  ///
  /// Defines this endpoint's shape on both arrival and departure. The flight
  /// interpolates between the participating endpoints' shapes. When omitted,
  /// uses this surface's resting shape. Does not change its resting appearance.
  final MateoShape? shape;

  /// The timing used when moving to a newer appearance.
  MateoTransformDuration get duration => target.duration;

  /// The timing used when returning to an earlier appearance.
  MateoTransformDuration get reverseDuration => target.reverseDuration;

  /// The easing used when moving to a newer appearance.
  Curve get curve => target.curve;

  /// The easing used when returning to an earlier appearance.
  Curve get reverseCurve => target.reverseCurve;

  /// Effects applied to the descendant content during the transform.
  ///
  /// Equal duplicates are ignored; conflicting configurations of the same effect
  /// type are rejected when the effects are applied.
  /// Without scaling, content keeps its captured size and is clipped by the surface.
  /// Without crossfading, content switches at the midpoint of eased flight progress.
  final List<MateoTransformAnimationContentEffect> contentEffects;

  /// Whether both transforms have a shared target and configuration.
  @override
  bool operator ==(Object other) {
    return other is MateoSurfaceAnimationTransform &&
        identical(target, other.target) &&
        shape == other.shape &&
        listEquals(contentEffects.toSet().toList(), other.contentEffects.toSet().toList());
  }

  /// The hash of this surface animation.
  @override
  int get hashCode {
    return Object.hash(
      MateoSurfaceAnimationTransform,
      target,
      shape,
      Object.hashAll(contentEffects.toSet()),
    );
  }
}
