import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import '../test_app.dart';

void main() {
  group('MateoEdgeFadeStyle', () {
    testWidgets(
      'when used in MateoEdgeFade without explicit style, it should default to theme background',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(
            child: MateoEdgeFade(position: MateoEdgeFadePosition.top),
          ),
        );

        final box = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
        final decoration = box.decoration as BoxDecoration;
        final gradient = decoration.gradient! as LinearGradient;
        expect(gradient.colors.first, equals(mateoTestColorScheme.background));
      },
    );

    testWidgets(
      'when style has explicit color, it should use that color for the gradient',
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

        final box = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
        final decoration = box.decoration as BoxDecoration;
        final gradient = decoration.gradient! as LinearGradient;
        expect(gradient.colors.first, equals(customColor));
      },
    );

    testWidgets(
      'when style has explicit height, it should size the fade to that height',
      (tester) async {
        await tester.pumpWidget(
          const TestApp(
            child: MateoEdgeFade(
              position: MateoEdgeFadePosition.top,
              style: MateoEdgeFadeStyle(height: 50),
            ),
          ),
        );

        final sizedBox = tester.widget<SizedBox>(
          find.byWidgetPredicate((w) => w is SizedBox && w.height == 50),
        );
        expect(sizedBox.height, equals(50));
      },
    );
  });
}
