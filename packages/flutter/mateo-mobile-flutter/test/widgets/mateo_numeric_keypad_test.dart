import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

Finder _key(MateoNumericKeypadKey key) =>
    find.byKey(Key('mateo_numeric_keypad_${key.name}'));

class _MaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
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

Future<void> _tapKey(WidgetTester tester, MateoNumericKeypadKey key) async {
  await tester.tap(_key(key));
  await tester.pump(const Duration(milliseconds: 320));
}

class _LocalizedKeypad extends StatelessWidget {
  const _LocalizedKeypad({
    required this.locale,
    required this.controllers,
    this.maxDecimals = 2,
    this.onChanged,
    this.onChangeRejected,
    this.disableAnimations = false,
  });

  final Locale locale;
  final List<MateoTextInputController> controllers;
  final int maxDecimals;
  final ValueChanged<double?>? onChanged;
  final VoidCallback? onChangeRejected;
  final bool disableAnimations;

  @override
  Widget build(BuildContext context) {
    return TestApp(
      child: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(disableAnimations: disableAnimations),
          child: Localizations.override(
            context: context,
            locale: locale,
            delegates: const [_MaterialLocalizationsDelegate()],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final controller in controllers)
                  MateoTextInput(
                    placeholder: 'Value',
                    variant: MateoTextInputVariant.quiet,
                    controller: controller,
                    keyboardType: TextInputType.none,
                    onChanged: (_) {},
                  ),
                MateoNumericKeypad(
                  controllers: controllers,
                  variant: MateoNumericKeypadVariant.monetary,
                  maxDecimals: maxDecimals,
                  onChanged: onChanged,
                  onChangeRejected: onChangeRejected,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  group('MateoNumericKeypadKey', () {
    test('when reading key metadata, it should expose canonical values', () {
      expect(MateoNumericKeypadKey.zero.rawValue, equals('0'));
      expect(MateoNumericKeypadKey.zero.numericValue, equals(0));
      expect(MateoNumericKeypadKey.nine.rawValue, equals('9'));
      expect(MateoNumericKeypadKey.nine.numericValue, equals(9));
      expect(MateoNumericKeypadKey.decimalSeparator.rawValue, equals('.'));
      expect(MateoNumericKeypadKey.decimalSeparator.numericValue, isNull);
      expect(MateoNumericKeypadKey.backspace.rawValue, isNull);
      expect(MateoNumericKeypadKey.backspace.numericValue, isNull);
    });
  });

  group('MateoNumericKeypadVariant', () {
    test('when reading monetary keys, it should use the approved order', () {
      expect(
        MateoNumericKeypadVariant.monetary.keys,
        equals([
          MateoNumericKeypadKey.one,
          MateoNumericKeypadKey.two,
          MateoNumericKeypadKey.three,
          MateoNumericKeypadKey.four,
          MateoNumericKeypadKey.five,
          MateoNumericKeypadKey.six,
          MateoNumericKeypadKey.seven,
          MateoNumericKeypadKey.eight,
          MateoNumericKeypadKey.nine,
          MateoNumericKeypadKey.decimalSeparator,
          MateoNumericKeypadKey.zero,
          MateoNumericKeypadKey.backspace,
        ]),
      );
    });
  });

  group('MateoNumericKeypad', () {
    test('when controllers are empty, it should reject construction', () {
      expect(
        () => MateoNumericKeypad(
          controllers: const [],
          variant: MateoNumericKeypadVariant.monetary,
        ),
        throwsAssertionError,
      );
    });

    test('when maxDecimals is not positive, it should reject construction', () {
      final controller = MateoTextInputController();
      addTearDown(controller.dispose);

      expect(
        () => MateoNumericKeypad(
          controllers: [controller],
          variant: MateoNumericKeypadVariant.monetary,
          maxDecimals: 0,
        ),
        throwsAssertionError,
      );
    });

    testWidgets(
      'when no controller is focused, it should focus and edit the first controller',
      (tester) async {
        final firstController = MateoTextInputController();
        final secondController = MateoTextInputController();
        addTearDown(firstController.dispose);
        addTearDown(secondController.dispose);

        await tester.pumpWidget(
          _LocalizedKeypad(
            locale: const Locale('en', 'US'),
            controllers: [firstController, secondController],
          ),
        );

        await _tapKey(tester, MateoNumericKeypadKey.one);

        expect(firstController.hasFocus, isTrue);
        expect(firstController.text, equals('1'));
        expect(secondController.text, isEmpty);
      },
    );

    testWidgets(
      'when another controller is focused, it should edit only that controller',
      (tester) async {
        final firstController = MateoTextInputController();
        final secondController = MateoTextInputController();
        addTearDown(firstController.dispose);
        addTearDown(secondController.dispose);

        await tester.pumpWidget(
          _LocalizedKeypad(
            locale: const Locale('en', 'US'),
            controllers: [firstController, secondController],
          ),
        );
        secondController.focus();
        await tester.pump();

        await _tapKey(tester, MateoNumericKeypadKey.two);

        expect(firstController.text, isEmpty);
        expect(secondController.text, equals('2'));
      },
    );

    testWidgets(
      'when entering an English value, it should group thousands and preserve fractional zeroes',
      (tester) async {
        final controller = MateoTextInputController();
        final changes = <double?>[];
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _LocalizedKeypad(
            locale: const Locale('en', 'US'),
            controllers: [controller],
            onChanged: changes.add,
          ),
        );

        for (final key in [
          MateoNumericKeypadKey.one,
          MateoNumericKeypadKey.two,
          MateoNumericKeypadKey.zero,
          MateoNumericKeypadKey.zero,
          MateoNumericKeypadKey.decimalSeparator,
          MateoNumericKeypadKey.five,
          MateoNumericKeypadKey.zero,
        ]) {
          await _tapKey(tester, key);
        }

        expect(controller.text, equals('1,200.50'));
        expect(changes.last, equals(1200.5));
      },
    );

    testWidgets(
      'when entering a Portuguese value, it should use localized separators',
      (tester) async {
        final controller = MateoTextInputController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _LocalizedKeypad(
            locale: const Locale('pt', 'BR'),
            controllers: [controller],
          ),
        );

        for (final key in [
          MateoNumericKeypadKey.one,
          MateoNumericKeypadKey.two,
          MateoNumericKeypadKey.zero,
          MateoNumericKeypadKey.zero,
          MateoNumericKeypadKey.decimalSeparator,
          MateoNumericKeypadKey.five,
          MateoNumericKeypadKey.zero,
        ]) {
          await _tapKey(tester, key);
        }

        expect(controller.text, equals('1.200,50'));
        expect(
          find.byKey(const Key('mateo_numeric_keypad_decimalSeparator_label')),
          findsOneWidget,
        );
        expect(find.text(','), findsOneWidget);
      },
    );

    testWidgets(
      'when locale data is unavailable, it should use English separators',
      (tester) async {
        final controller = MateoTextInputController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _LocalizedKeypad(
            locale: const Locale('zz', 'ZZ'),
            controllers: [controller],
          ),
        );

        for (final key in [
          MateoNumericKeypadKey.one,
          MateoNumericKeypadKey.two,
          MateoNumericKeypadKey.zero,
          MateoNumericKeypadKey.zero,
          MateoNumericKeypadKey.decimalSeparator,
          MateoNumericKeypadKey.five,
        ]) {
          await _tapKey(tester, key);
        }

        expect(controller.text, equals('1,200.5'));
      },
    );

    testWidgets(
      'when attaching existing localized text, it should normalize its formatting',
      (tester) async {
        final controller = MateoTextInputController(text: '1200,5');
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _LocalizedKeypad(
            locale: const Locale('pt', 'BR'),
            controllers: [controller],
          ),
        );
        await tester.pump();

        expect(controller.text, equals('1.200,5'));
      },
    );

    testWidgets(
      'when locale changes, it should preserve value and update separators',
      (tester) async {
        final controller = MateoTextInputController(text: '1200.50');
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _LocalizedKeypad(
            locale: const Locale('en', 'US'),
            controllers: [controller],
          ),
        );
        await tester.pump();
        expect(controller.text, equals('1,200.50'));

        await tester.pumpWidget(
          _LocalizedKeypad(
            locale: const Locale('pt', 'BR'),
            controllers: [controller],
          ),
        );
        await tester.pump();

        expect(controller.text, equals('1.200,50'));
      },
    );

