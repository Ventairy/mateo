import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/obstruction_insets_source.dart';

void main() {
  const childKey = ValueKey('content');
  testWidgets('when top and bottom are reserved, it should fit and align content between them', (tester) async {
    final view = ObstructionInsetsSource(const .fromLTRB(5, 60, 15, 80));
    addTearDown(view.dispose);
    for (final alignment in [Alignment.topLeft, Alignment.center, Alignment.bottomRight]) {
      await tester.pumpWidget(
        Directionality(
          textDirection: .ltr,
          child: Align(
            alignment: .topLeft,
            child: MateoSurface(
              width: const .custom(300),
              height: const .custom(300),
              color: const Color(0xFF123456),
              padding: const .all(10),
              alignment: alignment,
              child: const SizedBox(key: childKey, width: 40, height: 40),
            ),
          ),
        ),
      );
      // Supply the future footer reservation through the existing render contract.
      final dynamic spacing = tester.renderObject(find.byKey(childKey)).parent;
      // The renderer is private; exercise its inset inputs without exporting it.
      // ignore: avoid_dynamic_calls, cascade_invocations
      spacing
        ..obstructionInsets = (() => view.obstructionInsets)
        ..obstructionInsetsChanges = view.obstructionInsetsChanges;
      await tester.pumpAndSettle();
      final rect = tester.getRect(find.byKey(childKey));
      expect(rect.left, greaterThanOrEqualTo(15));
      expect(rect.top, greaterThanOrEqualTo(70));
      expect(rect.right, lessThanOrEqualTo(275));
      expect(rect.bottom, lessThanOrEqualTo(210));
      if (alignment == Alignment.center) expect(rect, const Rect.fromLTWH(130, 130, 40, 40));
      final box = spacing as RenderBox;
      expect(box.getMinIntrinsicHeight(300), 200);
      expect(box.getMinIntrinsicWidth(300), 80);
      expect(box.getDryLayout(const BoxConstraints.tightFor(width: 300, height: 300)), const Size(300, 300));
    }
  });

  testWidgets('when scroll content reserves a bottom inset, it should leave that space at the end', (tester) async {
    final view = ObstructionInsetsSource(const .only(top: 60, bottom: 80));
    addTearDown(view.dispose);
    await tester.pumpWidget(
      const Directionality(
        textDirection: .ltr,
        child: Align(
          alignment: .topLeft,
          child: MateoSurface.scrollable(
            width: .custom(300),
            height: .custom(300),
            color: Color(0xFF123456),
            padding: .all(10),
            child: SizedBox(key: childKey, height: 600),
          ),
        ),
      ),
    );
    final dynamic spacing = tester.renderObject(find.byKey(childKey)).parent;
    // The renderer is private; exercise its inset inputs without exporting it.
    // ignore: avoid_dynamic_calls, cascade_invocations
    spacing
      ..obstructionInsets = (() => view.obstructionInsets)
      ..obstructionInsetsChanges = view.obstructionInsetsChanges;
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byKey(childKey)).dy, 70);
    final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!;
    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pumpAndSettle();
    expect(tester.getBottomLeft(find.byKey(childKey)).dy, 210);

    final beforeFooter = controller.position.maxScrollExtent;
    view.insets.value = const .only(top: 60, bottom: 100);
    view.footerChanges.notifyListeners();
    await tester.pumpAndSettle();
    expect(controller.position.maxScrollExtent, beforeFooter + 20);
    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pumpAndSettle();
    expect(tester.getBottomLeft(find.byKey(childKey)).dy, 190);

    final beforeHeader = tester.getTopLeft(find.byKey(childKey)).dy;
    view.insets.value = const .only(top: 100, bottom: 100);
    view.headerChanges.notifyListeners();
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byKey(childKey)).dy, beforeHeader + 40);
    await tester.pumpWidget(const SizedBox());
    // Verify that detaching the consumer removes both merged subscriptions.
    // ignore: invalid_use_of_protected_member
    expect(view.headerChanges.hasListeners, isFalse);
    // Verify the future footer subscription is released as well.
    // ignore: invalid_use_of_protected_member
    expect(view.footerChanges.hasListeners, isFalse);
  });
}
