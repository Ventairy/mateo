import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_draft/src/foundation/mateo_rounded_convex_interpolation/mateo_rounded_convex_evaluator.dart';
import 'package:mateo_mobile_draft/src/foundation/mateo_rounded_convex_interpolation/mateo_rounded_convex_geometry.dart';
import 'package:mateo_mobile_draft/src/foundation/mateo_rounded_convex_interpolation/mateo_rounded_convex_path.dart';

MateoRoundedConvexDescription _description(Map<String, dynamic> row) {
  Float64List values(String key) =>
      Float64List.fromList((row[key] as List<dynamic>).map((v) => (v as num).toDouble()).toList());
  return (
    width: (row['width'] as num).toDouble(),
    height: (row['height'] as num).toDouble(),
    angle: (row['anchorAngle'] as num).toDouble(),
    turns: values('turningGaps'),
    speeds: values('speeds'),
    spacings: values('arcGaps'),
    outline: null,
  );
}

Float64List _supports(Float64List points, {int count = 128, double width = 1, double height = 1, double rotation = 0}) {
  final values = Float64List(count);
  for (var i = 0; i < count; i++) {
    final angle = (i + rotation) * 2 * math.pi / count;
    final x = math.cos(angle) * width;
    final y = math.sin(angle) * height;
    var maximum = double.negativeInfinity;
    for (var j = 0; j < points.length; j += 2) {
      maximum = math.max(maximum, points[j] * x + points[j + 1] * y);
    }
    values[i] = maximum;
  }
  return values;
}

