import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_draft/mateo_mobile.dart';
import 'package:mateo_mobile_draft/src/foundation/mateo_border_contour.dart';
import 'package:mateo_mobile_draft/src/foundation/mateo_capsule_border/mateo_capsule_border.dart';
import 'package:mateo_mobile_draft/src/foundation/mateo_rounded_convex_interpolation/mateo_rounded_convex_evaluator.dart';
import 'package:mateo_mobile_draft/src/foundation/mateo_rounded_convex_interpolation/mateo_rounded_convex_geometry.dart';
import 'package:mateo_mobile_draft/src/foundation/mateo_rounded_convex_interpolation/mateo_rounded_convex_preparation.dart';
import 'package:mateo_mobile_draft/src/foundation/mateo_rounded_rectangle_border/mateo_rounded_rectangle_border.dart';

part '_rounded_convex_contour_index.dart';

// Allow native coordinate quantization and the endpoint chord approximation
// when comparing independently rendered contours. Numeric fixture checks and
// retained-path ownership assertions have separate, tighter bounds.
const _renderedContourTolerance = .02;

MateoRoundedConvexInterpolation _interpolation({
  ({ShapeBorder shape, Size size}) begin = (shape: const MateoCapsuleBorder(), size: const Size(144, 48)),
  ({ShapeBorder shape, Size size}) end = (
    shape: const MateoRoundedRectangleBorder(radius: 24),
    size: const Size(240, 280),
  ),
}) => MateoRoundedConvexInterpolation(begin: begin, end: end);

MateoRoundedConvexDescription _description(Map<String, dynamic> fixture) {
  Float64List values(String key) =>
      Float64List.fromList((fixture[key] as List<dynamic>).map((v) => (v as num).toDouble()).toList());
  return (
    width: (fixture['width'] as num).toDouble(),
    height: (fixture['height'] as num).toDouble(),
    outline: null,
    angle: (fixture['anchorAngle'] as num).toDouble(),
    turns: values('turningGaps'),
    speeds: values('speeds'),
    spacings: values('arcGaps'),
  );
}

double _radialDistance(Path path, Offset center, Offset direction, double limit) {
  var inside = 0.0;
  var outside = limit;
  for (var i = 0; i < 24; i++) {
    final middle = (inside + outside) / 2;
    if (path.contains(center + direction * middle)) {
      inside = middle;
    } else {
      outside = middle;
    }
  }
  return (inside + outside) / 2;
}

double _contourDifference(Path a, Path b, Size size) {
  final center = Offset(size.width / 2, size.height / 2);
  var maximum = 0.0;
  for (var i = 0; i < 256; i++) {
    final angle = 2 * math.pi * i / 256;
    final direction = Offset(math.cos(angle), math.sin(angle));
    maximum = math.max(
      maximum,
      (_radialDistance(a, center, direction, size.longestSide) -
              _radialDistance(b, center, direction, size.longestSide))
          .abs(),
    );
  }
  return maximum;
}

void _expectPreparedFit(ShapeBorder border, Size size, List<MateoBorderCubic> original) {
  final description = prepareMateoRoundedConvexBorder(border, size, null);
  final evaluator = MateoRoundedConvexEvaluator(
    intervals: mateoRoundedConvexIntervals,
    locations: mateoRoundedConvexLocations,
  );
  final points = evaluator.evaluatePoints(description, description, 0);
  final fitted = [
    for (var i = 0; i < points.length; i += 2)
      Offset((points[i] + .5) * size.width, (points[i + 1] + .5) * size.height),
  ];
  final source = mateoBorderContour(original, size.longestSide * 1e-6);
  // The accepted 256-location fit allows 0.2% of the longer side, with a 0.05 px floor.
  final tolerance = math.max(.05, size.longestSide * .002);
  final sourceIndex = _MateoRoundedConvexContourIndex(source, 0, source.length);
  final fittedIndex = _MateoRoundedConvexContourIndex(fitted, 0, fitted.length);
  expect(
    fitted.every((p) => sourceIndex.isNear(p, tolerance * tolerance)),
    isTrue,
    reason: 'Fit exceeds source at $size',
  );
  expect(
    source.every((p) => fittedIndex.isNear(p, tolerance * tolerance)),
    isTrue,
    reason: 'Source exceeds fit at $size',
  );
}

