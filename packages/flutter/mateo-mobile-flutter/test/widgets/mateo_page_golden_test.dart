import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  group('MateoPage Golden Tests', () {
    goldenTest(
      'when wash directions reveal, they should match the approved circular gradients',
      fileName: 'mateo_page_wash_directions',
      whilePerforming: (tester) async {
        for (final direction in MateoPageTransitionDirection.values) {
          await tester.tap(find.byKey(_openKey(direction)));
        }
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 120));
        return null;
      },
      builder: () => GoldenTestGroup(
        columnWidthBuilder: (_) => const FixedColumnWidth(240),
        children: [
          for (final direction in MateoPageTransitionDirection.values)
            GoldenTestScenario(
              name: direction.name,
              child: SizedBox(
                width: 240,
                height: 320,
                child: _PageGoldenApp(direction: direction),
              ),
            ),
        ],
      ),
    );

    goldenTest(
      'when push directions move, they should blend without exposing destination content',
      fileName: 'mateo_page_push_directions',
      whilePerforming: (tester) async {
        for (final direction in MateoPageTransitionDirection.values) {
          await tester.tap(find.byKey(_pushOpenKey(direction)));
        }
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        return null;
      },
      builder: () => GoldenTestGroup(
        columnWidthBuilder: (_) => const FixedColumnWidth(240),
        children: [
          for (final direction in MateoPageTransitionDirection.values)
            GoldenTestScenario(
              name: direction.name,
              child: SizedBox(
                width: 240,
                height: 320,
                child: _PushPageGoldenApp(direction: direction),
              ),
            ),
        ],
      ),
    );

    goldenTest(
      'when wash is nearly closed, it should disappear without a small solid circle',
      fileName: 'mateo_page_wash_reverse_tail',
      whilePerforming: (tester) async {
        await tester.tap(find.byKey(_reverseOpenKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(_reverseCloseKey));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        return null;
      },
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'Near completion',
            child: const SizedBox(
              width: 240,
              height: 320,
              child: _ReverseTailGoldenApp(),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'when wash blends high-contrast pages, it should keep the feather visually continuous',
      fileName: 'mateo_page_wash_feather',
      whilePerforming: (tester) async {
        await tester.tap(find.byKey(_featherOpenKey));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 120));
        return null;
      },
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'High contrast',
            child: const SizedBox(
              width: 390,
              height: 640,
              child: _FeatherGoldenApp(),
            ),
          ),
        ],
      ),
    );
  });
}

const _featherOpenKey = Key('open-feather-page');
const _reverseOpenKey = Key('open-reverse-page');
const _reverseCloseKey = Key('close-reverse-page');

ValueKey<String> _openKey(MateoPageTransitionDirection direction) {
  return ValueKey('open-${direction.name}');
}

ValueKey<String> _pushOpenKey(MateoPageTransitionDirection direction) {
  return ValueKey('push-open-${direction.name}');
}

class _ReverseTailGoldenApp extends StatelessWidget {
  const _ReverseTailGoldenApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: mateoTestTheme.copyWith(platform: TargetPlatform.android),
      home: Builder(
        builder: (context) {
          return ColoredBox(
            color: const Color(0xFFFFE5D8),
            child: Center(
              child: FilledButton(
                key: _reverseOpenKey,
                onPressed: () {
                  Navigator.of(context).push(
                    MateoPage<void>(
                      transition: MateoPageTransition.wash(),
                      child: ColoredBox(
                        color: const Color(0xFF5B3FD6),
                        child: Center(
                          child: FilledButton(
                            key: _reverseCloseKey,
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close'),
                          ),
                        ),
                      ),
                    ).createRoute(context),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FeatherGoldenApp extends StatelessWidget {
  const _FeatherGoldenApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: mateoTestTheme.copyWith(platform: TargetPlatform.android),
      home: Builder(
        builder: (context) {
          return ColoredBox(
            color: Colors.white,
            child: Center(
              child: FilledButton(
                key: _featherOpenKey,
                onPressed: () {
                  Navigator.of(context).push(
                    MateoPage<void>(
                      transition: MateoPageTransition.wash(),
                      child: const ColoredBox(color: Color(0xFF141313)),
                    ).createRoute(context),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PageGoldenApp extends StatelessWidget {
  const _PageGoldenApp({required this.direction});

  final MateoPageTransitionDirection direction;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: mateoTestTheme.copyWith(platform: TargetPlatform.android),
      home: Builder(
        builder: (context) {
          return ColoredBox(
            color: const Color(0xFFFFE5D8),
            child: Center(
              child: FilledButton(
                key: _openKey(direction),
                onPressed: () {
                  Navigator.of(context).push(
                    MateoPage<void>(
                      transition: MateoPageTransition.wash(
                        direction: direction,
                      ),
                      child: const ColoredBox(
                        color: const Color(0xFF5B3FD6),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: EdgeInsets.only(top: 36),
                                child: Text(
                                  'DESTINATION',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: MateoTypography.fontFamily,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 24),
                                child: Icon(
                                  Icons.keyboard_arrow_up_rounded,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).createRoute(context),
                  );
                },
                child: Text(direction.name),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PushPageGoldenApp extends StatelessWidget {
  const _PushPageGoldenApp({required this.direction});

  final MateoPageTransitionDirection direction;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: mateoTestTheme.copyWith(platform: TargetPlatform.android),
      home: Builder(
        builder: (context) {
          return ColoredBox(
            color: const Color(0xFFFFE5D8),
            child: Stack(
              children: [
                const Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 36),
                    child: Text(
                      'SOURCE',
                      style: TextStyle(
                        color: Color(0xFF141313),
                        fontFamily: MateoTypography.fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: FilledButton(
                    key: _pushOpenKey(direction),
                    onPressed: () {
                      Navigator.of(context).push(
                        MateoPage<void>(
                          transition: MateoPageTransition.push(
                            direction: direction,
                          ),
                          child: const ColoredBox(
                            color: Color(0xFF5B3FD6),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: EdgeInsets.only(top: 36),
                                child: Text(
                                  'DESTINATION',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: MateoTypography.fontFamily,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ).createRoute(context),
                      );
                    },
                    child: Text(direction.name),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
