import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show internal;
import 'package:flutter/painting.dart';

import '../mateo_border_contour.dart';
import '../mateo_capsule_border/mateo_capsule_border.dart';
import '../mateo_rounded_rectangle_border/mateo_rounded_rectangle_border.dart';
import 'mateo_rounded_convex_evaluator.dart';

// Keep at most thirty-two endpoint descriptions, including their lazily cached
// edge geometry. Weak keys do not retain custom borders or application state.
final _preparedBorders =
    <
      ({
        WeakReference<ShapeBorder> shape,
        Size size,
        TextDirection? direction,
        MateoRoundedConvexDescription description,
      })
    >[];

@internal
MateoRoundedConvexDescription prepareMateoRoundedConvexBorder(
  ShapeBorder border,
  Size size,
  TextDirection? textDirection,
) {
  _validateSize(size);
  for (var i = _preparedBorders.length - 1; i >= 0; i--) {
    final prepared = _preparedBorders[i];
    final shape = prepared.shape.target;
    if (shape == null) {
      _preparedBorders.removeAt(i);
    } else if (shape == border && prepared.size == size && prepared.direction == textDirection) {
      if (i != _preparedBorders.length - 1) {
        _preparedBorders
          ..removeAt(i)
          ..add(prepared);
      }
      return prepared.description;
    }
  }
  final tolerance = size.longestSide * 1e-6;
  final points = switch (border) {
    MateoCapsuleBorder() => mateoBorderContour(mateoCapsuleCubics(size), tolerance),
    MateoRoundedRectangleBorder(:final radius) when radius == 0 => <Offset>[
      Offset.zero,
      Offset(size.width, 0),
      Offset(size.width, size.height),
      Offset(0, size.height),
    ],
    MateoRoundedRectangleBorder(:final radius) => mateoBorderContour(
      mateoRoundedRectangleCubics(size, radius),
      tolerance,
    ),
    _ => _samplePath(border.getOuterPath(Offset.zero & size, textDirection: textDirection), size),
  };
  final normalized = _normalize(points, size);
  final description = mateoRoundedConvexDescribePoints(normalized, size);
  if (_preparedBorders.length == 32) _preparedBorders.removeAt(0);
  _preparedBorders.add((shape: WeakReference(border), size: size, direction: textDirection, description: description));
  return description;
}

void _validateSize(Size size) {
  if (!size.width.isFinite ||
      !size.height.isFinite ||
      size.width < 1e-37 ||
      size.height < 1e-37 ||
      size.longestSide > 3.4e38) {
    throw ArgumentError.value(size, 'size', 'Both endpoint dimensions must be positive and finite.');
  }
}

List<Offset> _samplePath(Path path, Size size) {
  final bounds = path.getBounds();
  if (!bounds.isFinite || bounds.isEmpty) throw ArgumentError('The border must have a finite, nonempty contour.');
  // Measure in a stable native coordinate range, avoiding PathMetric's coarse
  // flattening on small borders. This path is never sampled during animation.
  final scale = 8192 / size.longestSide;
  final matrix = Float64List(16)
    ..[0] = scale
    ..[5] = scale
    ..[10] = 1
    ..[15] = 1;
  final metrics = path.transform(matrix).computeMetrics().toList();
  if (metrics.length != 1 || !metrics.single.isClosed || !metrics.single.length.isFinite) {
    throw ArgumentError('Provide one closed convex contour, without holes or disconnected regions.');
  }
  final metric = metrics.single;
  if (metric.length <= 0) throw ArgumentError('The border must have positive perimeter.');
  Offset point(double fraction) {
    final tangent = metric.getTangentForOffset(metric.length * fraction);
    if (tangent == null) throw ArgumentError('The border cannot be sampled.');
    return tangent.position / scale;
  }

  final points = <Offset>[];
  void sample(double start, Offset a, double end, Offset b, int depth) {
    final middle = (start + end) / 2;
    final m = point(middle);
    final chord = b - a;
    final distance = chord.distance;
    final deviation = distance == 0
        ? (m - a).distance
        : ((m.dx - a.dx) * chord.dy - (m.dy - a.dy) * chord.dx).abs() / distance;
    if (depth >= 8 && deviation <= size.longestSide * 2e-6) {
      points.add(a);
      return;
    }
    if (depth >= 24) throw ArgumentError('The border cannot be sampled with sufficient accuracy.');
    sample(start, a, middle, m, depth + 1);
    sample(middle, m, end, b, depth + 1);
  }

  // Multiple seeds keep an inward feature from hiding at a midpoint.
  for (var i = 0; i < 16; i++) {
    sample(i / 16, point(i / 16), (i + 1) / 16, point((i + 1) / 16), 4);
  }
  // Path.getBounds may include Bezier handles outside the visible curve.
  // Validate the sampled boundary, using a tolerance above sampling error.
  var left = double.infinity;
  var top = double.infinity;
  var right = double.negativeInfinity;
  var bottom = double.negativeInfinity;
  for (final point in points) {
    left = math.min(left, point.dx);
    top = math.min(top, point.dy);
    right = math.max(right, point.dx);
    bottom = math.max(bottom, point.dy);
  }
  final tolerance = math.max(1e-4, size.longestSide * 1e-5);
  if (left.abs() > tolerance ||
      top.abs() > tolerance ||
      (right - size.width).abs() > tolerance ||
      (bottom - size.height).abs() > tolerance) {
    throw ArgumentError('The border outer contour must occupy the supplied endpoint bounds.');
  }
  return points;
}

