import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  group('MateoToggle Golden Tests', () {
    late GlobalKey<_AnimatedToggleScenarioState> transitionKey;

    goldenTest(
      'when rendering toggle states, it should match the approved golden',
      fileName: 'mateo_toggle_states',
      whilePerforming: (tester) async {
        final pressedGesture = await tester.startGesture(
          tester.getCenter(find.byKey(const Key('pressed-toggle'))),
        );
        transitionKey.currentState!.turnOn();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));
        return pressedGesture.up;
      },
      builder: () {
        transitionKey = GlobalKey<_AnimatedToggleScenarioState>();

        return GoldenTestGroup(
          scenarioConstraints: const BoxConstraints.tightFor(
            width: 180,
            height: 100,
          ),
          children: [
            GoldenTestScenario(
              name: 'off',
              child: const _ToggleFrame(onChanged: _ignoreChange),
            ),
            GoldenTestScenario(
              name: 'on',
              child: const _ToggleFrame(
                initialValue: true,
                onChanged: _ignoreChange,
              ),
            ),
            GoldenTestScenario(
              name: 'disabled off',
              child: const _ToggleFrame(),
            ),
            GoldenTestScenario(
              name: 'disabled on',
              child: const _ToggleFrame(initialValue: true),
            ),
            GoldenTestScenario(
              name: 'pressed',
              child: const _ToggleFrame(
                toggleKey: Key('pressed-toggle'),
                animationsEnabled: true,
                onChanged: _ignoreChange,
              ),
            ),
            GoldenTestScenario(
              name: 'solid glide',
              child: _AnimatedToggleScenario(key: transitionKey),
            ),
            GoldenTestScenario(
              name: 'right to left on',
              child: const Directionality(
                textDirection: TextDirection.rtl,
                child: _ToggleFrame(
                  initialValue: true,
                  onChanged: _ignoreChange,
                ),
              ),
            ),
          ],
        );
      },
    );
  });
}

void _ignoreChange(bool value, Future<void> animation) {}

class _ToggleFrame extends StatefulWidget {
  const _ToggleFrame({
    this.initialValue = false,
    this.controller,
    this.onChanged,
    this.animationsEnabled = false,
    this.toggleKey,
  });

  final bool initialValue;
  final MateoToggleController? controller;
  final MateoToggleChanged? onChanged;
  final bool animationsEnabled;
  final Key? toggleKey;

  @override
  State<_ToggleFrame> createState() => _ToggleFrameState();
}

class _ToggleFrameState extends State<_ToggleFrame> {
  MateoToggleController? _ownedController;

  MateoToggleController get _controller => widget.controller ?? _ownedController!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _ownedController = MateoToggleController(value: widget.initialValue);
    }
  }

  @override
  void dispose() {
    _ownedController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: mateoTestColorScheme.background,
    child: Center(
      child: MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(disableAnimations: !widget.animationsEnabled),
        child: MateoToggle(
          key: widget.toggleKey,
          controller: _controller,
          onChanged: widget.onChanged,
        ),
      ),
    ),
  );
}

class _AnimatedToggleScenario extends StatefulWidget {
  const _AnimatedToggleScenario({super.key});

  @override
  State<_AnimatedToggleScenario> createState() => _AnimatedToggleScenarioState();
}

class _AnimatedToggleScenarioState extends State<_AnimatedToggleScenario> {
  final _controller = MateoToggleController();

  void turnOn() {
    _controller.setValue(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _ToggleFrame(
    controller: _controller,
    animationsEnabled: true,
    onChanged: _ignoreChange,
  );
}
