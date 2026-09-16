import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  for (final scenario in [
    (name: 'growing_before_switch', grow: true, reverse: false, elapsed: 12),
    (name: 'growing_after_switch', grow: true, reverse: false, elapsed: 98),
    (name: 'shrinking_before_switch', grow: false, reverse: false, elapsed: 12),
    (name: 'shrinking_after_switch', grow: false, reverse: false, elapsed: 98),
    (name: 'returning', grow: true, reverse: true, elapsed: 12),
  ]) {
    goldenTest(
      'when ${scenario.name}, it should show one morphing surface and a moving close button',
      fileName: 'mateo_sheet_${scenario.name}',
      whilePerforming: (tester) async {
        await tester.tap(find.text('Open sheet'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Continue'));
        if (scenario.reverse) {
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(const Key('mateo_sheet_close_button')).hitTestable());
        }
        await tester.pump();
        await tester.pump();
        // Preserve the approved capture points as fractions of the route duration.
        await tester.pump(Duration(microseconds: scenario.elapsed * 350000 ~/ 130));
        expect(tester.takeException(), isNull);
        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(width: 400, height: 800),
        children: [
          GoldenTestScenario(
            name: scenario.name,
            child: _StackGoldenApp(grow: scenario.grow),
          ),
        ],
      ),
    );
  }
}

class _StackGoldenApp extends StatelessWidget {
  const _StackGoldenApp({required this.grow});

  final bool grow;

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: mateoTestTheme,
    home: Scaffold(
      body: Builder(
        builder: (context) => Center(
          child: FilledButton(
            onPressed: () => MateoSheet.show<void>(
              context,
              presentation: const MateoSheetPresentation.bottom(),
              child: _SheetContent(height: grow ? 180 : 360, nextHeight: grow ? 360 : 180),
            ),
            child: const Text('Open sheet'),
          ),
        ),
      ),
    ),
  );
}

class _SheetContent extends StatelessWidget {
  const _SheetContent({required this.height, this.nextHeight});

  final double height;
  final double? nextHeight;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 60),
          child: Text(
            nextHeight == null ? 'Choose a time' : 'Plan your visit',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 12),
        Text(nextHeight == null ? 'Your details stay here while you choose.' : 'Find a moment that works for you.'),
        const Spacer(),
        MateoButton(
          presentation: MateoButtonPresentation.label(
            label: nextHeight == null ? 'Confirm' : 'Continue',
            variant: MateoButtonVariant.primary,
          ),
          onPressed: () {
            if (nextHeight case final height?) {
              MateoSheet.show<void>(
                context,
                presentation: const MateoSheetPresentation.bottom(),
                child: _SheetContent(height: height),
              );
            }
          },
        ),
      ],
    ),
  );
}
