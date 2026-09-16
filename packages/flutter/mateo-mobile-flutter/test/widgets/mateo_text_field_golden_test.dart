import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

void main() {
  group('MateoTextField Golden Tests', () {
    goldenTest(
      'when rendering filled visual states, it should match the approved golden',
      fileName: 'mateo_text_field_states',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(width: 320),
        children: [
          GoldenTestScenario(name: 'empty', child: _TextInputScenario()),
          GoldenTestScenario(
            name: 'filled',
            child: _TextInputScenario(initialText: 'mateo@example.com'),
          ),
          GoldenTestScenario(
            name: 'disabled',
            child: _TextInputScenario(isEnabled: false),
          ),
        ],
      ),
    );

    goldenTest(
      'when the filled input is focused, it should match the approved golden',
      fileName: 'mateo_text_field_focused',
      whilePerforming: (tester) async {
        await tester.tap(find.byType(TextField));
        await tester.pump(const Duration(milliseconds: 100));
        return null;
      },
      builder: () => const SizedBox(width: 320, child: _TextInputScenario()),
    );

    goldenTest(
      'when the character limit is exceeded, it should match the approved golden',
      fileName: 'mateo_text_field_limit_feedback',
      whilePerforming: (tester) async {
        await tester.enterText(find.byType(TextField), 'Mateo');
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 40));
        return null;
      },
      builder: () => const SizedBox(width: 320, child: _TextInputScenario(maxLength: 3)),
    );

    goldenTest(
      'when rendering search visual states, it should match the approved golden',
      fileName: 'mateo_text_field_search_states',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(width: 400),
        children: [
          GoldenTestScenario(
            name: 'resting',
            child: const _TextInputScenario(
              placeholder: 'Rua Oscar Freire; liberdade',
              presentation: MateoTextFieldPresentation.search(variant: .floating),
            ),
          ),
          GoldenTestScenario(
            name: 'typed',
            child: const _TextInputScenario(
              initialText: 'Rua Orindiúva 45',
              placeholder: 'Search places',
              presentation: MateoTextFieldPresentation.search(variant: .floating),
            ),
          ),
          GoldenTestScenario(
            name: 'disabled',
            child: const _TextInputScenario(
              placeholder: 'Search places',
              presentation: MateoTextFieldPresentation.search(variant: .floating),
              isEnabled: false,
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'when the search input is focused without text, it should match the approved golden',
      fileName: 'mateo_text_field_search_focused',
      whilePerforming: (tester) async {
        await tester.tap(find.byType(TextField));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 240));
        return null;
      },
      builder: () => const SizedBox(
        width: 400,
        child: _TextInputScenario(
          placeholder: 'Search places',
          presentation: MateoTextFieldPresentation.search(variant: .floating),
        ),
      ),
    );

    goldenTest(
      'when search text overflows, it should fade beneath the leading control',
      fileName: 'mateo_text_field_search_overflow',
      whilePerforming: (tester) async {
        await tester.enterText(
          find.byType(TextField),
          'Rua Oscar Freire, Liberdade, São Paulo, Brasil',
        );
        await tester.pumpAndSettle();
        return null;
      },
      builder: () => const SizedBox(
        width: 280,
        child: _TextInputScenario(
          placeholder: 'Search places',
          presentation: MateoTextFieldPresentation.search(variant: .floating),
        ),
      ),
    );

    goldenTest(
      'when overflowing search text is selected, it should fade the selection beneath the leading control',
      fileName: 'mateo_text_field_search_overflow_selection',
      whilePerforming: (tester) async {
        await tester.tap(find.byType(TextField));
        final controller = tester.widget<TextField>(find.byType(TextField)).controller!;
        controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: controller.text.length,
        );
        await tester.pumpAndSettle();
        return null;
      },
      builder: () => const SizedBox(
        width: 280,
        child: _TextInputScenario(
          initialText: 'Rua Oscar Freire, Liberdade, São Paulo, Brasil',
          placeholder: 'Search places',
          presentation: MateoTextFieldPresentation.search(variant: .floating),
        ),
      ),
    );

    goldenTest(
      'when unfocused search text overflows, it should fade before the trailing control',
      fileName: 'mateo_text_field_search_overflow_trailing',
      builder: () => const SizedBox(
        width: 280,
        child: _TextInputScenario(
          initialText: 'Rua Oscar Freire, Liberdade, São Paulo, Brasil',
          placeholder: 'Search places',
          presentation: MateoTextFieldPresentation.search(variant: .floating),
        ),
      ),
    );

    goldenTest(
      'when LTR search text is cleared, it should reveal only the placeholder',
      fileName: 'mateo_text_field_search_clear_switch_ltr',
      whilePerforming: (tester) async {
        final field = find.byType(TextField);
        await tester.tap(field);
        final controller = tester.widget<TextField>(field).controller!;
        controller.selection = TextSelection.collapsed(
          offset: controller.text.length,
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.byKey(const ValueKey('mateo_text_field_search_clear')),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 125));
        return null;
      },
      builder: () => const SizedBox(
        width: 280,
        child: _TextInputScenario(
          initialText: 'Rua Oscar Freire, Liberdade, São Paulo, Brasil',
          placeholder: 'Search places',
          presentation: MateoTextFieldPresentation.search(variant: .floating),
        ),
      ),
    );

    goldenTest(
      'when RTL search text is cleared, it should reveal only the placeholder',
      fileName: 'mateo_text_field_search_clear_switch_rtl',
      whilePerforming: (tester) async {
        final field = find.byType(TextField);
        await tester.tap(field);
        final controller = tester.widget<TextField>(field).controller!;
        controller.selection = TextSelection.collapsed(
          offset: controller.text.length,
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.byKey(const ValueKey('mateo_text_field_search_clear')),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 125));
        return null;
      },
      builder: () => const Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: 280,
          child: _TextInputScenario(
            initialText: 'Rua Oscar Freire, Liberdade, São Paulo, Brasil',
            placeholder: 'Search places',
            presentation: MateoTextFieldPresentation.search(variant: .floating),
          ),
        ),
      ),
    );

    goldenTest(
      'when search shows its counter, it should match the approved golden',
      fileName: 'mateo_text_field_search_growth',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(width: 280),
        children: [
          GoldenTestScenario(
            name: 'counter',
            child: const _TextInputScenario(
              initialText: 'Mateo',
              placeholder: 'Search places',
              presentation: MateoTextFieldPresentation.search(variant: .floating),
              maxLength: 20,
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'when search exceeds its character limit, it should match the approved golden',
      fileName: 'mateo_text_field_search_limit_feedback',
      whilePerforming: (tester) async {
        await tester.enterText(find.byType(TextField), 'Mateo');
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 40));
        return null;
      },
      builder: () => const SizedBox(
        width: 400,
        child: _TextInputScenario(
          initialText: 'Mat',
          placeholder: 'Search places',
          presentation: MateoTextFieldPresentation.search(variant: .floating),
          maxLength: 3,
        ),
      ),
    );
  });
}

class _TextInputScenario extends StatefulWidget {
  const _TextInputScenario({
    this.initialText,
    this.placeholder = 'Phone or email',
    this.presentation = const MateoTextFieldPresentation.search(variant: .filled),
    this.isEnabled = true,
    this.maxLength,
  });

  final String? initialText;
  final String placeholder;
  final MateoTextFieldPresentation presentation;
  final bool isEnabled;
  final int? maxLength;

  @override
  State<_TextInputScenario> createState() => _TextInputScenarioState();
}

class _TextInputScenarioState extends State<_TextInputScenario> {
  late final MateoTextController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MateoTextController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MateoTextField(
      placeholder: widget.placeholder,
      presentation: widget.presentation,
      controller: _controller,
      maxLength: widget.maxLength,
      onChanged: widget.isEnabled ? (_) {} : null,
    );
  }
}
