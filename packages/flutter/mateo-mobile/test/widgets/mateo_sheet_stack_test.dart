import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/surface_transform_test_widgets.dart';

void main() {
  late BuildContext launcher;
  late GlobalKey<NavigatorState> navigator;
  Future<void> host(WidgetTester tester, {bool reducedMotion = false}) async {
    navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MateoApp(
        navigatorKey: navigator,
        theme: surfaceTransformTheme,
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: reducedMotion),
          child: Builder(
            builder: (context) {
              launcher = context;
              return const SizedBox.expand();
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder sheet(int index) => find.byKey(ValueKey('sheet-$index'));
  Finder frame(int index) => find.descendant(
    of: sheet(index),
    matching: find.byWidgetPredicate((widget) => widget.runtimeType.toString() == '_MateoSheetFrame'),
  );
  double opacity(WidgetTester tester, int index) =>
      tester.widget<Opacity>(find.descendant(of: sheet(index), matching: find.byType(Opacity)).first).opacity;
  Rect bounds(WidgetTester tester, int index) {
    final render = tester.renderObject<RenderProxyBox>(frame(index).first);
    final clip = render.describeApproximatePaintClip(render.child!) ?? Offset.zero & render.size;
    return clip.shift(render.localToGlobal(Offset.zero));
  }

  Future<void> push(
    WidgetTester tester,
    int index, {
    double height = 160,
    double? maxHeight,
    bool settle = true,
    bool scrollable = false,
  }) async {
    unawaited(
      showMateoSheet<void>(
        context: launcher,
        maxHeight: maxHeight,
        view: MateoSheetView(
          key: ValueKey('sheet-$index'),
          surface: scrollable
              ? MateoSheetViewSurface.scrollable(child: SizedBox(height: 1800, child: Text('Content $index')))
              : MateoSheetViewSurface(
                  child: SizedBox(height: height, child: Text('Content $index')),
                ),
        ),
      ),
    );
    await tester.pump();
    if (settle) await tester.pumpAndSettle();
  }

  testWidgets('when the stack scrim is tapped, it should dismiss only the top sheet and restore the one below', (
    tester,
  ) async {
    await host(tester);
    await push(tester, 0);
    final resting = bounds(tester, 0);
    await push(tester, 1);
    final route = ModalRoute.of(tester.element(sheet(1)))!;
    expect(route.barrierColor, isNull);
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(sheet(1), findsNothing);
    expect(sheet(0), findsOneWidget);
    expect(bounds(tester, 0), resting);
    expect(ModalRoute.of(tester.element(sheet(0)))!.isCurrent, isTrue);
  });

  testWidgets('when a sheet is dismissed, it should finish exiting before the stack finishes restoring', (
    tester,
  ) async {
    await host(tester);
    await push(tester, 0);
    final resting = bounds(tester, 0);
    await push(tester, 1);
    final covered = bounds(tester, 0);
    final route = ModalRoute.of(tester.element(sheet(1)))!;
    expect(route.reverseTransitionDuration, const Duration(milliseconds: 300));

    navigator.currentState!.pop();
    await tester.pump();
    expect(bounds(tester, 0), covered);
    await tester.pump(const Duration(milliseconds: 320));
    await tester.pump();
    expect(sheet(1), findsNothing);
    expect(bounds(tester, 0).width, inExclusiveRange(covered.width, resting.width));
    await tester.pump(const Duration(milliseconds: 120));
    expect(bounds(tester, 0), resting);
    expect(tester.takeException(), isNull);
  });

  testWidgets('when four sheets open and return, it should fade only the oldest layer and retain its content', (
    tester,
  ) async {
    await host(tester);
    await push(tester, 0, height: 300);
    final content = tester.element(find.text('Content 0'));
    await push(tester, 1, height: 220);
    await push(tester, 2);
    expect(opacity(tester, 0), 1);
    expect(bounds(tester, 0).top, closeTo(bounds(tester, 1).top - 12, .01));
    expect(bounds(tester, 1).top, closeTo(bounds(tester, 2).top - 12, .01));
    expect(bounds(tester, 0).width, bounds(tester, 2).width - 64);
    await push(tester, 3, height: 100, settle: false);
    await tester.pump(const Duration(milliseconds: 120));
    expect(opacity(tester, 0), inExclusiveRange(0, 1));
    await tester.pumpAndSettle();
    expect(opacity(tester, 0), 0);
    expect(opacity(tester, 1), 1);
    navigator.currentState!.pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(opacity(tester, 0), inExclusiveRange(0, 1));
    await tester.pumpAndSettle();
    expect(opacity(tester, 0), 1);
    expect(tester.element(find.text('Content 0')), same(content));
    expect(tester.takeException(), isNull);
  });

  testWidgets('when a short sheet covers a scrolling sheet, it should resize only its frame and preserve scrolling', (
    tester,
  ) async {
    await host(tester);
    await push(tester, 0, scrollable: true);
    final scroll = tester.state<ScrollableState>(find.descendant(of: sheet(0), matching: find.byType(Scrollable)));
    scroll.position.jumpTo(100);
    final original = bounds(tester, 0);
    await push(tester, 1, height: 80);
    expect(bounds(tester, 0).height, 132);
    expect(tester.getSize(frame(0)).height, original.height);
    expect(scroll.position.pixels, 100);
    expect(
      tester.widget<IgnorePointer>(find.descendant(of: sheet(0), matching: find.byType(IgnorePointer)).first).ignoring,
      isTrue,
    );
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
    expect(bounds(tester, 0), original);
    expect(scroll.position.pixels, 100);
  });

  testWidgets('when differently capped sheets stack, they should preserve layout and scroll position on return', (
    tester,
  ) async {
    await host(tester);
    await push(tester, 0, scrollable: true, maxHeight: 400);
    final scroll = tester.state<ScrollableState>(find.descendant(of: sheet(0), matching: find.byType(Scrollable)));
    scroll.position.jumpTo(100);
    final original = bounds(tester, 0);
    expect(original.height, 400);
    await push(tester, 1, scrollable: true, maxHeight: 240);
    expect(bounds(tester, 1).height, 240);
    expect(tester.getSize(frame(0)).height, 400);
    expect(scroll.position.pixels, 100);
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
    expect(bounds(tester, 0), original);
    expect(scroll.position.pixels, 100);
    expect(tester.takeException(), isNull);
  });

  testWidgets('when a drag is cancelled or committed, it should continuously restore the covered frame', (
    tester,
  ) async {
    await host(tester);
    await push(tester, 0, height: 300);
    await push(tester, 1);
    final covered = bounds(tester, 0);
    final gesture = await tester.startGesture(tester.getCenter(sheet(1)));
    await gesture.moveBy(const Offset(0, 24));
    await tester.pump();
    final dragged = bounds(tester, 0);
    expect(dragged.width, greaterThan(covered.width));
    await gesture.cancel();
    await tester.pumpAndSettle();
    expect(bounds(tester, 0), covered);
    final dismiss = await tester.startGesture(tester.getCenter(sheet(1)));
    await dismiss.moveBy(const Offset(0, 60));
    await tester.pump();
    final before = bounds(tester, 0);
    await dismiss.up();
    await tester.pump();
    expect(bounds(tester, 0), before);
    await tester.pumpAndSettle();
    expect(sheet(1), findsNothing);
    expect(bounds(tester, 0).height, 340);
  });

  testWidgets('when entry reverses or the navigator is disposed, it should retain continuity and release listeners', (
    tester,
  ) async {
    await host(tester);
    await push(tester, 0);
    await push(tester, 1, settle: false);
    await tester.pump(const Duration(milliseconds: 100));
    final before = bounds(tester, 0);
    navigator.currentState!.pop();
    await tester.pump();
    expect(bounds(tester, 0), before);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('when motion is reduced, it should settle three visible frames without animation', (tester) async {
    await host(tester, reducedMotion: true);
    for (var i = 0; i < 4; i++) {
      await push(tester, i);
    }
    expect(opacity(tester, 0), 0);
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
    expect(opacity(tester, 0), 1);
    expect(tester.takeException(), isNull);
  });
  testWidgets('when another route covers the stack, it should retain frames and suppress covered content', (
    tester,
  ) async {
    await host(tester);
    await push(tester, 0);
    await push(tester, 1);
    final covered = bounds(tester, 0);
    navigator.currentState!.push<void>(
      RawDialogRoute(pageBuilder: (context, animation, secondaryAnimation) => const SizedBox.expand()),
    );
    await tester.pumpAndSettle();
    expect(bounds(tester, 0), covered);
    expect(
      tester
          .widget<ExcludeSemantics>(find.descendant(of: sheet(1), matching: find.byType(ExcludeSemantics)).first)
          .excluding,
      isTrue,
    );
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
    expect(bounds(tester, 0), covered);
    expect(
      tester
          .widget<ExcludeSemantics>(find.descendant(of: sheet(1), matching: find.byType(ExcludeSemantics)).first)
          .excluding,
      isFalse,
    );
  });

  testWidgets('when a middle sheet is removed, it should reconnect the remaining presentations', (tester) async {
    await host(tester);
    await push(tester, 0);
    await push(tester, 1);
    final middle = ModalRoute.of(tester.element(sheet(1)))!;
    await push(tester, 2);
    navigator.currentState!.removeRoute(middle);
    await tester.pumpAndSettle();
    expect(sheet(1), findsNothing);
    expect(bounds(tester, 0).width, bounds(tester, 2).width - 32);
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
    expect(bounds(tester, 0).width, tester.getSize(frame(0)).width);
    expect(tester.takeException(), isNull);
  });

  testWidgets('when a new sheet opens during return, it should keep the new covering relationship', (tester) async {
    await host(tester);
    await push(tester, 0);
    await push(tester, 1);
    navigator.currentState!.pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));
    final returning = bounds(tester, 0);
    await push(tester, 2, settle: false);
    expect(bounds(tester, 0), returning);
    await tester.pumpAndSettle();
    expect(bounds(tester, 0).width, bounds(tester, 2).width - 32);
    expect(
      tester.widget<IgnorePointer>(find.descendant(of: sheet(0), matching: find.byType(IgnorePointer)).first).ignoring,
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('when a sheet moves above stable content, it should not rebuild that content for animation frames', (
    tester,
  ) async {
    await host(tester);
    var builds = 0;
    unawaited(
      showMateoSheet<void>(
        context: launcher,
        view: MateoSheetView(
          surface: MateoSheetViewSurface(
            child: Builder(
              builder: (context) {
                builds++;
                return const SizedBox(height: 300);
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final initialBuilds = builds;
    await push(tester, 1, settle: false);
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 20));
    }
    expect(builds, initialBuilds);
    await tester.pumpAndSettle();
  });
  testWidgets('when sheets open in a nested navigator, it should leave the outer sheet frame unchanged', (
    tester,
  ) async {
    await host(tester);
    late BuildContext nested;
    unawaited(
      showMateoSheet<void>(
        context: launcher,
        view: MateoSheetView(
          key: const ValueKey('sheet-0'),
          surface: MateoSheetViewSurface(
            child: SizedBox(
              height: 300,
              child: Navigator(
                onGenerateRoute: (_) => PageRouteBuilder<void>(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    nested = context;
                    return const SizedBox.expand();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final outer = bounds(tester, 0);
    for (var index = 1; index <= 2; index++) {
      unawaited(
        showMateoSheet<void>(
          context: nested,
          view: MateoSheetView(
            key: ValueKey('sheet-$index'),
            surface: const MateoSheetViewSurface(child: SizedBox(height: 80)),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }
    expect(bounds(tester, 0), outer);
    expect(bounds(tester, 1).width, bounds(tester, 2).width - 32);
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'when sheets are swiped in quick succession, it should accept each swipe before the previous exit settles',
    (tester) async {
      await host(tester);
      for (var index = 0; index < 4; index++) {
        await push(tester, index);
      }
      for (var index = 3; index > 0; index--) {
        final route = ModalRoute.of(tester.element(sheet(index)))!;
        expect(route.isCurrent, isTrue);
        final gesture = await tester.startGesture(bounds(tester, index).center);
        await gesture.moveBy(const Offset(0, 70));
        await tester.pump(const Duration(milliseconds: 16));
        await gesture.up();
        await tester.pump();
        expect(route.isCurrent, isFalse);
        expect(ModalRoute.of(tester.element(sheet(index - 1)))!.isCurrent, isTrue);
        // Keep every outgoing route mounted while starting the next swipe.
        expect(sheet(index), findsOneWidget);
        await tester.pump(const Duration(milliseconds: 16));
      }
      await tester.pumpAndSettle();
      expect(sheet(0), findsOneWidget);
      expect(find.byType(MateoSheetView), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'when dragging beyond a full sheet extent, it should cap stack restoration and still return on cancellation',
    (tester) async {
      await host(tester);
      await push(tester, 0, height: 300);
      final resting = bounds(tester, 0);
      await push(tester, 1, height: 80);
      final covered = bounds(tester, 0);
      final gesture = await tester.startGesture(bounds(tester, 1).center);
      await gesture.moveBy(const Offset(0, 300));
      await tester.pump();
      expect(bounds(tester, 0), resting);
      await gesture.moveBy(const Offset(0, 100));
      await tester.pump();
      expect(bounds(tester, 0), resting);
      await gesture.cancel();
      await tester.pumpAndSettle();
      expect(bounds(tester, 0), covered);
      expect(ModalRoute.of(tester.element(sheet(1)))!.isCurrent, isTrue);
      expect(tester.takeException(), isNull);
    },
  );
}
