import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import '../test_app.dart';

LinearGradient _gradientOf(WidgetTester tester) {
  final box = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
  final boxDecoration = box.decoration as BoxDecoration;
  final gradient = boxDecoration.gradient! as LinearGradient;
  return gradient;
}

void main() {
  group('MateoEdgeFade', () {
    testWidgets(
      'when color is omitted, it should default to mateo background color',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(
            child: MateoEdgeFade(position: MateoEdgeFadePosition.top),
          ),
        );

        expect(
          _gradientOf(tester).colors.first,
          equals(mateoTestColorScheme.background),
        );
      },
    );

    testWidgets(
      'when color is provided, it should use the provided color as the gradient base',
      (tester) async {
        final customColor = mateoTestColorScheme.buttons.success.background;

        await tester.pumpWidget(
          TestApp(
            child: MateoEdgeFade(
              position: MateoEdgeFadePosition.top,
              style: MateoEdgeFadeStyle(color: customColor),
            ),
          ),
        );

        expect(_gradientOf(tester).colors.first, equals(customColor));
      },
    );

    testWidgets(
      'when position is top, it should orient the gradient opaque at the top',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(
            child: MateoEdgeFade(position: MateoEdgeFadePosition.top),
          ),
        );

        final gradient = _gradientOf(tester);
        expect(gradient.begin, equals(Alignment.topCenter));
        expect(gradient.end, equals(Alignment.bottomCenter));
      },
    );

    testWidgets(
      'when position is bottom, it should orient the gradient opaque at the bottom',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(
            child: MateoEdgeFade(position: MateoEdgeFadePosition.bottom),
          ),
        );

        final gradient = _gradientOf(tester);
        expect(gradient.begin, equals(Alignment.bottomCenter));
        expect(gradient.end, equals(Alignment.topCenter));
      },
    );

    testWidgets(
      'when rendered, it should wrap the gradient in an IgnorePointer',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(
            child: MateoEdgeFade(position: MateoEdgeFadePosition.top),
          ),
        );

        final fade = find.byType(MateoEdgeFade);
        expect(
          find.descendant(of: fade, matching: find.byType(IgnorePointer)),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'when rendered, it should wrap the gradient in a RepaintBoundary',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(
            child: MateoEdgeFade(position: MateoEdgeFadePosition.top),
          ),
        );

        final fade = find.byType(MateoEdgeFade);
        expect(
          find.descendant(of: fade, matching: find.byType(RepaintBoundary)),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'when rendered, the gradient last color should be fully transparent',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(
            child: MateoEdgeFade(position: MateoEdgeFadePosition.top),
          ),
        );

        expect(_gradientOf(tester).colors.last.a, equals(0.0));
      },
    );

    testWidgets(
      'when the device is very short, it should clamp the fade height to the minimum',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(
            child: MediaQuery(
              data: MediaQueryData(size: Size(400, 400)),
              child: MateoEdgeFade(position: MateoEdgeFadePosition.top),
            ),
          ),
        );

        final sizedBox = tester.widget<SizedBox>(
          find.byWidgetPredicate((w) => w is SizedBox && w.height == 72.0),
        );

        expect(sizedBox.height, equals(72.0));
      },
    );

    testWidgets(
      'when the device is very tall, it should clamp the fade height to the maximum',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(
            child: MediaQuery(
              data: MediaQueryData(size: Size(400, 1600)),
              child: MateoEdgeFade(position: MateoEdgeFadePosition.top),
            ),
          ),
        );

        final sizedBox = tester.widget<SizedBox>(
          find.byWidgetPredicate((w) => w is SizedBox && w.height == 120.0),
        );

        expect(sizedBox.height, equals(120.0));
      },
    );

    testWidgets(
      'when on a medium device, it should use the proportional fade height',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(
            child: MediaQuery(
              data: MediaQueryData(size: Size(400, 700)),
              child: MateoEdgeFade(position: MateoEdgeFadePosition.top),
            ),
          ),
        );

        final sizedBox = tester.widget<SizedBox>(
          find.byWidgetPredicate((w) => w is SizedBox && w.height == 100.0),
        );

        expect(sizedBox.height, equals(100.0));
      },
    );
  });
}
