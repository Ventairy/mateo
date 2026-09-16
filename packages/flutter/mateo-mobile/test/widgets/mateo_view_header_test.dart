import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

void main() {
  const color = Color(0xFF123456);
  Widget host(Widget child, {EdgeInsets padding = EdgeInsets.zero, Offset origin = Offset.zero}) => Directionality(
    textDirection: .ltr,
    child: MediaQuery(
      data: MediaQueryData(size: const Size(800, 600), padding: padding),
      child: Stack(
        children: [Positioned(left: origin.dx, top: origin.dy, width: 300, height: 300, child: child)],
      ),
    ),
  );
  const principal = SizedBox(key: ValueKey('principal'), width: 80, height: 30);
  const view = MateoView(
    header: MateoViewHeader(principal: principal),
    surface: MateoViewSurface.scrollable(color: color, child: SizedBox(height: 900)),
  );

  testWidgets('when near unsafe edges, it should correct the header without insetting the surface', (tester) async {
    for (final padding in [const EdgeInsets.only(top: 24, left: 18), const EdgeInsets.only(top: 40, left: 26)]) {
      await tester.pumpWidget(host(view, padding: padding));
      await tester.pumpAndSettle();
      expect(tester.getRect(find.byType(MateoViewSurface)), const Rect.fromLTWH(0, 0, 300, 300));
      expect(tester.getTopLeft(find.byKey(const ValueKey('principal'))), Offset(110 + padding.left, 12 + padding.top));
      final safe = tester.widget<MaybeSafeArea>(find.byType(MaybeSafeArea));
      expect(safe.bottom, isFalse);
    }
  });

  testWidgets('when reaching the right unsafe edge, it should move the header inward', (tester) async {
    await tester.pumpWidget(host(view, padding: const EdgeInsets.only(right: 20), origin: const Offset(500, 60)));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byKey(const ValueKey('principal'))), const Offset(590, 72));
    expect(tester.getRect(find.byType(MateoViewSurface)), const Rect.fromLTWH(500, 60, 300, 300));
  });

  testWidgets('when already safely positioned, it should leave header spacing unchanged', (tester) async {
    await tester.pumpWidget(
      host(view, padding: const EdgeInsets.only(top: 24, left: 18), origin: const Offset(40, 60)),
    );
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byKey(const ValueKey('principal'))), const Offset(150, 72));
    final before = tester.getTopLeft(find.byKey(const ValueKey('principal')));
    await tester.dragFrom(const Offset(180, 250), const Offset(0, -100));
    await tester.pumpAndSettle();
    expect(tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!.offset, greaterThan(0));
    expect(tester.getTopLeft(find.byKey(const ValueKey('principal'))), before);
  });

  testWidgets('when header controls move, it should preserve their taps and leave the surface interactive', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var headerTaps = 0;
    var bodyTaps = 0;
    await tester.pumpWidget(
      host(
        MateoView(
          header: MateoViewHeader(
            principal: GestureDetector(
              behavior: .opaque,
              onTap: () => headerTaps++,
              child: Semantics(label: 'Header action', button: true, child: principal),
            ),
          ),
          surface: MateoViewSurface(
            color: color,
            child: GestureDetector(behavior: .opaque, onTap: () => bodyTaps++, child: const SizedBox.expand()),
          ),
        ),
        padding: const EdgeInsets.only(top: 24),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(150, 48));
    expect(headerTaps, 1);
    expect(find.bySemanticsLabel('Header action'), findsOneWidget);
    await tester.tapAt(const Offset(150, 180));
    expect(bodyTaps, 1);
    semantics.dispose();
  });
}
