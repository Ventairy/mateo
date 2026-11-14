import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/logo_test_helpers.dart';

void main() {
  test('when logos are bundled, it should preserve the canonical SVGs byte for byte', () {
    final source = Directory('../../../design-system/foundation/assets/logos');
    final canonical = source.listSync().whereType<File>().where((file) => file.path.endsWith('.svg')).toList();
    final bundled = Directory('assets/logos').listSync().whereType<File>().toList();
    expect(
      bundled.map((file) => file.uri.pathSegments.last).toSet(),
      canonical.map((file) => file.uri.pathSegments.last).toSet(),
    );
    for (final file in canonical) {
      final name = file.uri.pathSegments.last;
      expect(File('assets/logos/$name').readAsBytesSync(), file.readAsBytesSync(), reason: name);
    }
  });

  testWidgets('when displaying the catalog, it should paint every logo including embedded images', (tester) async {
    await tester.pumpWidget(
      logoHost(Wrap(children: [for (final logo in MateoLogoData.values) MateoLogo(logo, size: 40)])),
    );
    await settleLogoImages(tester);
    expect(find.byType(MateoLogo), findsNWidgets(MateoLogoData.values.length));
    expect(find.byType(CustomPaint), findsNWidgets(MateoLogoData.values.length));
    expect(tester.takeException(), isNull);
  });

  testWidgets('when size is omitted or explicit, it should use the natural or requested frame', (tester) async {
    await tester.pumpWidget(logoHost(const MateoLogo(.telegram)));
    expect(tester.getSize(find.byType(MateoLogo)), const Size.square(20));
    await tester.pumpWidget(logoHost(const MateoLogo(.telegram, size: 40)));
    expect(tester.getSize(find.byType(MateoLogo)), const Size.square(40));
    expect(tester.getSize(find.byType(CustomPaint)), const Size.square(40));
  });

  testWidgets('when a parent is smaller and rectangular, it should center a proportional square frame', (tester) async {
    await tester.pumpWidget(
      logoHost(const SizedBox(width: 10, height: 8, child: MateoLogo(.telegram, size: 40))),
    );
    final frame = tester.getRect(find.byType(MateoLogo));
    final artwork = tester.getRect(find.byType(CustomPaint));
    expect(frame.size, const Size(10, 8));
    expect(artwork.shift(-frame.topLeft), const Rect.fromLTWH(1, 0, 8, 8));
    expect(tester.takeException(), isNull);
  });

  testWidgets('when scopes nest and change, it should inherit omitted sizes and update constant descendants', (
    tester,
  ) async {
    final size = ValueNotifier<double>(24);
    addTearDown(size.dispose);
    await tester.pumpWidget(
      logoHost(
        ValueListenableBuilder<double>(
          valueListenable: size,
          child: const MateoLogoScope(child: MateoLogo(.telegram)),
          builder: (context, value, child) => MateoLogoScope(size: value, child: child!),
        ),
      ),
    );
    expect(tester.getSize(find.byType(MateoLogo)), const Size.square(24));
    size.value = 32;
    await tester.pump();
    expect(tester.getSize(find.byType(MateoLogo)), const Size.square(32));
    await tester.pumpWidget(
      logoHost(
        const MateoLogoScope(
          size: 32,
          child: MateoLogoScope(size: 18, child: MateoLogo(.telegram)),
        ),
      ),
    );
    expect(tester.getSize(find.byType(MateoLogo)), const Size.square(18));
  });

  testWidgets('when a logo supplies a size, it should override every inherited default', (tester) async {
    await tester.pumpWidget(
      logoHost(
        const MateoLogoScope(
          size: 32,
          child: MateoLogoScope(size: 24, child: MateoLogo(.telegram, size: 16)),
        ),
      ),
    );
    expect(tester.getSize(find.byType(MateoLogo)), const Size.square(16));
  });

  testWidgets('when logo and icon scopes coexist, it should keep their sizes independent', (tester) async {
    await tester.pumpWidget(
      logoHost(
        const MateoIconScope(
          size: 48,
          child: MateoLogoScope(
            size: 32,
            child: Row(mainAxisSize: .min, children: [MateoLogo(.telegram), MateoIcon(.cross)]),
          ),
        ),
      ),
    );
    expect(tester.getSize(find.byType(MateoLogo)), const Size.square(32));
    expect(tester.getSize(find.byType(MateoIcon)), const Size.square(48));
    await tester.pumpWidget(logoHost(const MateoIconScope(size: 48, child: MateoLogo(.telegram))));
    expect(tester.getSize(find.byType(MateoLogo)), const Size.square(20));
  });

  testWidgets('when no scope supplies a size, it should expose an unresolved scope default', (tester) async {
    await tester.pumpWidget(
      MateoLogoScope(
        child: Builder(
          builder: (context) {
            expect(MateoLogoScope.of(context), (size: null));
            return const SizedBox();
          },
        ),
      ),
    );
  });

  testWidgets('when explicit, inherited, or constrained size is zero, it should render empty', (tester) async {
    for (final child in [
      const MateoLogo(.instagram, size: 0),
      const MateoLogoScope(size: 0, child: MateoLogo(.instagram)),
      const SizedBox.square(dimension: 0, child: MateoLogo(.instagram)),
    ]) {
      await tester.pumpWidget(logoHost(child));
      expect(tester.getSize(find.byType(MateoLogo)), Size.zero);
      expect(find.byType(CustomPaint), findsNothing);
      expect(tester.takeException(), isNull);
    }
  });

  test('when logo or scope sizes are invalid, it should reject them', () {
    for (final size in [-1.0, double.nan, double.infinity, double.negativeInfinity]) {
      expect(() => MateoLogo(.instagram, size: size), throwsAssertionError);
      expect(() => MateoLogoScope(size: size, child: const SizedBox()), throwsAssertionError);
    }
  });

  testWidgets('when labeled, it should expose one localized image label', (tester) async {
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(logoHost(const MateoLogo(.telegram, semanticLabel: 'Telegram')));
      expect(find.bySemanticsLabel('Telegram'), findsOneWidget);
      expect(tester.getSemantics(find.byType(MateoLogo)), matchesSemantics(label: 'Telegram', isImage: true));
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('when decorative, it should leave the accessible label to its parent', (tester) async {
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        logoHost(
          Semantics(container: true, label: 'Open Telegram', child: const MateoLogo(.telegram)),
        ),
      );
      expect(find.bySemanticsLabel('Open Telegram'), findsOneWidget);
      expect(tester.getSemantics(find.byType(MateoLogo)), matchesSemantics(label: 'Open Telegram'));
    } finally {
      semantics.dispose();
    }
  });

  for (final logo in MateoLogoData.values) {
    testWidgets('when inherited colors and direction change, it should preserve ${logo.name} artwork', (tester) async {
      final key = GlobalKey();
      Future<List<int>> capture({required bool conflictingDefaults}) async {
        await tester.pumpWidget(
          logoHost(
            DefaultTextStyle(
              style: TextStyle(color: conflictingDefaults ? const Color(0xFF00FF00) : const Color(0xFFFF0000)),
              child: MateoIconScope(
                color: conflictingDefaults ? const Color(0xFF0000FF) : null,
                size: 80,
                child: RepaintBoundary(key: key, child: MateoLogo(logo, size: 48)),
              ),
            ),
            direction: conflictingDefaults ? .rtl : .ltr,
          ),
        );
        await settleLogoImages(tester);
        return await logoPixels(tester, key);
      }

      final original = await capture(conflictingDefaults: false);
      final inherited = await capture(conflictingDefaults: true);
      expect(original, contains(isNot(0)));
      expect(inherited, orderedEquals(original));
      expect(tester.takeException(), isNull);
    });
  }
}
