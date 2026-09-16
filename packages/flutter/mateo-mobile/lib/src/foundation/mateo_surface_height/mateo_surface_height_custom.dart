part of 'mateo_surface_height.dart';

/// A custom height request for a Mateo surface.
final class MateoSurfaceHeightCustom extends MateoSurfaceHeight {
  /// Creates a custom height request.
  const MateoSurfaceHeightCustom(this.value)
    : assert(value >= 0 && value < double.infinity, 'height must be finite and nonnegative.'),
      super._();

  /// The requested total extent in logical pixels.
  final double value;

  /// Whether both values describe the same height request.
  @override
  bool operator ==(Object other) => other is MateoSurfaceHeightCustom && value == other.value;

  /// The hash of this height request.
  @override
  int get hashCode => Object.hash(MateoSurfaceHeightCustom, value);
}
