import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  group('MateoAppear Golden Tests', () {
    goldenTest(
      'when appear is triggered with disableAnimations, it should render the child fully visible',
      fileName: 'mateo_appear_visible',
      builder: () => GoldenTestGroup(
        scenarioConstraints: BoxConstraints.tightFor(width: 300, height: 200),
        children: [
          GoldenTestScenario(
            name: 'default fade animation',
            child: _AppearVisible(
              child: Text('Hello World', style: TextStyle(fontSize: 20)),
            ),
          ),
          GoldenTestScenario(
            name: 'with child container',
            child: _AppearVisible(
              child: Container(
                width: 100,
                height: 100,
                color: mateoTestColorScheme.buttons.primary.background,
                alignment: Alignment.center,
                child: Text(
                  'Box',
                  style: TextStyle(color: mateoTestColorScheme.background),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'when unmount is true and destroy completes with disableAnimations, it should render nothing',
      fileName: 'mateo_appear_unmounted',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 300,
          height: 200,
        ),
        children: [
          GoldenTestScenario(
            name: 'unmounted after destroy',
            child: _AppearDestroyed(
              child: const Text('Hello World', style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  });
}

class _AppearVisible extends StatefulWidget {
  const _AppearVisible({required this.child});

  final Widget child;

  @override
  State<_AppearVisible> createState() => _AppearVisibleState();
}

class _AppearVisibleState extends State<_AppearVisible> {
  final _controller = MateoAppearController();

  @override
  void initState() {
    super.initState();
    _controller.appear();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(disableAnimations: true),
      child: Material(
        child: Center(
          child: MateoAppear(controller: _controller, child: widget.child),
        ),
      ),
    );
  }
}

class _AppearDestroyed extends StatefulWidget {
  const _AppearDestroyed({required this.child});

  final Widget child;

  @override
  State<_AppearDestroyed> createState() => _AppearDestroyedState();
}

class _AppearDestroyedState extends State<_AppearDestroyed> {
  final _controller = MateoAppearController();

  @override
  void initState() {
    super.initState();
    _controller.appear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.destroy();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(disableAnimations: true),
      child: Material(
        child: Center(
          child: MateoAppear(
            controller: _controller,
            unmount: true,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
