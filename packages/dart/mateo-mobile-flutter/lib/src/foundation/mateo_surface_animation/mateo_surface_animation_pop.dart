// Fixed variant configuration belongs in its constructor.
// ignore_for_file: avoid_field_initializers_in_const_classes

part of 'mateo_surface_animation.dart';

/// A surface entrance with coordinated fading and scaling.
final class MateoSurfaceAnimationPop extends MateoSurfaceAnimation {
  /// Creates a centered surface entrance.
  const MateoSurfaceAnimationPop({
    this.duration = const .new(milliseconds: 320),
    this.curve = Curves.easeOutBack,
  }) : beginScale = 0.75,
       super._();

  /// The shared duration of the fade and scale entrance.
  final Duration duration;

  /// The shared easing curve of the fade and scale entrance.
  ///
  /// Scale preserves overshoot; rendered opacity stays between zero and one.
  final Curve curve;

  /// The initial scale relative to the surface's laid-out size.
  final double beginScale;

  /// Whether both values describe the same pop entrance.
  @override
  bool operator ==(Object other) =>
      other is MateoSurfaceAnimationPop && duration == other.duration && curve == other.curve;

  /// The hash of this surface animation.
  @override
  int get hashCode => Object.hash(MateoSurfaceAnimationPop, duration, curve);
}
