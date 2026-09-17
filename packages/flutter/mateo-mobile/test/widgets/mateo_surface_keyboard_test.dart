import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  const contentKey = ValueKey('content');
  const footerKey = ValueKey('footer');
  Widget host(double keyboard, {Alignment alignment = Alignment.center, double contentHeight = 3200}) => Directionality(
    textDirection: .ltr,
    child: MediaQuery(
      data: MediaQueryData(
        size: const Size(800, 600),
        padding: .only(top: 24, bottom: keyboard == 0 ? 24 : 0),
        viewPadding: const .only(top: 24, bottom: 24),
        viewInsets: .only(bottom: keyboard),
      ),
      child: MateoView(
        header: const MateoViewHeader(principal: SizedBox(height: 30)),
        footer: const MateoViewFooter(principal: SizedBox(key: footerKey, height: 30)),
        surface: MateoViewSurface.scrollable(
          color: const Color(0xFF123456),
          alignment: alignment,
          child: SizedBox(key: contentKey, width: 100, height: contentHeight),
        ),
      ),
    ),
  );

  testWidgets('when the keyboard closes at scroll start, it should keep aligned content stationary on every frame', (
    tester,
  ) async {
    for (final alignment in [Alignment.center, const Alignment(0, -0.2), const Alignment(0, 0.2)]) {
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(host(300, alignment: alignment));
      await tester.pumpAndSettle();
      final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!;
      final top = tester.getTopLeft(find.byKey(contentKey)).dy;
      for (final keyboard in [220.0, 160.0, 100.0, 40.0, 0.0]) {
        await tester.pumpWidget(host(keyboard, alignment: alignment), duration: const Duration(milliseconds: 16));
        expect(tester.getTopLeft(find.byKey(contentKey)).dy, top, reason: 'first frame at keyboard=$keyboard');
        expect(controller.offset, 0);
        await tester.pump(const Duration(milliseconds: 16));
        expect(tester.getTopLeft(find.byKey(contentKey)).dy, top, reason: 'reconciled frame at keyboard=$keyboard');
        expect(controller.offset, 0);
      }
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(find.byKey(contentKey)).dy, top);
    }
  });

  testWidgets(
    'when the keyboard closes at scroll end, it should move content without reversing and keep the end reachable',
    (tester) async {
      await tester.pumpWidget(host(300));
      await tester.pumpAndSettle();
      final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!;
      controller.jumpTo(controller.position.maxScrollExtent);
      await tester.pumpAndSettle();
      var previous = tester.getBottomLeft(find.byKey(contentKey)).dy;
      for (final keyboard in [220.0, 160.0, 100.0, 40.0, 0.0]) {
        await tester.pumpWidget(host(keyboard), duration: const Duration(milliseconds: 16));
        var bottom = tester.getBottomLeft(find.byKey(contentKey)).dy;
        expect(bottom, greaterThanOrEqualTo(previous));
        previous = bottom;
        await tester.pump(const Duration(milliseconds: 16));
        bottom = tester.getBottomLeft(find.byKey(contentKey)).dy;
        expect(bottom, greaterThanOrEqualTo(previous));
        previous = bottom;
      }
      await tester.pumpAndSettle();
      expect(controller.position.extentAfter, 24);
      controller.jumpTo(controller.position.maxScrollExtent);
      await tester.pumpAndSettle();
      expect(tester.getBottomLeft(find.byKey(contentKey)).dy, tester.getTopLeft(find.byKey(footerKey)).dy - 20);
    },
  );

  testWidgets('when a rising keyboard obstructs short aligned content, it should avoid the footer immediately', (
    tester,
  ) async {
    await tester.pumpWidget(host(0, alignment: .bottomCenter, contentHeight: 40));
    await tester.pumpAndSettle();
    await tester.pumpWidget(host(200, alignment: .bottomCenter, contentHeight: 40));
    expect(tester.getBottomLeft(find.byKey(contentKey)).dy, tester.getTopLeft(find.byKey(footerKey)).dy - 44);
    await tester.pumpAndSettle();
    expect(tester.getBottomLeft(find.byKey(contentKey)).dy, tester.getTopLeft(find.byKey(footerKey)).dy - 20);
  });
}
