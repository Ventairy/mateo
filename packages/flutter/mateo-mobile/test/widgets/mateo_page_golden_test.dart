import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

Future<void> main() async {
  for (final transition in _PageTransition.values) {
    await goldenTest(
      'when ${transition.description} in each direction, it should preserve the page relationship',
      fileName: 'mateo_page_${transition.name}_directions',
      whilePerforming: (tester) async {
        for (final direction in MateoPageTransitionDirection.values) {
          await tester.tap(find.byKey(ValueKey('open-${direction.name}')));
        }
        await tester.pump();
        await tester.pump(transition.goldenDuration);
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
                child: _Scene(direction: direction, transition: transition),
              ),
            ),
        ],
      ),
    );
  }
  await goldenTest(
    'when slide returns, it should move toward its source edge over the stationary page',
    fileName: 'mateo_page_slide_reverse',
    whilePerforming: (tester) async {
      await tester.tap(find.byKey(const ValueKey('open-up')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('close')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      return null;
    },
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'Return',
          child: const SizedBox(width: 240, height: 320, child: _Scene(direction: .up, transition: .slide)),
        ),
      ],
    ),
  );
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
          child: const SizedBox(width: 240, height: 320, child: _Scene(direction: .up, transition: .wash)),
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
            child: _Scene(direction: .up, transition: .wash, snapshotting: false),
          ),
        ),
        GoldenTestScenario(
          name: 'Reduced motion',
          child: const SizedBox(width: 240, height: 320, child: _Scene(direction: .down, transition: .wash, reduced: true)),
        ),
      ],
    ),
  );
}

final _theme = MateoThemeData.light(accentColor: const Color(0xFF7551FF), onAccent: const Color(0xFFFFFFFF));

enum _PageTransition {
  wash(description: 'wash reveals', goldenDuration: Duration(milliseconds: 120)),
  push(description: 'push moves', goldenDuration: Duration(milliseconds: 300)),
  slide(description: 'slide moves the destination', goldenDuration: Duration(milliseconds: 195));

  const _PageTransition({required this.description, required this.goldenDuration});

  final String description;
  final Duration goldenDuration;

  MateoPageTransition transition(MateoPageTransitionDirection direction) => switch (this) {
    .wash => .wash(direction: direction),
    .push => .push(direction: direction),
    .slide => .slide(direction: direction),
  };
}

class _Scene extends StatelessWidget {
  const _Scene({required this.direction, required this.transition, this.snapshotting = true, this.reduced = false});
  final MateoPageTransitionDirection direction;
  final _PageTransition transition;
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
                transition: transition.transition(direction),
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
