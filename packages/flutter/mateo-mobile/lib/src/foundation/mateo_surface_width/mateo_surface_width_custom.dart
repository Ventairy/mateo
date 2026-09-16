part of 'mateo_surface_width.dart';

/// A custom width request for a Mateo surface.
final class MateoSurfaceWidthCustom extends MateoSurfaceWidth {
  /// Creates a custom width request.
  const MateoSurfaceWidthCustom(this.value)
    : assert(value >= 0 && value < double.infinity, 'width must be finite and nonnegative.'),
      super._();

  /// The requested total extent in logical pixels.
  final double value;

  /// Whether both values describe the same width request.
  @override
  bool operator ==(Object other) => other is MateoSurfaceWidthCustom && value == other.value;

  /// The hash of this width request.
  @override
  int get hashCode => Object.hash(MateoSurfaceWidthCustom, value);
}
