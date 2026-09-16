import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures/drag_resistance_overdrag_scene.dart';

final Finder _content = find.byKey(const ValueKey('overdrag-content'));

Future<void> _pump(
  WidgetTester tester, {
  VoidCallback? onDismiss,
  ScrollController? scrollController,
  bool reduced = false,
}) => tester.pumpWidget(
  Directionality(
    textDirection: .ltr,
    child: MediaQuery(
      data: MediaQueryData(disableAnimations: reduced),
      child: Center(
        child: DragResistanceOverdragScene(onDismiss: onDismiss ?? () {}, scrollController: scrollController),
      ),
    ),
  ),
);

void main() {
  for (final cancel in [false, true]) {
    testWidgets('when real overdrag ends with cancel=$cancel, it should distinguish release from reversal', (
      tester,
    ) async {
      await _pump(tester);
      final origin = tester.getTopLeft(_content);
      final gesture = await tester.startGesture(tester.getCenter(_content));
      await gesture.moveBy(const Offset(0, -4));
      await tester.pump();
      expect(tester.getTopLeft(_content), origin);
      await gesture.moveBy(const Offset(0, -92));
      await tester.pump();
      expect((tester.getTopLeft(_content) - origin).dy, closeTo(-3, 1e-8));
      await gesture.moveBy(const Offset(0, 96));
      await tester.pump();
      expect(tester.getTopLeft(_content), origin);
      await gesture.moveBy(const Offset(0, -96));
      await tester.pump();
      if (cancel) {
        await gesture.cancel();
      } else {
        await gesture.up();
      }
      await tester.pump();
      expect((tester.getTopLeft(_content) - origin).dy, closeTo(-3, 1e-8));
      await tester.pump(const Duration(milliseconds: 90));
      expect((tester.getTopLeft(_content) - origin).dy, allOf(greaterThan(-3), lessThan(0)));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(_content), origin);
    });
  }

  testWidgets('when dragged downward, it should preserve dismissal movement and request the action', (tester) async {
    var dismissals = 0;
    await _pump(tester, onDismiss: () => dismissals++);
    final origin = tester.getTopLeft(_content);
    final gesture = await tester.startGesture(tester.getCenter(_content));
    await gesture.moveBy(const Offset(0, 180));
    await tester.pump();
    expect((tester.getTopLeft(_content) - origin).dy, 180);
    await gesture.up();
    await tester.pumpAndSettle();
    expect(dismissals, 1);
    expect(tester.getTopLeft(_content), origin);
  });

  testWidgets('when content can scroll, it should resist only after reaching the edge', (tester) async {
    final controller = ScrollController(initialScrollOffset: 100);
    addTearDown(controller.dispose);
    await _pump(tester, scrollController: controller);
    final origin = tester.getTopLeft(_content);
    final gesture = await tester.startGesture(tester.getCenter(_content));
    await gesture.moveBy(const Offset(0, -96));
    await tester.pump();
    expect(controller.offset, greaterThan(100));
    expect(tester.getTopLeft(_content), origin);
    await gesture.cancel();
    await tester.pumpAndSettle();
    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pumpAndSettle();
    final boundaryGesture = await tester.startGesture(tester.getCenter(_content));
    await boundaryGesture.moveBy(const Offset(0, -96));
    await tester.pump();
    expect((tester.getTopLeft(_content) - origin).dy, lessThan(0));
    await boundaryGesture.cancel();
    await tester.pumpAndSettle();
  });

  testWidgets('when reduced motion is enabled, it should suppress resistance and preserve dismissal', (tester) async {
    var dismissals = 0;
    await _pump(tester, reduced: true, onDismiss: () => dismissals++);
    final origin = tester.getTopLeft(_content);
    final gesture = await tester.startGesture(tester.getCenter(_content));
    await gesture.moveBy(const Offset(0, -96));
    await tester.pump();
    expect(tester.getTopLeft(_content), origin);
    await gesture.moveBy(const Offset(0, 276));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(dismissals, 1);
  });
}
