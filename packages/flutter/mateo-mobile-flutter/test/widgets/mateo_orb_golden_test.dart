import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  final animatedFrameKey = GlobalKey<_AnimatedOrbFrameState>();

  group('when rendering MateoOrb goldens', () {
    goldenTest(
      'when rendering visual states, it should match the approved golden',
      fileName: 'mateo_orb_states',
      whilePerforming: (tester) async {
        await _waitForShaders(tester);
        animatedFrameKey.currentState!.setTickerEnabled(enabled: true);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 780));
        animatedFrameKey.currentState!.setTickerEnabled(enabled: false);
        await tester.pump();
        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 220,
          height: 180,
        ),
        children: [
          GoldenTestScenario(
            name: 'default 48 pixels',
            child: const _GoldenFrame(child: MateoOrb(size: 48)),
          ),
          GoldenTestScenario(
            name: 'larger 120 pixels',
            child: const _GoldenFrame(child: MateoOrb(size: 120)),
          ),
          GoldenTestScenario(
            name: 'custom colors',
            child: _GoldenFrame(
              child: MateoOrb(
                size: 96,
                colorScheme: MateoOrbColorScheme(
                  background: mateoTestPalette.red[9],
                  smoke: mateoTestPalette.red[1],
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'animated phase',
            child: _AnimatedOrbFrame(
              key: animatedFrameKey,
              child: const MateoOrb(size: 96, animate: true),
            ),
          ),
          GoldenTestScenario(
            name: 'reduced motion',
            child: const _GoldenFrame(
              disableAnimations: true,
              child: MateoOrb(size: 96, animate: true),
            ),
          ),
        ],
      ),
    );
  });
}

class _GoldenFrame extends StatelessWidget {
  const _GoldenFrame({
    required this.child,
    this.disableAnimations = false,
  });

  final Widget child;
  final bool disableAnimations;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: mateoTestColorScheme.background,
      child: Center(
        child: MediaQuery(
          data: MediaQueryData(disableAnimations: disableAnimations),
          child: TickerMode(enabled: false, child: child),
        ),
      ),
    );
  }
}

class _AnimatedOrbFrame extends StatefulWidget {
  const _AnimatedOrbFrame({required this.child, super.key});

  final Widget child;

  @override
  State<_AnimatedOrbFrame> createState() => _AnimatedOrbFrameState();
}

class _AnimatedOrbFrameState extends State<_AnimatedOrbFrame> {
  var _tickerEnabled = false;

  void setTickerEnabled({required bool enabled}) {
    setState(() => _tickerEnabled = enabled);
  }

  @override
  Widget build(BuildContext context) {
    return _GoldenFrame(
      child: TickerMode(enabled: _tickerEnabled, child: widget.child),
    );
  }
}

Future<void> _waitForShaders(WidgetTester tester) async {
  for (var attempt = 0; attempt < 20; attempt++) {
    final paints = tester.widgetList<CustomPaint>(
      find.descendant(
        of: find.byType(MateoOrb),
        matching: find.byType(CustomPaint),
      ),
    );
    if (paints.isNotEmpty && paints.every((paint) => (paint.painter! as dynamic).shader != null)) {
      return;
    }
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump();
  }

  fail('MateoOrb shaders did not load.');
}
