import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  testWidgets('when displaying every country, it should find bundled artwork', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: .ltr,
        child: SingleChildScrollView(
          child: Wrap(
            children: [for (final country in Country.values) MateoCountryFlag(country: country, size: 24)],
          ),
        ),
      ),
    );
    expect(find.byType(MateoCountryFlag), findsNWidgets(Country.values.length));
    expect(find.byType(ClipOval), findsNWidgets(Country.values.length));
    expect(tester.takeException(), isNull);
  });

  testWidgets('when a size is supplied, it should render a circle at that size', (tester) async {
    await tester.pumpWidget(const Center(child: MateoCountryFlag(country: .brazil, size: 38)));
    expect(tester.getSize(find.byType(MateoCountryFlag)), const Size.square(38));
    expect(find.byType(ClipOval), findsOneWidget);
  });

  testWidgets('when parent constraints are smaller, it should fit them', (tester) async {
    await tester.pumpWidget(
      const Center(
        child: SizedBox.square(dimension: 20, child: MateoCountryFlag(country: .brazil, size: 38)),
      ),
    );
    expect(tester.getSize(find.byType(MateoCountryFlag)), const Size.square(20));
    expect(tester.takeException(), isNull);
  });

  testWidgets('when size is zero, it should render empty', (tester) async {
    await tester.pumpWidget(const Center(child: MateoCountryFlag(country: .brazil, size: 0)));
    expect(tester.getSize(find.byType(MateoCountryFlag)), Size.zero);
    expect(find.byType(CustomPaint), findsNothing);
  });

  test('when the size is invalid, it should assert', () {
    for (final size in [-1.0, double.infinity, double.negativeInfinity, double.nan]) {
      expect(() => MateoCountryFlag(country: .brazil, size: size), throwsAssertionError);
    }
  });

  testWidgets('when labeled, it should expose one image label', (tester) async {
    final handle = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        const Directionality(
          textDirection: .ltr,
          child: Center(
            child: MateoCountryFlag(country: .brazil, size: 32, semanticLabel: 'Brasil'),
          ),
        ),
      );
      expect(find.bySemanticsLabel('Brasil'), findsOneWidget);
      expect(tester.getSemantics(find.byType(MateoCountryFlag)), matchesSemantics(label: 'Brasil', isImage: true));
    } finally {
      handle.dispose();
    }
  });

  testWidgets('when decorative, it should leave the country label to its parent', (tester) async {
    final handle = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        Directionality(
          textDirection: .ltr,
          child: Center(
            child: Semantics(
              container: true,
              label: 'Brazil',
              child: const MateoCountryFlag(country: .brazil, size: 32),
            ),
          ),
        ),
      );
      expect(find.bySemanticsLabel('Brazil'), findsOneWidget);
      expect(tester.getSemantics(find.byType(MateoCountryFlag)), matchesSemantics(label: 'Brazil'));
    } finally {
      handle.dispose();
    }
  });
}
