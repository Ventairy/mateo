import 'package:flutter/foundation.dart';

part 'mateo_surface_height_fit.dart';
part 'mateo_surface_height_fill.dart';
part 'mateo_surface_height_custom.dart';

/// The requested total height of a Mateo surface, including its padding.
@immutable
sealed class MateoSurfaceHeight {
  const MateoSurfaceHeight._();

  /// Creates content-sized height within the parent's constraints.
  ///
  /// Content that requests expansion may still fill the available space.
  const factory MateoSurfaceHeight.fit() = MateoSurfaceHeightFit;

  /// Creates height that fills the parent's finite available extent.
  const factory MateoSurfaceHeight.fill() = MateoSurfaceHeightFill;

  /// Creates a requested height in logical pixels, subject to parent constraints.
  ///
  /// The value must be finite and nonnegative.
  const factory MateoSurfaceHeight.custom(double value) = MateoSurfaceHeightCustom;
}
