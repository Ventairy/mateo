import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

const _capture = ValueKey<String>('text');

Future<double> _colonInkCenter(WidgetTester tester, Rect region) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(_capture));
  final center = await tester.runAsync(() async {
    const ratio = 3.0;
    final image = await boundary.toImage(pixelRatio: ratio);
    try {
      final bytes = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
      var alphaSum = 0;
      var weightedY = 0;
      for (var y = (region.top * ratio).floor(); y < (region.bottom * ratio).ceil(); y++) {
        for (var x = (region.left * ratio).floor(); x < (region.right * ratio).ceil(); x++) {
          final alpha = bytes.getUint8((y * image.width + x) * 4 + 3);
          alphaSum += alpha;
          weightedY += y * alpha;
        }
      }
      expect(alphaSum, greaterThan(0));
      return weightedY / alphaSum / ratio;
    } finally {
      image.dispose();
    }
  });
  return center!;
}

void main() {
  testWidgets('a colon between numbers keeps its shaped position during a numeral roll', (tester) async {
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetDevicePixelRatio);

    Widget label(int value) => Directionality(
      textDirection: .ltr,
      child: Align(
        alignment: .topLeft,
        child: RepaintBoundary(
          key: _capture,
          child: MateoText('HTTP 3 : $value', presentation: const .interface()),
        ),
      ),
    );

    await tester.pumpWidget(label(100));
    final paragraph = tester.renderObject<RenderParagraph>(find.byType(RichText));
    final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(_capture));
    final colon = paragraph
        .getBoxesForSelection(const TextSelection(baseOffset: 7, extentOffset: 8))
        .single
        .toRect()
        .shift(paragraph.localToGlobal(Offset.zero, ancestor: boundary));
    final before = await _colonInkCenter(tester, colon);

    for (final value in [211, 120, 201, 101, 210, 112, 220, 201, 102, 121, 210, 221]) {
      await tester.pumpWidget(label(value));
      await tester.pump(const Duration(milliseconds: 88));
    }
    expect(tester.widget<Text>(find.byType(Text)).data, isNot('HTTP 3 : 221'));

    expect(await _colonInkCenter(tester, colon), closeTo(before, 0.3));
    await tester.pumpAndSettle();
    expect(tester.widget<Text>(find.byType(Text)).data, 'HTTP 3 : 221');
  }, semanticsEnabled: false);

  testWidgets('an overlapped second line keeps its own opacity in vector fallback', (tester) async {
    // The destination exceeds the atlas width at this density, so the
    // transition paints the original shaped paragraph through vector clips.
    tester.view.devicePixelRatio = 16;
    tester.view.physicalSize = const Size(4096, 640);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    const before = 'fox                                  dog\n           WWWW';
    const after = 'fox                                  dog\n           AAAA';

    Widget label(String text) => Directionality(
      textDirection: .ltr,
      child: Align(
        alignment: .topLeft,
        child: RepaintBoundary(
          key: _capture,
          child: MateoText(
            text,
            presentation: const .interface(height: 0.25, color: Color(0xFF000000)),
          ),
        ),
      ),
    );

    Future<int> secondLineInk() async {
      final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(_capture));
      final paragraph = tester.renderObject<RenderParagraph>(find.byType(RichText));
      final glyphs = paragraph.getBoxesForSelection(
        const TextSelection(baseOffset: after.length - 4, extentOffset: after.length),
      );
      final left = glyphs.first.left;
      final right = glyphs.last.right;
      return (await tester.runAsync(() async {
        const ratio = 3.0;
        final image = await boundary.toImage(pixelRatio: ratio);
        try {
          final bytes = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
          var ink = 0;
          for (var y = 0; y < image.height; y++) {
            for (var x = (left * ratio).floor(); x < (right * ratio).ceil(); x++) {
              ink += bytes.getUint8((y * image.width + x) * 4 + 3);
            }
          }
          return ink;
        } finally {
          image.dispose();
        }
      }))!;
    }

    await tester.pumpWidget(label(before));
    await tester.pumpWidget(label(after));
    await tester.pump(const Duration(milliseconds: 120));
    final enteringInk = await secondLineInk();

    await tester.pumpAndSettle();
    final settledInk = await secondLineInk();

    expect(enteringInk, greaterThan(0));
    expect(enteringInk, lessThan(settledInk * 0.8));
  }, semanticsEnabled: false);
}
