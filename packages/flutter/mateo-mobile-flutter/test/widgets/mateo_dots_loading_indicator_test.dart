import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  group('when constructing MateoDotsLoadingIndicator', () {
    test('with a negative dot radius, it should throw AssertionError', () {
      expect(
        () => MateoDotsLoadingIndicator(dotRadius: -1),
        throwsA(isA<AssertionError>()),
      );
    });

    test('with a zero dot radius, it should not throw', () {
      expect(
        () => const MateoDotsLoadingIndicator(dotRadius: 0),
        returnsNormally,
      );
    });

    test('with default props, it should not throw', () {
      expect(() => const MateoDotsLoadingIndicator(), returnsNormally);
    });
  });

  group('when rendering MateoDotsLoadingIndicator', () {
    testWidgets('with default props, it should paint dots via CustomPaint', (
      tester,
    ) async {
      await tester.pumpWidget(
        const TestApp(child: MateoDotsLoadingIndicator()),
      );

      expect(
        find.descendant(
          of: find.byType(MateoDotsLoadingIndicator),
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'with default props, it should size itself from the dot radius',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(child: MateoDotsLoadingIndicator()),
        );

        final sizedBox = tester.widget<SizedBox>(
          find.descendant(
            of: find.byType(MateoDotsLoadingIndicator),
            matching: find.byType(SizedBox),
          ),
        );

        expect(
          sizedBox,
          isA<SizedBox>()
              .having((box) => box.width, 'width', 43.5)
              .having((box) => box.height, 'height', 19.5),
        );
      },
    );

    testWidgets(
      'when animations are disabled, it should render without error',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: MateoDotsLoadingIndicator(),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('with a custom color, it should render without error', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: MateoDotsLoadingIndicator(color: mateoTestPalette.neutral[12]),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('with a custom dot radius, it should render without error', (
      tester,
    ) async {
      await tester.pumpWidget(
        const TestApp(child: MateoDotsLoadingIndicator(dotRadius: 6)),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('with a zero dot radius, it should render without error', (
      tester,
    ) async {
      await tester.pumpWidget(
        const TestApp(child: MateoDotsLoadingIndicator(dotRadius: 0)),
      );

      expect(tester.takeException(), isNull);
    });
  });

  group('when animating MateoDotsLoadingIndicator', () {
    testWidgets('after a partial cycle, it should still render without error', (
      tester,
    ) async {
      await tester.pumpWidget(
        const TestApp(child: MateoDotsLoadingIndicator()),
      );
      await tester.pump(const Duration(milliseconds: 440));

      expect(tester.takeException(), isNull);
    });
  });
}
