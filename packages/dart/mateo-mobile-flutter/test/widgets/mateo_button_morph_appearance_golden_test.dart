import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';

import '../fixtures/button_morph_scene.dart';

void main() {
  for (final returning in [false, true]) {
    late ButtonMorphScene scene;
    unawaited(
      goldenTest(
        'when a header button morphs ${returning ? 'back' : 'forward'}, it should retain its base appearance',
        fileName: 'mateo_button_morph_${returning ? 'pop' : 'push'}',
        constraints: const BoxConstraints.tightFor(width: 390, height: 700),
        builder: () {
          scene = ButtonMorphScene();
          return scene.app;
        },
        whilePerforming: (tester) async {
          scene.push();
          if (returning) {
            await tester.pumpAndSettle();
            scene.navigator.currentState!.pop();
          }
          await tester.pump();
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 240));
          return tester.pumpAndSettle;
        },
      ),
    );
  }
}
