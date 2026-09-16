import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  const header = ValueKey('header-content');
  const content = ValueKey('surface-content');
  Widget host({
    EdgeInsetsGeometry viewPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    EdgeInsetsGeometry? headerPadding,
    EdgeInsetsGeometry? surfacePadding,
    TextDirection direction = TextDirection.ltr,
    bool hasHeader = true,
    bool scrollable = false,
  }) {
    const child = SizedBox(key: content, height: 600);
    return Directionality(
      textDirection: direction,
      child: MediaQuery(
        data: const MediaQueryData(size: Size(800, 600)),
        child: Align(
          alignment: .topLeft,
          child: SizedBox(
            width: 300,
            height: 300,
            child: MateoView(
              padding: viewPadding,
              header: hasHeader
                  ? MateoViewHeader(
                      padding: headerPadding,
                      principal: const SizedBox(key: header, width: double.infinity, height: 30),
                    )
                  : null,
              surface: scrollable
                  ? MateoViewSurface.scrollable(color: const Color(0xFF123456), padding: surfacePadding, child: child)
                  : MateoViewSurface(color: const Color(0xFF123456), padding: surfacePadding, child: child),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('when slots or surface padding change, it should apply spacing once on every edge', (tester) async {
    for (final scrollable in [false, true]) {
      for (final hasHeader in [false, true]) {
        for (final hasFooter in [false, true]) {
          for (final padding in <EdgeInsetsGeometry?>[
            null,
            EdgeInsets.zero,
            const EdgeInsetsDirectional.fromSTEB(7, 8, 9, 10),
          ]) {
            await tester.pumpWidget(
              Directionality(
                textDirection: .rtl,
                child: MediaQuery(
                  data: const MediaQueryData(size: Size(800, 600)),
                  child: Align(
                    alignment: .topLeft,
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: MateoView(
                        padding: const EdgeInsets.fromLTRB(31, 32, 33, 34),
                        header: hasHeader
                            ? const MateoViewHeader(padding: EdgeInsets.zero, principal: SizedBox(height: 30))
                            : null,
                        footer: hasFooter
                            ? const MateoViewFooter(padding: EdgeInsets.zero, principal: SizedBox(height: 40))
                            : null,
                        surface: scrollable
                            ? MateoViewSurface.scrollable(
                                color: const Color(0xFF123456),
                                padding: padding,
                                child: const SizedBox(key: content, height: 600),
                              )
                            : MateoViewSurface(
                                color: const Color(0xFF123456),
                                padding: padding,
                                child: const SizedBox(key: content, height: 600),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();
            final explicit = padding?.resolve(TextDirection.rtl);
            final top = (hasHeader ? 30 : 0) + (explicit?.top ?? (hasHeader ? 20 : 32));
            final bottom = (hasFooter ? 40 : 0) + (explicit?.bottom ?? (hasFooter ? 20 : 34));
            expect(tester.getTopLeft(find.byKey(content)), Offset(explicit?.left ?? 31, top.toDouble()));
            expect(tester.getSize(find.byKey(content)).width, 300 - (explicit?.horizontal ?? 64));
            if (scrollable) {
              final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!;
              controller.jumpTo(controller.position.maxScrollExtent);
              await tester.pump();
            }
            expect(tester.getBottomLeft(find.byKey(content)).dy, 300 - bottom);
            await tester.pumpWidget(const SizedBox());
          }
        }
      }
    }
  });

  testWidgets('when explicit surface padding changes during scrolling, it should preserve the controller and offset', (
    tester,
  ) async {
    await tester.pumpWidget(host(scrollable: true, surfacePadding: const .all(8)));
    await tester.pumpAndSettle();
    final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!..jumpTo(100);
    await tester.pumpWidget(host(scrollable: true, surfacePadding: const .all(16)));
    await tester.pumpAndSettle();
    expect(tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller, same(controller));
    expect(controller.offset, 100);
    expect(tester.getTopLeft(find.byKey(content)), const Offset(16, -42));
  });

  testWidgets('when padding is inherited, it should align content and keep the surface full size', (tester) async {
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byKey(header)), const Rect.fromLTWH(20, 12, 260, 30));
    expect(tester.getRect(find.byKey(content)), const Rect.fromLTWH(20, 62, 260, 226));
    expect(tester.getRect(find.byType(MateoViewSurface)), const Rect.fromLTWH(0, 0, 300, 300));
  });

  testWidgets('when padding is explicit, it should replace every inherited edge including the header gap', (
    tester,
  ) async {
    for (final scrollable in [false, true]) {
      await tester.pumpWidget(host(headerPadding: .zero, surfacePadding: .zero, scrollable: scrollable));
      await tester.pumpAndSettle();
      expect(tester.getRect(find.byKey(header)), const Rect.fromLTWH(0, 0, 300, 30));
      expect(tester.getTopLeft(find.byKey(content)), const Offset(0, 30));
      await tester.pumpWidget(
        host(
          headerPadding: const .fromLTRB(3, 5, 7, 9),
          surfacePadding: const .fromLTRB(11, 13, 17, 19),
          scrollable: scrollable,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.getRect(find.byKey(header)), const Rect.fromLTWH(3, 5, 290, 30));
      expect(tester.getTopLeft(find.byKey(content)), const Offset(11, 57));
      expect(tester.getSize(find.byKey(content)).width, 272);
    }
  });

  testWidgets('when view padding is directional, it should resolve edges and reserve bottom padding', (
    tester,
  ) async {
    for (final direction in TextDirection.values) {
      await tester.pumpWidget(
        host(viewPadding: const EdgeInsetsDirectional.fromSTEB(7, 9, 15, 90), direction: direction),
      );
      await tester.pumpAndSettle();
      final left = direction == TextDirection.ltr ? 7.0 : 15.0;
      expect(tester.getRect(find.byKey(header)), Rect.fromLTWH(left, 9, 278, 30));
      expect(tester.getRect(find.byKey(content)), Rect.fromLTWH(left, 59, 278, 151));
    }
    await tester.pumpWidget(host(hasHeader: false, viewPadding: const .all(40)));
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byKey(content)), const Rect.fromLTWH(40, 40, 220, 220));
  });

  testWidgets('when view padding changes, it should refresh inherited spacing without replacing the controller', (
    tester,
  ) async {
    await tester.pumpWidget(host(scrollable: true));
    await tester.pumpAndSettle();
    final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!..jumpTo(100);
    await tester.pumpWidget(host(scrollable: true, viewPadding: const .fromLTRB(8, 16, 24, 80)));
    await tester.pumpAndSettle();
    expect(tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller, same(controller));
    expect(controller.offset, 100);
    expect(tester.getTopLeft(find.byKey(content)), const Offset(8, -34));
    expect(tester.getSize(find.byKey(content)).width, 268);
  });

  testWidgets('when surfaces are nested, it should allocate view padding only to the supplied surface', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: .ltr,
        child: MediaQuery(
          data: MediaQueryData(size: Size(800, 600)),
          child: MateoView(
            header: MateoViewHeader(
              principal: SizedBox(key: header, width: double.infinity, height: 30),
            ),
            surface: MateoViewSurface(
              color: Color(0xFF123456),
              child: MateoSurface(
                color: Color(0xFF123456),
                child: SizedBox(key: content),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byKey(header)), const Offset(20, 12));
    expect(tester.getTopLeft(find.byKey(content)), const Offset(20, 62));
  });
}
