import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart' show MateoNavigatorObserver;
import 'package:mateo_mobile/src/foundation/mateo_sheet_to_view_transition/mateo_sheet_to_view_transition.dart';

void main() {
  final forwardCurve = kSheetToViewTransformAnimation.curve;
  final reverseCurve = kSheetToViewTransformAnimation.reverseCurve;

  test('when automatic matching is configured, it should use all authored timing', () {
    final target = MateoNavigatorObserver().sheetToViewMorphTarget;
    expect(target.duration, sheetToViewTransformDurations.forward);
    expect(target.reverseDuration, sheetToViewTransformDurations.reverse);
    expect(target.curve, kSheetToViewTransformAnimation.curve);
    expect(target.reverseCurve, kSheetToViewTransformAnimation.reverseCurve);
  });

  test('when the transition runs, it should advance without overshoot or reversal', () {
    var previous = 0.0;
    for (var frame = 0; frame <= 1000; frame++) {
      final progress = forwardCurve.transform(frame / 1000);
      expect(progress, inInclusiveRange(previous, 1.0));
      previous = progress;
    }
    expect((forwardCurve.transform(0), forwardCurve.transform(1)), (0, 1));
  });

  test('when the surface decelerates, it should not speed up again before landing', () {
    const step = 0.001;
    var previousTravel = double.infinity;
    for (var frame = 200; frame < 1000; frame++) {
      final time = frame / 1000;
      final travel = forwardCurve.transform(time + step) - forwardCurve.transform(time);
      expect(travel, lessThanOrEqualTo(previousTravel + 1e-12));
      previousTravel = travel;
    }
  });

  test('when the landing tail begins, it should preserve velocity and acceleration', () {
    const join = 0.5;
    const step = 0.00001;
    final before = forwardCurve.transform(join - step);
    final at = forwardCurve.transform(join);
    final after = forwardCurve.transform(join + step);
    final incomingVelocity = (at - before) / step;
    final outgoingVelocity = (after - at) / step;
    final incomingAcceleration = (at - 2 * before + forwardCurve.transform(join - 2 * step)) / (step * step);
    final outgoingAcceleration = (forwardCurve.transform(join + 2 * step) - 2 * after + at) / (step * step);
    expect(outgoingVelocity, closeTo(incomingVelocity, 0.0001));
    expect(outgoingAcceleration, closeTo(incomingAcceleration, 0.005));
  });

  test('when the surface reaches its destination, it should stop with zero velocity and acceleration', () {
    const step = 0.0001;
    final at = forwardCurve.transform(1);
    final before = forwardCurve.transform(1 - step);
    final velocity = (at - before) / step;
    final acceleration = (at - 2 * before + forwardCurve.transform(1 - 2 * step)) / (step * step);
    expect(velocity, closeTo(0, 0.000001));
    expect(acceleration, closeTo(0, 0.005));
  });

  for (final refreshRate in [60, 120]) {
    test('when landing at $refreshRate Hz, it should have less final-frame travel than the previous curve', () {
      final duration = sheetToViewTransformDurations.forward;
      final penultimateTime = 1 - Duration.microsecondsPerSecond / (refreshRate * duration.inMicroseconds);
      final travel = 1 - forwardCurve.transform(penultimateTime);
      final previousTravel = 1 - Curves.easeOutCubic.transform(penultimateTime);
      expect(travel, lessThan(previousTravel / 2));
    });
  }

  test('when returning to the sheet, it should advance without overshoot or reversal', () {
    var previous = 0.0;
    for (var frame = 0; frame <= 1000; frame++) {
      final progress = reverseCurve.transform(frame / 1000);
      expect(progress, inInclusiveRange(previous, 1.0));
      previous = progress;
    }
    expect((reverseCurve.transform(0), reverseCurve.transform(1)), (0, 1));
  });

  test('when returning to the sheet, it should continuously decelerate after its peak', () {
    const step = 0.001;
    var previousTravel = double.infinity;
    for (var frame = 200; frame < 1000; frame++) {
      final time = frame / 1000;
      final travel = reverseCurve.transform(time + step) - reverseCurve.transform(time);
      expect(travel, lessThanOrEqualTo(previousTravel + 1e-12));
      previousTravel = travel;
    }
  });

  test('when the return landing begins, it should preserve velocity and acceleration', () {
    const join = 0.5;
    const step = 0.00001;
    final before = reverseCurve.transform(join - step);
    final at = reverseCurve.transform(join);
    final after = reverseCurve.transform(join + step);
    final incomingVelocity = (at - before) / step;
    final outgoingVelocity = (after - at) / step;
    final incomingAcceleration = (at - 2 * before + reverseCurve.transform(join - 2 * step)) / (step * step);
    final outgoingAcceleration = (reverseCurve.transform(join + 2 * step) - 2 * after + at) / (step * step);
    expect(outgoingVelocity, closeTo(incomingVelocity, 0.0001));
    expect(outgoingAcceleration, closeTo(incomingAcceleration, 0.005));
  });

  test('when the return reaches the sheet, it should stop without terminal force', () {
    const step = 0.0001;
    final at = reverseCurve.transform(1);
    final before = reverseCurve.transform(1 - step);
    final velocity = (at - before) / step;
    final acceleration = (at - 2 * before + reverseCurve.transform(1 - 2 * step)) / (step * step);
    expect(velocity, closeTo(0, 0.000001));
    expect(acceleration, closeTo(0, 0.005));
  });

  test('when the return lands, it should remove the forward curve terminal jerk', () {
    const step = 0.0001;
    double terminalJerk(Curve curve) =>
        (curve.transform(1) -
            3 * curve.transform(1 - step) +
            3 * curve.transform(1 - 2 * step) -
            curve.transform(1 - 3 * step)) /
        (step * step * step);

    expect(
      terminalJerk(reverseCurve).abs(),
      lessThan(terminalJerk(forwardCurve).abs() / 100),
    );
  });

  for (final refreshRate in [60, 120]) {
    test('when returning at $refreshRate Hz, it should land softer than the forward motion', () {
      final duration = sheetToViewTransformDurations.reverse;
      final penultimateTime = 1 - Duration.microsecondsPerSecond / (refreshRate * duration.inMicroseconds);
      final reverseTravel = 1 - reverseCurve.transform(penultimateTime);
      final forwardTravel = 1 - forwardCurve.transform(penultimateTime);
      expect(reverseTravel, lessThan(forwardTravel / 2));
    });
  }
}
