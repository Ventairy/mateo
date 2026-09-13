import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:mateo_mobile_draft/mateo_mobile.dart';

import '../fixtures/surface_transform_test_widgets.dart';

Future<void> main() async {
  for (final elapsed in [-1, 75, 150, 300]) {
    final navigators = <GlobalKey<NavigatorState>>[];
    final destinations = <Widget>[];
    final stage = elapsed < 0 ? 'resting' : '${elapsed}ms';
    await goldenTest(
      'when surfaces transform at $stage, it should show coordinated outlines and content handoff',
      fileName: 'mateo_surface_animation_$stage',
      pumpBeforeTest: (tester) async {
        await tester.pumpAndSettle();
        if (elapsed < 0) return;
        for (var i = 0; i < navigators.length; i++) {
          navigators[i].currentState!.push<void>(surfaceTransformRoute(destinations[i]));
        }
        await tester.pump();
        await tester.pump();
        await tester.pump(Duration(milliseconds: elapsed));
        if (elapsed == 300) await tester.pumpAndSettle();
      },
      builder: () {
        navigators.clear();
        destinations.clear();
        final theme = surfaceTransformTheme;
        return GoldenTestGroup(
          columns: 3,
          children: [
            for (final (name, sourceShape, destinationShape, viewShape, view) in [
              (
                'Capsule to rounded',
                const MateoSurfaceShape.capsule(),
                const MateoSurfaceShape.none(),
                const MateoViewSurfaceShape.rounded(radius: 28),
                true,
              ),
              (
                'Rounded to rectangle',
                const MateoSurfaceShape.rounded(radius: 16),
                const MateoSurfaceShape.none(),
                const MateoViewSurfaceShape.none(),
                true,
              ),
              (
                'Rounded to capsule',
                const MateoSurfaceShape.rounded(radius: 12),
                const MateoSurfaceShape.capsule(),
                const MateoViewSurfaceShape.none(),
                false,
              ),
            ])
              GoldenTestScenario(
                name: name,
                child: SizedBox(
                  width: 300,
                  height: 340,
                  child: Builder(
                    builder: (context) {
                      final navigatorKey = GlobalKey<NavigatorState>();
                      navigators.add(navigatorKey);
                      destinations.add(
                        surfaceTransformEndpoint(
                          bounds: const Rect.fromLTWH(20, 20, 260, 300),
                          shape: destinationShape,
                          viewShape: viewShape,
                          view: view,
                          color: theme.colorScheme.inverse.background,
                          child: Center(
                            child: Text('Details', style: TextStyle(color: theme.colorScheme.inverse.onBackground)),
                          ),
                        ),
                      );
                      return ClipRect(
                        child: MateoApp(
                          theme: theme,
                          navigatorKey: navigatorKey,
                          home: surfaceTransformEndpoint(
                            bounds: const Rect.fromLTWH(24, 24, 160, 64),
                            shape: sourceShape,
                            color: theme.colorScheme.accent,
                            elevation: MateoElevation(level: 1),
                            child: Center(
                              child: Text('Open', style: TextStyle(color: theme.colorScheme.onAccent)),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
