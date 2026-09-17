import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/surface_transform_test_widgets.dart';

Future<void> main() async {
  for (final scenario in <({String name, MateoSheetViewHeaderPresentation presentation})>[
    (name: 'handle', presentation: const .handle()),
    (name: 'close_button', presentation: const .closeButton()),
    (
      name: 'custom',
      presentation: const .custom(leading: Text('Back'), principal: Text('Details'), trailing: Text('Help')),
    ),
  ]) {
    late BuildContext launcher;
    await goldenTest(
      'when the header uses ${scenario.name}, it should display its presentation',
      fileName: 'mateo_sheet_view_header_${scenario.name}',
      constraints: const BoxConstraints.tightFor(width: 390, height: 844),
      pumpBeforeTest: (tester) async {
        await tester.pumpAndSettle();
        unawaited(
          showMateoSheet<void>(
            context: launcher,
            view: MateoSheetView(
              header: MateoSheetViewHeader(presentation: scenario.presentation),
              surface: const MateoSheetViewSurface(
                child: SizedBox(height: 180, child: Center(child: Text('Sheet content'))),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
      },
      builder: () => MateoApp(
        theme: surfaceTransformTheme,
        home: Builder(
          builder: (context) {
            launcher = context;
            return const SizedBox.expand();
          },
        ),
      ),
    );
  }
}
