import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:mateo_mobile_draft/src/foundation/mateo_rounded_convex_interpolation/mateo_rounded_convex_evaluator.dart';

MateoRoundedConvexDescription clone(
  MateoRoundedConvexDescription d, {
  double? width,
}) => (
  width: width ?? d.width,
  height: d.height,
  angle: d.angle,
  turns: Float64List.fromList(d.turns),
  speeds: Float64List.fromList(d.speeds),
  spacings: Float64List.fromList(d.spacings),
  outline: null,
);

void main() {
  test('when prepared geometry is reused, it should keep returned frames independently owned', () {
    final fixture = jsonDecode(
      File(
        '../../../design-system/foundation/assets/rounded-convex-interpolation/reference.json',
      ).readAsStringSync(),
    ) as Map<String, dynamic>;
    final descriptions = Map.fromEntries(
      (fixture['endpoints'] as List<dynamic>).map((raw) {
        final v = raw as Map<String, dynamic>;
        Float64List array(String key) => Float64List.fromList(
          (v[key] as List).map((n) => (n as num).toDouble()).toList(),
        );
        final MateoRoundedConvexDescription d = (
          width: (v['width'] as num).toDouble(),
          height: (v['height'] as num).toDouble(),
          angle: (v['anchorAngle'] as num).toDouble(),
          turns: array('turningGaps'),
          speeds: array('speeds'),
          spacings: array('arcGaps'),
          outline: null,
        );
        return MapEntry(v['id'] as String, d);
      }),
    );
    final a = descriptions['triangle']!;
    final b = descriptions['hexagon']!;
    MateoRoundedConvexEvaluator.clearPreparedPairs();
    MateoRoundedConvexEvaluator evaluator() => MateoRoundedConvexEvaluator(intervals: 512, locations: 256);
    final first = evaluator()..prepare(a, b);

    final points = first.evaluatePoints(a, b, .37);
    final saved = Float64List.fromList(points);
    final path = first.evaluateFrame(a, b, .37, const Rect.fromLTWH(0, 0, 320, 240)).path;
    final bounds = path.getBounds();
    final repeated = evaluator()..prepare(a, b);

    final copiedBegin = clone(a);
    final copiedEnd = clone(b);
    final copied = evaluator()..prepare(copiedBegin, copiedEnd);
    expect(copied.evaluatePoints(copiedBegin, copiedEnd, .37), orderedEquals(saved));

    for (final t in [.19, .72, 1.13, -.2]) {
      repeated.evaluateFrame(a, b, t, const Rect.fromLTWH(0, 0, 450, 300));
    }
    expect(first.evaluatePoints(a, b, .37), orderedEquals(saved));
    expect(points, orderedEquals(saved));
    expect(path.getBounds(), bounds);
    final reversed = evaluator()..prepare(b, a);

    // Clear cache ownership so equal numeric inputs prepare an independent map.
    MateoRoundedConvexEvaluator.clearPreparedPairs();
    final freshBegin = clone(b);
    final freshEnd = clone(a);
    final freshReverse = evaluator()..prepare(freshBegin, freshEnd);
    double support(Float64List outline, double x, double y) {
      var furthest = double.negativeInfinity;
      for (var i = 0; i < outline.length; i += 2) {
        furthest = math.max(furthest, outline[i] * x + outline[i + 1] * y);
      }
      return furthest;
    }

    for (final t in [-.2, 0.0, 1e-14, .19, .37, .72, 1 - 1e-14, 1.0, 1.13]) {
      final actual = reversed.evaluatePoints(b, a, t);
      final expected = freshReverse.evaluatePoints(freshBegin, freshEnd, t);
      for (var direction = 0; direction < 64; direction++) {
        final angle = 2 * math.pi * direction / 64;
        final x = math.cos(angle);
        final y = math.sin(angle);
        expect(support(actual, x, y), closeTo(support(expected, x, y), 1e-8));
      }
    }
    final reversePoints = reversed.evaluatePoints(b, a, .37);
    // A later path request reuses the native output buffer. Captured points
    // remain owned, and another request evaluates its own progress again.
    final captured = first.evaluatePoints(a, b, .371);
    first.evaluatePathFrame(a, b, -.2, const Rect.fromLTWH(0, 0, 320, 240));
    expect(first.evaluatePoints(a, b, .371), orderedEquals(captured));

    final played = first.evaluatePathFrame(a, b, .431, const Rect.fromLTWH(0, 0, 320, 240));
    final playedBounds = played.path.getBounds();
    // Interleaved path and coordinate requests retain their own output.
    first.evaluatePoints(a, b, .19);
    final repeatedPlayback = first.evaluatePathFrame(a, b, .431, const Rect.fromLTWH(0, 0, 320, 240));
    expect(repeatedPlayback.path.getBounds(), playedBounds);
    expect(first.evaluatePoints(a, b, .371), orderedEquals(captured));
    // Distinct immutable numeric values miss both cache paths. Keep them
    // reachable during churn so eviction exercises the byte budget.
    final inputs =
        <
          (
            MateoRoundedConvexDescription,
            MateoRoundedConvexDescription,
          )
        >[];
    for (var i = 0; i < 40; i++) {
      final aa = clone(a, width: a.width + i * 1e-6);
      final bb = clone(b);
      inputs.add((aa, bb));
      evaluator().evaluateFrame(
        aa,
        bb,
        .37,
        const Rect.fromLTWH(0, 0, 320, 240),
      );
      expect(
        MateoRoundedConvexEvaluator.preparedPairCacheBytes,
        lessThanOrEqualTo(2 * 1024 * 1024),
      );
    }

    // Eviction releases cache ownership only. Existing evaluators retain the
    // exact native data they are using until they themselves become garbage.
    expect(first.evaluatePoints(a, b, .37), orderedEquals(saved));
    expect(repeated.evaluatePoints(a, b, .37), orderedEquals(saved));
    expect(reversed.evaluatePoints(b, a, .37), orderedEquals(reversePoints));
    MateoRoundedConvexEvaluator.clearPreparedPairs();
    expect(
      MateoRoundedConvexEvaluator.preparedPairCacheBytes,
      0,
    );
    expect(repeated.evaluatePoints(a, b, .37), orderedEquals(saved));
    expect(inputs.length, 40);
  }, timeout: const Timeout(Duration(minutes: 2)));
}
