import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

const _kChildSize = 50.0;
const _kChild = SizedBox(width: _kChildSize, height: _kChildSize);

void main() {
  group('when constructing MateoRadarPulse', () {
    test('with zero steps, it should throw AssertionError', () {
      expect(
        () => MateoRadarPulse(steps: const [], child: _kChild),
        throwsA(isA<AssertionError>()),
      );
    });

    test('with default steps, it should not throw', () {
      expect(() => MateoRadarPulse(child: _kChild), returnsNormally);
    });

    test('with maxScale equal to 1.0, it should throw AssertionError', () {
      expect(
        () => MateoRadarPulse(maxScale: 1, child: _kChild),
        throwsA(isA<AssertionError>()),
      );
    });

    test('with maxScale below 1.0, it should throw AssertionError', () {
      expect(
        () => MateoRadarPulse(maxScale: 0.5, child: _kChild),
        throwsA(isA<AssertionError>()),
      );
    });

    test('with maxScale above 1.0, it should not throw', () {
      expect(
        () => MateoRadarPulse(maxScale: 1.001, child: _kChild),
        returnsNormally,
      );
    });
  });

  group('when rendering MateoRadarPulse', () {
    testWidgets(
      'with default steps, it should display the child without error',
      (tester) async {
        await tester.pumpWidget(
          TestApp(child: MateoRadarPulse(child: _kChild)),
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('with default steps, it should paint rings via CustomPaint', (
      tester,
    ) async {
      await tester.pumpWidget(TestApp(child: MateoRadarPulse(child: _kChild)));
      expect(
        find.descendant(
          of: find.byType(MateoRadarPulse),
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
    });

    testWidgets('with three custom steps, it should render without error', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: MateoRadarPulse(
            steps: const [
              MateoRadarPulseStep(),
              MateoRadarPulseStep(),
              MateoRadarPulseStep(),
            ],
            child: _kChild,
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'when animations are disabled, it should render without error',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: MateoRadarPulse(child: _kChild),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('when animations are disabled, it should still paint rings', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: MateoRadarPulse(child: _kChild),
          ),
        ),
      );
      expect(
        find.descendant(
          of: find.byType(MateoRadarPulse),
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'when a custom step color is provided, it should render without error',
      (tester) async {
        final customColor = mateoTestPalette.green[9];
        await tester.pumpWidget(
          TestApp(
            child: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: MateoRadarPulse(
                steps: [
                  MateoRadarPulseStep(color: customColor),
                  MateoRadarPulseStep(),
                ],
                child: _kChild,
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when a custom step borderRadius is provided, it should render without error',
      (tester) async {
        const customRadius = BorderRadius.all(Radius.circular(24));
        await tester.pumpWidget(
          TestApp(
            child: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: MateoRadarPulse(
                steps: const [
                  MateoRadarPulseStep(borderRadius: customRadius),
                  MateoRadarPulseStep(),
                ],
                child: _kChild,
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
      },
    );
  });

  group('when constructing MateoRadarPulseStep', () {
    test('with alpha below 0, it should throw AssertionError', () {
      expect(
        () => MateoRadarPulseStep(alpha: -0.1),
        throwsA(isA<AssertionError>()),
      );
    });

    test('with alpha above 1, it should throw AssertionError', () {
      expect(
        () => MateoRadarPulseStep(alpha: 1.1),
        throwsA(isA<AssertionError>()),
      );
    });

    test('with alpha equal to 0, it should not throw', () {
      expect(() => const MateoRadarPulseStep(alpha: 0), returnsNormally);
    });

    test('with alpha equal to 1, it should not throw', () {
      expect(() => const MateoRadarPulseStep(alpha: 1), returnsNormally);
    });

    test('with alpha inside range, it should not throw', () {
      expect(() => const MateoRadarPulseStep(alpha: 0.6), returnsNormally);
    });

    testWidgets('with a custom alpha, it should render without error', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: MateoRadarPulse(
              steps: const [
                MateoRadarPulseStep(alpha: 0.6),
                MateoRadarPulseStep(alpha: 0.2),
              ],
              child: _kChild,
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('with alpha 0, it should not paint any visible ring', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: MateoRadarPulse(
              steps: const [
                MateoRadarPulseStep(alpha: 0),
                MateoRadarPulseStep(alpha: 0),
              ],
              child: _kChild,
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('when animating MateoRadarPulse', () {
    testWidgets('at the start, it should have an active animation controller', (
      tester,
    ) async {
      await tester.pumpWidget(TestApp(child: MateoRadarPulse(child: _kChild)));
      await tester.pump(Duration.zero);

      expect(
        find.descendant(
          of: find.byType(MateoRadarPulse),
          matching: find.byType(AnimatedBuilder),
        ),
        findsOneWidget,
      );
    });

    testWidgets('after half a cycle, it should still render without error', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: MateoRadarPulse(
            duration: const Duration(milliseconds: 1600),
            child: _kChild,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 800));

      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'when duration is updated via didUpdateWidget, it should not throw',
      (tester) async {
        await tester.pumpWidget(
          TestApp(child: MateoRadarPulse(child: _kChild)),
        );
        await tester.pumpWidget(
          TestApp(
            child: MateoRadarPulse(
              duration: const Duration(milliseconds: 2000),
              child: _kChild,
            ),
          ),
        );
        await tester.pump();

        expect(tester.takeException(), isNull);
      },
    );
  });
}
