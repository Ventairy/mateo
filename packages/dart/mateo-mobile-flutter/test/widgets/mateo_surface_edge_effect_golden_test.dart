import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

Future<void> main() async {
  for (final scrolled in [false, true]) {
    await goldenTest(
      'when surface fades are ${scrolled ? 'scrolled' : 'resting'}, it should contain content and preserve outer shadows',
      fileName: 'mateo_surface_edge_effect_${scrolled ? 'scrolled' : 'resting'}',
      pumpBeforeTest: (tester) async {
        await tester.pumpAndSettle();
        if (scrolled) {
          for (final view in tester.widgetList<CustomScrollView>(find.byType(CustomScrollView))) {
            view.controller!.jumpTo(72);
          }
          await tester.pumpAndSettle();
        }
      },
      builder: () {
        final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
        return MateoTheme(
          data: theme,
          child: ColoredBox(
            color: theme.colorScheme.background,
            child: GoldenTestGroup(
              columns: 3,
              children: [
                for (final scrollable in [false, true])
                  for (final opacity in [1.0, .5, 0.0])
                    GoldenTestScenario(
                      name: '${scrollable ? 'Scrollable' : 'Ordinary'} / opacity $opacity',
                      child: Padding(
                        padding: const .all(40),
                        child: ColoredBox(
                          color: theme.colorScheme.accent,
                          child: scrollable
                              ? MateoSurface.scrollable(
                                  width: const .custom(160),
                                  height: const .custom(200),
                                  shape: const .capsule(),
                                  elevation: MateoElevation(level: 1),
                                  color: theme.colorScheme.background.withValues(alpha: opacity),
                                  edgeEffect: .fade(),
                                  child: _content(theme, 12),
                                )
                              : MateoSurface(
                                  width: const .custom(160),
                                  height: const .custom(200),
                                  shape: const .capsule(),
                                  elevation: MateoElevation(level: 1),
                                  color: theme.colorScheme.background.withValues(alpha: opacity),
                                  edgeEffect: .fade(),
                                  child: _content(theme, 5),
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
}

Widget _content(MateoThemeData theme, int count) => Column(
  children: [
    for (var index = 0; index < count; index++)
      SizedBox(
        height: 40,
        child: ColoredBox(
          color: index.isEven ? theme.colorScheme.inverse.background : theme.colorScheme.accent,
          child: Center(
            child: Text('Item ${index + 1}', style: TextStyle(color: theme.colorScheme.onAccent)),
          ),
        ),
      ),
  ],
);
