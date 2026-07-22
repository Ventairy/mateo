import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  group('MateoHero.background', () {
    testWidgets('when building at rest, it should wrap the child in a Hero', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 200,
              child: MateoHeroBackground(
                tag: 'test',
                decoration: BoxDecoration(
                  color: mateoTestColorScheme.background,
                ),
                child: SizedBox.shrink(),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Hero), findsNWidgets(2));
    });

    testWidgets(
      'when building at rest, it should not add a repaint boundary to the feed tree',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 300,
                height: 200,
                child: MateoHeroBackground(
                  tag: 'test',
                  decoration: BoxDecoration(
                    color: mateoTestColorScheme.background,
                  ),
                  child: SizedBox.shrink(),
                ),
              ),
            ),
          ),
        );

        final hero = tester.widget<Hero>(find.byType(Hero).first);
        expect(hero.child, isNot(isA<RepaintBoundary>()));
      },
    );

    testWidgets(
      'when building with a decoration, it should render a DecoratedBox with that decoration',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 300,
                height: 200,
                child: MateoHeroBackground(
                  tag: 'test',
                  decoration: BoxDecoration(
                    color: mateoTestColorScheme.background,
                    borderRadius: BorderRadius.circular(38),
                  ),
                ),
              ),
            ),
          ),
        );

        final decoratedBox = tester.widget<DecoratedBox>(
          find.byType(DecoratedBox),
        );
        final boxDecoration = decoratedBox.decoration as BoxDecoration;
        expect(boxDecoration.color, equals(mateoTestColorScheme.background));
        expect(boxDecoration.borderRadius, equals(BorderRadius.circular(38)));
      },
    );

    testWidgets(
      'when building with a child, it should render the child inside the box',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 300,
                height: 200,
                child: MateoHeroBackground(
                  tag: 'test',
                  decoration: BoxDecoration(
                    color: mateoTestColorScheme.background,
                  ),
                  child: Text('hello'),
                ),
              ),
            ),
          ),
        );

        expect(find.text('hello'), findsOneWidget);
      },
    );

    testWidgets(
      'when building with padding, it should wrap the child in a Padding widget',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 300,
                height: 200,
                child: MateoHeroBackground(
                  tag: 'test',
                  decoration: BoxDecoration(
                    color: mateoTestColorScheme.background,
                  ),
                  padding: EdgeInsets.all(24),
                  child: Text('hello'),
                ),
              ),
            ),
          ),
        );

        final padding = tester.widget<Padding>(find.byType(Padding));
        expect(padding.padding, equals(const EdgeInsets.all(24)));
      },
    );

    testWidgets(
      'when building with width, it should constrain the width via SizedBox',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MateoHeroBackground(
                tag: 'test',
                decoration: BoxDecoration(
                  color: mateoTestColorScheme.background,
                ),
                width: 300,
              ),
            ),
          ),
        );

        final sizedBoxes = find
            .byType(SizedBox)
            .evaluate()
            .map((e) => e.widget as SizedBox);
        final heroSizedBox = sizedBoxes.firstWhere((s) => s.width == 300);
        expect(heroSizedBox.width, equals(300));
      },
    );

    testWidgets(
      'when building with an extension, it should wrap the rendered box content',
      (tester) async {
        const extensionKey = Key('extension');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MateoHeroBackground(
                tag: 'test',
                decoration: BoxDecoration(
                  color: mateoTestColorScheme.background,
                ),
                extensions: [_MateoHeroKeyedExtension(key: extensionKey)],
                child: Text('hello'),
              ),
            ),
          ),
        );

        expect(find.byKey(extensionKey), findsOneWidget);
      },
    );

    testWidgets(
      'when building with multiple extensions, it should apply the first extension as the outer wrapper',
      (tester) async {
        const outerExtensionKey = Key('outer-extension');
        const innerExtensionKey = Key('inner-extension');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MateoHeroBackground(
                tag: 'test',
                decoration: BoxDecoration(
                  color: mateoTestColorScheme.background,
                ),
                extensions: [
                  _MateoHeroKeyedExtension(key: outerExtensionKey),
                  _MateoHeroKeyedExtension(key: innerExtensionKey),
                ],
                child: Text('hello'),
              ),
            ),
          ),
        );

        expect(
          find.ancestor(
            of: find.byKey(innerExtensionKey),
            matching: find.byKey(outerExtensionKey),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'when pushing to a destination background hero and settling, it should invoke only the source callbacks',
      (tester) async {
        final events = <String>[];

        await tester.pumpWidget(
          _MateoHeroBackgroundLifecycleTestApp(events: events),
        );
        await tester.tap(
          find.text(_MateoHeroBackgroundLifecycleTestApp.sourceText),
        );
        await tester.pumpAndSettle();

        expect(events, equals(['source-start', 'source-end']));
      },
    );

    testWidgets(
      'when pushing to a destination background hero and settling, it should invoke the destination onReceived callback',
      (tester) async {
        final receivedEvents = <String>[];

        await tester.pumpWidget(
          _MateoHeroBackgroundLifecycleTestApp(
            events: [],
            receivedEvents: receivedEvents,
          ),
        );
        await tester.tap(
          find.text(_MateoHeroBackgroundLifecycleTestApp.sourceText),
        );
        await tester.pumpAndSettle();

        expect(receivedEvents, equals(['destination-received']));
      },
    );
  });
}

class _MateoHeroKeyedExtension extends MateoHeroExtension {
  const _MateoHeroKeyedExtension({required this.key});

  final Key key;

  @override
  Widget wrap({required BuildContext context, required Widget child}) {
    return KeyedSubtree(key: key, child: child);
  }
}

class _MateoHeroBackgroundLifecycleTestApp extends StatelessWidget {
  const _MateoHeroBackgroundLifecycleTestApp({
    required this.events,
    this.receivedEvents,
  });

  static const sourceText = 'Open background hero';
  static const destinationText = 'Close background hero';

  final List<String> events;
  final List<String>? receivedEvents;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MateoTheme.light(),
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push<void>(
                    MateoHeroPage(
                      builder: (_) => _MateoHeroBackgroundLifecycleDestination(
                        events: events,
                        receivedEvents: receivedEvents,
                      ),
                    ).createRoute(context),
                  );
                },
                child: MateoHeroBackground(
                  tag: 'background-lifecycle',
                  width: 200,
                  height: 80,
                  decoration: BoxDecoration(
                    color: mateoTestColorScheme.background,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onStart: () => events.add('source-start'),
                  onEnd: () => events.add('source-end'),
                  onReceived: receivedEvents != null
                      ? () => receivedEvents!.add('source-received')
                      : null,
                  child: const Center(child: Text(sourceText)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MateoHeroBackgroundLifecycleDestination extends StatelessWidget {
  const _MateoHeroBackgroundLifecycleDestination({
    required this.events,
    this.receivedEvents,
  });

  final List<String> events;
  final List<String>? receivedEvents;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MateoHeroBackground(
          tag: 'background-lifecycle',
          width: 260,
          height: 120,
          decoration: BoxDecoration(
            color: mateoTestColorScheme.buttons.danger.background,
            borderRadius: BorderRadius.circular(24),
          ),
          onStart: () => events.add('destination-start'),
          onEnd: () => events.add('destination-end'),
          onReceived: receivedEvents != null
              ? () => receivedEvents!.add('destination-received')
              : null,
          child: const Center(
            child: Text(_MateoHeroBackgroundLifecycleTestApp.destinationText),
          ),
        ),
      ),
    );
  }
}
