import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

import '../mateo_surface_shape/mateo_surface_shape.dart';
import 'mateo_surface_transform_target.dart';

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

  /// Connects surfaces using the same transform target.
  ///
  /// Retain a [MateoSurfaceTransformTarget] in a shared owner and pass it to
  /// both surfaces. The target owns timing; each surface defines its appearance.
  const factory MateoSurfaceAnimation.transform({
    required MateoSurfaceTransformTarget target,
    MateoSurfaceShape? shape,
    List<MateoSurfaceTransformAnimationContentEffect> contentEffects,
  }) = MateoSurfaceAnimationTransform;

  /// The duration of this animation style, or null for inherited timing.
  Duration? get duration;

  /// The easing curve of this animation style.
  Curve get curve;
}
