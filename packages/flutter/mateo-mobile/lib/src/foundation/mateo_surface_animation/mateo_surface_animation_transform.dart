part of 'mateo_surface_animation.dart';

/// A transform connecting Mateo surfaces with equal identities.
final class MateoSurfaceAnimationTransform extends MateoSurfaceAnimation {
  /// Creates a transform connecting surfaces with an equal [id].
  const MateoSurfaceAnimationTransform({
    required this.id,
    this.duration = const .new(milliseconds: 230),
    this.curve = Curves.easeOutCubic,
    this.contentEffects = const [.crossfade(), .scale()],
  }) : super._();

  /// The identity shared by matching ordinary and view surfaces.
  ///
  /// Keep its equality and hash code stable while the surface is mounted.
  final Object id;

  /// The duration of this animation style.
  @override
  final Duration duration;

  /// The easing curve of this animation style.
  @override
  final Curve curve;

  /// Effects applied to the descendant content during the transform.
  ///
  /// Equal duplicates are ignored; conflicting configurations of the same effect
  /// type are rejected when the effects are applied.
  /// Without scaling, content keeps its captured size and is clipped by the surface.
  /// Without crossfading, content switches at the midpoint of eased flight progress.
  final List<MateoSurfaceTransformAnimationContentEffect> contentEffects;

  /// Whether both transforms have equal identities and configuration.
  @override
  bool operator ==(Object other) {
    return other is MateoSurfaceAnimationTransform &&
        id == other.id &&
        duration == other.duration &&
        curve == other.curve &&
        listEquals(contentEffects.toSet().toList(), other.contentEffects.toSet().toList());
  }

  /// The hash of this surface animation.
  @override
  int get hashCode {
    return Object.hash(MateoSurfaceAnimationTransform, id, duration, curve, Object.hashAll(contentEffects.toSet()));
  }
}