({Size size, ShapeBorder border, List<MateoBorderCubic> cubics}) _fixtureOutline(Map<String, dynamic> fixture) {
  final size = Size((fixture['width'] as num).toDouble(), (fixture['height'] as num).toDouble());
  final List<dynamic> curves;
  if (fixture['points'] case final List<dynamic> points) {
    curves = [
      for (var i = 0; i < points.length; i++)
        [points[i], points[i], points[(i + 1) % points.length], points[(i + 1) % points.length]],
    ];
  } else {
    curves = fixture['cubics'] as List<dynamic>;
  }
  final cubics = curves.map((rawCurve) {
    final c = rawCurve as List<dynamic>;
    Offset point(int i) {
      final p = c[i] as List<dynamic>;
      return Offset(((p[0] as num).toDouble() + .5) * size.width, ((p[1] as num).toDouble() + .5) * size.height);
    }

    return (start: point(0), control1: point(1), control2: point(2), end: point(3));
  }).toList();
  final border = _PathBorder((rect, _) {
    Offset fit(Offset p) =>
        Offset(rect.left + p.dx * rect.width / size.width, rect.top + p.dy * rect.height / size.height);
    final start = fit(cubics.first.start);
    final path = Path()..moveTo(start.dx, start.dy);
    for (final c in cubics) {
      final a = fit(c.control1);
      final b = fit(c.control2);
      final end = fit(c.end);
      path.cubicTo(a.dx, a.dy, b.dx, b.dy, end.dx, end.dy);
    }
    return path..close();
  });
  return (size: size, border: border, cubics: cubics);
}

