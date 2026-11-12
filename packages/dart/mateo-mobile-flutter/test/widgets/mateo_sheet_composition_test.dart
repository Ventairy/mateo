import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/surface_transform_test_widgets.dart';

void main() {
  for (final region in [(label: 'surface', text: 'Count 1'), (label: 'footer', text: 'Increment 1')]) {
    testWidgets('when a stateful widget builds a sheet, it should update its ${region.label}', (
      tester,
    ) async {
      var count = 0;
      await tester.pumpWidget(
        MateoApp(
          theme: surfaceTransformTheme,
          home: Builder(
            builder: (context) => MateoButton(
              key: const ValueKey('open'),
              presentation: const .label(label: 'Open'),
              onPressed: () => unawaited(
                showMateoSheet<void>(
                  context: context,
                  view: StatefulBuilder(
                    builder: (context, setState) => MateoSheetView(
                      surface: MateoSheetViewSurface(
                        child: MateoText('Count $count', presentation: const .interface()),
                      ),
                      footer: MateoSheetViewFooter(
                        principal: MateoButton(
                          key: const ValueKey('increment'),
                          presentation: .label(label: 'Increment $count'),
                          onPressed: () => setState(() => count++),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('open')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('increment')));
      await tester.pumpAndSettle();
      expect(find.text(region.text), findsOneWidget);
    });
  }
}
