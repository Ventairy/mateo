import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

Future<void> main() async {
  // Alchemist's blocked-text repaint bypasses custom opacity layers.
  // Use the actual layer tree and bundled fonts for these feedback goldens.
  await AlchemistConfig.runWithConfig(
    config: AlchemistConfig.current().copyWith(
      ciGoldensConfig: const CiGoldensConfig(obscureText: false),
      goldenTestTheme: GoldenTestTheme(
        backgroundColor: GoldenTestTheme.standard().backgroundColor,
        borderColor: GoldenTestTheme.standard().borderColor,
        nameTextStyle: const TextStyle(fontFamily: MateoTypography.fontFamily, fontSize: 18),
      ),
    ),
    run: () async {
      for (final pressed in [false, true]) {
        await goldenTest(
          'when press controls are ${pressed ? 'held' : 'resting'}, it should display their feedback treatments',
          fileName: 'mateo_press_${pressed ? 'held' : 'resting'}',
          pumpBeforeTest: (tester) async {
            await tester.pumpAndSettle();
            if (pressed) {
              var pointer = 1;
              for (final finder in [
                for (final animation in MateoPressAnimationType.values) find.byKey(ValueKey(animation)),
                find.byKey(const ValueKey('disabled')),
                find.byKey(const ValueKey('reduced')),
              ]) {
                final gesture = await tester.startGesture(tester.getCenter(finder), pointer: pointer++);
                addTearDown(gesture.cancel);
              }
              await tester.pumpAndSettle();
            }
          },
          builder: () {
            final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
            Widget control(Key key, MateoPressAnimationType animation, {bool enabled = true}) => Padding(
              padding: const .all(24),
              child: MateoPress(
                key: key,
                animation: animation,
                onPressed: enabled ? (_) {} : null,
                child: ColoredBox(
                  color: theme.colorScheme.accent,
                  child: Padding(
                    padding: const .symmetric(horizontal: 24, vertical: 16),
                    child: Text(
                      'Open messages',
                      style: TextStyle(fontFamily: MateoTypography.fontFamily, color: theme.colorScheme.onAccent),
                    ),
                  ),
                ),
              ),
            );
            return MateoTheme(
              data: theme,
              child: ColoredBox(
                color: theme.colorScheme.background,
                child: GoldenTestGroup(
                  columns: 3,
                  children: [
                    for (final animation in MateoPressAnimationType.values)
                      GoldenTestScenario(name: animation.name, child: control(ValueKey(animation), animation)),
                    GoldenTestScenario(
                      name: 'Disabled',
                      child: control(const ValueKey('disabled'), .scale, enabled: false),
                    ),
                    GoldenTestScenario(
                      name: 'Reduced motion',
                      child: MediaQuery(
                        data: const MediaQueryData(disableAnimations: true),
                        child: control(const ValueKey('reduced'), .scaleFade),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    },
  );
}
