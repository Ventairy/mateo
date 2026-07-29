import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  group('MateoFloatingActionButton Golden Tests', () {
    goldenTest(
      'when rendering visual states, it should match the approved golden',
      fileName: 'mateo_floating_action_button_states',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'resting',
            child: MateoFloatingActionButton(
              semanticLabel: 'Go back',
              iconBuilder: (state) => Icon(
                Icons.arrow_back,
                color: state.foregroundColor,
                size: state.iconSize,
              ),
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'custom',
            child: MateoFloatingActionButton(
              semanticLabel: 'Create',
              size: 64,
              iconSize: 28,
              backgroundColor: mateoTestPalette.green[9],
              foregroundColor: Colors.white,
              borderSide: BorderSide(
                color: mateoTestPalette.green[11],
                width: 2,
              ),
              iconBuilder: (state) => Icon(
                Icons.add,
                color: state.foregroundColor,
                size: state.iconSize,
              ),
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'action bloom source',
            child: MateoFloatingActionButton.actionBloom(
              semanticLabel: 'Note actions',
              actions: [
                _action('Create', Icons.add),
                _action('Delete', Icons.delete),
              ],
              iconBuilder: (state) => Icon(
                Icons.more_horiz,
                color: state.foregroundColor,
                size: state.iconSize,
              ),
            ),
          ),
        ],
      ),
    );
  });
}

MateoActionBloomAction _action(String title, IconData icon) {
  return MateoActionBloomAction(
    title: title,
    iconBuilder: (state) =>
        Icon(icon, color: state.foregroundColor, size: state.iconSize),
    onPressed: (feedbackAnimation) async {},
  );
}
