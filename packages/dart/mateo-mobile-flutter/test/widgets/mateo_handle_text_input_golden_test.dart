import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

final _theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);

Widget _scenario({
  MateoTextInputSize size = .standard,
  String text = '',
  bool enabled = true,
  double width = 240,
  double textScale = 1,
  TextDirection direction = .ltr,
}) => Builder(
  builder: (context) {
    final controller = TextEditingController(text: text);
    addTearDown(controller.dispose);
    return Directionality(
      textDirection: direction,
      child: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: width,
            child: MateoTextInput(
              autofocus: false,
              placeholder: 'Arroba',
              presentation: .handle(size: size),
              controller: controller,
              onChanged: enabled ? (_) {} : null,
            ),
          ),
        ),
      ),
    );
  },
);

Future<void> main() async {
  await goldenTest(
    'when handles are empty, populated, disabled, or constrained, it should keep the at prefix distinct from the plain editor',
    fileName: 'mateo_handle_text_input',
    builder: () => MateoTheme(
      data: _theme,
      child: ColoredBox(
        color: _theme.colorScheme.background,
        child: GoldenTestGroup(
          columns: 3,
          children: [
            for (final size in MateoTextInputSize.values) ...[
              GoldenTestScenario(
                name: '${size.name} empty',
                child: _scenario(size: size),
              ),
              GoldenTestScenario(
                name: '${size.name} populated',
                child: _scenario(size: size, text: 'Some.Name_42'),
              ),
              GoldenTestScenario(
                name: '${size.name} disabled',
                child: _scenario(size: size, text: 'Some.Name_42', enabled: false),
              ),
            ],
            GoldenTestScenario(name: 'Disabled placeholder', child: _scenario(enabled: false)),
            GoldenTestScenario(
              name: 'Narrow overflow',
              child: _scenario(width: 120, text: 'Some.Very.Long.Handle_42'),
            ),
            GoldenTestScenario(
              name: 'Large text',
              child: _scenario(text: 'Some.Name', textScale: 3),
            ),
            GoldenTestScenario(
              name: 'RTL surroundings',
              child: _scenario(text: 'Some.Name_42', direction: .rtl),
            ),
            GoldenTestScenario(
              name: 'Unicode handle',
              child: _scenario(text: 'João_42', direction: .rtl),
            ),
          ],
        ),
      ),
    ),
  );
}
