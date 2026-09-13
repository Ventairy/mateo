import 'dart:math' as math;

import 'package:flutter/foundation.dart' show internal;
import 'package:flutter/painting.dart';

import '../mateo_border_contour.dart';

part '_mateo_rounded_rectangle_path.dart';

/// A Mateo rounded rectangle with one flowing curve at each corner.
///
/// Use [radius] to choose the tightest bend. Larger requests fit the bounds
/// without changing the outline into a capsule.
///
/// ```dart
/// const ShapeDecoration(
///   color: Color(0xFF4A5CFF),
///   shape: MateoRoundedRectangleBorder(radius: 24),
/// )
/// ```
///
/// See the [rounded-rectangle foundation](https://github.com/Ventairy/mateo/blob/main/design-system/foundation/rounded-rectangle.md).
final class MateoRoundedRectangleBorder extends ShapeBorder {
  /// Creates a rounded rectangle without a painted stroke or layout inset.
  const MateoRoundedRectangleBorder({required this.radius})
    : assert(radius >= 0 && radius < double.infinity, 'radius must be finite and nonnegative');

  /// The requested minimum radius of curvature, in logical pixels.
  final double radius;

  /// The zero inset of this stroke-free shape.
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  /// The shape with its radius scaled by [t], clamped at zero.
  @override
  MateoRoundedRectangleBorder scale(double t) => .new(radius: math.max(0, radius * t));

  /// The interpolation from another rounded rectangle, or the inherited fallback.
  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) => a is MateoRoundedRectangleBorder
      ? MateoRoundedRectangleBorder(radius: math.max(0, a.radius + (radius - a.radius) * t))
      : super.lerpFrom(a, t);

  /// The interpolation to another rounded rectangle, or the inherited fallback.
  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) =>
      b is MateoRoundedRectangleBorder ? b.lerpFrom(this, t) : super.lerpTo(b, t);

  /// The interior outline, identical to [getOuterPath] because there is no stroke.
  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => getOuterPath(rect, textDirection: textDirection);

  /// The rounded outline within [rect], independent of [textDirection].
  ///
  /// Empty or nonfinite bounds produce an empty path. Invalid radii are rejected.
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    if (!radius.isFinite || radius < 0) throw ArgumentError.value(radius, 'radius');
    if (rect.isEmpty || !rect.isFinite || !rect.width.isFinite || !rect.height.isFinite) return Path();
    if (radius == 0) return Path()..addRect(rect);
    return _MateoRoundedRectanglePath.create(rect, radius);
  }

  /// Paints no stroke; decorations paint the interior using [getOuterPath].
  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  bool operator ==(Object other) => other is MateoRoundedRectangleBorder && radius == other.radius;

  @override
  int get hashCode => Object.hash(MateoRoundedRectangleBorder, radius);

  @override
  String toString() => 'MateoRoundedRectangleBorder(radius: $radius)';
}

// Direct native geometry for the convex foundation; not exported to consumers.
@internal
List<MateoBorderCubic> mateoRoundedRectangleCubics(Size size, double radius) {
  if (!radius.isFinite || radius < 0) throw ArgumentError.value(radius, 'radius');
  final cubics = <MateoBorderCubic>[];
  _MateoRoundedRectanglePath.create(Offset.zero & size, radius, onCubic: cubics.add);
  return cubics;
}
