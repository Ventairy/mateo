import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  group('MateoWidgetTransition Golden Tests', () {
    goldenTest(
      'when rendering static states, it should match the approved goldens',
      fileName: 'mateo_widget_transition_states',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 300,
          height: 400,
        ),
        children: [
          GoldenTestScenario(
            name: 'loading',
            child: const _GoldenFrame(child: _StaticTransition(index: 0)),
          ),
          GoldenTestScenario(
            name: 'content',
            child: const _GoldenFrame(child: _StaticTransition(index: 1)),
          ),
          GoldenTestScenario(
            name: 'error',
            child: const _GoldenFrame(child: _StaticTransition(index: 2)),
          ),
        ],
      ),
    );
  });
}

class _StaticTransition extends StatelessWidget {
  const _StaticTransition({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return MateoWidgetTransition(
      builder: (_) => KeyedSubtree(
        key: ValueKey('state_$index'),
        child: _GoldenChild(index: index),
      ),
      outDuration: const Duration(milliseconds: 300),
      outTransition: (child, controller) => FadeTransition(
        opacity: Tween<double>(begin: 1, end: 0).animate(controller),
        child: child,
      ),
      inDuration: const Duration(milliseconds: 500),
      inTransition: (child, controller) {
        final curved = CurveTween(curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: Tween<double>(
            begin: 0,
            end: 1,
          ).animate(curved.animate(controller)),
          child: child,
        );
      },
    );
  }
}

class _GoldenChild extends StatelessWidget {
  const _GoldenChild({required this.index});

  final int index;

  static final _colors = [
    mateoTestColorScheme.buttons.primary.background,
    mateoTestColorScheme.buttons.success.background,
    mateoTestColorScheme.toast.info.background,
  ];

  static const _labels = ['Carregando...', 'Item A', 'Item B'];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _colors[index],
      child: Center(
        child: Text(
          _labels[index],
          style: TextStyle(
            color: mateoTestColorScheme.background,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
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
