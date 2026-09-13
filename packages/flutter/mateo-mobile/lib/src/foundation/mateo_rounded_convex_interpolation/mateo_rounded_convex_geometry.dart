import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart' show internal;

part '_mateo_rounded_convex_endpoint.dart';

const double _tau = 2 * math.pi;
const double _degree = math.pi / 180;
const _flatness = .003;

typedef _Feature = ({double angle, double span});
typedef _Edge = ({double angle, double length});
typedef _Contribution = ({Offset direction, double begin, double end});

double _angle(Offset p) => math.atan2(p.dy, p.dx) % _tau;
double _delta(double a, double b) => math.atan2(math.sin(a - b), math.cos(a - b));
double _distance(Offset p, Offset a, Offset b) {
  final d = b - a;
  final f = d.distanceSquared == 0
      ? 0.0
      : (((p.dx - a.dx) * d.dx + (p.dy - a.dy) * d.dy) / d.distanceSquared).clamp(0.0, 1.0);
  return (p - a - d * f).distance;
}

double _tolerance(double ordinary, double longest) => math.max(longest * 1e-8, math.min(ordinary, longest * 1e-3));

List<Offset> _compactPolygon(List<Offset> points, double tolerance) {
  final anchors = <int>{};
  for (var axis = 0; axis < 2; axis++) {
    for (final sign in [-1, 1]) {
      var best = 0;
      for (var i = 1; i < points.length; i++) {
        if (sign * (axis == 0 ? points[i].dx : points[i].dy) > sign * (axis == 0 ? points[best].dx : points[best].dy)) {
          best = i;
        }
      }
      anchors.add(best);
    }
  }
  final ordered = anchors.toList()..sort();
  final keep = {...anchors};
  final n = points.length;
  void split(int a, int b) {
    var maximum = tolerance;
    var index = -1;
    for (var j = a + 1; j < b; j++) {
      final d = _distance(points[j % n], points[a % n], points[b % n]);
      if (d > maximum) {
        maximum = d;
        index = j;
      }
    }
    if (index >= 0) {
      keep.add(index % n);
      split(a, index);
      split(index, b);
    }
  }

  for (var i = 0; i < ordered.length; i++) {
    split(ordered[i], ordered[(i + 1) % ordered.length] + (i == ordered.length - 1 ? n : 0));
  }
  return [for (final i in keep.toList()..sort()) points[i]];
}

List<_Edge> _edges(List<Offset> points, double minimum) => [
  for (var i = 0; i < points.length; i++)
    if ((points[(i + 1) % points.length] - points[i]).distance >= minimum)
      (
        angle: _angle(points[(i + 1) % points.length] - points[i]),
        length: (points[(i + 1) % points.length] - points[i]).distance,
      ),
]..sort((a, b) => a.angle.compareTo(b.angle));

List<_Feature> _features(List<_Edge> edges, double width, double height) {
  // Sliding windows avoid a seam chosen among nearly equal angular gaps.
  final extended = <_Edge>[
    for (final e in edges) (angle: e.angle - _tau, length: e.length),
    ...edges,
    for (final e in edges) (angle: e.angle + _tau, length: e.length),
  ];
  final candidates = <({double length, double angle, double span})>[];
  var low = 0;
  var high = 0;
  var total = 0.0;
  for (final edge in edges) {
    while (high < extended.length && extended[high].angle <= edge.angle + _degree / 2) {
      total += extended[high++].length;
    }
    while (low < high && extended[low].angle < edge.angle - _degree / 2) {
      total -= extended[low++].length;
    }
    if (total >= .18 * math.min(width, height)) {
      final start = extended[low].angle;
      final end = extended[high - 1].angle;
      candidates.add((length: total, angle: ((start + end) / 2) % _tau, span: end - start));
    }
  }
  candidates.sort((a, b) {
    final byLength = b.length.compareTo(a.length);
    return byLength == 0 ? a.angle.compareTo(b.angle) : byLength;
  });
  final result = <_Feature>[];
  for (final c in candidates) {
    if (!result.any((f) => _delta(c.angle, f.angle).abs() < 3 * _degree)) {
      result.add((angle: c.angle, span: c.span));
    }
  }
  return result..sort((a, b) => a.angle.compareTo(b.angle));
}

double _spread(double angle, List<_Feature> own, List<_Feature> other) {
  if (other.length < 2) return 0;
  _Feature? feature;
  for (final f in own) {
    if (_delta(angle, f.angle).abs() <= f.span / 2 + 1e-8) {
      feature = f;
      break;
    }
  }
  if (feature == null) return 0;
  for (final f in other) {
    if (_delta(feature.angle, f.angle).abs() < 3 * _degree) return 0;
  }
  var left = double.infinity;
  var right = double.infinity;
  for (final f in other) {
    left = math.min(left, (feature.angle - f.angle) % _tau);
    right = math.min(right, (f.angle - feature.angle) % _tau);
  }
  final u = ((math.pi - left - right - 6 * _degree) / (math.pi / 3 - 6 * _degree)).clamp(0.0, 1.0);
  return math.min(left, right) * .9 * u * u * (3 - 2 * u);
}

