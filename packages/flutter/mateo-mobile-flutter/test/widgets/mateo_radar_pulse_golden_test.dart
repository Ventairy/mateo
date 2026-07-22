import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  group('MateoRadarPulse Golden Tests', () {
    goldenTest(
      'when rendering visual states, it should match the approved goldens',
      fileName: 'mateo_radar_pulse_states',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 300,
          height: 300,
        ),
        children: [
          GoldenTestScenario(
            name: 'default circular pulse',
            child: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(child: MateoRadarPulse(child: _goldenDot())),
            ),
          ),
          GoldenTestScenario(
            name: 'square border radius',
            child: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(
                child: MateoRadarPulse(
                  steps: const [
                    MateoRadarPulseStep(borderRadius: BorderRadius.zero),
                    MateoRadarPulseStep(borderRadius: BorderRadius.zero),
                  ],
                  child: _goldenDot(),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'squircle border radius',
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(
                child: MateoRadarPulse(
                  steps: [
                    MateoRadarPulseStep(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    MateoRadarPulseStep(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                  ],
                  child: _goldenDot(),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'custom colors per step',
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(
                child: MateoRadarPulse(
                  steps: [
                    MateoRadarPulseStep(color: mateoTestPalette.primary[9]),
                    MateoRadarPulseStep(color: mateoTestPalette.green[9]),
                  ],
                  child: _goldenDot(),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'custom alpha per step',
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(
                child: MateoRadarPulse(
                  steps: [
                    MateoRadarPulseStep(
                      color: mateoTestPalette.primary[9],
                      alpha: 0.7,
                    ),
                    MateoRadarPulseStep(
                      color: mateoTestPalette.green[9],
                      alpha: 0.15,
                    ),
                  ],
                  child: _goldenDot(),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'single step',
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(
                child: MateoRadarPulse(
                  steps: [MateoRadarPulseStep()],
                  child: _goldenDot(),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'four steps',
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(
                child: MateoRadarPulse(
                  steps: [
                    MateoRadarPulseStep(color: mateoTestPalette.primary[9]),
                    MateoRadarPulseStep(color: mateoTestPalette.green[9]),
                    MateoRadarPulseStep(color: mateoTestPalette.blue[9]),
                    MateoRadarPulseStep(color: mateoTestPalette.amber[9]),
                  ],
                  child: _goldenDot(),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'small child',
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(
                child: MateoRadarPulse(child: _goldenDot(size: 24)),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'large child',
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(
                child: MateoRadarPulse(child: _goldenDot(size: 120)),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'transparent child (pulse from behind)',
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: _GoldenFrame(
                child: MateoRadarPulse(
                  child: Icon(
                    Icons.bolt_rounded,
                    size: 56,
                    color: mateoTestPalette.primary[9],
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

Widget _goldenDot({double size = 56, Color? color}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color ?? mateoTestPalette.primary[9],
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: mateoTestColorScheme.buttons.floating.shadow,
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Icon(
      Icons.bolt_rounded,
      color: mateoTestColorScheme.background,
      size: 24,
    ),
  );
}

class _GoldenFrame extends StatelessWidget {
  const _GoldenFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: mateoTestColorScheme.background,
      child: Padding(padding: const EdgeInsets.all(24), child: child),
    );
  }
}
