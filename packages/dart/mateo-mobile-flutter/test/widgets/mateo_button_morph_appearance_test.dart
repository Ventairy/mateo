import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/button_morph_scene.dart';

void main() {
  testWidgets(
    'when a header button morphs forward and back, it should retain its scoped appearance throughout the flight and handoff',
    (tester) async {
      final scene = ButtonMorphScene();
      await tester.pumpWidget(scene.app);
      await tester.pumpAndSettle();
      final samples = [...scene.appearances(tester)];
      scene.push();
      await tester.pump();
      await tester.pump();
      for (final milliseconds in [40, 230, 240]) {
        await tester.pump(Duration(milliseconds: milliseconds));
        samples.addAll(scene.appearances(tester));
      }
      await tester.pumpAndSettle();
      samples.addAll(scene.appearances(tester));
      scene.navigator.currentState!.pop();
      await tester.pump();
      await tester.pump();
      for (final milliseconds in [40, 230, 240]) {
        await tester.pump(Duration(milliseconds: milliseconds));
        samples.addAll(scene.appearances(tester));
      }
      await tester.pumpAndSettle();
      samples.addAll(scene.appearances(tester));
      expect(
        samples,
        everyElement((
          color: MateoButtonVariant.primary.base.resolveColorScheme(scene.theme.colorScheme.buttons).background,
          height: MateoButtonSize.small.height,
          elevation: 1.0,
        )),
      );
    },
  );
}
