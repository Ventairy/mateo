import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

import '../test_app.dart';

const _surfaceKey = Key('mateo_sheet_surface');
const _closeKey = Key('mateo_sheet_close_button');

void main() {
  testWidgets('when a lower sheet has a PopScope veto, it should retain it during stack dismissal', (tester) async {
    final context = await _pumpStack(tester);
    final popAttempts = <bool>[];
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: PopScope<void>(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) => popAttempts.add(didPop),
          child: const Text('Protected'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: const Text('Second'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(200, 150));
    await tester.pumpAndSettle();
    expect(find.text('Protected').hitTestable(), findsOneWidget);
    expect(find.text('Second'), findsNothing);
    expect(popAttempts, [false]);
    expect(tester.takeException(), isNull);
  });
  testWidgets('when navigation interrupts a pending drag decision, it should allow dragging after returning', (
    tester,
  ) async {
    final context = await _pumpStack(tester);
    final decision = Completer<bool>();
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: const Text('First'),
      ),
    );
    await tester.pumpAndSettle();
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        shouldDismiss: (_) => decision.future,
        child: const SizedBox(height: 200, child: Text('Second')),
      ),
    );
    await tester.pumpAndSettle();
    await tester.flingFrom(const Offset(200, 150), const Offset(0, 220), 1000);
    await tester.pump();
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: const Text('Third'),
      ),
    );
    await tester.pumpAndSettle();
    decision.complete(false);
    await tester.pumpAndSettle();
    Navigator.of(context).pop();
    await tester.pumpAndSettle();
    final before = tester.getRect(find.byKey(_surfaceKey).last);
    final gesture = await tester.startGesture(const Offset(200, 150));
    await gesture.moveBy(const Offset(0, 40));
    await tester.pump();
    expect(tester.getRect(find.byKey(_surfaceKey).last).top, greaterThan(before.top));
    await gesture.cancel();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('when another sheet opens before a protected sheet reappears, it should remain usable after returning', (
    tester,
  ) async {
    final context = await _pumpStack(tester);
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        shouldDismiss: (_) => false,
        child: const SizedBox(height: 200, child: Text('Protected')),
      ),
    );
    await tester.pumpAndSettle();
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: const Text('Second'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.flingFrom(const Offset(200, 150), const Offset(0, 220), 1000);
    await tester.pump(const Duration(milliseconds: 230));
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: const Text('Third'),
      ),
    );
    await tester.pumpAndSettle();
    Navigator.of(context).pop();
    await tester.pumpAndSettle();
    expect(find.text('Protected').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('when returning to a scrollable sheet, it should preserve its height and scroll offset', (
    tester,
  ) async {
    final context = await _pumpStack(tester);
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: const SingleChildScrollView(child: SizedBox(height: 1600, child: Text('First'))),
      ),
    );
    await tester.pumpAndSettle();
    final position = tester.state<ScrollableState>(find.byType(Scrollable)).position;
    position.jumpTo(100);
    await tester.pump();
    final height = tester.getSize(find.byKey(_surfaceKey)).height;
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: const SizedBox(height: 100, child: Text('Second')),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(_closeKey).hitTestable());
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byKey(_surfaceKey)).height, height);
    expect(position.pixels, 100);
    expect(tester.takeException(), isNull);
  });

  testWidgets('when sheets belong to different navigators, it should keep their surfaces independent', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final contexts = <BuildContext>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: mateoTestTheme,
        home: Row(
          children: [
            for (var index = 0; index < 2; index++)
              Expanded(
                child: Navigator(
                  onGenerateRoute: (_) => MaterialPageRoute<void>(
                    builder: (context) {
                      contexts.add(context);
                      return const Scaffold();
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    unawaited(
      MateoSheet.show<void>(
        contexts[0],
        presentation: const MateoSheetPresentation.bottom(),
        child: const Text('Left'),
      ),
    );
    await tester.pumpAndSettle();
    unawaited(
      MateoSheet.show<void>(
        contexts[1],
        presentation: const MateoSheetPresentation.bottom(),
        child: const Text('Right'),
      ),
    );
    await tester.pumpAndSettle();
    final surfaces = tester.widgetList<Morph>(find.byType(Morph)).where((morph) => morph.child.key == _surfaceKey);
    expect(surfaces.map((morph) => morph.tag).toSet(), hasLength(2));
    unawaited(
      MateoSheet.show<void>(
        contexts[0],
        presentation: const MateoSheetPresentation.bottom(),
        child: const Text('Next left'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Next left').hitTestable(), findsOneWidget);
    expect(find.text('Right').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('when the oldest sheet refuses a scrim tap, it should skip accepted intermediate sheets', (tester) async {
    final context = await _pumpStack(tester);
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        shouldDismiss: (_) => false,
        child: const Text('Protected'),
      ),
    );
    await tester.pumpAndSettle();
    final middle = MateoSheet.show<int>(
      context,
      presentation: const MateoSheetPresentation.bottom(),
      child: const SizedBox(height: 200, child: Text('Middle')),
    );
    await tester.pumpAndSettle();
    final top = MateoSheet.show<int>(
      context,
      presentation: const MateoSheetPresentation.bottom(),
      child: const SizedBox(height: 300, child: Text('Top')),
    );
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(200, 150));
    await tester.pumpAndSettle();
    expect(await middle, isNull);
    expect(await top, isNull);
    expect(find.byKey(_surfaceKey), findsOneWidget);
    expect(find.text('Protected').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('when the top sheet refuses a committed drag, it should restore the top sheet', (tester) async {
    final context = await _pumpStack(tester);
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: const Text('First'),
      ),
    );
    await tester.pumpAndSettle();
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        shouldDismiss: (_) => false,
        child: const SizedBox(height: 200, child: Text('Protected')),
      ),
    );
    await tester.pumpAndSettle();
    final before = tester.getRect(find.byKey(_surfaceKey).last);
    await tester.fling(find.byKey(_surfaceKey).last, const Offset(0, 250), 1000);
    await tester.pumpAndSettle();
    expect(find.byKey(_surfaceKey), findsNWidgets(2));
    expect(tester.getRect(find.byKey(_surfaceKey).last), before);
    expect(find.text('Protected').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('when stacking sheets, it should keep one scrim and expose only the current content to accessibility', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final context = await _pumpStack(tester);
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: const Text('First sheet content'),
      ),
    );
    await tester.pumpAndSettle();
    final scrim = tester.widget<AnimatedModalBarrier>(find.byType(AnimatedModalBarrier)).color.value;
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: const Text('Second sheet content'),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final visibleScrims = tester
        .widgetList<AnimatedModalBarrier>(find.byType(AnimatedModalBarrier))
        .map((barrier) => barrier.color.value)
        .where((color) => color != null && color.a > 0);
    expect(visibleScrims.toList(), [scrim]);
    await tester.pumpAndSettle();
    final semanticsTree = tester.binding.renderViews.single.owner!.semanticsOwner!.rootSemanticsNode!.toStringDeep();
    expect(semanticsTree, isNot(contains('First sheet content')));
    expect(semanticsTree, contains('Second sheet content'));
    await Navigator.of(context).maybePop();
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel(RegExp('First sheet content')), findsOneWidget);
    semantics.dispose();
    expect(tester.takeException(), isNull);
  });

  testWidgets('when a lower sheet is removed programmatically, it should still animate the remaining sheet dismissal', (
    tester,
  ) async {
    final context = await _pumpStack(tester);
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: const Text('First'),
      ),
    );
    await tester.pumpAndSettle();
    final firstRoute = ModalRoute.of(tester.element(find.text('First')))!;
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: const Text('Second'),
      ),
    );
    await tester.pumpAndSettle();
    Navigator.of(context).removeRoute(firstRoute);
    await tester.pumpAndSettle();
    final before = tester.getRect(find.byKey(_surfaceKey));
    Navigator.of(context).pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.getRect(find.byKey(_surfaceKey)).top, greaterThan(before.top));
    await tester.pumpAndSettle();
    expect(find.byKey(_surfaceKey), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('when keyboard insets change during a morph, it should finish at the new bottom edge', (tester) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    final context = await _pumpStack(tester);
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: const Text('First'),
      ),
    );
    await tester.pumpAndSettle();
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: const SizedBox(height: 300, child: Text('Second')),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 70));
    tester.view.viewInsets = const FakeViewPadding(bottom: 200);
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byKey(_surfaceKey).last).bottom, closeTo(588, 0.01));
    expect(find.text('Second').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('when route pushes and pops interrupt a morph, it should settle on the current sheet', (tester) async {
    final context = await _pumpStack(tester);
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: const SizedBox(height: 100, child: Text('First')),
      ),
    );
    await tester.pumpAndSettle();
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: const SizedBox(height: 300, child: Text('Second')),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 70));
    Navigator.of(context).pop();
    await tester.pumpAndSettle();
    expect(find.text('First').hitTestable(), findsOneWidget);
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: const SizedBox(height: 300, child: Text('Second')),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 70));
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: const SizedBox(height: 200, child: Text('Third')),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Third').hitTestable(), findsOneWidget);
    Navigator.of(context).pop();
    await tester.pumpAndSettle();
    expect(find.text('Second').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('when navigation changes during a guard, it should leave the new sheet untouched', (tester) async {
    final context = await _pumpStack(tester);
    final decision = Completer<bool>();
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: const Text('First'),
      ),
    );
    await tester.pumpAndSettle();
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        shouldDismiss: (_) => decision.future,
        child: const Text('Second'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(200, 150));
    await tester.pump();
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: const Text('Third'),
      ),
    );
    await tester.pumpAndSettle();
    decision.complete(true);
    await tester.pumpAndSettle();
    expect(find.text('Third').hitTestable(), findsOneWidget);
    expect(find.byKey(_surfaceKey), findsNWidgets(3));
    expect(tester.takeException(), isNull);
  });

  testWidgets('when reduced motion is enabled, it should switch sheets immediately and dismiss the stack', (
    tester,
  ) async {
    final context = await _pumpStack(tester, disableAnimations: true);
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: const Text('First'),
      ),
    );
    await tester.pumpAndSettle();
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: const SizedBox(height: 300, child: Text('Second')),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Second').hitTestable(), findsOneWidget);
    expect(find.text('First').hitTestable(), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget.runtimeType.toString() == '_MorphFlightBoundary'), findsNothing);
    await tester.tapAt(const Offset(200, 150));
    await tester.pumpAndSettle();
    expect(find.byKey(_surfaceKey), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('when a downward drag is cancelled, it should restore the top sheet without morphing backward', (
    tester,
  ) async {
    final context = await _pumpStack(tester);
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: const SizedBox(height: 300, child: Text('First')),
      ),
    );
    await tester.pumpAndSettle();
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: const SizedBox(height: 100, child: Text('Second')),
      ),
    );
    await tester.pumpAndSettle();
    final before = tester.getRect(find.byKey(_surfaceKey).last);
    final gesture = await tester.startGesture(const Offset(200, 150));
    await gesture.moveBy(const Offset(0, 40));
    await tester.pump();
    expect(tester.getRect(find.byKey(_surfaceKey).last).top, greaterThan(before.top));
    expect(find.byWidgetPredicate((widget) => widget.runtimeType.toString() == '_MorphFlightBoundary'), findsNothing);
    await gesture.cancel();
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byKey(_surfaceKey).last), before);
    expect(find.text('Second').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('when another sheet opens, it should morph the container and close button and preserve route results', (
    tester,
  ) async {
    final context = await _pumpStack(tester);
    final first = MateoSheet.show<int>(
      context,
      presentation: const MateoSheetPresentation.bottom(),
      child: const SizedBox(height: 300, child: Text('First')),
    );
    await tester.pumpAndSettle();
    final firstSurface = tester.widget<Container>(find.byKey(_surfaceKey));
    final firstMorph = tester.widget<Morph>(find.ancestor(of: find.byKey(_surfaceKey), matching: find.byType(Morph)));
    expect(firstMorph.child, same(firstSurface));
    final second = MateoSheet.show<int>(
      context,
      presentation: const MateoSheetPresentation.bottom(),
      child: const SizedBox(height: 100, child: Text('Second')),
    );
    await tester.pump();
    final secondRoute = ModalRoute.of(tester.element(find.text('Second')))!;
    expect(secondRoute.transitionDuration, const Duration(milliseconds: 350));
    expect(secondRoute.reverseTransitionDuration, const Duration(milliseconds: 350));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));
    expect(tester.takeException(), isNull);
    final surfaces = tester.widgetList<Morph>(find.byType(Morph)).where((morph) => morph.child.key == _surfaceKey);
    expect(surfaces, hasLength(2));
    expect(surfaces.map((morph) => morph.tag).toSet(), hasLength(1));
    final closeMorphs = tester.widgetList<Morph>(find.byType(Morph)).where((morph) => morph.child.key == _closeKey);
    expect(closeMorphs.length, greaterThanOrEqualTo(2));
    expect(closeMorphs.map((morph) => morph.tag).toSet(), hasLength(1));
    final flights = find.byWidgetPredicate((widget) => widget.runtimeType.toString() == '_MorphFlightBoundary');
    final bounds = tester
        .renderObjectList<RenderBox>(flights)
        .map((box) => box.localToGlobal(Offset.zero) & box.size)
        .toList();
    final surfaceBounds = bounds.singleWhere((rect) => rect.width == 376);
    final closeBounds = bounds.singleWhere((rect) => rect.width == 50);
    expect(surfaceBounds.height, inExclusiveRange(140, 340));
    expect(surfaceBounds.bottom, closeTo(788, 0.01));
    expect(closeBounds.top, closeTo(surfaceBounds.top + 20, 0.01));
    await tester.pump(const Duration(milliseconds: 270));
    expect(secondRoute.animation!.value, 1);
    await tester.pumpAndSettle();
    Navigator.of(context).pop(20);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(secondRoute.animation!.value, 0);
    await tester.pumpAndSettle();
    expect(await second, 20);
    expect(find.text('First').hitTestable(), findsOneWidget);
    Navigator.of(context).pop(10);
    await tester.pumpAndSettle();
    expect(await first, 10);
    expect(tester.takeException(), isNull);
  });

  testWidgets('when closing the top sheet, it should return one level and retain the editor state', (tester) async {
    final context = await _pumpStack(tester);
    final editorKey = GlobalKey();
    final controller = TextEditingController(text: 'Saved draft');
    addTearDown(controller.dispose);
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: TextField(key: editorKey, controller: controller),
      ),
    );
    await tester.pumpAndSettle();
    final editorState = editorKey.currentState;
    unawaited(
      MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        child: const SizedBox(height: 300, child: Text('Second')),
      ),
    );
    await tester.pumpAndSettle();
    expect(editorKey.currentState, same(editorState));
    expect(find.text('Saved draft').hitTestable(), findsNothing);
    await tester.tap(find.byKey(_closeKey).hitTestable());
    await tester.pumpAndSettle();
    expect(editorKey.currentState, same(editorState));
    expect(controller.text, 'Saved draft');
    expect(find.text('Second'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final drag in [false, true]) {
    testWidgets(
      'when ${drag ? 'dragging' : 'tapping the scrim'} with three sheets, it should dismiss the entire stack',
      (
        tester,
      ) async {
        final context = await _pumpStack(tester);
        final results = <Future<void>>[];
        for (var index = 0; index < 3; index++) {
          results.add(
            MateoSheet.show<void>(
              context,
              presentation: const MateoSheetPresentation.bottom(),
              child: SizedBox(height: 120 + index * 40, child: Text('$index')),
            ),
          );
          await tester.pumpAndSettle();
        }
        if (drag) {
          await tester.flingFrom(const Offset(200, 150), const Offset(0, 220), 1000);
        } else {
          await tester.tapAt(const Offset(200, 150));
        }
        await tester.pumpAndSettle();
        expect(find.byKey(_surfaceKey), findsNothing);
        await Future.wait(results);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('when a middle sheet refuses ${drag ? 'a drag' : 'a scrim tap'}, it should return to that sheet', (
      tester,
    ) async {
      final context = await _pumpStack(tester);
      final decisions = <String>[];
      unawaited(
        MateoSheet.show<void>(
          context,
          presentation: const MateoSheetPresentation.bottom(),
          shouldDismiss: (_) {
            decisions.add('first');
            return true;
          },
          child: const Text('First'),
        ),
      );
      await tester.pumpAndSettle();
      unawaited(
        MateoSheet.show<void>(
          context,
          presentation: const MateoSheetPresentation.bottom(),
          shouldDismiss: (source) {
            decisions.add('middle:$source');
            return false;
          },
          child: const SizedBox(height: 250, child: Text('Protected')),
        ),
      );
      await tester.pumpAndSettle();
      final top = MateoSheet.show<void>(
        context,
        presentation: const MateoSheetPresentation.bottom(),
        shouldDismiss: (_) {
          decisions.add('top');
          return true;
        },
        child: const SizedBox(height: 100, child: Text('Top')),
      );
      await tester.pumpAndSettle();
      if (drag) {
        await tester.flingFrom(const Offset(200, 150), const Offset(0, 220), 1000);
      } else {
        await tester.tapAt(const Offset(200, 150));
      }
      await tester.pumpAndSettle();
      await top;
      expect(decisions, [
        'top',
        'middle:${drag ? MateoSheetDismissSource.drag : MateoSheetDismissSource.tapOutside}',
      ]);
      expect(find.text('Protected').hitTestable(), findsOneWidget);
      expect(find.text('Top'), findsNothing);
      expect(find.text('First').hitTestable(), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'when a stack guard is pending, it should ignore repeated requests and preserve the stack until resolved',
    (tester) async {
      final context = await _pumpStack(tester);
      final decision = Completer<bool>();
      var calls = 0;
      unawaited(
        MateoSheet.show<void>(
          context,
          presentation: const MateoSheetPresentation.bottom(),
          child: const Text('First'),
        ),
      );
      await tester.pumpAndSettle();
      unawaited(
        MateoSheet.show<void>(
          context,
          presentation: const MateoSheetPresentation.bottom(),
          shouldDismiss: (_) {
            calls++;
            return decision.future;
          },
          child: const Text('Second'),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(200, 150));
      await tester.pump();
      await tester.tapAt(const Offset(200, 150));
      await tester.pump();
      expect(calls, 1);
      expect(find.byKey(_surfaceKey), findsNWidgets(2));
      decision.complete(true);
      await tester.pumpAndSettle();
      expect(find.byKey(_surfaceKey), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}

Future<BuildContext> _pumpStack(WidgetTester tester, {bool disableAnimations = false}) async {
  await tester.binding.setSurfaceSize(const Size(400, 800));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  late BuildContext sheetContext;
  await tester.pumpWidget(
    MaterialApp(
      theme: mateoTestTheme,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: disableAnimations),
        child: child!,
      ),
      home: Scaffold(
        body: Builder(
          builder: (context) {
            sheetContext = context;
            return const Text('Page');
          },
        ),
      ),
    ),
  );
  return sheetContext;
}
