import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  group('MateoButtonPanel Golden Tests', () {
    goldenTest(
      'when rendering a two-button stack, it should match the approved golden',
      fileName: 'mateo_button_panel',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(width: 360),
        children: [
          GoldenTestScenario(
            name: 'primary and secondary actions',
            child: MateoButtonPanel(
              buttons: [
                MateoButton(
                  label: 'See offers',
                  variant: MateoButtonVariant.primary,
                  fit: MateoButtonFit.expand,
                  trailingIconBuilder: (state) => Icon(
                    Icons.near_me,
                    color: state.foregroundColor,
                    size: 20,
                  ),
                  onPressed: () {},
                ),
                MateoButton(
                  label: 'Post a job',
                  variant: MateoButtonVariant.secondary,
                  fit: MateoButtonFit.expand,
                  leadingIconBuilder: (state) => Icon(
                    Icons.edit_square,
                    color: state.foregroundColor,
                    size: 20,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  });
}
