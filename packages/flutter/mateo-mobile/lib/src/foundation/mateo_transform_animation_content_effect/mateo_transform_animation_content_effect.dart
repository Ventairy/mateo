import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

part 'mateo_transform_animation_content_effect_crossfade.dart';
part 'mateo_transform_animation_content_effect_scale.dart';

/// An effect applied to captured content during a transform animation.
@immutable
sealed class MateoTransformAnimationContentEffect {
  const MateoTransformAnimationContentEffect._();

  /// Blends outgoing and incoming content.
  const factory MateoTransformAnimationContentEffect.crossfade({
    Curve? curve,
  }) = MateoTransformAnimationContentEffectCrossfade;

  /// Scales content proportionally between endpoint sizes.
  const factory MateoTransformAnimationContentEffect.scale({Curve? curve}) = MateoTransformAnimationContentEffectScale;

  /// The effect easing, or null to follow the transform timing.
  Curve? get curve;
}
