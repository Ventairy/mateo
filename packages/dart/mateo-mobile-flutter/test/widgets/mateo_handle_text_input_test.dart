import 'dart:ui' show SemanticsAction, Tristate;

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

final _theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);

Widget _host(Widget child, {double width = 240, double textScale = 1, TextDirection direction = .ltr}) => MateoApp(
  theme: _theme,
  home: Directionality(
    textDirection: direction,
    child: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
      child: Center(
        child: SizedBox(width: width, child: child),
      ),
    ),
  ),
);

void main() {
  testWidgets('when a handle is entered, it should use identifier typing settings and submit a bare handle', (
    tester,
  ) async {
    final changes = <String>[];
    final submissions = <String>[];
    await tester.pumpWidget(
      _host(
        MateoTextInput(
          placeholder: 'Arroba',
          presentation: const .handle(),
          onChanged: changes.add,
          onSubmitted: submissions.add,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Arroba'), findsOneWidget);
    final configuration = tester.testTextInput.setClientArgs!;
    expect(configuration['inputType'], TextInputType.text.toJson());
    expect(configuration['textCapitalization'], 'TextCapitalization.none');
    expect(configuration['inputAction'], 'TextInputAction.done');
    expect(configuration['autocorrect'], isFalse);
    expect(configuration['enableSuggestions'], isFalse);
    expect(configuration['enableInlinePrediction'], isFalse);
    final field = tester.widget<CupertinoTextField>(find.byType(CupertinoTextField));
    expect(field.smartDashesType, SmartDashesType.disabled);
    expect(field.smartQuotesType, SmartQuotesType.disabled);
    expect(field.autofillHints, isEmpty);
    await tester.enterText(find.byType(CupertinoTextField), ' @Some.Name_42 ');
    await tester.testTextInput.receiveAction(.done);
    expect(changes, ['Some.Name_42']);
    expect(submissions, ['Some.Name_42']);
    expect(tester.widget<MateoIcon>(find.byType(MateoIcon)).icon, MateoIconData.at);
    final presentation = tester.widget<MateoTextInput>(find.byType(MateoTextInput)).presentation;
    expect(presentation.variant, MateoTextInputVariant.plain);
    expect(presentation.size, MateoTextInputSize.standard);
    expect(presentation.elevation, 0);
  }, variant: const TargetPlatformVariant({TargetPlatform.iOS, TargetPlatform.android}));

  testWidgets(
    'when a handle is pasted over selected text, it should normalize the replacement and preserve surrounding content',
    (tester) async {
      final controller = TextEditingController(text: 'before.old.after');
      addTearDown(controller.dispose);
      final changes = <String>[];
      await tester.pumpWidget(
        _host(
          MateoTextInput(
            placeholder: 'Handle',
            presentation: const .handle(),
            controller: controller,
            onChanged: changes.add,
          ),
        ),
      );
      await tester.pumpAndSettle();
      controller.selection = const TextSelection(baseOffset: 7, extentOffset: 10);
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method == 'Clipboard.getData') return {'text': ' @New 名 '};
        return null;
      });
      addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));
      final paste = tester.state<EditableTextState>(find.byType(EditableText)).pasteText(.toolbar);
      await tester.pumpAndSettle();
      await paste;
      expect(controller.text, 'before.New名.after');
      expect(controller.selection, const TextSelection.collapsed(offset: 11));
      expect(changes, ['before.New名.after']);
    },
  );

  testWidgets(
    'when the app assigns or replaces controllers, it should preserve their values without invoking onChanged',
    (tester) async {
      final first = TextEditingController(text: '@Initial Value');
      final second = TextEditingController(text: '@Replacement Value');
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      final changes = <String>[];
      Widget input(TextEditingController controller) => _host(
        MateoTextInput(
          placeholder: 'Handle',
          presentation: const .handle(),
          controller: controller,
          onChanged: changes.add,
        ),
      );
      await tester.pumpWidget(input(first));
      await tester.pumpAndSettle();
      expect(first.text, '@Initial Value');
      first.value = const TextEditingValue(
        text: '@Assigned Value',
        selection: TextSelection(baseOffset: 1, extentOffset: 5),
      );
      await tester.pump();
      expect(first.text, '@Assigned Value');
      expect(first.selection, const TextSelection(baseOffset: 1, extentOffset: 5));
      await tester.pumpWidget(input(second));
      expect(tester.widget<EditableText>(find.byType(EditableText)).controller, same(second));
      expect(second.text, '@Replacement Value');
      expect(changes, isEmpty);
      await tester.enterText(find.byType(CupertinoTextField), '@User Edit');
      expect(second.text, 'UserEdit');
      expect(changes, ['UserEdit']);
    },
  );

  testWidgets('when the prefix is tapped, it should focus the editor without editing the handle', (tester) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    final changes = <String>[];
    await tester.pumpWidget(
      _host(
        MateoTextInput(
          autofocus: false,
          focusNode: focusNode,
          placeholder: 'Handle',
          presentation: const .handle(),
          onChanged: changes.add,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(focusNode.hasFocus, isFalse);
    await tester.tap(find.byType(MateoIcon));
    await tester.pump();
    expect(focusNode.hasFocus, isTrue);
    expect(tester.testTextInput.isVisible, isTrue);
    expect(changes, isEmpty);
  });

  testWidgets('when all handle text is selected and copied, it should exclude the fixed prefix', (tester) async {
    final controller = TextEditingController(text: 'Some.Name');
    addTearDown(controller.dispose);
    String? copiedText;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') copiedText = (call.arguments as Map<dynamic, dynamic>)['text'] as String;
      return null;
    });
    addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));
    await tester.pumpWidget(
      _host(
        MateoTextInput(placeholder: 'Handle', presentation: const .handle(), controller: controller, onChanged: (_) {}),
      ),
    );
    await tester.pumpAndSettle();
    final editor = tester.state<EditableTextState>(find.byType(EditableText))..selectAll(.toolbar);
    await tester.pump();
    expect(controller.selection, const TextSelection(baseOffset: 0, extentOffset: 9));
    editor.copySelection(.toolbar);
    await tester.pump();
    expect(copiedText, 'Some.Name');
  });

  for (final enabled in [true, false]) {
    testWidgets(
      'when a handle is ${enabled ? 'enabled' : 'disabled'}, it should expose its editable semantics and themed colors without a separate prefix announcement',
      (tester) async {
        final semantics = tester.ensureSemantics();
        final controller = TextEditingController();
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          _host(
            MateoTextInput(
              placeholder: 'Handle',
              presentation: const .handle(),
              controller: controller,
              onChanged: enabled ? (_) {} : null,
            ),
          ),
        );
        await tester.pumpAndSettle();
        final colors = _theme.colorScheme.textInputs.plain;
        final field = tester.widget<CupertinoTextField>(find.byType(CupertinoTextField));
        final icon = tester.widget<MateoIcon>(find.byType(MateoIcon));
        expect(field.style!.color, enabled ? colors.text : colors.textDisabled);
        expect(field.placeholderStyle!.color, enabled ? colors.placeholder : colors.placeholderDisabled);
        expect(icon.color, enabled ? colors.icon : colors.iconDisabled);
        final data = tester.getSemantics(find.byType(EditableText)).getSemanticsData();
        expect(data.label, 'Handle');
        expect(data.value, isEmpty);
        controller.text = 'Some.Name';
        await tester.pump();
        expect(tester.getSemantics(find.byType(EditableText)).getSemanticsData().value, 'Some.Name');
        expect(data.flagsCollection.isTextField, isTrue);
        expect(data.flagsCollection.isEnabled, enabled ? Tristate.isTrue : Tristate.isFalse);
        expect(data.hasAction(SemanticsAction.setText), enabled);
        expect(find.bySemanticsLabel('@'), findsNothing);
        expect(find.byType(MateoSurface), findsNothing);
        if (!enabled) {
          await tester.tap(find.byType(MateoIcon));
          await tester.pump();
          expect(field.focusNode!.hasFocus, isFalse);
          expect(tester.testTextInput.isVisible, isFalse);
        }
        semantics.dispose();
      },
    );
  }

  for (final size in MateoTextInputSize.values) {
    testWidgets('when a ${size.name} handle uses large text, it should grow without clipping its content', (
      tester,
    ) async {
      Widget input() => MateoTextInput(
        autofocus: false,
        placeholder: 'Handle',
        presentation: .handle(size: size),
        onChanged: (_) {},
      );
      await tester.pumpWidget(_host(input()));
      final ordinaryHeight = tester.getSize(find.byType(MateoTextInput)).height;
      final iconBounds = tester.getRect(find.byType(MateoIcon));
      final inputBounds = tester.getRect(find.byType(MateoTextInput));
      expect(inputBounds.top, iconBounds.top);
      expect(inputBounds.bottom, iconBounds.bottom);
      expect(inputBounds.right, tester.getRect(find.byType(EditableText)).right);
      expect(
        tester.getRect(find.byType(MateoIcon)).left,
        tester.getRect(find.byType(MateoTextInput)).left,
      );
      expect(tester.widget<MateoIcon>(find.byType(MateoIcon)).size, size.leadingIconSize);
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).style.fontSize,
        MateoTextInputVariant.plain.resolveTypography(size).fontSize,
      );
      await tester.pumpWidget(_host(input(), textScale: 3));
      expect(tester.getSize(find.byType(MateoTextInput)).height, greaterThan(ordinaryHeight));
      expect(
        tester.getRect(find.byType(MateoTextInput)),
        tester.getRect(find.byType(CupertinoTextField)).expandToInclude(tester.getRect(find.byType(MateoIcon))),
      );
      expect(tester.getSize(find.byType(CupertinoTextField)).height, tester.getSize(find.byType(EditableText)).height);
      expect(tester.takeException(), isNull);
    });
  }

  for (final direction in TextDirection.values) {
    testWidgets(
      'when a long handle is entered in ${direction.name} surroundings, it should scroll to the caret while keeping the prefix on the left',
      (tester) async {
        final controller = TextEditingController();
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          _host(
            MateoTextInput(
              placeholder: 'Handle',
              presentation: const .handle(),
              controller: controller,
              onChanged: (_) {},
            ),
            direction: direction,
            width: 120,
          ),
        );
        await tester.pumpAndSettle();
        final prefixBounds = tester.getRect(find.byType(MateoIcon));
        final text = 'Some.שם_名前42' * 12;
        await tester.enterText(find.byType(CupertinoTextField), text);
        await tester.pumpAndSettle();
        final editor = tester.state<EditableTextState>(find.byType(EditableText)).renderEditable;
        expect(editor.textDirection, TextDirection.ltr);
        expect(controller.text, text);
        expect(tester.getRect(find.byType(MateoIcon)), prefixBounds);
        expect(prefixBounds.right, lessThan(tester.getRect(find.byType(EditableText)).left));
        final scrollable = tester.state<ScrollableState>(find.byType(Scrollable));
        expect(scrollable.position.maxScrollExtent, greaterThan(0));
        expect(scrollable.position.pixels, greaterThan(0));
        final caret = editor.getLocalRectForCaret(controller.selection.extent);
        expect(caret.left, greaterThanOrEqualTo(0));
        expect(caret.right, lessThanOrEqualTo(editor.size.width));
        expect(tester.takeException(), isNull);
      },
    );
  }
}
