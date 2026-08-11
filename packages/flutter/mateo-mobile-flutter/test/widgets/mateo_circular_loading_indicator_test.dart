import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  group('when constructing MateoCircularLoadingIndicator', () {
    test('when size is negative, it should throw AssertionError', () {
      expect(
        () => MateoCircularLoadingIndicator(size: -1),
        throwsA(isA<AssertionError>()),
      );
    });

    test('when size is infinite, it should throw AssertionError', () {
      expect(
        () => MateoCircularLoadingIndicator(size: double.infinity),
        throwsA(isA<AssertionError>()),
      );
    });

    test('when size is NaN, it should throw AssertionError', () {
      expect(
        () => MateoCircularLoadingIndicator(size: double.nan),
        throwsA(isA<AssertionError>()),
      );
    });

    test('when size is zero, it should construct normally', () {
      expect(
        () => const MateoCircularLoadingIndicator(size: 0),
        returnsNormally,
      );
    });
  });

  group('when laying out MateoCircularLoadingIndicator', () {
    testWidgets(
      'when size is supplied, it should use the requested square dimensions',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(child: MateoCircularLoadingIndicator(size: 24)),
        );

        expect(_paintSize(tester), const Size.square(24));
      },
    );

    testWidgets(
      'when parent dimensions differ, it should use the shortest dimension',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(
            child: SizedBox(
              width: 80,
              height: 48,
              child: MateoCircularLoadingIndicator(),
            ),
          ),
        );

        expect(_paintSize(tester), const Size.square(48));
      },
    );

    testWidgets(
      'when both parent axes are unbounded, it should use the 24 pixel fallback',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(
            child: UnconstrainedBox(child: MateoCircularLoadingIndicator()),
          ),
        );

        expect(_paintSize(tester), const Size.square(24));
      },
    );
  });

  group('when painting MateoCircularLoadingIndicator', () {
    testWidgets(
      'when colors are omitted, it should use primary steps 9 and 4',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(child: MateoCircularLoadingIndicator(size: 24)),
        );

        final painter = _painterOf(tester);
        expect(painter.color, mateoTestPalette.primary[9]);
        expect(painter.trackColor, mateoTestPalette.primary[4]);
      },
    );

    testWidgets('when colors are supplied, it should use both custom colors', (
      tester,
    ) async {
      const color = Color(0xFF17181B);
      const trackColor = Color(0xFFE0E1E5);

      await tester.pumpWidget(
        const TestApp(
          child: MateoCircularLoadingIndicator(
            color: color,
            trackColor: trackColor,
            size: 24,
          ),
        ),
      );

      final painter = _painterOf(tester);
      expect(painter.color, color);
      expect(painter.trackColor, trackColor);
    });

    testWidgets(
      'when size is 24, it should use equal one-fourteenth track and arc widths',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(child: MateoCircularLoadingIndicator(size: 24)),
        );

        final painter = _painterOf(tester);
        final trackWidth = 24 * painter.trackWidthFactor as double;
        final indicatorWidth = 24 * painter.indicatorWidthFactor as double;

        expect(trackWidth, 24 / 14);
        expect(indicatorWidth, 24 / 14);
        expect((trackWidth - indicatorWidth) / 2, 0);
      },
    );

    testWidgets(
      'when size doubles, it should double equal track and arc widths',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(child: MateoCircularLoadingIndicator(size: 48)),
        );

        final painter = _painterOf(tester);
        final trackWidth = 48 * painter.trackWidthFactor as double;
        final indicatorWidth = 48 * painter.indicatorWidthFactor as double;

        expect(trackWidth, 48 / 14);
        expect(indicatorWidth, 48 / 14);
        expect((trackWidth - indicatorWidth) / 2, 0);
      },
    );

    testWidgets(
      'when rendered, it should isolate the painter in a RepaintBoundary',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(child: MateoCircularLoadingIndicator(size: 24)),
        );

        expect(
          find.descendant(
            of: find.byType(MateoCircularLoadingIndicator),
            matching: find.byType(RepaintBoundary),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'when rendered, it should expose one indeterminate loading role',
      (tester) async {
        final semantics = tester.ensureSemantics();

        await tester.pumpWidget(
          const TestApp(child: MateoCircularLoadingIndicator(size: 24)),
        );

        final properties = _semanticsOf(tester).properties;
        expect(properties.role, SemanticsRole.loadingSpinner);
        expect(properties.value, isNull);

        semantics.dispose();
      },
    );
  });

  group('when animating MateoCircularLoadingIndicator', () {
    testWidgets(
      'when one quarter cycle elapses, it should rotate clockwise by one quarter turn',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(child: MateoCircularLoadingIndicator(size: 24)),
        );

        final initialPainter = _painterOf(tester);
        final initialCenterAngle =
            initialPainter.startAngle + initialPainter.indicatorSweep / 2
                as double;
        expect(initialCenterAngle, closeTo(-math.pi / 2, 0.001));
        expect(
          initialPainter.indicatorSweep,
          closeTo(100 * math.pi / 180, 0.001),
        );

        await tester.pump(const Duration(milliseconds: 200));

        final rotatedPainter = _painterOf(tester);
        final rotatedCenterAngle =
            rotatedPainter.startAngle + rotatedPainter.indicatorSweep / 2
                as double;
        expect(rotatedCenterAngle, closeTo(0, 0.02));
      },
    );

    testWidgets(
      'when a cycle wraps, it should continue without a held or frozen frame',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(child: MateoCircularLoadingIndicator(size: 24)),
        );

        await tester.pump(const Duration(milliseconds: 780));
        final beforeWrap = _progressOf(tester);
        await tester.pump(const Duration(milliseconds: 40));
        final afterWrap = _progressOf(tester);

        expect(beforeWrap, greaterThan(0.9));
        expect(afterWrap, lessThan(0.1));
      },
    );

    testWidgets(
      'when a frame advances, it should repaint without rebuilding CustomPaint',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(child: MateoCircularLoadingIndicator(size: 24)),
        );

        final customPaintBefore = tester.widget<CustomPaint>(
          find.byType(CustomPaint),
        );
        await tester.pump(const Duration(milliseconds: 100));
        final customPaintAfter = tester.widget<CustomPaint>(
          find.byType(CustomPaint),
        );

        expect(identical(customPaintAfter, customPaintBefore), isTrue);
        expect(_progressOf(tester), greaterThan(0));
      },
    );

    testWidgets(
      'when animations are disabled, it should keep a static top-centered arc',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: MateoCircularLoadingIndicator(size: 24),
            ),
          ),
        );

        final painterBefore = _painterOf(tester);
        final centerAngleBefore =
            painterBefore.startAngle + painterBefore.indicatorSweep / 2
                as double;
        await tester.pump(const Duration(milliseconds: 200));
        final painterAfter = _painterOf(tester);

        expect(painterBefore.progress, isNull);
        expect(centerAngleBefore, closeTo(-math.pi / 2, 0.001));
        expect(painterAfter.startAngle, painterBefore.startAngle);
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
              child: const MateoCircularLoadingIndicator(size: 24),
            ),
          ),
        );

        await tester.pump(const Duration(milliseconds: 100));
        final mutedProgress = _progressOf(tester);
        expect(mutedProgress, 0);

        tickerEnabled.value = true;
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(_progressOf(tester), greaterThan(mutedProgress));
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
          const TestApp(child: MateoCircularLoadingIndicator(size: 24)),
        );
        await tester.pump(const Duration(milliseconds: 100));
        final progressBeforePause = _progressOf(tester);

        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        await tester.pump(const Duration(milliseconds: 100));
        expect(_progressOf(tester), progressBeforePause);

        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(_progressOf(tester), greaterThan(progressBeforePause));
      },
    );
  });
}

dynamic _painterOf(WidgetTester tester) {
  return tester.widget<CustomPaint>(find.byType(CustomPaint)).painter!;
}

double _progressOf(WidgetTester tester) {
  final painter = _painterOf(tester);
  return (painter.progress as Animation<double>).value;
}

Size _paintSize(WidgetTester tester) {
  return tester.getSize(find.byType(CustomPaint));
}

Semantics _semanticsOf(WidgetTester tester) {
  return tester.widget<Semantics>(
    find.descendant(
      of: find.byType(MateoCircularLoadingIndicator),
      matching: find.byType(Semantics),
    ),
  );
}
