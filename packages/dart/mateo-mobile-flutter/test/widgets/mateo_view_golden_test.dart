import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/surface_transform_test_widgets.dart' show surfaceTransformTheme;

Future<void> main() async {
  await goldenTest(
    'when hosting surfaces, it should display their appearance across the view',
    fileName: 'mateo_view',
    builder: () {
      final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
      return MateoTheme(
        data: theme,
        child: ColoredBox(
          color: theme.colorScheme.background,
          child: GoldenTestGroup(
            columns: 2,
            children: [
              GoldenTestScenario(
                name: 'Overlay above fixed controls',
                child: SizedBox(
                  width: 240,
                  height: 320,
                  child: MateoView(
                    header: const MateoViewHeader(
                      principal: MateoText(
                        'Header',
                        presentation: .interface(),
                      ),
                    ),
                    footer: const MateoViewFooter(
                      principal: MateoText(
                        'Footer',
                        presentation: .interface(),
                      ),
                    ),
                    surface: const MateoViewSurface(
                      child: Center(
                        child: MateoText(
                          'Surface',
                          presentation: .interface(),
                        ),
                      ),
                    ),
                    overlay: ColoredBox(
                      color: theme.colorScheme.accent.withValues(alpha: 0.5),
                      child: Center(
                        child: MateoText(
                          'Overlay',
                          presentation: MateoTextPresentation.interface(color: theme.colorScheme.onAccent),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'Ordinary surface',
                child: SizedBox(
                  width: 240,
                  height: 320,
                  child: MateoView(
                    surface: MateoViewSurface(
                      color: theme.colorScheme.accent,
                      padding: const .all(24),
                      child: Center(
                        child: MateoText(
                          'Welcome',
                          presentation: MateoTextPresentation.interface(color: theme.colorScheme.onAccent),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'Scrollable surface',
                child: SizedBox(
                  width: 240,
                  height: 320,
                  child: MateoView(
                    surface: MateoViewSurface.scrollable(
                      padding: const .all(20),
                      child: Column(
                        crossAxisAlignment: .stretch,
                        children: [
                          for (var i = 0; i < 6; i++)
                            Padding(
                              padding: const .only(bottom: 12),
                              child: SizedBox(
                                height: 64,
                                child: ColoredBox(
                                  color: theme.colorScheme.accent,
                                  child: Center(
                                    child: MateoText(
                                      'Item ${i + 1}',
                                      presentation: MateoTextPresentation.interface(color: theme.colorScheme.onAccent),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  await goldenTest(
    'when a rounded view has an opaque, translucent or transparent fill, it should preserve its outline and elevation',
    fileName: 'mateo_view_rounded_background_alpha',
    builder: () => MateoTheme(
      data: surfaceTransformTheme,
      child: GoldenTestGroup(
        columns: 3,
        children: [
          for (final (label, alpha) in [('Opaque', 1.0), ('Translucent', .5), ('Transparent', 0.0)])
            GoldenTestScenario(
              name: label,
              child: Directionality(
                textDirection: .ltr,
                child: SizedBox(
                  width: 240,
                  height: 220,
                  child: Stack(
                    fit: .expand,
                    children: [
                      Row(
                        crossAxisAlignment: .stretch,
                        children: [
                          Expanded(child: ColoredBox(color: surfaceTransformTheme.colorScheme.accent)),
                          Expanded(child: ColoredBox(color: surfaceTransformTheme.colorScheme.inverse.background)),
                        ],
                      ),
                      Padding(
                        padding: const .all(32),
                        child: MateoView(
                          padding: .zero,
                          surface: MateoViewSurface(
                            color: surfaceTransformTheme.colorScheme.background.withValues(alpha: alpha),
                            shape: const .rounded(radius: 32),
                            elevation: .new(level: 1),
                            child: const SizedBox.expand(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
