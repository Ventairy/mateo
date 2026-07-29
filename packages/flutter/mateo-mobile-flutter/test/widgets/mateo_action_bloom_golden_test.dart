import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

const _sourceKey = Key('action_bloom_source');

void main() {
  group('MateoActionBloom Golden Tests', () {
    goldenTest(
      'when opened from the bottom, it should match the approved modal golden',
      fileName: 'mateo_action_bloom_open',
      whilePerforming: (tester) async {
        await _configureView(tester);
        await tester.tap(find.byKey(_sourceKey));
        await tester.pumpAndSettle();
        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 400,
          height: 800,
        ),
        children: [
          GoldenTestScenario(
            name: 'bottom open with descriptions',
            child: const _ActionBloomGoldenApp(),
          ),
        ],
      ),
    );

    goldenTest(
      'when opening, it should match the approved surface-transform golden',
      fileName: 'mateo_action_bloom_opening',
      whilePerforming: (tester) async {
        await _configureView(tester);
        await tester.tap(find.byKey(_sourceKey));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 400,
          height: 800,
        ),
        children: [
          GoldenTestScenario(
            name: 'opening',
            child: const _ActionBloomGoldenApp(),
          ),
        ],
      ),
    );

    goldenTest(
      'when a button opens, it should interpolate the pill into the panel',
      fileName: 'mateo_action_bloom_button_opening',
      whilePerforming: (tester) async {
        await _configureView(tester);
        await tester.tap(find.byKey(_sourceKey));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 400,
          height: 800,
        ),
        children: [
          GoldenTestScenario(
            name: 'button opening',
            child: const _ActionBloomGoldenApp(usesButtonSource: true),
          ),
        ],
      ),
    );

    goldenTest(
      'when opened from the top, it should match the approved safe-area golden',
      fileName: 'mateo_action_bloom_top',
      whilePerforming: (tester) async {
        await _configureView(tester);
        await tester.tap(find.byKey(_sourceKey));
        await tester.pumpAndSettle();
        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 400,
          height: 800,
        ),
        children: [
          GoldenTestScenario(
            name: 'top open below safe area',
            child: const _ActionBloomGoldenApp(alignment: Alignment.topRight),
          ),
        ],
      ),
    );

    goldenTest(
      'when text is enlarged, it should match the approved accessible golden',
      fileName: 'mateo_action_bloom_large_text',
      whilePerforming: (tester) async {
        await _configureView(tester);
        await tester.tap(find.byKey(_sourceKey));
        await tester.pumpAndSettle();
        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 400,
          height: 800,
        ),
        children: [
          GoldenTestScenario(
            name: 'large text',
            child: const _ActionBloomGoldenApp(textScaleFactor: 1.6),
          ),
        ],
      ),
    );
  });
}

Future<void> _configureView(WidgetTester tester) async {
  tester.view
    ..devicePixelRatio = 1
    ..physicalSize = const Size(400, 830)
    ..padding = const FakeViewPadding(top: 44, bottom: 34)
    ..viewPadding = const FakeViewPadding(top: 44, bottom: 34);
  addTearDown(tester.view.reset);
  await tester.pump();
}

class _ActionBloomGoldenApp extends StatelessWidget {
  const _ActionBloomGoldenApp({
    this.alignment = Alignment.bottomRight,
    this.textScaleFactor = 1,
    this.usesButtonSource = false,
  });

  final Alignment alignment;
  final double textScaleFactor;
  final bool usesButtonSource;

  @override
  Widget build(BuildContext context) {
    final actions = [
      _action('Create note', 'Start with a fresh, empty note.', Icons.add),
      _action(
        'Lock note',
        'Require authentication before opening.',
        Icons.lock,
      ),
      _action('Delete note', null, Icons.delete),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MateoTheme.light(),
      home: MediaQuery(
        data: MediaQueryData(
          size: const Size(400, 800),
          padding: const EdgeInsets.only(top: 44, bottom: 34),
          viewPadding: const EdgeInsets.only(top: 44, bottom: 34),
          textScaler: TextScaler.linear(textScaleFactor),
        ),
        child: Scaffold(
          body: Stack(
            children: [
              const _NotesSurface(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Align(
                  alignment: alignment,
                  child: usesButtonSource
                      ? MateoButton.actionBloom(
                          key: _sourceKey,
                          label: 'Note actions',
                          variant: MateoButtonVariant.primary,
                          actions: actions,
                        )
                      : MateoFloatingActionButton.actionBloom(
                          key: _sourceKey,
                          semanticLabel: 'Note actions',
                          actions: actions,
                          iconBuilder: (state) => Icon(
                            Icons.more_horiz,
                            color: state.foregroundColor,
                            size: state.iconSize,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

MateoActionBloomAction _action(
  String title,
  String? description,
  IconData icon,
) {
  return MateoActionBloomAction(
    title: title,
    description: description,
    iconBuilder: (state) =>
        Icon(icon, color: state.foregroundColor, size: state.iconSize),
    onPressed: (feedbackAnimation) async {},
  );
}

class _NotesSurface extends StatelessWidget {
  const _NotesSurface();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notes',
              style: TextStyle(
                fontFamily: MateoTypography.fontFamily,
                fontSize: 30,
                fontWeight: FontWeight.w700,
                letterSpacing: MateoTypography.letterSpacing,
              ),
            ),
            const SizedBox(height: 24),
            for (final note in const [
              ('Plan the garden', 'Choose herbs for the sunny corner'),
              ('Weekend errands', 'Market, library, and fresh flowers'),
              ('Book ideas', 'Small rituals that make a place feel like home'),
            ]) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.$1,
                      style: const TextStyle(
                        fontFamily: MateoTypography.fontFamily,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: MateoTypography.letterSpacing,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      note.$2,
                      style: const TextStyle(
                        color: Color(0xFF5E5E5E),
                        fontFamily: MateoTypography.fontFamily,
                        fontSize: 14,
                        letterSpacing: MateoTypography.letterSpacing,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}
