import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

import '../mateo_shape/mateo_shape.dart';
import '../mateo_transform_animation_content_effect/mateo_transform_animation_content_effect.dart';
import '../mateo_transform_target/mateo_transform_target.dart';

/// A transform animation connecting a Mateo view to another Mateo element.
@immutable
final class MateoViewAnimation {
  /// Creates a transform through a shared [target].
  const MateoViewAnimation.transform({
    required this.target,
    this.shape,
    this.contentEffects = const [.crossfade(), .scale()],
  });

  /// The connection shared by the participating elements.
  final MateoTransformTarget target;

  /// The shape this view uses while transforming.
  ///
  /// When omitted, uses the view surface's resting shape.
  final MateoShape? shape;

  /// Effects applied to the captured view content during the transform.
  final List<MateoTransformAnimationContentEffect> contentEffects;

  /// The shared target duration, or null for inherited timing.
  Duration? get duration => target.duration;

  /// The easing used by the shared target.
  Curve get curve => target.curve;

  @override
  bool operator ==(Object other) =>
      other is MateoViewAnimation &&
      identical(target, other.target) &&
      shape == other.shape &&
      listEquals(
        contentEffects.toSet().toList(),
        other.contentEffects.toSet().toList(),
      );

  @override
  int get hashCode => Object.hash(
    MateoViewAnimation,
    target,
    shape,
    Object.hashAll(contentEffects.toSet()),
  );
}
