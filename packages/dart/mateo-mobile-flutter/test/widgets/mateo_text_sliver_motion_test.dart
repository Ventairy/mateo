import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

const ValueKey<String> _viewportKey = ValueKey('viewport');
const ValueKey<String> _labelKey = ValueKey('label');
const _labelRow = 3;
const _rowHeight = 30.0;

void main() {
  for (final fixedExtent in [true, false]) {
    testWidgets(
      'reveals an already moving label in a ${fixedExtent ? 'fixed' : 'variable'} extent list',
      (tester) async {
        tester.view.devicePixelRatio = 2.625;
        tester.view.physicalSize = const Size(1050, 1890);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);
        final samples = <List<Uint8List>>[];
        final widths = <List<double>>[];

        for (final initiallyVisible in [true, false]) {
          final controller = ScrollController(initialScrollOffset: initiallyVisible ? _labelRow * _rowHeight : 0);
          var text = 'Fila 101,42';
          Widget scene() => Directionality(
            textDirection: .ltr,
            child: Center(
              child: RepaintBoundary(
                key: _viewportKey,
                child: ColoredBox(
                  color: const Color(0xFFFFFFFF),
                  child: SizedBox(
                    width: 230,
                    height: _rowHeight,
                    child: ListView.builder(
                      controller: controller,
                      scrollCacheExtent: const ScrollCacheExtent.pixels(150),
                      itemCount: 12,
                      itemExtent: fixedExtent ? _rowHeight : null,
                      itemBuilder: (context, index) => SizedBox(
                        height: fixedExtent || index < _labelRow ? _rowHeight : _rowHeight + 4,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: index == _labelRow
                              ? MateoText(
                                  text,
                                  key: _labelKey,
                                  presentation: const .interface(fontSize: .custom(14), fontWeight: .w500),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );

          await tester.pumpWidget(scene());
          expect(find.byKey(_labelKey, skipOffstage: false), findsOneWidget);
          text = 'Fila 911,445';
          await tester.pumpWidget(scene());
          await tester.pump(const Duration(milliseconds: 61));
          text = 'Fila 521,48 hoje';
          await tester.pumpWidget(scene());
          if (!initiallyVisible) controller.jumpTo(_labelRow * _rowHeight);
          await tester.pump(const Duration(milliseconds: 57));

          final widthsForScene = [tester.getSize(find.byKey(_labelKey)).width];
          final samplesForScene = [await _viewportPixels(tester)];
          await tester.pump(const Duration(milliseconds: 73));
          widthsForScene.add(tester.getSize(find.byKey(_labelKey)).width);
          samplesForScene.add(await _viewportPixels(tester));
          await tester.pumpAndSettle();
          widthsForScene.add(tester.getSize(find.byKey(_labelKey)).width);
          samplesForScene.add(await _viewportPixels(tester));
          expect(find.text(text), findsOneWidget);

          widths.add(widthsForScene);
          samples.add(samplesForScene);
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pumpAndSettle();
          controller.dispose();
        }

        expect(widths.first.first, lessThan(widths.first.last));
        expect(widths.last, widths.first);
        expect(samples.last, samples.first);
      },
      semanticsEnabled: false,
    );
  }
}

Future<Uint8List> _viewportPixels(WidgetTester tester) async {
  final viewport = tester.renderObject<RenderRepaintBoundary>(find.byKey(_viewportKey));
  return (await tester.runAsync(() async {
    final image = await viewport.toImage(pixelRatio: tester.view.devicePixelRatio);
    try {
      return (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!.buffer.asUint8List();
    } finally {
      image.dispose();
    }
  }))!;
}
