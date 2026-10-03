part of 'mateo_transform_animation_content_effect.dart';

/// Scales captured content proportionally during a transform animation.
final class MateoTransformAnimationContentEffectScale extends MateoTransformAnimationContentEffect {
  /// Creates a content scale effect.
  const MateoTransformAnimationContentEffectScale({this.curve}) : super._();

  /// The effect easing, or null to follow the transform timing.
  @override
  final Curve? curve;

  @override
  bool operator ==(Object other) => other is MateoTransformAnimationContentEffectScale && curve == other.curve;

  @override
  int get hashCode => Object.hash(MateoTransformAnimationContentEffectScale, curve);
}
