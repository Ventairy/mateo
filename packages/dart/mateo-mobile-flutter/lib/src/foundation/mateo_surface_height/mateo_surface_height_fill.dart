part of 'mateo_surface_height.dart';

/// A fill height request for a Mateo surface.
final class MateoSurfaceHeightFill extends MateoSurfaceHeight {
  /// Creates a fill height request.
  const MateoSurfaceHeightFill() : super._();

  /// Whether both values describe the same height request.
  @override
  bool operator ==(Object other) => other is MateoSurfaceHeightFill;

  /// The hash of this height request.
  @override
  int get hashCode => Object.hash(MateoSurfaceHeightFill, null);
}
