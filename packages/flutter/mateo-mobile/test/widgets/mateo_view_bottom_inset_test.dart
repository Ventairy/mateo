import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_view/base_mateo_view.dart';

const ValueKey<String> _contentKey = ValueKey('content');
const ValueKey<String> _footerKey = ValueKey('footer');
const ValueKey<String> _overlayKey = ValueKey('overlay');

Widget _host({
  double inset = 0,
  double safeBottom = 34,
  bool avoid = true,
  bool footer = true,
  double footerHeight = 40,
  int footerIdentity = 0,
  bool scrollable = false,
  bool offstage = false,
  bool base = false,
}) {
  const content = SizedBox(key: _contentKey, height: 900);
  final surface = scrollable
      ? const MateoViewSurface.scrollable(color: Color(0xFFFFFFFF), padding: .zero, child: content)
      : const MateoViewSurface(color: Color(0xFFFFFFFF), padding: .zero, child: content);
  final footerWidget = footer
      ? MateoViewFooter(
          key: ValueKey(footerIdentity),
          padding: .zero,
          principal: SizedBox(key: _footerKey, height: footerHeight),
        )
      : null;
  return Directionality(
    textDirection: .ltr,
    child: MediaQuery(
      data: MediaQueryData(
        size: const Size(800, 600),
        viewInsets: .only(bottom: inset),
        viewPadding: .only(bottom: safeBottom),
        padding: .only(bottom: (safeBottom - inset).clamp(0, safeBottom)),
      ),
      child: Offstage(
        offstage: offstage,
        child: base
            ? BaseMateoView(fitHeight: false, surface: surface, footer: footerWidget)
            : MateoView(
                avoidBottomInset: avoid,
                surface: surface,
                footer: footerWidget,
                overlay: const SizedBox.expand(key: _overlayKey),
              ),
      ),
    ),
  );
}

