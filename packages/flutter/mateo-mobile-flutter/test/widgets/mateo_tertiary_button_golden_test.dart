import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  group('MateoButton tertiary Golden Tests', () {
    goldenTest(
      'when tertiary buttons are loading, they should retain their compact transparent treatment',
      fileName: 'mateo_tertiary_button_loading',
      builder: () => MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: GoldenTestGroup(
          children: [
            for (final enabled in [true, false])
              GoldenTestScenario(
                name: enabled ? 'enabled' : 'disabled',
                child: MateoButton(
                  presentation: const MateoButtonPresentation.label(
                    label: 'Continue',
                    variant: MateoButtonVariant.tertiary,
                  ),
                  isLoading: true,
                  onPressed: enabled ? () {} : null,
                ),
              ),
          ],
        ),
      ),
    );

    goldenTest(
      'when rendering visual states, it should match the approved goldens',
      fileName: 'mateo_tertiary_button_states',
      builder: () => GoldenTestGroup(
        scenarioConstraints: BoxConstraints(minWidth: 260),
        children: [
          GoldenTestScenario(
            name: 'resting text only',
            child: MateoButton(
              presentation: MateoButtonPresentation.label(
                variant: MateoButtonVariant.tertiary,
                label: 'Ver oportunidades',
              ),
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'leading icon',
            child: MateoButton(
              presentation: MateoButtonPresentation.label(
                variant: MateoButtonVariant.tertiary,
                label: 'Buscar',
                leadingIconBuilder: (state) => Icon(
                  Icons.search,
                  color: state.foregroundColor,
                  size: 18,
                ),
              ),
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'trailing icon',
            child: MateoButton(
              presentation: MateoButtonPresentation.label(
                variant: MateoButtonVariant.tertiary,
                label: 'Continuar',
                trailingIconBuilder: (state) => Icon(
                  Icons.arrow_forward,
                  color: state.foregroundColor,
                  size: 18,
                ),
              ),
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'custom color',
            child: MateoButton(
              presentation: MateoButtonPresentation.label(
                variant: MateoButtonVariant.tertiary,
                label: 'Destacar',
                colorScheme: mateoTestColorScheme.buttons.tertiary.neutral.copyWith(
                  foreground: mateoTestColorScheme.buttons.primary.accent.background,
                ),
              ),
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'independent icon color',
            child: MateoButton(
              presentation: MateoButtonPresentation.label(
                variant: MateoButtonVariant.tertiary,
                label: 'Mapa',
                leadingIconBuilder: (state) => Icon(
                  Icons.location_on,
                  size: 18,
                  color: mateoTestThemeData.palette.green[9],
                ),
              ),
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'both icons',
            child: MateoButton(
              presentation: MateoButtonPresentation.label(
                variant: MateoButtonVariant.tertiary,
                label: 'Distância',
                leadingIconBuilder: (state) => Icon(
                  Icons.near_me,
                  color: state.foregroundColor,
                  size: 18,
                ),
                trailingIconBuilder: (state) => Icon(
                  Icons.info_outline,
                  color: state.foregroundColor,
                  size: 18,
                ),
              ),
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'disabled',
            child: MateoButton(
              presentation: MateoButtonPresentation.label(
                variant: MateoButtonVariant.tertiary,
                label: 'Indisponivel',
                leadingIconBuilder: (state) => Icon(Icons.lock, color: state.foregroundColor, size: 18),
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'when pressing the button, it should match the approved golden',
      fileName: 'mateo_tertiary_button_pressed',
      whilePerforming: (tester) async {
        final gesture = await tester.startGesture(
          tester.getCenter(find.text('Ver oportunidades')),
        );
        await tester.pump(const Duration(milliseconds: 120));
        addTearDown(gesture.removePointer);
        return null;
      },
      builder: () => SizedBox(
        width: 180,
        child: MateoButton(
          presentation: MateoButtonPresentation.label(
            variant: MateoButtonVariant.tertiary,
            label: 'Ver oportunidades',
          ),
          onPressed: () {},
        ),
      ),
    );
  });
}
