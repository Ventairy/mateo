import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  group('MateoToastPresentation', () {
    testWidgets(
      'when each presentation renders, it should use its matching toast color scheme',
      (tester) async {
        final toastColors = MateoColorScheme.light().toast;
        final scenarios =
            <
              ({
                String name,
                MateoToastVariantColorScheme colors,
                MateoToastPresentation Function(MateoToastIconBuilder iconBuilder) presentation,
              })
            >[
              (
                name: 'error',
                colors: toastColors.error,
                presentation: (iconBuilder) => MateoToastPresentation.error(iconBuilder: iconBuilder),
              ),
              (
                name: 'warning',
                colors: toastColors.warning,
                presentation: (iconBuilder) => MateoToastPresentation.warning(iconBuilder: iconBuilder),
              ),
              (
                name: 'info',
                colors: toastColors.info,
                presentation: (iconBuilder) => MateoToastPresentation.info(iconBuilder: iconBuilder),
              ),
              (
                name: 'success',
                colors: toastColors.success,
                presentation: (iconBuilder) => MateoToastPresentation.success(iconBuilder: iconBuilder),
              ),
              (
                name: 'neutral',
                colors: toastColors.neutral,
                presentation: (iconBuilder) => MateoToastPresentation.neutral(iconBuilder: iconBuilder),
              ),
            ];

        for (final scenario in scenarios) {
          MateoToastState? iconState;
          await tester.pumpWidget(
            TestApp(
              child: MateoToast(
                message: scenario.name,
                presentation: scenario.presentation((state) {
                  iconState = state;
                  return const SizedBox.shrink();
                }),
              ),
            ),
          );

          final decoration = tester.widget<DecoratedBox>(find.byKey(const Key('mateo_toast_surface'))).decoration;
          final message = tester.widget<Text>(find.byKey(const Key('mateo_toast_message')));

          expect((decoration as BoxDecoration).color, scenario.colors.background, reason: scenario.name);
          expect(message.style?.color, scenario.colors.foreground, reason: scenario.name);
          expect(iconState?.iconColor, scenario.colors.icon, reason: scenario.name);
        }
      },
    );
  });
}
