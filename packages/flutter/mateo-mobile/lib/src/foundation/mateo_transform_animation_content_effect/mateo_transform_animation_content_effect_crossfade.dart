part of 'mateo_transform_animation_content_effect.dart';

/// Blends captured outgoing and incoming content during a transform animation.
final class MateoTransformAnimationContentEffectCrossfade extends MateoTransformAnimationContentEffect {
  /// Creates a content crossfade effect.
  const MateoTransformAnimationContentEffectCrossfade({this.curve}) : super._();

  /// The effect easing, or null to follow the transform timing.
  @override
  final Curve? curve;

  @override
  bool operator ==(Object other) => other is MateoTransformAnimationContentEffectCrossfade && curve == other.curve;

  @override
  int get hashCode => Object.hash(MateoTransformAnimationContentEffectCrossfade, curve);
}
