import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  group('when constructing MateoProgressIndicator', () {
    test('when value is below zero, it should throw AssertionError', () {
      expect(
        () => MateoProgressIndicator(value: -0.01),
        throwsA(isA<AssertionError>()),
      );
    });

    test('when value is above one, it should throw AssertionError', () {
      expect(
        () => MateoProgressIndicator(value: 1.01),
        throwsA(isA<AssertionError>()),
      );
    });

    test('when value is NaN, it should throw AssertionError', () {
      expect(
        () => MateoProgressIndicator(value: double.nan),
        throwsA(isA<AssertionError>()),
      );
    });

    test('when value is within range, it should construct normally', () {
      expect(() => const MateoProgressIndicator(value: 0.5), returnsNormally);
    });

    test('when width is negative, it should throw AssertionError', () {
      expect(
        () => MateoProgressIndicator(value: 0.5, width: -1),
        throwsA(isA<AssertionError>()),
      );
    });

    test('when width is finite, it should construct normally', () {
      expect(
        () => const MateoProgressIndicator(value: 0.5, width: 240),
        returnsNormally,
      );
    });
  });

  group('when rendering MateoProgressIndicator', () {
    testWidgets(
      'when constrained to a width, it should fill it at the Mateo height',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(child: MateoProgressIndicator(value: 0.5, width: 240)),
        );

        expect(
          tester.getSize(find.byType(MateoProgressIndicator)),
          const Size(240, 5),
        );
      },
    );

    testWidgets(
      'when rendered, it should use the Mateo control colors and isolate repaints',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(
            child: SizedBox(
              width: 240,
              child: MateoProgressIndicator(value: 0.5),
            ),
          ),
        );

        final painter = _painterOf(tester);
        expect(painter.trackColor, equals(mateoTestColorScheme.controls.track));
        expect(
          painter.fillColor,
          equals(mateoTestColorScheme.controls.trackFilled),
        );
        expect(
          find.descendant(
            of: find.byType(MateoProgressIndicator),
            matching: find.byType(RepaintBoundary),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'when text direction changes, it should paint from the new leading edge',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SizedBox(
                width: 240,
                child: MateoProgressIndicator(value: 0.5),
              ),
            ),
          ),
        );

        expect(_painterOf(tester).textDirection, TextDirection.rtl);
      },
    );

    testWidgets(
      'when semantics text is omitted, it should expose percentage progress',
      (tester) async {
        final semantics = tester.ensureSemantics();

        await tester.pumpWidget(
          const TestApp(child: MateoProgressIndicator(value: 0.42)),
        );

        final properties = _semanticsOf(tester).properties;
        expect(properties.role, SemanticsRole.progressBar);
        expect(properties.label, isNull);
        expect(properties.value, '42%');
        expect(properties.minValue, '0');
        expect(properties.maxValue, '100');

        semantics.dispose();
      },
    );

    testWidgets(
      'when semantics text is provided, it should expose the custom descriptions',
      (tester) async {
        final semantics = tester.ensureSemantics();

        await tester.pumpWidget(
          const TestApp(
            child: MateoProgressIndicator(
              value: 0.5,
              semanticsLabel: 'Profile setup progress',
              semanticsValue: 'Step 2 of 4',
            ),
          ),
        );

        final properties = _semanticsOf(tester).properties;
        expect(properties.label, 'Profile setup progress');
        expect(properties.value, '50%');
        expect(properties.hint, 'Step 2 of 4');

        semantics.dispose();
      },
    );
  });

  group('when animating MateoProgressIndicator', () {
    testWidgets(
      'when first rendered, it should animate from zero to the supplied value',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(child: MateoProgressIndicator(value: 0.8)),
        );

        expect(_progressOf(tester), 0);
        await tester.pump(const Duration(milliseconds: 500));
        expect(_progressOf(tester), closeTo(0.7, 0.001));
        await tester.pump(const Duration(milliseconds: 500));
        expect(_progressOf(tester), 0.8);
      },
    );

    testWidgets(
      'when retargeted mid-animation, it should continue from the visible value',
      (tester) async {
        final value = ValueNotifier(0.8);
        addTearDown(value.dispose);

        await tester.pumpWidget(
          TestApp(
            child: ValueListenableBuilder(
              valueListenable: value,
              builder: (context, progress, child) {
                return MateoProgressIndicator(value: progress);
              },
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        final visibleValue = _progressOf(tester);
        value.value = 0.2;
        await tester.pump();

        expect(_progressOf(tester), visibleValue);
        await tester.pump(const Duration(milliseconds: 1000));
        expect(_progressOf(tester), 0.2);
      },
    );

    testWidgets(
      'when progress moves backward, it should animate to the lower value',
      (tester) async {
        final value = ValueNotifier(0.8);
        addTearDown(value.dispose);

        await tester.pumpWidget(
          TestApp(
            child: ValueListenableBuilder(
              valueListenable: value,
              builder: (context, progress, child) {
                return MateoProgressIndicator(value: progress);
              },
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 1000));

        value.value = 0.2;
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 1000));

        expect(_progressOf(tester), 0.2);
      },
    );

    testWidgets(
      'when animations are disabled, it should apply progress immediately',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: MateoProgressIndicator(value: 0.8),
            ),
          ),
        );
        await tester.pump();

        expect(_progressOf(tester), 0.8);
        expect(tester.binding.hasScheduledFrame, isFalse);
      },
    );

    testWidgets(
      'when its transition settles, it should stop scheduling frames',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(child: MateoProgressIndicator(value: 0.8)),
        );
        await tester.pumpAndSettle();

        expect(_progressOf(tester), 0.8);
        expect(
          (_painterOf(tester).progress as AnimationController).isAnimating,
          isFalse,
        );
        expect(tester.binding.hasScheduledFrame, isFalse);
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

Semantics _semanticsOf(WidgetTester tester) {
  return tester.widget<Semantics>(
    find.descendant(
      of: find.byType(MateoProgressIndicator),
      matching: find.byType(Semantics),
    ),
  );
}
