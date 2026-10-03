import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/surface_transform_test_widgets.dart';

Future<void> main() async {
  late BuildContext cappedLauncher;
  await goldenTest(
    'when a scrolling sheet is capped, its fixed slots should remain visible',
    fileName: 'mateo_sheet_capped',
    pumpBeforeTest: (tester) async {
      await tester.pumpAndSettle();
      unawaited(
        showMateoSheet<void>(
          context: cappedLauncher,
          maxExtent: 280,
          view: const MateoSheetView(
            header: MateoSheetViewHeader(presentation: .custom(principal: Text('Details'))),
            footer: MateoSheetViewFooter(principal: Text('Continue')),
            surface: MateoSheetViewSurface.scrollable(
              child: Column(children: [Text('Sheet content'), SizedBox(height: 600), Text('Last item')]),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    },
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'Maximum height with fixed slots',
          child: SizedBox(
            width: 320,
            height: 480,
            child: MateoApp(
              theme: surfaceTransformTheme,
              home: Builder(
                builder: (context) {
                  cappedLauncher = context;
                  return ColoredBox(
                    color: surfaceTransformTheme.colorScheme.text.primary,
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
  for (final phase in ['entering', 'resting', 'resisted']) {
    final launchers = <({BuildContext context, bool slots})>[];
    await goldenTest(
      'when the fitted sheet is $phase, it should include its content and fixed slots',
      fileName: 'mateo_sheet_$phase',
      pumpBeforeTest: (tester) async {
        await tester.pumpAndSettle();
        for (final launcher in launchers) {
          unawaited(
            showMateoSheet<void>(
              context: launcher.context,
              view: MateoSheetView(
                header: launcher.slots
                    ? const MateoSheetViewHeader(presentation: .custom(principal: Text('Details')))
                    : null,
                footer: launcher.slots ? const MateoSheetViewFooter(principal: Text('Footer')) : null,
                surface: MateoSheetViewSurface(
                  color: surfaceTransformTheme.colorScheme.background,
                  child: const SizedBox(height: 100, child: Center(child: Text('Sheet content'))),
                ),
              ),
            ),
          );
        }
        await tester.pump();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        if (phase != 'entering') await tester.pumpAndSettle();
        if (phase == 'resisted') {
          final sheets = find.byType(MateoSheetView);
          for (var index = 0; index < sheets.evaluate().length; index++) {
            final gesture = await tester.startGesture(tester.getCenter(sheets.at(index)), pointer: index + 1);
            addTearDown(gesture.cancel);
            await gesture.moveBy(const Offset(96, -96));
          }
          await tester.pump();
        }
      },
      builder: () {
        launchers.clear();
        return GoldenTestGroup(
          columns: 2,
          children: [
            for (final slots in [false, true])
              GoldenTestScenario(
                name: slots ? 'Header and footer' : 'Content only',
                child: SizedBox(
                  width: 320,
                  height: 480,
                  child: MateoApp(
                    theme: surfaceTransformTheme,
                    home: Builder(
                      builder: (context) {
                        launchers.add((context: context, slots: slots));
                        return ColoredBox(
                          color: surfaceTransformTheme.colorScheme.text.primary,
                          child: const SizedBox.expand(),
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
