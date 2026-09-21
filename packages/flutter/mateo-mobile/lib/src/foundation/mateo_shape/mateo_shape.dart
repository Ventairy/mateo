import 'package:flutter/foundation.dart';

import '../mateo_rounded_shape_border/mateo_rounded_shape_border.dart';

/// A supported Mateo shape treatment.
@immutable
final class MateoShape {
  /// Creates a shape with no treatment of its rectangular boundary.
  const MateoShape.none() : _border = const MateoRoundedShapeBorder(radius: 0), _radius = 0;

  /// Creates a capsule that adapts to its bounds.
  ///
  /// Equal width and height produce a circle.
  /// See the [rounded-shape foundation](https://github.com/Ventairy/mateo/blob/main/design-system/foundation/rounded-shape.md).
  const MateoShape.capsule() : _border = const MateoRoundedShapeBorder.capsule(), _radius = 0;

  /// Creates a rounded shape with the requested rounding [radius].
  // Keep the public argument name independent of private storage.
  // ignore: prefer_initializing_formals
  const MateoShape.rounded({required double radius}) : _border = null, _radius = radius;

  @internal
  // Internal rendering inputs do not have consumer Dartdoc.
  // ignore: public_member_api_docs
  MateoRoundedShapeBorder get border => _border ?? MateoRoundedShapeBorder(radius: _radius);

  final MateoRoundedShapeBorder? _border;
  final double _radius;

  /// Whether both values select the same shape treatment.
  @override
  bool operator ==(Object other) => other is MateoShape && border == other.border;

  /// The hash of this shape treatment.
  @override
  int get hashCode => Object.hash(MateoShape, border);
}
