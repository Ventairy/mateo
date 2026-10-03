import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

Future<void> main() async {
  for (final scrolled in [false, true]) {
    await goldenTest(
      'when view fades are ${scrolled ? 'scrolled' : 'resting'}, it should preserve rounded containment and fixed controls',
      fileName: 'mateo_view_surface_edge_fade_${scrolled ? 'scrolled' : 'resting'}',
      pumpBeforeTest: (tester) async {
        await tester.pumpAndSettle();
        if (scrolled) {
          for (final view in tester.widgetList<CustomScrollView>(find.byType(CustomScrollView))) {
            view.controller!.jumpTo(120);
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
                        padding: const .all(32),
                        child: ColoredBox(
                          color: theme.colorScheme.accent,
                          child: SizedBox(
                            width: 240,
                            height: 320,
                            child: MateoView(
                              header: const MateoViewHeader(principal: Text('Header')),
                              footer: const MateoViewFooter(principal: Text('Footer')),
                              surface: scrollable
                                  ? MateoViewSurface.scrollable(
                                      edgeEffect: .fade(),
                                      color: theme.colorScheme.background.withValues(alpha: opacity),
                                      shape: const .none(),
                                      elevation: MateoElevation(level: 1),
                                      padding: EdgeInsets.zero,
                                      child: _content(theme, 12),
                                    )
                                  : MateoViewSurface(
                                      edgeEffect: .fade(),
                                      color: theme.colorScheme.background.withValues(alpha: opacity),
                                      shape: const .none(),
                                      elevation: MateoElevation(level: 1),
                                      padding: EdgeInsets.zero,
                                      child: _content(theme, 4),
                                    ),
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
}

Widget _content(MateoThemeData theme, int count) => Column(
  crossAxisAlignment: .stretch,
  children: [
    for (var index = 0; index < count; index++)
      if (count > 4) SizedBox(height: 48, child: _item(theme, index)) else Expanded(child: _item(theme, index)),
  ],
);

Widget _item(MateoThemeData theme, int index) => ColoredBox(
  color: index.isEven ? theme.colorScheme.inverse.background : theme.colorScheme.accent,
  child: Center(
    child: Text('Item ${index + 1}', style: TextStyle(color: theme.colorScheme.onAccent)),
  ),
);
