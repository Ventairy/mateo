import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  group('MateoToastType', () {
    testWidgets(
      'when each type resolves colors, it should use its matching toast color scheme',
      (tester) async {
        late BuildContext capturedContext;

        await tester.pumpWidget(
          TestApp(
            child: Builder(
              builder: (context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        final toastColors = MateoColorScheme.light().toast;
        final expectedColors = <MateoToastType, MateoToastVariantColorScheme>{
          MateoToastType.error: toastColors.error,
          MateoToastType.warning: toastColors.warning,
          MateoToastType.info: toastColors.info,
          MateoToastType.success: toastColors.success,
          MateoToastType.neutral: toastColors.neutral,
        };

        for (final MapEntry(key: type, value: expected)
            in expectedColors.entries) {
          final actual = type.colors(capturedContext);

          expect(
            actual.background,
            equals(expected.background),
            reason: '$type',
          );
          expect(
            actual.foreground,
            equals(expected.foreground),
            reason: '$type',
          );
          expect(actual.icon, equals(expected.icon), reason: '$type');
        }
      },
    );
  });
}
