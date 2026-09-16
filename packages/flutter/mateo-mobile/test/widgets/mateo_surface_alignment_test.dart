import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  const headerKey = ValueKey('header');
  const contentKey = ValueKey('content');
  Widget host({
    AlignmentGeometry? alignment = Alignment.center,
    bool scrollable = false,
    bool header = true,
    double safeTop = 24,
    double headerHeight = 30,
    double top = 0,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
    TextDirection direction = TextDirection.ltr,
    Widget child = const SizedBox(key: contentKey, width: 40, height: 40),
  }) {
    final surface = scrollable
        ? MateoViewSurface.scrollable(
            color: const Color(0xFF123456),
            alignment: alignment,
            padding: padding,
            child: child,
          )
        : MateoViewSurface(color: const Color(0xFF123456), alignment: alignment, padding: padding, child: child);
    return Directionality(
      textDirection: direction,
      child: MediaQuery(
        data: MediaQueryData(
          size: const Size(800, 600),
          padding: .only(top: safeTop),
        ),
        child: Stack(
          children: [
            Positioned(
              top: top,
              left: 0,
              width: 300,
              height: 300,
              child: MateoView(
                header: header
                    ? MateoViewHeader(
                        key: headerKey,
                        principal: SizedBox(height: headerHeight),
                      )
                    : null,
                surface: surface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  testWidgets('when aligned content is clear, it should retain its full-surface position on the first frame', (
    tester,
  ) async {
    for (final scrollable in [false, true]) {
      for (final y in [0.0, -0.2, 0.2]) {
        await tester.pumpWidget(host(alignment: Alignment(0, y), scrollable: scrollable));
        final expected = Offset(130, 130 * (y + 1));
        expect(tester.getTopLeft(find.byKey(contentKey)), expected);
        await tester.pumpAndSettle();
        expect(tester.getTopLeft(find.byKey(contentKey)), expected);
        if (scrollable) {
          expect(
            tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!.position.maxScrollExtent,
            0,
          );
        }
      }
    }
  });

  testWidgets('when aligned content overlaps, it should add only enough clearance after padding', (tester) async {
    for (final scrollable in [false, true]) {
      for (final alignment in [Alignment.topCenter, const Alignment(0, -0.8)]) {
        await tester.pumpWidget(
          host(alignment: alignment, scrollable: scrollable, padding: const .fromLTRB(10, 12, 30, 20)),
        );
        final expected =
            tester.getBottomLeft(find.descendant(of: find.byKey(headerKey), matching: find.byType(Padding)).first).dy +
            12;
        expect(tester.getTopLeft(find.byKey(contentKey)).dy, expected);
        expect(tester.getTopLeft(find.byKey(contentKey)).dx, 120);
        await tester.pumpAndSettle();
        expect(tester.getTopLeft(find.byKey(contentKey)).dy, expected);
      }
    }
  });

  testWidgets('when padding and direction differ, it should resolve alignment within the padded surface', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        alignment: AlignmentDirectional.centerStart,
        direction: .rtl,
        padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 40, 30),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byKey(contentKey)), const Offset(240, 120));
  });

  testWidgets('when ordinary content is large, it should fit the remaining height', (tester) async {
    await tester.pumpWidget(
      host(
        padding: const .all(10),
        child: const SizedBox(key: contentKey, width: 40, height: 1000),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.byKey(contentKey)).dy,
      tester.getBottomLeft(find.descendant(of: find.byKey(headerKey), matching: find.byType(Padding)).first).dy + 10,
    );
    expect(tester.getBottomLeft(find.byKey(contentKey)).dy, 290);
  });

  testWidgets('when tall aligned content scrolls, it should pass behind the header and retain bottom reachability', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        scrollable: true,
        padding: const .all(10),
        child: const SizedBox(key: contentKey, width: 100, height: 600),
      ),
    );
    await tester.pumpAndSettle();
    final initialTop = tester.getTopLeft(find.byKey(contentKey)).dy;
    final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!..jumpTo(120);
    await tester.pump();
    expect(tester.getTopLeft(find.byKey(contentKey)).dy, initialTop - 120);
    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pump();
    expect(tester.getBottomLeft(find.byKey(contentKey)).dy, 290);
  });

  testWidgets('when header geometry changes, it should preserve scrolling and apply the new initial clearance', (
    tester,
  ) async {
    const child = SizedBox(key: contentKey, width: 100, height: 600);
    await tester.pumpWidget(host(scrollable: true, child: child));
    await tester.pumpAndSettle();
    final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!..jumpTo(120);
    await tester.pumpWidget(host(scrollable: true, safeTop: 40, headerHeight: 60, child: child));
    await tester.pumpAndSettle();
    expect(tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller, same(controller));
    expect(controller.offset, 120);
    expect(
      tester.getTopLeft(find.byKey(contentKey)).dy,
      tester.getBottomLeft(find.descendant(of: find.byKey(headerKey), matching: find.byType(Padding)).first).dy - 120,
    );
  });

  testWidgets('when the header is absent or a sheet is inset, it should use only the relevant clearance', (
    tester,
  ) async {
    await tester.pumpWidget(host(header: false, alignment: .topCenter));
    expect(tester.getTopLeft(find.byKey(contentKey)), const Offset(130, 0));
    await tester.pumpWidget(host(top: 100, alignment: .topCenter));
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.byKey(contentKey)).dy,
      tester.getBottomLeft(find.descendant(of: find.byKey(headerKey), matching: find.byType(Padding)).first).dy,
    );
  });

  testWidgets('when aligned content is interactive, it should paint and expose semantics at the same position', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();

    try {
      var tapped = false;
      await tester.pumpWidget(
        host(
          alignment: const Alignment(0, -0.8),
          child: Semantics(
            label: 'Aligned action',
            button: true,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => tapped = true,
              child: const SizedBox(key: contentKey, width: 40, height: 40),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tapAt(tester.getCenter(find.byKey(contentKey)));
      expect(tapped, isTrue);
      final node = tester.getSemantics(find.bySemanticsLabel('Aligned action'));
      var transform = Matrix4.identity();
      SemanticsNode? current = node;
      while (current != null) {
        if (current.transform != null) transform = current.transform!.clone()..multiply(transform);
        current = current.parent;
      }
      // Root semantics use physical pixels, while widget geometry uses logical pixels.
      final pixelRatio = tester.view.devicePixelRatio;
      expect(
        MatrixUtils.transformRect(transform, node.rect),
        MatrixUtils.transformRect(
          Matrix4.diagonal3Values(pixelRatio, pixelRatio, 1),
          tester.getRect(find.byKey(contentKey)),
        ),
      );
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('when an aligned surface has no view, it should align normally and support dry layout', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: .ltr,
        child: Center(
          child: MateoSurface(
            color: Color(0xFF123456),
            width: .custom(300),
            height: .custom(300),
            alignment: .center,
            child: SizedBox(key: contentKey, width: 40, height: 40),
          ),
        ),
      ),
    );
    expect(tester.getCenter(find.byKey(contentKey)), tester.getCenter(find.byType(MateoSurface)));
    final box = tester.renderObject<RenderBox>(find.byType(MateoSurface));
    expect(box.getDryLayout(const BoxConstraints.tightFor(width: 300, height: 300)), const Size(300, 300));
  });
  testWidgets('when aligned axes are unbounded, it should size around the padded child', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: .ltr,
        child: UnconstrainedBox(
          child: MateoSurface(
            color: Color(0xFF123456),
            alignment: .center,
            padding: .fromLTRB(10, 20, 30, 40),
            child: SizedBox(key: contentKey, width: 40, height: 40),
          ),
        ),
      ),
    );
    expect(tester.getSize(find.byType(MateoSurface)), const Size(80, 100));
    expect(
      tester.getTopLeft(find.byKey(contentKey)) - tester.getTopLeft(find.byType(MateoSurface)),
      const Offset(10, 20),
    );
  });
}
