import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  group('when constructing MateoGroupedListRow', () {
    test('with an empty title, it should throw AssertionError', () {
      expect(
        () => MateoGroupedListRow(
          leading: const SizedBox.shrink(),
          title: '',
        ),
        throwsAssertionError,
      );
    });

    test('with an empty description, it should throw AssertionError', () {
      expect(
        () => MateoGroupedListRow(
          leading: const SizedBox.shrink(),
          title: 'Place',
          description: '',
        ),
        throwsAssertionError,
      );
    });
  });

  group('when rendering MateoGroupedList', () {
    testWidgets('inside a scrolling parent, it should size itself to all children', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: SizedBox(
            width: 360,
            height: 180,
            child: SingleChildScrollView(
              child: MateoGroupedList(
                children: [_row(0), _row(1), _row(2), _row(3)],
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Place 3'), findsOneWidget);
      expect(
        tester.getSize(find.byType(MateoGroupedList)).height,
        greaterThan(180),
      );
      expect(find.byType(Scrollable), findsOneWidget);
    });

    testWidgets('with children, it should preserve their supplied order', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: SizedBox(
            width: 360,
            height: 260,
            child: MateoGroupedList(
              children: [_row(0), _row(1), _row(2)],
            ),
          ),
        ),
      );

      expect(
        tester.getTopLeft(find.text('Place 0')).dy,
        lessThan(tester.getTopLeft(find.text('Place 1')).dy),
      );
      expect(
        tester.getTopLeft(find.text('Place 1')).dy,
        lessThan(tester.getTopLeft(find.text('Place 2')).dy),
      );
    });

    testWidgets('with adjacent rows, it should paint only inset data dividers', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: SizedBox(
            width: 360,
            height: 260,
            child: MateoGroupedList(
              children: [_row(0), _row(1), _row(2)],
            ),
          ),
        ),
      );

      final dividers = tester.widgetList<PositionedDirectional>(
        find.byType(PositionedDirectional),
      );
      expect(dividers, hasLength(2));
      for (final divider in dividers) {
        expect(divider.start, 84);
        expect(divider.end, 24);
        expect(divider.height, 1);
      }
    });

    testWidgets('with a keyed row, it should preserve the consumer key', (
      tester,
    ) async {
      const rowKey = ValueKey('stable-place');
      await tester.pumpWidget(
        const TestApp(
          child: SizedBox(
            width: 360,
            height: 100,
            child: MateoGroupedList(
              children: [
                MateoGroupedListRow(
                  key: rowKey,
                  leading: SizedBox.shrink(),
                  title: 'Place',
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byKey(rowKey), findsOneWidget);
    });

    testWidgets('with interactive rows, it should activate through divider-adjacent space', (
      tester,
    ) async {
      final presses = <int>[];
      await tester.pumpWidget(
        TestApp(
          child: SizedBox(
            width: 360,
            height: 180,
            child: MateoGroupedList(
              children: [
                for (var index = 0; index < 2; index++)
                  MateoGroupedListRow(
                    leading: const SizedBox.shrink(),
                    title: 'Place $index',
                    onPressed: (animation) async {
                      presses.add(index);
                      await animation;
                    },
                  ),
              ],
            ),
          ),
        ),
      );

      final firstRowBounds = tester.getRect(
        find.byType(MateoGroupedListRow).first,
      );
      await tester.tapAt(
        firstRowBounds.bottomLeft + const Offset(100, -0.5),
      );
      await tester.pumpAndSettle();

      expect(presses, [0]);
    });

    testWidgets('with an interactive row, it should expose its title as button semantics', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        TestApp(
          child: MateoGroupedListRow(
            leading: const SizedBox.shrink(),
            title: 'Place',
            onPressed: (animation) async {},
          ),
        ),
      );

      final data = tester
          .getSemantics(
            find.descendant(
              of: find.byType(MateoGroupedListRow),
              matching: find.byType(MateoTap),
            ),
          )
          .getSemanticsData();
      semantics.dispose();

      expect(
        (label: data.label, button: data.flagsCollection.isButton, tap: data.hasAction(SemanticsAction.tap)),
        (label: 'Place', button: true, tap: true),
      );
    });

    testWidgets('when children change, it should display the consumer update', (
      tester,
    ) async {
      var childCount = 1;
      late StateSetter updateChildren;
      await tester.pumpWidget(
        TestApp(
          child: StatefulBuilder(
            builder: (context, setState) {
              updateChildren = setState;
              return MateoGroupedList(
                children: [
                  for (var index = 0; index < childCount; index++) _row(index),
                ],
              );
            },
          ),
        ),
      );

      expect(find.text('Place 1'), findsNothing);
      updateChildren(() => childCount = 2);
      await tester.pump();

      expect(find.text('Place 1'), findsOneWidget);
    });
  });
}

MateoGroupedListRow _row(int index) => MateoGroupedListRow(
  leading: const SizedBox.square(dimension: 24),
  title: 'Place $index',
  description: 'Neighborhood $index',
);
