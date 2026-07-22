import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  group('MateoLoadingText Golden Tests', () {
    goldenTest(
      'when rendering visual states, it should match the approved goldens',
      fileName: 'mateo_loading_text_states',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'default',
            child: TickerMode(
              enabled: false,
              child: MediaQuery(
                data: MediaQueryData(disableAnimations: true),
                child: MateoLoadingText(text: 'Carregando oportunidades...'),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'custom indicator color',
            child: TickerMode(
              enabled: false,
              child: MediaQuery(
                data: MediaQueryData(disableAnimations: true),
                child: MateoLoadingText(
                  text: 'Buscando...',
                  progressIndicatorColor: mateoTestPalette.green[9],
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'long text',
            child: const TickerMode(
              enabled: false,
              child: MediaQuery(
                data: MediaQueryData(disableAnimations: true),
                child: MateoLoadingText(
                  text: 'Verificando novas oportunidades perto de você...',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  });
}
