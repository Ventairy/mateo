import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/src/components/mateo_header/mateo_header.dart';

import '../test_app.dart';

void main() {
  group('MateoHeader library', () {
    testWidgets('when imported directly, it should render a standalone header without a view', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: mateoTestTheme,
          home: const Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: MateoHeader(
                presentation: .standalone(
                  title: Text('Contacts'),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Contacts'), findsOneWidget);
      expect(find.byType(MateoHeaderScope), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('when an internal scope is supplied, it should coordinate without depending on a view widget', (
      tester,
    ) async {
      final scrollController = ScrollController(initialScrollOffset: 40);
      var fadeUpdates = 0;
      var presenceUpdates = 0;
      final connection = MateoHeaderConnection(onFadeChanged: () => fadeUpdates++);
      connection.addListener(() => presenceUpdates++);
      addTearDown(scrollController.dispose);
      addTearDown(connection.dispose);

      expect(connection.hasHeader, isFalse);
      expect(connection.resolveFadeExtent(80), isNull);

      await tester.pumpWidget(
        MaterialApp(
          theme: mateoTestTheme,
          home: Scaffold(
            body: Stack(
              children: [
                ListView(
                  controller: scrollController,
                  children: const [SizedBox(height: 2000)],
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: MateoHeaderScope(
                    connection: connection,
                    managedScrollController: scrollController,
                    child: const MateoHeader(presentation: .view(title: Text('Contacts'))),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      expect(connection.hasHeader, isTrue);
      expect(connection.resolveFadeExtent(80), closeTo(79.6875, 0.001));
      expect(presenceUpdates, 1);
      expect(tester.getTopLeft(find.byType(MateoHeader)), Offset.zero);
      expect(tester.getTopLeft(find.text('Contacts')), Offset.zero);

      final previousFadeUpdates = fadeUpdates;
      scrollController.jumpTo(0);
      await tester.pump();

      expect(connection.resolveFadeExtent(80), 0);
      expect(fadeUpdates, greaterThan(previousFadeUpdates));
      expect(presenceUpdates, 1);

      await tester.pumpWidget(const SizedBox.shrink());

      expect(connection.hasHeader, isFalse);
      expect(connection.resolveFadeExtent(80), isNull);
      expect(presenceUpdates, 2);
      expect(tester.takeException(), isNull);
    });
  });
}
