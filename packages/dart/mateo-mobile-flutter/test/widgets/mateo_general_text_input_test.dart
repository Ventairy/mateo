import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_edge_fade/mateo_edge_fade_painter.dart';

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
        .code: (
          keyboardType: .text,
          capitalization: .characters,
          autocorrect: false,
          suggestions: false,
          autofillHints: [],
          enteredText: 'ABC123',
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

  for (final variant in [MateoTextInputVariant.plain, MateoTextInputVariant.filled]) {
    for (final MapEntry(key: purpose, value: scenario) in purposeScenarios.entries) {
      testWidgets(
        'when general $variant is for ${purpose.name}, it should configure typing assistance and preserve entered content',
        (tester) async {
          final changes = <String>[];
          final submissions = <String>[];
          await tester.pumpWidget(
            _host(
              MateoTextInput(
                placeholder: 'Text',
                presentation: .general(variant: variant, purpose: purpose),
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
  }

  for (final variant in [MateoTextInputVariant.plain, MateoTextInputVariant.filled]) {
    testWidgets(
      'when code $variant receives typing or paste, it should uppercase letters and remove spaces while preserving app-supplied values',
      (
        tester,
      ) async {
        final controller = TextEditingController(text: 'initialCode');
        addTearDown(controller.dispose);
        final changes = <String>[];
        final submissions = <String>[];
        await tester.pumpWidget(
          _host(
            MateoTextInput(
              placeholder: 'Code',
              presentation: .general(variant: variant, purpose: .code),
              controller: controller,
              onChanged: changes.add,
              onSubmitted: submissions.add,
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(controller.text, 'initialCode');
        controller.text = 'appCode';
        await tester.pump();
        expect(controller.text, 'appCode');
        expect(changes, isEmpty);
        await tester.enterText(find.byType(CupertinoTextField), '  ab  12 ');
        expect(controller.text, 'AB12');
        controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'Clipboard.getData') return {'text': '  cd  34!? 🌻  '};
          return null;
        });
        addTearDown(
          () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null),
        );
        final paste = tester.state<EditableTextState>(find.byType(EditableText)).pasteText(.toolbar);
        await tester.pumpAndSettle();
        await paste;
        expect(controller.text, 'CD34!?🌻');
        expect(changes, ['AB12', 'CD34!?🌻']);
        await tester.testTextInput.receiveAction(.done);
        expect(submissions, ['CD34!?🌻']);
      },
    );
  }

  for (final variant in [MateoTextInputVariant.plain, MateoTextInputVariant.filled]) {
    testWidgets(
      'when code $variant edits include Unicode letters or compose text, it should preserve editing positions and wait for commitment',
      (tester) async {
        final controller = TextEditingController();
        addTearDown(controller.dispose);
        final changes = <String>[];
        await tester.pumpWidget(
          _host(
            MateoTextInput(
              placeholder: 'Code',
              presentation: .general(variant: variant, purpose: .code),
              controller: controller,
              onChanged: changes.add,
            ),
          ),
        );
        await tester.pumpAndSettle();
        tester.testTextInput.updateEditingValue(
          const TextEditingValue(text: 'aé12', selection: TextSelection.collapsed(offset: 2)),
        );
        expect(controller.text, 'AÉ12');
        expect(controller.selection, const TextSelection.collapsed(offset: 2));
        tester.testTextInput.updateEditingValue(
          const TextEditingValue(
            text: 'aé12b',
            selection: TextSelection(baseOffset: 5, extentOffset: 2, affinity: .upstream, isDirectional: true),
          ),
        );
        expect(controller.text, 'AÉ12B');
        expect(
          controller.selection,
          const TextSelection(baseOffset: 5, extentOffset: 2, affinity: .upstream, isDirectional: true),
        );
        tester.testTextInput.updateEditingValue(
          const TextEditingValue(
            text: ' a é12 b ',
            selection: TextSelection(baseOffset: 8, extentOffset: 3, affinity: .upstream, isDirectional: true),
          ),
        );
        expect(controller.text, 'AÉ12B');
        expect(
          controller.selection,
          const TextSelection(baseOffset: 5, extentOffset: 1, affinity: .upstream, isDirectional: true),
        );
        const composingValue = TextEditingValue(
          text: 'ab 12',
          selection: TextSelection.collapsed(offset: 3),
          composing: TextRange(start: 0, end: 3),
        );
        changes.clear();
        tester.testTextInput.updateEditingValue(composingValue);
        expect(controller.value, composingValue);
        tester.testTextInput.updateEditingValue(composingValue.copyWith(composing: TextRange.empty));
        expect(controller.text, 'AB12');
        expect(controller.selection, const TextSelection.collapsed(offset: 2));
        expect(controller.value.composing, TextRange.empty);
        expect(changes, ['ab 12', 'AB12']);
      },
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
          MateoTextInputPurpose.code,
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

  for (final variant in [MateoTextInputVariant.filled.base]) {
    test('when general receives $variant, it should reject the unsupported treatment', () {
      expect(
        () => MateoTextInputPresentation.general(variant: variant),
        throwsA(
          isA<AssertionError>().having((error) => error.message, 'message', 'Base is not supported by general'),
        ),
      );
    });
  }
  for (final size in [MateoTextInputSize.small, MateoTextInputSize.standard]) {
    for (final enabled in [true, false]) {
      testWidgets(
        'when filled general is $size and enabled=$enabled, it should use its capsule colors and accessible sizing',
        (tester) async {
          Widget input() => MateoTextInput(
            autofocus: false,
            placeholder: 'Your name',
            presentation: .general(variant: .filled, size: size),
            onChanged: enabled ? (_) {} : null,
          );
          await tester.pumpWidget(_host(input()));
          final surface = tester.widget<MateoSurface>(find.byType(MateoSurface));
          final colors = _theme.colorScheme.textInputs.filled.neutral;
          expect(surface.color, enabled ? colors.background : colors.backgroundDisabled);
          expect(surface.elevation, isNull);
          final field = tester.widget<CupertinoTextField>(find.byType(CupertinoTextField));
          expect(field.style!.color, enabled ? colors.text : colors.textDisabled);
          expect(field.placeholderStyle!.color, enabled ? colors.placeholder : colors.placeholderDisabled);
          expect(field.style!.fontSize, MateoTextInputVariant.filled.resolveTypography(size).fontSize);
          expect(
            field.padding,
            EdgeInsetsDirectional.symmetric(
              horizontal: size.leadingPadding,
              vertical: (size.height - MateoTextInputVariant.filled.resolveTypography(size).lineHeight) / 2,
            ),
          );
          expect(tester.getSize(find.byType(MateoTextInput)).height, size.height);
          expect(find.byType(MateoIcon), findsNothing);
          await tester.pumpWidget(_host(input(), textScale: 3));
          expect(tester.getSize(find.byType(MateoTextInput)).height, greaterThan(size.height));
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets('when general switches between plain and filled, it should preserve editing state and focus', (
    tester,
  ) async {
    Widget input(MateoTextInputVariant variant) => _host(
      MateoTextInput(
        placeholder: 'Code',
        presentation: .general(variant: variant, purpose: .code),
        onChanged: (_) {},
      ),
    );
    await tester.pumpWidget(input(.plain));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(CupertinoTextField), 'abc123');
    final original = tester.widget<EditableText>(find.byType(EditableText));
    original.controller.selection = const TextSelection(baseOffset: 1, extentOffset: 4);
    final value = original.controller.value;
    for (final variant in [MateoTextInputVariant.filled, MateoTextInputVariant.plain]) {
      await tester.pumpWidget(input(variant));
      await tester.pumpAndSettle();
      final editor = tester.widget<EditableText>(find.byType(EditableText));
      expect(editor.controller, same(original.controller));
      expect(editor.controller.value, value);
      expect(editor.focusNode, same(original.focusNode));
      expect(editor.focusNode.hasFocus, isTrue);
    }
  });

  testWidgets('when filled general is large, it should reject the unsupported size', (tester) async {
    await tester.pumpWidget(
      _host(
        MateoTextInput(
          placeholder: 'Text',
          presentation: const .general(variant: .filled, size: .large),
          onChanged: (_) {},
        ),
      ),
    );
    expect(tester.takeException(), isAssertionError);
  });
  for (final direction in TextDirection.values) {
    testWidgets(
      'when long filled general text scrolls in $direction, it should adapt its fades and preserve selection',
      (tester) async {
        final controller = TextEditingController(text: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ' * 4);
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          _host(
            MateoTextInput(
              autofocus: false,
              placeholder: 'Code',
              controller: controller,
              presentation: const .general(variant: .filled),
              onChanged: (_) {},
            ),
            direction: direction,
          ),
        );
        await tester.pumpAndSettle();
        final editable = tester.state<EditableTextState>(find.byType(EditableText));
        final position = editable.renderEditable.offset as ScrollPosition;
        final painter = tester
            .widgetList<CustomPaint>(find.byType(CustomPaint))
            .map((paint) => paint.foregroundPainter)
            .whereType<MateoEdgeFadePainter>()
            .single;
        final bounds = tester.getSize(find.byType(MateoTextInput));
        position.jumpTo(0);
        await tester.pumpAndSettle();
        final start = painter.resolveBands(bounds);
        position.jumpTo(position.maxScrollExtent / 2);
        await tester.pumpAndSettle();
        final middle = painter.resolveBands(bounds);
        expect(middle.every((band) => band.extent > MateoTextInputSize.standard.leadingPadding), isTrue);
        position.jumpTo(position.maxScrollExtent);
        await tester.pumpAndSettle();
        final end = painter.resolveBands(bounds);
        // The two ends exchange their resting and overflow depths.
        expect(start.first.extent, closeTo(end.last.extent, 0.001));
        expect(start.last.extent, closeTo(end.first.extent, 0.001));
        expect(start.map((band) => band.extent), contains(MateoTextInputSize.standard.leadingPadding));
        final value = controller.text;
        controller.selection = TextSelection(baseOffset: 0, extentOffset: value.length);
        await tester.pumpAndSettle();
        expect(controller.text, value);
        expect(controller.selection.extentOffset, value.length);
        expect(tester.takeException(), isNull);
      },
    );
  }
  for (final direction in TextDirection.values) {
    testWidgets('when filled general edits long text in $direction, it should keep the caret inside the resting fade', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          MateoTextInput(
            placeholder: 'Code',
            presentation: const .general(variant: .filled),
            onChanged: (_) {},
          ),
          direction: direction,
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(CupertinoTextField), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ' * 4);
      await tester.pumpAndSettle();
      final editor = tester.state<EditableTextState>(find.byType(EditableText));
      final caret = editor.renderEditable.getLocalRectForCaret(editor.textEditingValue.selection.extent);
      final renderBox = tester.renderObject<RenderBox>(find.byType(MateoTextInput));
      final caretPosition = renderBox.globalToLocal(editor.renderEditable.localToGlobal(caret.center));
      expect(caretPosition.dx, greaterThanOrEqualTo(MateoTextInputSize.standard.leadingPadding));
      expect(caretPosition.dx, lessThanOrEqualTo(renderBox.size.width - MateoTextInputSize.standard.trailingPadding));
      expect(tester.takeException(), isNull);
    });
  }
  for (final variant in [MateoTextInputVariant.plain, MateoTextInputVariant.filled]) {
    for (final direction in TextDirection.values) {
      testWidgets(
        'when general $variant text is dragged in $direction, it should scroll without moving the caret or editing',
        (tester) async {
          final controller = TextEditingController.fromValue(
            const TextEditingValue(
              text: 'Coffee shops and bakeries nearby with outdoor seating and warm drinks',
              selection: TextSelection.collapsed(offset: 0),
            ),
          );
          addTearDown(controller.dispose);
          final changes = <String>[];
          await tester.pumpWidget(
            _host(
              MateoTextInput(
                autofocus: false,
                placeholder: 'Text',
                controller: controller,
                presentation: .general(variant: variant),
                onChanged: changes.add,
              ),
              direction: direction,
            ),
          );
          await tester.pumpAndSettle();
          final editor = tester.widget<EditableText>(find.byType(EditableText));
          final scroll = tester.widget<CupertinoTextField>(find.byType(CupertinoTextField)).scrollController!;
          for (final focused in [false, true]) {
            if (focused) {
              await tester.tap(find.byType(EditableText));
              await tester.pumpAndSettle();
            }
            expect(editor.focusNode.hasFocus, focused);
            final editingValue = controller.value;
            scroll.jumpTo(scroll.position.maxScrollExtent / 2);
            await tester.pumpAndSettle();
            final initialOffset = scroll.offset;
            final gesture = await tester.startGesture(tester.getCenter(find.byType(EditableText)));
            await gesture.moveBy(const Offset(-50, 0));
            await tester.pump(const Duration(milliseconds: 100));
            await gesture.moveBy(const Offset(-30, 0));
            await tester.pump(const Duration(milliseconds: 100));
            expect((scroll.offset - initialOffset).abs(), greaterThan(10));
            await gesture.up();
            await tester.pumpAndSettle();
            expect(controller.value, editingValue);
            expect(editor.focusNode.hasFocus, focused);
            expect(changes, isEmpty);
          }
          await tester.longPress(find.byType(EditableText));
          await tester.pumpAndSettle();
          expect(controller.selection.isValid, isTrue);
          expect(editor.focusNode.hasFocus, isTrue);
          await tester.tap(find.byType(EditableText));
          await tester.pump(const Duration(milliseconds: 50));
          await tester.tap(find.byType(EditableText));
          await tester.pumpAndSettle();
          expect(controller.selection.isCollapsed, isFalse);
          expect(changes, isEmpty);
          expect(tester.takeException(), isNull);
        },
        variant: const TargetPlatformVariant({TargetPlatform.iOS, TargetPlatform.android}),
      );
    }

    testWidgets('when disabled general $variant text is dragged, it should stay still and unfocused', (tester) async {
      final controller = TextEditingController(text: 'Coffee shops and bakeries nearby with outdoor seating');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(
          MateoTextInput(
            controller: controller,
            placeholder: 'Text',
            presentation: .general(variant: variant),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final scroll = tester.widget<CupertinoTextField>(find.byType(CupertinoTextField)).scrollController!;
      final initialOffset = scroll.offset;
      final value = controller.value;
      await tester.drag(find.byType(EditableText), const Offset(-80, 0), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(scroll.offset, initialOffset);
      expect(controller.value, value);
      expect(tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus, isFalse);
    });
  }
}
