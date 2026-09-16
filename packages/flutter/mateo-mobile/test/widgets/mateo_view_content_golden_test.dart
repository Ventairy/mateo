import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

Future<void> main() async {
  for (final scrolled in [false, true]) {
    await goldenTest(
      'when content ${scrolled ? 'scrolls' : 'rests'}, it should respect the fixed header',
      fileName: scrolled ? 'mateo_view_content_scrolled' : 'mateo_view_content_rest',
      pumpBeforeTest: (tester) async {
        await tester.pumpAndSettle();
        if (scrolled) {
          tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!.jumpTo(120);
          await tester.pumpAndSettle();
        }
      },
      builder: () {
        final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
        return Directionality(
          textDirection: .ltr,
          child: MediaQuery(
            data: const MediaQueryData(size: Size(360, 400), padding: EdgeInsets.only(top: 24)),
            child: MateoTheme(
              data: theme,
              child: SizedBox(
                width: 360,
                height: 400,
                child: MateoView(
                  header: const MateoViewHeader(principal: Text('Messages')),
                  surface: MateoViewSurface.scrollable(
                    child: Column(
                      crossAxisAlignment: .stretch,
                      children: [
                        for (var i = 0; i < 8; i++)
                          Padding(
                            padding: const .only(bottom: 12),
                            child: SizedBox(
                              height: 60,
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
            ),
          ),
        );
      },
    );
  }
}
