import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

Widget _host(Widget input, {MateoThemeData? theme}) => MateoApp(
  theme:
      theme ??
      MateoThemeData.light(
        accentColor: const Color(0xFF4A5CFF),
        onAccent: MateoPalette().white,
      ),
  home: Center(child: SizedBox(width: 320, child: input)),
);

void main() {
  testWidgets('when Android editing controls read their theme repeatedly, they reuse the resolved Material theme', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        MateoTextInput(
          autofocus: true,
          placeholder: 'Code',
          presentation: .general(variant: .filled.neutral, purpose: .code),
          onChanged: (_) {},
        ),
      ),
    );
    await tester.enterText(find.byType(EditableText), 'INVITE');
    await tester.pump();
    final editingContext = tester.element(find.byType(EditableText));
    final editingTheme = material.Theme.of(editingContext);
    expect(material.Theme.of(editingContext), same(editingTheme));
    await tester.enterText(find.byType(EditableText), 'INVITE2');
    await tester.pump();
    expect(material.Theme.of(editingContext), same(editingTheme));
  }, variant: TargetPlatformVariant.only(.android));

  testWidgets('when the Mateo accent changes, the native editing theme follows it', (tester) async {
    for (final accent in [MateoPalette().blue[9], MateoPalette().green[9]]) {
      final theme = MateoThemeData.light(accentColor: accent, onAccent: MateoPalette().white);
      await tester.pumpWidget(
        _host(
          MateoTextInput(
            autofocus: true,
            placeholder: 'Code',
            presentation: .general(variant: .filled.neutral, purpose: .code),
            onChanged: (_) {},
          ),
          theme: theme,
        ),
      );
      await tester.pump();
      final editingContext = tester.element(find.byType(EditableText));
      expect(material.Theme.of(editingContext).colorScheme.primary, theme.colorScheme.accent);
      expect(material.TextSelectionTheme.of(editingContext).selectionHandleColor, theme.colorScheme.accent);
    }
  }, variant: TargetPlatformVariant.only(.android));

  for (final phone in [false, true]) {
    testWidgets(
      'when a ${phone ? 'phone' : 'search'} consumer rebuilds after an edit, it should keep the field widget stable',
      (
        tester,
      ) async {
        var shownValue = '';
        await tester.pumpWidget(
          _host(
            StatefulBuilder(
              builder: (context, rebuildParent) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MateoTextInput(
                    autofocus: false,
                    placeholder: 'Input',
                    presentation: phone ? const .phone(initialCountry: .brazil) : const .search(variant: .filled),
                    onChanged: (value) => rebuildParent(() => shownValue = value),
                  ),
                  Text(shownValue),
                ],
              ),
            ),
          ),
        );
        await tester.enterText(find.byType(CupertinoTextField), phone ? '119' : 'bra');
        await tester.pump();
        final field = tester.widget<CupertinoTextField>(find.byType(CupertinoTextField));

        await tester.enterText(find.byType(CupertinoTextField), phone ? '1198' : 'braz');
        await tester.pump();

        expect(tester.widget<CupertinoTextField>(find.byType(CupertinoTextField)), same(field));
      },
    );
  }

  testWidgets('when a consumer replaces its edit callback, it should invoke the new callback', (tester) async {
    final oldValues = <String>[];
    final newValues = <String>[];
    late StateSetter rebuildParent;
    var onChanged = oldValues.add;
    await tester.pumpWidget(
      _host(
        StatefulBuilder(
          builder: (context, rebuild) {
            rebuildParent = rebuild;
            final currentCallback = onChanged;
            return MateoTextInput(
              autofocus: false,
              placeholder: 'Search',
              presentation: const .search(variant: .filled),
              onChanged: currentCallback,
            );
          },
        ),
      ),
    );
    await tester.enterText(find.byType(CupertinoTextField), 'bra');
    await tester.pump();
    rebuildParent(() => onChanged = newValues.add);
    await tester.pump();
    await tester.enterText(find.byType(CupertinoTextField), 'braz');
    await tester.pump();

    expect((oldValues.length, newValues.length), (1, 1));
  });

  testWidgets('when a consumer replaces its submit callback, it should invoke the new callback', (tester) async {
    final oldValues = <String>[];
    final newValues = <String>[];
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    Widget input(ValueChanged<String> onSubmitted) => MateoTextInput(
      autofocus: false,
      focusNode: focusNode,
      placeholder: 'Search',
      presentation: const .search(variant: .filled),
      onChanged: (_) {},
      onSubmitted: onSubmitted,
    );

    await tester.pumpWidget(_host(input(oldValues.add)));
    await tester.enterText(find.byType(CupertinoTextField), 'bra');
    await tester.testTextInput.receiveAction(.search);
    await tester.pumpWidget(_host(input(newValues.add)));
    focusNode.requestFocus();
    await tester.pump();
    await tester.testTextInput.receiveAction(.search);

    expect((oldValues.length, newValues.length), (1, 1));
  });

  testWidgets('when a disabled consumer gains an edit callback, it should enable the field', (tester) async {
    Widget input(ValueChanged<String>? onChanged) => MateoTextInput(
      autofocus: false,
      placeholder: 'Search',
      presentation: const .search(variant: .filled),
      onChanged: onChanged,
    );

    await tester.pumpWidget(_host(input(null)));
    await tester.pumpWidget(_host(input((_) {})));

    expect(tester.widget<CupertinoTextField>(find.byType(CupertinoTextField)).enabled, isTrue);
  });

  testWidgets('when editing nonempty search text, it should keep the field widget stable', (tester) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await tester.pumpWidget(
      _host(
        MateoTextInput(
          autofocus: false,
          focusNode: focusNode,
          placeholder: 'Search',
          presentation: const .search(variant: .filled),
          onChanged: (_) {},
        ),
      ),
    );
    focusNode.requestFocus();
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(CupertinoTextField), 'coffee');
    await tester.pumpAndSettle();

    final field = tester.widget<CupertinoTextField>(find.byType(CupertinoTextField));
    await tester.enterText(find.byType(CupertinoTextField), 'coffee shop');
    await tester.pump();

    expect(tester.widget<CupertinoTextField>(find.byType(CupertinoTextField)), same(field));
  });

  testWidgets('when moving a search selection, it should keep the field widget stable', (tester) async {
    final controller = TextEditingController(text: 'coffee');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _host(
        MateoTextInput(
          autofocus: false,
          controller: controller,
          placeholder: 'Search',
          presentation: const .search(variant: .filled),
          onChanged: (_) {},
        ),
      ),
    );
    final field = tester.widget<CupertinoTextField>(find.byType(CupertinoTextField));

    controller.selection = const TextSelection.collapsed(offset: 3);
    await tester.pump();

    expect(tester.widget<CupertinoTextField>(find.byType(CupertinoTextField)), same(field));
  });

  testWidgets('when editing a phone number in the same country, it should keep the field widget stable', (
    tester,
  ) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await tester.pumpWidget(
      _host(
        MateoTextInput(
          autofocus: false,
          focusNode: focusNode,
          placeholder: 'Phone number',
          presentation: const .phone(initialCountry: .brazil),
          onChanged: (_) {},
        ),
      ),
    );
    focusNode.requestFocus();
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(CupertinoTextField), '1196');
    await tester.pumpAndSettle();

    final field = tester.widget<CupertinoTextField>(find.byType(CupertinoTextField));
    await tester.enterText(find.byType(CupertinoTextField), '1196923');
    await tester.pump();

    expect(tester.widget<CupertinoTextField>(find.byType(CupertinoTextField)), same(field));
  });
}
