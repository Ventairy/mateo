import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  test('when no counter observes it, it should not impose a character limit', () {
    final controller = MateoTextController();
    addTearDown(controller.dispose);

    controller.text = 'a' * 51;

    expect(controller.text, 'a' * 51);
  });

  testWidgets('when used by a Flutter text field, it should own text and focus directly', (tester) async {
    final controller = MateoTextController(text: 'Mateo');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      TestApp(
        child: TextField(
          controller: controller,
          focusNode: controller.focusNode,
        ),
      ),
    );

    controller.focus();
    await tester.pump();

    expect((controller.text, controller.hasFocus), ('Mateo', true));
  });
}
