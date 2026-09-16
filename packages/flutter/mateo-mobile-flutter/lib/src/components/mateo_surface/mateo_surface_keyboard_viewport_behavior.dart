part of '../mateo_surface.dart';

/// Policies for sizing a managed surface viewport around the keyboard.
enum MateoSurfaceKeyboardViewportBehavior {
  /// Resizes the managed viewport to end above the software keyboard.
  resize,

  /// Extends the managed viewport behind the software keyboard.
  ///
  /// The keyboard remains a trailing scroll and focus obstruction, so content
  /// can still move completely above it while the viewport paints underneath.
  extendBehind,
}
