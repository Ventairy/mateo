import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

import '../fixtures/surface_transform_targets.dart';
import '../fixtures/surface_transform_test_widgets.dart';

const ValueKey<String> _frameKey = ValueKey('nested-morph-frame');

Future<int> _visibleHeaderBands(WidgetTester tester) async => (await tester.runAsync(() async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(_frameKey));
  final image = await (boundary.debugLayer! as OffsetLayer).toImage(Offset.zero & boundary.size);
  try {
    final bytes = (await image.toByteData(format: .rawRgba))!;
    var bands = 0;
    var previousRowPainted = false;
    for (var y = 0; y < image.height; y++) {
      var rowPainted = false;
      for (var x = 0; x < image.width; x++) {
        final offset = (y * image.width + x) * 4;
        if (bytes.getUint8(offset) < 30 && bytes.getUint8(offset + 1) > 200 && bytes.getUint8(offset + 2) < 30) {
          rowPainted = true;
          break;
        }
      }
      if (rowPainted && !previousRowPainted) bands++;
      previousRowPainted = rowPainted;
    }
    return bands;
  } finally {
    image.dispose();
  }
}))!;

Future<List<int>> _nestedHeaderPixels(WidgetTester tester) async {
  final paints = tester
      .widgetList<CustomPaint>(
        find.byWidgetPredicate(
          (widget) => widget is CustomPaint && widget.painter.runtimeType.toString() == '_MorphContentSnapshotPainter',
        ),
      )
      .toList();
  expect(paints, isNotEmpty);
  return (await tester.runAsync(() async {
    final counts = <int>[];
    for (final paint in paints) {
      final recorder = ui.PictureRecorder();
      paint.painter!.paint(Canvas(recorder), const Size(400, 800));
      final picture = recorder.endRecording();
      final image = await picture.toImage(400, 800);
      final bytes = (await image.toByteData(format: .rawRgba))!;
      var count = 0;
      for (var offset = 0; offset < bytes.lengthInBytes; offset += 4) {
        if (bytes.getUint8(offset) < 30 && bytes.getUint8(offset + 1) > 200 && bytes.getUint8(offset + 2) < 30) {
          count++;
        }
      }
      counts.add(count);
      image.dispose();
      picture.dispose();
    }
    return counts;
  }))!;
}

void main() {
  for (final scrollable in [false, true]) {
    testWidgets(
      'when a view with scrolling $scrollable pushes and pops, its surface snapshots should exclude the independently flying header',
      (tester) async {
        tester.view
          ..devicePixelRatio = 1
          ..physicalSize = const Size(400, 800);
        addTearDown(tester.view.reset);
        final navigator = GlobalKey<NavigatorState>();
        final surface = surfaceTransformTarget(
          'nested-header-$scrollable',
          duration: const Duration(seconds: 1),
          curve: Curves.linear,
        );
        final header = MorphTarget(
          tag: 'header-$scrollable',
          duration: const Duration(seconds: 1),
          curve: Curves.linear,
        );
        Widget content({required bool destination}) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Morph(
              targets: [header],
              flightConfig: .auto(childSwitchAt: destination ? 0.9 : 0.01),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: destination ? 160 : 100,
                    height: 30,
                    child: const ColoredBox(color: Color(0xFF00FF00)),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: destination ? 220 : 140,
                    height: 20,
                    child: const ColoredBox(color: Color(0xFF00FF00)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        );
        await tester.pumpWidget(
          RepaintBoundary(
            key: _frameKey,
            child: MateoApp(
              theme: surfaceTransformTheme,
              navigatorKey: navigator,
              home: surfaceTransformEndpoint(
                bounds: const Rect.fromLTWH(40, 350, 250, 160),
                animation: .transform(target: surface, contentEffects: const [.crossfade()]),
                color: const Color(0xFF000000),
                child: content(destination: false),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await startSurfaceTransformAnimationFlight(
          tester,
          navigator.currentState!,
          surfaceTransformEndpoint(
            bounds: const Rect.fromLTWH(12, 40, 376, 700),
            animation: .transform(target: surface, contentEffects: const [.crossfade()]),
            color: const Color(0xFF000000),
            view: true,
            scrollable: scrollable,
            child: content(destination: true),
          ),
          routeDuration: const Duration(milliseconds: 320),
        );
        await tester.pump(const Duration(milliseconds: 150));
        expect(
          await _nestedHeaderPixels(tester),
          everyElement(0),
          reason: 'push content must exclude the separate header flight',
        );
        expect(await _visibleHeaderBands(tester), 2, reason: 'the separate header remains visible during push');
        await tester.pumpAndSettle();
        expect(await _visibleHeaderBands(tester), 2, reason: 'one header settles in the view');
        navigator.currentState!.pop();
        await tester.pump();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 150));
        expect(
          await _nestedHeaderPixels(tester),
          everyElement(0),
          reason: 'pop content must exclude the separate header flight',
        );
        expect(await _visibleHeaderBands(tester), 2, reason: 'the separate header remains visible during pop');
        await tester.pumpAndSettle();
        expect(await _visibleHeaderBands(tester), 2, reason: 'one header settles in the card');
      },
    );
  }
}
