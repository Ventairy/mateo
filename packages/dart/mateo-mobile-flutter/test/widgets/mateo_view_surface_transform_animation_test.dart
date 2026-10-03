import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/surface_transform_targets.dart';
import '../fixtures/surface_transform_test_widgets.dart';

ValueKey<String> _capture = const ValueKey('capture');
const _black = Color(0xFF000000);
final _colors = [const Color(0xFFFF0000), const Color(0xFF00FF00), const Color(0xFF0000FF), const Color(0xFFFFFF00)];

Future<List<int>> _pixel(WidgetTester tester, Offset point) async => (await tester.runAsync(() async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(_capture));
  final image = await (boundary.debugLayer! as OffsetLayer).toImage(Offset.zero & boundary.size);
  final bytes = (await image.toByteData(format: .rawRgba))!;
  final offset = (point.dy.round() * image.width + point.dx.round()) * 4;
  final pixel = List.generate(3, (i) => bytes.getUint8(offset + i));
  image.dispose();
  return pixel;
}))!;

Future<List<List<int>>> _destinationSnapshotPixels(WidgetTester tester, List<Offset> points) async {
  final snapshot = tester.widget<CustomPaint>(
    find
        .byWidgetPredicate(
          (widget) => widget is CustomPaint && widget.painter.runtimeType.toString() == '_MorphContentSnapshotPainter',
        )
        .last,
  );
  return (await tester.runAsync(() async {
    final recorder = ui.PictureRecorder();
    snapshot.painter!.paint(Canvas(recorder), const Size(400, 800));
    final picture = recorder.endRecording();
    final image = await picture.toImage(400, 800);
    final bytes = (await image.toByteData(format: .rawRgba))!;
    final pixels = [
      for (final point in points)
        List.generate(
          4,
          (channel) => bytes.getUint8((point.dy.round() * image.width + point.dx.round()) * 4 + channel),
        ),
    ];
    image.dispose();
    picture.dispose();
    return pixels;
  }))!;
}

