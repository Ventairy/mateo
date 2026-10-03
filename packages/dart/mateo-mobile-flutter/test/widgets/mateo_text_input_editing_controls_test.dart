import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
    for (final phone in [false, true]) {
      testWidgets('$platform phone=$phone uses platform editing controls inside MateoApp', (tester) async {
        debugDefaultTargetPlatformOverride = platform;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        String? clipboardText;
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'Clipboard.setData') clipboardText = (call.arguments as Map)['text'] as String;
          if (call.method == 'Clipboard.getData') return {'text': clipboardText};
          if (call.method == 'Clipboard.hasStrings') return {'value': clipboardText != null};
          return null;
        });
        addTearDown(
          () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null),
        );
        final controller = TextEditingController(text: phone ? '11969230549' : 'Search words');
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          MateoApp(
            theme: MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white),
            home: Center(
              child: SizedBox(
                width: 320,
                child: MateoTextInput(
                  controller: controller,
                  placeholder: 'Input',
                  presentation: phone ? const .phone(initialCountry: .brazil) : const .search(variant: .filled),
                  onChanged: (_) {},
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final editable = tester.state<EditableTextState>(find.byType(EditableText));
        expect(
          editable.widget.selectionControls,
          same(
            platform == TargetPlatform.android
                ? material.materialTextSelectionHandleControls
                : cupertinoTextSelectionHandleControls,
          ),
        );
        controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
        await tester.pump();
        editable.showToolbar();
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(
          find.byType(
            platform == TargetPlatform.android ? material.TextSelectionToolbar : CupertinoTextSelectionToolbar,
          ),
          findsOneWidget,
        );
        final selectedText = controller.text;
        await tester.tap(find.text('Copy'));
        await tester.pumpAndSettle();
        expect(clipboardText, selectedText);
        expect(controller.text, selectedText);
        await tester.pumpWidget(const SizedBox.shrink());
        debugDefaultTargetPlatformOverride = null;
      });
    }
  }
}
