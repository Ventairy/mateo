part of 'mateo_surface_animation.dart';

/// The physical direction a surface travels as it pops into place.
enum MateoSurfaceAnimationPopDirection {
  /// Pops in place without sliding.
  center,

  /// Travels upward from below.
  top,

  /// Travels upward and rightward from below and to the left.
  topRight,

  /// Travels rightward from the left.
  right,

  /// Travels downward and rightward from above and to the left.
  bottomRight,

  /// Travels downward from above.
  bottom,

  /// Travels downward and leftward from above and to the right.
  bottomLeft,

  /// Travels leftward from the right.
  left,

  /// Travels upward and leftward from below and to the right.
  topLeft,
}
