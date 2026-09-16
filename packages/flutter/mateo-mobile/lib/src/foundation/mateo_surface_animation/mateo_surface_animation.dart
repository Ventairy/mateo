import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

part 'mateo_surface_animation_none.dart';
part 'mateo_surface_animation_pop.dart';
part 'mateo_surface_animation_transform.dart';
part 'mateo_surface_transform_animation_content_effect.dart';
part 'mateo_surface_transform_animation_content_effect_crossfade.dart';
part 'mateo_surface_transform_animation_content_effect_scale.dart';

/// An animation style for a Mateo surface.
@immutable
sealed class MateoSurfaceAnimation {
  const MateoSurfaceAnimation._();

  /// Creates a surface animation with no transition.
  const factory MateoSurfaceAnimation.none() = MateoSurfaceAnimationNone;

  /// Creates an entrance with an animation that pops in
  ///
  /// Runs when the surface mounts or switches to this style. Ordinary rebuilds
  /// do not replay it. Reduced motion shows the surface immediately.
  ///
  /// ```dart
  /// const MateoSurface(
  ///   animation: .pop(duration: Duration(milliseconds: 250), curve: Curves.easeOut),
  ///   child: Text('Welcome'),
  /// )
  /// ```
  const factory MateoSurfaceAnimation.pop({Duration duration, Curve curve}) = MateoSurfaceAnimationPop;

  /// Morph between different surfaces by animating their properties with an equal [id].
  ///
  /// Keep the ID's equality and hash code stable while the surface is mounted.
  /// Ordinary and view surfaces can share the same ID.
  ///
  /// Example of a card morphing into a view surface:
  ///
  /// ```dart
  /// final card = MateoSurface(
  ///   animation: const .transform(id: 'details'),
  ///   shape: const .capsule(),
  ///   child: const Text('Open details'),
  /// );
  /// final screen = MateoView(
  ///   surface: MateoViewSurface(
  ///     animation: const .transform(id: 'details'),
  ///     child: const Text('Details'),
  ///   ),
  /// );
  /// ```
  ///
  /// For content that should only crossfade while the surface transforms instead of default effects:
  ///
  /// ```dart
  /// const animation = MateoSurfaceAnimation.transform(
  ///   id: 'details',
  ///   contentEffects: [.crossfade()],
  /// );
  /// ```
  const factory MateoSurfaceAnimation.transform({
    required Object id,
    Duration duration,
    Curve curve,
    List<MateoSurfaceTransformAnimationContentEffect> contentEffects,
  }) = MateoSurfaceAnimationTransform;

  /// The duration of this animation style.
  Duration get duration;

  /// The easing curve of this animation style.
  Curve get curve;
}
