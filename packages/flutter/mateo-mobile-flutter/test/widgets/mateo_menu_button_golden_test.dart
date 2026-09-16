import 'package:alchemist/alchemist.dart';
import 'package:flutter/foundation.dart' show AsyncCallback;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

const _triggerKey = Key('mateo_menu_button_golden_trigger');

void main() {
  group('MateoMenuButton Golden Tests', () {
    for (final placement in [
      (name: 'left', alignment: Alignment.centerRight),
      (name: 'right', alignment: Alignment.centerLeft),
      (name: 'bottom', alignment: Alignment.topCenter),
      (name: 'top', alignment: Alignment.bottomCenter),
    ]) {
      for (final phase in ['open', 'opening_start', 'opening', 'closing']) {
        goldenTest(
          'when popup opens ${placement.name}, it should preserve its origin while $phase',
          fileName: 'mateo_menu_popup_${placement.name}_$phase',
          whilePerforming: (tester) async {
            if (phase.startsWith('opening')) {
              await _configureView(tester);
              await tester.tap(find.byKey(_triggerKey));
              await tester.pump();
              await tester.pump(Duration(milliseconds: phase == 'opening_start' ? 16 : 80));
            } else {
              await _openMenu(tester);
              if (phase == 'closing') {
                await tester.tap(find.text('Share'));
                await tester.pump();
                await tester.pump(const Duration(milliseconds: 80));
              }
            }
            return () async => tester.pumpAndSettle();
          },
          builder: () => _goldenGroup(
            name: 'popup ${placement.name} $phase',
            child: _MenuGoldenApp(
              iconTrigger: true,
              alignment: placement.alignment,
              menuPresentation: const MateoMenuPresentation.context(),
            ),
          ),
        );
      }
    }

    goldenTest(
      'when an icon opens an action menu, it should preserve the circular trigger and expanded surface',
      fileName: 'mateo_menu_button_icon_expand',
      whilePerforming: _openMenu,
      builder: () => _goldenGroup(name: 'icon expand', child: const _MenuGoldenApp(iconTrigger: true)),
    );
    goldenTest(
      'when a circular trigger opens, it should keep its surface attached during the flight',
      fileName: 'mateo_menu_button_icon_opening',
      whilePerforming: (tester) async {
        await _configureView(tester);
        await tester.tap(find.byKey(_triggerKey));
        await tester.pump();
        await tester.pump();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 80));
        return () async => tester.pumpAndSettle();
      },
      builder: () => _goldenGroup(name: 'icon opening', child: const _MenuGoldenApp(iconTrigger: true)),
    );
    goldenTest(
      'when an icon menu closes, it should return to its visible circle',
      fileName: 'mateo_menu_button_icon_closing',
      whilePerforming: (tester) async {
        await _openMenu(tester);
        await tester.tap(find.text('Share'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 80));
        return () async => tester.pumpAndSettle();
      },
      builder: () => _goldenGroup(name: 'icon closing', child: const _MenuGoldenApp(iconTrigger: true)),
    );

    goldenTest(
      'when closed, it should match the approved trigger golden',
      fileName: 'mateo_menu_button_closed',
      whilePerforming: _configureView,
      builder: () => _goldenGroup(
        name: 'closed',
        child: const _MenuGoldenApp(),
      ),
    );

    goldenTest(
      'when opened upward, it should match the approved mixed-actions golden',
      fileName: 'mateo_menu_button_open_upward',
      whilePerforming: _openMenu,
      builder: () => _goldenGroup(
        name: 'open upward',
        child: const _MenuGoldenApp(),
      ),
    );

    goldenTest(
      'when opened downward, it should match the approved fallback golden',
      fileName: 'mateo_menu_button_open_downward',
      whilePerforming: _openMenu,
      builder: () => _goldenGroup(
        name: 'open downward',
        child: const _MenuGoldenApp(alignment: Alignment.topCenter),
      ),
    );

    goldenTest(
      'when opening starts, it should keep the departing surface visible',
      fileName: 'mateo_menu_button_opening_start',
      whilePerforming: (tester) async {
        await _configureView(tester);
        await tester.tap(find.byKey(_triggerKey));
        await tester.pump();
        await tester.pump();
        await tester.pump();
        return () async => tester.pumpAndSettle();
      },
      builder: () => _goldenGroup(
        name: 'opening start',
        child: const _MenuGoldenApp(neutralTrigger: true),
      ),
    );

    goldenTest(
      'when opening, it should match the approved interpolated frame golden',
      fileName: 'mateo_menu_button_opening',
      whilePerforming: (tester) async {
        await _configureView(tester);
        await tester.tap(find.byKey(_triggerKey));
        await tester.pump();
        await tester.pump();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 40));
        return () async => tester.pumpAndSettle();
      },
      builder: () => _goldenGroup(
        name: 'opening interpolation',
        child: const _MenuGoldenApp(neutralTrigger: true),
      ),
    );

    goldenTest(
      'when closing, it should match the approved midpoint golden',
      fileName: 'mateo_menu_button_closing',
      whilePerforming: (tester) async {
        await _openMenu(tester);
        await tester.tapAt(const Offset(8, 400));
        await tester.pump();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 90));
        return () async => tester.pumpAndSettle();
      },
      builder: () => _goldenGroup(
        name: 'closing midpoint with large icons',
        child: const _MenuGoldenApp(largeActions: true),
      ),
    );

    goldenTest(
      'when actions omit optional content, it should match the approved simple golden',
      fileName: 'mateo_menu_button_optional_content',
      whilePerforming: _openMenu,
      builder: () => _goldenGroup(
        name: 'optional content',
        child: const _MenuGoldenApp(simpleActions: true),
      ),
    );

    goldenTest(
      'when the default menu is opened, it should match the approved surface golden',
      fileName: 'mateo_menu_button_dark',
      whilePerforming: _openMenu,
      builder: () => _goldenGroup(
        name: 'dark menu',
        child: const _MenuGoldenApp(
          menuPresentation: const MateoMenuPresentation.action(),
        ),
      ),
    );

    goldenTest(
      'when text is enlarged, it should match the approved large-text golden',
      fileName: 'mateo_menu_button_large_text',
      whilePerforming: _openMenu,
      builder: () => _goldenGroup(
        name: 'large text',
        child: const _MenuGoldenApp(textScaleFactor: 1.6),
      ),
    );
  });
}

