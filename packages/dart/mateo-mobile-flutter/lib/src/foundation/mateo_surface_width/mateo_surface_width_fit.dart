part of 'mateo_surface_width.dart';

/// A fit width request for a Mateo surface.
final class MateoSurfaceWidthFit extends MateoSurfaceWidth {
  /// Creates a fit width request.
  const MateoSurfaceWidthFit() : super._();

  /// Whether both values describe the same width request.
  @override
  bool operator ==(Object other) => other is MateoSurfaceWidthFit;

  /// The hash of this width request.
  @override
  int get hashCode => Object.hash(MateoSurfaceWidthFit, null);
}
