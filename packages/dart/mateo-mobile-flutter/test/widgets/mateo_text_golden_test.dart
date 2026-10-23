import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

Future<void> main() async {
  await AlchemistConfig.runWithConfig(
    config: const AlchemistConfig(
      platformGoldensConfig: PlatformGoldensConfig(enabled: false),
      ciGoldensConfig: CiGoldensConfig(obscureText: false),
    ),
    run: () async => goldenTest(
      'interface and decorative faces retain accents and natural metrics at accessible sizes',
      fileName: 'mateo_text',
      builder: () {
        final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
        return MateoTheme(
          data: theme,
          child: ColoredBox(
            color: theme.colorScheme.background,
            child: GoldenTestGroup(
              columns: 2,
              children: [
                for (final scale in [1.0, 2.0])
                  for (final (name, presentation) in <(String, MateoTextPresentation)>[
                    ('Interface', const .interface(fontSize: 20, fontWeight: .w600, height: 1.3)),
                    ('Rounded', const .decorative(variant: .rounded, fontSize: 32)),
                    ('Cursive', const .decorative(variant: .cursive, fontSize: 32)),
                  ])
                    GoldenTestScenario(
                      name: '$name · ${scale}x',
                      child: MediaQuery(
                        data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                        child: SizedBox(
                          width: 380,
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: MateoText('Olá, coração!\nAção e café.', presentation: presentation),
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
