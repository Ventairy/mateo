import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  group('MateoDotMatrix Color Golden Tests', () {
    goldenTest(
      'when rendering with different colors, it should match the approved goldens',
      fileName: 'mateo_dot_matrix_colors',
      builder: () => GoldenTestGroup(
        scenarioConstraints: BoxConstraints.tightFor(width: 320, height: 1300),
        children: [
          GoldenTestScenario(
            name: 'no explicit color',
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _ColorFrame(
                child: MateoDotMatrix(width: 240, height: 160, radius: 16),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'blue',
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _ColorFrame(
                child: MateoDotMatrix(
                  width: 240,
                  height: 160,
                  radius: 16,
                  color: mateoTestPalette.blue[9],
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'green',
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _ColorFrame(
                child: MateoDotMatrix(
                  width: 240,
                  height: 160,
                  radius: 16,
                  color: mateoTestPalette.green[9],
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'orange',
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _ColorFrame(
                child: MateoDotMatrix(
                  width: 240,
                  height: 160,
                  radius: 16,
                  color: mateoTestPalette.amber[9],
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'red',
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _ColorFrame(
                child: MateoDotMatrix(
                  width: 240,
                  height: 160,
                  radius: 16,
                  color: mateoTestPalette.red[9],
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'purple',
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _ColorFrame(
                child: MateoDotMatrix(
                  width: 240,
                  height: 160,
                  radius: 16,
                  color: mateoTestPalette.violet[9],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  });
}

class _ColorFrame extends StatelessWidget {
  const _ColorFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: mateoTestColorScheme.background,
      child: Padding(padding: const EdgeInsets.all(24), child: child),
    );
  }
}
