import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

final _theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);

Widget _host(Widget child, {double textScale = 1, TextDirection direction = .ltr}) => MateoApp(
  theme: _theme,
  home: Directionality(
    textDirection: direction,
    child: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
      child: Center(child: SizedBox(width: 240, child: child)),
    ),
  ),
);

void main() {
  testWidgets('when general receives ordinary text, it should preserve edits and submit with Done', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    final changes = <String>[];
    final submissions = <String>[];
    await tester.pumpWidget(
      _host(
        MateoTextInput(
          placeholder: 'Your name',
          presentation: const .general(variant: .plain),
          controller: controller,
          onChanged: changes.add,
          onSubmitted: submissions.add,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Your name'), findsOneWidget);
    expect(tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus, isTrue);
    expect(tester.testTextInput.setClientArgs!['inputType'], containsPair('name', 'TextInputType.text'));
    expect(tester.testTextInput.setClientArgs!['textCapitalization'], 'TextCapitalization.sentences');
    await tester.enterText(find.byType(CupertinoTextField), 'João 42! 🌻');
    await tester.testTextInput.receiveAction(.done);
    await tester.pump();
    expect(controller.text, 'João 42! 🌻');
    expect(changes, ['João 42! 🌻']);
    expect(submissions, ['João 42! 🌻']);
    final placeholderVisibility = tester.widget<Visibility>(
      find.ancestor(of: find.text('Your name'), matching: find.byType(Visibility)).first,
    );
    expect(placeholderVisibility.visible, isFalse);
    expect(find.byType(MateoIcon), findsNothing);
  });

  final purposeScenarios =
      <
        MateoTextInputPurpose,
        ({
          TextInputType keyboardType,
          TextCapitalization capitalization,
          bool autocorrect,
          bool suggestions,
          List<String> autofillHints,
          String enteredText,
        })
      >{
        .text: (
          keyboardType: .text,
          capitalization: .sentences,
          autocorrect: true,
          suggestions: true,
          autofillHints: [],
          enteredText: '  Olá, world! 🌻  ',
        ),
        .givenName: (
          keyboardType: .text,
          capitalization: .words,
          autocorrect: false,
          suggestions: true,
          autofillHints: [AutofillHints.givenName],
          enteredText: 'João',
        ),
        .email: (
          keyboardType: .emailAddress,
          capitalization: .none,
          autocorrect: false,
          suggestions: false,
          autofillHints: [AutofillHints.email],
          enteredText: 'Joao.Example+Tag@Example.COM',
        ),
        .phone: (
          keyboardType: .phone,
          capitalization: .none,
          autocorrect: false,
          suggestions: false,
          autofillHints: [AutofillHints.telephoneNumber],
          enteredText: '+55 (11) 98765-4321 ext. 9',
        ),
      };

  for (final MapEntry(key: purpose, value: scenario) in purposeScenarios.entries) {
    testWidgets(
      'when general is for ${purpose.name}, it should configure typing assistance and preserve entered content',
      (tester) async {
        final changes = <String>[];
        final submissions = <String>[];
        await tester.pumpWidget(
          _host(
            MateoTextInput(
              placeholder: 'Text',
              presentation: .general(variant: .plain, purpose: purpose),
              onChanged: changes.add,
              onSubmitted: submissions.add,
            ),
          ),
        );
        await tester.pumpAndSettle();
        final configuration = tester.testTextInput.setClientArgs!;
        expect(configuration['inputType'], scenario.keyboardType.toJson());
        expect(configuration['textCapitalization'], scenario.capitalization.toString());
        expect(configuration['autocorrect'], scenario.autocorrect);
        expect(configuration['enableSuggestions'], scenario.suggestions);
        expect(configuration['inputAction'], 'TextInputAction.done');
        final field = tester.widget<CupertinoTextField>(find.byType(CupertinoTextField));
        expect(field.smartDashesType, purpose == .text ? SmartDashesType.enabled : SmartDashesType.disabled);
        expect(field.smartQuotesType, purpose == .text ? SmartQuotesType.enabled : SmartQuotesType.disabled);
        expect(field.autofillHints, scenario.autofillHints);
        await tester.enterText(find.byType(CupertinoTextField), scenario.enteredText);
        await tester.testTextInput.receiveAction(.done);
        await tester.pump();
        final editor = tester.widget<EditableText>(find.byType(EditableText));
        expect(editor.controller.text, scenario.enteredText);
        expect(changes, [scenario.enteredText]);
        expect(submissions, [scenario.enteredText]);
        expect(find.byType(MateoIcon), findsNothing);
      },
      variant: const TargetPlatformVariant({TargetPlatform.iOS, TargetPlatform.android}),
    );
  }

  for (final externalFocus in [false, true]) {
    testWidgets(
      'when purpose changes with ${externalFocus ? 'external manual' : 'owned automatic'} focus, it should preserve editing state and update the keyboard',
      (tester) async {
        final changes = <String>[];
        final focusNode = externalFocus ? FocusNode() : null;
        addTearDown(() => focusNode?.dispose());
        Widget input(MateoTextInputPurpose purpose) => _host(
          MateoTextInput(
            autofocus: !externalFocus,
            focusNode: focusNode,
            placeholder: 'Text',
            presentation: .general(variant: .plain, purpose: purpose),
            onChanged: changes.add,
          ),
        );
        await tester.pumpWidget(input(.text));
        await tester.pumpAndSettle();
        if (externalFocus) {
          await tester.showKeyboard(find.byType(EditableText));
          await tester.pump();
        }
        const editingValue = TextEditingValue(
          text: 'João.Example+Tag@Example.COM',
          selection: TextSelection(baseOffset: 0, extentOffset: 4),
        );
        tester.testTextInput.updateEditingValue(editingValue);
        await tester.pump();
        changes.clear();
        final initialEditor = tester.widget<EditableText>(find.byType(EditableText));
        for (final purpose in [
          MateoTextInputPurpose.givenName,
          MateoTextInputPurpose.email,
          MateoTextInputPurpose.phone,
          MateoTextInputPurpose.text,
        ]) {
          await tester.pumpWidget(input(purpose));
          await tester.pump();
          final editor = tester.widget<EditableText>(find.byType(EditableText));
          expect(editor.controller, same(initialEditor.controller));
          expect(editor.controller.value, editingValue);
          expect(editor.focusNode, same(initialEditor.focusNode));
          expect(editor.focusNode.hasFocus, isTrue);
          expect(tester.testTextInput.setClientArgs!['inputType'], purposeScenarios[purpose]!.keyboardType.toJson());
          expect(
            tester.testTextInput.setClientArgs!['textCapitalization'],
            purposeScenarios[purpose]!.capitalization.toString(),
          );
          expect(
            tester.widget<CupertinoTextField>(find.byType(CupertinoTextField)).autofillHints,
            purposeScenarios[purpose]!.autofillHints,
          );
          expect(changes, isEmpty);
        }
      },
      variant: const TargetPlatformVariant({TargetPlatform.iOS, TargetPlatform.android}),
    );
  }

  testWidgets('when purpose changes without focus, it should keep the keyboard closed', (tester) async {
    Widget input(MateoTextInputPurpose purpose) => _host(
      MateoTextInput(
        autofocus: false,
        placeholder: 'Text',
        presentation: .general(variant: .plain, purpose: purpose),
        onChanged: (_) {},
      ),
    );
    await tester.pumpWidget(input(.text));
    await tester.pumpWidget(input(.email));
    await tester.pumpAndSettle();
    expect(tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus, isFalse);
    expect(tester.testTextInput.hasAnyClients, isFalse);
  });

  for (final size in MateoTextInputSize.values) {
    testWidgets('when general is ${size.name}, it should use plain typography and grow for accessible text', (
      tester,
    ) async {
      Widget input() => MateoTextInput(
        autofocus: false,
        placeholder: 'Your name',
        presentation: .general(variant: .plain, size: size),
        onChanged: (_) {},
      );
      await tester.pumpWidget(_host(input()));
      final ordinaryHeight = tester.getSize(find.byType(MateoTextInput)).height;
      expect(ordinaryHeight, greaterThanOrEqualTo(size.height));
      final typography = MateoTextInputVariant.plain.resolveTypography(size);
      final editor = tester.widget<EditableText>(find.byType(EditableText));
      expect(editor.style.fontSize, typography.fontSize);
      expect(editor.style.height, typography.lineHeight / typography.fontSize);
      expect(editor.maxLines, 1);
      expect(editor.focusNode.hasFocus, isFalse);
      await tester.pumpWidget(_host(input(), textScale: 3));
      expect(tester.getSize(find.byType(MateoTextInput)).height, greaterThan(ordinaryHeight));
      expect(tester.takeException(), isNull);
    });
  }

  for (final enabled in [true, false]) {
    testWidgets('when general is ${enabled ? 'enabled' : 'disabled'}, it should use its semantic text colors', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(
          MateoTextInput(
            placeholder: 'Your name',
            presentation: const .general(variant: .plain),
            onChanged: enabled ? (_) {} : null,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final colors = _theme.colorScheme.textInputs.plain;
      final field = tester.widget<CupertinoTextField>(find.byType(CupertinoTextField));
      expect(field.style!.color, enabled ? colors.text : colors.textDisabled);
      expect(field.placeholderStyle!.color, enabled ? colors.placeholder : colors.placeholderDisabled);
      expect(field.cursorColor, _theme.colorScheme.accent);
      expect(field.decoration, const BoxDecoration());
      expect(find.byType(MateoSurface), findsNothing);
      final semanticsData = tester.getSemantics(find.byType(EditableText)).getSemanticsData();
      expect(semanticsData.label, 'Your name');
      expect(semanticsData.flagsCollection.isTextField, isTrue);
      expect(semanticsData.flagsCollection.isFocused, enabled ? Tristate.isTrue : Tristate.isFalse);
      expect(semanticsData.flagsCollection.isEnabled, enabled ? Tristate.isTrue : Tristate.isFalse);
      expect(semanticsData.hasAction(SemanticsAction.setText), enabled);
      semantics.dispose();
    });
  }

  for (final direction in TextDirection.values) {
    testWidgets('when general has no leading icon in ${direction.name}, it should align text with its leading edge', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          MateoTextInput(
            autofocus: false,
            placeholder: 'Text',
            presentation: const .general(variant: .plain),
            onChanged: (_) {},
          ),
          direction: direction,
        ),
      );
      final inputBounds = tester.getRect(find.byType(MateoTextInput));
      final editorBounds = tester.getRect(find.byType(EditableText));
      expect(
        direction == .ltr ? editorBounds.left : editorBounds.right,
        direction == .ltr ? inputBounds.left : inputBounds.right,
      );
    });

    testWidgets('when long general text uses ${direction.name}, it should scroll to the caret without overflowing', (
      tester,
    ) async {
      final text = direction == .rtl ? 'كتابة نص طويل للاختبار ' * 12 : 'A long general text input ' * 12;
      await tester.pumpWidget(
        _host(
          MateoTextInput(
            placeholder: 'Text',
            presentation: const .general(variant: .plain),
            onChanged: (_) {},
          ),
          direction: direction,
        ),
      );
      await tester.enterText(find.byType(CupertinoTextField), text);
      await tester.pumpAndSettle();
      final editor = tester.widget<EditableText>(find.byType(EditableText));
      final renderedEditor = tester.state<EditableTextState>(find.byType(EditableText)).renderEditable;
      expect(renderedEditor.textDirection, direction);
      expect(editor.controller.text, text);
      final scrollable = tester.state<ScrollableState>(find.byType(Scrollable));
      expect(scrollable.position.maxScrollExtent, greaterThan(0));
      final caret = renderedEditor.getLocalRectForCaret(editor.controller.selection.extent);
      expect(caret.left, greaterThanOrEqualTo(0));
      expect(caret.right, lessThanOrEqualTo(renderedEditor.size.width));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('when the general controller changes, it should display the new value without reporting an edit', (
    tester,
  ) async {
    final first = TextEditingController(text: 'First');
    final second = TextEditingController(text: 'Second');
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    final changes = <String>[];
    Widget input(TextEditingController controller) => _host(
      MateoTextInput(
        autofocus: false,
        placeholder: 'Your name',
        presentation: const .general(variant: .plain),
        controller: controller,
        onChanged: changes.add,
      ),
    );
    await tester.pumpWidget(input(first));
    await tester.pumpWidget(input(second));
    expect(find.text('Second'), findsOneWidget);
    first.text = 'Old controller';
    second.text = 'Updated';
    await tester.pump();
    expect(find.text('Updated'), findsOneWidget);
    expect(changes, isEmpty);
    expect(find.byType(MateoIcon), findsNothing);
  });

  test('when general omits size, it should use the standard size with no elevation', () {
    const presentation = MateoTextInputPresentation.general(variant: .plain);
    expect(presentation.size, MateoTextInputSize.standard);
    expect(presentation.elevation, 0);
  });

  for (final variant in [MateoTextInputVariant.filled.neutral, MateoTextInputVariant.filled.base]) {
    test('when general receives $variant, it should reject the unsupported treatment', () {
      expect(
        () => MateoTextInputPresentation.general(variant: variant),
        throwsA(
          isA<AssertionError>().having((error) => error.message, 'message', 'Only plain is supported by general'),
        ),
      );
    });
  }
}
