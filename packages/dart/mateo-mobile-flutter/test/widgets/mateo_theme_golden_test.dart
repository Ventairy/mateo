import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/components/mateo_text/mateo_text.dart' show MateoTextScope;

Future<void> main() async {
  await goldenTest(
    'when inheriting Mateo colors and text, it should render default and custom appearances',
    fileName: 'mateo_theme',
    builder: () => GoldenTestGroup(
      columns: 2,
      children: [
        for (final (label, accent, foreground) in [
          ('Mateo', const Color(0xFF4A5CFF), MateoPalette().white),
          ('Custom accent', const Color(0xFFFFD000), MateoPalette().black),
        ])
          GoldenTestScenario(
            name: label,
            child: MateoTextScope(
              fontSize: 18,
              height: 1.4,
              child: MateoTheme(
                data: MateoThemeData.light(accentColor: accent, onAccent: foreground),
                child: Builder(
                  builder: (context) {
                    final colors = MateoTheme.of(context).colorScheme;
                    return ColoredBox(
                      color: colors.background,
                      child: SizedBox(
                        width: 280,
                        child: Padding(
                          padding: const .all(20),
                          child: Column(
                            mainAxisSize: .min,
                            crossAxisAlignment: .stretch,
                            children: [
                              const MateoText(
                                'Simple, warm, human.',
                                presentation: .interface(),
                              ),
                              MateoText(
                                'Supporting text',
                                presentation: MateoTextPresentation.interface(color: colors.text.secondary),
                              ),
                              const SizedBox(height: 16),
                              ColoredBox(
                                color: colors.accent,
                                child: Padding(
                                  padding: const .all(12),
                                  child: MateoText(
                                    'Accent surface',
                                    presentation: MateoTextPresentation.interface(color: colors.onAccent),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ColoredBox(
                                color: colors.inverse.background,
                                child: Padding(
                                  padding: const .all(12),
                                  child: Column(
                                    crossAxisAlignment: .start,
                                    mainAxisSize: .min,
                                    children: [
                                      MateoText(
                                        'Inverse surface',
                                        presentation: MateoTextPresentation.interface(
                                          color: colors.inverse.onBackground,
                                        ),
                                      ),
                                      MateoText(
                                        'Inverse accent',
                                        presentation: MateoTextPresentation.interface(color: colors.inverse.accent),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
