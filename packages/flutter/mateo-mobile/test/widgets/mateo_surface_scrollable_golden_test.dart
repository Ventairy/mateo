import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

Future<void> main() async {
  for (final scrolled in [false, true]) {
    await goldenTest(
      'when ${scrolled ? 'scrolled' : 'resting'}, it should keep the surface fixed around its viewport',
      fileName: scrolled ? 'mateo_surface_scrolled' : 'mateo_surface_scrollable',
      pumpBeforeTest: (tester) async {
        await tester.pumpAndSettle();
        if (scrolled) {
          for (final view in tester.widgetList<CustomScrollView>(find.byType(CustomScrollView))) {
            if (view.controller!.position.maxScrollExtent > 0) view.controller!.jumpTo(80);
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
              columns: 2,
              children: [
                for (final long in [false, true])
                  GoldenTestScenario(
                    name: long ? 'Overflow' : 'Flexible short content',
                    child: Padding(
                      padding: const .all(48),
                      child: MateoSurface.scrollable(
                        width: const .custom(200),
                        height: const .custom(240),
                        padding: const .all(20),
                        elevation: MateoElevation(level: 1),
                        shape: const .none(),
                        child: Column(
                          crossAxisAlignment: .stretch,
                          children: [
                            const Text('Your content'),
                            if (!long) const Spacer(),
                            for (var i = 0; i < (long ? 6 : 1); i++)
                              Padding(
                                padding: const .only(top: 12),
                                child: SizedBox(
                                  height: 52,
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
              ],
            ),
          ),
        );
      },
    );
  }
}
