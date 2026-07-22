import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  group('MateoRouteSettled Golden Tests', () {
    goldenTest(
      'when the route is settled, it should render the child fully visible',
      fileName: 'mateo_route_settled_resting',
      builder: () => GoldenTestGroup(
        scenarioConstraints: BoxConstraints.tightFor(width: 300, height: 200),
        children: [
          GoldenTestScenario(
            name: 'resting',
            child: _RestingRouteSettled(
              child: Text('Hello World', style: TextStyle(fontSize: 20)),
            ),
          ),
          GoldenTestScenario(
            name: 'with container',
            child: _RestingRouteSettled(
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
  });
}

/// Wraps [child] in a [MateoRouteSettled] inside a reduced-motion environment so
/// the settle animation completes instantly and golden output is deterministic.
class _RestingRouteSettled extends StatelessWidget {
  const _RestingRouteSettled({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(disableAnimations: true),
      child: Material(
        child: Center(child: MateoRouteSettled(child: child)),
      ),
    );
  }
}
