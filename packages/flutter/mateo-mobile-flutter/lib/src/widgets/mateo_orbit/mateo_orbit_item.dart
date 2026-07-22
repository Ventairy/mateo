part of 'mateo_orbit.dart';

/// A single widget placed on a [MateoOrbit].
///
/// Each item occupies a fixed position on the orbit circle and revolves
/// around the center as the orbit rotates. The [size] drives both the
/// item's on-screen extent and the auto-computed orbit radius so every
/// item stays fully visible.
@immutable
class MateoOrbitItem {
  /// Creates an orbit item.
  const MateoOrbitItem({required this.child, required this.size});

  /// The widget rendered at this orbit position.
  final Widget child;

  /// The layout extent of [child].
  ///
  /// Used to center the item on the orbit circle and, when [MateoOrbit.radius]
  /// is omitted, to compute a radius that keeps every item fully inside the
  /// available bounds.
  final Size size;
}