@internal
final class MateoRoundedConvexPair {
  MateoRoundedConvexPair(MateoRoundedConvexEndpoint a, MateoRoundedConvexEndpoint b)
    : _minimum = math.min(1e-12, math.max(a.longest, b.longest) * 1e-12) {
    final merged = <({double angle, double begin, double end})>[];
    var i = 0;
    var j = 0;
    while (i < a._outlineEdges.length || j < b._outlineEdges.length) {
      final aa = i < a._outlineEdges.length ? a._outlineEdges[i].angle : double.infinity;
      final ab = j < b._outlineEdges.length ? b._outlineEdges[j].angle : double.infinity;
      if ((aa - ab).abs() < 1e-10) {
        merged.add((angle: aa, begin: a._outlineEdges[i++].length, end: b._outlineEdges[j++].length));
      } else if (aa < ab) {
        merged.add((angle: aa, begin: a._outlineEdges[i++].length, end: 0));
      } else {
        merged.add((angle: ab, begin: 0, end: b._outlineEdges[j++].length));
      }
    }
    final refines = merged.any(
      (e) =>
          _spread(e.angle, a._flatFeatures, b._flatFeatures) > 1e-7 ||
          _spread(e.angle, b._flatFeatures, a._flatFeatures) > 1e-7,
    );
    roundsCorners =
        refines ||
        (a._flatFeatures.isEmpty && b._flatFeatures.length >= 3) ||
        (b._flatFeatures.isEmpty && a._flatFeatures.length >= 3);
    _base = [
      for (final e in merged) (direction: Offset(math.cos(e.angle), math.sin(e.angle)), begin: e.begin, end: e.end),
    ];
  }
  final double _minimum;
  late final bool roundsCorners;
  late final List<_Contribution> _base;
  late final Float64List _weights = Float64List(_base.length);

  Float64List evaluate(double t) {
    if (!t.isFinite) throw ArgumentError.value(t, 'progress', 'Progress must be finite.');
    final q = mateoRoundedConvexOutlineProgress(t);
    final edges = _base;
    final weights = _weights;
    var total = 0.0;
    var mx = 0.0;
    var my = 0.0;
    for (var i = 0; i < edges.length; i++) {
      final e = edges[i];
      final w = mateoRoundedConvexPositive(e.begin, e.end, q, minimum: _minimum);
      weights[i] = w;
      total += w;
      mx += w * e.direction.dx;
      my += w * e.direction.dy;
    }
    mx /= total;
    my /= total;
    final count = edges.length;
    final points = Float64List(count * 2);
    var x = 0.0;
    var y = 0.0;
    var x0 = double.infinity;
    var x1 = double.negativeInfinity;
    var y0 = double.infinity;
    var y1 = double.negativeInfinity;
    for (var i = 0; i < count; i++) {
      points[2 * i] = x;
      points[2 * i + 1] = y;
      x0 = math.min(x0, x);
      x1 = math.max(x1, x);
      y0 = math.min(y0, y);
      y1 = math.max(y1, y);
      x += weights[i] * (edges[i].direction.dx - mx);
      y += weights[i] * (edges[i].direction.dy - my);
    }
    if (!x1.isFinite || !y1.isFinite || x1 <= x0 || y1 <= y0) {
      throw ArgumentError('The contour must have positive finite area.');
    }
    for (var i = 0; i < points.length; i += 2) {
      points[i] = (points[i] - (x0 + x1) / 2) / (x1 - x0);
      points[i + 1] = (points[i + 1] - (y0 + y1) / 2) / (y1 - y0);
    }
    return points;
  }
}

@internal
double mateoRoundedConvexOutlineProgress(double t) {
  if (t >= 0 && t <= 1) return t;
  final distance = t < 0 ? -t : t - 1;
  final exponential = math.exp(-2 * distance / .08);
  final continuation = .08 * (1 - exponential) / (1 + exponential);
  return t < 0 ? -continuation : 1 + continuation;
}

@internal
double mateoRoundedConvexPositive(double a, double b, double t, {double minimum = 1e-12}) {
  if (t >= 0 && t <= 1) return (1 - t) * a + t * b;
  final begin = math.max(minimum, a);
  final end = math.max(minimum, b);
  final x = t < 0 ? begin : end;
  final z = (end - begin) * (t < 0 ? t : t - 1);
  if (z >= 0) return x + z;
  final q = -z / x;
  return x / (1 + q + q * q);
}
