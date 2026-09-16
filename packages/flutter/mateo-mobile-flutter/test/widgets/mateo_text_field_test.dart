import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  group('MateoTextField', () {
    test('when a search presentation changes variant, it should retain its concrete widget and expose the variant', () {
      const first = MateoTextFieldPresentation.search(variant: .floating);
      const second = MateoTextFieldPresentation.search(variant: .filled);
      expect(first.variant, MateoTextFieldVariant.floating);
      expect(second.variant, MateoTextFieldVariant.filled);
      expect(Widget.canUpdate(first, second), isTrue);
    });

    testWidgets('when a theme constrains the editor, it should preserve the search surface minimum height', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          theme: mateoTestTheme.copyWith(
            inputDecorationTheme: const InputDecorationThemeData(constraints: BoxConstraints(maxHeight: 30)),
          ),
          child: MateoTextField(
            placeholder: 'Search',
            presentation: .search(variant: .floating),
            onChanged: (_) {},
          ),
        ),
      );
      expect(tester.getSize(find.byKey(const ValueKey('mateo_text_field_search_surface'))).height, 55);
    });

    testWidgets('when reduced motion becomes enabled during clearing, it should settle the placeholder immediately', (
      tester,
    ) async {
      final textController = MateoTextController(text: 'Mateo');
      addTearDown(textController.dispose);
      var disableAnimations = false;
      late StateSetter updateHost;
      await tester.pumpWidget(
        TestApp(
          child: StatefulBuilder(
            builder: (context, setState) {
              updateHost = setState;
              return MediaQuery(
                data: MediaQueryData(disableAnimations: disableAnimations),
                child: MateoTextField(
                  placeholder: 'Search',
                  presentation: .search(variant: .floating),
                  controller: textController,
                  onChanged: (_) {},
                ),
              );
            },
          ),
        ),
      );
      textController.clear();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      final reveal = find.byKey(const ValueKey('mateo_text_field_search_placeholder_reveal'));
      expect(tester.widget<FadeTransition>(reveal).opacity.value, inExclusiveRange(0, 1));
      updateHost(() => disableAnimations = true);
      await tester.pump();
      expect(tester.widget<FadeTransition>(reveal).opacity.value, 1);
      expect(
        tester.widget<ScaleTransition>(find.descendant(of: reveal, matching: find.byType(ScaleTransition))).scale.value,
        1,
      );
    });

    testWidgets('when switching presentations, it should retain the editing controller, selection, and focus', (
      tester,
    ) async {
      final controller = MateoTextController(text: 'Mateo');
      addTearDown(controller.dispose);
      for (final presentation in const [
        MateoTextFieldPresentation.search(variant: .floating),
        MateoTextFieldPresentation.search(variant: .filled),
        MateoTextFieldPresentation.search(variant: .floating),
      ]) {
        await tester.pumpWidget(
          TestApp(
            child: MateoTextField(
              placeholder: 'Name',
              presentation: presentation,
              controller: controller,
              onChanged: (_) {},
            ),
          ),
        );
        await tester.pumpAndSettle();
        final field = tester.widget<TextField>(find.byType(TextField));
        expect(field.controller, same(controller));
        expect(controller.text, 'Mateo');
        if (presentation.variant == MateoTextFieldVariant.floating && !controller.hasFocus) {
          controller.focus();
          controller.selection = const TextSelection(baseOffset: 1, extentOffset: 4);
          await tester.pumpAndSettle();
        }
        expect(controller.hasFocus, isTrue);
        expect(controller.selection, const TextSelection(baseOffset: 1, extentOffset: 4));
        expect(field.style!.fontSize, 16);
        expect(field.decoration!.hintStyle!.fontSize, 16);
        expect(field.textInputAction, TextInputAction.search);
      }
    });

    testWidgets(
      'when the floating search presentation is empty, it should show its placeholder',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoTextField(
              placeholder: 'Phone or email',
              presentation: MateoTextFieldPresentation.search(variant: .floating),
              onChanged: (_) {},
            ),
          ),
        );

        expect(
          find.byKey(const ValueKey('mateo_text_field_search_placeholder')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'when text is entered, it should update the controller and invoke onChanged',
      (tester) async {
        final controller = MateoTextController();
        addTearDown(controller.dispose);
        String? changedValue;

        await tester.pumpWidget(
          TestApp(
            child: MateoTextField(
              placeholder: 'Phone or email',
              presentation: MateoTextFieldPresentation.search(variant: .floating),
              controller: controller,
              onChanged: (value) => changedValue = value,
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'mateo@example.com');

        expect(controller.text, equals('mateo@example.com'));
        expect(changedValue, equals('mateo@example.com'));
      },
    );

    testWidgets(
      'when the keyboard submits, it should invoke onSubmitted with the value',
      (tester) async {
        String? submittedValue;

        await tester.pumpWidget(
          TestApp(
            child: MateoTextField(
              placeholder: 'Phone or email',
              presentation: MateoTextFieldPresentation.search(variant: .floating),
              textInputAction: TextInputAction.done,
              onChanged: (_) {},
              onSubmitted: (value) => submittedValue = value,
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'mateo@example.com');
        await tester.testTextInput.receiveAction(TextInputAction.done);

        expect(submittedValue, equals('mateo@example.com'));
      },
    );

    testWidgets(
      'when configured for mobile entry, it should forward keyboard and autofill options',
      (tester) async {
        final controller = MateoTextController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          TestApp(
            child: MateoTextField(
              placeholder: 'Phone or email',
              presentation: MateoTextFieldPresentation.search(variant: .floating),
              controller: controller,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              onChanged: (_) {},
            ),
          ),
        );
        await tester.pump();

        final field = tester.widget<TextField>(find.byType(TextField));

        expect(field.autofocus, isTrue);
        expect(field.keyboardType, equals(TextInputType.emailAddress));
        expect(field.textInputAction, equals(TextInputAction.next));
        expect(field.autofillHints, equals(const [AutofillHints.email]));
        expect(controller.hasFocus, isTrue);
      },
    );

    testWidgets(
      'when search omits its keyboard action, it should use the search action',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoTextField(
              placeholder: 'Search places',
              presentation: MateoTextFieldPresentation.search(variant: .floating),
              onChanged: (_) {},
            ),
          ),
        );

        expect(
          tester.widget<TextField>(find.byType(TextField)).textInputAction,
          TextInputAction.search,
        );
      },
    );

    testWidgets(
      'when search provides a keyboard action, it should override its default',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoTextField(
              placeholder: 'Search places',
              presentation: MateoTextFieldPresentation.search(variant: .floating),
              textInputAction: TextInputAction.done,
              onChanged: (_) {},
            ),
          ),
        );

        expect(
          tester.widget<TextField>(find.byType(TextField)).textInputAction,
          TextInputAction.done,
        );
      },
    );

    testWidgets('when onChanged is null, it should disable focus and editing', (
      tester,
    ) async {
      final controller = MateoTextController(text: 'Existing value');
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        TestApp(
          child: MateoTextField(
            placeholder: 'Phone or email',
            presentation: MateoTextFieldPresentation.search(variant: .floating),
            controller: controller,
          ),
        ),
      );

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.enabled, isFalse);
      expect(
        field.style!.color,
        mateoTestColorScheme.textField.floating.textDisabled,
      );

      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'Changed value');
      await tester.pump();

      expect(controller.hasFocus, isFalse);
      expect(controller.text, equals('Existing value'));
    });

    testWidgets(
      'when editable becomes false, it should reject edits without losing the keyboard',
      (tester) async {
        final controller = MateoTextController(text: 'Existing value');
        addTearDown(controller.dispose);
        var editable = true;
        late StateSetter setState;

        await tester.pumpWidget(
          TestApp(
            child: StatefulBuilder(
              builder: (context, stateSetter) {
                setState = stateSetter;
                return MateoTextField(
                  placeholder: 'Phone or email',
                  presentation: MateoTextFieldPresentation.search(variant: .floating),
                  controller: controller,
                  editable: editable,
                  onChanged: (_) {},
                );
              },
            ),
          ),
        );

        await tester.tap(find.byType(TextField));
        await tester.showKeyboard(find.byType(TextField));

        expect(controller.hasFocus, isTrue);
        expect(tester.testTextInput.hasAnyClients, isTrue);

        setState(() => editable = false);
        await tester.pump();

        expect(controller.hasFocus, isTrue);
        expect(tester.testTextInput.hasAnyClients, isTrue);

        await tester.enterText(find.byType(TextField), 'Changed value');

        expect(controller.text, equals('Existing value'));
        expect(controller.hasFocus, isTrue);
        expect(tester.testTextInput.hasAnyClients, isTrue);
        expect(
          tester.getSemantics(find.byType(EditableText)),
          matchesSemantics(
            isTextField: true,
            isEnabled: true,
            hasEnabledState: true,
            isReadOnly: true,
            isFocusable: true,
            isFocused: true,
            hasTapAction: true,
            hasFocusAction: true,
            hasMoveCursorBackwardByCharacterAction: true,
            hasMoveCursorBackwardByWordAction: true,
            hasSetSelectionAction: true,
            hasSetTextAction: true,
          ),
        );

        controller.text = 'Programmatic value';
        await tester.pump();

        expect(controller.text, equals('Programmatic value'));
        expect(controller.hasFocus, isTrue);
        expect(tester.testTextInput.hasAnyClients, isTrue);
      },
    );

    testWidgets(
      'when controller focus is called, it should focus and unfocus the input',
      (tester) async {
        final controller = MateoTextController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          TestApp(
            child: MateoTextField(
              placeholder: 'Phone or email',
              presentation: MateoTextFieldPresentation.search(variant: .floating),
              controller: controller,
              onChanged: (_) {},
            ),
          ),
        );

        controller.focus();
        await tester.pump();

        expect(controller.hasFocus, isTrue);

        controller.unfocus();
        await tester.pump();

        expect(controller.hasFocus, isFalse);
      },
    );

    for (final (name, presentation) in const [
      ('floating', MateoTextFieldPresentation.search(variant: .floating)),
      ('filled', MateoTextFieldPresentation.search(variant: .filled)),
    ]) {
      testWidgets(
        'when tapping outside the ${name} input by default, it should unfocus and close the keyboard',
        (tester) async {
          final controller = MateoTextController();
          addTearDown(controller.dispose);

          await tester.pumpWidget(
            TestApp(
              child: SizedBox(
                width: 320,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MateoTextField(
                      placeholder: 'Search places',
                      presentation: presentation,
                      controller: controller,
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      key: const ValueKey('outside_text_input'),
                      behavior: HitTestBehavior.opaque,
                      onTap: () {},
                      child: const SizedBox(width: 120, height: 40),
                    ),
                  ],
                ),
              ),
            ),
          );

          await tester.tap(find.byType(TextField));
          await tester.showKeyboard(find.byType(TextField));

          expect(controller.hasFocus, isTrue);
          expect(tester.testTextInput.hasAnyClients, isTrue);

          await tester.tap(find.byKey(const ValueKey('outside_text_input')));
          await tester.pump();

          expect(controller.hasFocus, isFalse);
          expect(tester.testTextInput.hasAnyClients, isFalse);
        },
      );

      testWidgets(
        'when tapping outside the ${name} input with unfocus disabled, it should retain focus and keep the keyboard open',
        (tester) async {
          final controller = MateoTextController();
          addTearDown(controller.dispose);

          await tester.pumpWidget(
            TestApp(
              child: SizedBox(
                width: 320,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MateoTextField(
                      placeholder: 'Search places',
                      presentation: presentation,
                      controller: controller,
                      unfocusOnTapOutside: false,
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      key: const ValueKey('outside_text_input'),
                      behavior: HitTestBehavior.opaque,
                      onTap: () {},
                      child: const SizedBox(width: 120, height: 40),
                    ),
                  ],
                ),
              ),
            ),
          );

          await tester.tap(find.byType(TextField));
          await tester.showKeyboard(find.byType(TextField));

          await tester.tap(find.byKey(const ValueKey('outside_text_input')));
          await tester.pump();

          expect(controller.hasFocus, isTrue);
          expect(tester.testTextInput.hasAnyClients, isTrue);
        },
      );
    }

    testWidgets(
      'when controller text changes, it should update and clear the input',
      (tester) async {
        final controller = MateoTextController(text: 'Initial value');
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          TestApp(
            child: MateoTextField(
              placeholder: 'Phone or email',
              presentation: MateoTextFieldPresentation.search(variant: .floating),
              controller: controller,
              onChanged: (_) {},
            ),
          ),
        );

        controller.text = 'Updated value';
        await tester.pump();

        expect(find.text('Updated value'), findsOneWidget);
        expect(controller.text, equals('Updated value'));

        controller.clear();
        await tester.pump();

        expect(controller.text, isEmpty);
        expect(
          find.byKey(const ValueKey('mateo_text_field_search_placeholder')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'when maxLength is null, it should allow unlimited text without a counter',
      (tester) async {
        final controller = MateoTextController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          TestApp(
            child: MateoTextField(
              placeholder: 'Message',
              presentation: MateoTextFieldPresentation.search(variant: .floating),
              controller: controller,
              onChanged: (_) {},
            ),
          ),
        );

        await tester.enterText(
          find.byType(TextField),
          List.filled(200, 'a').join(),
        );

        expect(controller.text, hasLength(200));
        expect(find.textContaining('/'), findsNothing);
      },
    );

    testWidgets(
      'when maxLength is provided, it should count and enforce the limit',
      (tester) async {
        final controller = MateoTextController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          TestApp(
            child: MateoTextField(
              placeholder: 'Code',
              presentation: MateoTextFieldPresentation.search(variant: .floating),
              controller: controller,
              maxLength: 5,
              onChanged: (_) {},
            ),
          ),
        );

        final emptyHeight = tester.getSize(find.byType(TextField)).height;
        expect(
          find.byKey(const ValueKey('mateo_text_field_search_counter')),
          findsNothing,
        );

        await tester.enterText(find.byType(TextField), 'Ma');
        await tester.pump();

        expect(_counterText(tester), '2/5');
        expect(
          find.byKey(const ValueKey('mateo_text_field_search_counter')),
          findsOneWidget,
        );
        expect(
          tester.getSize(find.byType(TextField)).height,
          equals(emptyHeight),
        );

        await tester.enterText(find.byType(TextField), 'Mateo!');
        await tester.pump();

        expect(controller.text, equals('Mateo'));
        expect(_counterText(tester), '5/5');

        controller.clear();
        await tester.pump();

        expect(
          find.byKey(const ValueKey('mateo_text_field_search_counter')),
          findsNothing,
        );
        expect(
          tester.getSize(find.byType(TextField)).height,
          equals(emptyHeight),
        );
      },
    );

    for (final (name, presentation) in const [
      ('floating', MateoTextFieldPresentation.search(variant: .floating)),
      ('filled', MateoTextFieldPresentation.search(variant: .filled)),
    ]) {
      testWidgets(
        'when the $name limit changes while focused, it should retain text, focus, and the input connection',
        (tester) async {
          final controller = MateoTextController(text: '👨‍👩‍👧‍👦a');
          int? maxLength;
          late StateSetter updateHost;
          addTearDown(controller.dispose);

          await tester.pumpWidget(
            StatefulBuilder(
              builder: (context, setState) {
                updateHost = setState;
                return TestApp(
                  child: MateoTextField(
                    placeholder: 'Code',
                    presentation: presentation,
                    controller: controller,
                    maxLength: maxLength,
                    onChanged: (_) {},
                  ),
                );
              },
            ),
          );
          await tester.showKeyboard(find.byType(TextField));
          final editableState = tester.state<EditableTextState>(find.byType(EditableText));
          final selection = controller.selection;
          tester.testTextInput.log.clear();

          updateHost(() => maxLength = 10);
          await tester.pump();

          var textInputMethods = tester.testTextInput.log.map((call) => call.method);
          expect(controller.text, '👨‍👩‍👧‍👦a');
          expect(controller.hasFocus, isTrue);
          expect(controller.selection, selection);
          expect(tester.state<EditableTextState>(find.byType(EditableText)), same(editableState));
          expect(_counterText(tester), '2/10');
          expect(tester.testTextInput.hasAnyClients, isTrue);
          expect(
            textInputMethods.where(
              (method) =>
                  method == 'TextInput.clearClient' || method == 'TextInput.hide' || method == 'TextInput.setClient',
            ),
            isEmpty,
          );

          tester.testTextInput.log.clear();
          updateHost(() => maxLength = null);
          await tester.pump();

          textInputMethods = tester.testTextInput.log.map((call) => call.method);
          expect(controller.text, '👨‍👩‍👧‍👦a');
          expect(controller.hasFocus, isTrue);
          expect(controller.selection, selection);
          expect(tester.state<EditableTextState>(find.byType(EditableText)), same(editableState));
          expect(find.textContaining('/10'), findsNothing);
          expect(tester.testTextInput.hasAnyClients, isTrue);
          expect(
            textInputMethods.where(
              (method) =>
                  method == 'TextInput.clearClient' || method == 'TextInput.hide' || method == 'TextInput.setClient',
            ),
            isEmpty,
          );
        },
      );
    }

    testWidgets(
      'when extra input is rejected, it should make the counter red and shake it',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoTextField(
              placeholder: 'Code',
              presentation: MateoTextFieldPresentation.search(variant: .floating),
              maxLength: 3,
              onChanged: (_) {},
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'Mat');
        await tester.pump();
        final restingCounterLeft = tester.getTopLeft(find.byKey(const ValueKey('mateo_character_counter_text'))).dx;

        await tester.enterText(find.byType(TextField), 'Mateo');
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 40));

        final counter = tester.widget<AnimatedDefaultTextStyle>(
          find.byKey(const ValueKey('mateo_character_counter_text')),
        );
        final shakenCounterLeft = tester.getTopLeft(find.byKey(const ValueKey('mateo_character_counter_text'))).dx;

        expect(
          counter.style.color,
          equals(
            mateoTestColorScheme.characterCounter.floating.foregroundReject,
          ),
        );
        expect(shakenCounterLeft, isNot(closeTo(restingCounterLeft, 0.5)));
        expect(
          find.bySemanticsLabel('Character limit reached: 3 of 3.'),
          findsOneWidget,
        );

        await tester.pumpAndSettle();

        expect(
          tester
              .widget<AnimatedDefaultTextStyle>(find.byKey(const ValueKey('mateo_character_counter_text')))
              .style
              .color,
          equals(mateoTestColorScheme.characterCounter.floating.foreground),
        );
      },
    );

    testWidgets(
      'when reduced motion is enabled, it should show red feedback without shaking',
      (tester) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: TestApp(
              child: MateoTextField(
                placeholder: 'Code',
                presentation: MateoTextFieldPresentation.search(variant: .floating),
                maxLength: 3,
                onChanged: (_) {},
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'Mat');
        await tester.pump();
        final restingCounterLeft = tester.getTopLeft(find.byKey(const ValueKey('mateo_character_counter_text'))).dx;

        await tester.enterText(find.byType(TextField), 'Mateo');
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 40));

        final counter = tester.widget<AnimatedDefaultTextStyle>(
          find.byKey(const ValueKey('mateo_character_counter_text')),
        );
        final feedbackCounterLeft = tester.getTopLeft(find.byKey(const ValueKey('mateo_character_counter_text'))).dx;

        expect(
          counter.style.color,
          equals(
            mateoTestColorScheme.characterCounter.floating.foregroundReject,
          ),
        );
        expect(feedbackCounterLeft, closeTo(restingCounterLeft, 0.01));
      },
    );

    testWidgets(
      'when disabled, it should expose disabled text-field semantics',
      (tester) async {
        final semantics = tester.ensureSemantics();

        await tester.pumpWidget(
          const TestApp(
            child: MateoTextField(
              placeholder: 'Phone or email',
              presentation: MateoTextFieldPresentation.search(variant: .floating),
            ),
          ),
        );

        expect(
          tester.getSemantics(find.byType(EditableText)),
          matchesSemantics(
            isTextField: true,
            isEnabled: false,
            hasEnabledState: true,
            isReadOnly: true,
            isFocusable: true,
          ),
        );
        semantics.dispose();
      },
    );

    testWidgets(
      'when text scale is enlarged, it should grow without overflowing',
      (tester) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: TestApp(
              child: SizedBox(
                width: 240,
                child: MateoTextField(
                  placeholder: 'Phone or email',
                  presentation: MateoTextFieldPresentation.search(variant: .floating),
                  onChanged: (_) {},
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(tester.getSize(find.byType(TextField)).height, greaterThan(48));
      },
    );

    testWidgets(
      'when direction is right to left, it should inherit the ambient direction',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: MateoTextField(
                placeholder: 'البريد الإلكتروني',
                presentation: MateoTextFieldPresentation.search(variant: .floating),
                onChanged: (_) {},
              ),
            ),
          ),
        );

        final renderEditable = tester.renderObject<RenderEditable>(
          find.descendant(
            of: find.byType(EditableText),
            matching: find.byElementPredicate(
              (element) => element.renderObject is RenderEditable,
            ),
          ),
        );

        expect(renderEditable.textDirection, equals(TextDirection.rtl));
      },
    );

    testWidgets(
      'when scroll padding is provided, it should forward the caret clearance',
      (tester) async {
        const scrollPadding = EdgeInsets.fromLTRB(12, 16, 20, 104);

        await tester.pumpWidget(
          TestApp(
            child: MateoTextField(
              placeholder: 'Description',
              presentation: MateoTextFieldPresentation.search(variant: .floating),
              scrollPadding: scrollPadding,
              onChanged: (_) {},
            ),
          ),
        );

        expect(
          tester.widget<TextField>(find.byType(TextField)).scrollPadding,
          equals(scrollPadding),
        );
      },
    );

    testWidgets(
      'when scroll padding is omitted, it should use the native default',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoTextField(
              placeholder: 'Description',
              presentation: MateoTextFieldPresentation.search(variant: .floating),
              onChanged: (_) {},
            ),
          ),
        );

        expect(
          tester.widget<TextField>(find.byType(TextField)).scrollPadding,
          equals(const EdgeInsets.all(20)),
        );
      },
    );

    testWidgets(
      'when unfocused text overflows on iOS, it should scroll horizontally',
      (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        final controller = MateoTextController(
          text: 'A very long value that does not fit the available width',
        );
        addTearDown(controller.dispose);

        try {
          await tester.pumpWidget(
            TestApp(
              child: SizedBox(
                width: 160,
                child: MateoTextField(
                  placeholder: 'Value',
                  presentation: MateoTextFieldPresentation.search(variant: .floating),
                  controller: controller,
                  onChanged: (_) {},
                ),
              ),
            ),
          );

          final scrollable = find.descendant(
            of: find.byType(TextField),
            matching: find.byType(Scrollable),
          );
          final scrollableState = tester.state<ScrollableState>(scrollable);
          final field = tester.widget<TextField>(find.byType(TextField));

          expect(field.maxLines, equals(1));
          expect(field.scrollPhysics, isA<ClampingScrollPhysics>());
          expect(controller.hasFocus, isFalse);
          expect(scrollableState.position.pixels, equals(0));

          await tester.drag(scrollable, const Offset(-120, 0));
          await tester.pumpAndSettle();

          expect(scrollableState.position.pixels, greaterThan(0));
          expect(controller.hasFocus, isFalse);
        } finally {
          debugDefaultTargetPlatformOverride = null;
        }
      },
    );

    for (final (name, variant) in const [
      ('floating', MateoTextFieldVariant.floating),
      ('filled', MateoTextFieldVariant.filled),
    ]) {
      testWidgets(
        'when the $name search presentation is rendered, it should keep its prompt leading and use its surface role',
        (tester) async {
          final expectedColors = switch (variant) {
            MateoTextFieldVariant.floating => mateoTestColorScheme.textField.floating,
            MateoTextFieldVariant.filled => mateoTestColorScheme.textField.filled,
          };
          await tester.pumpWidget(
            TestApp(
              child: SizedBox(
                width: 360,
                child: MateoTextField(
                  placeholder: 'Search places',
                  presentation: MateoTextFieldPresentation.search(variant: variant),
                  onChanged: (_) {},
                ),
              ),
            ),
          );

          final surface = find.byKey(
            const ValueKey('mateo_text_field_search_surface'),
          );
          final icon = find.byKey(const ValueKey('mateo_text_field_search_icon'));
          final placeholder = find.byKey(
            const ValueKey('mateo_text_field_search_placeholder'),
          );
          final surfaceRect = tester.getRect(surface);
          final iconRect = tester.getRect(icon);
          final placeholderRect = tester.getRect(placeholder);
          final surfaceLeft = surfaceRect.left;

          expect(surfaceRect.width, equals(360));
          expect(surfaceRect.height, equals(55));
          expect(iconRect.left, closeTo(surfaceLeft + 18, 0.01));
          expect(placeholderRect.left, closeTo(surfaceLeft + 48, 0.01));
          expect(placeholderRect.left - iconRect.right, closeTo(12, 0.01));
          expect(
            tester.widget<Text>(placeholder).style!.color,
            equals(expectedColors.placeholderResting),
          );
          final material = tester.widget<Material>(
            find.descendant(of: surface, matching: find.byType(Material)),
          );
          expect(material.color, equals(expectedColors.background));

          final field = tester.widget<TextField>(find.byType(TextField));
          expect(field.showCursor, isFalse);
          await tester.tap(find.byType(TextField));
          await tester.pump();

          expect(tester.getTopLeft(icon).dx, closeTo(surfaceLeft + 18, 0.01));
          expect(tester.getTopLeft(placeholder).dx, closeTo(surfaceLeft + 48, 0.01));
          expect(tester.widget<TextField>(find.byType(TextField)).showCursor, isTrue);
        },
      );
    }

    testWidgets(
      'when reduced motion is enabled, search should change presentation without transitional movement',
      (tester) async {
        final controller = MateoTextController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: TestApp(
              child: SizedBox(
                width: 360,
                child: MateoTextField(
                  placeholder: 'Search places',
                  presentation: MateoTextFieldPresentation.search(variant: .floating),
                  controller: controller,
                  onChanged: (_) {},
                ),
              ),
            ),
          ),
        );

        final surfaceLeft = tester
            .getTopLeft(
              find.byKey(const ValueKey('mateo_text_field_search_surface')),
            )
            .dx;

        controller.focus();
        await tester.pump();

        expect(
          tester
              .getTopLeft(
                find.byKey(const ValueKey('mateo_text_field_search_icon')),
              )
              .dx,
          closeTo(surfaceLeft + 18, 0.01),
        );
        expect(
          tester.widget<TextField>(find.byType(TextField)).showCursor,
          isTrue,
        );
      },
    );

    testWidgets(
      'when search text is cleared, it should retain focus and notify the empty value',
      (tester) async {
        final controller = MateoTextController();
        addTearDown(controller.dispose);
        final changes = <String>[];

        await tester.pumpWidget(
          TestApp(
            child: SizedBox(
              width: 360,
              child: MateoTextField(
                placeholder: 'Search places',
                presentation: MateoTextFieldPresentation.search(variant: .floating),
                controller: controller,
                onChanged: changes.add,
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'Liberdade');
        await tester.pumpAndSettle();
        final focusStates = <bool>[];
        controller.addListener(() => focusStates.add(controller.hasFocus));

        expect(
          find.byKey(const ValueKey('mateo_text_field_search_clear')),
          findsOneWidget,
        );
        expect(
          tester
              .widget<MateoButton>(
                find.byKey(const ValueKey('mateo_text_field_search_clear')),
              )
              .presentation
              .variant,
          MateoButtonVariant.primary.base,
        );
        expect(
          tester
              .widget<MateoButton>(
                find.byKey(const ValueKey('mateo_text_field_search_clear')),
              )
              .presentation
              .elevation,
          1,
        );

        await tester.tap(
          find.byKey(const ValueKey('mateo_text_field_search_clear')),
        );
        await tester.pump();

        expect(controller.text, isEmpty);
        expect(controller.hasFocus, isTrue);
        expect(focusStates, isNot(contains(false)));
        expect(tester.testTextInput.hasAnyClients, isTrue);
        expect(changes.last, isEmpty);
        expect(
          find.byKey(const ValueKey('mateo_text_field_search_clear')),
          findsNothing,
        );
        expect(
          find.byKey(const ValueKey('mateo_text_field_search_placeholder')),
          findsOneWidget,
        );
        expect(
          tester
              .widget<FadeTransition>(
                find.byKey(
                  const ValueKey(
                    'mateo_text_field_search_placeholder_reveal',
                  ),
                ),
              )
              .opacity
              .value,
          equals(0),
        );

        await tester.pump(const Duration(milliseconds: 125));

        final placeholderOpacity = tester
            .widget<FadeTransition>(
              find.byKey(
                const ValueKey(
                  'mateo_text_field_search_placeholder_reveal',
                ),
              ),
            )
            .opacity
            .value;
        expect(placeholderOpacity, greaterThan(0));
        expect(placeholderOpacity, lessThan(1));
        final placeholderScale = tester
            .widget<ScaleTransition>(
              find.descendant(
                of: find.byKey(
                  const ValueKey(
                    'mateo_text_field_search_placeholder_reveal',
                  ),
                ),
                matching: find.byType(ScaleTransition),
              ),
            )
            .scale
            .value;
        expect(placeholderScale, greaterThan(0.9));
        expect(placeholderScale, lessThan(1));

        await tester.pumpAndSettle();

        expect(
          find.byKey(const ValueKey('mateo_text_field_search_clear')),
          findsNothing,
        );
        expect(
          find.byKey(const ValueKey('mateo_text_field_search_placeholder')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'when search text is cleared programmatically, it should reveal the placeholder',
      (tester) async {
        final controller = MateoTextController(text: 'Liberdade');
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          TestApp(
            child: MateoTextField(
              placeholder: 'Search places',
              presentation: MateoTextFieldPresentation.search(variant: .floating),
              controller: controller,
              onChanged: (_) {},
            ),
          ),
        );

        controller.clear();
        await tester.pump();

        expect(controller.text, isEmpty);
        expect(
          find.byKey(const ValueKey('mateo_text_field_search_clear')),
          findsNothing,
        );
        expect(
          tester
              .widget<FadeTransition>(
                find.byKey(
                  const ValueKey(
                    'mateo_text_field_search_placeholder_reveal',
                  ),
                ),
              )
              .opacity
              .value,
          equals(0),
        );
      },
    );

    testWidgets(
      'when the last search character is deleted, it should reveal the placeholder with the shared transition',
      (tester) async {
        final controller = MateoTextController(text: 'M');
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          TestApp(
            child: MateoTextField(
              placeholder: 'Search places',
              presentation: MateoTextFieldPresentation.search(variant: .floating),
              controller: controller,
              onChanged: (_) {},
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), '');
        await tester.pump();

        final placeholderReveal = find.byKey(
          const ValueKey('mateo_text_field_search_placeholder_reveal'),
        );
        expect(
          tester.widget<FadeTransition>(placeholderReveal).opacity.value,
          equals(0),
        );

        await tester.pump(const Duration(milliseconds: 125));

        final placeholderOpacity = tester.widget<FadeTransition>(placeholderReveal).opacity.value;
        final placeholderScale = tester
            .widget<ScaleTransition>(
              find.descendant(
                of: placeholderReveal,
                matching: find.byType(ScaleTransition),
              ),
            )
            .scale
            .value;
        expect(placeholderOpacity, greaterThan(0));
        expect(placeholderOpacity, lessThan(1));
        expect(placeholderScale, greaterThan(0.9));
        expect(placeholderScale, lessThan(1));
      },
    );

    testWidgets(
      'when reduced motion is enabled and search text is cleared, it should show the placeholder immediately',
      (tester) async {
        final controller = MateoTextController(text: 'Liberdade');
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: TestApp(
              child: MateoTextField(
                placeholder: 'Search places',
                presentation: MateoTextFieldPresentation.search(variant: .floating),
                controller: controller,
                onChanged: (_) {},
              ),
            ),
          ),
        );

        await tester.tap(
          find.byKey(const ValueKey('mateo_text_field_search_clear')),
        );
        await tester.pump();

        expect(controller.text, isEmpty);
        expect(
          tester
              .widget<FadeTransition>(
                find.byKey(
                  const ValueKey(
                    'mateo_text_field_search_placeholder_reveal',
                  ),
                ),
              )
              .opacity
              .value,
          equals(1),
        );
      },
    );

    testWidgets(
      'when new search text arrives during the placeholder reveal, it should cancel the transition',
      (tester) async {
        final controller = MateoTextController(text: 'Liberdade');
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          TestApp(
            child: MateoTextField(
              placeholder: 'Search places',
              presentation: MateoTextFieldPresentation.search(variant: .floating),
              controller: controller,
              onChanged: (_) {},
            ),
          ),
        );

        await tester.tap(
          find.byKey(const ValueKey('mateo_text_field_search_clear')),
        );
        await tester.pump();
        await tester.enterText(find.byType(TextField), 'Sé');
        await tester.pump();

        expect(controller.text, equals('Sé'));
        expect(
          find.byKey(const ValueKey('mateo_text_field_search_placeholder')),
          findsNothing,
        );
      },
    );

    testWidgets(
      'when single-line search text scrolls, it should keep its directional fade mask mounted',
      (tester) async {
        const text = 'Rua Oscar Freire, Liberdade, São Paulo, Brasil';
        final controller = MateoTextController(text: text);
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          TestApp(
            child: SizedBox(
              width: 240,
              child: MateoTextField(
                placeholder: 'Search places',
                presentation: MateoTextFieldPresentation.search(variant: .floating),
                controller: controller,
                onChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final textScrollController = tester.widget<TextField>(find.byType(TextField)).scrollController!;
        expect(textScrollController.hasClients, isTrue);
        expect(textScrollController.offset, equals(0));

        expect(
          find.byKey(const ValueKey('mateo_text_field_search_fade_mask')),
          findsOneWidget,
        );
        expect(
          tester
              .widget<ShaderMask>(
                find.byKey(const ValueKey('mateo_text_field_search_fade_mask')),
              )
              .blendMode,
          equals(BlendMode.dstIn),
        );
        expect(
          tester.widget<TextField>(find.byType(TextField)).clipBehavior,
          equals(Clip.none),
        );

        controller.value = const TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
        controller.focus();
        await tester.pumpAndSettle();

        expect(textScrollController.offset, greaterThan(0));
        expect(
          find.byKey(const ValueKey('mateo_text_field_search_fade_mask')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'when overflowing search text is selected, it should paint the selection through the fade mask',
      (tester) async {
        const text = 'Rua Oscar Freire, Liberdade, São Paulo, Brasil';
        final controller = MateoTextController(text: text);
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          TestApp(
            child: SizedBox(
              width: 240,
              child: MateoTextField(
                placeholder: 'Search places',
                presentation: MateoTextFieldPresentation.search(variant: .floating),
                controller: controller,
                onChanged: (_) {},
              ),
            ),
          ),
        );

        controller
          ..focus()
          ..value = const TextEditingValue(
            text: text,
            selection: TextSelection(baseOffset: 0, extentOffset: text.length),
          );
        await tester.pumpAndSettle();

        expect(
          find.byKey(
            const ValueKey('mateo_text_field_search_selection_painter'),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'when search has no consumer controller, it should still own and clear its text',
      (tester) async {
        String? changedValue;

        await tester.pumpWidget(
          TestApp(
            child: MateoTextField(
              placeholder: 'Search places',
              presentation: MateoTextFieldPresentation.search(variant: .floating),
              onChanged: (value) => changedValue = value,
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'Mateo');
        await tester.pumpAndSettle();
        await tester.tap(
          find.byKey(const ValueKey('mateo_text_field_search_clear')),
        );
        await tester.pumpAndSettle();

        expect(
          tester.widget<TextField>(find.byType(TextField)).controller!.text,
          isEmpty,
        );
        expect(changedValue, isEmpty);
      },
    );

    testWidgets(
      'when search controller ownership changes, it should replace and dispose only its internal controller',
      (tester) async {
        final externalController = MateoTextController(text: 'External');
        addTearDown(externalController.dispose);
        MateoTextController? controller;
        late StateSetter setState;

        await tester.pumpWidget(
          TestApp(
            child: StatefulBuilder(
              builder: (context, stateSetter) {
                setState = stateSetter;
                return MateoTextField(
                  placeholder: 'Search places',
                  presentation: MateoTextFieldPresentation.search(variant: .floating),
                  controller: controller,
                  onChanged: (_) {},
                );
              },
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'Owned');
        expect(
          tester.widget<TextField>(find.byType(TextField)).controller!.text,
          equals('Owned'),
        );

        final ownedController = tester.widget<TextField>(find.byType(TextField)).controller!;
        setState(() => controller = externalController);
        await tester.pump();

        expect(tester.takeException(), isNull);
        expect(find.text('External'), findsOneWidget);
        expect(() => ownedController.addListener(() {}), throwsAssertionError);

        setState(() => controller = null);
        await tester.pump();

        expect(tester.takeException(), isNull);
        expect(
          tester.widget<TextField>(find.byType(TextField)).controller!.text,
          isEmpty,
        );
        await tester.pumpWidget(const SizedBox.shrink());
        externalController.text = 'Still owned by the caller';
        expect(externalController.text, 'Still owned by the caller');
      },
    );

    testWidgets(
      'when search begins with text, it should use the engaged layout without waiting for focus',
      (tester) async {
        final controller = MateoTextController(text: 'Oscar Freire');
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          TestApp(
            child: SizedBox(
              width: 360,
              child: MateoTextField(
                placeholder: 'Search places',
                presentation: MateoTextFieldPresentation.search(variant: .floating),
                controller: controller,
                onChanged: (_) {},
              ),
            ),
          ),
        );

        final surfaceLeft = tester
            .getTopLeft(
              find.byKey(const ValueKey('mateo_text_field_search_surface')),
            )
            .dx;

        expect(find.text('Oscar Freire'), findsOneWidget);
        expect(
          tester
              .getTopLeft(
                find.byKey(const ValueKey('mateo_text_field_search_icon')),
              )
              .dx,
          closeTo(surfaceLeft + 18, 0.01),
        );
        expect(
          find.byKey(const ValueKey('mateo_text_field_search_clear')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'when search has a character limit, it should show a leading floating counter below the surface',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: SizedBox(
              width: 360,
              child: MateoTextField(
                placeholder: 'Search places',
                presentation: MateoTextFieldPresentation.search(variant: .floating),
                maxLength: 5,
                onChanged: (_) {},
              ),
            ),
          ),
        );

        expect(
          find.byKey(const ValueKey('mateo_text_field_search_counter')),
          findsNothing,
        );

        await tester.enterText(find.byType(TextField), 'Ma');
        await tester.pump();

        final surfaceRect = tester.getRect(
          find.byKey(const ValueKey('mateo_text_field_search_surface')),
        );
        final counterRect = tester.getRect(
          find.byKey(const ValueKey('mateo_text_field_search_counter')),
        );

        expect(_counterText(tester), '2/5');
        expect(counterRect.top, equals(surfaceRect.bottom + 8));
        expect(counterRect.left, equals(surfaceRect.left));

        await tester.enterText(find.byType(TextField), 'Mateo');
        await tester.pump();
        final restingCounterLeft = tester
            .getTopLeft(
              find.byKey(const ValueKey('mateo_character_counter')),
            )
            .dx;

        await tester.enterText(find.byType(TextField), 'Mateo!');
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 40));

        expect(
          tester
              .widget<AnimatedDefaultTextStyle>(find.byKey(const ValueKey('mateo_character_counter_text')))
              .style
              .color,
          equals(
            mateoTestColorScheme.characterCounter.floating.foregroundReject,
          ),
        );
        expect(
          tester
              .getTopLeft(
                find.byKey(const ValueKey('mateo_character_counter')),
              )
              .dx,
          isNot(closeTo(restingCounterLeft, 0.5)),
        );
      },
    );

    testWidgets(
      'when search text grows without changing presentation, it should update the character counter',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoTextField(
              placeholder: 'Search places',
              presentation: MateoTextFieldPresentation.search(variant: .floating),
              maxLength: 5,
              onChanged: (_) {},
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'M');
        await tester.pump();
        expect(_counterText(tester), '1/5');

        await tester.enterText(find.byType(TextField), 'Ma');
        await tester.pump();
        expect(_counterText(tester), '2/5');

        await tester.enterText(find.byType(TextField), '👨‍👩‍👧‍👦a');
        await tester.pump();
        expect(_counterText(tester), '2/5');
      },
    );

    testWidgets(
      'when reduced motion is enabled and search reaches its limit, it should show red feedback without shaking the pill',
      (tester) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: TestApp(
              child: MateoTextField(
                placeholder: 'Search places',
                presentation: MateoTextFieldPresentation.search(variant: .floating),
                maxLength: 3,
                onChanged: (_) {},
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'Mat');
        await tester.pump();
        final restingCounterLeft = tester
            .getTopLeft(
              find.byKey(const ValueKey('mateo_text_field_search_counter')),
            )
            .dx;

        await tester.enterText(find.byType(TextField), 'Mateo');
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 40));

        expect(
          tester
              .widget<AnimatedDefaultTextStyle>(find.byKey(const ValueKey('mateo_character_counter_text')))
              .style
              .color,
          equals(
            mateoTestColorScheme.characterCounter.floating.foregroundReject,
          ),
        );
        expect(
          tester
              .getTopLeft(
                find.byKey(const ValueKey('mateo_text_field_search_counter')),
              )
              .dx,
          closeTo(restingCounterLeft, 0.01),
        );
      },
    );

    testWidgets(
      'when search is read only or disabled, it should not expose the clear action',
      (tester) async {
        final controller = MateoTextController(text: 'Mateo');
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          TestApp(
            child: MateoTextField(
              placeholder: 'Search places',
              presentation: MateoTextFieldPresentation.search(variant: .floating),
              controller: controller,
              editable: false,
              onChanged: (_) {},
            ),
          ),
        );

        expect(
          find.byKey(const ValueKey('mateo_text_field_search_clear')),
          findsNothing,
        );

        await tester.pumpWidget(
          TestApp(
            child: MateoTextField(
              placeholder: 'Search places',
              presentation: MateoTextFieldPresentation.search(variant: .floating),
              controller: controller,
            ),
          ),
        );

        expect(
          tester.widget<TextField>(find.byType(TextField)).enabled,
          isFalse,
        );
        expect(
          find.byKey(const ValueKey('mateo_text_field_search_clear')),
          findsNothing,
        );
      },
    );

    testWidgets(
      'when search is disabled, it should use the disabled surface colors',
      (tester) async {
        const backgroundDisabled = Color(0xFFE5EAFA);
        final searchColors = mateoTestColorScheme.textField.floating.copyWith(
          backgroundDisabled: backgroundDisabled,
        );
        final colorScheme = mateoTestColorScheme.copyWith(
          textField: mateoTestColorScheme.textField.copyWith(
            floating: searchColors,
          ),
        );
        final theme = mateoTestTheme.copyWith(
          extensions: [
            mateoTestThemeData.copyWith(
              colorScheme: colorScheme,
            ),
          ],
        );

        await tester.pumpWidget(
          TestApp(
            theme: theme,
            child: const MateoTextField(
              placeholder: 'Search places',
              presentation: MateoTextFieldPresentation.search(variant: .floating),
            ),
          ),
        );

        final surface = find.byKey(
          const ValueKey('mateo_text_field_search_surface'),
        );
        final decoration = tester.widget<DecoratedBox>(surface).decoration as BoxDecoration;
        final material = tester.widget<Material>(
          find.descendant(of: surface, matching: find.byType(Material)),
        );
        final shape = material.shape! as RoundedRectangleBorder;
        expect(material.color, backgroundDisabled);
        expect(shape.side, BorderSide.none);
        expect(decoration.boxShadow!.single.color, mateoTestPalette.neutral[12].withValues(alpha: 0.1));
      },
    );

    testWidgets(
      'when search uses right to left direction, it should mirror its leading controls and counter',
      (tester) async {
        final controller = MateoTextController(text: 'القاهرة');
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          TestApp(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SizedBox(
                width: 360,
                child: MateoTextField(
                  placeholder: 'ابحث عن مكان',
                  presentation: MateoTextFieldPresentation.search(variant: .floating),
                  controller: controller,
                  maxLength: 20,
                  onChanged: (_) {},
                ),
              ),
            ),
          ),
        );

        final surfaceRect = tester.getRect(
          find.byKey(const ValueKey('mateo_text_field_search_surface')),
        );
        final iconRect = tester.getRect(
          find.byKey(const ValueKey('mateo_text_field_search_icon')),
        );
        final counterRect = tester.getRect(
          find.byKey(const ValueKey('mateo_text_field_search_counter')),
        );

        expect(iconRect.right, closeTo(surfaceRect.right - 18, 0.01));
        expect(counterRect.right, closeTo(surfaceRect.right, 0.01));
      },
    );

    testWidgets(
      'when search text is enlarged in a narrow width, it should preserve its minimum height without overflowing',
      (tester) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: TestApp(
              child: SizedBox(
                width: 180,
                child: MateoTextField(
                  placeholder: 'Search places nearby',
                  presentation: MateoTextFieldPresentation.search(variant: .floating),
                  onChanged: (_) {},
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(
          tester
              .getSize(
                find.byKey(const ValueKey('mateo_text_field_search_surface')),
              )
              .height,
          greaterThanOrEqualTo(56),
        );
      },
    );

    test(
      'when maxLength is not positive, it should reject the configuration',
      () {
        expect(
          () => MateoTextField(
            placeholder: 'Code',
            presentation: MateoTextFieldPresentation.search(variant: .floating),
            maxLength: 0,
          ),
          throwsAssertionError,
        );
      },
    );
  });
}

String _counterText(WidgetTester tester) => tester
    .widgetList<Text>(find.descendant(of: find.byType(MateoCharacterCounter), matching: find.byType(Text)))
    .map((text) => text.data ?? '')
    .join();
