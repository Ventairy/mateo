import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  final animatedFrameKey = GlobalKey<_AnimatedGoldenFrameState>();

  group('when rendering MateoCircularLoadingIndicator goldens', () {
    goldenTest(
      'when rendering visual states, it should match the approved golden',
      fileName: 'mateo_circular_loading_indicator_states',
      whilePerforming: (tester) async {
        animatedFrameKey.currentState!.setTickerEnabled(enabled: true);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));
        animatedFrameKey.currentState!.setTickerEnabled(enabled: false);
        await tester.pump();
        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 220,
          height: 160,
        ),
        children: [
          GoldenTestScenario(
            name: 'default 24 pixels',
            child: const _GoldenFrame(
              disableAnimations: true,
              child: MateoCircularLoadingIndicator(size: 24),
            ),
          ),
          GoldenTestScenario(
            name: 'larger 48 pixels',
            child: const _GoldenFrame(
              disableAnimations: true,
              child: MateoCircularLoadingIndicator(size: 48),
            ),
          ),
          GoldenTestScenario(
            name: 'custom colors',
            child: _GoldenFrame(
              disableAnimations: true,
              child: MateoCircularLoadingIndicator(
                color: mateoTestPalette.neutral[12],
                trackColor: mateoTestPalette.neutral[4],
                size: 32,
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'animated quarter turn',
            child: _AnimatedGoldenFrame(
              key: animatedFrameKey,
              child: const MateoCircularLoadingIndicator(size: 32),
            ),
          ),
          GoldenTestScenario(
            name: 'reduced motion',
            child: const _GoldenFrame(
              disableAnimations: true,
              child: MateoCircularLoadingIndicator(size: 32),
            ),
          ),
        ],
      ),
    );
  });
}

class _GoldenFrame extends StatelessWidget {
  const _GoldenFrame({required this.child, this.disableAnimations = true});

  final Widget child;
  final bool disableAnimations;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: mateoTestColorScheme.background,
      child: Center(
        child: MediaQuery(
          data: MediaQueryData(disableAnimations: disableAnimations),
          child: child,
        ),
      ),
    );
  }
}

class _AnimatedGoldenFrame extends StatefulWidget {
  const _AnimatedGoldenFrame({required this.child, super.key});

  final Widget child;

  @override
  State<_AnimatedGoldenFrame> createState() => _AnimatedGoldenFrameState();
}

class _AnimatedGoldenFrameState extends State<_AnimatedGoldenFrame> {
  var _tickerEnabled = false;

  void setTickerEnabled({required bool enabled}) {
    setState(() => _tickerEnabled = enabled);
  }

  @override
  Widget build(BuildContext context) {
    return _GoldenFrame(
      disableAnimations: false,
      child: TickerMode(enabled: _tickerEnabled, child: widget.child),
    );
  }
}
