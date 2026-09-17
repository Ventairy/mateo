import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/surface_transform_test_widgets.dart';

void main() {
  for (final reverse in [false, true]) {
    testWidgets('interrupted content preserves composition with reversal $reverse', (tester) async {
      final navigator = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MateoApp(
          theme: surfaceTransformTheme,
          navigatorKey: navigator,
          home: surfaceTransformEndpoint(bounds: const Rect.fromLTWH(20, 40, 160, 64), child: const Text('Source')),
        ),
      );
      await tester.pumpAndSettle();
      await startSurfaceTransformAnimationFlight(
        tester,
        navigator.currentState!,
        surfaceTransformEndpoint(
          bounds: const Rect.fromLTWH(40, 60, 240, 280),
          child: const Text('Destination'),
        ),
      );
      await tester.pump(const Duration(milliseconds: 90));
      List<(Rect, double)> composition() => [
        for (final position in tester.widgetList<Positioned>(
          find.descendant(of: surfaceFlight, matching: find.byType(Positioned)),
        ))
          (
            Rect.fromLTWH(position.left!, position.top!, position.width!, position.height!),
            (position.child as Opacity).opacity,
          ),
      ];
      final before = composition();
      if (reverse) {
        navigator.currentState!.pop();
        await tester.pump();
        await tester.pump();
      } else {
        await startSurfaceTransformAnimationFlight(
          tester,
          navigator.currentState!,
          surfaceTransformEndpoint(
            bounds: const Rect.fromLTWH(80, 100, 320, 180),
            child: const Text('Next'),
          ),
        );
      }
      expect(composition(), before);
      await tester.pump(const Duration(milliseconds: 40));
      expect(tester.takeException(), isNull);
      await tester.pumpAndSettle();
      expect(surfaceFlight, findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  for (final fromView in [false, true]) {
    for (final toView in [false, true]) {
      for (final scrollable in [false, true]) {
        testWidgets('crossfade $fromView to $toView with scrolling $scrollable retains content and proportions', (
          tester,
        ) async {
          final navigator = GlobalKey<NavigatorState>();
          final sourceKey = GlobalKey();
          final destinationKey = GlobalKey();
          await tester.pumpWidget(
            MateoApp(
              theme: surfaceTransformTheme,
              navigatorKey: navigator,
              home: surfaceTransformEndpoint(
                bounds: const Rect.fromLTWH(20, 40, 160, 64),
                view: fromView,
                scrollable: scrollable,
                child: StatefulBuilder(key: sourceKey, builder: (context, setState) => const Text('Source')),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final sourceState = sourceKey.currentState;
          await startSurfaceTransformAnimationFlight(
            tester,
            navigator.currentState!,
            surfaceTransformEndpoint(
              bounds: const Rect.fromLTWH(40, 60, 240, 280),
              view: toView,
              scrollable: scrollable,
              child: StatefulBuilder(key: destinationKey, builder: (context, setState) => const Text('Destination')),
            ),
          );
          final destinationState = destinationKey.currentState;
          await tester.pump(const Duration(milliseconds: 115));
          final layers = find.descendant(
            of: surfaceFlight,
            matching: find.byWidgetPredicate((widget) => widget is Opacity && widget.child is FittedBox),
          );
          expect(layers, findsNWidgets(2));
          expect(
            find.descendant(
              of: surfaceFlight,
              matching: find.byWidgetPredicate(
                (widget) =>
                    widget is CustomPaint && widget.painter.runtimeType.toString() == '_MorphGroupSnapshotPainter',
              ),
            ),
            findsNWidgets(2),
          );
          final opacities = tester.widgetList<Opacity>(layers).map((layer) => layer.opacity).toList();
          final progress = Curves.easeOutCubic.transform(.5);
          expect(opacities[0], closeTo(1 - progress, 1e-6));
          expect(opacities[1], closeTo(progress, 1e-6));
          final positions = tester
              .widgetList<Positioned>(find.descendant(of: surfaceFlight, matching: find.byType(Positioned)))
              .toList();
          expect(positions[0].width! / positions[0].height!, closeTo(160 / 64, 1e-6));
          expect(positions[1].width! / positions[1].height!, closeTo(240 / 280, 1e-6));
          expect(find.descendant(of: surfaceFlight, matching: find.byType(Text)), findsNothing);
          expect(sourceKey.currentState, same(sourceState));
          expect(destinationKey.currentState, same(destinationState));
          expect(tester.takeException(), isNull);
          await tester.pumpAndSettle();
          expect(surfaceFlight, findsNothing);
          expect(destinationKey.currentState, same(destinationState));
          navigator.currentState!.pop();
          await tester.pumpAndSettle();
          expect(sourceKey.currentState, same(sourceState));
          expect(surfaceFlight, findsNothing);
          expect(tester.takeException(), isNull);
        });
      }
    }
  }
}
