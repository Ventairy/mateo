import 'dart:ffi' as ffi;
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart' show internal, visibleForTesting;

import 'mateo_rounded_convex_geometry.dart';
import 'mateo_rounded_convex_path.dart';

part '_mateo_rounded_convex_curve.dart';
part '_mateo_rounded_convex_chart.dart';
part '_mateo_rounded_convex_native.dart';
part '_mateo_rounded_convex_native_path.dart';
part '_mateo_rounded_convex_bindings.dart';
part '_mateo_rounded_convex_pair_cache.dart';

@internal
const mateoRoundedConvexIntervals = 512;
@internal
const mateoRoundedConvexLocations = 256;

// Static endpoint speeds and cyclic arc gaps need positive regularization.
// This is numerical regularization, not a radius or animation-speed setting.
@internal
const mateoRoundedConvexPreparedMinimum = 1e-12;

// Shared binary64 geometry used by endpoint preparation and frame evaluation.
// Coordinates remain centered and normalized until the border paints them.
@internal
typedef MateoRoundedConvexDescription = ({
  double width,
  double height,
  double angle,
  Float64List turns,
  Float64List speeds,
  Float64List spacings,
  MateoRoundedConvexEndpoint? outline,
});

@internal
const double mateoRoundedConvexTau = 2 * math.pi;

@internal
double mateoRoundedConvexDimension(double a, double b, double progress) {
  if (progress >= 0 && progress <= 1) return (1 - progress) * a + progress * b;
  const relativeDisplacementLimit = .2;
  final endpoint = progress < 0 ? a : b;
  final relative = (b - a) * (progress < 0 ? progress : progress - 1) / endpoint;
  if (!relative.isFinite) return double.nan;
  final ratio = relative / relativeDisplacementLimit;
  // Equivalent to relative / hypot(1, ratio), without squaring a large ratio.
  final softened = ratio.abs() <= 1
      ? relative / math.sqrt(1 + ratio * ratio)
      : relative.sign * relativeDisplacementLimit / math.sqrt(1 + (1 / ratio) * (1 / ratio));
  return softened >= 0 ? endpoint * (1 + softened) : endpoint / (1 - softened + softened * softened);
}

@internal
void mateoRoundedConvexFitPoints(
  Float64List points,
  double width,
  double height,
) {
  for (var axis = 0; axis < 2; axis++) {
    var minimum = double.infinity;
    var maximum = double.negativeInfinity;
    for (var i = axis; i < points.length; i += 2) {
      minimum = math.min(minimum, points[i]);
      maximum = math.max(maximum, points[i]);
    }
    final extent = maximum - minimum;
    if (!extent.isFinite || extent <= 0) throw ArgumentError('The contour must have positive finite area.');
    final center = (minimum + maximum) / 2;
    final scale = (axis == 0 ? width : height) / extent;
    for (var i = axis; i < points.length; i += 2) {
      points[i] = (points[i] - center) * scale;
    }
  }
}

@internal
void mateoRoundedConvexLengths(Float64List points, Float64List lengths) {
  lengths[0] = 0;
  for (var i = 0; i < lengths.length - 1; i++) {
    final next = (i + 1) % (lengths.length - 1);
    final dx = points[2 * next] - points[2 * i];
    final dy = points[2 * next + 1] - points[2 * i + 1];
    lengths[i + 1] = lengths[i] + math.sqrt(dx * dx + dy * dy);
  }
}

@internal
Float64List mateoRoundedConvexArcSites(Float64List polygon, int locations) {
  final count = polygon.length ~/ 2;
  final lengths = Float64List(count + 1);
  mateoRoundedConvexLengths(polygon, lengths);
  final weights = Float64List(count);
  final bends = Float64List(count);
  for (var i = 0; i < count; i++) {
    final previous = (i + count - 1) % count;
    final next = (i + 1) % count;
    final ax = polygon[2 * i] - polygon[2 * previous];
    final ay = polygon[2 * i + 1] - polygon[2 * previous + 1];
    final bx = polygon[2 * next] - polygon[2 * i];
    final by = polygon[2 * next + 1] - polygon[2 * i + 1];
    bends[i] = math.max(0, ax * by - ay * bx);
  }
  final factor = 4 * count * count / (mateoRoundedConvexTau * lengths.last);
  var total = 0.0;
  for (var i = 0; i < count; i++) {
    weights[i] = lengths[i + 1] - lengths[i] + factor * (bends[i] + bends[(i + 1) % count]) / 2;
    total += weights[i];
  }
  final sites = Float64List(locations);
  var edge = 0;
  var prefix = 0.0;
  for (var i = 0; i < locations; i++) {
    final target = total * i / locations;
    while (edge < count - 1 && prefix + weights[edge] <= target) {
      prefix += weights[edge++];
    }
    final fraction = (target - prefix) / weights[edge];
    sites[i] = (lengths[edge] + fraction * (lengths[edge + 1] - lengths[edge])) / lengths.last;
  }
  return sites;
}