List<Offset> _normalize(List<Offset> input, Size size) {
  var points = <Offset>[];
  for (final point in input) {
    final normalized = Offset(point.dx / size.width - .5, point.dy / size.height - .5);
    if (!normalized.dx.isFinite || !normalized.dy.isFinite) throw ArgumentError('The border must be finite.');
    if (points.isEmpty) {
      points.add(normalized);
    } else {
      final dx = normalized.dx - points.last.dx;
      final dy = normalized.dy - points.last.dy;
      if (dx * dx + dy * dy > 1e-20) points.add(normalized);
    }
  }
  if (points.length > 1) {
    final dx = points.first.dx - points.last.dx;
    final dy = points.first.dy - points.last.dy;
    if (dx * dx + dy * dy < 1e-20) points.removeLast();
  }
  if (points.length < 3) throw ArgumentError('The border must have positive area.');
  var area = 0.0;
  for (var i = 0; i < points.length; i++) {
    area += _cross(points[i], points[(i + 1) % points.length]);
  }
  if (area.abs() < 1e-12) throw ArgumentError('The border must have positive area.');
  if (area < 0) points = points.reversed.toList();
  // Remove only sub-tolerance collinearity introduced by path quantization.
  // Inward features above this tolerance are rejected, never replaced by a hull.
  var changed = true;
  while (changed && points.length > 3) {
    changed = false;
    final retained = <Offset>[];
    for (var i = 0; i < points.length; i++) {
      final previous = retained.isEmpty ? points[(i + points.length - 1) % points.length] : retained.last;
      final current = points[i];
      final next = points[(i + 1) % points.length];
      final dx = next.dx - previous.dx;
      final dy = next.dy - previous.dy;
      final ax = current.dx - previous.dx;
      final ay = current.dy - previous.dy;
      final lengthSquared = dx * dx + dy * dy;
      final projection = ax * dx + ay * dy;
      final cross = ax * dy - ay * dx;
      if (i < points.length - 1 &&
          retained.length + points.length - i > 3 &&
          projection >= 0 &&
          projection <= lengthSquared &&
          cross * cross <= 1e-14 * lengthSquared) {
        changed = true;
      } else {
        retained.add(current);
      }
    }
    points = retained;
  }
  var turning = 0.0;
  for (var i = 0; i < points.length; i++) {
    final current = points[i];
    final previous = points[(i + points.length - 1) % points.length];
    final next = points[(i + 1) % points.length];
    final ax = current.dx - previous.dx;
    final ay = current.dy - previous.dy;
    final bx = next.dx - current.dx;
    final by = next.dy - current.dy;
    final turn = math.atan2(ax * by - ay * bx, ax * bx + ay * by);
    if (turn < -1e-5) throw ArgumentError('The border must be convex; inward contours are unsupported.');
    turning += turn;
  }
  if ((turning - mateoRoundedConvexTau).abs() > 1e-5) {
    throw ArgumentError('The border must make exactly one convex turn.');
  }
  return points;
}

double _cross(Offset a, Offset b) => a.dx * b.dy - a.dy * b.dx;
