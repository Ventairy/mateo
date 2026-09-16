import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  group('MateoButton Golden Tests', () {
    goldenTest(
      'when rendering visual states, it should match the approved golden',
      fileName: 'mateo_button_floating_states',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(width: 128),
        children: [
          GoldenTestScenario(
            name: 'resting',
            child: MateoButton(
              onPressed: () {},
              presentation: MateoButtonPresentation.icon(
                variant: MateoButtonVariant.primary.base,
                elevation: 1,
                semanticLabel: 'Go back',
                iconBuilder: (state) => Icon(
                  Icons.arrow_back,
                  color: state.foregroundColor,
                  size: state.iconSize,
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'custom',
            child: MateoButton(
              onPressed: () {},
              presentation: MateoButtonPresentation.icon(
                variant: MateoButtonVariant.primary.base,
                elevation: 1,
                semanticLabel: 'Create',
                buttonSize: 64,
                iconSize: 28,
                iconBuilder: (state) => Icon(
                  Icons.add,
                  color: state.foregroundColor,
                  size: state.iconSize,
                ),
                colorScheme: mateoTestColorScheme.buttons.primary.base.copyWith(
                  background: mateoTestPalette.green[9],
                  foreground: Colors.white,
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'disabled',
            child: MateoButton(
              onPressed: null,
              presentation: MateoButtonPresentation.icon(
                variant: MateoButtonVariant.primary.base,
                elevation: 1,
                semanticLabel: 'Create',
                iconBuilder: (state) => Icon(
                  Icons.add,
                  color: state.foregroundColor,
                  size: state.iconSize,
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'loading',
            child: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: MateoButton(
                isLoading: true,
                onPressed: () {},
                presentation: MateoButtonPresentation.icon(
                  variant: MateoButtonVariant.primary.base,
                  elevation: 1,
                  semanticLabel: 'Create',
                  iconBuilder: (state) => Icon(
                    Icons.add,
                    color: state.foregroundColor,
                    size: state.iconSize,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  });
}
