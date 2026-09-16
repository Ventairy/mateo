import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/surface_transform_test_widgets.dart';

Future<void> main() async {
  late BuildContext launcher;
  await goldenTest(
    'when a sheet has a colored scrolling surface, it should keep both fixed slots and their fades',
    fileName: 'mateo_sheet_view_scrolled',
    constraints: const BoxConstraints.tightFor(width: 390, height: 844),
    pumpBeforeTest: (tester) async {
      await tester.pumpAndSettle();
      final slotStyle = TextStyle(color: surfaceTransformTheme.colorScheme.onAccent);
      unawaited(
        showMateoSheet<void>(
          context: launcher,
          view: MateoSheetView(
            header: MateoSheetViewHeader(
              leading: Text('Back', style: slotStyle),
              principal: Text('Choose a stay', style: slotStyle),
              trailing: Text('Help', style: slotStyle),
            ),
            footer: MateoSheetViewFooter(principal: Text('Two nights · Two guests', style: slotStyle)),
            surface: MateoSheetViewSurface.scrollable(
              color: surfaceTransformTheme.colorScheme.accent,
              alignment: .topCenter,
              edgeEffect: .fade(at: const [.top, .bottom]),
              child: DefaultTextStyle.merge(
                style: TextStyle(color: surfaceTransformTheme.colorScheme.onAccent, fontSize: 20),
                child: Column(
                  children: [
                    for (var i = 0; i < 16; i++)
                      Padding(
                        padding: const .symmetric(vertical: 24),
                        child: Text('Garden room ${i + 1}'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      tester.state<ScrollableState>(find.byType(Scrollable)).position.jumpTo(180);
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
