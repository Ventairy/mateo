part of 'mateo_surface_animation.dart';

/// A surface animation with no transition.
final class MateoSurfaceAnimationNone extends MateoSurfaceAnimation {
  /// Creates a surface animation with no transition.
  const MateoSurfaceAnimationNone() : super._();

  /// The fixed duration of this animation style.
  Duration get duration => .zero;

  /// The easing curve of this animation style.
  Curve get curve => Curves.linear;

  /// Whether both values describe no surface animation.
  @override
  bool operator ==(Object other) => other is MateoSurfaceAnimationNone;

  /// The hash of this surface animation.
  @override
  int get hashCode => runtimeType.hashCode;
}
