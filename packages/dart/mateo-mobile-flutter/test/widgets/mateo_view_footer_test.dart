import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  const footerKey = ValueKey('footer-content');
  const contentKey = ValueKey('content');
  Widget host({
    bool footer = true,
    bool header = false,
    bool scrollable = false,
    double safeBottom = 24,
    double keyboard = 0,
    double bottom = 600,
    double footerHeight = 30,
    double contentHeight = 800,
    EdgeInsetsGeometry? surfacePadding,
    EdgeInsetsGeometry? footerPadding,
    EdgeInsetsGeometry viewPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    AlignmentGeometry? alignment,
  }) {
    final child = SizedBox(key: contentKey, height: contentHeight);
    return Directionality(
      textDirection: .ltr,
      child: MediaQuery(
        data: MediaQueryData(
          size: const Size(800, 600),
          padding: .only(top: 24, bottom: safeBottom),
          viewInsets: .only(bottom: keyboard),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              width: 300,
              height: bottom,
              child: MateoView(
                padding: viewPadding,
                header: header ? const MateoViewHeader(principal: SizedBox(height: 30)) : null,
                footer: footer
                    ? MateoViewFooter(
                        padding: footerPadding,
                        principal: SizedBox(key: footerKey, width: double.infinity, height: footerHeight),
                      )
                    : null,
                surface: scrollable
                    ? MateoViewSurface.scrollable(
                        color: const Color(0xFF123456),
                        alignment: alignment,
                        padding: surfacePadding,
                        child: child,
                      )
                    : MateoViewSurface(
                        color: const Color(0xFF123456),
                        alignment: alignment,
                        padding: surfacePadding,
                        child: child,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  testWidgets('when a footer reserves space, it should clear its corrected top and the content gap', (tester) async {
    for (final header in [false, true]) {
      await tester.pumpWidget(host(header: header));
      await tester.pumpAndSettle();
      expect(tester.getBottomLeft(find.byKey(contentKey)).dy, tester.getTopLeft(find.byKey(footerKey)).dy - 20);
      expect(tester.getTopLeft(find.byKey(contentKey)).dy, header ? 86 : 12);
      await tester.pumpWidget(host(header: header, keyboard: 200));
      await tester.pumpAndSettle();
      expect(tester.getBottomLeft(find.byKey(contentKey)).dy, 338);
      await tester.pumpWidget(host(header: header, bottom: 400));
      await tester.pumpAndSettle();
      expect(tester.getBottomLeft(find.byKey(contentKey)).dy, 338);
    }
  });

  testWidgets('when local footer padding is supplied, it should replace inherited padding', (tester) async {
    await tester.pumpWidget(host(footerPadding: .zero));
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byKey(footerKey)), const Rect.fromLTWH(0, 546, 300, 30));
    expect(tester.getBottomLeft(find.byKey(contentKey)).dy, 526);
    await tester.pumpWidget(host(footerPadding: const .fromLTRB(3, 7, 11, 15)));
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byKey(footerKey)), const Rect.fromLTWH(3, 531, 286, 30));
    expect(tester.getBottomLeft(find.byKey(contentKey)).dy, 504);
  });

  testWidgets('when footer size changes, it should update scrolling without replacing its controller', (
    tester,
  ) async {
    await tester.pumpWidget(host(scrollable: true));
    await tester.pumpAndSettle();
    final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!..jumpTo(100);
    await tester.pumpWidget(host(scrollable: true));
    await tester.pumpAndSettle();
    expect(tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller, same(controller));
    expect(controller.offset, 100);
    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pumpAndSettle();
    expect(tester.getBottomLeft(find.byKey(contentKey)).dy, 514);
    controller.jumpTo(100);
    await tester.pumpWidget(host(scrollable: true, footerHeight: 60, safeBottom: 40));
    await tester.pumpAndSettle();
    expect(controller.offset, 100);
    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pumpAndSettle();
    expect(tester.getBottomLeft(find.byKey(contentKey)).dy, 468);
    controller.jumpTo(100);
    await tester.pumpWidget(host(scrollable: true, footer: false));
    await tester.pumpAndSettle();
    expect(tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller, same(controller));
    expect(controller.offset, 100);
  });

  testWidgets('when a footer is already inset, it should add no extra safe-area displacement', (
    tester,
  ) async {
    await tester.pumpWidget(host(bottom: 450, alignment: .bottomCenter));
    await tester.pumpAndSettle();
    expect(tester.getBottomLeft(find.byKey(footerKey)).dy, 438);
    expect(tester.getBottomLeft(find.byKey(contentKey)).dy, 388);
  });
  testWidgets('when scrolling with a footer, it should end above its corrected position and padding', (
    tester,
  ) async {
    ScrollController? retained;
    for (final keyboard in [0.0, 200.0, 0.0]) {
      await tester.pumpWidget(host(scrollable: true, keyboard: keyboard, surfacePadding: const .only(bottom: 8)));
      await tester.pumpAndSettle();
      final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!;
      if (retained != null) expect(controller, same(retained));
      retained = controller;
      controller.jumpTo(controller.position.maxScrollExtent);
      await tester.pumpAndSettle();
      expect(tester.getBottomLeft(find.byKey(contentKey)).dy, tester.getTopLeft(find.byKey(footerKey)).dy - 8);
      expect(tester.getRect(find.byType(MateoViewSurface)), const Rect.fromLTWH(0, 0, 300, 600));
    }
  });

  testWidgets('when short scrollable content is bottom aligned, it should still avoid a footer', (
    tester,
  ) async {
    await tester.pumpWidget(host(scrollable: true, contentHeight: 40, alignment: .bottomCenter));
    await tester.pumpAndSettle();
    expect(tester.getBottomLeft(find.byKey(contentKey)).dy, 514);
    final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!;
    expect(controller.position.maxScrollExtent, 0);
    await tester.pumpWidget(host(scrollable: true, footer: false, contentHeight: 40, alignment: .bottomCenter));
    await tester.pumpAndSettle();
    expect(tester.getBottomLeft(find.byKey(contentKey)).dy, 588);
  });
}
