import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

Future<void> main() async {
  for (final (name, keyboard, scrolled) in [
    ('reserved', false, false),
    ('keyboard', true, false),
    ('scrolled', false, true),
    ('keyboard_scrolled', true, true),
  ]) {
    await goldenTest(
      'when the footer is $name, it should coordinate with the header and content',
      fileName: 'mateo_view_footer_$name',
      pumpBeforeTest: (tester) async {
        await tester.pumpAndSettle();
        if (scrolled) {
          final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!;
          controller.jumpTo(controller.position.maxScrollExtent);
          await tester.pumpAndSettle();
        }
      },
      builder: () {
        final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
        return MateoTheme(
          data: theme,
          child: Directionality(
            textDirection: .ltr,
            child: MediaQuery(
              data: MediaQueryData(
                size: const Size(360, 400),
                padding: const .only(top: 24, bottom: 16),
                viewInsets: .only(bottom: keyboard ? 140 : 0),
              ),
              child: SizedBox(
                width: 360,
                height: 400,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: MateoView(
                        header: const MateoViewHeader(principal: Text('Your selection')),
                        footer: MateoViewFooter(
                          principal: ColoredBox(
                            color: theme.colorScheme.accent,
                            child: Padding(
                              padding: const .all(12),
                              child: Text('Continue', style: TextStyle(color: theme.colorScheme.onAccent)),
                            ),
                          ),
                        ),
                        surface: scrolled
                            ? MateoViewSurface.scrollable(
                                child: Column(
                                  crossAxisAlignment: .stretch,
                                  children: [
                                    for (var i = 0; i < 8; i++)
                                      SizedBox(height: 70, child: Center(child: Text('Item ${i + 1}'))),
                                  ],
                                ),
                              )
                            : MateoViewSurface(
                                child: ColoredBox(
                                  color: theme.palette.neutral[3],
                                  child: const Column(children: [Text('Content start'), Spacer(), Text('Content end')]),
                                ),
                              ),
                      ),
                    ),
                    if (keyboard)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: 140,
                        child: ColoredBox(
                          color: theme.palette.neutral[5],
                          child: const Center(child: Text('Keyboard')),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
