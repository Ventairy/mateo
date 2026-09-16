import 'package:alchemist/alchemist.dart';
import 'package:flutter/foundation.dart' show AsyncCallback;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

const _sourceKey = Key('mateo_select_golden_source');

void main() {
  group('MateoSelect Golden Tests', () {
    for (final stage in ['closed', 'opening', 'open', 'closing']) {
      goldenTest(
        'when ghost is $stage, it should preserve its transparent source and shared menu colors',
        fileName: 'mateo_select_ghost_$stage',
        builder: () => _goldenGroup(
          name: 'ghost $stage',
          child: const _SelectGoldenApp(
            presentation: MateoSelectPresentation.ghost(),
          ),
        ),
        whilePerforming: (tester) async {
          await _configureView(tester);
          if (stage == 'closed') return null;
          await tester.tap(find.byKey(_sourceKey));
          await tester.pump();
          await tester.pump();
          if (stage == 'opening') {
            await tester.pump(const Duration(milliseconds: 80));
          } else {
            await tester.pumpAndSettle();
            if (stage == 'closing') {
              await tester.tap(find.byKey(const ValueKey<Object>(('mateo_select_option_semantics', 'fixed'))));
              await tester.pump();
              await tester.pump();
              await tester.pump();
              await tester.pump();
              await tester.pump(const Duration(milliseconds: 80));
            }
          }
          return () async {
            await tester.pumpAndSettle();
          };
        },
      );
    }

    goldenTest(
      'when closed, it should match the approved neutral golden',
      fileName: 'mateo_select_closed',
      whilePerforming: _configureView,
      builder: () => _goldenGroup(name: 'closed', child: const _SelectGoldenApp()),
    );

    goldenTest(
      'when opened without descriptions, it should match the approved menu golden',
      fileName: 'mateo_select_open',
      whilePerforming: (tester) async {
        await _configureView(tester);
        await tester.tap(find.byKey(_sourceKey));
        await tester.pumpAndSettle();
        return null;
      },
      builder: () => _goldenGroup(
        name: 'open without descriptions',
        child: const _SelectGoldenApp(),
      ),
    );

    goldenTest(
      'when opened with descriptions, it should match the approved menu golden',
      fileName: 'mateo_select_open_descriptions',
      whilePerforming: (tester) async {
        await _configureView(tester);
        await tester.tap(find.byKey(_sourceKey));
        await tester.pumpAndSettle();
        return null;
      },
      builder: () => _goldenGroup(
        name: 'open with descriptions',
        child: const _SelectGoldenApp(withDescriptions: true),
      ),
    );

    goldenTest(
      'when opening, it should match the approved animation frame golden',
      fileName: 'mateo_select_opening',
      whilePerforming: (tester) async {
        await _configureView(tester);
        await tester.tap(find.byKey(_sourceKey));
        await tester.pump();
        await tester.pump();
        await tester.pump(const Duration(microseconds: 91667));
        return () async {
          await tester.pumpAndSettle();
        };
      },
      builder: () => _goldenGroup(
        name: 'opening animation',
        child: const _SelectGoldenApp(
          initialValue: 'range',
          withDescriptions: true,
        ),
      ),
    );

    goldenTest(
      'when dismissed outside, it should match the approved return animation golden',
      fileName: 'mateo_select_closing_outside',
      whilePerforming: (tester) async {
        await _configureView(tester);
        await tester.tap(find.byKey(_sourceKey));
        await tester.pumpAndSettle();
        await tester.tapAt(const Offset(390, 400));
        await tester.pump();
        await tester.pump();
        await tester.pump();
        await tester.pump(const Duration(microseconds: 45833));
        return () async {
          await tester.pumpAndSettle();
        };
      },
      builder: () => _goldenGroup(
        name: 'outside dismissal animation',
        child: const _SelectGoldenApp(withDescriptions: true),
      ),
    );

    goldenTest(
      'when selecting an option, it should fly that row from its position',
      fileName: 'mateo_select_closing_selection',
      whilePerforming: (tester) async {
        await _configureView(tester);
        await tester.tap(find.byKey(_sourceKey));
        await tester.pumpAndSettle();
        await tester.tap(
          find.descendant(
            of: find.byKey(const Key('mateo_select_panel')),
            matching: find.text('Faixa'),
          ),
        );
        await tester.pump();
        await tester.pump();
        await tester.pump();
        await tester.pump();
        await tester.pump(const Duration(microseconds: 91667));
        return () async {
          await tester.pumpAndSettle();
        };
      },
      builder: () => _goldenGroup(
        name: 'selection return animation',
        child: const _SelectGoldenApp(withDescriptions: true),
      ),
    );

    goldenTest(
      'when selection nears the trigger, it should use the new trigger width',
      fileName: 'mateo_select_closing_selection_target',
      whilePerforming: (tester) async {
        await _configureView(tester);
        await tester.tap(find.byKey(_sourceKey));
        await tester.pumpAndSettle();
        await tester.tap(
          find.descendant(
            of: find.byKey(const Key('mateo_select_panel')),
            matching: find.text('Faixa'),
          ),
        );
        await tester.pump();
        await tester.pump();
        await tester.pump();
        await tester.pump();
        await tester.pump(const Duration(microseconds: 187500));
        return () async {
          await tester.pumpAndSettle();
        };
      },
      builder: () => _goldenGroup(
        name: 'selection return target',
        child: const _SelectGoldenApp(withDescriptions: true),
      ),
    );

    goldenTest(
      'when text is enlarged, it should match the approved safe-area golden',
      fileName: 'mateo_select_large_text',
      whilePerforming: (tester) async {
        await _configureView(tester);
        await tester.tap(find.byKey(_sourceKey));
        await tester.pumpAndSettle();
        return null;
      },
      builder: () => _goldenGroup(
        name: 'large text open',
        child: const _SelectGoldenApp(
          withDescriptions: true,
          textScaleFactor: 1.6,
        ),
      ),
    );
  });
}

