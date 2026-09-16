import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

Future<void> main() async {
  await goldenTest(
    'when varied content passes under a header, it should protect titles and smoothly reveal content below',
    fileName: 'mateo_view_surface_header_fade',
    pumpBeforeTest: (tester) async {
      await tester.pumpAndSettle();
      for (final view in tester.widgetList<CustomScrollView>(find.byType(CustomScrollView))) {
        view.controller!.jumpTo(160);
      }
      await tester.pumpAndSettle();
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
              for (final transparent in [false, true])
                for (final pattern in ['Text', 'Blocks', 'Color'])
                  GoldenTestScenario(
                    name: '$pattern / ${transparent ? 'Transparent' : 'Opaque'}',
                    child: Padding(
                      padding: const .all(24),
                      child: ColoredBox(
                        color: theme.colorScheme.accent,
                        child: SizedBox(
                          width: 260,
                          height: 300,
                          child: MateoView(
                            padding: const .symmetric(horizontal: 12, vertical: 16),
                            header: MateoViewHeader(
                              principal: Text(
                                'Your collection\nSaved for later',
                                textAlign: .center,
                                style: TextStyle(color: theme.colorScheme.text.primary, fontSize: 20),
                              ),
                            ),
                            surface: MateoViewSurface.scrollable(
                              edgeEffect: .fade(at: const [.top]),
                              color: transparent ? const Color(0x00000000) : theme.colorScheme.background,
                              shape: const .none(),
                              padding: EdgeInsets.zero,
                              child: Column(
                                crossAxisAlignment: .stretch,
                                children: [
                                  for (var i = 0; i < 24; i++)
                                    SizedBox(
                                      height: 30,
                                      child: ColoredBox(
                                        color: pattern == 'Text'
                                            ? theme.colorScheme.background
                                            : pattern == 'Blocks'
                                            ? (i.isEven
                                                  ? theme.colorScheme.inverse.background
                                                  : theme.colorScheme.background)
                                            : (i.isEven
                                                  ? theme.colorScheme.accent
                                                  : theme.colorScheme.inverse.background),
                                        child: pattern == 'Text'
                                            ? Text(
                                                'Messages, ideas and places $i',
                                                style: TextStyle(color: theme.colorScheme.text.primary, fontSize: 18),
                                              )
                                            : Row(
                                                children: [
                                                  Expanded(
                                                    child: ColoredBox(
                                                      color: theme.colorScheme.accent,
                                                      child: const SizedBox.expand(),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Expanded(
                                                    child: ColoredBox(
                                                      color: theme.colorScheme.onAccent,
                                                      child: const SizedBox.expand(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                ],
                              ),
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
  await goldenTest(
    'when scrolling across the header gap, it should extend the same progressive fade',
    fileName: 'mateo_view_surface_header_fade_progress',
    pumpBeforeTest: (tester) async {
      await tester.pumpAndSettle();
      var index = 0;
      for (final view in tester.widgetList<CustomScrollView>(find.byType(CustomScrollView))) {
        view.controller!.jumpTo(const [0.0, 5.0, 10.0, 20.0][index++ % 4]);
      }
      await tester.pumpAndSettle();
    },
    builder: () {
      final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
      return MateoTheme(
        data: theme,
        child: GoldenTestGroup(
          columns: 4,
          children: [
            for (final transparent in [false, true])
              for (final distance in [0, 5, 10, 20])
                GoldenTestScenario(
                  name: '${transparent ? 'Mask' : 'Overlay'} / $distance px',
                  child: Padding(
                    padding: const .all(16),
                    child: ColoredBox(
                      color: theme.colorScheme.accent,
                      child: SizedBox(
                        width: 220,
                        height: 280,
                        child: MateoView(
                          padding: EdgeInsets.zero,
                          header: MateoViewHeader(
                            principal: SizedBox(
                              height: 80,
                              child: Center(
                                child: Text('Your collection', style: TextStyle(color: theme.colorScheme.text.primary)),
                              ),
                            ),
                          ),
                          surface: MateoViewSurface.scrollable(
                            color: transparent ? const Color(0x00000000) : theme.colorScheme.background,
                            edgeEffect: .fade(at: const [.top]),
                            child: Column(
                              children: [
                                for (var i = 0; i < 12; i++)
                                  SizedBox(
                                    height: 40,
                                    child: ColoredBox(
                                      color: i.isEven
                                          ? theme.colorScheme.inverse.background
                                          : theme.colorScheme.background,
                                      child: const SizedBox.expand(),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          ],
        ),
      );
    },
  );
}
