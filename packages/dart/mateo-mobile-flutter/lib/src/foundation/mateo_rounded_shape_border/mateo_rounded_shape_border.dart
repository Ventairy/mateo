import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/painting.dart';

part '_mateo_rounded_shape_lerp_border.dart';
part '_mateo_rounded_shape_path.dart';

/// Mateo's outline for rounded shapes, like rectangles, pills, and circles.
///
/// [radius] controls rounding in logical pixels. It fits to half the shorter
/// side; [MateoRoundedShapeBorder.capsule] selects that full rounding at any size.
/// A fully rounded square is an exact circle. The border paints no stroke.
///
/// ```dart
/// const ShapeDecoration(
///   color: Color(0xFF4A5CFF),
///   shape: MateoRoundedShapeBorder(radius: 24),
/// )
/// ```
///
/// See the [rounded-shape foundation](https://github.com/Ventairy/mateo/blob/main/design-system/foundation/rounded-shape.md).
final class MateoRoundedShapeBorder extends ShapeBorder {
  /// Creates a rounded shape with a finite, nonnegative [radius].
  const MateoRoundedShapeBorder({required double radius})
    : assert(radius >= 0 && radius < double.infinity, 'radius must be finite and nonnegative'),
      radius = radius;

  /// Creates full rounding that follows the current bounds.
  const MateoRoundedShapeBorder.capsule() : radius = null;

  /// The requested rounding, or null for full rounding from the bounds.
  ///
  /// This is the circular bend's radius, not a minimum local curvature radius.
  final double? radius;

  /// Resolves the visible radius within positive, finite [size].
  double resolveRadius(Size size) => _resolveRadius(radius, size);

  static double _resolveRadius(double? requested, Size size) {
    if (requested != null && (!requested.isFinite || requested < 0)) {
      throw ArgumentError.value(requested, 'radius', 'Must be finite and nonnegative.');
    }
    if (!size.width.isFinite || !size.height.isFinite || size.isEmpty) {
      throw ArgumentError.value(size, 'size', 'Both dimensions must be positive and finite.');
    }
    return math.min(requested ?? size.shortestSide / 2, size.shortestSide / 2);
  }

  /// Blends endpoint sizes and radii into a rounded shape.
  ///
  /// Resolve capsule radii with [resolveRadius] before calling this method.
  /// Each finite, nonnegative endpoint radius is fitted to its own size.
  /// Flutter linearly blends width, height, and the fitted radii, including
  /// outside 0–1. The resulting radius stays nonnegative and fits the new bounds.
  /// Nonfinite progress, invalid endpoints, or unrepresentable frames throw
  /// [ArgumentError]. Dimensions must remain positive and finite.
  ///
  /// To redirect a movement, use its visible size and radius as [begin].
  /// Timing and position belong to the caller.
  ///
  /// ```dart
  /// final frame = MateoRoundedShapeBorder.lerp(
  ///   begin: (size: const Size(200, 56), radius: 28),
  ///   end: (size: const Size(320, 480), radius: 32),
  ///   progress: progress,
  /// );
  /// ```
  ///
  /// See the [interpolation foundation](https://github.com/Ventairy/mateo/blob/main/design-system/foundation/rounded-shape-interpolation.md).
  static ({Size size, MateoRoundedShapeBorder border}) lerp({
    required ({Size size, double radius}) begin,
    required ({Size size, double radius}) end,
    required double progress,
  }) {
    if (!progress.isFinite) throw ArgumentError.value(progress, 'progress', 'Must be finite.');
    final beginRadius = _resolveRadius(begin.radius, begin.size);
    final endRadius = _resolveRadius(end.radius, end.size);
    if (progress == 0 || (begin.size == end.size && beginRadius == endRadius)) {
      return (size: begin.size, border: .new(radius: beginRadius));
    }
    if (progress == 1) return (size: end.size, border: .new(radius: endRadius));
    final size = Size(
      lerpDouble(begin.size.width, end.size.width, progress)!,
      lerpDouble(begin.size.height, end.size.height, progress)!,
    );
    final radius = lerpDouble(beginRadius, endRadius, progress)!;
    if (!size.width.isFinite || !size.height.isFinite || size.isEmpty || !radius.isFinite) {
      throw ArgumentError.value(progress, 'progress', 'Produces an invalid or unrepresentable rounded shape.');
    }
    return (size: size, border: .new(radius: math.min(math.max<double>(0, radius), size.shortestSide / 2)));
  }

  /// The zero inset of this stroke-free shape.
  @override
  EdgeInsetsGeometry get dimensions => .zero;

  /// Scales a requested radius by [t], clamping negative results to zero.
  ///
  /// Full rounding continues to follow the bounds.
  @override
  MateoRoundedShapeBorder scale(double t) => radius == null ? this : .new(radius: math.max(0, radius! * t));

  /// Blends fitted radii within the painted bounds using Mateo's interpolation.
  ///
  /// Use [lerp] when the bounds also change.
  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) =>
      a is MateoRoundedShapeBorder ? _lerp(a, this, t) : super.lerpFrom(a, t);

  /// Blends fitted radii within the painted bounds using Mateo's interpolation.
  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) =>
      b is MateoRoundedShapeBorder ? _lerp(this, b, t) : super.lerpTo(b, t);

  static ShapeBorder _lerp(MateoRoundedShapeBorder a, MateoRoundedShapeBorder b, double t) {
    if (!t.isFinite) throw ArgumentError.value(t, 't', 'Must be finite.');
    if (t == 0 || a == b) return a;
    if (t == 1) return b;
    return _MateoRoundedShapeLerpBorder(begin: a, end: b, progress: t);
  }

  /// The interior outline, identical to [getOuterPath] because there is no stroke.
  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => getOuterPath(rect, textDirection: textDirection);

  /// Draws cubic shoulders and circular bends within [rect].
  ///
  /// Empty or nonfinite bounds produce an empty path. Invalid radii are rejected.
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    if (radius != null && (!radius!.isFinite || radius! < 0)) throw ArgumentError.value(radius, 'radius');
    if (rect.isEmpty || !rect.isFinite || !rect.width.isFinite || !rect.height.isFinite) return Path();
    return _mateoRoundedShapePath(rect, resolveRadius(rect.size));
  }

  /// Paints no stroke; decorations paint the interior using [getOuterPath].
  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  bool operator ==(Object other) => other is MateoRoundedShapeBorder && radius == other.radius;

  @override
  int get hashCode => Object.hash(MateoRoundedShapeBorder, radius);

  @override
  String toString() =>
      radius == null ? 'MateoRoundedShapeBorder.capsule()' : 'MateoRoundedShapeBorder(radius: $radius)';
}
