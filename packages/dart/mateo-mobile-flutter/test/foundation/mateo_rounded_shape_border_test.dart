import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart' show Matrix4;
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

Offset _point(List<dynamic> p) => Offset((p[0] as num).toDouble(), (p[1] as num).toDouble());

void main() {
  final fixture = jsonDecode(
    File('../../../design-system/foundation/assets/rounded-shape/reference.json').readAsStringSync(),
  ) as Map<String, dynamic>;

  test('when rendering canonical fixtures, it should match independent shoulder and circular arc samples', () {
    for (final raw in fixture['cases'] as List<dynamic>) {
      final data = raw as Map<String, dynamic>;
      final width = (data['width'] as num).toDouble();
      final height = (data['height'] as num).toDouble();
      final requested = (data['requestedRadius'] as num).toDouble();
      final fixtureOrigin = _point(data['origin'] as List<dynamic>);
      if (data['effectiveRadius'] == 0) continue;
      final segments = data['topRightSegments'] as List<dynamic>;
      for (final scale in [1.0, 100.0, .01]) {
        final origin = Offset(width * .026, -height * .014) * scale;
        final rect = origin & Size(width * scale, height * scale);
        final path = MateoRoundedShapeBorder(radius: requested * scale).getOuterPath(rect);
        expect(path.computeMetrics().single.isClosed, isTrue);
        expect(path.getBounds(), rectMoreOrLessEquals(rect, epsilon: rect.longestSide * 1e-6));
        // Path.contains has an absolute native tolerance. Probe in a stable
        // coordinate range while retaining the path created at each scale.
        final normalization = 500 / rect.longestSide;
        final sampled = path.transform((Matrix4.identity()..scaleByDouble(normalization, normalization, 1, 1)).storage);
        for (final rawSample in data['topRightSamples'] as List<dynamic>) {
          final sample = rawSample as Map<String, dynamic>;
          final t = (sample['t'] as num).toDouble();
          if (t == 0 || t == 1) continue;
          final segment = segments[sample['segment'] as int] as Map<String, dynamic>;
          final point = _point(sample['point'] as List<dynamic>) - fixtureOrigin;
          final Offset inward;
          if (segment['kind'] == 'A') {
            final center = _point(segment['center'] as List<dynamic>) - fixtureOrigin;
            inward = (center - point) / (center - point).distance;
          } else {
            final p = (segment['points'] as List<dynamic>).map((p) => _point(p as List<dynamic>)).toList();
            final u = 1 - t;
            final velocity = (p[1] - p[0]) * (3 * u * u) + (p[2] - p[1]) * (6 * u * t) + (p[3] - p[2]) * (3 * t * t);
            if (velocity.distance < 1e-10) continue;
            inward = Offset(-velocity.dy, velocity.dx) / velocity.distance;
          }
          final delta = inward * (math.min(width, height) * 2e-5);
          for (var corner = 0; corner < 4; corner++) {
            Offset transform(Offset p) =>
                origin +
                switch (corner) {
                  0 => p * scale,
                  1 => Offset(p.dx, height - p.dy) * scale,
                  2 => Offset(width - p.dx, height - p.dy) * scale,
                  _ => Offset(width - p.dx, p.dy) * scale,
                };
            final reason = '$width × $height / $requested / scale $scale / corner $corner / $sample';
            expect(sampled.contains(transform(point + delta) * normalization), isTrue, reason: reason);
            expect(sampled.contains(transform(point - delta) * normalization), isFalse, reason: reason);
          }
        }
      }
    }
  });

  test('when rounding reaches its bounds, it should make capsules and oversized requests identical', () {
    for (final size in [const Size(96, 96), const Size(300, 50), const Size(65, 50), const Size(50, 300)]) {
      final rect = const Offset(11, -13) & size;
      final capsule = const MateoRoundedShapeBorder.capsule().getOuterPath(rect);
      for (final radius in [size.shortestSide / 2, 999.0]) {
        final rounded = MateoRoundedShapeBorder(radius: radius).getOuterPath(rect);
        expect(Path.combine(.xor, capsule, rounded).getBounds().isEmpty, isTrue);
      }
    }
    for (final diameter in [.01, 48.0, 500.0, 100000.0]) {
      final rect = Rect.fromLTWH(13, -7, diameter, diameter);
      final circle = Path()..addOval(rect);
      final rounded = MateoRoundedShapeBorder(radius: diameter / 2).getOuterPath(rect);
      expect(Path.combine(.xor, circle, rounded).getBounds().isEmpty, isTrue);
    }
  });

  test('when radius is zero, it should draw an exact rectangle', () {
    const rect = Rect.fromLTWH(13, -7, 180, 120);
    final path = const MateoRoundedShapeBorder(radius: 0).getOuterPath(rect);
    expect(Path.combine(.xor, path, Path()..addRect(rect)).getBounds().isEmpty, isTrue);
  });

  test('when ShapeBorder blends oversized radii, it should fit before blending', () {
    const rect = Rect.fromLTWH(0, 0, 96, 96);
    final actual = ShapeBorder.lerp(
      const MateoRoundedShapeBorder(radius: 999),
      const MateoRoundedShapeBorder(radius: 0),
      .5,
    )!.getOuterPath(rect);
    final expected = const MateoRoundedShapeBorder(radius: 24).getOuterPath(rect);
    expect(Path.combine(.xor, actual, expected).getBounds().isEmpty, isTrue);
  });

  test('when used as a stroke-free border, it should preserve scaling and direction independence', () {
    const border = MateoRoundedShapeBorder(radius: 24);
    const capsule = MateoRoundedShapeBorder.capsule();
    expect(border.scale(2), const MateoRoundedShapeBorder(radius: 48));
    expect(border.scale(-1), const MateoRoundedShapeBorder(radius: 0));
    expect(capsule.scale(2), capsule);
    expect(border.dimensions, EdgeInsets.zero);
    expect(border.hashCode, const MateoRoundedShapeBorder(radius: 24).hashCode);
    expect(const MateoShape.rounded(radius: 24), const MateoShape.rounded(radius: 24));
    expect(const MateoShape.rounded(radius: 24), isNot(const MateoShape.rounded(radius: 32)));
    const rect = Rect.fromLTWH(13, -7, 180, 120);
    expect(
      Path.combine(.xor, border.getInnerPath(rect), border.getOuterPath(rect, textDirection: .rtl)).getBounds().isEmpty,
      isTrue,
    );
  });

  test('when inputs are invalid, it should reject radii and leave empty bounds undrawn', () {
    for (final radius in [-1.0, double.nan, double.infinity]) {
      expect(() => MateoRoundedShapeBorder(radius: radius), throwsAssertionError);
    }
    for (final rect in [
      Rect.zero,
      const Rect.fromLTWH(0, 0, -1, 30),
      const Rect.fromLTWH(0, 0, double.infinity, 30),
      const Rect.fromLTWH(double.nan, 0, 30, 30),
    ]) {
      expect(const MateoRoundedShapeBorder(radius: 24).getOuterPath(rect).computeMetrics(), isEmpty);
      expect(const MateoRoundedShapeBorder.capsule().getOuterPath(rect).computeMetrics(), isEmpty);
    }
  });
}
