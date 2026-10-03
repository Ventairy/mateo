import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  test('when pills exchange orientation, it should rebuild the ordinary shape from three blended values', () {
    const movement = (
      begin: (size: Size(200, 56), radius: 28.0),
      end: (size: Size(56, 200), radius: 28.0),
    );
    for (final (t, size) in [
      (0.0, const Size(200, 56)),
      (.25, const Size(164, 92)),
      (.5, const Size(128, 128)),
      (.75, const Size(92, 164)),
      (1.0, const Size(56, 200)),
    ]) {
      final frame = MateoRoundedShapeBorder.lerp(begin: movement.begin, end: movement.end, progress: t);
      expect(frame.size, size);
      expect(frame.border.radius, 28);
      final rect = Offset.zero & size;
      expect(
        Path.combine(
          .xor,
          frame.border.getOuterPath(rect),
          const MateoRoundedShapeBorder(radius: 28).getOuterPath(rect),
        ).getBounds().isEmpty,
        isTrue,
      );
    }
  });

  test('when requested radii exceed endpoint bounds, it should blend their visible radii', () {
    const movement = (
      begin: (size: Size(96, 96), radius: 999.0),
      end: (size: Size(96, 96), radius: 0.0),
    );
    expect(
      MateoRoundedShapeBorder.lerp(begin: movement.begin, end: movement.end, progress: 0).border.radius,
      48,
    );
    expect(
      MateoRoundedShapeBorder.lerp(begin: movement.begin, end: movement.end, progress: .5).border.radius,
      24,
    );
    expect(MateoRoundedShapeBorder.lerp(begin: movement.begin, end: movement.end, progress: 1).border.radius, 0);
    expect(
      MateoRoundedShapeBorder.lerp(begin: movement.begin, end: movement.end, progress: 1.3).border.radius,
      0,
    );
  });

  test('when progress overshoots, it should extrapolate directly and fit only the radius', () {
    const movement = (
      begin: (size: Size(100, 100), radius: 0.0),
      end: (size: Size(200, 200), radius: 20.0),
    );
    for (final (t, width, radius) in [
      (-.1, 90.0, 0.0),
      (1.1, 210.0, 22.0),
      (1.5, 250.0, 30.0),
      (2.0, 300.0, 40.0),
      (100.0, 10100.0, 2000.0),
    ]) {
      final frame = MateoRoundedShapeBorder.lerp(begin: movement.begin, end: movement.end, progress: t);
      expect(frame.size.width, closeTo(width, 1e-10));
      expect(frame.size.height, closeTo(width, 1e-10));
      expect(frame.border.radius, closeTo(radius, 1e-10));
    }
    final fixedSize = (
      begin: movement.begin,
      end: (size: movement.begin.size, radius: movement.end.radius),
    );
    expect(
      MateoRoundedShapeBorder.lerp(begin: fixedSize.begin, end: fixedSize.end, progress: 100).border.radius,
      50,
    );
  });

  test('when only one dimension changes, it should keep the other values stationary at large finite progress', () {
    const movement = (
      begin: (size: Size(1, 100), radius: 0.0),
      end: (size: Size(2, 100), radius: 0.0),
    );
    expect(MateoRoundedShapeBorder.lerp(begin: movement.begin, end: movement.end, progress: 1e100), (
      size: const Size(1e100, 100),
      border: const MateoRoundedShapeBorder(radius: 0),
    ));
  });

  test('when resolved endpoints are equal, it should remain stationary even for extreme progress', () {
    const movement = (
      begin: (size: Size(96, 96), radius: 48.0),
      end: (size: Size(96, 96), radius: 999.0),
    );
    for (final t in [-1e308, -.5, 0.0, .5, 1.0, 1.5, 1e308]) {
      expect(MateoRoundedShapeBorder.lerp(begin: movement.begin, end: movement.end, progress: t), (
        size: const Size(96, 96),
        border: const MateoRoundedShapeBorder(radius: 48),
      ));
    }
  });

  test('when overshoot changes the available rounding, it should match linear reference values and fit the radius', () {
    // Independently calculated linear values, also covered by the portable reference.
    for (final (a, ar, b, br, t, expected, radius) in [
      (
        const Size(300, 50),
        25.0,
        const Size(96, 96),
        10.0,
        -.1,
        const Size(320.4, 45.4),
        22.7,
      ),
      (
        const Size(300, 50),
        25.0,
        const Size(96, 96),
        10.0,
        1.1,
        const Size(75.6, 100.6),
        8.5,
      ),
      (
        const Size(48, 48),
        24.0,
        const Size(320, 640),
        32.0,
        -.05,
        const Size(34.4, 18.4),
        9.2,
      ),
      (
        const Size(48, 48),
        24.0,
        const Size(320, 640),
        32.0,
        1.1,
        const Size(347.2, 699.2),
        32.8,
      ),
      (
        const Size(96, 96),
        999.0,
        const Size(50, 300),
        0.0,
        -.1,
        const Size(100.6, 75.6),
        37.8,
      ),
      (
        const Size(96, 96),
        999.0,
        const Size(50, 300),
        0.0,
        1.1,
        const Size(45.4, 320.4),
        0.0,
      ),
    ]) {
      final frame = MateoRoundedShapeBorder.lerp(
        begin: (size: a, radius: ar),
        end: (size: b, radius: br),
        progress: t,
      );
      expect(frame.size.width, closeTo(expected.width, 1e-10));
      expect(frame.size.height, closeTo(expected.height, 1e-10));
      expect(frame.border.radius, closeTo(radius, 1e-10));
    }
  });

  test('when reversing or scaling the movement, it should retrace and scale its visible frames', () {
    for (final (a, b) in [
      (const Size(200, 56), const Size(56, 200)),
      (const Size(96, 96), const Size(320, 480)),
      (const Size(360, 640), const Size(48, 48)),
    ]) {
      final begin = (size: a, radius: a.shortestSide / 2);
      final end = (size: b, radius: 24.0);
      final forward = (begin: begin, end: end);
      final reverse = (begin: end, end: begin);
      for (final t in [-2.0, -.1, 0.0, .25, .5, .75, 1.0, 1.1, 3.0]) {
        if (a.width + (b.width - a.width) * t <= 0 || a.height + (b.height - a.height) * t <= 0) {
          expect(
            () => MateoRoundedShapeBorder.lerp(begin: forward.begin, end: forward.end, progress: t),
            throwsArgumentError,
          );
          expect(
            () => MateoRoundedShapeBorder.lerp(begin: reverse.begin, end: reverse.end, progress: 1 - t),
            throwsArgumentError,
          );
          continue;
        }
        final frame = MateoRoundedShapeBorder.lerp(begin: forward.begin, end: forward.end, progress: t);
        final reversed = MateoRoundedShapeBorder.lerp(begin: reverse.begin, end: reverse.end, progress: 1 - t);
        expect(reversed.size.width, closeTo(frame.size.width, 1e-10));
        expect(reversed.size.height, closeTo(frame.size.height, 1e-10));
        expect(reversed.border.radius, closeTo(frame.border.radius!, 1e-10));
        for (final scale in [.001, 1000.0]) {
          final scaled = MateoRoundedShapeBorder.lerp(
            begin: (size: a * scale, radius: begin.radius * scale),
            end: (size: b * scale, radius: end.radius * scale),
            progress: t,
          );
          expect(scaled.size.width / scale, closeTo(frame.size.width, 1e-10));
          expect(scaled.size.height / scale, closeTo(frame.size.height, 1e-10));
          expect(scaled.border.radius! / scale, closeTo(frame.border.radius!, 1e-10));
        }
      }
    }
  });

  test('when a movement is interrupted, it should start from the visible size and fitted radius', () {
    const movement = (
      begin: (size: Size(240, 48), radius: 24.0),
      end: (size: Size(96, 96), radius: 999.0),
    );
    for (final t in [-.3, .5, 1.3]) {
      final visible = MateoRoundedShapeBorder.lerp(begin: movement.begin, end: movement.end, progress: t);
      final redirected = (
        begin: (size: visible.size, radius: visible.border.radius!),
        end: (size: const Size(320, 480), radius: 0.0),
      );
      expect(MateoRoundedShapeBorder.lerp(begin: redirected.begin, end: redirected.end, progress: 0), visible);
    }
  });

  test('when either numeric radius is invalid, it should reject the endpoint', () {
    for (final radius in [-1.0, double.nan, double.infinity, double.negativeInfinity]) {
      final invalid = (size: const Size(96, 96), radius: radius);
      const valid = (size: Size(96, 96), radius: 24.0);
      expect(() => MateoRoundedShapeBorder.lerp(begin: invalid, end: valid, progress: 0), throwsArgumentError);
      expect(() => MateoRoundedShapeBorder.lerp(begin: valid, end: invalid, progress: 1), throwsArgumentError);
    }
  });

  test('when progress or dimensions are invalid, it should reject the frame without a substitute shape', () {
    const movement = (
      begin: (size: Size(96, 96), radius: 48.0),
      end: (size: Size(320, 480), radius: 24.0),
    );
    for (final t in [double.nan, double.infinity, double.negativeInfinity]) {
      expect(
        () => MateoRoundedShapeBorder.lerp(begin: movement.begin, end: movement.end, progress: t),
        throwsArgumentError,
      );
    }
    for (final size in [Size.zero, const Size(-1, 10), const Size(double.infinity, 10)]) {
      expect(
        () => MateoRoundedShapeBorder.lerp(
          begin: (size: size, radius: 48.0),
          end: movement.end,
          progress: .5,
        ),
        throwsArgumentError,
      );
    }
    const enormous = (
      begin: (size: Size(1e307, 1e307), radius: 0.0),
      end: (size: Size(1.7e308, 1.7e308), radius: 0.0),
    );
    expect(
      () => MateoRoundedShapeBorder.lerp(begin: enormous.begin, end: enormous.end, progress: 2),
      throwsArgumentError,
    );
    const shrinking = (
      begin: (size: Size(200, 200), radius: 20.0),
      end: (size: Size(100, 100), radius: 0.0),
    );
    for (final t in [2.0, 3.0]) {
      expect(
        () => MateoRoundedShapeBorder.lerp(begin: shrinking.begin, end: shrinking.end, progress: t),
        throwsArgumentError,
      );
    }
    const overflowingRadius = (
      begin: (size: Size(1e308, 1e308), radius: 0.0),
      end: (size: Size(1e308, 1e308), radius: 5e307),
    );
    expect(
      () => MateoRoundedShapeBorder.lerp(
        begin: overflowingRadius.begin,
        end: overflowingRadius.end,
        progress: 1e308,
      ),
      throwsArgumentError,
    );
  });
}
