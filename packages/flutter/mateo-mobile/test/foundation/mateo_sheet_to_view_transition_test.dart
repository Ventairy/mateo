import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/src/foundation/mateo_sheet_to_view_transition/mateo_sheet_to_view_transition.dart';

void main() {
  final curve = kSheetToViewTransformAnimation.curve;

  test('when the transition runs, it should advance without overshoot or reversal', () {
    var previous = 0.0;
    for (var frame = 0; frame <= 1000; frame++) {
      final progress = curve.transform(frame / 1000);
      expect(progress, inInclusiveRange(previous, 1.0));
      previous = progress;
    }
    expect((curve.transform(0), curve.transform(1)), (0, 1));
  });

  test('when the surface decelerates, it should not speed up again before landing', () {
    const step = 0.001;
    var previousTravel = double.infinity;
    for (var frame = 200; frame < 1000; frame++) {
      final time = frame / 1000;
      final travel = curve.transform(time + step) - curve.transform(time);
      expect(travel, lessThanOrEqualTo(previousTravel + 1e-12));
      previousTravel = travel;
    }
  });

  test('when the landing tail begins, it should preserve velocity and acceleration', () {
    const join = 0.5;
    const step = 0.00001;
    final before = curve.transform(join - step);
    final at = curve.transform(join);
    final after = curve.transform(join + step);
    final incomingVelocity = (at - before) / step;
    final outgoingVelocity = (after - at) / step;
    final incomingAcceleration = (at - 2 * before + curve.transform(join - 2 * step)) / (step * step);
    final outgoingAcceleration = (curve.transform(join + 2 * step) - 2 * after + at) / (step * step);
    expect(outgoingVelocity, closeTo(incomingVelocity, 0.0001));
    expect(outgoingAcceleration, closeTo(incomingAcceleration, 0.005));
  });

  test('when the surface reaches its destination, it should stop with zero velocity and acceleration', () {
    const step = 0.0001;
    final at = curve.transform(1);
    final before = curve.transform(1 - step);
    final velocity = (at - before) / step;
    final acceleration = (at - 2 * before + curve.transform(1 - 2 * step)) / (step * step);
    expect(velocity, closeTo(0, 0.000001));
    expect(acceleration, closeTo(0, 0.005));
  });

  for (final refreshRate in [60, 120]) {
    test('when landing at $refreshRate Hz, it should have less final-frame travel than the previous curve', () {
      final duration = kSheetToViewTransformAnimation.duration!;
      final penultimateTime = 1 - Duration.microsecondsPerSecond / (refreshRate * duration.inMicroseconds);
      final travel = 1 - curve.transform(penultimateTime);
      final previousTravel = 1 - Curves.easeOutCubic.transform(penultimateTime);
      expect(travel, lessThan(previousTravel / 2));
    });
  }
}
