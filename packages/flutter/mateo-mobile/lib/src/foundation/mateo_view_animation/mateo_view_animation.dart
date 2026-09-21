import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

import '../mateo_shape/mateo_shape.dart';
import '../mateo_transform_animation_content_effect/mateo_transform_animation_content_effect.dart';
import '../mateo_transform_duration/mateo_transform_duration.dart';
import '../mateo_transform_target/mateo_transform_target.dart';

part 'mateo_view_animation_transform.dart';

/// An animation style for a Mateo view.
@immutable
sealed class MateoViewAnimation {
  const MateoViewAnimation._();

  /// Connects a view to another Mateo element using a shared transform target.
  const factory MateoViewAnimation.transform({
    required MateoTransformTarget target,
    MateoShape? shape,
    List<MateoTransformAnimationContentEffect> contentEffects,
  }) = MateoViewAnimationTransform;
}
