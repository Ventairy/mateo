import 'package:alchemist/alchemist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

Future<void> main() async {
  await goldenTest(
    'when filled treatments are elevated, they should show themed backgrounds and unclipped shadows',
    fileName: 'mateo_text_input_treatments_elevation',
    builder: () => Localizations(
      locale: const Locale('en'),
      delegates: const [GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
      child: MateoTheme(
        data: MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white),
        child: Builder(
          builder: (context) => ColoredBox(
            color: MateoTheme.of(context).palette.neutral[2],
            child: GoldenTestGroup(
              columns: 3,
              children: [
                for (final variant in [MateoTextInputVariant.filled.neutral, MateoTextInputVariant.filled.base])
                  for (final elevation in [0.0, 0.75, 2.0])
                    for (final enabled in [true, false])
                      GoldenTestScenario(
                        name: '$variant / $elevation / ${enabled ? 'enabled' : 'disabled'}',
                        child: Padding(
                          padding: const EdgeInsets.all(48),
                          child: SizedBox(
                            width: 280,
                            child: MateoTextInput(
                              autofocus: false,
                              placeholder: 'Search places',
                              presentation: .search(variant: variant, elevation: elevation),
                              onChanged: enabled ? (_) {} : null,
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
  );
  for (final position in ['start', 'partial', 'middle', 'end']) {
    await goldenTest(
      'when long search text is at $position, it should fade beneath both fixed icons',
      fileName: 'mateo_text_input_fade_$position',
      pumpBeforeTest: (tester) async {
        await tester.pumpAndSettle();
        for (final state in tester.stateList<EditableTextState>(find.byType(EditableText))) {
          final offset = state.renderEditable.offset as ScrollPosition;
          offset.jumpTo(switch (position) {
            'partial' => 2,
            'middle' => offset.maxScrollExtent / 2,
            'end' => offset.maxScrollExtent,
            _ => 0,
          });
        }
        await tester.pumpAndSettle();
      },
      builder: () => Localizations(
        locale: const Locale('en'),
        delegates: const [GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
        child: MateoTheme(
          data: MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white),
          child: ColoredBox(
            color: MateoPalette().white,
            child: GoldenTestGroup(
              columns: 2,
              children: [
                for (final size in MateoTextInputSize.values)
                  for (final direction in TextDirection.values)
                    GoldenTestScenario(
                      name: '${size.name} / ${direction.name}',
                      child: Builder(
                        builder: (context) {
                          final controller = TextEditingController(
                            text: 'Coffee shops and bakeries nearby with outdoor seating',
                          );
                          addTearDown(controller.dispose);
                          return Directionality(
                            textDirection: direction,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SizedBox(
                                width: 280,
                                child: MateoTextInput(
                                  autofocus: false,
                                  placeholder: 'Search places',
                                  controller: controller,
                                  presentation: .search(variant: .filled, size: size),
                                  onChanged: (_) {},
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  await goldenTest(
    'when search inputs are empty, populated, or disabled, they should show the filled treatment at both sizes',
    fileName: 'mateo_text_input',
    builder: () => Localizations(
      locale: const Locale('en'),
      delegates: const [GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
      child: MateoTheme(
        data: MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white),
        child: ColoredBox(
          color: MateoPalette().white,
          child: GoldenTestGroup(
            columns: 3,
            children: [
              for (final size in MateoTextInputSize.values)
                for (final state in ['empty', 'populated', 'disabled'])
                  GoldenTestScenario(
                    name: '${size.name} / $state',
                    child: Builder(
                      builder: (context) {
                        final controller = TextEditingController(text: state == 'populated' ? 'Coffee nearby' : '');
                        addTearDown(controller.dispose);
                        return SizedBox(
                          width: 320,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: MateoTextInput(
                              autofocus: false,
                              placeholder: 'Search places',
                              controller: controller,
                              presentation: .search(variant: .filled, size: size),
                              onChanged: state == 'disabled' ? null : (_) {},
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            ],
          ),
        ),
      ),
    ),
  );
}
