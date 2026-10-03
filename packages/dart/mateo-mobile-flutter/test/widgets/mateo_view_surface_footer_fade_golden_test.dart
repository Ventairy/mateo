import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

Future<void> main() async {
  await goldenTest(
    'when varied content passes under footer controls, it should smoothly reveal content at the footer top',
    fileName: 'mateo_view_surface_footer_fade',
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
                for (final pattern in ['Button', 'Search', 'Color'])
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
                            footer: MateoViewFooter(
                              principal: Container(
                                padding: const .symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.background,
                                  borderRadius: .circular(20),
                                ),
                                child: Text(
                                  pattern == 'Search' ? 'Search your collection' : 'Continue',
                                  textAlign: .center,
                                  style: TextStyle(color: theme.colorScheme.text.primary, fontSize: 20),
                                ),
                              ),
                            ),
                            surface: MateoViewSurface.scrollable(
                              edgeEffect: .fade(at: const [.bottom]),
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
}
