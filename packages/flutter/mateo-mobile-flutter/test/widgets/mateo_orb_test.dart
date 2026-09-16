import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  group('when constructing MateoOrb', () {
    test('when size is negative, it should throw AssertionError', () {
      expect(() => MateoOrb(size: -1), throwsA(isA<AssertionError>()));
    });

    test('when size is infinite, it should throw AssertionError', () {
      expect(
        () => MateoOrb(size: double.infinity),
        throwsA(isA<AssertionError>()),
      );
    });

    test('when size is NaN, it should throw AssertionError', () {
      expect(
        () => MateoOrb(size: double.nan),
        throwsA(isA<AssertionError>()),
      );
    });

    test('when size is zero, it should construct normally', () {
      expect(() => const MateoOrb(size: 0), returnsNormally);
    });
  });

  group('when using MateoOrbColorScheme', () {
    const first = MateoOrbColorScheme(
      background: Color(0xFF4A5CFF),
      smoke: Color(0xFFFBFCFD),
    );
    const second = MateoOrbColorScheme(
      background: Color(0xFFFB2C36),
      smoke: Color(0xFFFFFAFA),
    );

    test('when values are unchanged, it should compare by value', () {
      expect(
        first,
        const MateoOrbColorScheme(
          background: Color(0xFF4A5CFF),
          smoke: Color(0xFFFBFCFD),
        ),
      );
    });

    test('when copying one role, it should preserve the other role', () {
      final copied = first.copyWith(background: second.background);

      expect(copied.background, second.background);
      expect(copied.smoke, first.smoke);
    });

    test('when interpolating halfway, it should blend both roles', () {
      final blended = MateoOrbColorScheme.lerp(first, second, 0.5);

      expect(
        blended.background,
        Color.lerp(first.background, second.background, 0.5),
      );
      expect(blended.smoke, Color.lerp(first.smoke, second.smoke, 0.5));
    });
  });

  group('when laying out MateoOrb', () {
    testWidgets(
      'when size is supplied, it should use the requested square dimensions',
      (tester) async {
        await tester.pumpWidget(const TestApp(child: MateoOrb(size: 72)));

        expect(_paintSize(tester), const Size.square(72));
      },
    );

    testWidgets(
      'when parent dimensions differ, it should use the shortest dimension',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(
            child: SizedBox(
              width: 96,
              height: 64,
              child: MateoOrb(),
            ),
          ),
        );

        expect(_paintSize(tester), const Size.square(64));
      },
    );

    testWidgets(
      'when only height is bounded, it should use the bounded dimension',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(
            child: UnconstrainedBox(
              constrainedAxis: Axis.vertical,
              child: SizedBox(height: 72, child: MateoOrb()),
            ),
          ),
        );

        expect(_paintSize(tester), const Size.square(72));
      },
    );

    testWidgets(
      'when both parent axes are unbounded, it should use the 48 pixel fallback',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(child: UnconstrainedBox(child: MateoOrb())),
        );

        expect(_paintSize(tester), const Size.square(48));
      },
    );
  });

  group('when painting MateoOrb', () {
    testWidgets(
      'when colors are omitted, it should use primary step 9 and neutral step 1',
      (tester) async {
        await tester.pumpWidget(const TestApp(child: MateoOrb(size: 72)));

        final painter = _painterOf(tester);
        expect(painter.background, mateoTestPalette.accent[9]);
        expect(painter.smoke, mateoTestPalette.neutral[1]);
      },
    );

    testWidgets('when colors are supplied, it should use the custom scheme', (
      tester,
    ) async {
      const colorScheme = MateoOrbColorScheme(
        background: Color(0xFFFB2C36),
        smoke: Color(0xFFFFFAFA),
      );
      await tester.pumpWidget(
        const TestApp(
          child: MateoOrb(size: 72, colorScheme: colorScheme),
        ),
      );

      final painter = _painterOf(tester);
      expect(painter.background, colorScheme.background);
      expect(painter.smoke, colorScheme.smoke);
    });

    testWidgets(
      'when the shader loads, it should replace the fallback painter input',
      (tester) async {
        await tester.pumpWidget(const TestApp(child: MateoOrb(size: 72)));

        await _waitForShader(tester);

        expect(_painterOf(tester).shader, isNotNull);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when rendered, it should isolate the painter in a RepaintBoundary',
      (tester) async {
        await tester.pumpWidget(const TestApp(child: MateoOrb(size: 72)));

        expect(
          find.descendant(
            of: find.byType(MateoOrb),
            matching: find.byType(RepaintBoundary),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'when rendered, it should not add component-owned semantics',
      (tester) async {
        await tester.pumpWidget(const TestApp(child: MateoOrb(size: 72)));

        expect(
          find.descendant(
            of: find.byType(MateoOrb),
            matching: find.byType(Semantics),
          ),
          findsNothing,
        );
      },
    );
  });

  group('when animating MateoOrb', () {
    testWidgets('when animate is omitted, it should hold the time-zero frame', (
      tester,
    ) async {
      await tester.pumpWidget(const TestApp(child: MateoOrb(size: 72)));
      await _waitForShader(tester);
      final timeBefore = _timeOf(tester);

      await tester.pump(const Duration(milliseconds: 1200));

      expect(timeBefore, 0);
      expect(_timeOf(tester), timeBefore);
      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets(
      'when one internal segment wraps, it should keep elapsed time continuous',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(child: MateoOrb(size: 72, animate: true)),
        );
        await _waitForShader(tester);

        await tester.pump(const Duration(milliseconds: 900));
        final beforeWrap = _timeOf(tester);
        await tester.pump(const Duration(milliseconds: 200));
        final afterWrap = _timeOf(tester);

        expect(beforeWrap, closeTo(0.9, 0.02));
        expect(afterWrap, closeTo(1.1, 0.02));
        expect(afterWrap, greaterThan(beforeWrap));
      },
    );

    testWidgets(
      'when a frame advances, it should repaint without rebuilding CustomPaint',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(child: MateoOrb(size: 72, animate: true)),
        );
        await _waitForShader(tester);
        final customPaintBefore = tester.widget<CustomPaint>(
          _orbPaintFinder(),
        );

        await tester.pump(const Duration(milliseconds: 100));
        final customPaintAfter = tester.widget<CustomPaint>(_orbPaintFinder());

        expect(identical(customPaintAfter, customPaintBefore), isTrue);
        expect(_timeOf(tester), greaterThan(0));
      },
    );

    testWidgets(
      'when animate changes, it should freeze and resume the visible phase',
      (tester) async {
        const key = ValueKey('orb');
        await tester.pumpWidget(
          const TestApp(child: MateoOrb(key: key, size: 72, animate: true)),
        );
        await _waitForShader(tester);
        await tester.pump(const Duration(milliseconds: 300));

        await tester.pumpWidget(
          const TestApp(child: MateoOrb(key: key, size: 72)),
        );
        final frozenTime = _timeOf(tester);
        await tester.pump(const Duration(milliseconds: 300));
        expect(_timeOf(tester), frozenTime);

        await tester.pumpWidget(
          const TestApp(child: MateoOrb(key: key, size: 72, animate: true)),
        );
        await tester.pump(const Duration(milliseconds: 100));
        expect(_timeOf(tester), greaterThan(frozenTime));
      },
    );

    testWidgets(
      'when animations are disabled, it should keep the visible phase static',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: MateoOrb(size: 72, animate: true),
            ),
          ),
        );
        await _waitForShader(tester);
        final timeBefore = _timeOf(tester);

        await tester.pump(const Duration(milliseconds: 300));

        expect(timeBefore, 0);
        expect(_timeOf(tester), timeBefore);
        expect(tester.binding.hasScheduledFrame, isFalse);
      },
    );

    testWidgets(
      'when TickerMode is disabled, it should preserve its phase until resumed',
      (tester) async {
        final tickerEnabled = ValueNotifier(false);
        addTearDown(tickerEnabled.dispose);
        await tester.pumpWidget(
          TestApp(
            child: ValueListenableBuilder(
              valueListenable: tickerEnabled,
              builder: (context, enabled, child) {
                return TickerMode(enabled: enabled, child: child!);
              },
              child: const MateoOrb(size: 72, animate: true),
            ),
          ),
        );
        await _waitForShader(tester);

        await tester.pump(const Duration(milliseconds: 200));
        final mutedTime = _timeOf(tester);
        expect(mutedTime, 0);

        tickerEnabled.value = true;
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(_timeOf(tester), greaterThan(mutedTime));
      },
    );

    testWidgets(
      'when the application pauses, it should resume from the preserved phase',
      (tester) async {
        addTearDown(
          () => tester.binding.handleAppLifecycleStateChanged(
            AppLifecycleState.resumed,
          ),
        );
        await tester.pumpWidget(
          const TestApp(child: MateoOrb(size: 72, animate: true)),
        );
        await _waitForShader(tester);
        await tester.pump(const Duration(milliseconds: 200));
        final timeBeforePause = _timeOf(tester);

        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        await tester.pump(const Duration(milliseconds: 200));
        expect(_timeOf(tester), timeBeforePause);

        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(_timeOf(tester), greaterThan(timeBeforePause));
      },
    );
  });
}

Finder _orbPaintFinder() {
  return find.descendant(
    of: find.byType(MateoOrb),
    matching: find.byType(CustomPaint),
  );
}

dynamic _painterOf(WidgetTester tester) {
  return tester.widget<CustomPaint>(_orbPaintFinder()).painter!;
}

Size _paintSize(WidgetTester tester) => tester.getSize(_orbPaintFinder());

double _timeOf(WidgetTester tester) {
  return _painterOf(tester).elapsedSeconds as double;
}

Future<void> _waitForShader(WidgetTester tester) async {
  for (var attempt = 0; attempt < 20; attempt++) {
    if (_painterOf(tester).shader != null) return;
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump();
  }

  fail('MateoOrb shader did not load.');
}
