import 'dart:async';

import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

import '../fixtures/surface_transform_test_widgets.dart';

void main() {
  late BuildContext launcher;
  late GlobalKey<NavigatorState> navigator;

  Future<void> host(WidgetTester tester, {bool reducedMotion = false, Widget? child}) async {
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
              return child ?? const SizedBox.expand();
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  const view = MateoSheetView(
    surface: MateoSheetViewSurface(child: SizedBox(height: 80, child: Text('Sheet content'))),
  );

  Future<void> requestDismiss(WidgetTester tester, MateoSheetDismissSource source) async {
    switch (source) {
      case .closeButton:
        await tester.tap(find.byType(MateoButton).last);
      case .drag:
        await tester.drag(find.byType(MateoSheetView).last, const Offset(0, 120));
      case .tapOutside:
        await tester.tapAt(const Offset(10, 10));
      case .systemBack:
        navigator.currentState!.maybePop();
      case .accessibilityAction:
        final node = tester.getSemantics(find.byType(MateoSheetView).last);
        tester.platformDispatcher.onSemanticsActionEvent!(
          SemanticsActionEvent(type: SemanticsAction.dismiss, nodeId: node.id, viewId: tester.view.viewId),
        );
    }
    await tester.pumpAndSettle();
  }

  for (final source in MateoSheetDismissSource.values) {
    for (final allowed in [false, true]) {
      testWidgets('when $source returns $allowed, it should report the source and respect the decision', (
        tester,
      ) async {
        final semantics = tester.ensureSemantics();
        await host(tester);
        final requests = <MateoSheetDismissSource>[];
        unawaited(
          showMateoSheet<void>(
            context: launcher,
            view: source == .closeButton
                ? const MateoSheetView(
                    header: MateoSheetViewHeader(presentation: .closeButton()),
                    surface: MateoSheetViewSurface(child: SizedBox(height: 80)),
                  )
                : view,
            shouldDismiss: (source) {
              requests.add(source);
              return allowed;
            },
          ),
        );
        await tester.pumpAndSettle();
        final origin = tester.getTopLeft(find.byType(MateoSheetView));
        await requestDismiss(tester, source);
        expect(requests, [source]);
        expect(find.byType(MateoSheetView), allowed ? findsNothing : findsOneWidget);
        if (!allowed) expect(tester.getTopLeft(find.byType(MateoSheetView)), origin);
        semantics.dispose();
      });
    }
  }

  for (final allowed in [false, true]) {
    testWidgets('when an async drag decision returns $allowed, it should ignore repeated requests and settle', (
      tester,
    ) async {
      await host(tester);
      final decision = Completer<bool>();
      var calls = 0;
      unawaited(
        showMateoSheet<void>(
          context: launcher,
          view: view,
          shouldDismiss: (_) {
            calls++;
            return decision.future;
          },
        ),
      );
      await tester.pumpAndSettle();
      final origin = tester.getTopLeft(find.byType(MateoSheetView));
      await requestDismiss(tester, .drag);
      await requestDismiss(tester, .tapOutside);
      await requestDismiss(tester, .systemBack);
      expect(calls, 1);
      expect(find.byType(MateoSheetView), findsOneWidget);
      decision.complete(allowed);
      await tester.pumpAndSettle();
      expect(find.byType(MateoSheetView), allowed ? findsNothing : findsOneWidget);
      if (!allowed) expect(tester.getTopLeft(find.byType(MateoSheetView)), origin);
    });
  }

  testWidgets('when explicitly popped during a decision, it should preserve the result and ignore the stale approval', (
    tester,
  ) async {
    await host(tester);
    final decision = Completer<bool>();
    final result = showMateoSheet<String>(context: launcher, view: view, shouldDismiss: (_) => decision.future);
    await tester.pumpAndSettle();
    await requestDismiss(tester, .tapOutside);
    navigator.currentState!.pop('done');
    await tester.pumpAndSettle();
    expect(await result, 'done');
    decision.complete(true);
    await tester.pumpAndSettle();
    expect(navigator.currentState!.canPop(), isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('when another sheet covers a pending decision, it should keep both sheets open', (tester) async {
    await host(tester);
    final decision = Completer<bool>();
    unawaited(showMateoSheet<void>(context: launcher, view: view, shouldDismiss: (_) => decision.future));
    await tester.pumpAndSettle();
    await requestDismiss(tester, .tapOutside);
    unawaited(showMateoSheet<void>(context: launcher, view: view));
    await tester.pumpAndSettle();
    decision.complete(true);
    await tester.pumpAndSettle();
    expect(find.byType(MateoSheetView), findsNWidgets(2));
  });

  testWidgets('when a decision throws, it should report the error and allow a later request', (tester) async {
    await host(tester);
    var calls = 0;
    unawaited(
      showMateoSheet<void>(
        context: launcher,
        view: view,
        shouldDismiss: (_) {
          if (calls++ == 0) throw StateError('decision failed');
          return true;
        },
      ),
    );
    await tester.pumpAndSettle();
    await requestDismiss(tester, .drag);
    expect(tester.takeException(), isStateError);
    expect(find.byType(MateoSheetView), findsOneWidget);
    await requestDismiss(tester, .tapOutside);
    expect(find.byType(MateoSheetView), findsNothing);
  });

  testWidgets('when PopScope vetoes an approved request, it should keep the sheet open', (tester) async {
    await host(tester);
    unawaited(
      showMateoSheet<void>(
        context: launcher,
        shouldDismiss: (_) => true,
        view: const MateoSheetView(
          surface: MateoSheetViewSurface(child: PopScope(canPop: false, child: SizedBox(height: 80))),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await requestDismiss(tester, .drag);
    expect(find.byType(MateoSheetView), findsOneWidget);
  });

  for (final reducedMotion in [false, true]) {
    testWidgets(
      'when a stacked drag is denied with reduced motion $reducedMotion, it should restore and consult only the top sheet',
      (tester) async {
        await host(tester, reducedMotion: reducedMotion);
        var lowerCalls = 0;
        var topCalls = 0;
        unawaited(
          showMateoSheet<void>(
            context: launcher,
            view: view,
            shouldDismiss: (_) {
              lowerCalls++;
              return true;
            },
          ),
        );
        await tester.pumpAndSettle();
        unawaited(showMateoSheet<void>(context: launcher, view: view, shouldDismiss: (_) => ++topCalls > 1));
        await tester.pumpAndSettle();
        final frames = tester.getRect(find.byType(MateoSheetView).first);
        final topFrame = tester.getRect(find.byType(MateoSheetView).last);
        await requestDismiss(tester, .drag);
        expect(find.byType(MateoSheetView), findsNWidgets(2));
        expect(tester.getRect(find.byType(MateoSheetView).first), frames);
        expect(tester.getRect(find.byType(MateoSheetView).last), topFrame);
        await requestDismiss(tester, .tapOutside);
        expect(find.byType(MateoSheetView), findsOneWidget);
        expect(topCalls, 2);
        expect(lowerCalls, 0);
      },
    );
  }

  for (final direction in <String, Offset>{
    'up': const Offset(0, -96),
    'left': const Offset(-96, 0),
    'right': const Offset(96, 0),
  }.entries) {
    for (final cancelled in [false, true]) {
      testWidgets(
        'when overdragged ${direction.key} with cancellation=$cancelled, it should resist and settle without dismissing',
        (tester) async {
          await host(tester);
          unawaited(showMateoSheet<void>(context: launcher, view: view));
          await tester.pumpAndSettle();
          final sheet = find.byType(MateoSheetView);
          final origin = tester.getTopLeft(sheet);
          final element = tester.element(sheet);
          final gesture = await tester.startGesture(tester.getCenter(sheet));
          await gesture.moveBy(direction.value);
          await tester.pump();
          expect(tester.getTopLeft(sheet) - origin, direction.value / 32);
          expect(tester.element(sheet), same(element));
          if (cancelled) {
            await gesture.cancel();
          } else {
            await gesture.up();
          }
          await tester.pump();
          expect(tester.getTopLeft(sheet) - origin, direction.value / 32);
          await tester.pump(const Duration(milliseconds: 90));
          expect((tester.getTopLeft(sheet) - origin).distance, allOf(greaterThan(0), lessThan(3)));
          await tester.pump(const Duration(milliseconds: 90));
          expect(tester.getTopLeft(sheet), origin);
          navigator.currentState!.pop();
          await tester.pumpAndSettle();
        },
      );
    }
  }

  testWidgets('when an upward gesture reverses downward, it should resist until a new gesture starts', (
    tester,
  ) async {
    await host(tester);
    unawaited(showMateoSheet<void>(context: launcher, view: view));
    await tester.pumpAndSettle();
    final sheet = find.byType(MateoSheetView);
    final origin = tester.getTopLeft(sheet);
    final gesture = await tester.startGesture(tester.getCenter(sheet));
    await gesture.moveBy(const Offset(0, -96));
    await tester.pump();
    expect(tester.getTopLeft(sheet).dy, origin.dy - 3);
    await gesture.moveBy(const Offset(0, 96));
    await tester.pump();
    expect(tester.getTopLeft(sheet), origin);
    await gesture.moveBy(const Offset(0, 96));
    await tester.pump();
    expect(tester.getTopLeft(sheet).dy, origin.dy + 3);
    await gesture.moveBy(const Offset(0, -48));
    await tester.pump();
    expect(tester.getTopLeft(sheet).dy - origin.dy, allOf(greaterThan(0), lessThan(3)));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(sheet, findsOneWidget);
    expect(tester.getTopLeft(sheet), origin);

    final dismissal = await tester.startGesture(tester.getCenter(sheet));
    await dismissal.moveBy(const Offset(0, 96));
    await tester.pump();
    expect(tester.getTopLeft(sheet).dy, origin.dy + 96);
    await dismissal.up();
    await tester.pumpAndSettle();
    expect(sheet, findsNothing);
  });

  testWidgets('when overdrag motion is reduced, it should keep the sheet at rest', (tester) async {
    await host(tester, reducedMotion: true);
    unawaited(showMateoSheet<void>(context: launcher, view: view));
    await tester.pumpAndSettle();
    final sheet = find.byType(MateoSheetView);
    final origin = tester.getTopLeft(sheet);
    final gesture = await tester.startGesture(tester.getCenter(sheet));
    await gesture.moveBy(const Offset(96, -96));
    await tester.pump();
    expect(tester.getTopLeft(sheet), origin);
    await gesture.up();
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(sheet), origin);
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
  });

  testWidgets('when upward scrolling reaches its boundary, it should resist only the remaining overdrag', (
    tester,
  ) async {
    await host(tester);
    unawaited(
      showMateoSheet<void>(
        context: launcher,
        view: const MateoSheetView(
          surface: MateoSheetViewSurface.scrollable(child: SizedBox(height: 1200)),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final sheet = find.byType(MateoSheetView);
    final scroll = tester.state<ScrollableState>(find.byType(Scrollable));
    final origin = tester.getTopLeft(sheet);
    final gesture = await tester.startGesture(tester.getCenter(sheet));
    await gesture.moveBy(const Offset(0, -96));
    await tester.pump();
    expect(scroll.position.pixels, greaterThan(0));
    expect(tester.getTopLeft(sheet), origin);
    await gesture.cancel();
    await tester.pumpAndSettle();
    scroll.position.jumpTo(scroll.position.maxScrollExtent);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 150));
    final boundaryGesture = await tester.startGesture(tester.getCenter(sheet));
    await boundaryGesture.moveBy(const Offset(0, -96));
    await tester.pump();
    expect(tester.getTopLeft(sheet).dy, closeTo(origin.dy - 3, .001));
    await boundaryGesture.cancel();
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(sheet), origin);
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
  });

  testWidgets('when removed during overdrag, it should ignore the held pointer ending afterward', (tester) async {
    await host(tester);
    unawaited(showMateoSheet<void>(context: launcher, view: view));
    await tester.pumpAndSettle();
    final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoSheetView)));
    await gesture.moveBy(const Offset(0, -96));
    await tester.pump();
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
    expect(find.byType(MateoSheetView), findsNothing);
    await gesture.cancel();
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('when a drag is cancelled, it should return with the sheet landing motion', (tester) async {
    await host(tester);
    unawaited(showMateoSheet<void>(context: launcher, view: view));
    await tester.pumpAndSettle();
    final swipe = tester.widget<InteractiveSwipeDismiss>(find.byType(InteractiveSwipeDismiss));
    final start = tester.getTopLeft(find.byType(MateoSheetView)).dy;
    final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoSheetView)));
    await gesture.moveBy(const Offset(0, 20));
    await tester.pump();
    expect(tester.getTopLeft(find.byType(MateoSheetView)).dy, closeTo(start + 20, .001));
    await tester.pump(const Duration(milliseconds: 200));
    await gesture.cancel();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(
      tester.getTopLeft(find.byType(MateoSheetView)).dy,
      closeTo(start + 20 * (1 - swipe.dragConfig.returnCurve.transform(100 / 360)), .001),
    );
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byType(MateoSheetView)).dy, start);
    expect(swipe.dragConfig.returnDuration, const Duration(milliseconds: 360));
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
  });

  for (final height in [80.0, 1000.0]) {
    testWidgets('when dragging a $height sheet past 30 percent, it should dismiss with a null result', (tester) async {
      await host(tester);
      final result = showMateoSheet<String>(
        context: launcher,
        view: MateoSheetView(
          surface: MateoSheetViewSurface(child: SizedBox(height: height)),
        ),
      );
      await tester.pumpAndSettle();
      final extent = tester.getSize(find.byType(InteractiveSwipeDismiss)).height;
      final gesture = await tester.startGesture(tester.getTopLeft(find.byType(MateoSheetView)) + const Offset(100, 10));
      await gesture.moveBy(Offset(0, extent * .31));
      await tester.pump(const Duration(milliseconds: 200));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(await result, isNull);
      expect(find.byType(MateoSheetView), findsNothing);
    });
  }

  testWidgets('when flung below the distance threshold, it should dismiss', (tester) async {
    await host(tester);
    unawaited(
      showMateoSheet<void>(
        context: launcher,
        view: const MateoSheetView(surface: MateoSheetViewSurface(child: SizedBox(height: 1000))),
      ),
    );
    await tester.pumpAndSettle();
    await tester.flingFrom(const Offset(200, 100), const Offset(0, 80), 1500);
    await tester.pumpAndSettle();
    expect(find.byType(MateoSheetView), findsNothing);
  });

  testWidgets('when swipe motion is reduced, it should dismiss without translating', (tester) async {
    await host(tester, reducedMotion: true);
    unawaited(showMateoSheet<void>(context: launcher, view: view));
    await tester.pumpAndSettle();
    final top = tester.getTopLeft(find.byType(MateoSheetView)).dy;
    final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoSheetView)));
    await gesture.moveBy(const Offset(0, 30));
    await tester.pump();
    expect(tester.getTopLeft(find.byType(MateoSheetView)).dy, top);
    await tester.pump(const Duration(milliseconds: 200));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(find.byType(MateoSheetView), findsNothing);
  });

  testWidgets('when another route is current, a stale dismissal should leave it open', (tester) async {
    await host(tester);
    unawaited(showMateoSheet<void>(context: launcher, view: view));
    await tester.pumpAndSettle();
    final swipe = tester.widget<InteractiveSwipeDismiss>(find.byType(InteractiveSwipeDismiss));
    navigator.currentState!.push(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => const SizedBox(key: ValueKey('cover')),
      ),
    );
    await tester.pumpAndSettle();
    expect(await swipe.onDismiss(), isFalse);
    expect(find.byKey(const ValueKey('cover')), findsOneWidget);
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
    expect(await swipe.onDismiss(), isTrue);
    await tester.pumpAndSettle();
    expect(find.byType(MateoSheetView), findsNothing);
  });

  testWidgets('when content is scrolled, it should scroll back before dragging the sheet', (tester) async {
    await host(tester);
    unawaited(
      showMateoSheet<void>(
        context: launcher,
        view: const MateoSheetView(surface: MateoSheetViewSurface.scrollable(child: SizedBox(height: 1200))),
      ),
    );
    await tester.pumpAndSettle();
    final scroll = tester.state<ScrollableState>(find.byType(Scrollable));
    scroll.position.jumpTo(200);
    await tester.pumpAndSettle();
    final top = tester.getTopLeft(find.byType(MateoSheetView)).dy;
    await tester.dragFrom(const Offset(200, 200), const Offset(0, 60));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byType(MateoSheetView)).dy, top);
    expect(scroll.position.pixels, lessThan(200));
    scroll.position.jumpTo(0);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 150));
    await tester.dragFrom(const Offset(200, 200), const Offset(0, 200));
    await tester.pumpAndSettle();
    expect(find.byType(MateoSheetView), findsNothing);
  });

  testWidgets('when shown, it should preserve the supplied view and return its pop result', (tester) async {
    await host(tester);
    final result = showMateoSheet<String>(context: launcher, view: view);
    await tester.pumpAndSettle();
    expect(tester.widget<MateoSheetView>(find.byType(MateoSheetView)), same(view));
    expect(tester.widget<MateoSheetViewSurface>(find.byType(MateoSheetViewSurface)), same(view.surface));
    expect(tester.getSize(find.byType(MateoSheetView)), const Size(768, 120));
    navigator.currentState!.pop('done');
    expect(await result, 'done');
    await tester.pumpAndSettle();
    expect(find.byType(MateoSheetView), findsNothing);
  });

  testWidgets('when a sheet has fixed slots, it should use its built-in spacing', (
    tester,
  ) async {
    {
      await host(tester);
      unawaited(
        showMateoSheet<void>(
          context: launcher,
          view: const MateoSheetView(
            header: MateoSheetViewHeader(presentation: .custom(principal: SizedBox(height: 10))),
            footer: MateoSheetViewFooter(principal: SizedBox(height: 10)),
            surface: MateoSheetViewSurface(child: SizedBox(key: ValueKey('body'), height: 40)),
          ),
        ),
      );
      await tester.pumpAndSettle();
      const spacing = 20.0;
      expect(tester.getSize(find.byType(MateoSheetViewHeader)).height, 10 + spacing);
      expect(tester.getSize(find.byType(MateoSheetViewFooter)).height, 10 + spacing);
      expect(tester.getTopLeft(find.byKey(const ValueKey('body'))).dx, 16 + spacing);
      expect(tester.getSize(find.byKey(const ValueKey('body'))).width, 768 - 2 * spacing);
      expect(tester.getBottomLeft(find.byType(MateoSheetView)).dy, 588);
      navigator.currentState!.pop();
      await tester.pumpAndSettle();
    }
  });

  testWidgets('when content is tall, it should cap the whole sheet at 90 percent with or without motion', (
    tester,
  ) async {
    for (final reducedMotion in [false, true]) {
      for (final scrollable in [false, true]) {
        await host(tester, reducedMotion: reducedMotion);
        unawaited(
          showMateoSheet<void>(
            context: launcher,
            view: MateoSheetView(
              header: const MateoSheetViewHeader(presentation: .custom(principal: SizedBox(height: 20))),
              footer: const MateoSheetViewFooter(principal: SizedBox(height: 20)),
              surface: scrollable
                  ? const MateoSheetViewSurface.scrollable(child: SizedBox(height: 1000))
                  : const MateoSheetViewSurface(child: SizedBox(height: 1000)),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.getRect(find.byType(MateoSheetView)), const Rect.fromLTWH(16, 48, 768, 540));
        navigator.currentState!.pop();
        await tester.pumpAndSettle();
      }
    }
  });

  for (final maxExtent in [0.0, -1.0, double.infinity, double.negativeInfinity, double.nan]) {
    testWidgets('when maxExtent is $maxExtent, it should reject the limit before opening', (tester) async {
      await host(tester);
      expect(() => showMateoSheet<void>(context: launcher, view: view, maxExtent: maxExtent), throwsAssertionError);
      await tester.pumpAndSettle();
      expect(find.byType(MateoSheetView), findsNothing);
    });
  }

  for (final reducedMotion in [false, true]) {
    for (final scrollable in [false, true]) {
      for (final maxExtent in [300.0, 1000.0]) {
        testWidgets(
          'when maxExtent is $maxExtent, it should cap fixed slots and content ($scrollable, $reducedMotion)',
          (tester) async {
            await host(tester, reducedMotion: reducedMotion);
            unawaited(
              showMateoSheet<void>(
                context: launcher,
                maxExtent: maxExtent,
                view: MateoSheetView(
                  header: const MateoSheetViewHeader(presentation: .custom(principal: SizedBox(height: 20))),
                  footer: const MateoSheetViewFooter(principal: SizedBox(height: 20)),
                  surface: scrollable
                      ? const MateoSheetViewSurface.scrollable(child: SizedBox(height: 1000))
                      : const MateoSheetViewSurface(child: SizedBox(height: 1000)),
                ),
              ),
            );
            await tester.pumpAndSettle();
            expect(tester.getSize(find.byType(MateoSheetView)).height, maxExtent == 300 ? 300 : 540);
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  }

  testWidgets('when maxExtent exceeds fitted content, it should keep the sheet short and dismissible', (tester) async {
    await host(tester);
    final result = showMateoSheet<void>(context: launcher, view: view, maxExtent: 300);
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(MateoSheetView)).height, 120);
    await requestDismiss(tester, .drag);
    await result;
    expect(find.byType(MateoSheetView), findsNothing);
  });

  testWidgets('when capped scrolling reaches the end, the last item should clear the fixed footer', (tester) async {
    await host(tester);
    unawaited(
      showMateoSheet<void>(
        context: launcher,
        maxExtent: 300,
        view: const MateoSheetView(
          header: MateoSheetViewHeader(presentation: .custom(principal: Text('Header'))),
          footer: MateoSheetViewFooter(principal: Text('Footer')),
          surface: MateoSheetViewSurface.scrollable(
            child: Column(children: [SizedBox(height: 1000), Text('Last item')]),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.drag(find.byType(Scrollable), const Offset(0, -1200));
    await tester.pumpAndSettle();
    expect(find.text('Last item').hitTestable(), findsOneWidget);
    expect(
      tester.getBottomLeft(find.text('Last item')).dy,
      lessThanOrEqualTo(tester.getTopLeft(find.byType(MateoSheetViewFooter)).dy),
    );
    expect(tester.getSize(find.byType(MateoSheetView)).height, 300);
    final scroll = tester.state<ScrollableState>(find.byType(Scrollable));
    scroll.position.jumpTo(0);
    await tester.pumpAndSettle();
    await requestDismiss(tester, .drag);
    expect(find.byType(MateoSheetView), findsNothing);
  });

  testWidgets('when the viewport changes, maxExtent should remain fixed beneath the adaptive viewport ceiling', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 600);
    addTearDown(tester.view.reset);
    await host(tester);
    unawaited(
      showMateoSheet<void>(
        context: launcher,
        maxExtent: 400,
        view: const MateoSheetView(surface: MateoSheetViewSurface.scrollable(child: SizedBox(height: 1000))),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(MateoSheetView)).height, 400);
    tester.view.physicalSize = const Size(800, 300);
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(MateoSheetView)).height, 270);
    tester.view.physicalSize = const Size(800, 800);
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(MateoSheetView)).height, 400);
    tester.view.padding = const FakeViewPadding(top: 500, bottom: 100);
    await tester.pumpAndSettle();
    final sheet = tester.getRect(find.byType(MateoSheetView));
    expect(sheet.height, lessThanOrEqualTo(176));
    expect(sheet.top, greaterThanOrEqualTo(512));
    expect(sheet.bottom, lessThanOrEqualTo(688));
  });

  testWidgets('when the sheet animates, it should use the approved landing curve and separate timings', (tester) async {
    await host(tester);
    unawaited(showMateoSheet<void>(context: launcher, view: view));
    await tester.pump();
    final context = tester.element(find.byType(MateoSheetView));
    final route = ModalRoute.of(context)!;
    expect(route.transitionDuration, const Duration(milliseconds: 360));
    expect(route.reverseTransitionDuration, const Duration(milliseconds: 300));
    final slide = tester.widget<SlideTransition>(
      find.ancestor(of: find.byType(MateoSheetView), matching: find.byType(SlideTransition)).first,
    );
    final movement = (slide.position as AnimationWithParentMixin<double>).parent as CurvedAnimation;
    final curve = movement.curve;
    var previous = 0.0;
    for (var i = 0; i <= 10000; i++) {
      final t = i / 10000;
      final value = curve.transform(t);
      expect(value, inInclusiveRange(0.0, 1.0));
      expect(value, greaterThanOrEqualTo(previous - 1e-12));
      expect(1 - movement.reverseCurve!.transform(1 - t), closeTo(value, 1e-12));
      previous = value;
    }
    const join = 0.48300052620708006;
    const e = .00001;
    expect(curve.transform(join), closeTo(.95, 1e-12));
    final before = (curve.transform(join) - curve.transform(join - e)) / e;
    final after = (curve.transform(join + e) - curve.transform(join)) / e;
    expect(before, closeTo(after, .0001));
    final accelerationBefore =
        (curve.transform(join) - 2 * curve.transform(join - e) + curve.transform(join - 2 * e)) / (e * e);
    final accelerationAfter =
        (curve.transform(join + 2 * e) - 2 * curve.transform(join + e) + curve.transform(join)) / (e * e);
    expect(accelerationBefore, closeTo(accelerationAfter, .001));
    expect((1 - curve.transform(1 - e)) / e, closeTo(0, .000001));
    expect((1 - 2 * curve.transform(1 - e) + curve.transform(1 - 2 * e)) / (e * e), closeTo(0, .001));
    await tester.pumpAndSettle();
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
  });

  testWidgets('when opening and closing, it should move upward then downward', (tester) async {
    await host(tester);
    unawaited(showMateoSheet<void>(context: launcher, view: view));
    await tester.pump();
    expect(tester.getTopLeft(find.byType(MateoSheetView)).dy, 612);
    await tester.pump(const Duration(milliseconds: 100));
    final enteringY = tester.getTopLeft(find.byType(MateoSheetView)).dy;
    expect(enteringY, inExclusiveRange(468, 612));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byType(MateoSheetView)).dy, 468);
    navigator.currentState!.pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.getTopLeft(find.byType(MateoSheetView)).dy, inExclusiveRange(468, 612));
    await tester.pumpAndSettle();
    expect(find.byType(MateoSheetView), findsNothing);
  });

  testWidgets('when dismissed during entry, it should reverse without jumping', (tester) async {
    await host(tester);
    unawaited(showMateoSheet<void>(context: launcher, view: view));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final before = tester.getTopLeft(find.byType(MateoSheetView)).dy;
    navigator.currentState!.pop();
    await tester.pump();
    expect(tester.getTopLeft(find.byType(MateoSheetView)).dy, closeTo(before, 0.001));
    await tester.pump(const Duration(milliseconds: 30));
    expect(tester.getTopLeft(find.byType(MateoSheetView)).dy, greaterThan(before));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('when reduced motion is enabled, it should enter and leave without translation', (tester) async {
    await host(tester, reducedMotion: true);
    unawaited(showMateoSheet<void>(context: launcher, view: view));
    await tester.pump();
    expect(tester.getTopLeft(find.byType(MateoSheetView)).dy, 468);
    expect(find.ancestor(of: find.byType(MateoSheetView), matching: find.byType(SlideTransition)), findsNothing);
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
    expect(find.byType(MateoSheetView), findsNothing);
  });

  for (final scenario in ['settled', 'entering', 'reduced motion']) {
    testWidgets('when the scrim is tapped with a $scenario sheet, it should dismiss and block background input', (
      tester,
    ) async {
      var taps = 0;
      await host(
        tester,
        reducedMotion: scenario == 'reduced motion',
        child: GestureDetector(
          behavior: .opaque,
          onTap: () => taps++,
          child: const SizedBox.expand(),
        ),
      );
      final result = showMateoSheet<String>(context: launcher, view: view);
      await tester.pump();
      if (scenario == 'entering') {
        await tester.pump(const Duration(milliseconds: 100));
      } else {
        await tester.pumpAndSettle();
      }
      final route = ModalRoute.of(tester.element(find.byType(MateoSheetView)))!;
      expect(route.barrierColor, surfaceTransformTheme.colorScheme.sheet.scrim);
      expect(route.barrierDismissible, isTrue);
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(await result, isNull);
      expect(taps, 0);
      expect(find.byType(MateoSheetView), findsNothing);
    });
  }

  testWidgets('when sheet content is tapped, it should keep the sheet open', (tester) async {
    await host(tester);
    unawaited(showMateoSheet<void>(context: launcher, view: view));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sheet content'));
    await tester.pumpAndSettle();
    expect(find.byType(MateoSheetView), findsOneWidget);
    expect(navigator.currentState!.canPop(), isTrue);
  });

  testWidgets('when called inside a nested navigator, it should preserve local appearance and use that navigator', (
    tester,
  ) async {
    final nestedNavigator = GlobalKey<NavigatorState>();
    final localTheme = MateoThemeData.light(
      accentColor: surfaceTransformTheme.palette.violet[9],
      onAccent: surfaceTransformTheme.palette.white,
    );
    final localStyle = TextStyle(fontSize: 31, color: localTheme.colorScheme.text.primary);
    await host(
      tester,
      child: Navigator(
        key: nestedNavigator,
        onGenerateRoute: (_) => PageRouteBuilder<void>(
          pageBuilder: (context, animation, secondaryAnimation) => MateoTheme(
            data: localTheme,
            child: Directionality(
              textDirection: .rtl,
              child: DefaultTextStyle(
                style: localStyle,
                child: Builder(
                  builder: (context) {
                    launcher = context;
                    return const SizedBox.expand();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
    unawaited(
      showMateoSheet<void>(
        context: launcher,
        view: MateoSheetView(
          surface: MateoSheetViewSurface(
            child: Builder(
              builder: (context) {
                expect(MateoTheme.of(context), same(localTheme));
                expect(DefaultTextStyle.of(context).style, localStyle);
                expect(Directionality.of(context), TextDirection.rtl);
                return const Text('Nested sheet');
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(nestedNavigator.currentState!.canPop(), isTrue);
    expect(navigator.currentState!.canPop(), isFalse);
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(nestedNavigator.currentState!.canPop(), isFalse);
    expect(navigator.currentState!.canPop(), isFalse);
    expect(find.text('Nested sheet'), findsNothing);
  });
  testWidgets(
    'when another sheet opens above a sheet, it should leave the earlier layout and scroll position unchanged',
    (tester) async {
      await host(tester);
      const firstKey = ValueKey('first sheet');
      unawaited(
        showMateoSheet<void>(
          context: launcher,
          view: const MateoSheetView(
            key: firstKey,
            surface: MateoSheetViewSurface.scrollable(child: SizedBox(height: 1200)),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final first = find.byKey(firstKey);
      final bounds = tester.getRect(first);
      final scroll = tester.state<ScrollableState>(find.descendant(of: first, matching: find.byType(Scrollable)));
      scroll.position.jumpTo(100);
      await tester.pump();

      unawaited(showMateoSheet<void>(context: launcher, view: view));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.getRect(first), bounds);
      await tester.pumpAndSettle();
      expect(tester.getRect(first), bounds);
      expect(scroll.position.pixels, 100);
      expect(find.byType(MateoSheetView), findsNWidgets(2));

      navigator.currentState!.pop();
      await tester.pumpAndSettle();
      expect(find.byType(MateoSheetView), findsOneWidget);
      expect(tester.getRect(first), bounds);
      expect(scroll.mounted, isTrue);
      expect(scroll.position.pixels, 100);
      expect(tester.takeException(), isNull);
    },
  );
}
