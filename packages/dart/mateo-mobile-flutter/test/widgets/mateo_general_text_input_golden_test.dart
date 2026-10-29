import 'package:alchemist/alchemist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

final _theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);

Future<void> main() async {
  await goldenTest(
    'when general uses supported treatments, sizes and states, it should show plain text and filled capsules',
    fileName: 'mateo_general_text_input',
    builder: () => MateoTheme(
      data: _theme,
      child: ColoredBox(
        color: _theme.colorScheme.background,
        child: GoldenTestGroup(
          columns: 3,
          children: [
            for (final variant in [MateoTextInputVariant.plain, MateoTextInputVariant.filled])
              for (final size in MateoTextInputSize.values.where(
                (size) => variant == MateoTextInputVariant.plain || size != MateoTextInputSize.large,
              ))
                for (final state in ['empty', 'populated', 'disabled'])
                  GoldenTestScenario(
                    name: '${variant == MateoTextInputVariant.plain ? 'plain' : 'filled'} ${size.name} $state',
                    child: Builder(
                      builder: (context) {
                        final controller = TextEditingController(text: state == 'populated' ? 'João da Silva' : '');
                        addTearDown(controller.dispose);
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: SizedBox(
                            width: 240,
                            child: MateoTextInput(
                              autofocus: false,
                              placeholder: 'Your name',
                              controller: controller,
                              presentation: .general(variant: variant, size: size),
                              onChanged: state == 'disabled' ? null : (_) {},
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    ),
  );
  await goldenTest(
    'when filled general text overflows or is selected, it should fade within its capsule in both directions',
    fileName: 'mateo_general_text_input_filled_overflow',
    pumpBeforeTest: (tester) async {
      await tester.pumpAndSettle();
      for (final direction in TextDirection.values) {
        for (final position in ['start', 'middle', 'end']) {
          for (final selected in [false, true]) {
            final finder = find.descendant(
              of: find.byKey(ValueKey('$direction $position $selected')),
              matching: find.byType(EditableText),
            );
            final editor = tester.state<EditableTextState>(finder);
            // Render each selected scenario with its native selection color even
            // though a golden grid cannot focus several editors at once.
            if (selected) {
              editor.renderEditable.selectionColor =
                  DefaultSelectionStyle.of(editor.context).selectionColor ??
                  CupertinoTheme.of(editor.context).primaryColor.withValues(alpha: 0.2);
            }
            final scroll = editor.renderEditable.offset as ScrollPosition;
            scroll.jumpTo(
              position == 'start'
                  ? 0
                  : position == 'end'
                  ? scroll.maxScrollExtent
                  : scroll.maxScrollExtent / 2,
            );
          }
        }
      }
      await tester.pumpAndSettle();
    },
    builder: () => MateoTheme(
      data: _theme,
      child: ColoredBox(
        color: _theme.colorScheme.background,
        child: GoldenTestGroup(
          columns: 3,
          children: [
            for (final direction in TextDirection.values)
              for (final selected in [false, true])
                for (final position in ['start', 'middle', 'end'])
                  GoldenTestScenario(
                    name: '${direction.name} $position selected=$selected',
                    child: Builder(
                      builder: (context) {
                        final controller = TextEditingController(text: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ' * 3);
                        if (selected) {
                          controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
                        }
                        addTearDown(controller.dispose);
                        return Directionality(
                          textDirection: direction,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: SizedBox(
                              width: 240,
                              child: MateoTextInput(
                                key: ValueKey('$direction $position $selected'),
                                autofocus: false,
                                placeholder: 'Code',
                                controller: controller,
                                presentation: const .general(variant: .filled),
                                onChanged: (_) {},
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    ),
  );
}
