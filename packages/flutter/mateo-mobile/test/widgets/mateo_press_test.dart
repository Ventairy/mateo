import 'dart:async';

import 'package:flutter/rendering.dart';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

Widget host(Widget child, {bool reducedMotion = false, bool tickerEnabled = true}) => Directionality(
  textDirection: .ltr,
  child: MediaQuery(
    data: MediaQueryData(disableAnimations: reducedMotion),
    child: TickerMode(
      enabled: tickerEnabled,
      child: Center(child: SizedBox(width: 160, height: 80, child: child)),
    ),
  ),
);

double scale(WidgetTester tester) {
  final press = tester.widget<MateoPress>(find.byType(MateoPress));
  final child = tester.renderObject<RenderBox>(find.byWidget(press.child));
  final target = tester.renderObject<RenderBox>(find.byType(MateoPress));
  return child.getTransformTo(target).storage[0];
}

Iterable<OpacityLayer> opacityLayers(WidgetTester tester) =>
    tester.layerListOf(find.byType(MateoPress)).whereType<OpacityLayer>();

void main() {
  testWidgets('when no style is supplied, it should default to scale', (tester) async {
    await tester.pumpWidget(host(MateoPress(onPressed: (_) {}, child: const Text('Press'))));
    expect(tester.widget<MateoPress>(find.byType(MateoPress)).animation, MateoPressAnimationType.scale);
    final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoPress)));
    await tester.pumpAndSettle();
    expect(scale(tester), closeTo(0.96, 0.001));
    expect(opacityLayers(tester), isEmpty);
    await gesture.up();
    await tester.pumpAndSettle();
    expect(scale(tester), 1);
  });

  for (final animation in MateoPressAnimationType.values) {
    testWidgets('when $animation is pressed, it should apply its feedback and settle its future', (tester) async {
      var calls = 0;
      var completed = false;
      await tester.pumpWidget(
        host(
          MateoPress(
            animation: animation,
            onPressed: (release) async {
              calls++;
              await release;
              completed = true;
            },
            child: const Text('Press'),
          ),
        ),
      );
      final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoPress)));
      await tester.pumpAndSettle();
      expect(scale(tester), animation == .none ? 1 : closeTo(0.96, 0.001));
      if (animation == .scaleFade) {
        expect(opacityLayers(tester).single.alpha, 102);
      } else {
        expect(opacityLayers(tester), isEmpty);
      }
      await gesture.up();
      expect(calls, 1);
      await tester.pumpAndSettle();
      expect(completed, isTrue);
      expect(scale(tester), 1);
      expect(opacityLayers(tester), isEmpty);
      expect(tester.binding.transientCallbackCount, 0);
    });
  }

  testWidgets('when a quick tap ends, it should finish press-in before releasing', (tester) async {
    var completed = false;
    await tester.pumpWidget(
      host(
        MateoPress(
          onPressed: (release) async {
            await release;
            completed = true;
          },
          child: const Text('Press'),
        ),
      ),
    );
    await tester.tap(find.byType(MateoPress));
    expect(completed, isFalse);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    expect(scale(tester), closeTo(0.96, 0.001));
    expect(completed, isFalse);
    await tester.pumpAndSettle();
    expect(scale(tester), 1);
    expect(completed, isTrue);
  });

  testWidgets('when re-pressed during release, it should settle both futures without getting stuck', (tester) async {
    var completed = 0;
    await tester.pumpWidget(
      host(
        MateoPress(
          onPressed: (release) async {
            await release;
            completed++;
          },
          child: const Text('Press'),
        ),
      ),
    );
    final first = await tester.startGesture(tester.getCenter(find.byType(MateoPress)));
    await tester.pumpAndSettle();
    await first.up();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 40));
    await tester.tap(find.byType(MateoPress));
    await tester.pumpAndSettle();
    expect(completed, 2);
    expect(scale(tester), 1);
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('when cancelled, it should end the press without activating', (tester) async {
    final changes = <bool>[];
    var calls = 0;
    await tester.pumpWidget(
      host(
        MateoPress(
          onPressed: (_) => calls++,
          onPressChanged: changes.add,
          child: const Text('Press'),
        ),
      ),
    );
    final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoPress)));
    await tester.pump(const Duration(milliseconds: 120));
    await gesture.cancel();
    await tester.pumpAndSettle();
    expect(changes, [true, false]);
    expect(calls, 0);
    expect(scale(tester), 1);
  });

  testWidgets('when disabled while held, it should report one release without activating', (tester) async {
    final changes = <bool>[];
    var calls = 0;
    Widget view({required bool enabled}) => host(
      MateoPress(
        onPressed: enabled ? (_) => calls++ : null,
        onPressChanged: changes.add,
        child: const Text('Press'),
      ),
    );
    await tester.pumpWidget(view(enabled: true));
    final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoPress)));
    await tester.pumpAndSettle();
    await tester.pumpWidget(view(enabled: false));
    expect(changes, [true, false]);
    expect(scale(tester), 1);
    await gesture.up();
    await tester.pumpAndSettle();
    expect(changes, [true, false]);
    expect(calls, 0);
  });

  testWidgets('when disabled after a quick tap, it should finish feedback while rejecting new input', (tester) async {
    var calls = 0;
    var completed = false;
    Widget view({required bool enabled}) => host(
      MateoPress(
        onPressed: enabled
            ? (animation) async {
                calls++;
                await animation;
                completed = true;
              }
            : null,
        child: const Text('Press'),
      ),
    );
    await tester.pumpWidget(view(enabled: true));
    await tester.tap(find.byType(MateoPress));
    await tester.pumpWidget(view(enabled: false));
    expect(completed, isFalse);
    await tester.tap(find.byType(MateoPress));
    expect(calls, 1);
    await tester.pump(const Duration(milliseconds: 150));
    expect(scale(tester), closeTo(0.96, 0.001));
    expect(completed, isFalse);
    for (var frame = 0; frame < 12; frame++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(scale(tester), 1);
    expect(completed, isTrue);
    expect(tester.binding.transientCallbackCount, 0);
  });

  for (final interruption in ['mode', 'reduced motion', 'ticker', 'remove']) {
    testWidgets('when release is interrupted by $interruption, it should complete its future', (tester) async {
      var completed = false;
      Widget view({bool interrupted = false}) => host(
        interrupted && interruption == 'remove'
            ? const SizedBox()
            : MateoPress(
                animation: interrupted && interruption == 'mode' ? .none : .scaleFade,
                onPressed: (release) async {
                  await release;
                  completed = true;
                },
                child: const Text('Press'),
              ),
        reducedMotion: interrupted && interruption == 'reduced motion',
        tickerEnabled: !(interrupted && interruption == 'ticker'),
      );
      await tester.pumpWidget(view());
      await tester.tap(find.byType(MateoPress));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 30));
      await tester.pumpWidget(view(interrupted: true));
      await tester.pump();
      expect(completed, isTrue);
      if (interruption != 'remove') {
        expect(scale(tester), 1);
        expect(opacityLayers(tester), isEmpty);
      }
      expect(tester.binding.transientCallbackCount, 0);
    });
  }

  testWidgets('when onPressed throws synchronously, it should still finish release feedback', (tester) async {
    Future<void>? release;
    await tester.pumpWidget(
      host(
        MateoPress(
          onPressed: (animation) {
            release = animation;
            throw StateError('action failed');
          },
          child: const Text('Press'),
        ),
      ),
    );
    await tester.tap(find.byType(MateoPress));
    expect(tester.takeException(), isA<StateError>());
    var completed = false;
    unawaited(release!.then((_) => completed = true));
    await tester.pumpAndSettle();
    expect(completed, isTrue);
    expect(scale(tester), 1);
  });

  testWidgets('when reduced motion is enabled, it should activate without visual feedback', (tester) async {
    var completed = false;
    await tester.pumpWidget(
      host(
        MateoPress(
          animation: .scaleFade,
          onPressed: (release) async {
            await release;
            completed = true;
          },
          child: const Text('Press'),
        ),
        reducedMotion: true,
      ),
    );
    final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoPress)));
    await tester.pumpAndSettle();
    expect(scale(tester), 1);
    expect(opacityLayers(tester), isEmpty);
    await gesture.up();
    await tester.pump();
    expect(completed, isTrue);
  });

  testWidgets('when pressing inner whitespace, it should activate the same target', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      host(
        MateoPress(
          onPressed: (_) => calls++,
          child: const Padding(padding: .all(20), child: Text('Press')),
        ),
      ),
    );
    await tester.tapAt(tester.getTopLeft(find.byType(MateoPress)) + const Offset(2, 2));
    expect(calls, 1);
    await tester.pumpAndSettle();
  });

  testWidgets('when styles change or animate, it should preserve child state and render identity', (tester) async {
    var builds = 0;
    final child = StatefulBuilder(
      builder: (_, _) {
        builds++;
        return const Text('Press', key: ValueKey('content'));
      },
    );
    Widget view(MateoPressAnimationType animation) => host(
      MateoPress(
        animation: animation,
        onPressed: (_) {},
        child: child,
      ),
    );
    await tester.pumpWidget(view(.scale));
    final state = tester.state(find.byType(StatefulBuilder));
    final render = tester.renderObject(find.byKey(const ValueKey('content')));
    for (final animation in MateoPressAnimationType.values) {
      await tester.pumpWidget(view(animation));
      await tester.tap(find.byType(MateoPress));
      await tester.pumpAndSettle();
      expect(tester.state(find.byType(StatefulBuilder)), same(state));
      expect(tester.renderObject(find.byKey(const ValueKey('content'))), same(render));
      expect(opacityLayers(tester), isEmpty);
    }
    expect(builds, 1);
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('when pointer feedback is enabled, it should honor the haptic option', (tester) async {
    final haptics = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'HapticFeedback.vibrate') haptics.add(call);
      return null;
    });
    addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));
    for (final enabled in [true, false]) {
      await tester.pumpWidget(
        host(
          MateoPress(
            fireHapticFeedback: enabled,
            onPressed: (_) {},
            child: const Text('Press'),
          ),
        ),
      );
      await tester.tap(find.byType(MateoPress));
      await tester.pumpAndSettle();
    }
    expect(haptics, hasLength(1));
    expect(haptics.single.arguments, 'HapticFeedbackType.lightImpact');
  });

  testWidgets('when screen-reader activation occurs, it should expose one action and skip pointer feedback', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var calls = 0;
    var completed = false;
    final changes = <bool>[];
    await tester.pumpWidget(
      host(
        MateoPress(
          onPressed: (release) async {
            calls++;
            await release;
            completed = true;
          },
          onPressChanged: changes.add,
          child: const Text('Press'),
        ),
      ),
    );
    final node = tester.getSemantics(find.byType(MateoPress));
    expect(
      node,
      matchesSemantics(
        label: 'Press',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    tester.binding.platformDispatcher.onSemanticsActionEvent!(
      SemanticsActionEvent(type: SemanticsAction.tap, nodeId: node.id, viewId: tester.view.viewId),
    );
    await tester.pump();
    expect(calls, 1);
    expect(completed, isTrue);
    expect(changes, isEmpty);
    expect(scale(tester), 1);
    semantics.dispose();
  });

  testWidgets('when a label is supplied or disabled, it should expose the intended semantics', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      host(
        const MateoPress(
          semanticLabel: 'Open details',
          child: Text('Decorative'),
        ),
      ),
    );
    expect(
      tester.getSemantics(find.byType(MateoPress)),
      matchesSemantics(
        label: 'Open details',
        isButton: true,
        hasEnabledState: true,
        isEnabled: false,
      ),
    );
    expect(find.bySemanticsLabel('Decorative'), findsNothing);
    await tester.tap(find.byType(MateoPress));
    await tester.pumpAndSettle();
    expect(scale(tester), 1);
    semantics.dispose();
  });
  testWidgets('when a scroll wins the gesture, it should cancel without activating the item', (tester) async {
    var calls = 0;
    final changes = <bool>[];
    await tester.pumpWidget(
      host(
        SingleChildScrollView(
          child: MateoPress(
            onPressed: (_) => calls++,
            onPressChanged: changes.add,
            child: const SizedBox(height: 600, child: Text('Item')),
          ),
        ),
      ),
    );
    final gesture = await tester.startGesture(
      tester.getTopLeft(find.byType(SingleChildScrollView)) + const Offset(30, 30),
    );
    await tester.pump(const Duration(milliseconds: 120));
    await gesture.moveBy(const Offset(0, -50));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(changes, [true, false]);
    expect(calls, 0);
    expect(scale(tester), 1);
  });

  testWidgets('when reduced motion changes during a held press, it should reset feedback and still activate', (
    tester,
  ) async {
    var completed = false;
    Widget view({required bool reduced}) => host(
      MateoPress(
        animation: .scaleFade,
        onPressed: (release) async {
          await release;
          completed = true;
        },
        child: const Text('Press'),
      ),
      reducedMotion: reduced,
    );
    await tester.pumpWidget(view(reduced: false));
    final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoPress)));
    await tester.pumpAndSettle();
    await tester.pumpWidget(view(reduced: true));
    expect(scale(tester), 1);
    expect(opacityLayers(tester), isEmpty);
    await gesture.up();
    await tester.pump();
    expect(completed, isTrue);
  });

  testWidgets('when removed while held, it should not call application code during disposal', (tester) async {
    final changes = <bool>[];
    await tester.pumpWidget(
      host(
        MateoPress(
          onPressed: (_) {},
          onPressChanged: changes.add,
          child: const Text('Press'),
        ),
      ),
    );
    final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoPress)));
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox());
    await gesture.up();
    expect(changes, [true]);
    expect(tester.takeException(), isNull);
  });
  testWidgets('when reparented during a press, it should preserve child state and reset feedback', (tester) async {
    final key = GlobalKey();
    final child = StatefulBuilder(builder: (_, _) => const Text('Press'));
    Widget view({required bool moved}) {
      final press = MateoPress(key: key, onPressed: (_) {}, child: child);
      return host(
        Row(
          children: [
            Expanded(child: moved ? const SizedBox() : press),
            Expanded(child: moved ? press : const SizedBox()),
          ],
        ),
      );
    }

    await tester.pumpWidget(view(moved: false));
    final state = tester.state(find.byType(StatefulBuilder));
    final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoPress)));
    await tester.pumpAndSettle();
    await tester.pumpWidget(view(moved: true));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(tester.state(find.byType(StatefulBuilder)), same(state));
    expect(scale(tester), 1);
    expect(tester.takeException(), isNull);
    await tester.tap(find.byType(MateoPress));
    await tester.pumpAndSettle();
    expect(scale(tester), 1);
  });
  testWidgets('when scale ticks, it should avoid the widget rebuilds required by ScaleTransition', (tester) async {
    final previous = debugOnRebuildDirtyWidget;
    addTearDown(() => debugOnRebuildDirtyWidget = previous);
    final controller = AnimationController(vsync: tester, duration: const Duration(milliseconds: 150));
    addTearDown(controller.dispose);
    var stockBuilds = 0;
    await tester.pumpWidget(host(ScaleTransition(scale: controller, child: const Text('Stock'))));
    debugOnRebuildDirtyWidget = (element, _) {
      if (element.widget is ScaleTransition) stockBuilds++;
    };
    controller.forward();
    await tester.pump();
    for (var frame = 0; frame < 10; frame++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(stockBuilds, greaterThan(0));
    debugOnRebuildDirtyWidget = previous;

    await tester.pumpWidget(host(MateoPress(onPressed: (_) {}, child: const Text('Press'))));
    var pressBuilds = 0;
    debugOnRebuildDirtyWidget = (element, _) {
      var insidePress = element.widget is MateoPress;
      element.visitAncestorElements((ancestor) {
        if (ancestor.widget is MateoPress) insidePress = true;
        return !insidePress;
      });
      if (insidePress) pressBuilds++;
    };
    final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoPress)));
    await tester.pump();
    for (var frame = 0; frame < 10; frame++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(scale(tester), closeTo(0.96, 0.001));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(pressBuilds, 0);
    debugOnRebuildDirtyWidget = previous;
  });

  testWidgets('when held content is hit, it should translate pointer positions through the centered scale', (
    tester,
  ) async {
    final positions = <Offset>[];
    const childKey = ValueKey('scaled hit target');
    await tester.pumpWidget(
      host(
        MateoPress(
          onPressed: (_) {},
          child: Listener(
            key: childKey,
            behavior: .opaque,
            onPointerDown: (event) => positions.add(event.localPosition),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
    final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoPress)), pointer: 1);
    await tester.pumpAndSettle();
    final second = await tester.startGesture(
      tester.getTopLeft(find.byKey(childKey)) + const Offset(12, 12),
      pointer: 2,
    );
    expect(positions.last.dx, closeTo(12 / 0.96, 0.001));
    expect(positions.last.dy, closeTo(12 / 0.96, 0.001));
    await second.up();
    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('when resized while held, it should keep the scale centered in the new bounds', (tester) async {
    const childKey = ValueKey('scaled content');
    Widget view(double width) => Directionality(
      textDirection: .ltr,
      child: Center(
        child: SizedBox(
          width: width,
          height: 80,
          child: MateoPress(
            onPressed: (_) {},
            child: const SizedBox.expand(key: childKey),
          ),
        ),
      ),
    );
    await tester.pumpWidget(view(160));
    final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoPress)));
    await tester.pumpAndSettle();
    await tester.pumpWidget(view(240));
    final press = tester.renderObject<RenderBox>(find.byType(MateoPress));
    final child = tester.renderObject<RenderBox>(find.byKey(childKey));
    final transform = child.getTransformTo(press);
    expect(transform.storage[0], closeTo(0.96, 0.001));
    expect(transform.storage[12], closeTo(240 * 0.02, 0.001));
    expect(transform.storage[13], closeTo(80 * 0.02, 0.001));
    expect(child.size, const Size(240, 80));
    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('when composited scale settles, it should release its transform layer', (tester) async {
    await tester.pumpWidget(
      host(
        RepaintBoundary(
          child: MateoPress(
            onPressed: (_) {},
            child: const RepaintBoundary(child: SizedBox.expand()),
          ),
        ),
      ),
    );
    Iterable<TransformLayer> layers() => tester.layerListOf(find.byType(MateoPress)).whereType<TransformLayer>();
    expect(layers(), isEmpty);
    final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoPress)));
    await tester.pumpAndSettle();
    expect(layers(), hasLength(1));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(layers(), isEmpty);
    expect(tester.binding.transientCallbackCount, 0);
  });
  testWidgets('when pressed semantics are queried, it should preserve target bounds and transform child geometry', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    const childKey = ValueKey('semantic child');
    await tester.pumpWidget(
      host(
        MateoPress(
          onPressed: (_) {},
          child: Semantics(
            key: childKey,
            container: true,
            label: 'Inner',
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
    final target = tester.getSemantics(find.byType(MateoPress));
    final targetRect = target.rect;
    final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoPress)));
    await tester.pumpAndSettle();
    final child = tester.getSemantics(find.byKey(childKey));
    expect(target.rect, targetRect);
    expect(child.transform!.storage[0], closeTo(0.96, 0.001));
    expect(child.transform!.storage[12], closeTo(160 * 0.02, 0.001));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(child.transform?.storage[0] ?? 1, 1);
    handle.dispose();
  });
}
