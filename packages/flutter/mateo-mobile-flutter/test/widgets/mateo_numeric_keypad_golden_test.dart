import 'package:alchemist/alchemist.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

class _MaterialLocalizationsDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  const _MaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    return SynchronousFuture(const DefaultMaterialLocalizations());
  }

  @override
  bool shouldReload(_MaterialLocalizationsDelegate old) => false;
}

class _KeypadGoldenHarness extends StatefulWidget {
  const _KeypadGoldenHarness({
    required this.locale,
    this.initialText,
    this.textScaler = TextScaler.noScaling,
    this.showInput = true,
  });

  final Locale locale;
  final String? initialText;
  final TextScaler textScaler;
  final bool showInput;

  @override
  State<_KeypadGoldenHarness> createState() => _KeypadGoldenHarnessState();
}

class _KeypadGoldenHarnessState extends State<_KeypadGoldenHarness> {
  late final MateoTextInputController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MateoTextInputController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: widget.locale,
      delegates: const [_MaterialLocalizationsDelegate()],
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: widget.textScaler),
        child: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showInput)
                MateoTextInput(
                  placeholder: 'Amount',
                  variant: MateoTextInputVariant.quiet,
                  controller: _controller,
                  keyboardType: TextInputType.none,
                  onChanged: (_) {},
                ),
              MateoNumericKeypad(
                controllers: [_controller],
                variant: MateoNumericKeypadVariant.monetary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  group('MateoNumericKeypad Golden Tests', () {
    goldenTest(
      'when rendering localized and enlarged states, it should match the approved goldens',
      fileName: 'mateo_numeric_keypad_states',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(width: 392),
        children: [
          GoldenTestScenario(
            name: 'English',
            child: const _KeypadGoldenHarness(
              locale: Locale('en', 'US'),
              initialText: '1200.50',
            ),
          ),
          GoldenTestScenario(
            name: 'Portuguese',
            child: const _KeypadGoldenHarness(
              locale: Locale('pt', 'BR'),
              initialText: '1200,50',
            ),
          ),
          GoldenTestScenario(
            name: 'enlarged text',
            child: const _KeypadGoldenHarness(
              locale: Locale('en', 'US'),
              textScaler: TextScaler.linear(1.6),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'when a key is pressed, it should match the approved golden',
      fileName: 'mateo_numeric_keypad_pressed',
      whilePerforming: (tester) async {
        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(const Key('mateo_numeric_keypad_five'))),
        );
        await tester.pump(const Duration(milliseconds: 120));
        addTearDown(gesture.removePointer);
        return null;
      },
      builder: () => const SizedBox(
        width: 360,
        child: _KeypadGoldenHarness(
          locale: Locale('en', 'US'),
          showInput: false,
        ),
      ),
    );
  });
}
