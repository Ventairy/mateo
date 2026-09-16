import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  group('MateoProgressIndicator Golden Tests', () {
    goldenTest(
      'when rendering progress states, it should match the approved golden',
      fileName: 'mateo_progress_indicator_states',
      whilePerforming: (tester) async {
        await tester.pump(const Duration(milliseconds: 120));
        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 320,
          height: 120,
        ),
        children: [
          GoldenTestScenario(
            name: 'empty',
            child: const _ProgressFrame(value: 0),
          ),
          GoldenTestScenario(
            name: 'quarter',
            child: const _ProgressFrame(value: 0.25),
          ),
          GoldenTestScenario(
            name: 'half',
            child: const _ProgressFrame(value: 0.5),
          ),
          GoldenTestScenario(
            name: 'complete',
            child: const _ProgressFrame(value: 1),
          ),
          GoldenTestScenario(
            name: 'animating',
            child: const _ProgressFrame(value: 0.75, animate: true),
          ),
          GoldenTestScenario(
            name: 'right to left',
            child: const Directionality(
              textDirection: TextDirection.rtl,
              child: _ProgressFrame(value: 0.5),
            ),
          ),
        ],
      ),
    );
  });
}

class _ProgressFrame extends StatelessWidget {
  const _ProgressFrame({required this.value, this.animate = false});

  final double value;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: mateoTestColorScheme.background,
      child: Center(
        child: MediaQuery(
          data: MediaQueryData(disableAnimations: !animate),
          child: MateoProgressIndicator(value: value, width: 240),
        ),
      ),
    );
  }
}
