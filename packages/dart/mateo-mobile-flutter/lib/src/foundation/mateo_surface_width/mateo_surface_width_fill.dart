part of 'mateo_surface_width.dart';

/// A fill width request for a Mateo surface.
final class MateoSurfaceWidthFill extends MateoSurfaceWidth {
  /// Creates a fill width request.
  const MateoSurfaceWidthFill() : super._();

  /// Whether both values describe the same width request.
  @override
  bool operator ==(Object other) => other is MateoSurfaceWidthFill;

  /// The hash of this width request.
  @override
  int get hashCode => Object.hash(MateoSurfaceWidthFill, null);
}