    testWidgets(
      'when selection is replaced, it should preserve localized grouping and caret position',
      (tester) async {
        final controller = MateoTextInputController(text: '1,234');
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _LocalizedKeypad(
            locale: const Locale('en', 'US'),
            controllers: [controller],
          ),
        );
        await tester.pump();
        controller.value = controller.value.copyWith(
          selection: const TextSelection(baseOffset: 2, extentOffset: 5),
        );

        await _tapKey(tester, MateoNumericKeypadKey.nine);

        expect(controller.text, equals('19'));
        expect(controller.value.selection.baseOffset, equals(2));
      },
    );

    testWidgets(
      'when the selected decimal is replaced, it should accept one decimal separator',
      (tester) async {
        final controller = MateoTextInputController(text: '12.3');
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _LocalizedKeypad(
            locale: const Locale('en', 'US'),
            controllers: [controller],
          ),
        );
        await tester.pump();
        controller.value = controller.value.copyWith(
          selection: const TextSelection(baseOffset: 2, extentOffset: 3),
        );

        await _tapKey(tester, MateoNumericKeypadKey.decimalSeparator);

        expect(controller.text, equals('12.3'));
        expect(controller.value.selection.baseOffset, equals(3));
      },
    );

    testWidgets(
      'when backspacing beside a grouping separator, it should delete the preceding digit',
      (tester) async {
        final controller = MateoTextInputController(text: '1,234');
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _LocalizedKeypad(
            locale: const Locale('en', 'US'),
            controllers: [controller],
          ),
        );
        await tester.pump();
        controller.value = controller.value.copyWith(
          selection: const TextSelection.collapsed(offset: 2),
        );

        await _tapKey(tester, MateoNumericKeypadKey.backspace);

        expect(controller.text, equals('234'));
        expect(controller.value.selection.baseOffset, equals(0));
      },
    );

    testWidgets(
      'when decimal input exceeds its rules, it should report each rejected change',
      (tester) async {
        final controller = MateoTextInputController();
        final changes = <double?>[];
        var rejectedChanges = 0;
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _LocalizedKeypad(
            locale: const Locale('en', 'US'),
            controllers: [controller],
            maxDecimals: 1,
            onChanged: changes.add,
            onChangeRejected: () => rejectedChanges += 1,
          ),
        );

        for (final key in [
          MateoNumericKeypadKey.one,
          MateoNumericKeypadKey.decimalSeparator,
          MateoNumericKeypadKey.two,
        ]) {
          await _tapKey(tester, key);
        }
        expect(changes, hasLength(3));

        await _tapKey(tester, MateoNumericKeypadKey.three);
        await _tapKey(tester, MateoNumericKeypadKey.decimalSeparator);

        expect(controller.text, equals('1.2'));
        expect(changes, hasLength(3));
        expect(rejectedChanges, equals(2));
      },
    );

    testWidgets(
      'when backspace cannot delete, it should report the rejected change',
      (tester) async {
        final controller = MateoTextInputController();
        final changes = <double?>[];
        var rejectedChanges = 0;
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _LocalizedKeypad(
            locale: const Locale('en', 'US'),
            controllers: [controller],
            onChanged: changes.add,
            onChangeRejected: () => rejectedChanges += 1,
          ),
        );

        await _tapKey(tester, MateoNumericKeypadKey.backspace);

        expect(controller.text, isEmpty);
        expect(changes, isEmpty);
        expect(rejectedChanges, equals(1));
      },
    );

    testWidgets('when deletion empties the value, it should report null', (
      tester,
    ) async {
      final controller = MateoTextInputController(text: '1');
      double? reportedValue = 1;
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _LocalizedKeypad(
          locale: const Locale('en', 'US'),
          controllers: [controller],
          onChanged: (value) => reportedValue = value,
        ),
      );
      await tester.pump();

      await _tapKey(tester, MateoNumericKeypadKey.backspace);

      expect(controller.text, isEmpty);
      expect(reportedValue, isNull);
    });

    testWidgets(
      'when backspace is held, it should repeatedly delete without deleting again on release',
      (tester) async {
        final controller = MateoTextInputController(text: '12345');
        final changes = <double?>[];
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _LocalizedKeypad(
            locale: const Locale('en', 'US'),
            controllers: [controller],
            onChanged: changes.add,
          ),
        );
        await tester.pump();

        final gesture = await tester.startGesture(
          tester.getCenter(_key(MateoNumericKeypadKey.backspace)),
        );
        await tester.pump(const Duration(milliseconds: 449));

        expect(controller.text, equals('12,345'));
        expect(changes, isEmpty);

        await tester.pump(const Duration(milliseconds: 1));
        await tester.pump(const Duration(milliseconds: 160));

        expect(controller.text, equals('12'));
        expect(changes, equals([1234, 123, 12]));

        await gesture.up();
        await tester.pump(const Duration(milliseconds: 320));

        expect(controller.text, equals('12'));
        expect(changes, equals([1234, 123, 12]));
      },
    );

    testWidgets(
      'when rendered, it should use primary text color and scale-only feedback',
      (tester) async {
        final controller = MateoTextInputController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _LocalizedKeypad(
            locale: const Locale('en', 'US'),
            controllers: [controller],
          ),
        );

        final oneLabel = tester.widget<Text>(
          find.byKey(const Key('mateo_numeric_keypad_one_label')),
        );
        final oneKey = _key(MateoNumericKeypadKey.one);

        expect(
          oneLabel.style?.color,
          equals(mateoTestColorScheme.text.primary),
        );
        expect(
          find.descendant(of: oneKey, matching: find.byType(ScaleTransition)),
          findsOneWidget,
        );
        expect(
          find.descendant(of: oneKey, matching: find.byType(FadeTransition)),
          findsNothing,
        );
      },
    );

    testWidgets(
      'when semantics are read, it should expose button labels for every key',
      (tester) async {
        final controller = MateoTextInputController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _LocalizedKeypad(
            locale: const Locale('en', 'US'),
            controllers: [controller],
          ),
        );

        final oneSemantics = tester.getSemantics(
          _key(MateoNumericKeypadKey.one),
        );
        final decimalSemantics = tester.getSemantics(
          _key(MateoNumericKeypadKey.decimalSeparator),
        );
        final backspaceSemantics = tester.getSemantics(
          _key(MateoNumericKeypadKey.backspace),
        );
        final localizations = MaterialLocalizations.of(
          tester.element(find.byType(MateoNumericKeypad)),
        );

        expect(oneSemantics.label, equals('1'));
        expect(oneSemantics.flagsCollection.isButton, isTrue);
        expect(
          decimalSemantics.label,
          equals(localizations.keyboardKeyNumpadDecimal),
        );
        expect(
          backspaceSemantics.label,
          equals(localizations.keyboardKeyBackspace),
        );
      },
    );

    testWidgets(
      'when animations are disabled, it should edit without entering a pressed scale',
      (tester) async {
        final controller = MateoTextInputController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _LocalizedKeypad(
            locale: const Locale('en', 'US'),
            controllers: [controller],
            disableAnimations: true,
          ),
        );

        final oneKey = _key(MateoNumericKeypadKey.one);
        final gesture = await tester.startGesture(tester.getCenter(oneKey));
        await tester.pump(const Duration(milliseconds: 80));
        final scale = tester.widget<ScaleTransition>(
          find.descendant(of: oneKey, matching: find.byType(ScaleTransition)),
        );
        expect(scale.scale.value, equals(1));

        await gesture.up();
        await tester.pump();
        expect(controller.text, equals('1'));
      },
    );
  });
}
