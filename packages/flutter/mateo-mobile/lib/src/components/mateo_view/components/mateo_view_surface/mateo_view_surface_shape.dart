import 'package:flutter/foundation.dart';

import '../../../../foundation/mateo_rounded_shape_border/mateo_rounded_shape_border.dart';

/// A supported shape treatment for a Mateo view surface.
///
/// Omit the treatment to retain a square-edged boundary.
@immutable
final class MateoViewSurfaceShape {
  /// Creates a surface shape with no treatment of its rectangular boundary.
  const MateoViewSurfaceShape.none() : _border = const MateoRoundedShapeBorder(radius: 0), _radius = 0;

  /// Creates a rounded view surface with the requested rounding [_radius].
  const MateoViewSurfaceShape.rounded({required this._radius}) : _border = null;

  @internal
  // Internal rendering inputs do not have consumer Dartdoc.
  // ignore: public_member_api_docs
  MateoRoundedShapeBorder get border => _border ?? MateoRoundedShapeBorder(radius: _radius);

  final MateoRoundedShapeBorder? _border;
  final double _radius;

  /// Whether both values select the same surface treatment.
  @override
  bool operator ==(Object other) => other is MateoViewSurfaceShape && border == other.border;

  /// The hash of this surface treatment.
  @override
  int get hashCode => Object.hash(MateoViewSurfaceShape, border);
}
