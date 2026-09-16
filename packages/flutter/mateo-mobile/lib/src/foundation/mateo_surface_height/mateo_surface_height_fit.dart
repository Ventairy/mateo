part of 'mateo_surface_height.dart';

/// A fit height request for a Mateo surface.
final class MateoSurfaceHeightFit extends MateoSurfaceHeight {
  /// Creates a fit height request.
  const MateoSurfaceHeightFit() : super._();

  /// Whether both values describe the same height request.
  @override
  bool operator ==(Object other) => other is MateoSurfaceHeightFit;

  /// The hash of this height request.
  @override
  int get hashCode => Object.hash(MateoSurfaceHeightFit, null);
}
