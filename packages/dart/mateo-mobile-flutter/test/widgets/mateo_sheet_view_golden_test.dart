import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/components/mateo_text/mateo_text.dart' show MateoTextScope;

import '../fixtures/surface_transform_test_widgets.dart';

Future<void> main() async {
  late BuildContext launcher;
  await goldenTest(
    'when a sheet has a colored scrolling surface, it should keep both fixed slots and their fades',
    fileName: 'mateo_sheet_view_scrolled',
    constraints: const BoxConstraints.tightFor(width: 390, height: 844),
    pumpBeforeTest: (tester) async {
      await tester.pumpAndSettle();
      final slotStyle = MateoTextPresentation.interface(color: surfaceTransformTheme.colorScheme.onAccent);
      unawaited(
        showMateoSheet<void>(
          context: launcher,
          view: MateoSheetView(
            header: MateoSheetViewHeader(
              presentation: .custom(
                leading: MateoText(
                  'Back',
                  presentation: slotStyle,
                ),
                principal: MateoText(
                  'Choose a stay',
                  presentation: slotStyle,
                ),
                trailing: MateoText(
                  'Help',
                  presentation: slotStyle,
                ),
              ),
            ),
            footer: MateoSheetViewFooter(
              principal: MateoText(
                'Two nights · Two guests',
                presentation: slotStyle,
              ),
            ),
            surface: MateoSheetViewSurface.scrollable(
              color: surfaceTransformTheme.colorScheme.accent,
              alignment: .topCenter,
              edgeEffect: .fade(at: const [.top, .bottom]),
              child: MateoTextScope(
                color: surfaceTransformTheme.colorScheme.onAccent,
                fontSize: 20,
                child: Column(
                  children: [
                    for (var i = 0; i < 16; i++)
                      Padding(
                        padding: const .symmetric(vertical: 24),
                        child: MateoText(
                          'Garden room ${i + 1}',
                          presentation: const .interface(),
                        ),
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

  late BuildContext unreservedLauncher;
  await goldenTest(
    'when a sheet does not reserve header space, it should let the surface begin beneath the fixed header',
    fileName: 'mateo_sheet_view_unreserved_header',
    constraints: const BoxConstraints.tightFor(width: 390, height: 844),
    pumpBeforeTest: (tester) async {
      await tester.pumpAndSettle();
      final foreground = surfaceTransformTheme.colorScheme.onAccent;
      unawaited(
        showMateoSheet<void>(
          context: unreservedLauncher,
          view: MateoSheetView(
            reserveHeaderSpace: false,
            header: MateoSheetViewHeader(
              presentation: .custom(
                leading: MateoText(
                  'Back',
                  presentation: MateoTextPresentation.interface(color: foreground),
                ),
                principal: MateoText(
                  'Garden room',
                  presentation: MateoTextPresentation.interface(color: foreground, fontWeight: FontWeight.w700),
                ),
                trailing: MateoText(
                  'Close',
                  presentation: MateoTextPresentation.interface(color: foreground),
                ),
              ),
            ),
            surface: MateoSheetViewSurface(
              color: surfaceTransformTheme.colorScheme.accent,
              edgeEffect: .fade(at: const [.top]),
              child: ColoredBox(
                color: surfaceTransformTheme.colorScheme.background,
                child: SizedBox(
                  height: 260,
                  child: Align(
                    alignment: .bottomCenter,
                    child: Padding(
                      padding: const .only(bottom: 28),
                      child: MateoText(
                        'A quiet place to arrive',
                        presentation: MateoTextPresentation.interface(
                          color: surfaceTransformTheme.colorScheme.text.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
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
    },
    builder: () => MateoApp(
      theme: surfaceTransformTheme,
      home: Builder(
        builder: (context) {
          unreservedLauncher = context;
          return const SizedBox.expand();
        },
      ),
    ),
  );
}
