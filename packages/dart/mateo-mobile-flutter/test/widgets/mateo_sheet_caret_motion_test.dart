import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures/sheet_caret_motion_test_harness.dart';

void main() {
  final sheet = find.byKey(const ValueKey('caret_motion_sheet'));
  for (final (contentHeight, textScale) in [(200.0, 1.0), (280.0, 1.0), (240.0, 2.0)]) {
    for (final frameDuration in [const Duration(microseconds: 16667), const Duration(microseconds: 8333)]) {
      testWidgets(
        'when a focused $contentHeight tall sheet at text scale $textScale animates at ${frameDuration.inMicroseconds} microsecond frames, it should keep its height and direction throughout opening and closing',
        (tester) async {
          final harness = SheetCaretMotionTestHarness(contentHeight: contentHeight, textScale: textScale);
          await harness.pump(tester);
          harness.open();
          await tester.pump();
          final opening = <Rect>[tester.getRect(sheet)];
          for (var elapsed = Duration.zero; elapsed < const Duration(milliseconds: 500); elapsed += frameDuration) {
            await tester.pump(frameDuration);
            opening.add(tester.getRect(sheet));
          }
          await tester.pumpAndSettle();
          final closing = <Rect>[tester.getRect(sheet)];
          harness.navigatorKey.currentState!.pop();
          for (var elapsed = Duration.zero; elapsed < const Duration(milliseconds: 300); elapsed += frameDuration) {
            await tester.pump(frameDuration);
            if (sheet.evaluate().isNotEmpty) closing.add(tester.getRect(sheet));
          }
          await tester.pumpAndSettle();
          expect(
            (
              stableOpeningHeight: opening.every((rect) => (rect.height - opening.first.height).abs() < .001),
              movesUp: [for (var i = 1; i < opening.length; i++) opening[i].top <= opening[i - 1].top + .001]
                  .every((value) => value),
              stableClosingHeight: closing.every((rect) => (rect.height - closing.first.height).abs() < .001),
              movesDown: [for (var i = 1; i < closing.length; i++) closing[i].top >= closing[i - 1].top - .001]
                  .every((value) => value),
            ),
            (stableOpeningHeight: true, movesUp: true, stableClosingHeight: true, movesDown: true),
          );
        },
      );
    }
  }

  for (final contentHeight in [124.0, 650.0]) {
    for (final keyboardInset in [0.0, 309.0, 363.0]) {
      for (final frameDuration in [const Duration(microseconds: 16667), const Duration(microseconds: 8333)]) {
        testWidgets(
          'when a $contentHeight tall sheet closes and the keyboard changes to $keyboardInset at ${frameDuration.inMicroseconds} microsecond frames, it should preserve its exit geometry',
          (tester) async {
            final harness = SheetCaretMotionTestHarness(
              contentHeight: contentHeight,
              inputAtBottom: contentHeight > 600,
            );
            await harness.pump(tester);
            harness.open();
            await tester.pumpAndSettle();
            final initial = tester.getRect(sheet);
            harness.navigatorKey.currentState!.pop();
            tester.view.viewInsets = FakeViewPadding(bottom: keyboardInset);
            harness.media.value = harness.media.value.copyWith(viewInsets: EdgeInsets.only(bottom: keyboardInset));
            await tester.pump();
            expect(tester.getRect(sheet), initial);
            var previousTop = initial.top;
            for (var frame = 0; frame < 40; frame++) {
              if (frame == 3) {
                tester.view.viewInsets = FakeViewPadding(bottom: keyboardInset + 30);
                harness.media.value = harness.media.value.copyWith(
                  viewInsets: EdgeInsets.only(bottom: keyboardInset + 30),
                );
              }
              await tester.pump(frameDuration);
              if (sheet.evaluate().isEmpty) break;
              final bounds = tester.getRect(sheet);
              expect(bounds.height, closeTo(initial.height, .001));
              expect(bounds.top, greaterThanOrEqualTo(previousTop - .001));
              previousTop = bounds.top;
            }
            await tester.pumpAndSettle();
            expect(sheet, findsNothing);
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  }

  for (final reducedMotion in [false, true]) {
    testWidgets(
      'when enlarged text opens with reduced motion $reducedMotion, it should remain fitted and respond to keyboard changes',
      (tester) async {
        final harness = SheetCaretMotionTestHarness(textScale: 2, reducedMotion: reducedMotion);
        await harness.pump(tester);
        harness.open();
        await tester.pumpAndSettle();
        final initialHeight = tester.getSize(sheet).height;
        for (final inset in [390.0, 250.0, 336.0]) {
          tester.view.viewInsets = FakeViewPadding(bottom: inset);
          harness.media.value = harness.media.value.copyWith(viewInsets: EdgeInsets.only(bottom: inset));
          await tester.pumpAndSettle();
          final bounds = tester.getRect(sheet);
          expect(bounds.height, closeTo(initialHeight.clamp(0, 844 - inset - (47 + 12 * 2)), .001));
          expect(bounds.bottom, closeTo(844 - inset - 12, .001));
          final editor = tester.state<EditableTextState>(find.byType(EditableText));
          final caret = MatrixUtils.transformRect(
            editor.renderEditable.getTransformTo(null),
            editor.renderEditable.getLocalRectForCaret(editor.widget.controller.selection.extent),
          );
          final footer = tester.getRect(find.byKey(const ValueKey('caret_motion_continue')));
          expect(caret.bottom, lessThanOrEqualTo(footer.top));
        }
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('when the focused input needs real scrolling, it should reveal the caret above the fixed footer', (
    tester,
  ) async {
    final harness = SheetCaretMotionTestHarness(contentHeight: 650, inputAtBottom: true);
    await harness.pump(tester);
    harness.open();
    await tester.pumpAndSettle();
    final editor = tester.state<EditableTextState>(find.byType(EditableText));
    final caret = MatrixUtils.transformRect(
      editor.renderEditable.getTransformTo(null),
      editor.renderEditable.getLocalRectForCaret(editor.widget.controller.selection.extent),
    );
    final footer = tester.getRect(find.byKey(const ValueKey('caret_motion_continue')));
    expect(
      (
        focused: editor.widget.focusNode.hasFocus,
        caretAboveFooter: caret.bottom <= footer.top,
        caretOnScreen: caret.top >= 47,
      ),
      (focused: true, caretAboveFooter: true, caretOnScreen: true),
    );
  });
}
