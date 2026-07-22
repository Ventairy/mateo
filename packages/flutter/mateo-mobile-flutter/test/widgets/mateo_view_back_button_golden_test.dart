import 'package:alchemist/alchemist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  group('MateoViewBackButton Golden Tests', () {
    goldenTest(
      'when rendering the resting back button, it should match the approved golden',
      fileName: 'mateo_view_back_button_resting',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'resting',
            child: MateoViewBackButton(onPressed: () {}),
          ),
        ],
      ),
    );
  });
}
