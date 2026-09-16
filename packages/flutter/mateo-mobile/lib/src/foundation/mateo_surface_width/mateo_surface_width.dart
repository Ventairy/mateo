import 'package:flutter/foundation.dart';

part 'mateo_surface_width_fit.dart';
part 'mateo_surface_width_fill.dart';
part 'mateo_surface_width_custom.dart';

/// The requested total width of a Mateo surface, including its padding.
@immutable
sealed class MateoSurfaceWidth {
  const MateoSurfaceWidth._();

  /// Creates content-sized width within the parent's constraints.
  ///
  /// Content that requests expansion may still fill the available space.
  const factory MateoSurfaceWidth.fit() = MateoSurfaceWidthFit;

  /// Creates width that fills the parent's finite available extent.
  const factory MateoSurfaceWidth.fill() = MateoSurfaceWidthFill;

  /// Creates a requested width in logical pixels, subject to parent constraints.
  ///
  /// The value must be finite and nonnegative.
  const factory MateoSurfaceWidth.custom(double value) = MateoSurfaceWidthCustom;
}
