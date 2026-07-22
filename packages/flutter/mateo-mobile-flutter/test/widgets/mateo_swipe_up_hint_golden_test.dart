import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  group('MateoSwipeUpHint Golden Tests', () {
    goldenTest(
      'when rendering visual states, it should match the approved goldens',
      fileName: 'mateo_swipe_up_hint_states',
      builder: () => GoldenTestGroup(
        scenarioConstraints: BoxConstraints.tightFor(width: 300, height: 300),
        children: [
          GoldenTestScenario(
            name: 'default theme colors',
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(child: MateoSwipeUpHint()),
            ),
          ),
          GoldenTestScenario(
            name: 'custom phone color',
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(
                child: MateoSwipeUpHint(
                  phoneColor: mateoTestPalette.neutral[12],
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'custom accent color',
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(
                child: MateoSwipeUpHint(
                  accentColor: mateoTestPalette.primary[9],
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'custom colors both',
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(
                child: MateoSwipeUpHint(
                  phoneColor: mateoTestPalette.neutral[12],
                  accentColor: mateoTestPalette.primary[9],
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'small height',
            child: const MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(child: MateoSwipeUpHint(height: 80)),
            ),
          ),
          GoldenTestScenario(
            name: 'large height',
            child: const MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(child: MateoSwipeUpHint(height: 240)),
            ),
          ),
        ],
      ),
    );
  });
}

class _GoldenFrame extends StatelessWidget {
  const _GoldenFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: mateoTestColorScheme.background,
      child: Center(child: child),
    );
  }
}
