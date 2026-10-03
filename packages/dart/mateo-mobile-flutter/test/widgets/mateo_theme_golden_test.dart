import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

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
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 18, height: 1.4),
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
                              const Text('Simple, warm, human.'),
                              Text('Supporting text', style: TextStyle(color: colors.text.secondary)),
                              const SizedBox(height: 16),
                              ColoredBox(
                                color: colors.accent,
                                child: Padding(
                                  padding: const .all(12),
                                  child: Text('Accent surface', style: TextStyle(color: colors.onAccent)),
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
                                      Text('Inverse surface', style: TextStyle(color: colors.inverse.onBackground)),
                                      Text('Inverse accent', style: TextStyle(color: colors.inverse.accent)),
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
