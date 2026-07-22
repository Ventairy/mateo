import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  group('MateoDotsLoadingIndicator Golden Tests', () {
    goldenTest(
      'when rendering visual states, it should match the approved goldens',
      fileName: 'mateo_dots_loading_indicator_states',
      builder: () => GoldenTestGroup(
        scenarioConstraints: BoxConstraints.tightFor(width: 220, height: 160),
        children: [
          GoldenTestScenario(
            name: 'default primary dots',
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(child: MateoDotsLoadingIndicator()),
            ),
          ),
          GoldenTestScenario(
            name: 'custom neutral dots',
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(
                child: MateoDotsLoadingIndicator(
                  color: mateoTestPalette.neutral[12],
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'compact radius',
            child: const MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(
                child: MateoDotsLoadingIndicator(dotRadius: 3),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'larger radius',
            child: const MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(
                child: MateoDotsLoadingIndicator(dotRadius: 6),
              ),
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
