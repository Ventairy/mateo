import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  group('MateoCharacterCounter', () {
    testWidgets('when text changes, it should count user-perceived characters', (tester) async {
      final controller = MateoTextController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        TestApp(
          child: MateoCharacterCounter(
            textController: controller,
            limit: 10,
            variant: MateoCharacterCounterVariant.text,
          ),
        ),
      );

      controller.text = '👨‍👩‍👧‍👦a';
      await tester.pump();

      expect(
        tester.widget<Text>(find.byKey(const ValueKey('mateo_character_counter_value'))).data,
        '2',
      );
    });

    testWidgets('when customized, it should apply the supplied padding and font size', (tester) async {
      final controller = MateoTextController(text: 'a');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        TestApp(
          child: MateoCharacterCounter(
            textController: controller,
            limit: 50,
            variant: MateoCharacterCounterVariant.floating,
            padding: const EdgeInsets.all(13),
            fontSize: 17,
          ),
        ),
      );

      expect(
        (
          tester
              .widget<Padding>(find.descendant(of: find.byType(MateoCharacterCounter), matching: find.byType(Padding)))
              .padding,
          tester
              .widget<AnimatedDefaultTextStyle>(find.byKey(const ValueKey('mateo_character_counter_text')))
              .style
              .fontSize,
        ),
        (const EdgeInsets.all(13), 17),
      );
    });

    testWidgets('when the limit is exceeded, it should show rejection feedback', (tester) async {
      final controller = MateoTextController(text: 'abc');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: TestApp(
            child: MateoCharacterCounter(
              textController: controller,
              limit: 3,
              variant: MateoCharacterCounterVariant.text,
            ),
          ),
        ),
      );

      controller.text = 'abcd';
      await tester.pump();

      expect(
        tester.widget<AnimatedDefaultTextStyle>(find.byKey(const ValueKey('mateo_character_counter_text'))).style.color,
        mateoTestColorScheme.characterCounter.text.foregroundReject,
      );
    });

    testWidgets('when a Flutter text field exceeds the limit, it should reject input without a formatter', (
      tester,
    ) async {
      final controller = MateoTextController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        TestApp(
          child: Column(
            children: [
              TextField(controller: controller, focusNode: controller.focusNode),
              MateoCharacterCounter(
                textController: controller,
                limit: 3,
                variant: MateoCharacterCounterVariant.text,
              ),
            ],
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'abcd');

      expect(controller.text, 'abc');
    });

    testWidgets('when an edit exceeds its grapheme limit, it should preserve complete user-perceived characters', (
      tester,
    ) async {
      final controller = MateoTextController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        TestApp(
          child: MateoCharacterCounter(
            textController: controller,
            limit: 1,
            variant: MateoCharacterCounterVariant.text,
          ),
        ),
      );

      controller.text = '👨‍👩‍👧‍👦a';

      expect(controller.text, '👨‍👩‍👧‍👦');
    });

    testWidgets('when its limit decreases, it should truncate the existing text', (tester) async {
      final controller = MateoTextController(text: 'abcde');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        TestApp(
          child: MateoCharacterCounter(
            textController: controller,
            limit: 5,
            variant: MateoCharacterCounterVariant.text,
          ),
        ),
      );

      await tester.pumpWidget(
        TestApp(
          child: MateoCharacterCounter(
            textController: controller,
            limit: 3,
            variant: MateoCharacterCounterVariant.text,
          ),
        ),
      );

      expect(controller.text, 'abc');
    });

    testWidgets('when its controller changes, it should move limit ownership to the new controller', (tester) async {
      final oldController = MateoTextController();
      final newController = MateoTextController();
      addTearDown(oldController.dispose);
      addTearDown(newController.dispose);
      await tester.pumpWidget(
        TestApp(
          child: MateoCharacterCounter(
            textController: oldController,
            limit: 3,
            variant: MateoCharacterCounterVariant.text,
          ),
        ),
      );

      await tester.pumpWidget(
        TestApp(
          child: MateoCharacterCounter(
            textController: newController,
            limit: 3,
            variant: MateoCharacterCounterVariant.text,
          ),
        ),
      );
      oldController.text = 'abcd';
      newController.text = 'abcd';

      expect((oldController.text, newController.text), ('abcd', 'abc'));
    });

    testWidgets('when removed, it should release its controller limit', (tester) async {
      final controller = MateoTextController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        TestApp(
          child: MateoCharacterCounter(
            textController: controller,
            limit: 3,
            variant: MateoCharacterCounterVariant.text,
          ),
        ),
      );

      await tester.pumpWidget(const TestApp(child: SizedBox.shrink()));
      controller.text = 'abcd';

      expect(controller.text, 'abcd');
    });

    testWidgets('when multiple counters share a controller, it should enforce the smallest attached limit', (
      tester,
    ) async {
      final controller = MateoTextController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        TestApp(
          child: Row(
            children: [
              MateoCharacterCounter(
                textController: controller,
                limit: 5,
                variant: MateoCharacterCounterVariant.text,
              ),
              MateoCharacterCounter(
                textController: controller,
                limit: 3,
                variant: MateoCharacterCounterVariant.text,
              ),
            ],
          ),
        ),
      );

      controller.text = 'abcd';
      final shortestLimitText = controller.text;
      await tester.pumpWidget(
        TestApp(
          child: MateoCharacterCounter(
            textController: controller,
            limit: 5,
            variant: MateoCharacterCounterVariant.text,
          ),
        ),
      );
      controller.text = 'abcde';

      expect((shortestLimitText, controller.text), ('abc', 'abcde'));
    });

    testWidgets('when over-limit input is composing, it should wait for composition to finish', (tester) async {
      final controller = MateoTextController(text: 'ab');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        TestApp(
          child: MateoCharacterCounter(
            textController: controller,
            limit: 3,
            variant: MateoCharacterCounterVariant.text,
          ),
        ),
      );

      controller.value = const TextEditingValue(
        text: 'abcd',
        selection: TextSelection.collapsed(offset: 4),
        composing: TextRange(start: 1, end: 4),
      );

      expect(
        controller.value,
        const TextEditingValue(
          text: 'abcd',
          selection: TextSelection.collapsed(offset: 4),
          composing: TextRange(start: 1, end: 4),
        ),
      );
    });

    testWidgets('when over-limit composition finishes, it should enforce the limit and keep selection valid', (
      tester,
    ) async {
      final controller = MateoTextController(text: 'ab');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        TestApp(
          child: MateoCharacterCounter(
            textController: controller,
            limit: 3,
            variant: MateoCharacterCounterVariant.text,
          ),
        ),
      );
      controller.value = const TextEditingValue(
        text: 'abcd',
        selection: TextSelection.collapsed(offset: 4),
        composing: TextRange(start: 1, end: 4),
      );

      controller.value = controller.value.copyWith(composing: TextRange.empty);

      expect(
        controller.value,
        const TextEditingValue(
          text: 'abc',
          selection: TextSelection.collapsed(offset: 3),
        ),
      );
    });

    testWidgets('when the count gains a digit, it should move the suffix continuously', (tester) async {
      final controller = MateoTextController(text: 'a' * 9);
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        TestApp(
          child: MateoCharacterCounter(
            textController: controller,
            limit: 50,
            variant: MateoCharacterCounterVariant.floating,
          ),
        ),
      );
      final suffix = find.byKey(const ValueKey('mateo_character_counter_suffix'));
      final start = tester.getTopLeft(suffix).dx;

      controller.text = 'a' * 10;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 70));
      final middle = tester.getTopLeft(suffix).dx;
      await tester.pump(const Duration(milliseconds: 100));
      final end = tester.getTopLeft(suffix).dx;

      expect(start < middle && middle < end, isTrue);
    });

    testWidgets('when a new digit slot starts opening, it should keep the value on one line', (tester) async {
      final controller = MateoTextController(text: 'a' * 9);
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        TestApp(
          child: MateoCharacterCounter(
            textController: controller,
            limit: 50,
            variant: MateoCharacterCounterVariant.floating,
          ),
        ),
      );

      controller.text = 'a' * 10;
      await tester.pump();

      expect(
        tester.getSize(find.byKey(const ValueKey('mateo_character_counter_value'))).height,
        tester.getSize(find.byKey(const ValueKey('mateo_character_counter_suffix'))).height,
      );
    });

    testWidgets('when a new digit slot starts opening, it should not clip the incoming digit', (tester) async {
      final controller = MateoTextController(text: 'a' * 9);
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        TestApp(
          child: MateoCharacterCounter(
            textController: controller,
            limit: 50,
            variant: MateoCharacterCounterVariant.floating,
          ),
        ),
      );

      controller.text = 'a' * 10;
      await tester.pump();

      expect(
        find.descendant(
          of: find.byKey(const ValueKey('mateo_character_counter_value_slot')),
          matching: find.byType(ClipRect),
        ),
        findsNothing,
      );
    });

    testWidgets('when the count gains a digit, it should resize the pill continuously', (tester) async {
      final controller = MateoTextController(text: 'a' * 9);
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        TestApp(
          child: MateoCharacterCounter(
            textController: controller,
            limit: 50,
            variant: MateoCharacterCounterVariant.floating,
          ),
        ),
      );
      final counter = find.byKey(const ValueKey('mateo_character_counter'));
      final start = tester.getSize(counter).width;

      controller.text = 'a' * 10;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 70));
      final middle = tester.getSize(counter).width;
      await tester.pump(const Duration(milliseconds: 100));
      final end = tester.getSize(counter).width;

      expect(start < middle && middle < end, isTrue);
    });
  });
}
