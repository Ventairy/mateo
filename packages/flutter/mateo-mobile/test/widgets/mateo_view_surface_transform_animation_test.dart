import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/surface_transform_test_widgets.dart';

const ValueKey<String> _capture = ValueKey('capture');
const _black = Color(0xFF000000);
const _colors = [Color(0xFFFF0000), Color(0xFF00FF00), Color(0xFF0000FF), Color(0xFFFFFF00)];

Future<List<int>> _pixel(WidgetTester tester, Offset point) async => (await tester.runAsync(() async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(_capture));
  final image = await (boundary.debugLayer! as OffsetLayer).toImage(Offset.zero & boundary.size);
  final bytes = (await image.toByteData(format: .rawRgba))!;
  final offset = (point.dy.round() * image.width + point.dx.round()) * 4;
  final pixel = List.generate(3, (i) => bytes.getUint8(offset + i));
  image.dispose();
  return pixel;
}))!;

void main() {
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
          const animation = MateoSurfaceAnimation.transform(
            id: 'complete-view',
            duration: Duration(seconds: 1),
            curve: Curves.linear,
          );
          const sourceBounds = Rect.fromLTWH(40, 40, 120, 80);
          const destinationBounds = Rect.fromLTWH(40, 40, 320, 400);
          final content = Center(child: marker(0));
          final view = Stack(
            children: [
              Positioned.fromRect(
                rect: destinationBounds,
                child: MateoView(
                  padding: EdgeInsets.zero,
                  header: MateoViewHeader(principal: marker(1)),
                  footer: MateoViewFooter(principal: marker(2)),
                  overlay: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(padding: const EdgeInsets.only(right: 20), child: marker(3)),
                  ),
                  surface: scrollable
                      ? MateoViewSurface.scrollable(animation: animation, color: _black, child: content)
                      : MateoViewSurface(animation: animation, color: _black, child: content),
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
                home: surfaceTransformEndpoint(bounds: sourceBounds, animation: animation, color: _black),
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
