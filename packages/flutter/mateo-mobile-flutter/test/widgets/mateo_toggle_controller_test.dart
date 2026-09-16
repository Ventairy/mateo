import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  group('when using MateoToggleController without a toggle', () {
    test('when created, it should expose its initial value and no clients', () {
      final controller = MateoToggleController(value: true);
      addTearDown(controller.dispose);
      expect(controller.value, isTrue);
      expect(controller.hasClients, isFalse);
    });

    test('when a detached command changes value, it should notify synchronously and complete immediately', () async {
      final controller = MateoToggleController();
      addTearDown(controller.dispose);
      var notifications = 0;
      controller.addListener(() => notifications += 1);
      final animation = controller.setValue(true);
      expect(controller.value, isTrue);
      expect(notifications, 1);
      await expectLater(animation, completes);
    });

    test('when toggled while detached, it should reverse its logical value', () async {
      final controller = MateoToggleController();
      addTearDown(controller.dispose);
      await controller.toggle();
      expect(controller.value, isTrue);
    });

    test('when a listener is removed, it should stop receiving changes', () {
      final controller = MateoToggleController();
      addTearDown(controller.dispose);
      var notifications = 0;
      void listener() => notifications += 1;
      controller
        ..addListener(listener)
        ..removeListener(listener)
        ..setValue(true);
      expect(notifications, 0);
    });

    test('when disposed, it should reject new listeners', () {
      final controller = MateoToggleController()..dispose();

      expect(() => controller.addListener(() {}), throwsFlutterError);
    });
  });

  group('when using MateoToggleController with a toggle', () {
    testWidgets('when attached and removed, it should report its client lifecycle', (tester) async {
      final controller = MateoToggleController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(TestApp(child: MateoToggle(controller: controller)));
      expect(controller.hasClients, isTrue);
      await tester.pumpWidget(const TestApp(child: SizedBox()));
      expect(controller.hasClients, isFalse);
    });

    testWidgets('when the same value is set during a transition, it should return the active future', (tester) async {
      final controller = MateoToggleController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        TestApp(
          child: MateoToggle(controller: controller, onChanged: _ignoreChange),
        ),
      );
      final first = controller.setValue(true);
      final repeated = controller.setValue(true);
      expect(identical(first, repeated), isTrue);
      await tester.pumpAndSettle();
      await expectLater(first, completes);
    });

    testWidgets('when a command is retargeted, it should complete the superseded future immediately', (tester) async {
      final controller = MateoToggleController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        TestApp(
          child: MateoToggle(controller: controller, onChanged: _ignoreChange),
        ),
      );
      var firstCompleted = false;
      var secondCompleted = false;
      controller.setValue(true).then((_) => firstCompleted = true);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));
      controller.setValue(false).then((_) => secondCompleted = true);
      await tester.pump();
      expect(firstCompleted, isTrue);
      expect(secondCompleted, isFalse);
      await tester.pumpAndSettle();
      expect(secondCompleted, isTrue);
    });

    testWidgets('when attached to two toggles, it should throw a FlutterError', (tester) async {
      final controller = MateoToggleController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        TestApp(
          child: Stack(
            children: [
              MateoToggle(controller: controller),
              MateoToggle(controller: controller),
            ],
          ),
        ),
      );
      expect(tester.takeException(), isA<FlutterError>());
    });

    testWidgets('when controllers are replaced, it should settle and adopt the replacement immediately', (
      tester,
    ) async {
      final first = MateoToggleController();
      final second = MateoToggleController(value: true);
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      final key = GlobalKey<_ControllerReplacementState>();
      await tester.pumpWidget(_ControllerReplacement(key: key, first: first, second: second));
      var firstAnimationCompleted = false;
      first.setValue(true).then((_) => firstAnimationCompleted = true);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));
      key.currentState!.useSecond();
      await tester.pump();
      expect(first.hasClients, isFalse);
      expect(firstAnimationCompleted, isTrue);
      expect(second.hasClients, isTrue);
      expect(_positionOf(tester), 1);
    });

    testWidgets('when switching to internal ownership, it should preserve the current logical value', (tester) async {
      final controller = MateoToggleController(value: true);
      addTearDown(controller.dispose);
      final key = GlobalKey<_ExternalToInternalState>();
      await tester.pumpWidget(_ExternalToInternal(key: key, controller: controller));
      key.currentState!.useInternal();
      await tester.pump();
      expect(controller.hasClients, isFalse);
      expect(_positionOf(tester), 1);
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

class _ControllerReplacement extends StatefulWidget {
  const _ControllerReplacement({super.key, required this.first, required this.second});

  final MateoToggleController first;
  final MateoToggleController second;

  @override
  State<_ControllerReplacement> createState() => _ControllerReplacementState();
}

class _ControllerReplacementState extends State<_ControllerReplacement> {
  var _useSecond = false;

  void useSecond() => setState(() => _useSecond = true);

  @override
  Widget build(BuildContext context) => TestApp(
    child: MateoToggle(
      controller: _useSecond ? widget.second : widget.first,
      onChanged: _ignoreChange,
    ),
  );
}

class _ExternalToInternal extends StatefulWidget {
  const _ExternalToInternal({super.key, required this.controller});

  final MateoToggleController controller;

  @override
  State<_ExternalToInternal> createState() => _ExternalToInternalState();
}

class _ExternalToInternalState extends State<_ExternalToInternal> {
  var _useInternal = false;

  void useInternal() => setState(() => _useInternal = true);

  @override
  Widget build(BuildContext context) => TestApp(
    child: MateoToggle(
      controller: _useInternal ? null : widget.controller,
      onChanged: _ignoreChange,
    ),
  );
}
