import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show OpacityLayer;
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

final _tapFinder = find.byType(MateoTap);

Finder _scaleWithinTap() => find.descendant(of: _tapFinder, matching: find.byType(ScaleTransition));
Finder _fadeWithinTap() => find.descendant(of: _tapFinder, matching: find.byType(FadeTransition));

Iterable<OpacityLayer> _opacityLayersWithinTap(WidgetTester tester) =>
    tester.layerListOf(_tapFinder).whereType<OpacityLayer>();

void main() {
  group('MateoTap', () {
    testWidgets('when onPressed is synchronous and tapped, it should call onPressed', (tester) async {
      var tapCount = 0;

      await tester.pumpWidget(
        TestApp(
          child: MateoTap(
            onPressed: (animation) {
              tapCount += 1;
            },
            child: const Text('Tap'),
          ),
        ),
      );

      await tester.tap(find.text('Tap'));
      await tester.pump(const Duration(milliseconds: 800));

      expect(tapCount, equals(1));
    });

    testWidgets('when enabled, it should expose enabled button semantics', (tester) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(
        TestApp(
          child: MateoTap(
            onPressed: (animation) async {},
            child: const Text('Tap'),
          ),
        ),
      );

      final data = tester.getSemantics(_tapFinder).getSemanticsData();
      semantics.dispose();

      expect(
        (
          button: data.flagsCollection.isButton,
          enabled: data.flagsCollection.isEnabled,
          tap: data.hasAction(SemanticsAction.tap),
        ),
        (button: true, enabled: Tristate.isTrue, tap: true),
      );
    });

    testWidgets('when disabled, it should expose disabled button semantics without a tap action', (tester) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(const TestApp(child: MateoTap(child: Text('Tap'))));

      final data = tester.getSemantics(_tapFinder).getSemanticsData();
      semantics.dispose();

      expect(
        (
          button: data.flagsCollection.isButton,
          enabled: data.flagsCollection.isEnabled,
          tap: data.hasAction(SemanticsAction.tap),
        ),
        (button: true, enabled: Tristate.isFalse, tap: false),
      );
    });

    testWidgets('when activated through semantics, it should call onPressed once with a completed animation', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      var pressCount = 0;
      var animationCompleted = false;

      await tester.pumpWidget(
        TestApp(
          child: MateoTap(
            onPressed: (animation) async {
              pressCount += 1;
              await animation;
              animationCompleted = true;
            },
            child: const Text('Tap'),
          ),
        ),
      );

      final node = tester.getSemantics(_tapFinder);
      node.owner!.performAction(node.id, SemanticsAction.tap);
      await tester.pump();
      semantics.dispose();

      expect(
        (pressCount: pressCount, animationCompleted: animationCompleted),
        (pressCount: 1, animationCompleted: true),
      );
    });

    testWidgets('when activated through semantics, it should skip pointer feedback and haptics', (tester) async {
      final semantics = tester.ensureSemantics();
      final hapticCalls = <MethodCall>[];
      var pressChangeCount = 0;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) {
        if (call.method.startsWith('HapticFeedback')) hapticCalls.add(call);
        return null;
      });

      await tester.pumpWidget(
        TestApp(
          child: MateoTap(
            onPressed: (animation) async {},
            onPressChanged: (_) => pressChangeCount += 1,
            child: const Text('Tap'),
          ),
        ),
      );

      final node = tester.getSemantics(_tapFinder);
      node.owner!.performAction(node.id, SemanticsAction.tap);
      await tester.pump();
      semantics.dispose();

      expect((pressChanges: pressChangeCount, haptics: hapticCalls.length), (pressChanges: 0, haptics: 0));
    });

    testWidgets('when semanticLabel is omitted, it should preserve descendant text semantics', (tester) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(
        TestApp(
          child: MateoTap(
            onPressed: (animation) async {},
            child: const Text('Descendant label'),
          ),
        ),
      );

      final descendantLabels = find.bySemanticsLabel('Descendant label').evaluate().length;
      semantics.dispose();

      expect(descendantLabels, 1);
    });

    testWidgets('when semanticLabel is provided, it should replace descendant semantics', (tester) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(
        TestApp(
          child: MateoTap(
            semanticLabel: 'Custom label',
            onPressed: (animation) async {},
            child: const Text('Descendant label'),
          ),
        ),
      );

      final labels = (
        customLabels: find.bySemanticsLabel('Custom label').evaluate().length,
        descendantLabels: find.bySemanticsLabel('Descendant label').evaluate().length,
      );
      semantics.dispose();

      expect(
        labels,
        (customLabels: 1, descendantLabels: 0),
      );
    });

    testWidgets('when pressed, it should apply pressed opacity', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: MateoTap(
            onPressed: (animation) async {},
            child: const Text('Tap'),
          ),
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Tap')),
      );

      await tester.pumpAndSettle();

      expect(_opacityLayersWithinTap(tester).single.alpha, 102);

      await gesture.up();
      await tester.pump(const Duration(milliseconds: 800));
    });

    testWidgets('when scale-fade feedback is idle, it should not retain an opacity layer', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: MateoTap(
            onPressed: (animation) async {},
            child: const Text('Tap'),
          ),
        ),
      );

      expect(_opacityLayersWithinTap(tester), isEmpty);

      final gesture = await tester.startGesture(tester.getCenter(find.text('Tap')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));

      final alpha = _opacityLayersWithinTap(tester).single.alpha;
      expect(alpha, greaterThan(102));
      expect(alpha, lessThan(255));

      await gesture.up();
      await tester.pumpAndSettle();

      expect(_opacityLayersWithinTap(tester), isEmpty);
      expect(tester.binding.hasScheduledFrame, isFalse);
      expect(tester.binding.transientCallbackCount, 0);
    });

    testWidgets('when scale-fade feedback presses and releases, it should retain child state and render identity', (
      tester,
    ) async {
      const childKey = Key('stateful tap content');
      var childBuilds = 0;
      await tester.pumpWidget(
        TestApp(
          child: MateoTap(
            onPressed: (_) {},
            child: StatefulBuilder(
              builder: (_, _) {
                childBuilds++;
                return const Text('Tap', key: childKey);
              },
            ),
          ),
        ),
      );
      final childState = tester.state(find.byType(StatefulBuilder));
      final childRender = tester.renderObject(find.byKey(childKey));

      for (var press = 0; press < 3; press++) {
        final gesture = await tester.startGesture(tester.getCenter(find.byKey(childKey)));
        await tester.pumpAndSettle();
        expect(tester.state(find.byType(StatefulBuilder)), same(childState));
        expect(tester.renderObject(find.byKey(childKey)), same(childRender));
        expect(_opacityLayersWithinTap(tester).single.alpha, 102);
        await gesture.up();
        await tester.pumpAndSettle();
        expect(tester.state(find.byType(StatefulBuilder)), same(childState));
        expect(tester.renderObject(find.byKey(childKey)), same(childRender));
        expect(_opacityLayersWithinTap(tester), isEmpty);
      }

      expect(childBuilds, 1);
      expect(tester.binding.hasScheduledFrame, isFalse);
      expect(tester.binding.transientCallbackCount, 0);
      for (var frame = 0; frame < 5; frame++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      expect(childBuilds, 1);
      expect(tester.binding.hasScheduledFrame, isFalse);
      expect(tester.binding.transientCallbackCount, 0);
    });

    testWidgets('when pressed, it should apply pressed scale', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: MateoTap(
            onPressed: (animation) async {},
            child: const Text('Tap'),
          ),
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Tap')),
      );

      await tester.pumpAndSettle();

      final scale = tester.widget<ScaleTransition>(_scaleWithinTap());

      expect(scale.scale.value, closeTo(0.96, 0.001));

      await gesture.up();
      await tester.pump(const Duration(milliseconds: 800));
    });

    testWidgets(
      'when disableAnimations is enabled, it should skip pressed visual state',
      (tester) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: TestApp(
              child: MateoTap(
                onPressed: (animation) async {},
                child: const Text('Tap'),
              ),
            ),
          ),
        );

        final gesture = await tester.startGesture(
          tester.getCenter(find.text('Tap')),
        );
        await tester.pump(const Duration(milliseconds: 45));

        final scale = tester.widget<ScaleTransition>(_scaleWithinTap());

        expect(scale.scale.value, equals(1.0));

        await gesture.up();
        await tester.pump(const Duration(milliseconds: 800));
      },
    );

    testWidgets('when disabled and tapped, it should not call onPressed', (
      tester,
    ) async {
      const tapCount = 0;

      await tester.pumpWidget(
        const TestApp(child: MateoTap(child: Text('Tap'))),
      );

      await tester.tap(find.text('Tap'));

      expect(tapCount, equals(0));
    });

    testWidgets('when tapped down, it should call HapticFeedback.lightImpact', (
      tester,
    ) async {
      final hapticCalls = <MethodCall>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) {
          if (call.method.startsWith('HapticFeedback')) hapticCalls.add(call);
          return null;
        },
      );

      await tester.pumpWidget(
        TestApp(
          child: MateoTap(
            onPressed: (animation) async {},
            child: const Text('Tap'),
          ),
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Tap')),
      );
      await tester.pump();

      expect(hapticCalls, hasLength(1));
      expect(hapticCalls[0].method, equals('HapticFeedback.vibrate'));

      await gesture.up();
      await tester.pump(const Duration(milliseconds: 800));
    });

    testWidgets(
      'when disabled and tapped down, it should not call HapticFeedback',
      (tester) async {
        final hapticCalls = <MethodCall>[];
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          (call) {
            if (call.method.startsWith('HapticFeedback')) hapticCalls.add(call);
            return null;
          },
        );

        await tester.pumpWidget(
          const TestApp(child: MateoTap(child: Text('Tap'))),
        );

        final gesture = await tester.startGesture(
          tester.getCenter(find.text('Tap')),
        );
        await tester.pump();

        expect(hapticCalls, isEmpty);

        addTearDown(gesture.up);
      },
    );

    testWidgets(
      'when fireHapticFeedback is true, it should fire haptic feedback',
      (tester) async {
        final hapticCalls = <MethodCall>[];
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          (call) {
            if (call.method.startsWith('HapticFeedback')) hapticCalls.add(call);
            return null;
          },
        );

        await tester.pumpWidget(
          TestApp(
            child: MateoTap(
              fireHapticFeedback: true,
              onPressed: (animation) async {},
              child: const Text('Tap'),
            ),
          ),
        );

        final gesture = await tester.startGesture(
          tester.getCenter(find.text('Tap')),
        );
        await tester.pump();

        expect(hapticCalls, hasLength(1));
        expect(hapticCalls[0].method, equals('HapticFeedback.vibrate'));

        await gesture.up();
        await tester.pump(const Duration(milliseconds: 800));
      },
    );

    testWidgets(
      'when fireHapticFeedback is false, it should not fire haptic feedback',
      (tester) async {
        final hapticCalls = <MethodCall>[];
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          (call) {
            if (call.method.startsWith('HapticFeedback')) hapticCalls.add(call);
            return null;
          },
        );

        await tester.pumpWidget(
          TestApp(
            child: MateoTap(
              fireHapticFeedback: false,
              onPressed: (animation) async {},
              child: const Text('Tap'),
            ),
          ),
        );

        final gesture = await tester.startGesture(
          tester.getCenter(find.text('Tap')),
        );
        await tester.pump();

        expect(hapticCalls, isEmpty);

        addTearDown(gesture.up);
      },
    );

    testWidgets(
      'when scale animation type is used, it should render ScaleTransition without FadeTransition',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoTap(
              animation: MateoTapAnimationType.scale,
              onPressed: (animation) async {},
              child: const Text('Tap'),
            ),
          ),
        );

        expect(_scaleWithinTap(), findsOneWidget);
        expect(_fadeWithinTap(), findsNothing);
      },
    );

    testWidgets(
      'when scale animation type is used and pressed, it should apply pressed scale',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoTap(
              animation: MateoTapAnimationType.scale,
              onPressed: (animation) async {},
              child: const Text('Tap'),
            ),
          ),
        );

        final gesture = await tester.startGesture(
          tester.getCenter(find.text('Tap')),
        );

        await tester.pumpAndSettle();

        final scale = tester.widget<ScaleTransition>(_scaleWithinTap());

        expect(scale.scale.value, closeTo(0.96, 0.001));

        await gesture.up();
        await tester.pump(const Duration(milliseconds: 800));
      },
    );

    testWidgets(
      'when animation future is awaited, it should complete after release duration',
      (tester) async {
        var animationCompleted = false;

        await tester.pumpWidget(
          TestApp(
            child: MateoTap(
              onPressed: (animation) async {
                await animation;
                animationCompleted = true;
              },
              child: const Text('Tap'),
            ),
          ),
        );

        await tester.tap(find.text('Tap'));

        expect(animationCompleted, isFalse);

        await tester.pumpAndSettle();

        expect(animationCompleted, isTrue);
      },
    );

    testWidgets(
      'when tapped very fast, it should still reach the full pressed scale before releasing',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoTap(
              onPressed: (animation) async {},
              child: const Text('Tap'),
            ),
          ),
        );

        final gesture = await tester.startGesture(
          tester.getCenter(find.text('Tap')),
        );
        await tester.pump(const Duration(milliseconds: 16));
        await gesture.up();

        for (var i = 0; i < 8; i++) {
          await tester.pump(const Duration(milliseconds: 16));
        }

        final scale = tester.widget<ScaleTransition>(_scaleWithinTap());
        expect(scale.scale.value, closeTo(0.96, 0.001));

        await tester.pumpAndSettle();
        expect(scale.scale.value, closeTo(1.0, 0.001));
      },
    );

    testWidgets(
      'when none animation type is used, it should not render ScaleTransition or FadeTransition',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoTap(
              animation: MateoTapAnimationType.none,
              onPressed: (animation) async {},
              child: const Text('Tap'),
            ),
          ),
        );

        expect(
          find.descendant(
            of: _tapFinder,
            matching: find.byType(ScaleTransition),
          ),
          findsNothing,
        );
        expect(
          find.descendant(
            of: _tapFinder,
            matching: find.byType(FadeTransition),
          ),
          findsNothing,
        );
      },
    );

    testWidgets(
      'when none animation type and tapped, it should call onPressed immediately',
      (tester) async {
        var tapCount = 0;

        await tester.pumpWidget(
          TestApp(
            child: MateoTap(
              animation: MateoTapAnimationType.none,
              onPressed: (animation) async {
                tapCount += 1;
              },
              child: const Text('Tap'),
            ),
          ),
        );

        await tester.tap(find.text('Tap'));
        await tester.pump();

        expect(tapCount, equals(1));
      },
    );

    testWidgets(
      'when none animation type and disabled, it should not call onPressed',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoTap(
              animation: MateoTapAnimationType.none,
              child: const Text('Tap'),
            ),
          ),
        );

        final gesture = await tester.startGesture(
          tester.getCenter(find.text('Tap')),
        );
        await tester.pump();

        expect(
          find.descendant(
            of: _tapFinder,
            matching: find.byType(ScaleTransition),
          ),
          findsNothing,
        );
        expect(
          find.descendant(
            of: _tapFinder,
            matching: find.byType(FadeTransition),
          ),
          findsNothing,
        );

        await gesture.up();
        await tester.pump();
      },
    );
  });
}
