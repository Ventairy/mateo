import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/surface_transform_test_widgets.dart';

Future<void> main() async {
  for (final phase in ['three', 'four', 'entering', 'taller_entering', 'returning']) {
    late BuildContext launcher;
    await goldenTest(
      'when a stack is $phase, it should show stepped frames and preserve the front content',
      fileName: 'mateo_sheet_stack_$phase',
      pumpBeforeTest: (tester) async {
        await tester.pumpAndSettle();
        final count = phase == 'three' ? 3 : 4;
        for (var index = 0; index < count; index++) {
          unawaited(
            showMateoSheet<void>(
              context: launcher,
              view: MateoSheetView(
                surface: MateoSheetViewSurface(
                  color: surfaceTransformTheme.colorScheme.background,
                  child: SizedBox(
                    height: phase == 'taller_entering' && index == 3 ? 340 : 240 - index * 30,
                    child: Center(child: Text('Sheet ${index + 1}')),
                  ),
                ),
              ),
            ),
          );
          await tester.pump();
          if (phase.endsWith('entering') && index == 3) {
            await tester.pump(const Duration(milliseconds: 100));
          } else {
            await tester.pumpAndSettle();
          }
        }
        if (phase == 'returning') {
          Navigator.of(launcher).pop();
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 100));
        }
      },
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: phase,
            child: SizedBox(
              width: 320,
              height: 480,
              child: MateoApp(
                theme: surfaceTransformTheme,
                home: Builder(
                  builder: (context) {
                    launcher = context;
                    return ColoredBox(
                      color: surfaceTransformTheme.colorScheme.background,
                      child: const SizedBox.expand(),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
