import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  group('MateoIconButton Golden Tests', () {
    goldenTest(
      'when rendering visual states, it should match the approved goldens',
      fileName: 'mateo_icon_button_states',
      builder: () => GoldenTestGroup(
        scenarioConstraints: BoxConstraints(minWidth: 96),
        children: [
          GoldenTestScenario(
            name: 'resting with label',
            child: MateoIconButton(
              label: 'Buscar',
              iconBuilder: (state) => Icon(
                Icons.search,
                color: state.recommendedIconColor,
                size: state.iconSize,
              ),
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'resting without label',
            child: MateoIconButton(
              iconBuilder: (state) => Icon(
                Icons.add,
                color: state.recommendedIconColor,
                size: state.iconSize,
              ),
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'custom background',
            child: MateoIconButton(
              backgroundColor: mateoTestPalette.green[9],
              label: 'Mapa',
              iconBuilder: (state) => Icon(
                Icons.location_on,
                color: state.recommendedIconColor,
                size: state.iconSize,
              ),
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'custom disabled background',
            child: MateoIconButton(
              disabledBackgroundColor: mateoTestPalette.neutral[5],
              label: 'Fechado',
              iconBuilder: (state) => Icon(
                Icons.lock,
                color: state.recommendedIconColor,
                size: state.iconSize,
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'disabled with label',
            child: MateoIconButton(
              label: 'Bloqueado',
              iconBuilder: (state) => Icon(
                Icons.lock,
                color: state.recommendedIconColor,
                size: state.iconSize,
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'when pressing the button, it should match the approved golden',
      fileName: 'mateo_icon_button_pressed',
      whilePerforming: (tester) async {
        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(const Key('mateo_icon_button_circle'))),
        );
        await tester.pump(const Duration(milliseconds: 120));
        addTearDown(gesture.removePointer);
        return null;
      },
      builder: () => MateoIconButton(
        label: 'Buscar',
        iconBuilder: (state) => Icon(
          Icons.search,
          color: state.recommendedIconColor,
          size: state.iconSize,
        ),
        onPressed: () {},
      ),
    );
  });
}
