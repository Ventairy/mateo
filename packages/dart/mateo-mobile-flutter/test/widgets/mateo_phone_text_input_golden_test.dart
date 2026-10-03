import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

final _theme = MateoThemeData.light(
  accentColor: const Color(0xFFFF4A4B),
  onAccent: MateoPalette().white,
);

Completer<void>? _nextCountryPickerRoutePush;

class _CountryPickerNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final completion = _nextCountryPickerRoutePush;
    _nextCountryPickerRoutePush = null;
    completion?.complete();
  }
}

Future<void> main() async {
  await goldenTest(
    'phone inputs keep the country selector distinct from their plain editor',
    fileName: 'mateo_phone_text_input',
    builder: () => MateoTheme(
      data: _theme,
      child: ColoredBox(
        color: _theme.colorScheme.background,
        child: GoldenTestGroup(
          columns: 3,
          children: [
            GoldenTestScenario(
              name: 'Brazil empty',
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: 300,
                  child: MateoTextInput(
                    autofocus: false,
                    placeholder: 'Phone number',
                    presentation: const .phone(initialCountry: .brazil),
                    onChanged: (_) {},
                  ),
                ),
              ),
            ),
            GoldenTestScenario(
              name: 'United States populated',
              child: Builder(
                builder: (context) {
                  final controller = TextEditingController(text: '2025550123');
                  addTearDown(controller.dispose);
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: 300,
                      child: MateoTextInput(
                        autofocus: false,
                        controller: controller,
                        placeholder: 'Phone number',
                        presentation: const .phone(initialCountry: Country.unitedStates),
                        onChanged: (_) {},
                      ),
                    ),
                  );
                },
              ),
            ),
            GoldenTestScenario(
              name: 'Large plain',
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: 300,
                  child: MateoTextInput(
                    autofocus: false,
                    placeholder: 'Phone number',
                    presentation: const .phone(initialCountry: .brazil, size: .large),
                    onChanged: (_) {},
                  ),
                ),
              ),
            ),
            GoldenTestScenario(
              name: 'Small disabled',
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: SizedBox(
                  width: 300,
                  child: MateoTextInput(
                    autofocus: false,
                    placeholder: 'Phone number',
                    presentation: .phone(initialCountry: .brazil, size: .small),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  await goldenTest(
    'phone country selection uses a searchable bottom sheet',
    fileName: 'mateo_phone_country_picker',
    pumpBeforeTest: (tester) async {
      await tester.pumpAndSettle();
      final routePushed = Completer<void>();
      _nextCountryPickerRoutePush = routePushed;
      await tester.tap(find.byType(MateoCountryFlag));
      for (var attempt = 0; attempt < 500 && !routePushed.isCompleted; attempt++) {
        await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 10)));
        await tester.pump();
      }
      expect(routePushed.isCompleted, isTrue);
      await tester.pumpAndSettle();
    },
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'Portuguese country picker',
          child: SizedBox(
            width: 390,
            height: 700,
            child: MateoApp(
              theme: _theme,
              navigatorObservers: [_CountryPickerNavigatorObserver()],
              locale: const Locale('pt', 'BR'),
              supportedLocales: const [Locale('en', 'US'), Locale('pt', 'BR')],
              home: Center(
                child: SizedBox(
                  width: 350,
                  child: MateoTextInput(
                    autofocus: false,
                    placeholder: 'Número',
                    presentation: const .phone(initialCountry: .brazil),
                    onChanged: (_) {},
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
