import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  group('MateoTextButton Golden Tests', () {
    goldenTest(
      'when rendering visual states, it should match the approved goldens',
      fileName: 'mateo_text_button_states',
      builder: () => GoldenTestGroup(
        scenarioConstraints: BoxConstraints(minWidth: 260),
        children: [
          GoldenTestScenario(
            name: 'resting text only',
            child: MateoTextButton(text: 'Ver oportunidades', onPressed: () {}),
          ),
          GoldenTestScenario(
            name: 'leading icon',
            child: MateoTextButton(
              text: 'Buscar',
              leadingIconBuilder: (state) => Icon(
                Icons.search,
                color: state.recommendedIconColor,
                size: 18,
              ),
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'trailing icon',
            child: MateoTextButton(
              text: 'Continuar',
              trailingIconBuilder: (state) => Icon(
                Icons.arrow_forward,
                color: state.recommendedIconColor,
                size: 18,
              ),
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'custom color',
            child: MateoTextButton(
              text: 'Destacar',
              color: mateoTestColorScheme.buttons.primary.background,
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'independent icon color',
            child: MateoTextButton(
              text: 'Mapa',
              leadingIconBuilder: (state) => Icon(
                Icons.location_on,
                size: 18,
                color: mateoTestColorScheme.buttons.success.background,
              ),
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'both icons',
            child: MateoTextButton(
              text: 'Distância',
              leadingIconBuilder: (state) => Icon(
                Icons.near_me,
                color: state.recommendedIconColor,
                size: 18,
              ),
              trailingIconBuilder: (state) => Icon(
                Icons.info_outline,
                color: state.recommendedIconColor,
                size: 18,
              ),
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'disabled',
            child: MateoTextButton(
              text: 'Indisponivel',
              leadingIconBuilder: (state) =>
                  Icon(Icons.lock, color: state.recommendedIconColor, size: 18),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'when pressing the button, it should match the approved golden',
      fileName: 'mateo_text_button_pressed',
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
        child: MateoTextButton(text: 'Ver oportunidades', onPressed: () {}),
      ),
    );
  });
}
