import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_draft/mateo_mobile.dart';
import 'package:mateo_mobile_draft/src/foundation/mateo_rounded_convex_interpolation/mateo_rounded_convex_evaluator.dart';
import 'package:mateo_mobile_draft/src/foundation/mateo_rounded_convex_interpolation/mateo_rounded_convex_geometry.dart';

List<double> _pathSamples(Path path) {
  final metric = path.computeMetrics().single;
  return [
    metric.length,
    for (var i = 0; i < 256; i++) ...[
      metric.getTangentForOffset(metric.length * i / 256)!.position.dx,
      metric.getTangentForOffset(metric.length * i / 256)!.position.dy,
    ],
  ];
}

void main() {
  test('when physical endpoints have no charts, it should preserve independently owned frames', () {
    MateoRoundedConvexEvaluator.clearPreparedPairs();
    final fixture = jsonDecode(
      File('../../../design-system/foundation/assets/rounded-convex-interpolation/reference.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final descriptions = {
      for (final raw in fixture['endpoints'] as List<dynamic>) (raw as Map<String, dynamic>)['id'] as String: raw,
    };
    final owners = <Object>[];
    var tested = 0;
    for (final pair in (fixture['transitions'] as List).cast<Map<String, dynamic>>()) {
      MateoRoundedConvexDescription endpoint(String name) {
        final data = descriptions[name]!;
        final width = (data['width'] as num).toDouble();
        final height = (data['height'] as num).toDouble();
        return (
          width: width,
          height: height,
          angle: 0,
          turns: Float64List(0),
          speeds: Float64List(0),
          spacings: Float64List(0),
          outline: MateoRoundedConvexEndpoint.fromCubics(
            Float64List.fromList(
              (data['cubics'] as List<dynamic>)
                  .expand((curve) => curve as List<dynamic>)
                  .expand((point) => point as List<dynamic>)
                  .map((value) => (value as num).toDouble())
                  .toList(),
            ),
            width,
            height,
          ),
        );
      }

      final a = endpoint(pair['source'] as String);
      final b = endpoint(pair['destination'] as String);
      if (MateoRoundedConvexPair(a.outline!, b.outline!).roundsCorners) continue;
      final evaluator = MateoRoundedConvexEvaluator(intervals: 512, locations: 256)..prepare(a, b);
      final repeated = MateoRoundedConvexEvaluator(intervals: 512, locations: 256)..prepare(a, b);
      final copiedA = endpoint(pair['source'] as String);
      final copiedB = endpoint(pair['destination'] as String);
      final copied = MateoRoundedConvexEvaluator(intervals: 512, locations: 256)..prepare(copiedA, copiedB);

      owners.addAll([a, b, copiedA, copiedB, evaluator, repeated, copied]);
      final retained = evaluator.evaluatePathFrame(a, b, .371, const Rect.fromLTWH(0, 0, 320, 240));
      final savedPath = _pathSamples(retained.path);
      expect(retained.pathTolerance, 0);
      for (final progress in [-1e6, -.2, .19, .72, 1.13, 1e6]) {
        evaluator.evaluatePathFrame(a, b, progress, const Rect.fromLTWH(0, 0, 450, 300));
        repeated.evaluatePathFrame(a, b, 1 - progress, const Rect.fromLTWH(0, 0, 240, 320));
        copied.evaluatePathFrame(copiedA, copiedB, progress / 2, const Rect.fromLTWH(0, 0, 320, 240));
      }

      expect(_pathSamples(retained.path), orderedEquals(savedPath));
      final captured = retained.capture();

      expect(evaluator.evaluatePoints(a, b, .371), orderedEquals(captured));
      for (final frame in (pair['frames'] as List).cast<Map<String, dynamic>>()) {
        final points = evaluator.evaluatePoints(a, b, (frame['progress'] as num).toDouble());
        final width = (frame['width'] as num).toDouble();
        final height = (frame['height'] as num).toDouble();
        final expected = (frame['points'] as List<dynamic>).cast<List<dynamic>>();
        for (var i = 0; i < 128; i++) {
          final angle = 2 * math.pi * i / 128;
          final x = math.cos(angle) * width;
          final y = math.sin(angle) * height;
          var maximum = double.negativeInfinity;
          for (var j = 0; j < points.length; j += 2) {
            maximum = math.max(maximum, points[j] * x + points[j + 1] * y);
          }
          final expectedSupport = expected
              .map((point) => (point[0] as num).toDouble() * x + (point[1] as num).toDouble() * y)
              .reduce(math.max);
          expect(maximum, closeTo(expectedSupport, 1e-8), reason: '${pair['source']} to ${pair['destination']}');
        }
      }
      tested++;
    }
    expect(tested, greaterThan(0));
    expect(owners, hasLength(7 * tested));
  });

  test('when a retained physical border becomes an endpoint, it should preserve later resized paths', () {
    final interpolation = MateoRoundedConvexInterpolation(
      begin: (shape: const MateoCapsuleBorder(), size: const Size(144, 48)),
      end: (shape: const MateoRoundedRectangleBorder(radius: 24), size: const Size(240, 280)),
    );
    final repeated = MateoRoundedConvexInterpolation(begin: interpolation.begin, end: interpolation.end);

    final retained = interpolation.lerp(.371);
    const firstBounds = Rect.fromLTWH(3, 7, 483, 519);
    const secondBounds = Rect.fromLTWH(-11, 23, 811, 337);
    final firstPath = retained.border.getOuterPath(firstBounds);
    final firstSamples = _pathSamples(firstPath);
    final secondSamples = _pathSamples(retained.border.getOuterPath(secondBounds));
    final redirect = MateoRoundedConvexInterpolation(
      begin: (shape: retained.border, size: retained.size),
      end: interpolation.end,
    );

    for (final progress in [-.2, .19, .72, 1.13]) {
      interpolation.lerp(progress);
      repeated.lerp(1 - progress);
      redirect.lerp(progress);
    }
    // Alternate bounds so each request replaces the single cached transform.
    expect(_pathSamples(retained.border.getOuterPath(firstBounds)), orderedEquals(firstSamples));
    expect(_pathSamples(retained.border.getOuterPath(secondBounds)), orderedEquals(secondSamples));
    expect(_pathSamples(firstPath), orderedEquals(firstSamples));
  });
}
