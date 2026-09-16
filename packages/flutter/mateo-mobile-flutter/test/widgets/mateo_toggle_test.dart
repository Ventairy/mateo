import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  group('when rendering MateoToggle', () {
    testWidgets('when no controller is supplied, it should default to off', (tester) async {
      await tester.pumpWidget(const TestApp(child: MateoToggle(onChanged: _ignoreChange)));
      expect(_positionOf(tester), 0);
    });

    testWidgets('when an initialized controller is supplied, it should render its value immediately', (tester) async {
      final controller = MateoToggleController(value: true);
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        TestApp(
          child: MateoToggle(controller: controller, onChanged: _ignoreChange),
        ),
      );
      expect(_positionOf(tester), 1);
    });

    testWidgets('when rendered, it should use the Mateo touch target size', (tester) async {
      await tester.pumpWidget(const TestApp(child: MateoToggle(onChanged: _ignoreChange)));
      expect(tester.getSize(find.byType(MateoToggle)), const Size(58, 48));
      expect(
        find.descendant(of: find.byType(MateoToggle), matching: find.byType(RepaintBoundary)),
        findsOneWidget,
      );
    });

    testWidgets('when custom colors are supplied, it should retain them', (tester) async {
      const colors = MateoToggleColorScheme(
        trackOn: Colors.green,
        trackOff: Colors.red,
        trackDisabled: Colors.grey,
        circleOn: Colors.white,
        circleOff: Colors.black,
        circleDisabled: Colors.blueGrey,
      );
      await tester.pumpWidget(
        const TestApp(
          child: MateoToggle(onChanged: _ignoreChange, colorScheme: colors),
        ),
      );
      expect(_painterOf(tester).colorScheme, colors);
    });
  });

  group('when interacting with MateoToggle', () {
    testWidgets('when tapped without an external controller, it should retain the new state across rebuilds', (
      tester,
    ) async {
      late StateSetter rebuild;
      bool? requestedValue;
      await tester.pumpWidget(
        TestApp(
          child: StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return MateoToggle(onChanged: (value, animation) => requestedValue = value);
            },
          ),
        ),
      );
      await tester.tap(find.byType(MateoToggle));
      expect(requestedValue, isTrue);
      await tester.pumpAndSettle();
      expect(_positionOf(tester), 1);
      rebuild(() {});
      await tester.pump();
      expect(_positionOf(tester), 1);
    });

    testWidgets('when tapped, it should update the controller before invoking the callback', (tester) async {
      final controller = MateoToggleController();
      addTearDown(controller.dispose);
      bool? valueSeenInCallback;
      Future<void>? callbackAnimation;
      await tester.pumpWidget(
        TestApp(
          child: MateoToggle(
            controller: controller,
            onChanged: (value, animation) {
              valueSeenInCallback = controller.value;
              callbackAnimation = animation;
            },
          ),
        ),
      );
      await tester.tap(find.byType(MateoToggle));
      expect(controller.value, isTrue);
      expect(valueSeenInCallback, isTrue);
      expect(callbackAnimation, isNotNull);
      expect(identical(callbackAnimation, controller.setValue(true)), isTrue);
    });

    testWidgets('when disabled and tapped, it should remain inert', (tester) async {
      final controller = MateoToggleController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(TestApp(child: MateoToggle(controller: controller)));
      await tester.tap(find.byType(MateoToggle));
      expect(controller.value, isFalse);
      expect(_positionOf(tester), 0);
      expect(_painterOf(tester).enabled, isFalse);
    });

    testWidgets('when dragged past the midpoint, it should change to on', (tester) async {
      final controller = MateoToggleController();
      addTearDown(controller.dispose);
      bool? requestedValue;
      await tester.pumpWidget(
        TestApp(
          child: MateoToggle(
            controller: controller,
            onChanged: (value, animation) => requestedValue = value,
          ),
        ),
      );
      final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoToggle)));
      await gesture.moveBy(const Offset(20, 0));
      await gesture.moveBy(const Offset(20, 0));
      await gesture.up();
      expect(requestedValue, isTrue);
      expect(controller.value, isTrue);
    });

    testWidgets('when dragged short of the midpoint, it should return off', (tester) async {
      final controller = MateoToggleController();
      addTearDown(controller.dispose);
      bool? requestedValue;
      await tester.pumpWidget(
        TestApp(
          child: MateoToggle(
            controller: controller,
            onChanged: (value, animation) => requestedValue = value,
          ),
        ),
      );
      final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoToggle)));
      await gesture.moveBy(const Offset(20, 0));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(requestedValue, isNull);
      expect(controller.value, isFalse);
      expect(_positionOf(tester), 0);
    });

    testWidgets('when a drag is cancelled, it should return to its controller value', (tester) async {
      await tester.pumpWidget(const TestApp(child: MateoToggle(onChanged: _ignoreChange)));
      final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoToggle)));
      await gesture.moveBy(const Offset(20, 0));
      await gesture.moveBy(const Offset(10, 0));
      await gesture.cancel();
      await tester.pumpAndSettle();
      expect(_positionOf(tester), 0);
    });

    testWidgets('when dragged in RTL, it should reverse the physical direction', (tester) async {
      final controller = MateoToggleController();
      addTearDown(controller.dispose);
      bool? requestedValue;
      await tester.pumpWidget(
        TestApp(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: MateoToggle(
              controller: controller,
              onChanged: (value, animation) => requestedValue = value,
            ),
          ),
        ),
      );
      final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoToggle)));
      await gesture.moveBy(const Offset(-20, 0));
      await gesture.moveBy(const Offset(-20, 0));
      await gesture.up();
      expect(requestedValue, isTrue);
      expect(_painterOf(tester).textDirection, TextDirection.rtl);
    });

    testWidgets('when a user change occurs, it should fire one light haptic', (tester) async {
      final hapticCalls = <MethodCall>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) {
        if (call.method.startsWith('HapticFeedback')) hapticCalls.add(call);
        return null;
      });
      await tester.pumpWidget(const TestApp(child: MateoToggle(onChanged: _ignoreChange)));
      await tester.tap(find.byType(MateoToggle));
      expect(hapticCalls, hasLength(1));
      expect(hapticCalls.single.method, 'HapticFeedback.vibrate');
      expect(hapticCalls.single.arguments, 'HapticFeedbackType.lightImpact');
    });

    testWidgets('when the callback awaits animation, it should complete after the toggle settles', (tester) async {
      late Future<void> animation;
      var animationCompleted = false;
      await tester.pumpWidget(
        TestApp(
          child: MateoToggle(
            onChanged: (value, transition) {
              animation = transition;
              transition.then((_) => animationCompleted = true);
            },
          ),
        ),
      );
      await tester.tap(find.byType(MateoToggle));
      expect(animationCompleted, isFalse);
      await tester.pump(const Duration(milliseconds: 399));
      expect(animationCompleted, isFalse);
      await tester.pumpAndSettle();
      await animation;
      expect(animationCompleted, isTrue);
      expect(_positionOf(tester), 1);
    });
  });

  group('when exposing MateoToggle semantics', () {
    testWidgets('when enabled, it should expose its label, value, and action', (tester) async {
      final semantics = tester.ensureSemantics();
      final controller = MateoToggleController();
      addTearDown(controller.dispose);
      bool? requestedValue;
      await tester.pumpWidget(
        TestApp(
          child: MateoToggle(
            controller: controller,
            semanticsLabel: 'Notifications',
            onChanged: (value, animation) => requestedValue = value,
          ),
        ),
      );
      final outer = tester.widget<Semantics>(
        find.descendant(
          of: find.byType(MateoToggle),
          matching: find.byWidgetPredicate(
            (widget) => widget is Semantics && widget.properties.toggled != null,
          ),
        ),
      );
      final node = tester.getSemantics(find.byType(MateoToggle));
      expect(outer.properties.label, 'Notifications');
      expect(outer.properties.toggled, isFalse);
      expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
      node.owner!.performAction(node.id, SemanticsAction.tap);
      await tester.pump();
      expect(requestedValue, isTrue);
      expect(controller.value, isTrue);
      semantics.dispose();
    });

    testWidgets('when disabled, it should expose disabled semantics and the controller value', (tester) async {
      final controller = MateoToggleController(value: true);
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        TestApp(
          child: MateoToggle(controller: controller, semanticsLabel: 'Notifications'),
        ),
      );
      final semanticsWidgets = tester.widgetList<Semantics>(
        find.descendant(of: find.byType(MateoToggle), matching: find.byType(Semantics)),
      );
      expect(semanticsWidgets.any((widget) => widget.properties.enabled == false), isTrue);
      expect(semanticsWidgets.any((widget) => widget.properties.toggled == true), isTrue);
    });
  });

  group('when changing MateoToggle programmatically', () {
    testWidgets('when the controller changes, it should use a solid glide without user effects', (tester) async {
      final controller = MateoToggleController();
      addTearDown(controller.dispose);
      final hapticCalls = <MethodCall>[];
      var callbackCount = 0;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) {
        if (call.method.startsWith('HapticFeedback')) hapticCalls.add(call);
        return null;
      });
      await tester.pumpWidget(
        TestApp(
          child: MateoToggle(
            controller: controller,
            onChanged: (value, animation) => callbackCount += 1,
          ),
        ),
      );
      final animation = controller.setValue(true);
      expect(controller.value, isTrue);
      expect(_positionOf(tester), 0);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(_positionOf(tester), greaterThan(0.5));
      await tester.pumpAndSettle();
      await animation;
      expect(_positionOf(tester), 1);
      expect(callbackCount, 0);
      expect(hapticCalls, isEmpty);
    });

    testWidgets('when disabled and changed by its controller, it should still animate', (tester) async {
      final controller = MateoToggleController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(TestApp(child: MateoToggle(controller: controller)));
      final animation = controller.setValue(true);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(_positionOf(tester), greaterThan(0.5));
      await tester.pumpAndSettle();
      await animation;
      expect(_positionOf(tester), 1);
      expect(_painterOf(tester).enabled, isFalse);
    });

    testWidgets('when retargeted, it should continue from the visible position', (tester) async {
      final controller = MateoToggleController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        TestApp(
          child: MateoToggle(controller: controller, onChanged: _ignoreChange),
        ),
      );
      controller.setValue(true);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));
      final visiblePosition = _positionOf(tester);
      controller.setValue(false);
      expect(_positionOf(tester), closeTo(visiblePosition, 0.001));
      await tester.pumpAndSettle();
      expect(_positionOf(tester), 0);
    });

    testWidgets('when animations are disabled, it should update and complete immediately', (tester) async {
      final controller = MateoToggleController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        TestApp(
          child: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: MateoToggle(controller: controller, onChanged: _ignoreChange),
          ),
        ),
      );
      final animation = controller.setValue(true);
      var completed = false;
      animation.then((_) => completed = true);
      await tester.pump();
      expect(completed, isTrue);
      expect(_positionOf(tester), 1);
      expect(tester.binding.hasScheduledFrame, isFalse);
    });
  });
}

void _ignoreChange(bool value, Future<void> animation) {}

dynamic _painterOf(WidgetTester tester) => tester
    .widget<CustomPaint>(
      find.descendant(of: find.byType(MateoToggle), matching: find.byType(CustomPaint)),
    )
    .painter;

double _positionOf(WidgetTester tester) => (_painterOf(tester).position as Animation<double>).value;
