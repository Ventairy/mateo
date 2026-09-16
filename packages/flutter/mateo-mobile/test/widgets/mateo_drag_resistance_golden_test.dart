import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

Future<void> main() async {
  for (final active in [false, true]) {
    await goldenTest(
      'when drag resistance is ${active ? 'active' : 'resting'}, it should follow configured directions',
      fileName: 'mateo_drag_resistance_${active ? 'active' : 'resting'}',
      builder: () {
        final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
        Widget scenario(String name, MateoDragResistanceConfig resistance, {bool reduced = false}) =>
            GoldenTestScenario(
              name: name,
              child: MediaQuery(
                data: MediaQueryData(disableAnimations: reduced),
                child: Padding(
                  padding: const .all(24),
                  child: MateoDragResistance.driven(
                    resistance: resistance,
                    dragOffset: active ? const Offset(192, -192) : .zero,
                    child: ColoredBox(
                      color: theme.colorScheme.accent,
                      child: Padding(
                        padding: const .all(20),
                        child: Text('Boundary', style: TextStyle(color: theme.colorScheme.onAccent)),
                      ),
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
              columns: 2,
              children: [
                scenario('All directions', const .all(6)),
                scenario('Horizontal', const .symmetric(horizontal: 6)),
                scenario('Top only', const .only(top: 6)),
                scenario('Asymmetric', const .only(top: 4, right: 8)),
                scenario('Disabled', .zero),
                scenario('Reduced motion', const .all(6), reduced: true),
              ],
            ),
          ),
        );
      },
    );
  }
}
