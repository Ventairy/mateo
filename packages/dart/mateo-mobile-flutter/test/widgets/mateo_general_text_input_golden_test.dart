import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

final _theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);

Future<void> main() async {
  await goldenTest(
    'when general uses plain sizes and states, it should show only text on the surrounding surface',
    fileName: 'mateo_general_text_input',
    builder: () => MateoTheme(
      data: _theme,
      child: ColoredBox(
        color: _theme.colorScheme.background,
        child: GoldenTestGroup(
          columns: 3,
          children: [
            for (final size in MateoTextInputSize.values)
              for (final state in ['empty', 'populated', 'disabled'])
                GoldenTestScenario(
                  name: '${size.name} $state',
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
                            presentation: .general(variant: .plain, size: size),
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
}