GoldenTestGroup _goldenGroup({required String name, required Widget child}) => GoldenTestGroup(
  scenarioConstraints: const BoxConstraints.tightFor(width: 400, height: 800),
  children: [GoldenTestScenario(name: name, child: child)],
);

Future<AsyncCallback?> _configureView(WidgetTester tester) async {
  tester.view
    ..devicePixelRatio = 1
    ..physicalSize = const Size(400, 830)
    ..padding = const FakeViewPadding(top: 44, bottom: 34)
    ..viewPadding = const FakeViewPadding(top: 44, bottom: 34);
  addTearDown(tester.view.reset);
  await tester.pump();
  return null;
}

Future<AsyncCallback?> _openMenu(WidgetTester tester) async {
  await _configureView(tester);
  await tester.tap(find.byKey(_triggerKey));
  await tester.pumpAndSettle();
  return null;
}

class _MenuGoldenApp extends StatelessWidget {
  const _MenuGoldenApp({
    this.alignment = Alignment.center,
    this.neutralTrigger = false,
    this.iconTrigger = false,
    this.largeActions = false,
    this.simpleActions = false,
    this.textScaleFactor = 1,
    this.menuPresentation = const MateoMenuPresentation.action(),
  });

  final Alignment alignment;
  final bool neutralTrigger;
  final bool iconTrigger;
  final bool largeActions;
  final bool simpleActions;
  final double textScaleFactor;
  final MateoMenuPresentation menuPresentation;

  @override
  Widget build(BuildContext context) {
    final actions = largeActions
        ? [
            MateoMenuItem(
              title: 'Post a job',
              description: 'Ask someone nearby for help',
              leadingIconBuilder: (_) => const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blue,
                child: Icon(Icons.edit_outlined, color: Colors.white),
              ),
              onPressed: (_) {},
            ),
            MateoMenuItem(
              title: 'Browse jobs',
              description: 'See what people need right now',
              leadingIconBuilder: (_) => const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.green,
                child: Icon(Icons.work_outline, color: Colors.white),
              ),
              onPressed: (_) {},
            ),
          ]
        : simpleActions
        ? [
            MateoMenuItem(title: 'Duplicate', onPressed: (_) {}),
            MateoMenuItem(title: 'Archive', onPressed: (_) {}),
          ]
        : [
            MateoMenuItem(
              title: 'Share',
              description: 'Send this item to someone',
              leadingIconBuilder: (_) => const Icon(Icons.ios_share_rounded, size: 22),
              onPressed: (_) {},
            ),
            MateoMenuItem(
              title: 'Duplicate',
              description: 'Create another copy',
              leadingIconBuilder: (_) => const Icon(Icons.copy_rounded, size: 22),
              onPressed: (_) {},
            ),
            MateoMenuItem(
              title: 'Delete',
              description: 'This action is unavailable',
              leadingIconBuilder: (_) => const Icon(Icons.delete_outline_rounded, size: 22),
            ),
          ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: mateoTestTheme,
      home: MediaQuery(
        data: MediaQueryData(
          size: const Size(400, 800),
          padding: const EdgeInsets.only(top: 44, bottom: 34),
          viewPadding: const EdgeInsets.only(top: 44, bottom: 34),
          textScaler: TextScaler.linear(textScaleFactor),
        ),
        child: Scaffold(
          body: Align(
            alignment: alignment,
            child: MateoMenuButton(
              buttonPresentation: iconTrigger
                  ? MateoButtonPresentation.icon(
                      variant: MateoButtonVariant.primary.base,
                      elevation: 1,
                      semanticLabel: 'More actions',
                      hitAreaSize: 80,
                      iconBuilder: (state) =>
                          Icon(Icons.more_horiz, color: state.foregroundColor, size: state.iconSize),
                    )
                  : MateoButtonPresentation.label(
                      label: 'More actions',
                      variant: neutralTrigger ? MateoButtonVariant.primary.neutral : MateoButtonVariant.secondary,
                      trailingIconBuilder: (state) => Icon(
                        Icons.expand_more_rounded,
                        color: state.foregroundColor,
                        size: 20,
                      ),
                    ),
              key: _triggerKey,
              menuPresentation: menuPresentation,
              items: actions,
            ),
          ),
        ),
      ),
    );
  }
}
