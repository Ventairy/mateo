import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import '../test_app.dart';

void main() {
  group('MateoSearchBarButton', () {
    test('when accessing searchBarHeight, it should equal 60', () {
      expect(MateoSearchBarButton.searchBarHeight, equals(60));
    });

    testWidgets('when rendering, the SizedBox height should be 60', (
      tester,
    ) async {
      await tester.pumpWidget(
        const TestApp(child: MateoSearchBarButton(title: 'Search...')),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.byWidgetPredicate((w) => w is SizedBox && w.height == 60),
      );

      expect(sizedBox.height, equals(60));
    });
  });
}
