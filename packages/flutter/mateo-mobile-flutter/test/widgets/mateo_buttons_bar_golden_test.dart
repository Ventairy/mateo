import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  group('MateoButtonsBar Golden Tests', () {
    goldenTest(
      'when rendering visual states, it should match the approved goldens',
      fileName: 'mateo_buttons_bar_states',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 360,
          height: 140,
        ),
        children: [
          GoldenTestScenario(
            name: 'fit content',
            child: const _ButtonsBarScenario(),
          ),
          GoldenTestScenario(
            name: 'expanded width',
            child: const SizedBox(
              width: 260,
              child: _ButtonsBarScenario(widthFit: MateoButtonsBarFit.expand),
            ),
          ),
          GoldenTestScenario(
            name: 'fixed width',
            child: const _ButtonsBarScenario(
              constraints: BoxConstraints.tightFor(width: 240),
            ),
          ),
        ],
      ),
    );
  });
}

class _ButtonsBarScenario extends StatelessWidget {
  const _ButtonsBarScenario({
    this.constraints,
    this.widthFit = MateoButtonsBarFit.fitItems,
  });

  final BoxConstraints? constraints;
  final MateoButtonsBarFit widthFit;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: mateoTestColorScheme.skeleton.shimmerGlow,
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: MateoButtonsBar(
            constraints: constraints,
            widthFit: widthFit,
            items: [
              MateoIconButton(
                backgroundColor: mateoTestColorScheme.buttons.danger.background,
                iconBuilder: (state) => Icon(
                  Icons.close,
                  color: state.recommendedIconColor,
                  size: state.iconSize,
                ),
                onPressed: () {},
              ),
              MateoIconButton(
                backgroundColor: mateoTestColorScheme.toast.success.icon,
                iconBuilder: (state) => Icon(
                  Icons.phone,
                  color: state.recommendedIconColor,
                  size: state.iconSize,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
