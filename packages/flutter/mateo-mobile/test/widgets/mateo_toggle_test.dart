import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
Widget host(Widget child, {bool reduced = false, bool ticker = true, TextDirection direction = TextDirection.ltr}) =>
    Directionality(
      textDirection: direction,
      child: MediaQuery(
        data: MediaQueryData(disableAnimations: reduced),
        child: TickerMode(
          enabled: ticker,
          child: MateoTheme(
            data: theme,
            child: Center(child: child),
          ),
        ),
      ),
    );

class _Canvas extends Fake implements Canvas {
  final paths = <({Rect bounds, Color color})>[];
  @override
  void drawPath(Path path, Paint paint) => paths.add((bounds: path.getBounds(), color: paint.color));
}

List<({Rect bounds, Color color})> drawing(WidgetTester tester) {
  final finder = find.descendant(of: find.byType(MateoToggle), matching: find.byType(CustomPaint));
  final canvas = _Canvas();
  tester.widget<CustomPaint>(finder).painter!.paint(canvas, tester.getSize(finder));
  return canvas.paths;
}

// Matches the toggle callback.
// ignore: avoid_positional_boolean_parameters
void ignore(bool value) {}

void main() {
  testWidgets('when locally owned, it should toggle once per tap and expose switch semantics', (tester) async {
    final semantics = tester.ensureSemantics();

    var calls = 0;
    await tester.pumpWidget(
      host(
        MateoToggle(
          semanticsLabel: 'Notifications',
          onChanged: (value) {
            expect(value, isTrue);
            calls++;
          },
        ),
      ),
    );
    expect(tester.getSize(find.byType(MateoToggle)), const Size(78, 48));
    expect(drawing(tester).last.bounds, rectMoreOrLessEquals(const Rect.fromLTWH(4, 10, 39, 28), epsilon: 0.00001));
    await tester.tap(find.byType(MateoToggle));
    await tester.pumpAndSettle();
    expect(calls, 1);
    expect(
      tester.getSemantics(find.byType(MateoToggle)),
      matchesSemantics(
        label: 'Notifications',
        hasEnabledState: true,
        isEnabled: true,
        hasToggledState: true,
        isToggled: true,
        hasTapAction: true,
      ),
    );
    expect(drawing(tester).last.bounds.left, closeTo(35, 0.00001));
    semantics.dispose();
  });
  testWidgets('when disabled, it should ignore taps and retain logical position', (tester) async {
    final controller = MateoToggleController(value: true);
    addTearDown(controller.dispose);
    await tester.pumpWidget(host(MateoToggle(controller: controller)));
    await tester.tap(find.byType(MateoToggle));
    await tester.pumpAndSettle();
    expect(controller.value, isTrue);
    expect(drawing(tester).first.color, isSameColorAs(theme.colorScheme.toggle.trackDisabled));
    expect(drawing(tester).last.color, isSameColorAs(theme.colorScheme.toggle.thumbDisabled));
  });
  testWidgets('when activated through semantics, it should change value with one haptic', (tester) async {
    final semantics = tester.ensureSemantics();

    final calls = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      calls.add(call);
      return null;
    });
    addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));
    final controller = MateoToggleController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(host(MateoToggle(controller: controller, onChanged: ignore)));
    tester
        .renderObject(find.byType(MateoToggle))
        .owner!
        .semanticsOwner!
        .performAction(
          tester.getSemantics(find.byType(MateoToggle)).id,
          SemanticsAction.tap,
        );
    await tester.pumpAndSettle();
    expect(controller.value, isTrue);
    expect(calls.where((call) => call.method == 'HapticFeedback.vibrate'), hasLength(1));
    unawaited(controller.toggle());
    await tester.pumpAndSettle();
    expect(calls.where((call) => call.method == 'HapticFeedback.vibrate'), hasLength(1));
    semantics.dispose();
  });
  for (final direction in TextDirection.values) {
    testWidgets('when dragged in $direction, it should commit only at release', (tester) async {
      final controller = MateoToggleController();
      addTearDown(controller.dispose);
      var calls = 0;
      await tester.pumpWidget(
        host(
          MateoToggle(
            controller: controller,
            onChanged: (_) {
              calls++;
            },
          ),
          direction: direction,
        ),
      );
      final sign = direction == TextDirection.ltr ? 1.0 : -1.0;
      final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoToggle)));
      await gesture.moveBy(Offset(20 * sign, 0));
      await gesture.moveBy(Offset(18 * sign, 0));
      await tester.pump(const Duration(milliseconds: 100));
      expect(controller.value, isFalse);
      await gesture.up();
      await tester.pumpAndSettle();
      expect(controller.value, isTrue);
      expect(calls, 1);
      expect(drawing(tester).last.bounds.left, closeTo(direction == TextDirection.ltr ? 35 : 4, 0.00001));
    });
  }
  testWidgets('when cancelled, it should return without notifying', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      host(
        MateoToggle(
          onChanged: (_) {
            calls++;
          },
        ),
      ),
    );
    final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoToggle)));
    await gesture.moveBy(const Offset(20, 0));
    await gesture.moveBy(const Offset(12, 0));
    await tester.pump();
    await gesture.cancel();
    await tester.pumpAndSettle();
    expect(calls, 0);
    expect(drawing(tester).last.bounds.left, closeTo(4, 0.00001));
  });
  testWidgets('when reversed, it should preserve position and velocity and complete both futures', (tester) async {
    final controller = MateoToggleController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(host(MateoToggle(controller: controller, onChanged: ignore)));
    var firstDone = false;
    var secondDone = false;
    unawaited(
      controller.toggle().then((_) {
        firstDone = true;
      }),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));
    final before = drawing(tester).last.bounds.left;
    unawaited(
      controller.toggle().then((_) {
        secondDone = true;
      }),
    );
    expect(drawing(tester).last.bounds.left, before);
    await tester.pump();
    expect(firstDone, isTrue);
    expect(secondDone, isFalse);
    await tester.pump(const Duration(milliseconds: 1));
    expect(drawing(tester).last.bounds.left, greaterThan(before));
    await tester.pumpAndSettle();
    expect(secondDone, isTrue);
    expect(drawing(tester).last.bounds.left, closeTo(4, 0.00001));
  });
  testWidgets('when spring motion peaks, it should rebound without extrapolating color', (tester) async {
    final controller = MateoToggleController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(host(MateoToggle(controller: controller, onChanged: ignore)));
    unawaited(controller.toggle());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 131));
    expect(drawing(tester).last.bounds.left, inExclusiveRange(37, 39));
    expect(drawing(tester).first.color, isSameColorAs(theme.colorScheme.toggle.trackOn));
    await tester.pump(const Duration(milliseconds: 269));
    expect(drawing(tester).last.bounds.left, closeTo(35, 0.03));
    await tester.pumpAndSettle();
    expect(drawing(tester).last.bounds.left, closeTo(35, 0.00001));
  });
  for (final mode in ['reduced', 'muted', 'disabled', 'removed']) {
    testWidgets('when $mode interrupts motion, it should settle the future and stop ticking', (tester) async {
      final controller = MateoToggleController();
      addTearDown(controller.dispose);
      Widget toggle() => MateoToggle(controller: controller, onChanged: ignore);
      await tester.pumpWidget(host(toggle()));
      var done = false;
      unawaited(
        controller.toggle().then((_) {
          done = true;
        }),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpWidget(
        host(
          mode == 'removed'
              ? const SizedBox()
              : mode == 'disabled'
              ? MateoToggle(controller: controller)
              : toggle(),
          reduced: mode == 'reduced',
          ticker: mode != 'muted',
        ),
      );
      await tester.pump();
      expect(done, isTrue);
      expect(tester.binding.transientCallbackCount, 0);
      if (mode != 'removed') expect(drawing(tester).last.bounds.left, closeTo(35, 0.00001));
    });
  }
  testWidgets('when reduced motion is active, it should complete immediately', (tester) async {
    final controller = MateoToggleController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(host(MateoToggle(controller: controller, onChanged: ignore), reduced: true));
    var done = false;
    unawaited(
      controller.toggle().then((_) {
        done = true;
      }),
    );
    await tester.pump();
    expect(done, isTrue);
    expect(drawing(tester).last.bounds.left, closeTo(35, 0.00001));
  });
  testWidgets('when controllers change, it should detach, complete and preserve internal state', (tester) async {
    final first = MateoToggleController();
    final second = MateoToggleController(value: true);
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    await tester.pumpWidget(host(MateoToggle(controller: first, onChanged: ignore)));
    var done = false;
    unawaited(
      first.toggle().then((_) {
        done = true;
      }),
    );
    await tester.pump();
    await tester.pumpWidget(host(MateoToggle(controller: second, onChanged: ignore)));
    expect(done, isTrue);
    expect(first.hasClients, isFalse);
    expect(second.hasClients, isTrue);
    expect(drawing(tester).last.bounds.left, closeTo(35, 0.00001));
    await tester.pumpWidget(host(const MateoToggle(onChanged: ignore)));
    expect(second.hasClients, isFalse);
    expect(drawing(tester).last.bounds.left, closeTo(35, 0.00001));
  });
  testWidgets('when attached twice, it should reject the second attachment', (tester) async {
    final controller = MateoToggleController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      host(
        Stack(
          children: [
            MateoToggle(controller: controller),
            MateoToggle(controller: controller),
          ],
        ),
      ),
    );
    expect(tester.takeException(), isA<FlutterError>());
    expect(controller.hasClients, isTrue);
    await tester.pumpWidget(const SizedBox());
    expect(controller.hasClients, isFalse);
  });
  testWidgets('when the same value is requested, it should return the active future', (tester) async {
    final controller = MateoToggleController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(host(MateoToggle(controller: controller, onChanged: ignore)));
    final first = controller.setValue(true);
    expect(identical(first, controller.setValue(true)), isTrue);
    await tester.pumpAndSettle();
    await first;
  });
  test('when detached, it should notify synchronously and complete commands', () async {
    final controller = MateoToggleController();
    addTearDown(controller.dispose);
    var calls = 0;
    controller.addListener(() {
      calls++;
    });
    final future = controller.toggle();
    expect(calls, 1);
    expect(controller.value, isTrue);
    expect(controller.hasClients, isFalse);
    await future;
  });
  testWidgets('when grabbed during rebound, it should move from the visible position without snapping', (tester) async {
    final controller = MateoToggleController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(host(MateoToggle(controller: controller, onChanged: ignore)));
    unawaited(controller.toggle());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 131));
    final before = drawing(tester).last.bounds.left;
    final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoToggle)));
    await gesture.moveBy(const Offset(-20, 0));
    await gesture.moveBy(const Offset(-0.25, 0));
    expect(drawing(tester).last.bounds.left, closeTo(before - 0.25, 0.00001));
    await gesture.cancel();
    await tester.pumpAndSettle();
  });

  testWidgets('when a drag is disabled, it should cancel without activation', (tester) async {
    final controller = MateoToggleController();
    addTearDown(controller.dispose);
    var calls = 0;
    await tester.pumpWidget(
      host(
        MateoToggle(
          controller: controller,
          onChanged: (_) {
            calls++;
          },
        ),
      ),
    );
    final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoToggle)));
    await gesture.moveBy(const Offset(20, 0));
    await gesture.moveBy(const Offset(12, 0));
    await tester.pumpWidget(host(MateoToggle(controller: controller)));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(calls, 0);
    expect(controller.value, isFalse);
    expect(drawing(tester).last.bounds.left, closeTo(4, 0.00001));
  });

  testWidgets('when dragged back before halfway, it should return without a value change', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      host(
        MateoToggle(
          onChanged: (_) {
            calls++;
          },
        ),
      ),
    );
    final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoToggle)));
    await gesture.moveBy(const Offset(20, 0));
    await gesture.moveBy(const Offset(4, 0));
    await tester.pump(const Duration(milliseconds: 200));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(calls, 0);
    expect(drawing(tester).last.bounds.left, closeTo(4, 0.00001));
  });

  testWidgets('when reversed before the first frame, it should complete without a stale ticker', (tester) async {
    final controller = MateoToggleController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(host(MateoToggle(controller: controller, onChanged: ignore)));
    final first = controller.toggle();
    final second = controller.toggle();
    await tester.pumpAndSettle();
    await Future.wait([first, second]);
    expect(controller.value, isFalse);
    expect(drawing(tester).last.bounds.left, closeTo(4, 0.00001));
  });

  testWidgets('when a listener retargets synchronously, each command should retain its own future', (tester) async {
    final controller = MateoToggleController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(host(MateoToggle(controller: controller, onChanged: ignore)));
    Future<void>? reversal;
    controller.addListener(() {
      if (controller.value) reversal = controller.setValue(false);
    });
    final original = controller.setValue(true);
    expect(identical(original, reversal), isFalse);
    await tester.pumpAndSettle();
    await original;
    await reversal;
    expect(controller.value, isFalse);
  });

  testWidgets('when a nested theme is supplied, it should use its toggle colors', (tester) async {
    final nestedTheme = theme.copyWith(accentColor: const Color(0xFF00A86B));
    final colors = nestedTheme.colorScheme.toggle;
    await tester.pumpWidget(
      host(
        MateoTheme(
          data: nestedTheme,
          child: const MateoToggle(onChanged: ignore),
        ),
      ),
    );
    expect(drawing(tester).first.color, isSameColorAs(colors.trackOff));
    expect(drawing(tester).last.color, isSameColorAs(colors.thumbOff));
    await tester.tap(find.byType(MateoToggle));
    await tester.pumpAndSettle();
    expect(drawing(tester).first.color, isSameColorAs(colors.trackOn));
    expect(drawing(tester).last.color, isSameColorAs(colors.thumbOn));
  });
}