GoldenTestGroup _goldenGroup({required String name, required Widget child}) => GoldenTestGroup(
  scenarioConstraints: const BoxConstraints.tightFor(
    width: 400,
    height: 800,
  ),
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

class _SelectGoldenApp extends StatelessWidget {
  const _SelectGoldenApp({
    this.initialValue = 'combine',
    this.presentation = const MateoSelectPresentation.neutral(),
    this.withDescriptions = false,
    this.textScaleFactor = 1,
  });

  final MateoSelectPresentation presentation;
  final String initialValue;
  final bool withDescriptions;
  final double textScaleFactor;

  @override
  Widget build(BuildContext context) {
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
          body: Center(
            child: MateoSelect<String>(
              presentation: presentation,
              onSelected: (value, animation) {},
              key: _sourceKey,
              initialValue: initialValue,
              options: [
                _option(
                  value: 'combine',
                  title: 'A combinar',
                  description: withDescriptions ? 'Decide com a pessoa' : null,
                ),
                _option(
                  value: 'fixed',
                  title: 'Valor fixo',
                  description: withDescriptions ? 'Pagar um valor só pra quem for' : null,
                ),
                _option(
                  value: 'range',
                  title: 'Faixa',
                  description: withDescriptions ? 'Pagar entre dois valores' : null,
                ),
                _option(
                  value: 'other',
                  title: 'Outro',
                  description: withDescriptions ? 'Pagar uma outra coisa que não seja dinheiro' : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

MateoSelectOption<String> _option({
  required String value,
  required String title,
  String? description,
}) => MateoSelectOption(
  value: value,
  title: title,
  description: description,
  iconBuilder: (state) => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: mateoTestColorScheme.inverse.background,
      shape: BoxShape.circle,
    ),
    alignment: Alignment.center,
    child: Text(
      r'$',
      style: TextStyle(
        color: mateoTestColorScheme.inverse.onBackground,
        fontFamily: MateoTypography.fontFamily,
        fontSize: state.iconSize,
        fontWeight: FontWeight.w600,
        height: 1,
      ),
    ),
  ),
);
