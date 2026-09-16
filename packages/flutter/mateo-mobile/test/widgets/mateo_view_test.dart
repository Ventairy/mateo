import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  const color = Color(0xFF123456);
  Widget host(Widget child) => Directionality(
    textDirection: .ltr,
    child: Center(child: SizedBox(width: 240, height: 320, child: child)),
  );

  testWidgets('when hosting either surface, it should fill the bounds using the supplied instance', (tester) async {
    for (final surface in [
      const MateoViewSurface(color: color, child: SizedBox()),
      const MateoViewSurface.scrollable(color: color, child: SizedBox(height: 600)),
    ]) {
      await tester.pumpWidget(host(MateoView(surface: surface)));
      expect(tester.widget<MateoViewSurface>(find.byType(MateoViewSurface)), same(surface));
      expect(tester.getSize(find.byType(MateoViewSurface)), const Size(240, 320));
      expect(find.byType(ColoredBox), findsOneWidget);
      expect(tester.widget<ColoredBox>(find.byType(ColoredBox)).color, color);
      expect(find.byType(ClipRRect), findsOneWidget);
    }
  });

  testWidgets('when the view rebuilds, it should preserve the surface scroll controller and offset', (tester) async {
    Widget view(Color background) => host(
      MateoView(
        surface: MateoViewSurface.scrollable(color: background, child: const SizedBox(height: 900)),
      ),
    );
    await tester.pumpWidget(view(color));
    final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!;
    await tester.drag(find.byType(MateoView), const Offset(0, -150));
    await tester.pumpAndSettle();
    final offset = controller.offset;
    expect(offset, greaterThan(0));
    await tester.pumpWidget(view(const Color(0xFF654321)));
    expect(tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller, same(controller));
    expect(controller.offset, offset);
  });

  testWidgets('when media insets and semantics exist, it should preserve them for the content', (tester) async {
    const media = MediaQueryData(padding: .only(top: 24, bottom: 16), viewInsets: .only(bottom: 180));
    final semantics = tester.ensureSemantics();
    MediaQueryData? received;
    await tester.pumpWidget(
      host(
        MediaQuery(
          data: media,
          child: MateoView(
            surface: MateoViewSurface(
              color: color,
              child: Builder(
                builder: (context) {
                  received = MediaQuery.of(context);
                  return Semantics(label: 'Content', button: true, onTap: () {}, child: const SizedBox());
                },
              ),
            ),
          ),
        ),
      ),
    );
    expect(received, media);
    expect(tester.getSize(find.byType(MateoViewSurface)), const Size(240, 320));
    expect(
      tester.getSemantics(find.bySemanticsLabel('Content')),
      matchesSemantics(label: 'Content', isButton: true, hasTapAction: true),
    );
    semantics.dispose();
  });
  testWidgets('when overlay has media insets, it should fill the view and isolate primary scrolling', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    const overlayKey = ValueKey('overlay');
    await tester.pumpWidget(
      host(
        PrimaryScrollController(
          controller: controller,
          child: MediaQuery(
            data: const MediaQueryData(padding: .all(24), viewInsets: .only(bottom: 180)),
            child: MateoView(
              padding: const .all(30),
              surface: const MateoViewSurface(color: color, child: SizedBox()),
              overlay: Builder(
                builder: (context) {
                  expect(PrimaryScrollController.maybeOf(context), isNull);
                  expect(MediaQuery.paddingOf(context), const EdgeInsets.all(24));
                  expect(MediaQuery.viewInsetsOf(context).bottom, 180);
                  return const SizedBox(key: overlayKey);
                },
              ),
            ),
          ),
        ),
      ),
    );
    expect(tester.getRect(find.byKey(overlayKey)), tester.getRect(find.byType(MateoView)));
  });

  testWidgets('when overlay changes during scrolling, it should stay fixed and preserve surface state', (tester) async {
    const overlayKey = ValueKey('overlay');
    Widget view({required bool overlay}) => host(
      MateoView(
        surface: const MateoViewSurface.scrollable(color: color, child: SizedBox(height: 900)),
        overlay: overlay ? const IgnorePointer(child: SizedBox(key: overlayKey)) : null,
      ),
    );
    await tester.pumpWidget(view(overlay: false));
    final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!;
    await tester.drag(find.byType(MateoView), const Offset(0, -100));
    await tester.pumpAndSettle();
    final offset = controller.offset;
    await tester.pumpWidget(view(overlay: true));
    expect(controller.offset, offset);
    final bounds = tester.getRect(find.byKey(overlayKey));
    await tester.drag(find.byType(MateoView), const Offset(0, -100));
    await tester.pumpAndSettle();
    expect(controller.offset, greaterThan(offset));
    expect(tester.getRect(find.byKey(overlayKey)), bounds);
    final finalOffset = controller.offset;
    await tester.pumpWidget(view(overlay: false));
    expect(tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller, same(controller));
    expect(controller.offset, finalOffset);
  });

  testWidgets('when overlay receives or ignores taps, it should respect caller hit testing above every slot', (
    tester,
  ) async {
    var overlayTaps = 0;
    var underlyingTaps = 0;
    Widget target(String key) => GestureDetector(
      key: ValueKey(key),
      behavior: .opaque,
      onTap: () => underlyingTaps++,
      child: const SizedBox(width: 100, height: 40),
    );
    Widget view({required bool ignoring}) => host(
      MateoView(
        surface: MateoViewSurface(
          color: color,
          child: Center(child: target('body')),
        ),
        header: MateoViewHeader(principal: target('header')),
        footer: MateoViewFooter(principal: target('footer')),
        overlay: IgnorePointer(
          ignoring: ignoring,
          child: GestureDetector(behavior: .opaque, onTap: () => overlayTaps++, child: const SizedBox.expand()),
        ),
      ),
    );
    await tester.pumpWidget(view(ignoring: false));
    for (final key in ['body', 'header', 'footer']) {
      await tester.tapAt(tester.getCenter(find.byKey(ValueKey(key))));
    }
    expect(overlayTaps, 3);
    expect(underlyingTaps, 0);
    await tester.pumpWidget(view(ignoring: true));
    for (final key in ['body', 'header', 'footer']) {
      await tester.tap(find.byKey(ValueKey(key)));
    }
    expect(overlayTaps, 3);
    expect(underlyingTaps, 3);
  });
}