void main() {
  for (final prepareOffstage in [false, true]) {
    for (final topInset in [0.0, 24.0, 47.0]) {
      testWidgets(
        'when a view transforms below a $topInset safe area with the keyboard open and its route ${prepareOffstage ? "prepared offstage" : "painted immediately"}, it should capture the settled body position from the first flight frame',
        (tester) async {
          tester.view
            ..devicePixelRatio = 1
            ..physicalSize = const Size(400, 800)
            ..padding = FakeViewPadding(top: topInset)
            ..viewPadding = FakeViewPadding(top: topInset, bottom: 34)
            ..viewInsets = const FakeViewPadding(bottom: 300);
          addTearDown(tester.view.reset);
          final navigator = GlobalKey<NavigatorState>();
          final bodyKey = GlobalKey();
          final centerKey = GlobalKey();
          final headerKey = GlobalKey();
          final animation = MateoSurfaceAnimation.transform(
            target: surfaceTransformTarget(
              'safe-area-view',
              duration: const Duration(seconds: 1),
              curve: Curves.linear,
            ),
            contentEffects: const [.crossfade()],
          );
          final bodyColor = surfaceTransformTheme.palette.red;
          await tester.pumpWidget(
            RepaintBoundary(
              key: _capture,
              child: MateoApp(
                theme: surfaceTransformTheme,
                navigatorKey: navigator,
                home: surfaceTransformEndpoint(
                  bounds: const Rect.fromLTWH(40, 200, 120, 80),
                  animation: animation,
                  color: _black,
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          await startSurfaceTransformAnimationFlight(
            tester,
            navigator.currentState!,
            routeDuration: const Duration(milliseconds: 320),
            prepareOffstage: prepareOffstage,
            MateoView(
              animation: viewAnimationFor(animation),
              header: MateoViewHeader(principal: SizedBox(key: headerKey, height: 40)),
              surface: MateoViewSurface(
                color: _black,
                child: Column(
                  children: [
                    SizedBox(
                      key: bodyKey,
                      height: 12,
                      width: 24,
                      child: ColoredBox(color: bodyColor),
                    ),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          key: centerKey,
                          width: 12,
                          height: 12,
                          child: ColoredBox(color: bodyColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          await tester.pump(const Duration(milliseconds: 16));
          final centers = [tester.getCenter(find.byKey(bodyKey)), tester.getCenter(find.byKey(centerKey))];
          expect(tester.getTopLeft(find.byKey(bodyKey)).dy, tester.getBottomLeft(find.byKey(headerKey)).dy + 20);
          final expectedPixel = [
            (bodyColor.r * 255).round(),
            (bodyColor.g * 255).round(),
            (bodyColor.b * 255).round(),
            255,
          ];
          // Inspect the actual destination raster before scaling/crossfading.
          // Hidden live widgets alone cannot prove that the flight is aligned.
          expect(await _destinationSnapshotPixels(tester, centers), [expectedPixel, expectedPixel]);
          await tester.pump(const Duration(milliseconds: 964));
          expect(await _destinationSnapshotPixels(tester, centers), [expectedPixel, expectedPixel]);
          await tester.pumpAndSettle();
          expect([tester.getCenter(find.byKey(bodyKey)), tester.getCenter(find.byKey(centerKey))], centers);
        },
      );
    }
  }
  for (final scrollable in [false, true]) {
    for (final interrupted in [false, true]) {
      testWidgets(
        'when a complete view transforms with scrolling $scrollable and interruption $interrupted, it should carry every slot and preserve state on return',
        (tester) async {
          final navigator = GlobalKey<NavigatorState>();
          final keys = List.generate(4, (_) => GlobalKey());
          Widget marker(int index) => StatefulBuilder(
            key: keys[index],
            builder: (context, setState) => SizedBox(width: 24, height: 24, child: ColoredBox(color: _colors[index])),
          );
          final target = surfaceTransformTarget(
            'complete-view',
            duration: const Duration(seconds: 1),
            curve: Curves.linear,
          );
          final surfaceAnimation = MateoSurfaceAnimation.transform(target: target);
          final viewAnimation = MateoViewAnimation.transform(target: target);
          const sourceBounds = Rect.fromLTWH(40, 40, 120, 80);
          const destinationBounds = Rect.fromLTWH(40, 40, 320, 400);
          final content = Center(child: marker(0));
          final view = Stack(
            children: [
              Positioned.fromRect(
                rect: destinationBounds,
                child: MateoView(
                  animation: viewAnimation,
                  padding: EdgeInsets.zero,
                  header: MateoViewHeader(principal: marker(1)),
                  footer: MateoViewFooter(principal: marker(2)),
                  overlay: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(padding: const EdgeInsets.only(right: 20), child: marker(3)),
                  ),
                  surface: scrollable
                      ? MateoViewSurface.scrollable(color: _black, child: content)
                      : MateoViewSurface(color: _black, child: content),
                ),
              ),
            ],
          );
          await tester.pumpWidget(
            RepaintBoundary(
              key: _capture,
              child: MateoApp(
                theme: surfaceTransformTheme,
                navigatorKey: navigator,
                home: surfaceTransformEndpoint(bounds: sourceBounds, animation: surfaceAnimation, color: _black),
              ),
            ),
          );
          await tester.pumpAndSettle();
          await startSurfaceTransformAnimationFlight(tester, navigator.currentState!, view);
          final states = keys.map((key) => key.currentState).toList();
          final centers = keys.map((key) => tester.getCenter(find.byKey(key))).toList();
          await tester.pump(const Duration(milliseconds: 500));
          final flightBounds = tester.getRect(surfaceFlight);
          // The destination scales from 0.2 to 1: halfway, all four markers must
          // paint at 0.6 of their endpoint offsets with the same half opacity.
          for (var i = 0; i < keys.length; i++) {
            final point = flightBounds.center + (centers[i] - destinationBounds.center) * .6;
            final pixel = await _pixel(tester, point);
            final color = _colors[i];
            final expected = [color.r, color.g, color.b].map((channel) => channel * 127.5).toList();
            for (var channel = 0; channel < 3; channel++) {
              expect(pixel[channel], closeTo(expected[channel], 3), reason: 'slot $i channel $channel at $point');
            }
            expect(keys[i].currentState, same(states[i]));
          }
          if (interrupted) {
            final before = await _pixel(tester, flightBounds.center + (centers[1] - destinationBounds.center) * .6);
            navigator.currentState!.pop();
            await tester.pump();
            await tester.pump();
            expect(tester.getRect(surfaceFlight), rectMoreOrLessEquals(flightBounds));
            expect(await _pixel(tester, flightBounds.center + (centers[1] - destinationBounds.center) * .6), before);
            await tester.pumpAndSettle();
            expect(surfaceFlight, findsNothing);
            expect(tester.takeException(), isNull);
            return;
          }
          await tester.pumpAndSettle();
          expect(surfaceFlight, findsNothing);
          for (var i = 0; i < keys.length; i++) {
            expect(tester.getCenter(find.byKey(keys[i])), centers[i]);
            expect(keys[i].currentState, same(states[i]));
          }
          navigator.currentState!.pop();
          await tester.pump();
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 500));
          expect(surfaceFlight, findsOneWidget);
          await tester.pumpAndSettle();
          expect(surfaceFlight, findsNothing);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
