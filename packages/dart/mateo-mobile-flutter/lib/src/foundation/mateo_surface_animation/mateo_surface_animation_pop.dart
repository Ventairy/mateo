// Fixed variant configuration belongs in its constructor.
// ignore_for_file: avoid_field_initializers_in_const_classes

part of 'mateo_surface_animation.dart';

/// A surface entrance with coordinated fading, scaling, and optional directional movement.
final class MateoSurfaceAnimationPop extends MateoSurfaceAnimation {
  /// Creates a surface entrance that moves toward [direction].
  const new({
    this.duration = const .new(milliseconds: 320),
    this.curve = Curves.easeOutBack,
    this.direction = .center,
  }) : beginScale = 0.75,
       super._();

  /// The shared duration of the fade, scale, and slide entrance.
  final Duration duration;

  /// The shared easing curve of the fade, scale, and slide entrance.
  ///
  /// Scale and slide preserve overshoot; rendered opacity stays between zero and one.
  final Curve curve;

  /// The direction of travel into the resting position.
  ///
  /// For example, [MateoSurfaceAnimationPopDirection.top] starts slightly below
  /// the resting position. Center preserves the stationary pop. Left and right
  /// are physical directions, including in right-to-left layouts.
  final MateoSurfaceAnimationPopDirection direction;

  /// The initial scale relative to the surface's laid-out size.
  final double beginScale;

  /// Whether both values describe the same pop entrance.
  @override
  bool operator ==(Object other) =>
      other is MateoSurfaceAnimationPop &&
      duration == other.duration &&
      curve == other.curve &&
      direction == other.direction;

  /// The hash of this surface animation.
  @override
  int get hashCode => Object.hash(MateoSurfaceAnimationPop, duration, curve, direction);
}
