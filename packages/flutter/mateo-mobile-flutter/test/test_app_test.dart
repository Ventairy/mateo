import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import 'test_app.dart';

void main() {
  testWidgets(
    'when TestApp receives a custom theme, it should expose that exact Mateo color scheme',
    (tester) async {
      final customColorScheme = mateoTestColorScheme.copyWith(
        background: mateoTestColorScheme.buttons.secondary.background,
      );
      final customMateoThemeData = mateoTestThemeData.copyWith(
        colorScheme: customColorScheme,
      );
      final customTheme = mateoTestTheme.copyWith(
        extensions: [customMateoThemeData],
      );
      late MateoThemeData activeThemeData;

      await tester.pumpWidget(
        TestApp(
          theme: customTheme,
          child: Builder(
            builder: (context) {
              activeThemeData = Theme.of(context).extension<MateoThemeData>()!;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(activeThemeData.colorScheme, customColorScheme);
      expect(activeThemeData.palette, mateoTestPalette);
    },
  );
}
