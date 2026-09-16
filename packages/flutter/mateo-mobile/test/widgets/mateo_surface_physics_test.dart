import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  Widget host({bool reduced = false, double height = 300, double contentHeight = 1200}) => Directionality(
    textDirection: .ltr,
    child: MediaQuery(
      data: MediaQueryData(disableAnimations: reduced),
      child: Center(
        child: MateoSurface.scrollable(
          color: const Color(0xFF123456),
          width: const .custom(300),
          height: .custom(height),
          child: SizedBox(height: contentHeight),
        ),
      ),
    ),
  );
  ScrollController controller(WidgetTester tester) =>
      tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!;
  FixedScrollMetrics metrics(double pixels, {double viewport = 300}) => FixedScrollMetrics(
    minScrollExtent: 0,
    maxScrollExtent: 1000,
    pixels: pixels,
    viewportDimension: viewport,
    axisDirection: .down,
    devicePixelRatio: 1,
  );

  testWidgets('when released beyond either edge, it should rebound proportionally and settle exactly', (tester) async {
    await tester.pumpWidget(host());
    final physics = controller(tester).position.physics;
    for (final bottom in [false, true]) {
      var previousPeak = 0.0;
      for (final distance in [5.0, 40.0, 120.0]) {
        final target = bottom ? 1000.0 : 0.0;
        final simulation = physics.createBallisticSimulation(metrics(target + (bottom ? distance : -distance)), 0)!;
        var peak = 0.0;
        final extrema = <double>[];
        var previousVelocity = simulation.dx(0);
        for (var frame = 1; frame <= 720; frame++) {
          final time = frame / 240;
          if (simulation.isDone(time)) break;
          final x = simulation.x(time);
          final velocity = simulation.dx(time);
          expect(x.isFinite && velocity.isFinite, isTrue);
          peak = math.max(peak, bottom ? target - x : x - target);
          if (previousVelocity * velocity < 0) extrema.add((x - target).abs());
          previousVelocity = velocity;
        }
        expect(peak, greaterThan(previousPeak));
        // Flutter can settle tiny rebounds early at its pixel tolerance.
        if (distance >= 40) expect(peak / distance, closeTo(0.205, 0.005));
        for (var index = 1; index < extrema.length; index++) {
          expect(extrema[index], lessThan(extrema[index - 1]));
        }
        expect(simulation.isDone(3), isTrue);
        expect(simulation.x(3), target);
        previousPeak = peak;
      }
    }
  });

  testWidgets('when release velocity or a fling reaches an edge, it should settle with finite motion', (tester) async {
    await tester.pumpWidget(host());
    final physics = controller(tester).position.physics;
    for (final start in [-60.0, 1060.0, 0.0, 1000.0]) {
      for (final velocity in [-1500.0, 1500.0]) {
        final simulation = physics.createBallisticSimulation(metrics(start), velocity)!;
        expect(simulation.x(0), closeTo(start, 0.001));
        expect(simulation.dx(0), closeTo(velocity, 0.001));
        for (var frame = 0; frame <= 720; frame++) {
          expect(simulation.x(frame / 120).isFinite && simulation.dx(frame / 120).isFinite, isTrue);
        }
        expect(simulation.isDone(6), isTrue);
        expect(simulation.x(6), inInclusiveRange(0, 1000));
      }
    }
  });

  testWidgets('when pulling farther outside an edge, it should increase resistance relative to the viewport', (
    tester,
  ) async {
    await tester.pumpWidget(host());
    final physics = controller(tester).position.physics;
    expect(physics.applyPhysicsToUserOffset(metrics(500), 20), 20);
    for (final viewport in [200.0, 800.0]) {
      final near = physics.applyPhysicsToUserOffset(metrics(-viewport * 0.1, viewport: viewport), 10);
      final far = physics.applyPhysicsToUserOffset(metrics(-viewport * 0.4, viewport: viewport), 10);
      expect(far, inExclusiveRange(0, near));
      expect(near, lessThan(10));
    }
    expect(
      physics.applyPhysicsToUserOffset(metrics(-20, viewport: 200), 10),
      physics.applyPhysicsToUserOffset(metrics(-80, viewport: 800), 10),
    );
  });

  testWidgets('when short content is pulled, it should remain still', (tester) async {
    await tester.pumpWidget(host(contentHeight: 80));
    await tester.drag(find.byType(CustomScrollView), const Offset(0, 100));
    await tester.pumpAndSettle();
    expect(controller(tester).offset, 0);
    expect(controller(tester).position.maxScrollExtent, 0);
  });

  testWidgets('when a rebound is touched, it should stop and hand control to the new gesture', (tester) async {
    await tester.pumpWidget(host());
    final scroll = controller(tester);
    final gesture = await tester.startGesture(tester.getCenter(find.byType(CustomScrollView)));
    await gesture.moveBy(const Offset(0, 120));
    await tester.pump(const Duration(milliseconds: 150));
    expect(scroll.offset, lessThan(0));
    await gesture.up();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 240));
    expect(scroll.offset, greaterThan(0));
    final interrupt = await tester.startGesture(tester.getCenter(find.byType(CustomScrollView)));
    final held = scroll.offset;
    await tester.pump(const Duration(seconds: 1));
    expect(scroll.offset, held);
    await interrupt.moveBy(const Offset(0, -60));
    expect(scroll.offset, greaterThan(held));
    await interrupt.up();
    await tester.pumpAndSettle();
  });

  testWidgets('when reduced motion changes, it should preserve the controller and use a non-oscillating return', (
    tester,
  ) async {
    await tester.pumpWidget(host());
    final scroll = controller(tester)..jumpTo(100);
    final normalType = scroll.position.physics.runtimeType;
    await tester.pumpWidget(host(reduced: true));
    expect(controller(tester), same(scroll));
    expect(scroll.offset, 100);
    expect(scroll.position.physics.runtimeType, isNot(normalType));
    final simulation = scroll.position.physics.createBallisticSimulation(metrics(-80), 0)!;
    var previous = -80.0;
    for (var frame = 1; frame <= 360; frame++) {
      final x = simulation.x(frame / 120);
      expect(x, inInclusiveRange(previous, 0));
      previous = x;
    }
    expect(simulation.x(3), 0);
    await tester.pumpWidget(host());
    expect(controller(tester), same(scroll));
    expect(scroll.position.physics.runtimeType, normalType);
  });

  testWidgets('when geometry changes during rebound, it should settle within the updated bounds', (tester) async {
    await tester.pumpWidget(host());
    final scroll = controller(tester)..jumpTo(-80);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpWidget(host(height: 220, contentHeight: 700));
    expect(controller(tester), same(scroll));
    await tester.pumpAndSettle();
    expect(scroll.offset, inInclusiveRange(scroll.position.minScrollExtent, scroll.position.maxScrollExtent));
    scroll.jumpTo(scroll.position.maxScrollExtent);
    expect(scroll.offset, 480);
  });
  testWidgets('when the platform changes, it should retain the same Mateo edge response', (tester) async {
    try {
      final peaks = <double>[];
      for (final platform in [TargetPlatform.iOS, TargetPlatform.android]) {
        debugDefaultTargetPlatformOverride = platform;
        await tester.pumpWidget(const SizedBox());
        await tester.pumpWidget(host());
        final simulation = controller(tester).position.physics.createBallisticSimulation(metrics(-80), 0)!;
        peaks.add(simulation.x(0.24));
      }
      expect(peaks.first, peaks.last);
      expect(peaks.first, greaterThan(0));
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('when reduced motion is enabled during rebound, it should retain the position and settle', (
    tester,
  ) async {
    await tester.pumpWidget(host());
    final scroll = controller(tester)..jumpTo(-80);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));
    final before = scroll.offset;
    await tester.pumpWidget(host(reduced: true));
    expect(controller(tester), same(scroll));
    expect(scroll.offset, closeTo(before, 0.001));
    expect(scroll.position.physics.spring.damping, 30);
    await tester.pumpAndSettle();
    expect(scroll.offset, 0);
  });
}
