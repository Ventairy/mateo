import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/surface_transform_test_widgets.dart';

Future<void> main() async {
  for (final elapsed in [0, 60, 120, 180, 300, 400]) {
    await goldenTest(
      'pop at $elapsed ms keeps content and shadow attached',
      fileName: 'mateo_surface_pop_${elapsed}ms',
      pumpBeforeTest: (tester) async {
        await tester.pump();
        await tester.pump(Duration(milliseconds: elapsed));
      },
      builder: () => GoldenTestGroup(
        columns: 2,
        children: [
          for (final reduced in [false, true])
            GoldenTestScenario(
              name: reduced ? 'Reduced motion' : 'Pop',
              child: MateoTheme(
                data: surfaceTransformTheme,
                child: MediaQuery(
                  data: MediaQueryData(disableAnimations: reduced),
                  child: SizedBox(
                    width: 280,
                    height: 180,
                    child: Center(
                      child: MateoSurface(
                        animation: const .pop(),
                        width: const .custom(220),
                        height: const .custom(110),
                        shape: const .rounded(radius: 24),
                        elevation: MateoElevation(level: 1),
                        color: surfaceTransformTheme.colorScheme.accent,
                        child: Center(
                          child: Text('Welcome', style: TextStyle(color: surfaceTransformTheme.colorScheme.onAccent)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
