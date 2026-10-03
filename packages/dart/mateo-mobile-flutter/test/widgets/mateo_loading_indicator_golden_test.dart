import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

final _theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);

Widget _matrix({required bool reduced}) => MateoTheme(
  data: _theme,
  child: ColoredBox(
    color: _theme.colorScheme.background,
    child: MediaQuery(
      data: MediaQueryData(disableAnimations: reduced),
      child: GoldenTestGroup(
        columns: 2,
        children: [
          for (final (name, presentation) in <(String, MateoLoadingIndicatorPresentation)>[
            ('Circular default', .circular(color: _theme.colorScheme.accent)),
            ('Dots default', .dots(color: _theme.colorScheme.accent)),
            ('Circular compact', .circular(color: _theme.colorScheme.accent, size: 16)),
            ('Dots button', .dots(color: _theme.colorScheme.accent, height: 12)),
            ('Circular large', .circular(color: _theme.colorScheme.accent, size: 48)),
            ('Dots large', .dots(color: _theme.colorScheme.accent, height: 32)),
            (
              'Circular custom',
              .circular(
                color: _theme.colorScheme.text.primary,
              ),
            ),
            ('Dots custom', .dots(color: _theme.colorScheme.text.primary)),
          ])
            GoldenTestScenario(
              name: name,
              child: ColoredBox(
                color: _theme.colorScheme.background,
                child: SizedBox(
                  width: 180,
                  height: 80,
                  child: Center(child: MateoLoadingIndicator(presentation: presentation)),
                ),
              ),
            ),
        ],
      ),
    ),
  ),
);

Future<void> main() async {
  await goldenTest(
    'when motion is reduced, it should show stationary activity in each appearance',
    fileName: 'mateo_loading_indicator_stationary',
    builder: () => _matrix(reduced: true),
  );
  for (final milliseconds in [200, 600]) {
    await goldenTest(
      'when animation reaches $milliseconds milliseconds, it should preserve each presentation shape',
      fileName: 'mateo_loading_indicator_$milliseconds',
      builder: () => _matrix(reduced: false),
      pumpBeforeTest: (tester) async {
        await tester.pump();
        await tester.pump(Duration(milliseconds: milliseconds));
      },
    );
  }
}
