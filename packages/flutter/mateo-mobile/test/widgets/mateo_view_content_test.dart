import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/content_paint_counter.dart';

void main() {
  const color = Color(0xFF123456);
  const headerKey = ValueKey('header');
  const contentKey = ValueKey('content');
  Widget host(Widget child, {double top = 0, double safeTop = 24}) => Directionality(
    textDirection: .ltr,
    child: MediaQuery(
      data: MediaQueryData(
        size: const Size(800, 600),
        padding: .only(top: safeTop),
      ),
      child: Stack(
        children: [Positioned(left: 0, top: top, width: 300, height: 300, child: child)],
      ),
    ),
  );
  Widget view({bool scrollable = false, double headerHeight = 30, double padding = 10}) {
    const child = Column(
      crossAxisAlignment: .stretch,
      children: [SizedBox(key: contentKey, height: 600)],
    );
    return MateoView(
      header: MateoViewHeader(
        key: headerKey,
        principal: SizedBox(width: 100, height: headerHeight),
      ),
      surface: scrollable
          ? MateoViewSurface.scrollable(color: color, padding: .all(padding), child: child)
          : MateoViewSurface(
              color: color,
              padding: .all(padding),
              child: const Align(
                alignment: .topLeft,
                child: SizedBox(key: contentKey, width: 60, height: 40),
              ),
            ),
    );
  }

  testWidgets('when a retained view moves, it should repaint content on the requested next frame and settle', (
    tester,
  ) async {
    final counter = ContentPaintCounter();
    final child = RepaintBoundary(
      child: MateoView(
        header: const MateoViewHeader(principal: SizedBox(height: 30)),
        surface: MateoViewSurface(
          color: color,
          child: CustomPaint(painter: counter),
        ),
      ),
    );
    await tester.pumpWidget(host(Transform.translate(offset: const Offset(0, 100), child: child)));
    await tester.pumpAndSettle();
    final before = counter.paints;
    await tester.pumpWidget(host(Transform.translate(offset: Offset.zero, child: child)));
    final during = counter.paints;
    final requested = tester.binding.hasScheduledFrame;
    await tester.pump();
    final after = counter.paints;
    await tester.pumpAndSettle();
    expect((during == before, requested, after > during, tester.binding.hasScheduledFrame), (true, true, true, false));
  });

  testWidgets('when initially mounted, it should clear the corrected header on the first frame', (tester) async {
    for (final scrollable in [false, true]) {
      for (final top in [0.0, 60.0]) {
        await tester.pumpWidget(const SizedBox());
        await tester.pumpWidget(host(view(scrollable: scrollable), top: top));
        final expected =
            tester.getBottomLeft(find.descendant(of: find.byKey(headerKey), matching: find.byType(Padding)).first).dy +
            30;
        expect(tester.getTopLeft(find.byKey(contentKey)).dy, expected);
        await tester.pumpAndSettle();
        expect(tester.getTopLeft(find.byKey(contentKey)).dy, expected);
        expect(tester.getRect(find.byType(MateoViewSurface)), Rect.fromLTWH(0, top, 300, 300));
      }
    }
  });

  testWidgets('when scrolled, it should carry clearance behind the fixed header', (tester) async {
    await tester.pumpWidget(host(view(scrollable: true)));
    await tester.pumpAndSettle();
    final headerBottom = tester
        .getBottomLeft(find.descendant(of: find.byKey(headerKey), matching: find.byType(Padding)).first)
        .dy;
    final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!..jumpTo(120);
    await tester.pump();
    expect(tester.getTopLeft(find.byKey(contentKey)).dy, headerBottom + 30 - 120);
    expect(
      tester.getBottomLeft(find.descendant(of: find.byKey(headerKey), matching: find.byType(Padding)).first).dy,
      headerBottom,
    );
    await tester.pumpWidget(host(view(scrollable: true, headerHeight: 60), safeTop: 40));
    await tester.pumpAndSettle();
    expect(tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller, same(controller));
    expect(controller.offset, 120);
    expect(
      tester.getTopLeft(find.byKey(contentKey)).dy,
      tester.getBottomLeft(find.descendant(of: find.byKey(headerKey), matching: find.byType(Padding)).first).dy +
          30 -
          120,
    );
  });

  testWidgets('when nested surfaces occur, it should apply the view clearance only once', (tester) async {
    await tester.pumpWidget(
      host(
        const MateoView(
          header: MateoViewHeader(key: headerKey, principal: SizedBox(height: 30)),
          surface: MateoViewSurface(
            color: color,
            child: MateoSurface(
              color: color,
              child: Align(
                alignment: .topLeft,
                child: SizedBox(key: contentKey, width: 40, height: 40),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.byKey(contentKey)).dy,
      tester.getBottomLeft(find.descendant(of: find.byKey(headerKey), matching: find.byType(Padding)).first).dy + 20,
    );
  });

  testWidgets('when short content fills the surface, it should retain flexible space after header clearance', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        const MateoView(
          header: MateoViewHeader(key: headerKey, principal: SizedBox(height: 30)),
          surface: MateoViewSurface.scrollable(
            color: color,
            padding: .all(10),
            child: Column(
              children: [
                SizedBox(key: contentKey, height: 20),
                Spacer(),
                SizedBox(key: ValueKey('bottom'), height: 20),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.byKey(contentKey)).dy,
      tester.getBottomLeft(find.descendant(of: find.byKey(headerKey), matching: find.byType(Padding)).first).dy + 30,
    );
    expect(tester.getBottomLeft(find.byKey(const ValueKey('bottom'))).dy, 278);
    expect(tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!.position.maxScrollExtent, 0);
  });

  testWidgets('when ordinary content paints upward, it should have no clip at the header boundary', (tester) async {
    await tester.pumpWidget(
      host(
        MateoView(
          header: const MateoViewHeader(key: headerKey, principal: SizedBox(height: 30)),
          surface: MateoViewSurface(
            color: color,
            child: Align(
              alignment: .topLeft,
              child: Transform.translate(
                offset: const Offset(0, -30),
                child: const SizedBox(key: contentKey, width: 40, height: 40),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.byKey(contentKey)).dy,
      tester.getBottomLeft(find.descendant(of: find.byKey(headerKey), matching: find.byType(Padding)).first).dy +
          20 -
          30,
    );
    expect(find.ancestor(of: find.byKey(contentKey), matching: find.byType(ClipRRect)), findsOneWidget);
    expect(find.ancestor(of: find.byKey(contentKey), matching: find.byType(ClipRect)), findsNothing);
  });

  testWidgets('when the header is removed, it should restore view padding without replacing the scroll controller', (
    tester,
  ) async {
    await tester.pumpWidget(host(view(scrollable: true)));
    await tester.pumpAndSettle();
    final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!;
    await tester.pumpWidget(
      host(
        const MateoView(
          surface: MateoViewSurface.scrollable(
            color: color,
            child: SizedBox(key: contentKey, height: 600),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller, same(controller));
    expect(tester.getTopLeft(find.byKey(contentKey)).dy, 12);
  });
}