void main() {
  testWidgets('when avoidance is disabled, footer and content should retain device spacing across keyboard frames', (
    tester,
  ) async {
    await tester.pumpWidget(_host(avoid: false));
    await tester.pumpAndSettle();
    final footer = tester.getRect(find.byKey(_footerKey));
    final content = tester.getRect(find.byKey(_contentKey));
    for (final inset in [8.0, 20.0, 34.0, 200.0, 335.0, 28.0, 3.0, 0.0]) {
      await tester.pumpWidget(_host(inset: inset, avoid: false));
      expect(tester.getRect(find.byKey(_footerKey)), footer);
      expect(tester.getRect(find.byKey(_contentKey)), content);
      await tester.pumpAndSettle();
      expect(tester.getRect(find.byKey(_footerKey)), footer);
      expect(tester.getRect(find.byKey(_contentKey)), content);
      for (final key in [_footerKey, _contentKey, _overlayKey]) {
        final context = tester.element(find.byKey(key));
        expect(MediaQuery.viewInsetsOf(context).bottom, inset);
        expect(MediaQuery.paddingOf(context).bottom, (34 - inset).clamp(0, 34));
      }
    }
    await tester.pumpWidget(_host(inset: 335, safeBottom: 48, avoid: false));
    await tester.pumpAndSettle();
    expect(tester.getBottomLeft(find.byKey(_footerKey)).dy, 552);
    await tester.pumpWidget(_host(inset: 335, avoid: true));
    await tester.pumpAndSettle();
    expect(tester.getBottomLeft(find.byKey(_footerKey)).dy, 265);
    await tester.pumpWidget(_host(inset: 335, avoid: false));
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byKey(_footerKey)), footer);
  });

  testWidgets('when avoiding a bottom inset, it should reserve content and move only the footer', (tester) async {
    for (final inset in [0.0, 8.0, 34.0, 180.0, 250.0, 20.0, 0.0]) {
      await tester.pumpWidget(_host(inset: inset));
      await tester.pumpAndSettle();
      final remainingSafeArea = (34 - inset).clamp(0, 34);
      final bottom = 600 - (inset < remainingSafeArea ? remainingSafeArea : inset);
      expect(tester.getBottomLeft(find.byKey(_footerKey)).dy, bottom);
      expect(tester.getBottomLeft(find.byKey(_contentKey)).dy, bottom - 40);
      expect(tester.getSize(find.byType(MateoViewSurface)), const Size(800, 600));
      expect(tester.getSize(find.byKey(_overlayKey)), const Size(800, 600));
      expect(MediaQuery.viewInsetsOf(tester.element(find.byKey(_contentKey))).bottom, inset);
      expect(tester.binding.hasScheduledFrame, isFalse);
    }
  });

  testWidgets('when no footer exists, it should reserve the inset and allow opting out', (tester) async {
    for (final avoid in [true, false, true]) {
      await tester.pumpWidget(_host(inset: 200, footer: false, avoid: avoid));
      await tester.pump();
      expect(tester.getSize(find.byKey(_contentKey)).height, avoid ? 400 : 600);
    }
  });

  testWidgets('when footer and inset change together, it should discard removed and replaced geometry', (tester) async {
    await tester.pumpWidget(_host(inset: 200));
    await tester.pumpAndSettle();
    await tester.pumpWidget(_host(inset: 260, footerHeight: 70, footerIdentity: 1));
    await tester.pump();
    expect(tester.getBottomLeft(find.byKey(_footerKey)).dy, 340);
    expect(tester.getBottomLeft(find.byKey(_contentKey)).dy, 270);
    await tester.pumpWidget(_host(inset: 180, footer: false));
    await tester.pumpAndSettle();
    expect(tester.getBottomLeft(find.byKey(_contentKey)).dy, 420);
    await tester.pumpWidget(_host(inset: 100, footerHeight: 60, footerIdentity: 2, offstage: true));
    await tester.pumpAndSettle();
    await tester.pumpWidget(_host(inset: 100, footerHeight: 60, footerIdentity: 2));
    await tester.pump();
    expect(tester.getBottomLeft(find.byKey(_contentKey)).dy, 440);
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('when scrolling with insets, it should retain its controller and expose the last item', (tester) async {
    ScrollController? previous;
    for (final inset in [0.0, 200.0, 280.0, 0.0]) {
      await tester.pumpWidget(_host(inset: inset, scrollable: true));
      await tester.pumpAndSettle();
      final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!;
      if (previous != null) expect(controller, same(previous));
      previous = controller;
      controller.jumpTo(controller.position.maxScrollExtent);
      await tester.pumpAndSettle();
      expect(tester.getBottomLeft(find.byKey(_contentKey)).dy, tester.getTopLeft(find.byKey(_footerKey)).dy);
      expect(tester.getSize(find.byType(CustomScrollView)), const Size(800, 600));
    }
  });

  testWidgets('when a base omits avoidance, it should preserve existing sheet layout behavior', (tester) async {
    await tester.pumpWidget(_host(inset: 200, base: true, footer: false));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byKey(_contentKey)).height, 600);
  });

  testWidgets('when an inset changes around a focused input, it should retain focus and allow visible scrolling', (
    tester,
  ) async {
    final focus = FocusNode();
    final controller = TextEditingController(text: 'Draft');
    addTearDown(focus.dispose);
    addTearDown(controller.dispose);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 600);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpWidget(
      MateoApp(
        theme: MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white),
        home: MateoView(
          footer: const MateoViewFooter(principal: SizedBox(key: _footerKey, height: 40)),
          surface: MateoViewSurface.scrollable(
            child: Column(
              children: [
                const SizedBox(height: 700),
                MateoTextInput(
                  placeholder: 'Message',
                  presentation: const .search(variant: .filled),
                  controller: controller,
                  focusNode: focus,
                  autofocus: false,
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(MateoTextInput));
    focus.requestFocus();
    await tester.pumpAndSettle();
    final scrollController = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!;
    for (final inset in [200.0, 260.0, 0.0]) {
      tester.view.viewInsets = FakeViewPadding(bottom: inset);
      await tester.pumpAndSettle();
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      await tester.pumpAndSettle();
      expect(focus.hasFocus, isTrue);
      expect(controller.text, 'Draft');
      expect(tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller, same(scrollController));
      expect(
        tester.getBottomLeft(find.byType(MateoTextInput)).dy,
        lessThanOrEqualTo(tester.getTopLeft(find.byKey(_footerKey)).dy),
      );
    }
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('when media data is absent, the default view should still fill its bounds', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: .ltr,
        child: MateoView(
          surface: MateoViewSurface(color: Color(0xFFFFFFFF), child: SizedBox()),
        ),
      ),
    );
    expect(tester.widget<MateoView>(find.byType(MateoView)).avoidBottomInset, isTrue);
    expect(tester.getSize(find.byType(MateoViewSurface)), const Size(800, 600));
  });
}
