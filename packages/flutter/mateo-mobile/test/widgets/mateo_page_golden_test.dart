import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

Future<void> main() async {
  for (final wash in [true, false]) {
    await goldenTest(
      'when ${wash ? 'wash reveals' : 'push moves'} in each direction, it should preserve the page relationship',
      fileName: 'mateo_page_${wash ? 'wash' : 'push'}_directions',
      whilePerforming: (tester) async {
        for (final direction in MateoPageTransitionDirection.values) {
          await tester.tap(find.byKey(ValueKey('open-${direction.name}')));
        }
        await tester.pump();
        await tester.pump(Duration(milliseconds: wash ? 120 : 300));
        return null;
      },
      builder: () => GoldenTestGroup(
        columns: 2,
        children: [
          for (final direction in MateoPageTransitionDirection.values)
            GoldenTestScenario(
              name: direction.name,
              child: SizedBox(
                width: 240,
                height: 320,
                child: _Scene(direction: direction, wash: wash),
              ),
            ),
        ],
      ),
    );
  }
  await goldenTest(
    'when wash finishes returning, it should fade out without a solid circle',
    fileName: 'mateo_page_wash_reverse_tail',
    whilePerforming: (tester) async {
      await tester.tap(find.byKey(const ValueKey('open-up')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('close')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      return null;
    },
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'Return',
          child: const SizedBox(width: 240, height: 320, child: _Scene(direction: .up, wash: true)),
        ),
      ],
    ),
  );
  await goldenTest(
    'when wash uses live content or reduced motion, it should preserve the final content',
    fileName: 'mateo_page_wash_live_reduced',
    whilePerforming: (tester) async {
      for (final finder in [find.byKey(const ValueKey('open-up')), find.byKey(const ValueKey('open-down'))]) {
        await tester.tap(finder);
      }
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 120));
      return null;
    },
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'Live content',
          child: const SizedBox(
            width: 240,
            height: 320,
            child: _Scene(direction: .up, wash: true, snapshotting: false),
          ),
        ),
        GoldenTestScenario(
          name: 'Reduced motion',
          child: const SizedBox(width: 240, height: 320, child: _Scene(direction: .down, wash: true, reduced: true)),
        ),
      ],
    ),
  );
}

final _theme = MateoThemeData.light(accentColor: const Color(0xFF7551FF), onAccent: const Color(0xFFFFFFFF));

class _Scene extends StatelessWidget {
  const _Scene({required this.direction, required this.wash, this.snapshotting = true, this.reduced = false});
  final MateoPageTransitionDirection direction;
  final bool wash;
  final bool snapshotting;
  final bool reduced;

  @override
  Widget build(BuildContext context) => MateoApp(
    theme: _theme,
    builder: (context, child) => MediaQuery(
      data: MediaQueryData(disableAnimations: reduced),
      child: child!,
    ),
    home: Builder(
      builder: (context) => ColoredBox(
        color: _theme.colorScheme.background,
        child: Center(
          child: GestureDetector(
            key: ValueKey('open-${direction.name}'),
            onTap: () => Navigator.of(context).push(
              MateoPage<void>(
                transition: wash ? .wash(direction: direction) : .push(direction: direction),
                allowSnapshotting: snapshotting,
                child: Builder(
                  builder: (context) => ColoredBox(
                    color: _theme.colorScheme.accent,
                    child: Center(
                      child: GestureDetector(
                        key: const ValueKey('close'),
                        onTap: () => Navigator.of(context).pop(),
                        child: Text('Details', style: TextStyle(color: _theme.colorScheme.onAccent, fontSize: 26)),
                      ),
                    ),
                  ),
                ),
              ).createRoute(context),
            ),
            child: Text('Discover', style: TextStyle(color: _theme.colorScheme.text.primary, fontSize: 26)),
          ),
        ),
      ),
    ),
  );
}
