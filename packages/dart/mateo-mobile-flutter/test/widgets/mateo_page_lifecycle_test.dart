import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/render_lifecycle_probe/render_lifecycle_probe.dart';

void main() {
  for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
    for (final snapshots in [true, false]) {
      for (final source in [
        const MateoPageTransition.push(direction: .left),
        const MateoPageTransition.slide(direction: .down),
        const MateoPageTransition.wash(direction: .right),
      ]) {
        for (final destination in [
          const MateoPageTransition.push(
            direction: .up,
            duration: Duration(milliseconds: 480),
            reverseDuration: Duration(milliseconds: 350),
          ),
          const MateoPageTransition.slide(direction: .right),
          const MateoPageTransition.wash(direction: .down),
        ]) {
          testWidgets(
            'when ${source.runtimeType} is covered by ${destination.runtimeType} on ${platform.name} with snapshots $snapshots, it should keep maintained render objects attached',
            (tester) async {
              final previousPlatform = debugDefaultTargetPlatformOverride;
              debugDefaultTargetPlatformOverride = platform;
              try {
                final reducedMotion = ValueNotifier(false);
                addTearDown(reducedMotion.dispose);
                final navigatorKey = GlobalKey<NavigatorState>();
                var attaches = 0;
                var detaches = 0;
                final theme = MateoThemeData.light(
                  accentColor: const Color(0xFF7551FF),
                  onAccent: const Color(0xFFFFFFFF),
                );
                await tester.pumpWidget(
                  MateoApp(
                    theme: theme,
                    builder: (context, child) => ValueListenableBuilder<bool>(
                      valueListenable: reducedMotion,
                      builder: (context, reduced, _) => MediaQuery(
                        data: MediaQueryData(disableAnimations: reduced),
                        child: child!,
                      ),
                    ),
                    home: Builder(
                      builder: (context) => Navigator(
                        key: navigatorKey,
                        onGenerateRoute: (_) => MateoPage<void>(
                          transition: source,
                          allowSnapshotting: snapshots,
                          child: RenderLifecycleProbe(
                            key: const ValueKey('source'),
                            onAttach: () => attaches++,
                            onDetach: () => detaches++,
                            child: ColoredBox(color: theme.colorScheme.background),
                          ),
                        ).createRoute(context),
                      ),
                    ),
                  ),
                );
                await tester.pumpAndSettle();
                expect(attaches, 1);
                expect(detaches, 0);
                final navigator = navigatorKey.currentState!;
                final sourceBounds = tester.getRect(find.byKey(const ValueKey('source')));
                for (var roundTrip = 0; roundTrip < 2; roundTrip++) {
                  var destinationDetaches = 0;
                  navigator.push(
                    MateoPage<void>(
                      transition: destination,
                      allowSnapshotting: snapshots,
                      child: RenderLifecycleProbe(
                        onAttach: () {},
                        onDetach: () => destinationDetaches++,
                        child: ColoredBox(color: theme.colorScheme.background),
                      ),
                    ).createRoute(navigator.context),
                  );
                  await tester.pump();
                  await tester.pump(const Duration(milliseconds: 100));
                  expect(detaches, 0, reason: 'Pushing must preserve prepared render resources.');
                  final movingBounds = tester.getRect(find.byKey(const ValueKey('source')));
                  if (destination is MateoPageTransitionPush) {
                    expect(movingBounds.left, sourceBounds.left);
                    expect(movingBounds.top, lessThan(sourceBounds.top));
                  } else {
                    expect(movingBounds, sourceBounds);
                  }
                  if (roundTrip == 0) {
                    await tester.pumpAndSettle();
                    reducedMotion.value = true;
                    await tester.pumpAndSettle();
                    expect(detaches, 0, reason: 'Reduced motion must not replace render ancestors.');
                    reducedMotion.value = false;
                    await tester.pumpAndSettle();
                  }
                  if (roundTrip == 1) {
                    navigator.push(
                      const MateoPage<void>(
                        transition: .push(direction: .right),
                        child: SizedBox.expand(),
                      ).createRoute(navigator.context),
                    );
                    await tester.pump();
                    await tester.pump(const Duration(milliseconds: 80));
                    expect(
                      destinationDetaches,
                      0,
                      reason: 'Covering an arriving page must keep its render subtree attached.',
                    );
                    navigator.pop();
                    await tester.pumpAndSettle();
                    expect(destinationDetaches, 0);
                  }
                  expect(detaches, 0);
                  navigator.pop();
                  await tester.pump();
                  await tester.pump(const Duration(milliseconds: 100));
                  expect(detaches, 0);
                  await tester.pumpAndSettle();
                  expect(attaches, 1);
                  expect(detaches, 0, reason: 'Returning must preserve prepared render resources.');
                  expect(destinationDetaches, 1, reason: 'The removed destination must release its render resources.');
                }
                await tester.pumpWidget(const SizedBox());
                expect(detaches, 1, reason: 'Removing the route must still release render resources.');
              } finally {
                debugDefaultTargetPlatformOverride = previousPlatform;
              }
            },
          );
        }
      }
    }
  }
}