// Weak numeric keys share endpoint fits without retaining application objects.
final _endpointGeometry = Expando<MateoRoundedConvexEndpoint>();

@internal
Path mateoRoundedConvexNativePath(Float64List points, Rect bounds, {double tolerance = .01}) =>
    _MateoRoundedConvexNativePath.shared.path(points, bounds, tolerance: tolerance);

@internal
final class MateoRoundedConvexEvaluator {
  MateoRoundedConvexEvaluator({
    required this.intervals,
    required this.locations,
  });
  final int intervals;
  final int locations;
  late final _MateoRoundedConvexCurve _curve = .new(
    intervals: intervals,
    locations: locations,
  );
  MateoRoundedConvexDescription? _begin;
  MateoRoundedConvexDescription? _end;
  late MateoRoundedConvexPair _pair;
  late _MateoNativeKernel _native;

  MateoRoundedConvexDescription _chart(
    MateoRoundedConvexDescription description,
  ) {
    if (description.turns.isNotEmpty) return description;
    final outline = description.outline!;
    return mateoRoundedConvexDescribePoints([
      for (final p in outline.points) .new(p.dx / description.width, p.dy / description.height),
    ], .new(description.width, description.height));
  }

  Float64List _rawOutline(double t) {
    if (t == 0 || t == 1) return _pair.evaluate(t);
    return _native.frame(t);
  }

  MateoRoundedConvexEndpoint _endpoint(
    MateoRoundedConvexDescription description,
  ) {
    if (description.outline case final outline?) return outline;
    final cached = _endpointGeometry[description.turns];
    if (cached != null) return cached;
    final cubics = _curve.reconstruct(description);
    return _endpointGeometry[description.turns] = MateoRoundedConvexEndpoint.fromCubics(
      cubics,
      description.width,
      description.height,
    );
  }

  @visibleForTesting
  static int get preparedPairCacheBytes => _preparedPairs.retainedBytes;

  @visibleForTesting
  static void clearPreparedPairs() => _preparedPairs.clear();

  void prepare(
    MateoRoundedConvexDescription begin,
    MateoRoundedConvexDescription end,
  ) {
    if (_begin == begin && _end == end) return;
    final cached = _preparedPairs.find(begin, end);
    if (cached != null) {
      _pair = cached.pair;
      _native = cached.kernel;
    } else {
      final a = _endpoint(begin);
      final b = _endpoint(end);
      final pair = MateoRoundedConvexPair(a, b);
      _MateoNativeKernel? native;
      if (pair.roundsCorners) {
        native = _preparedPairs.find(end, begin)?.kernel.reversed();
        if (native == null) {
          final curveBegin = _chart(begin);
          final curveEnd = _chart(end);
          native = _MateoNativeKernel.rounded(curveBegin, curveEnd, a, b);
        }
      } else {
        native = _MateoNativeKernel.physical(begin, end, a, b);
      }
      _preparedPairs.add(begin, end, pair, native);
      _pair = pair;
      _native = native;
    }
    _begin = begin;
    _end = end;
  }

  static final _pathBuilder = MateoRoundedConvexPathBuilder();

  ({Float64List points, Path path}) evaluateFrame(
    MateoRoundedConvexDescription begin,
    MateoRoundedConvexDescription end,
    double progress,
    Rect rect,
  ) {
    prepare(begin, end);
    if (!progress.isFinite) throw ArgumentError.value(progress, 'progress');
    if (progress != 0 && progress != 1) {
      return _native.frameWithPath(progress, rect);
    }
    final points = _pair.evaluate(progress);
    final native = _pathBuilder.prepare(points, rect);
    final path = Path()
      ..addPolygon([
        for (var i = 0; i < native.length; i += 2) Offset(native[i], native[i + 1]),
      ], true);
    return (points: points, path: path);
  }

  ({Path path, Float64List Function() capture, Path Function(Rect)? transform, double pathTolerance}) evaluatePathFrame(
    MateoRoundedConvexDescription begin,
    MateoRoundedConvexDescription end,
    double progress,
    Rect rect,
  ) {
    prepare(begin, end);
    if (!progress.isFinite) throw ArgumentError.value(progress, 'progress');
    if (progress != 0 && progress != 1) {
      final kernel = _native;
      return (
        path: kernel.framePath(progress, rect),
        capture: () => kernel.frame(progress),
        transform: (bounds) => kernel.framePath(progress, bounds),
        pathTolerance: kernel.roundsCorners ? .01 : 0,
      );
    }
    final evaluated = evaluateFrame(begin, end, progress, rect);
    return (
      path: evaluated.path,
      capture: () => evaluated.points,
      transform: null,
      pathTolerance: 0,
    );
  }

  @visibleForTesting
  Float64List evaluatePoints(
    MateoRoundedConvexDescription begin,
    MateoRoundedConvexDescription end,
    double progress,
  ) {
    prepare(begin, end);
    if (!progress.isFinite) {
      throw ArgumentError.value(
        progress,
        'progress',
        'Progress must be finite.',
      );
    }
    return _rawOutline(progress);
  }
}