void main() {
  final fixture = jsonDecode(
    File('../../../design-system/foundation/assets/rounded-convex-interpolation/reference.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  final endpoints = <String, Map<String, dynamic>>{
    for (final raw in fixture['endpoints'] as List<dynamic>) (raw as Map<String, dynamic>)['id'] as String: raw,
  };
  final sources = jsonDecode(
    File('../../../design-system/foundation/assets/rounded-convex-interpolation/source-outlines.json')
        .readAsStringSync(),
  ) as Map<String, dynamic>;
  final sourceOutlines = {
    for (final raw in sources['shapes'] as List<dynamic>)
      (raw as Map<String, dynamic>)['id'] as String: _fixtureOutline(raw),
  };
  test('retained native frames preserve paths across reuse and endpoint capture', () {
    final a = sourceOutlines['triangle']!;
    final b = sourceOutlines['hexagon']!;
    final begin = (shape: a.border, size: a.size);
    final end = (shape: b.border, size: b.size);
    final interpolation = MateoRoundedConvexInterpolation(
      begin: begin,
      end: end,
    );
    final frame = interpolation.lerp(.37);
    final paired = Offset.zero & frame.size;
    final saved = frame.border.getOuterPath(paired);
    final shifted = paired.shift(const Offset(19, 23));
    const resized = Rect.fromLTWH(31, 27, 432, 365);
    frame.border.getOuterPath(shifted);
    final scaled = frame.border.getOuterPath(resized);

    final peer = MateoRoundedConvexInterpolation(begin: begin, end: end);
    for (final t in [.23, .77, 1.12, -.21]) {
      interpolation.lerp(t).border.getOuterPath(const Rect.fromLTWH(0, 0, 314, 217));
      peer.lerp(t);
    }
    MateoRoundedConvexEvaluator.clearPreparedPairs();
    final retained = frame.border.getOuterPath(paired);
    expect(_contourDifference(saved, retained, frame.size), 0);
    expect(frame.border.getOuterPath(resized).getBounds(), scaled.getBounds());

    final redirected = MateoRoundedConvexInterpolation(
      begin: (shape: frame.border, size: frame.size),
      end: begin,
    );

    // Preparing the same retained border again uses its owned exact capture.
    MateoRoundedConvexInterpolation(
      begin: (shape: frame.border, size: frame.size),
      end: end,
    );

    final start = redirected.lerp(0);
    expect(
      _contourDifference(saved, start.border.getOuterPath(paired), frame.size),
      lessThan(.02),
    );
    final returned = frame.border.getOuterPath(paired)..reset();
    expect(returned.getBounds().isEmpty, isTrue);
    expect(
      _contourDifference(saved, frame.border.getOuterPath(paired), frame.size),
      0,
    );
  });

  test('when evaluating the reference frames, it should reproduce their polygon contours', () {
    final evaluator = MateoRoundedConvexEvaluator(
      intervals: fixture['inputIntervals'] as int,
      locations: fixture['endpointFitCubics'] as int,
    );
    for (final raw in fixture['transitions'] as List<dynamic>) {
      final transition = raw as Map<String, dynamic>;
      final begin = _description(endpoints[transition['source']]!);
      final end = _description(endpoints[transition['destination']]!);
      for (final rawFrame in transition['frames'] as List<dynamic>) {
        final frame = rawFrame as Map<String, dynamic>;
        final actual = evaluator.evaluatePoints(begin, end, (frame['progress'] as num).toDouble());
        final expected = (frame['points'] as List<dynamic>).expand((p) => p as List<dynamic>).cast<num>().toList();
        // Near-coincident edge directions can sort differently across runtimes.
        // Compare support distances, which describe the same convex contour.
        for (var i = 0; i < 128; i++) {
          final angle = i * 2 * math.pi / 128;
          final dx = math.cos(angle);
          final dy = math.sin(angle);
          double support(List<num> p) {
            var result = double.negativeInfinity;
            for (var j = 0; j < p.length; j += 2) {
              result = math.max(result, p[j] * dx + p[j + 1] * dy);
            }
            return result;
          }

          expect(
            support(actual),
            closeTo(support(expected), 2e-10),
            reason: '${transition['source']} → ${transition['destination']} at ${frame['progress']}',
          );
        }
      }
    }
  });
  test('when repeatedly retargeted, frame preparation should retain a compact convex silhouette', () {
    final a = prepareMateoRoundedConvexBorder(const MateoCapsuleBorder(), const Size(440, 48), null);
    final b = prepareMateoRoundedConvexBorder(
      const MateoRoundedRectangleBorder(radius: 24),
      const Size(320, 720),
      null,
    );
    final evaluator = MateoRoundedConvexEvaluator(
      intervals: mateoRoundedConvexIntervals,
      locations: mateoRoundedConvexLocations,
    );
    var source = a;
    for (var i = 0; i < 120; i++) {
      final end = i.isEven ? b : a;
      final points = evaluator.evaluatePoints(source, end, .37);
      final width = mateoRoundedConvexDimension(source.width, end.width, .37);
      final height = mateoRoundedConvexDimension(source.height, end.height, .37);
      final endpoint = MateoRoundedConvexEndpoint.fromFrame(points, width, height);
      expect(endpoint.points.length, lessThan(1600));
      for (var j = 0; j < 128; j++) {
        final angle = j * 2 * math.pi / 128;
        final dx = math.cos(angle);
        final dy = math.sin(angle);
        var original = double.negativeInfinity;
        for (var k = 0; k < points.length; k += 2) {
          original = math.max(original, points[k] * width * dx + points[k + 1] * height * dy);
        }
        final prepared = endpoint.points.map((p) => p.dx * dx + p.dy * dy).reduce(math.max);
        expect(prepared, closeTo(original, .0030001));
      }
      source = (
        width: width,
        height: height,
        angle: 0.0,
        turns: Float64List(0),
        speeds: Float64List(0),
        spacings: Float64List(0),
        outline: endpoint,
      );
    }
  });

  test('when dimensions rebound, it should match the approved gentle excursion in both directions', () {
    final returning = _interpolation(
      begin: (shape: const MateoCapsuleBorder(), size: const Size(240, 280)),
      end: (shape: const MateoRoundedRectangleBorder(radius: 24), size: const Size(144, 48)),
    );
    final frame = returning.lerp(1.1);
    expect(frame.size.width, closeTo(134.926774, 1e-6));
    expect(frame.size.height, closeTo(39.377971, 1e-6));
    expect(mateoRoundedConvexDimension(72, 144, 1.1), closeTo(150.985026, 1e-6));
    expect(mateoRoundedConvexDimension(72, 48, 1.1), closeTo(45.676871, 1e-6));
    for (final (a, b) in [(48.0, 280.0), (280.0, 48.0), (72.0, 144.0), (72.0, 72.0)]) {
      for (var i = 0; i <= 200; i++) {
        final t = -.5 + i / 100;
        final value = mateoRoundedConvexDimension(a, b, t);
        expect(value, closeTo(mateoRoundedConvexDimension(b, a, 1 - t), 1e-10));
        if (t >= 0 && t <= 1) {
          expect(value, (1 - t) * a + t * b);
        } else {
          final endpoint = t < 0 ? a : b;
          expect(value, inInclusiveRange(endpoint / 1.24, endpoint * 1.2));
        }
      }
      for (final endpoint in [0.0, 1.0]) {
        // A cubic correction preserves the incoming slope and curvature.
        double correction(double h) =>
            (mateoRoundedConvexDimension(a, b, endpoint + h) - ((1 - endpoint - h) * a + (endpoint + h) * b)).abs();
        final h = endpoint == 0 ? -1e-4 : 1e-4;
        expect(correction(h / 2), lessThanOrEqualTo(correction(h) * .14 + 1e-12));
      }
    }
    expect(mateoRoundedConvexDimension(48, 280, 1e300), closeTo(336, 1e-10));
    expect(mateoRoundedConvexDimension(280, 48, 1e300), closeTo(48 / 1.24, 1e-10));
  });
  test('when progress crosses the mapping joins, it should preserve scalar continuation and symmetry', () {
    expect(mateoRoundedConvexPositive(144, 240, .5), 192);
    expect(mateoRoundedConvexPositive(48, 280, .5), 164);
    expect(mateoRoundedConvexPositive(144, 48, 1.1), closeTo(38.70967741935, 1e-8));
    for (final t in [-100.0, -.5, -.1, -1e-8, 0.0, 1e-8, .25 - 1e-8, .25, .5, .75, 1.0, 1.1, 1.5, 100.0]) {
      expect(mateoRoundedConvexOutlineProgress(t), closeTo(1 - mateoRoundedConvexOutlineProgress(1 - t), 1e-14));
      expect(mateoRoundedConvexPositive(144, 48, t), greaterThan(0));
    }
  });
  for (final (shape, size) in <(ShapeBorder, Size)>[
    (const MateoCapsuleBorder(), const Size(48, 48)),
    (const MateoCapsuleBorder(), const Size(55.2, 48)),
    (const MateoCapsuleBorder(), const Size(64.8, 48)),
    (const MateoCapsuleBorder(), const Size(76.8, 48)),
    (const MateoCapsuleBorder(), const Size(144, 48)),
    (const MateoCapsuleBorder(), const Size(48, 240)),
    (const MateoRoundedRectangleBorder(radius: 24), const Size(240, 280)),
    (const MateoRoundedRectangleBorder(radius: 2), const Size(360, 180)),
    (const MateoRoundedRectangleBorder(radius: 999), const Size(96, 96)),
  ]) {
    test('when preparing $shape at $size, it should preserve the native endpoint contour', () {
      final interpolation = _interpolation(begin: (shape: shape, size: size));
      final original = shape.getOuterPath(Offset.zero & size);
      final frame = interpolation.lerp(0);
      final error = _contourDifference(original, frame.border.getOuterPath(Offset.zero & size), size);
      expect(error, lessThan(math.max(.05, size.longestSide * .002)), reason: 'Native endpoint error: $error');
      _expectPreparedFit(shape, size, switch (shape) {
        MateoCapsuleBorder() => mateoCapsuleCubics(size),
        MateoRoundedRectangleBorder(:final radius) => mateoRoundedRectangleCubics(size, radius),
        _ => throw StateError('Unexpected native fixture'),
      });
    });
  }
  test('when evaluating retained frames and reversing, it should keep stable partner-independent geometry', () {
    final forward = _interpolation();
    final reverse = _interpolation(
      begin: forward.end,
      end: forward.begin,
    );
    final retained = forward.lerp(.37);
    final before = retained.border.getOuterPath(Offset.zero & retained.size);
    for (final t in [-.5, -.1, 0.0, .2, .5, .8, 1.0, 1.1, 1.5]) {
      final a = forward.lerp(t);
      final b = reverse.lerp(1 - t);
      expect(a.size.width, closeTo(b.size.width, 1e-10));
      expect(a.size.height, closeTo(b.size.height, 1e-10));
      expect(
        _contourDifference(
          a.border.getOuterPath(Offset.zero & a.size),
          b.border.getOuterPath(Offset.zero & a.size),
          a.size,
        ),
        lessThan(_renderedContourTolerance),
      );
    }
    expect(_contourDifference(before, retained.border.getOuterPath(Offset.zero & retained.size), retained.size), 0);
    final other = _interpolation(end: (shape: const MateoCapsuleBorder(), size: const Size(300, 90)));
    final rect = Offset.zero & forward.begin.size;
    expect(
      _contourDifference(
        forward.lerp(0).border.getOuterPath(rect),
        other.lerp(0).border.getOuterPath(rect),
        forward.begin.size,
      ),
      0,
    );
  });
  test('when progress approaches either endpoint, it should converge without a border swap', () {
    final interpolation = _interpolation();
    for (final endpoint in [0.0, 1.0]) {
      final resting = interpolation.lerp(endpoint);
      final rect = Offset.zero & resting.size;
      for (final delta in [-1e-7, 1e-7]) {
        final nearby = interpolation.lerp(endpoint + delta);
        expect(
          _contourDifference(resting.border.getOuterPath(rect), nearby.border.getOuterPath(rect), resting.size),
          lessThan(_renderedContourTolerance),
        );
      }
    }
  });
  test('when a custom border wraps a native outline, it should match direct preparation', () {
    const native = MateoRoundedRectangleBorder(radius: 24);
    const size = Size(240, 280);
    final direct = _interpolation(begin: (shape: native, size: size));
    final custom = _interpolation(begin: (shape: _PathBorder((rect, _) => native.getOuterPath(rect)), size: size));
    for (final t in [0.0, .25, .5, .75, 1.0]) {
      final a = direct.lerp(t);
      final b = custom.lerp(t);
      expect(
        _contourDifference(
          a.border.getOuterPath(Offset.zero & a.size),
          b.border.getOuterPath(Offset.zero & b.size),
          a.size,
        ),
        lessThan(.05),
      );
    }
  });
  test('when interpolating every reference pair through overshoot, it should keep finite closed convex polygons', () {
    final values = endpoints.values.toList();
    final evaluator = MateoRoundedConvexEvaluator(
      intervals: fixture['inputIntervals'] as int,
      locations: fixture['endpointFitCubics'] as int,
    );
    for (var a = 0; a < values.length; a++) {
      for (var b = a + 1; b < values.length; b++) {
        final begin = _description(values[a]);
        final end = _description(values[b]);
        for (final t in [
          -.5,
          -.1,
          -1e-7,
          0.0,
          1e-7,
          .25 - 1e-7,
          .25,
          .25 + 1e-7,
          .5,
          .75 - 1e-7,
          .75,
          .75 + 1e-7,
          1 - 1e-7,
          1.0,
          1 + 1e-7,
          1.1,
          1.5,
        ]) {
          final width = mateoRoundedConvexDimension(
            (values[a]['width'] as num).toDouble(),
            (values[b]['width'] as num).toDouble(),
            t,
          );
          final height = mateoRoundedConvexDimension(
            (values[a]['height'] as num).toDouble(),
            (values[b]['height'] as num).toDouble(),
            t,
          );
          final points = evaluator.evaluatePoints(begin, end, t);
          expect(points.every((v) => v.isFinite), isTrue);
          expect(width, greaterThan(0));
          expect(height, greaterThan(0));
          final vertices = <Offset>[];
          for (var i = 0; i < points.length; i += 2) {
            final p = Offset(points[i], points[i + 1]);
            if (vertices.isEmpty || (p - vertices.last).distance > 1e-12) vertices.add(p);
          }
          if ((vertices.first - vertices.last).distance < 1e-12) vertices.removeLast();
          var area = 0.0;
          for (var i = 0; i < vertices.length; i++) {
            final p = vertices[i];
            final next = vertices[(i + 1) % vertices.length];
            final after = vertices[(i + 2) % vertices.length];
            final a = next - p;
            final b = after - next;
            expect(a.dx * b.dy - a.dy * b.dx, greaterThan(-1e-12));
            area += p.dx * next.dy - p.dy * next.dx;
          }
          expect(area, greaterThan(0));
          for (final coordinate in [vertices.map((p) => p.dx), vertices.map((p) => p.dy)]) {
            expect(coordinate.reduce(math.min), closeTo(-.5, 1e-12));
            expect(coordinate.reduce(math.max), closeTo(.5, 1e-12));
          }
        }
      }
    }
  });

  test('when preparing all custom reference outlines, it should preserve their endpoints and accept overshoot', () {
    for (final entry in sourceOutlines.entries) {
      final (:size, :border, :cubics) = entry.value;
      late final MateoRoundedConvexInterpolation interpolation;
      expect(
        () => interpolation = _interpolation(begin: (shape: border, size: size)),
        returnsNormally,
        reason: entry.key,
      );
      _expectPreparedFit(border, size, cubics);
      for (final t in [-.5, 0.0, .25, .5, .75, 1.0, 1.5]) {
        final frame = interpolation.lerp(t);
        final path = frame.border.getOuterPath(Offset.zero & frame.size);
        expect(path.getBounds().isFinite, isTrue, reason: '${entry.key} at $t');
        expect(path.computeMetrics().length, 1);
        expect(path.computeMetrics().single.isClosed, isTrue);
      }
    }
  });

  test('when preparing finished inputs, it should follow the portable reference motion', () {
    for (final raw in fixture['transitions'] as List<dynamic>) {
      final transition = raw as Map<String, dynamic>;
      final begin = sourceOutlines[transition['source']]!;
      final end = sourceOutlines[transition['destination']]!;
      final interpolation = _interpolation(
        begin: (shape: begin.border, size: begin.size),
        end: (shape: end.border, size: end.size),
      );
      for (final rawFrame in transition['frames'] as List<dynamic>) {
        final frame = rawFrame as Map<String, dynamic>;
        final expected = _fixtureOutline(frame);
        final actual = interpolation.lerp((frame['progress'] as num).toDouble());
        final bounds = Offset.zero & actual.size;
        expect(actual.size.width, closeTo(expected.size.width, 1e-10));
        expect(actual.size.height, closeTo(expected.size.height, 1e-10));
        // The foundation measures nearest outline distance, not radial distance
        // from the center, which overstates differences near pointed corners.
        final contours = [
          for (final path in [expected.border.getOuterPath(bounds), actual.border.getOuterPath(bounds)])
            [
              for (final metric in path.computeMetrics())
                for (var i = 0; i < (metric.length / .1).ceil(); i++)
                  metric.getTangentForOffset(metric.length * i / (metric.length / .1).ceil())!.position,
            ],
        ];
        final indexes = [for (final contour in contours) _MateoRoundedConvexContourIndex(contour, 0, contour.length)];
        final tolerance = math.max(.5, actual.size.longestSide * .002);
        for (var i = 0; i < contours.length; i++) {
          expect(
            contours[i].every((point) => indexes[1 - i].isNear(point, tolerance * tolerance)),
            isTrue,
            reason: '${transition['source']} → ${transition['destination']} at ${frame['progress']}',
          );
        }
      }
    }
  });

  test('when sharp or mixed convex outlines are supplied, it should accept them with positive prepared values', () {
    expect(mateoRoundedConvexPreparedMinimum, fixture['preparedPositiveMinimum']);
    final borders = <ShapeBorder>[
      const MateoRoundedRectangleBorder(radius: 0),
      _PathBorder((rect, _) => Path()..addRect(rect)),
      _PathBorder((rect, _) => Path()..addPolygon([rect.topCenter, rect.bottomRight, rect.bottomLeft], true)),
      _PathBorder(
        (rect, _) => Path()
          ..moveTo(rect.left, rect.bottom)
          ..lineTo(rect.left, rect.center.dy)
          ..cubicTo(rect.left, rect.top, rect.center.dx, rect.top, rect.center.dx, rect.top)
          ..cubicTo(rect.right, rect.top, rect.right, rect.center.dy, rect.right, rect.center.dy)
          ..lineTo(rect.right, rect.bottom)
          ..close(),
      ),
    ];
    for (final border in borders) {
      const size = Size(240, 180);
      final description = prepareMateoRoundedConvexBorder(border, size, null);
      expect(description.speeds.every((v) => v >= mateoRoundedConvexPreparedMinimum), isTrue);
      expect(description.spacings.every((v) => v >= mateoRoundedConvexPreparedMinimum), isTrue);
      expect(description.speeds, contains(mateoRoundedConvexPreparedMinimum));
      final interpolation = _interpolation(begin: (shape: border, size: size));
      for (final t in [-.5, -.1, -1e-7, 0.0, 1e-7, .5, 1 - 1e-7, 1.0, 1 + 1e-7, 1.1, 1.5]) {
        final frame = interpolation.lerp(t);
        final path = frame.border.getOuterPath(Offset.zero & frame.size);
        expect(frame.size.shortestSide, greaterThan(0));
        expect(path.getBounds().isFinite, isTrue);
        expect(path.computeMetrics().single.isClosed, isTrue);
      }
    }
  });

  test('when retargeting from a returned frame, it should preserve the visible starting outline', () {
    final visible = _interpolation().lerp(.37);
    final next = _interpolation(begin: (shape: visible.border, size: visible.size));
    final bounds = Offset.zero & visible.size;
    expect(
      _contourDifference(visible.border.getOuterPath(bounds), next.lerp(0).border.getOuterPath(bounds), visible.size),
      lessThan(math.max(.05, visible.size.longestSide * .0007)),
    );
  });

  test('when a caller mutates a returned path, it should preserve the frame at every requested bounds', () {
    final interpolation = _interpolation();
    final frame = interpolation.lerp(.37);
    final bounds = Offset.zero & frame.size;
    final original = frame.border.getOuterPath(bounds);
    frame.border.getOuterPath(bounds).reset();
    final secondCopy = interpolation.lerp(.37).border.getOuterPath(bounds);
    expect(_contourDifference(original, secondCopy, frame.size), 0);
    final otherBounds = Rect.fromLTWH(17, 29, frame.size.height, frame.size.width);
    frame.border.getOuterPath(otherBounds).reset();
    expect(_contourDifference(original, frame.border.getOuterPath(bounds), frame.size), 0);
    original.reset();
    expect(_contourDifference(secondCopy, frame.border.getOuterPath(bounds), frame.size), 0);
  });

  test('when a retained border is painted at a vastly different size, it should keep finite geometry', () {
    for (final (sourceScale, targetScale) in [(1e-30, 1e30), (1e30, 1e-30)]) {
      final source = Size(sourceScale, sourceScale * 2);
      final target = Size(targetScale, targetScale * 2);
      final frame = _interpolation(
        begin: (shape: const MateoCapsuleBorder(), size: source),
        end: (shape: const MateoCapsuleBorder(), size: source),
      ).lerp(.37);
      final path = frame.border.getOuterPath(Offset.zero & target);
      final bounds = path.getBounds();
      expect(bounds.isFinite, isTrue);
      expect(bounds.isEmpty, isFalse);
      expect(bounds.width / target.width, closeTo(1, .001));
      expect(bounds.height / target.height, closeTo(1, .001));
      path.reset();
      expect(frame.border.getOuterPath(Offset.zero & target).getBounds(), bounds);
    }
  });

  test('when prepared endpoints change size, direction, or outline, it should use their current geometry', () {
    Path outline(Rect rect, TextDirection? direction) => Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          rect,
          topLeft: Radius.circular(direction == .rtl ? 36 : 8),
          bottomRight: const Radius.circular(20),
        ),
      );
    final border = _PathBorder(outline);
    for (final size in [const Size(144, 96), const Size(280, 120), const Size(144, 96)]) {
      for (final direction in [TextDirection.ltr, TextDirection.rtl, TextDirection.ltr]) {
        final actual = MateoRoundedConvexInterpolation(
          begin: (shape: border, size: size),
          end: (shape: border, size: size),
          textDirection: direction,
        ).lerp(.4);
        final freshBorder = _PathBorder(outline);
        final expected = MateoRoundedConvexInterpolation(
          begin: (shape: freshBorder, size: size),
          end: (shape: freshBorder, size: size),
          textDirection: direction,
        ).lerp(.4);
        expect(
          _contourDifference(
            actual.border.getOuterPath(Offset.zero & size),
            expected.border.getOuterPath(Offset.zero & size),
            size,
          ),
          0,
        );
      }
    }
    const size = Size(144, 96);
    final updated = _PathBorder((rect, _) => Path()..addOval(rect));
    final frame = _interpolation(begin: (shape: updated, size: size), end: (shape: updated, size: size)).lerp(0);
    expect(
      _contourDifference(frame.border.getOuterPath(Offset.zero & size), Path()..addOval(Offset.zero & size), size),
      lessThan(.05),
    );
  });

  test(
    'when an older retained frame is retargeted, it should prepare that frame independently of later evaluations',
    () {
      final interpolation = _interpolation();
      final retained = interpolation.lerp(.37);
      final immediate = _interpolation(begin: (shape: retained.border, size: retained.size));
      final expected = immediate.lerp(.4);
      [-.5, .13, .9, 1.5].forEach(interpolation.lerp);
      final resized = Size(retained.size.width * 2, retained.size.height * 2);
      _interpolation(begin: (shape: retained.border, size: resized)).lerp(.6);
      final delayed = _interpolation(begin: (shape: retained.border, size: retained.size));
      final actual = delayed.lerp(.4);
      expect(actual.size, expected.size);
      expect(
        _contourDifference(
          expected.border.getOuterPath(Offset.zero & expected.size),
          actual.border.getOuterPath(Offset.zero & actual.size),
          actual.size,
        ),
        0,
      );
    },
  );

  test('when an endpoint is unchanged or uniformly scaled, it should preserve its geometry', () {
    const border = MateoRoundedRectangleBorder(radius: 24);
    const size = Size(240, 280);
    final identical = _interpolation(begin: (shape: border, size: size), end: (shape: border, size: size));
    final original = identical.lerp(0).border.getOuterPath(Offset.zero & size);
    for (final t in [-.5, 0.0, .5, 1.0, 1.5]) {
      expect(
        _contourDifference(original, identical.lerp(t).border.getOuterPath(Offset.zero & size), size),
        lessThan(.0001),
      );
    }
    final normal = _interpolation();
    final scaled = _interpolation(
      begin: (shape: const MateoCapsuleBorder(), size: const Size(288, 96)),
      end: (shape: const MateoRoundedRectangleBorder(radius: 48), size: const Size(480, 560)),
    );
    for (final t in [0.0, .3, 1.0, 1.1]) {
      final a = normal.lerp(t);
      final b = scaled.lerp(t);
      expect(b.size, a.size * 2);
      expect(
        _contourDifference(
          a.border.getOuterPath(Offset.zero & a.size),
          b.border.getOuterPath(Offset.zero & a.size),
          a.size,
        ),
        lessThan(_renderedContourTolerance),
      );
    }
  });

  test('when inputs are invalid, it should reject them before rendering', () {
    final retainedBorder = _interpolation().lerp(.37).border;
    for (final size in [Size.zero, const Size(-1, 20), const Size(double.nan, 20), const Size(20, double.infinity)]) {
      expect(() => _interpolation(begin: (shape: const MateoCapsuleBorder(), size: size)), throwsArgumentError);
      expect(() => _interpolation(begin: (shape: retainedBorder, size: size)), throwsArgumentError);
    }
    final interpolation = _interpolation();
    for (final t in [double.nan, double.infinity, double.negativeInfinity, 1e308]) {
      expect(() => interpolation.lerp(t), throwsArgumentError);
    }
    for (final build in <Path Function(Rect, TextDirection?)>[
      (rect, _) => Path()..addRect(rect.deflate(1)),
      (rect, _) => Path()
        ..addRect(rect)
        ..addOval(rect.deflate(10)),
      (rect, _) => Path()
        ..moveTo(0, 0)
        ..lineTo(rect.width, rect.height),
      (rect, _) =>
          Path()..addPolygon([rect.topLeft, rect.topRight, rect.center, rect.bottomRight, rect.bottomLeft], true),
    ]) {
      expect(() => _interpolation(begin: (shape: _PathBorder(build), size: const Size(144, 48))), throwsArgumentError);
    }
  });
}

final class _PathBorder extends ShapeBorder {
  const _PathBorder(this.buildPath);
  final Path Function(Rect, TextDirection?) buildPath;
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;
  @override
  ShapeBorder scale(double t) => this;
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => buildPath(rect, textDirection);
  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => getOuterPath(rect, textDirection: textDirection);
  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}
}
