import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

/// A reusable widget that shows the edge-fade effect against a visible
/// background so the gradient is captured in golden screenshots.
class _FadeScenario extends StatelessWidget {
  _FadeScenario({
    required this.position,
    MateoEdgeFadeStyle? style,
    Color? backgroundColor,
  }) : style = style ?? const MateoEdgeFadeStyle(),
       backgroundColor =
           backgroundColor ?? mateoTestColorScheme.toast.info.icon;

  final MateoEdgeFadePosition position;
  final MateoEdgeFadeStyle style;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 200,
      child: Stack(
        children: [
          Positioned.fill(child: ColoredBox(color: backgroundColor)),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MateoEdgeFade(position: position, style: style),
          ),
        ],
      ),
    );
  }
}

void main() {
  group('MateoEdgeFade Golden Tests', () {
    goldenTest(
      'when rendering positions and colors, it should match the approved goldens',
      fileName: 'mateo_edge_fade_states',
      builder: () => GoldenTestGroup(
        scenarioConstraints: BoxConstraints(maxWidth: 400, maxHeight: 300),
        children: [
          GoldenTestScenario(
            name: 'top edge',
            child: _FadeScenario(position: MateoEdgeFadePosition.top),
          ),
          GoldenTestScenario(
            name: 'bottom edge',
            child: _FadeScenario(position: MateoEdgeFadePosition.bottom),
          ),
          GoldenTestScenario(
            name: 'custom color',
            child: _FadeScenario(
              position: MateoEdgeFadePosition.top,
              style: MateoEdgeFadeStyle(
                color: mateoTestColorScheme.buttons.primary.background,
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'default color on light background',
            child: _FadeScenario(
              position: MateoEdgeFadePosition.top,
              backgroundColor: mateoTestColorScheme.skeleton.bone,
            ),
          ),
        ],
      ),
    );
  });
}