void main() {
  final data = jsonDecode(
    File('../../../design-system/foundation/assets/rounded-convex-interpolation/reference.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  final descriptors = {
    for (final raw in data['endpoints'] as List<dynamic>)
      (raw as Map<String, dynamic>)['id'] as String: _description(raw),
  };
  test('when rendering reference motion, it should preserve native convexity and reversed contours', () {
    final pathBuilder = MateoRoundedConvexPathBuilder();
    final nativeArithmetic = Float32List(6);
    for (final raw in data['transitions'] as List<dynamic>) {
      final p = raw as Map<String, dynamic>;
      final a = descriptors[p['source']]!;
      final b = descriptors[p['destination']]!;
      final forward = MateoRoundedConvexEvaluator(intervals: 512, locations: 256);
      final reverse = MateoRoundedConvexEvaluator(intervals: 512, locations: 256);
      forward.prepare(a, b);
      for (final raw in p['frames'] as List<dynamic>) {
        final f = raw as Map<String, dynamic>;
        final t = (f['progress'] as num).toDouble();
        final w = (f['width'] as num).toDouble();
        final h = (f['height'] as num).toDouble();
        final points = forward.evaluatePoints(a, b, t);
        final values = _supports(points, width: w, height: h);
        final native = pathBuilder.prepare(points, Rect.fromLTWH(-w / 2, -h / 2, w, h));
        final nativeSupports = _supports(Float64List.fromList(native));
        for (var i = 0; i < native.length; i += 2) {
          final next = (i + 2) % native.length;
          final after = (i + 4) % native.length;
          nativeArithmetic[0] = native[next] - native[i];
          nativeArithmetic[1] = native[next + 1] - native[i + 1];
          nativeArithmetic[2] = native[after] - native[next];
          nativeArithmetic[3] = native[after + 1] - native[next + 1];
          nativeArithmetic[4] = nativeArithmetic[0] * nativeArithmetic[3];
          nativeArithmetic[5] = nativeArithmetic[1] * nativeArithmetic[2];
          nativeArithmetic[4] = nativeArithmetic[4] - nativeArithmetic[5];
          expect(
            nativeArithmetic[4],
            greaterThanOrEqualTo(0),
            reason: 'Native convexity ${p['source']} to ${p['destination']} at $t',
          );
        }
        final reversed = _supports(reverse.evaluatePoints(b, a, 1 - t), width: w, height: h);

        for (var i = 0; i < 128; i++) {
          expect(
            nativeSupports[i],
            closeTo(values[i], .001),
            reason: 'Native support ${p['source']} to ${p['destination']} at $t',
          );
          expect(
            values[i],
            closeTo(reversed[i], .00001),
            reason: 'Reversal ${p['source']} to ${p['destination']} at $t direction $i',
          );
        }
      }
    }
  });

  test('when interrupting rounded motion repeatedly, it should retain the visible endpoint and its owned geometry', () {
    final a = descriptors['soft-triangle']!;
    final b = descriptors['soft-hexagon']!;
    var source = a;
    final retained = <({Float64List points, Float64List supports})>[];
    for (var i = 0; i < 12; i++) {
      final end = i.isEven ? b : a;
      final evaluator = MateoRoundedConvexEvaluator(intervals: 512, locations: 256);
      final start = evaluator.evaluatePoints(source, end, 0);
      if (source.outline case final outline?) {
        final previous = Float64List.fromList([
          for (final p in outline.points) ...[p.dx / source.width, p.dy / source.height],
        ]);
        final expected = _supports(previous, width: source.width, height: source.height);
        final actual = _supports(start, width: source.width, height: source.height);
        final near = _supports(evaluator.evaluatePoints(source, end, 1e-7), width: source.width, height: source.height);
        for (var j = 0; j < actual.length; j++) {
          expect(actual[j], closeTo(expected[j], 1e-8));
          // A new curve description uses the same fit budget as input preparation.
          expect(near[j], closeTo(expected[j], math.max(.05, math.max(source.width, source.height) * .002)));
        }
      }
      final points = evaluator.evaluatePoints(source, end, .37);
      retained.add((points: points, supports: _supports(points)));
      final width = mateoRoundedConvexDimension(source.width, end.width, .37);
      final height = mateoRoundedConvexDimension(source.height, end.height, .37);
      final outline = MateoRoundedConvexEndpoint.fromFrame(points, width, height);
      expect(outline.points.length, lessThan(1600));
      source = (
        width: width,
        height: height,
        angle: 0.0,
        turns: Float64List(0),
        speeds: Float64List(0),
        spacings: Float64List(0),
        outline: outline,
      );
    }
    for (final frame in retained) {
      expect(_supports(frame.points), orderedEquals(frame.supports));
    }
  });

  test('when rounded endpoints have tiny or enormous bounds, it should retain finite positive-area outlines', () {
    for (final scale in [1e-28, 1e28]) {
      MateoRoundedConvexDescription scaled(String id) {
        final source = descriptors[id]!;
        return (
          width: source.width * scale,
          height: source.height * scale,
          angle: source.angle,
          turns: .fromList(source.turns),
          speeds: .fromList(source.speeds),
          spacings: .fromList(source.spacings),
          outline: null,
        );
      }

      final a = scaled('soft-triangle');
      final b = scaled('soft-hexagon');
      final evaluator = MateoRoundedConvexEvaluator(intervals: 512, locations: 256);
      for (final t in [-.1, 0.0, .25, .5, .75, 1.0, 1.1]) {
        final points = evaluator.evaluatePoints(a, b, t);
        expect(points.length, greaterThanOrEqualTo(6));
        expect(points.every((v) => v.isFinite), isTrue);
        var area = 0.0;
        for (var i = 0; i < points.length; i += 2) {
          final next = (i + 2) % points.length;
          area += points[i] * points[next + 1] - points[i + 1] * points[next];
        }
        expect(area, greaterThan(0));
      }
    }
  });

  test('when moving between triangle outlines, it should maintain an even outline speed', () {
    for (final (begin, end) in [('triangle', 'hexagon'), ('soft-triangle', 'soft-hexagon'), ('pentagon', 'triangle')]) {
      final a = descriptors[begin]!;
      final b = descriptors[end]!;
      final evaluator = MateoRoundedConvexEvaluator(intervals: 512, locations: 256);
      var previous = _supports(evaluator.evaluatePoints(a, b, 0), count: 96, rotation: .5);
      final distances = <double>[];
      for (var i = 1; i <= 500; i++) {
        final values = _supports(evaluator.evaluatePoints(a, b, i / 500), count: 96, rotation: .5);
        var squared = 0.0;
        for (var k = 0; k < values.length; k++) {
          final delta = values[k] - previous[k];
          squared += delta * delta;
        }
        if (i > 25 && i <= 475) distances.add(math.sqrt(squared / values.length));
        previous = values;
      }
      final mean = distances.reduce((a, b) => a + b) / distances.length;
      expect(distances.reduce(math.min) / mean, greaterThan(.85), reason: '$begin to $end slow interval');
      expect(distances.reduce(math.max) / mean, lessThan(1.2), reason: '$begin to $end fast interval');
    }
  });
}
