import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  final variants = <String, MateoButtonVariant>{
    'primary accent': MateoButtonVariant.primary,
    'primary neutral': MateoButtonVariant.primary.neutral,
    'primary base': MateoButtonVariant.primary.base,
    'secondary accent': MateoButtonVariant.secondary,
    'secondary neutral': MateoButtonVariant.secondary.neutral,
    'tertiary': MateoButtonVariant.tertiary,
    'elevated neutral': MateoButtonVariant.primary.neutral,
    'elevated base': MateoButtonVariant.primary.base,
  };
  for (final state in ['resting', 'disabled', 'loading', 'pressed']) {
    goldenTest(
      'when icon variants are $state, they should preserve circular surfaces',
      fileName: 'mateo_button_icon_variants_$state',
      whilePerforming: state == 'pressed'
          ? (tester) async {
              for (final element in find.byType(MateoButton).evaluate()) {
                final gesture = await tester.startGesture(tester.getCenter(find.byWidget(element.widget)));
                addTearDown(gesture.removePointer);
              }
              await tester.pump(const Duration(milliseconds: 120));
              return null;
            }
          : null,
      builder: () => MediaQuery(
        data: MediaQueryData(disableAnimations: state == 'loading'),
        child: GoldenTestGroup(
          columns: 3,
          children: [
            for (final entry in variants.entries)
              GoldenTestScenario(
                name: entry.key,
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: MateoButton(
                    presentation: MateoButtonPresentation.icon(
                      semanticLabel: 'Search',
                      variant: entry.value,
                      elevation: entry.key.startsWith('elevated') ? 1 : 0,
                      iconBuilder: (state) => Icon(Icons.search, color: state.foregroundColor, size: state.iconSize),
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

  group('MateoButton icon presentation Golden Tests', () {
    goldenTest(
      'when rendering visual states, it should match the approved goldens',
      fileName: 'mateo_button_icon_states',
      builder: () => GoldenTestGroup(
        scenarioConstraints: BoxConstraints(minWidth: 96),
        children: [
          GoldenTestScenario(
            name: 'resting',
            child: MateoButton(
              presentation: MateoButtonPresentation.icon(
                variant: MateoButtonVariant.primary,
                iconBuilder: (state) => Icon(
                  Icons.search,
                  color: state.foregroundColor,
                  size: state.iconSize,
                ),
                semanticLabel: 'Action',
              ),
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'custom background',
            child: MateoButton(
              presentation: MateoButtonPresentation.icon(
                variant: MateoButtonVariant.primary,
                iconBuilder: (state) => Icon(
                  Icons.location_on,
                  color: state.foregroundColor,
                  size: state.iconSize,
                ),
                semanticLabel: 'Action',
                colorScheme: mateoTestColorScheme.buttons.primary.accent.copyWith(
                  background: mateoTestPalette.green[9],
                ),
              ),
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'custom disabled background',
            child: MateoButton(
              presentation: MateoButtonPresentation.icon(
                variant: MateoButtonVariant.primary,
                iconBuilder: (state) => Icon(
                  Icons.lock,
                  color: state.foregroundColor,
                  size: state.iconSize,
                ),
                semanticLabel: 'Action',
                colorScheme: mateoTestColorScheme.buttons.primary.accent.copyWith(
                  backgroundDisabled: mateoTestPalette.neutral[5],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'when pressing the button, it should match the approved golden',
      fileName: 'mateo_button_icon_pressed',
      whilePerforming: (tester) async {
        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(const Key('mateo_button_container'))),
        );
        await tester.pump(const Duration(milliseconds: 120));
        addTearDown(gesture.removePointer);
        return null;
      },
      builder: () => MateoButton(
        presentation: MateoButtonPresentation.icon(
          variant: MateoButtonVariant.primary,
          iconBuilder: (state) => Icon(
            Icons.search,
            color: state.foregroundColor,
            size: state.iconSize,
          ),
          semanticLabel: 'Action',
        ),
        onPressed: () {},
      ),
    );
  });
}
