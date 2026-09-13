import 'package:flutter/foundation.dart';

/// The animation connecting appearances of a Mateo surface.
@immutable
final class MateoSurfaceAnimation {
  /// Creates a surface animation with no transition.
  const MateoSurfaceAnimation.none() : id = null;

  /// Creates a transform connecting surfaces with an equal [id].
  ///
  /// Keep the ID's equality and hash code stable while the surface is mounted.
  /// Ordinary and view surfaces can share the same ID.
  ///
  /// ```dart
  /// final card = MateoSurface(
  ///   animation: const .transform(id: 'details'),
  ///   shape: const .capsule(),
  ///   child: const Text('Open details'),
  /// );
  /// final screen = MateoView(
  ///   surface: MateoViewSurface(
  ///     animation: const .transform(id: 'details'),
  ///     child: const Text('Details'),
  ///   ),
  /// );
  /// ```
  ///
  /// Navigate from the card's route to the screen, or mount a new keyed
  /// appearance in the same overlay. Rebuilding an existing surface updates
  /// it directly. Navigation stays under the app's control.
  ///
  /// See the [surface guidance](https://github.com/Ventairy/mateo/blob/main/design-system/mobile/surface.md).
  const MateoSurfaceAnimation.transform({required Object this.id});

  /// The identity shared by matching surfaces, or null when animation is off.
  final Object? id;

  /// Whether both values describe the same surface animation.
  @override
  bool operator ==(Object other) => other is MateoSurfaceAnimation && id == other.id;

  /// The hash of this surface animation.
  @override
  int get hashCode => Object.hash(MateoSurfaceAnimation, id);
}
