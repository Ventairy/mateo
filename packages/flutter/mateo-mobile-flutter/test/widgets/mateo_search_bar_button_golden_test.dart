import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  group('MateoSearchBarButton Golden Tests', () {
    goldenTest(
      'when rendering the resting search bar button, it should match the approved golden',
      fileName: 'mateo_search_bar_button_resting',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints(maxWidth: 400),
        children: [
          GoldenTestScenario(
            name: 'resting',
            child: const SizedBox(
              width: 400,
              child: MateoSearchBarButton(
                title: 'Search for an opportunity...',
              ),
            ),
          ),
        ],
      ),
    );
  });
}
