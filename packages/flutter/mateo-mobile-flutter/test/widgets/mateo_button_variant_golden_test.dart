import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

void main() {
  final presets = {
    'primary accent': MateoButtonVariant.primary,
    'primary neutral': MateoButtonVariant.primary.neutral,
    'primary base': MateoButtonVariant.primary.base,
    'secondary accent': MateoButtonVariant.secondary,
    'secondary neutral': MateoButtonVariant.secondary.neutral,
    'elevated neutral': MateoButtonVariant.primary.neutral,
    'elevated base': MateoButtonVariant.primary.base,
  };
  for (final state in ['resting', 'disabled', 'loading', 'pressed']) {
    goldenTest(
      'when all presets are $state, they should match the authored surfaces',
      fileName: 'mateo_button_presets_$state',
      whilePerforming: state != 'pressed'
          ? null
          : (tester) async {
              for (final finder
                  in find.byType(MateoButton).evaluate().map((element) => find.byWidget(element.widget))) {
                final gesture = await tester.startGesture(tester.getCenter(finder));
                addTearDown(gesture.removePointer);
              }
              await tester.pump(const Duration(milliseconds: 120));
              return null;
            },
      builder: () => MediaQuery(
        data: MediaQueryData(disableAnimations: state == 'loading'),
        child: GoldenTestGroup(
          columns: 2,
          children: [
            for (final entry in presets.entries)
              GoldenTestScenario(
                name: entry.key,
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: MateoButton(
                    presentation: MateoButtonPresentation.label(
                      label: 'Continue',
                      variant: entry.value,
                      elevation: entry.key.startsWith('elevated') ? 1 : 0,
                    ),
                    isLoading: state == 'loading',
                    onPressed: state == 'disabled' ? null : () {},
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  goldenTest(
    'when elevated over light dark and scrim surfaces, it should preserve the selected colors',
    fileName: 'mateo_button_floating_surfaces',
    builder: () => GoldenTestGroup(
      columns: 2,
      children: [
        for (final background in [Colors.white, Colors.black, const Color(0xFF999999)])
          for (final variant in [MateoButtonVariant.primary.neutral, MateoButtonVariant.primary.base])
            GoldenTestScenario(
              name: '${background.toARGB32()} ${variant == MateoButtonVariant.primary.base ? 'base' : 'neutral'}',
              child: ColoredBox(
                color: background,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: MateoButton(
                    presentation: MateoButtonPresentation.label(label: 'Close', variant: variant, elevation: 1),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
      ],
    ),
  );
}
