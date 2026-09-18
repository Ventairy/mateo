import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/surface_transform_test_widgets.dart';

void main() {
  late BuildContext launcher;
  late GlobalKey<NavigatorState> navigator;
  late ValueNotifier<MediaQueryData> media;

  Future<void> host(WidgetTester tester, {double safeBottom = 34, bool reducedMotion = false}) async {
    navigator = .new();
    media = ValueNotifier(
      MediaQueryData(
        size: const Size(800, 600),
        padding: .only(top: 24, bottom: safeBottom),
        viewPadding: .only(top: 24, bottom: safeBottom),
        disableAnimations: reducedMotion,
      ),
    );
    addTearDown(media.dispose);
    await tester.pumpWidget(
      MateoApp(
        navigatorKey: navigator,
        theme: surfaceTransformTheme,
        builder: (_, child) => ValueListenableBuilder(
          valueListenable: media,
          child: child,
          builder: (_, value, child) => MediaQuery(data: value, child: child!),
        ),
        home: Builder(
          builder: (context) {
            launcher = context;
            return const SizedBox.expand();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  void setInset(double inset) => media.value = media.value.copyWith(
    viewInsets: .only(bottom: inset),
    padding: media.value.padding.copyWith(bottom: math.max(0, media.value.viewPadding.bottom - inset)),
  );

  Finder sheet(int index) => find.byKey(ValueKey('sheet-$index'));

  Rect paintedBounds(WidgetTester tester, int index) {
    final frame = find.descendant(
      of: sheet(index),
      matching: find.byWidgetPredicate((widget) => widget.runtimeType.toString() == '_MateoSheetFrame'),
    );
    final render = tester.renderObject<RenderProxyBox>(frame.first);
    return (render.describeApproximatePaintClip(render.child!) ?? Offset.zero & render.size).shift(
      render.localToGlobal(.zero),
    );
  }

  Future<void> push(
    WidgetTester tester, {
    int index = 0,
    bool? avoid,
    bool scrollable = false,
    bool fixedSlots = false,
    double? maxExtent,
  }) async {
    final content = SizedBox(key: ValueKey('content-$index'), height: scrollable ? 1600 : 80);
    final view = MateoSheetView(
      key: ValueKey('sheet-$index'),
      header: fixedSlots ? const MateoSheetViewHeader(presentation: .handle()) : null,
      footer: fixedSlots ? MateoSheetViewFooter(principal: SizedBox(key: ValueKey('footer-$index'), height: 40)) : null,
      surface: scrollable ? MateoSheetViewSurface.scrollable(child: content) : MateoSheetViewSurface(child: content),
    );
    unawaited(
      avoid == null
          ? showMateoSheet<void>(context: launcher, view: view, maxExtent: maxExtent)
          : showMateoSheet<void>(context: launcher, view: view, maxExtent: maxExtent, avoidBottomInset: avoid),
    );
    await tester.pumpAndSettle();
  }

  for (final avoid in <bool?>[null, false]) {
    for (final scrollable in [false, true]) {
      testWidgets('avoidance $avoid keeps scrollable=$scrollable stable during an older keyboard dismissal', (
        tester,
      ) async {
        await host(tester);
        setInset(280);
        await tester.pump();
        await push(tester, avoid: avoid, scrollable: scrollable, fixedSlots: true);
        final resting = tester.getRect(sheet(0));
        final footer = tester.getRect(find.byKey(const ValueKey('footer-0')));
        expect(resting.bottom, 600 - 34 - 12);
        for (final inset in [200.0, 34.0, 20.0, 0.0, 8.0, 300.0, 0.0]) {
          setInset(inset);
          await tester.pump();
          expect(tester.getRect(sheet(0)), resting);
          expect(tester.getRect(find.byKey(const ValueKey('footer-0'))), footer);
          expect(MediaQuery.viewInsetsOf(tester.element(sheet(0))).bottom, inset);
        }
        expect(tester.takeException(), isNull);
      });
    }
  }

  for (final safeBottom in [0.0, 34.0]) {
    testWidgets('avoiding fitted sheets follows live insets with safe area $safeBottom', (tester) async {
      await host(tester, safeBottom: safeBottom);
      await push(tester, avoid: true, fixedSlots: true);
      final height = tester.getSize(sheet(0)).height;
      for (final inset in [8.0, 20.0, 34.0, 200.0, 280.0, 0.0]) {
        setInset(inset);
        await tester.pump();
        final bounds = tester.getRect(sheet(0));
        expect(bounds.bottom, 600 - math.max(safeBottom, inset) - 12);
        expect(bounds.height, height);
        expect(tester.getRect(find.byKey(const ValueKey('footer-0'))).bottom, lessThan(bounds.bottom));
        expect(MediaQuery.viewInsetsOf(tester.element(sheet(0))).bottom, 0);
        expect(MediaQuery.viewPaddingOf(tester.element(sheet(0))).bottom, 0);
      }
      expect(tester.takeException(), isNull);
    });
  }

  for (final maxExtent in <double?>[null, 240]) {
    testWidgets('avoiding scrollable sheets honor remaining height and maxExtent $maxExtent', (tester) async {
      await host(tester);
      await push(tester, avoid: true, scrollable: true, fixedSlots: true, maxExtent: maxExtent);
      for (final inset in [0.0, 200.0, 320.0, 0.0]) {
        setInset(inset);
        await tester.pumpAndSettle();
        final bounds = tester.getRect(sheet(0));
        expect(bounds.bottom, 600 - math.max(34, inset) - 12);
        expect(
          bounds.height,
          math.min(
            math.min(maxExtent ?? double.infinity, (600 - inset) * .9),
            600 - math.max(34, inset) - 24 - 24,
          ),
        );
        final scroll = find.descendant(of: sheet(0), matching: find.byType(Scrollable)).first;
        final position = tester.state<ScrollableState>(scroll).position;
        position.jumpTo(position.maxScrollExtent);
        await tester.pumpAndSettle();
        final content = tester.getRect(find.byKey(const ValueKey('content-0')));
        final footer = tester.getRect(find.byKey(const ValueKey('footer-0')));
        expect(content.bottom, lessThanOrEqualTo(footer.top));
        expect(position.pixels, position.maxScrollExtent);
      }
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('avoiding sheets clamp their viewport when the keyboard fills the screen', (tester) async {
    await host(tester);
    await push(tester, avoid: true, scrollable: true);
    for (final inset in [500.0, 575.0, 600.0, 650.0, 0.0]) {
      setInset(inset);
      await tester.pumpAndSettle();
      expect(tester.getSize(sheet(0)).height, greaterThanOrEqualTo(0));
      expect(tester.takeException(), isNull);
    }
  });

  for (final reducedMotion in [false, true]) {
    for (final backAvoids in [false, true]) {
      for (final frontAvoids in [false, true]) {
        testWidgets('stack $backAvoids/$frontAvoids aligns and restores with reduced motion $reducedMotion', (
          tester,
        ) async {
          await host(tester, reducedMotion: reducedMotion);
          await push(tester, avoid: backAvoids);
          await push(tester, index: 1, avoid: frontAvoids);
          for (final inset in [200.0, 280.0, 20.0, 0.0, 200.0]) {
            setInset(inset);
            await tester.pumpAndSettle();
            final back = paintedBounds(tester, 0);
            final front = paintedBounds(tester, 1);
            expect(back.top, closeTo(front.top - 12, .001));
            expect(back.bottom, closeTo(front.bottom, .001));
            expect(back.width, front.width - 32);
          }
          await tester.drag(sheet(1), const Offset(0, 120));
          await tester.pumpAndSettle();
          expect(sheet(1), findsNothing);
          expect(paintedBounds(tester, 0), tester.getRect(sheet(0)));
          expect(paintedBounds(tester, 0).bottom, 600 - (backAvoids ? 200 : 34) - 12);
          await push(tester, index: 1, avoid: frontAvoids);
          navigator.currentState!.pop();
          await tester.pump();
          setInset(0);
          await tester.pumpAndSettle();
          expect(paintedBounds(tester, 0), tester.getRect(sheet(0)));
          expect(paintedBounds(tester, 0).bottom, 600 - 34 - 12);
          expect(tester.takeException(), isNull);
        });
      }
    }
  }
}
