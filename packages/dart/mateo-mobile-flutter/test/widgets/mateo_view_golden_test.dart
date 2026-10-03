import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

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
                    header: const MateoViewHeader(principal: Text('Header')),
                    footer: const MateoViewFooter(principal: Text('Footer')),
                    surface: const MateoViewSurface(child: Center(child: Text('Surface'))),
                    overlay: ColoredBox(
                      color: theme.colorScheme.accent.withValues(alpha: 0.5),
                      child: Center(
                        child: Text('Overlay', style: TextStyle(color: theme.colorScheme.onAccent)),
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
                        child: Text('Welcome', style: TextStyle(color: theme.colorScheme.onAccent)),
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
                                    child: Text('Item ${i + 1}', style: TextStyle(color: theme.colorScheme.onAccent)),
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
}
