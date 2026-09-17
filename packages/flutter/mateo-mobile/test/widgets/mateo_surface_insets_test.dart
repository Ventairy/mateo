import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/base_mateo_surface.dart';

import '../fixtures/obstruction_insets_source.dart';
import '../fixtures/surface_transform_test_widgets.dart';

void main() {
  const childKey = ValueKey('content');
  testWidgets('when obstruction ownership changes, it should replace subscriptions and clear removed clearance', (
    tester,
  ) async {
    final first = ObstructionInsetsSource(const .only(top: 40));
    final second = ObstructionInsetsSource(const .only(top: 80));
    final selected = ValueNotifier<ObstructionInsetsSource?>(first);
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    addTearDown(selected.dispose);
    await tester.pumpWidget(
      Directionality(
        textDirection: .ltr,
        child: ValueListenableBuilder<ObstructionInsetsSource?>(
          valueListenable: selected,
          builder: (_, obstruction, child) => BaseMateoSurface(
            obstruction: obstruction,
            width: const .fill(),
            height: const .fill(),
            padding: .zero,
            color: surfaceTransformTheme.colorScheme.background,
            child: const SizedBox.expand(key: childKey),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byKey(childKey)).dy, 40);
    selected.value = second;
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byKey(childKey)).dy, 80);
    // Inspect subscriptions to verify the old owner is released.
    // ignore: invalid_use_of_protected_member
    expect(first.headerChanges.hasListeners, isFalse);
    // Inspect subscriptions to verify the new owner is observed.
    // ignore: invalid_use_of_protected_member
    expect(second.headerChanges.hasListeners, isTrue);
    first.insets.value = const .only(top: 120);
    first.headerChanges.notifyListeners();
    await tester.pump();
    expect(tester.getTopLeft(find.byKey(childKey)).dy, 80);
    selected.value = null;
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byKey(childKey)).dy, 0);
    // Removing coordination must release the remaining subscription.
    // ignore: invalid_use_of_protected_member
    expect(second.headerChanges.hasListeners, isFalse);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('when top and bottom are reserved, it should fit and align content between them', (tester) async {
    final view = ObstructionInsetsSource(const .fromLTRB(5, 60, 15, 80));
    addTearDown(view.dispose);
    for (final alignment in [Alignment.topLeft, Alignment.center, Alignment.bottomRight]) {
      await tester.pumpWidget(
        Directionality(
          textDirection: .ltr,
          child: Align(
            alignment: .topLeft,
            child: BaseMateoSurface(
              obstruction: view,
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
      final spacing = tester.renderObject(find.byKey(childKey)).parent! as RenderBox;
      await tester.pumpAndSettle();
      final rect = tester.getRect(find.byKey(childKey));
      expect(rect.left, greaterThanOrEqualTo(15));
      expect(rect.top, greaterThanOrEqualTo(70));
      expect(rect.right, lessThanOrEqualTo(275));
      expect(rect.bottom, lessThanOrEqualTo(210));
      if (alignment == Alignment.center) expect(rect, const Rect.fromLTWH(130, 130, 40, 40));
      final box = spacing;
      expect(box.getMinIntrinsicHeight(300), 200);
      expect(box.getMinIntrinsicWidth(300), 80);
      expect(box.getDryLayout(const BoxConstraints.tightFor(width: 300, height: 300)), const Size(300, 300));
    }
  });

  testWidgets('when scroll content reserves a bottom inset, it should leave that space at the end', (tester) async {
    final view = ObstructionInsetsSource(const .only(top: 60, bottom: 80));
    addTearDown(view.dispose);
    await tester.pumpWidget(
      Directionality(
        textDirection: .ltr,
        child: Align(
          alignment: .topLeft,
          child: BaseMateoSurface.scrollable(
            obstruction: view,
            width: const .custom(300),
            height: const .custom(300),
            color: const Color(0xFF123456),
            padding: const .all(10),
            child: const SizedBox(key: childKey, height: 600),
          ),
        ),
      ),
    );
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
