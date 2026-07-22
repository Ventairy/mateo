import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  group('when constructing MateoSwipeUpHint', () {
    test('with default props, it should not throw', () {
      expect(() => const MateoSwipeUpHint(), returnsNormally);
    });

    test('with a custom height, it should not throw', () {
      expect(() => const MateoSwipeUpHint(height: 200), returnsNormally);
    });

    test('with a custom phoneColor, it should not throw', () {
      expect(
        () => MateoSwipeUpHint(phoneColor: mateoTestPalette.neutral[12]),
        returnsNormally,
      );
    });

    test('with a custom accentColor, it should not throw', () {
      expect(
        () => MateoSwipeUpHint(accentColor: mateoTestPalette.primary[9]),
        returnsNormally,
      );
    });

    test('with height zero, it should not throw', () {
      expect(() => const MateoSwipeUpHint(height: 0), returnsNormally);
    });
  });

  group('when rendering MateoSwipeUpHint', () {
    testWidgets('with default props, it should paint via CustomPaint', (
      tester,
    ) async {
      await tester.pumpWidget(const TestApp(child: MateoSwipeUpHint()));
      expect(
        find.descendant(
          of: find.byType(MateoSwipeUpHint),
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'with default props, it should size itself from the height prop',
      (tester) async {
        await tester.pumpWidget(const TestApp(child: MateoSwipeUpHint()));

        final customPaint = tester.widget<CustomPaint>(
          find.descendant(
            of: find.byType(MateoSwipeUpHint),
            matching: find.byType(CustomPaint),
          ),
        );

        expect(customPaint.size.height, closeTo(120, 0.1));
      },
    );

    testWidgets('with a custom height, it should size itself accordingly', (
      tester,
    ) async {
      await tester.pumpWidget(
        const TestApp(child: MateoSwipeUpHint(height: 200)),
      );

      final customPaint = tester.widget<CustomPaint>(
        find.descendant(
          of: find.byType(MateoSwipeUpHint),
          matching: find.byType(CustomPaint),
        ),
      );

      expect(customPaint.size.height, closeTo(200, 0.1));
    });

    testWidgets(
      'when animations are disabled, it should render without error',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: MateoSwipeUpHint(),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when animations are disabled, it should still paint via CustomPaint',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: MateoSwipeUpHint(),
            ),
          ),
        );
        expect(
          find.descendant(
            of: find.byType(MateoSwipeUpHint),
            matching: find.byType(CustomPaint),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets('with a custom phoneColor, it should render without error', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: MateoSwipeUpHint(phoneColor: mateoTestPalette.neutral[12]),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('with a custom accentColor, it should render without error', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: MateoSwipeUpHint(accentColor: mateoTestPalette.primary[9]),
        ),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('when animating MateoSwipeUpHint', () {
    testWidgets('after a partial cycle, it should still render without error', (
      tester,
    ) async {
      await tester.pumpWidget(const TestApp(child: MateoSwipeUpHint()));
      await tester.pump(const Duration(milliseconds: 500));

      expect(tester.takeException(), isNull);
    });

    testWidgets('after a full cycle, it should loop without error', (
      tester,
    ) async {
      await tester.pumpWidget(const TestApp(child: MateoSwipeUpHint()));
      await tester.pump(const Duration(milliseconds: 2200));

      expect(tester.takeException(), isNull);
    });
  });

  group('when reduced motion is enabled', () {
    testWidgets('it should render a static frame without error', (
      tester,
    ) async {
      await tester.pumpWidget(
        const TestApp(
          child: MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: MateoSwipeUpHint(),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(
        find.descendant(
          of: find.byType(MateoSwipeUpHint),
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'it should pass progress 0.3 to the generated animation widget',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: MateoSwipeUpHint(),
            ),
          ),
        );

        final swipeUpPhone = tester
            .widgetList<Widget>(
              find.descendant(
                of: find.byType(MateoSwipeUpHint),
                matching: find.byWidgetPredicate(
                  (w) => w.runtimeType.toString() == '_SwipeUpPhoneAnimation',
                ),
              ),
            )
            .first;

        final progress = (swipeUpPhone as dynamic).progress as double;

        expect(progress, 0.3);
      },
    );
  });
}
