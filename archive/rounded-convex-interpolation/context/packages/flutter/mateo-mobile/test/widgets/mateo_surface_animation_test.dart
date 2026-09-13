import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_draft/mateo_mobile.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart' show Morph;

import '../fixtures/surface_transform_test_widgets.dart';

void main() {
  const beginBounds = Rect.fromLTWH(20, 40, 144, 48);
  const endBounds = Rect.fromLTWH(260, 180, 240, 280);

  test('when animation is omitted or compared, it should retain closed value defaults', () {
    expect(const MateoSurface(child: SizedBox()).animation, const MateoSurfaceAnimation.none());
    expect(const MateoSurface.scrollable(child: SizedBox()).animation, const MateoSurfaceAnimation.none());
    expect(const MateoViewSurface(child: SizedBox()).animation, const MateoSurfaceAnimation.none());
    expect(const MateoViewSurface.scrollable(child: SizedBox()).animation, const MateoSurfaceAnimation.none());
    expect(const MateoSurfaceAnimation.transform(id: 'a'), const MateoSurfaceAnimation.transform(id: 'a'));
    expect(const MateoSurfaceAnimation.transform(id: 'a'), isNot(const MateoSurfaceAnimation.transform(id: 'b')));
    expect(const MateoSurfaceAnimation.transform(id: 'a'), isNot(const MateoSurfaceAnimation.none()));
    expect(
      const MateoSurfaceAnimation.transform(id: 'a').hashCode,
      const MateoSurfaceAnimation.transform(id: 'a').hashCode,
    );
  });

  for (final fromView in [false, true]) {
    for (final toView in [false, true]) {
      for (final scrollable in [false, true]) {
        testWidgets(
          'when ${fromView ? 'view' : 'ordinary'} transforms to ${toView ? 'view' : 'ordinary'} '
          'with scrolling $scrollable, it should interpolate and return in 300 ms',
          (tester) async {
            final navigatorKey = GlobalKey<NavigatorState>();
            final beginColor = surfaceTransformTheme.colorScheme.accent;
            final endColor = surfaceTransformTheme.colorScheme.background;
            final beginShape = fromView ? const MateoRoundedRectangleBorder(radius: 24) : const MateoCapsuleBorder();
            final endShape = toView ? const RoundedRectangleBorder() : const MateoRoundedRectangleBorder(radius: 40);
            final reference = MateoRoundedConvexInterpolation(
              begin: (shape: beginShape, size: beginBounds.size),
              end: (shape: endShape, size: endBounds.size),
            );
            await tester.pumpWidget(
              MateoApp(
                theme: surfaceTransformTheme,
                navigatorKey: navigatorKey,
                home: surfaceTransformEndpoint(
                  bounds: beginBounds,
                  view: fromView,
                  scrollable: scrollable,
                  shape: const .capsule(),
                  color: beginColor,
                  child: const Text('Source'),
                ),
              ),
            );
            await tester.pumpAndSettle();
            await startSurfaceFlight(
              tester,
              navigatorKey.currentState!,
              surfaceTransformEndpoint(
                bounds: endBounds,
                view: toView,
                scrollable: scrollable,
                shape: const .rounded(radius: 40),
                viewShape: const .none(),
                child: const Text('Destination'),
              ),
            );
            expect(surfaceFlight, findsOneWidget);
            expect(tester.getRect(surfaceFlight), beginBounds);
            await tester.pump(const Duration(milliseconds: 150));
            final progress = Curves.easeOutCubic.transform(.5);
            final frame = reference.lerp(progress);
            expect(tester.getRect(surfaceFlight), rectMoreOrLessEquals(Rect.lerp(beginBounds, endBounds, progress)!));
            final decoration = surfaceFlightDecoration(tester);
            expect(decoration.color, Color.lerp(beginColor, endColor, progress));
            expectSurfaceOutline(
              decoration.shape.getOuterPath(Offset.zero & frame.size),
              frame.border.getOuterPath(Offset.zero & frame.size),
            );
            expect(find.descendant(of: surfaceFlight, matching: find.byType(Text)), findsNothing);
            await tester.pump(const Duration(milliseconds: 149));
            expect(surfaceFlight, findsOneWidget);
            await tester.pump(const Duration(milliseconds: 1));
            expect(tester.getRect(surfaceFlight), rectMoreOrLessEquals(endBounds));
            // Allow Morph's paint-confirmed endpoint handoff to remove the overlay.
            await tester.pumpAndSettle();
            expect(surfaceFlight, findsNothing);
            navigatorKey.currentState!.pop();
            await tester.pump();
            await tester.pump();
            expect(surfaceFlight, findsOneWidget);
            expect(tester.getRect(surfaceFlight), endBounds);
            await tester.pump(const Duration(milliseconds: 150));
            expect(tester.getRect(surfaceFlight), rectMoreOrLessEquals(Rect.lerp(endBounds, beginBounds, progress)!));
            await tester.pumpAndSettle();
            expect(surfaceFlight, findsNothing);
            expect(find.text('Source'), findsOneWidget);
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  }

  testWidgets('when rebuilding or toggling animation, it should retain content state without a flight', (tester) async {
    final revision = ValueNotifier(0);
    addTearDown(revision.dispose);
    final childKey = GlobalKey();
    await tester.pumpWidget(
      MateoApp(
        theme: surfaceTransformTheme,
        home: ValueListenableBuilder<int>(
          valueListenable: revision,
          builder: (context, value, child) => surfaceTransformEndpoint(
            bounds: beginBounds,
            disabled: value == 2,
            id: value > 2 ? 'new-id' : 'details',
            shape: .rounded(radius: value.toDouble()),
            child: StatefulBuilder(key: childKey, builder: (context, setState) => const Text('Retained')),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final state = childKey.currentState;
    final target = tester.widget<Morph>(find.byType(Morph)).target;
    for (final value in [1, 2, 3, 4]) {
      revision.value = value;
      await tester.pumpAndSettle();
      expect(surfaceFlight, findsNothing);
      expect(childKey.currentState, same(state));
      if (value == 1) expect(tester.widget<Morph>(find.byType(Morph)).target, same(target));
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('when a local keyed surface is replaced, it should transform between its measured bounds', (
    tester,
  ) async {
    final destination = ValueNotifier(false);
    addTearDown(destination.dispose);
    await tester.pumpWidget(
      MateoApp(
        theme: surfaceTransformTheme,
        home: ValueListenableBuilder<bool>(
          valueListenable: destination,
          builder: (context, value, child) => surfaceTransformEndpoint(
            key: ValueKey(value),
            bounds: value ? endBounds : beginBounds,
            view: value,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    destination.value = true;
    await tester.pump();
    await tester.pump();
    expect(surfaceFlight, findsOneWidget);
    expect(tester.getRect(surfaceFlight), beginBounds);
    await tester.pump(const Duration(milliseconds: 150));
    expect(
      tester.getRect(surfaceFlight),
      rectMoreOrLessEquals(Rect.lerp(beginBounds, endBounds, Curves.easeOutCubic.transform(.5))!),
    );
    await tester.pumpAndSettle();
    destination.value = false;
    await tester.pump();
    await tester.pump();
    expect(surfaceFlight, findsOneWidget);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('when a route interrupts a flight, it should start at the sampled outline and color', (tester) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MateoApp(
        theme: surfaceTransformTheme,
        navigatorKey: navigatorKey,
        home: surfaceTransformEndpoint(bounds: beginBounds, shape: const .capsule()),
      ),
    );
    await tester.pumpAndSettle();
    await startSurfaceFlight(
      tester,
      navigatorKey.currentState!,
      surfaceTransformEndpoint(
        bounds: endBounds,
        color: surfaceTransformTheme.colorScheme.accent,
      ),
    );
    await tester.pump(const Duration(milliseconds: 90));
    final sampledRect = tester.getRect(surfaceFlight);
    final sampledDecoration = surfaceFlightDecoration(tester);
    const nextBounds = Rect.fromLTWH(80, 100, 320, 180);
    await startSurfaceFlight(
      tester,
      navigatorKey.currentState!,
      surfaceTransformEndpoint(
        bounds: nextBounds,
        shape: const .none(),
        color: surfaceTransformTheme.colorScheme.inverse.background,
      ),
    );
    expect(tester.getRect(surfaceFlight), sampledRect);
    expect(surfaceFlightDecoration(tester).color, sampledDecoration.color);
    expectSurfaceOutline(
      surfaceFlightDecoration(tester).shape.getOuterPath(Offset.zero & sampledRect.size),
      sampledDecoration.shape.getOuterPath(Offset.zero & sampledRect.size),
      tolerance: sampledRect.size.longestSide * .0007,
    );
    await tester.pumpAndSettle();
    expect(surfaceFlight, findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final beforeFlight in [false, true]) {
    testWidgets(
      'when reduced motion is enabled ${beforeFlight ? 'before' : 'during'} flight, it should reveal content',
      (tester) async {
        final disabled = ValueNotifier(beforeFlight);
        addTearDown(disabled.dispose);
        final navigatorKey = GlobalKey<NavigatorState>();
        await tester.pumpWidget(
          MateoApp(
            theme: surfaceTransformTheme,
            navigatorKey: navigatorKey,
            builder: (context, child) => ValueListenableBuilder<bool>(
              valueListenable: disabled,
              builder: (context, value, _) => MediaQuery(
                data: MediaQuery.of(context).copyWith(disableAnimations: value),
                child: child!,
              ),
            ),
            home: surfaceTransformEndpoint(bounds: beginBounds),
          ),
        );
        await tester.pumpAndSettle();
        await startSurfaceFlight(
          tester,
          navigatorKey.currentState!,
          surfaceTransformEndpoint(
            bounds: endBounds,
            child: const Text('Arrived'),
          ),
        );
        if (!beforeFlight) {
          expect(surfaceFlight, findsOneWidget);
          await tester.pump(const Duration(milliseconds: 75));
          disabled.value = true;
        }
        await tester.pumpAndSettle();
        expect(surfaceFlight, findsNothing);
        expect(find.text('Arrived').hitTestable(), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final kind in ['different ID', 'disabled', 'zero size', 'no overlay']) {
    testWidgets('when an endpoint has $kind, it should render normally without a flight', (tester) async {
      final endpoint = surfaceTransformEndpoint(
        bounds: kind == 'zero size' ? Rect.zero : endBounds,
        id: kind == 'different ID' ? 'other' : 'details',
        disabled: kind == 'disabled',
        child: const Text('Resting'),
      );
      if (kind == 'no overlay') {
        await tester.pumpWidget(
          MateoTheme(
            data: surfaceTransformTheme,
            child: Directionality(textDirection: .ltr, child: endpoint),
          ),
        );
      } else {
        final navigatorKey = GlobalKey<NavigatorState>();
        await tester.pumpWidget(
          MateoApp(
            theme: surfaceTransformTheme,
            navigatorKey: navigatorKey,
            home: surfaceTransformEndpoint(bounds: beginBounds),
          ),
        );
        await tester.pumpAndSettle();
        await startSurfaceFlight(tester, navigatorKey.currentState!, endpoint);
      }
      expect(surfaceFlight, findsNothing);
      expect(find.text('Resting'), findsOneWidget);
      if (kind == 'zero size') {
        expect(
          tester.takeException(),
          isA<FlutterError>().having(
            (error) => error.message,
            'diagnostic',
            contains('did not have usable layout'),
          ),
        );
      }
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('when a flying app unmounts, it should release its overlay and ticker', (tester) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MateoApp(
        theme: surfaceTransformTheme,
        navigatorKey: navigatorKey,
        home: surfaceTransformEndpoint(bounds: beginBounds),
      ),
    );
    await tester.pumpAndSettle();
    await startSurfaceFlight(tester, navigatorKey.currentState!, surfaceTransformEndpoint(bounds: endBounds));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    expect(surfaceFlight, findsNothing);
    expect(tester.binding.transientCallbackCount, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('when an endpoint is scaled, it should preserve the painted outline in overlay coordinates', (
    tester,
  ) async {
    const sourceShape = MateoRoundedRectangleBorder(radius: 12);
    const scaledBounds = Rect.fromLTWH(30, 30, 216, 36);
    final navigatorKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MateoApp(
        theme: surfaceTransformTheme,
        navigatorKey: navigatorKey,
        home: Transform.scale(
          scaleX: 1.5,
          scaleY: .75,
          alignment: .topLeft,
          child: surfaceTransformEndpoint(bounds: beginBounds, shape: const .rounded(radius: 12)),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await startSurfaceFlight(tester, navigatorKey.currentState!, surfaceTransformEndpoint(bounds: endBounds));
    expect(tester.getRect(surfaceFlight), rectMoreOrLessEquals(scaledBounds));
    final expected = sourceShape
        .getOuterPath(Offset.zero & beginBounds.size)
        .transform(
          (Matrix4.identity()..scaleByDouble(1.5, .75, 1, 1)).storage,
        );
    expectSurfaceOutline(
      surfaceFlightDecoration(tester).shape.getOuterPath(Offset.zero & scaledBounds.size),
      expected,
      tolerance: .15,
    );
    await tester.pump(const Duration(milliseconds: 150));
    final referenceSource = MateoRoundedConvexInterpolation(
      begin: (shape: sourceShape, size: beginBounds.size),
      end: (shape: sourceShape, size: beginBounds.size),
    ).lerp(0);
    final frame = MateoRoundedConvexInterpolation(
      begin: (shape: referenceSource.border, size: scaledBounds.size),
      end: (shape: const MateoRoundedRectangleBorder(radius: 24), size: endBounds.size),
    ).lerp(Curves.easeOutCubic.transform(.5));
    expectSurfaceOutline(
      surfaceFlightDecoration(tester).shape.getOuterPath(Offset.zero & frame.size),
      frame.border.getOuterPath(Offset.zero & frame.size),
      tolerance: .15,
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('when a push reverses before landing, it should return from its current visible geometry', (
    tester,
  ) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MateoApp(
        theme: surfaceTransformTheme,
        navigatorKey: navigatorKey,
        home: surfaceTransformEndpoint(bounds: beginBounds, shape: const .capsule()),
      ),
    );
    await tester.pumpAndSettle();
    await startSurfaceFlight(tester, navigatorKey.currentState!, surfaceTransformEndpoint(bounds: endBounds));
    await tester.pump(const Duration(milliseconds: 90));
    final sampledBounds = tester.getRect(surfaceFlight);
    final sampledShape = surfaceFlightDecoration(tester).shape;
    navigatorKey.currentState!.pop();
    await tester.pump();
    await tester.pump();
    expect(tester.getRect(surfaceFlight), rectMoreOrLessEquals(sampledBounds));
    expectSurfaceOutline(
      surfaceFlightDecoration(tester).shape.getOuterPath(Offset.zero & sampledBounds.size),
      sampledShape.getOuterPath(Offset.zero & sampledBounds.size),
      tolerance: sampledBounds.size.longestSide * .0007,
    );
    await tester.pumpAndSettle();
    expect(surfaceFlight, findsNothing);
    expect(navigatorKey.currentState!.canPop(), isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('when a surface is flying, it should hide content and effects while retaining state and scroll', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      final navigatorKey = GlobalKey<NavigatorState>();
      final sourceKey = GlobalKey();
      final destinationKey = GlobalKey();
      var taps = 0;
      Widget content(GlobalKey key, String label, double height) => StatefulBuilder(
        key: key,
        builder: (context, setState) => Semantics(
          label: label,
          child: GestureDetector(
            behavior: .opaque,
            onTap: () => taps++,
            child: SizedBox(height: height),
          ),
        ),
      );
      await tester.pumpWidget(
        MateoApp(
          theme: surfaceTransformTheme,
          navigatorKey: navigatorKey,
          home: surfaceTransformEndpoint(
            bounds: beginBounds,
            scrollable: true,
            child: content(sourceKey, 'Source content', 900),
            elevation: MateoElevation(level: 2),
            edgeEffect: MateoEdgeEffect.fade(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final sourceState = sourceKey.currentState;
      final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!..jumpTo(120);
      await tester.pumpAndSettle();
      await startSurfaceFlight(
        tester,
        navigatorKey.currentState!,
        surfaceTransformEndpoint(
          bounds: endBounds,
          view: true,
          child: content(destinationKey, 'Destination content', 280),
          elevation: MateoElevation(level: 1),
          edgeEffect: MateoEdgeEffect.fade(),
        ),
      );
      final destinationState = destinationKey.currentState;
      await tester.pump(const Duration(milliseconds: 100));
      expect(surfaceFlightDecoration(tester).shadows, isNull);
      expect(find.descendant(of: surfaceFlight, matching: find.byType(StatefulBuilder)), findsNothing);
      expect(find.bySemanticsLabel('Source content'), findsNothing);
      expect(find.bySemanticsLabel('Destination content'), findsNothing);
      await tester.tapAt(tester.getRect(surfaceFlight).center);
      expect(taps, 0);
      expect(sourceKey.currentState, same(sourceState));
      expect(destinationKey.currentState, same(destinationState));
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('Destination content'), findsOneWidget);
      await tester.tapAt(endBounds.center);
      expect(taps, 1);
      navigatorKey.currentState!.pop();
      await tester.pumpAndSettle();
      expect(controller.offset, 120);
      expect(sourceKey.currentState, same(sourceState));
      expect(find.bySemanticsLabel('Source content'), findsOneWidget);
      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('when a route has a longer animation, it should still land the surface after 300 ms', (tester) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MateoApp(
        theme: surfaceTransformTheme,
        navigatorKey: navigatorKey,
        home: surfaceTransformEndpoint(bounds: beginBounds),
      ),
    );
    await tester.pumpAndSettle();
    final route = surfaceTransformRoute(
      surfaceTransformEndpoint(bounds: endBounds),
      duration: const Duration(seconds: 1),
    );
    navigatorKey.currentState!.push<void>(route);
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.getRect(surfaceFlight), rectMoreOrLessEquals(endBounds));
    expect(route.animation!.isCompleted, isFalse);
    await tester.pumpAndSettle();
    expect(surfaceFlight, findsNothing);
    expect(tester.takeException(), isNull);
  });
}
