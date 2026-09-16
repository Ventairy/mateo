import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_edge_fade/base_mateo_edge_fade.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/default_mateo_surface_edge_fade/default_mateo_surface_edge_fade.dart';

const _white = Color(0xFFFFFFFF);
const _black = Color(0xFF000000);
const _blue = Color(0xFF0000FF);

Widget _host(Widget child, {Key? captureKey, double height = 200}) => Directionality(
  textDirection: .ltr,
  child: Center(
    child: RepaintBoundary(
      key: captureKey,
      child: SizedBox(width: 100, height: height, child: child),
    ),
  ),
);

Future<List<int>> _pixel(WidgetTester tester, Key key, int x, int y) async => (await tester.runAsync(() async {
  final image = await tester.renderObject<RenderRepaintBoundary>(find.byKey(key)).toImage();
  final bytes = (await image.toByteData(format: .rawRgba))!;
  final offset = (y * image.width + x) * 4;
  final pixel = List<int>.generate(4, (index) => bytes.getUint8(offset + index));
  image.dispose();
  return pixel;
}))!;

// Independent Bernstein representation of the quintic, for the error oracle.
double _visibility(double u) =>
    10 * math.pow(u, 3) * math.pow(1 - u, 2) + 5 * math.pow(u, 4) * (1 - u) + math.pow(u, 5);

void main() {
  testWidgets('when no sides are selected, it should return the child without an engine', (tester) async {
    const child = SizedBox(width: 40, height: 20);
    await tester.pumpWidget(_host(DefaultMateoSurfaceEdgeFade(surfaceColor: _white, sides: const {}, child: child)));
    expect(find.byType(BaseMateoEdgeFade), findsNothing);
    expect(find.byWidget(child), findsOneWidget);
  });

  testWidgets('when selected sides change outside the widget, it should preserve its immutable snapshot', (
    tester,
  ) async {
    final sides = <MateoEdgeEffectSide>{.bottom};
    final widget = DefaultMateoSurfaceEdgeFade(surfaceColor: _white, sides: sides, child: const SizedBox());
    sides
      ..clear()
      ..add(.top);
    expect(() => widget.sides.add(.top), throwsUnsupportedError);
    await tester.pumpWidget(_host(widget));
    final bands = tester.widget<BaseMateoEdgeFade>(find.byType(BaseMateoEdgeFade)).resolveBands(const Size(100, 200));
    expect(bands.map((band) => band.edge), [AxisDirection.down]);
  });

  testWidgets('when resolving a local size, it should allocate fifteen percent per selected edge without clamps', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(DefaultMateoSurfaceEdgeFade(surfaceColor: _white, sides: const {.bottom, .top}, child: const SizedBox())),
    );
    final engine = tester.widget<BaseMateoEdgeFade>(find.byType(BaseMateoEdgeFade));
    for (final height in [1e-8, .5, 1.0, 8.0, 32.0, 80.0, 120.25, 400.0, 800.0, 1600.0]) {
      final bands = engine.resolveBands(Size(100, height));
      expect(bands.map((band) => band.edge), [AxisDirection.up, AxisDirection.down]);
      for (final band in bands) {
        expect(band.extent, height * .15);
      }
    }
    expect(engine.resolveBands(.zero), isEmpty);
    expect(engine.resolveBands(const Size(0, 100)), isEmpty);
    expect(engine.resolveBands(const Size(100, 0)), isEmpty);
  });

  testWidgets(
    'when sampling the default profile, it should preserve symmetry monotonicity and the interpolation bound',
    (tester) async {
      await tester.pumpWidget(
        _host(DefaultMateoSurfaceEdgeFade(surfaceColor: _white, sides: const {.top}, child: const SizedBox())),
      );
      final profile = tester
          .widget<BaseMateoEdgeFade>(find.byType(BaseMateoEdgeFade))
          .resolveBands(const Size(100, 200))
          .single
          .profile;
      expect(profile.stops.length, 33);
      expect(profile.visibility.first, 0);
      expect(profile.visibility.last, 1);
      expect(profile.visibility[8], 53 / 512);
      expect(profile.visibility[16], .5);
      expect(profile.visibility[24], 459 / 512);
      for (var i = 0; i < profile.stops.length; i++) {
        expect(profile.stops[i], i / 32);
        expect(profile.visibility[i], closeTo(_visibility(profile.stops[i]), 1e-14));
        expect(profile.visibility[i] + profile.visibility[32 - i], closeTo(1, 1e-14));
        if (i > 0) expect(profile.visibility[i], greaterThan(profile.visibility[i - 1]));
      }
      final bound = (10 * math.sqrt(3) / 3) / (8 * 32 * 32);
      for (var i = 0; i < 10000; i++) {
        final u = i / 10000;
        final segment = (u * 32).floor();
        final fraction = u * 32 - segment;
        final interpolated = profile.visibility[segment] * (1 - fraction) + profile.visibility[segment + 1] * fraction;
        expect((interpolated - _visibility(u)).abs(), lessThanOrEqualTo(bound));
      }
    },
  );

  testWidgets('when instances and sizes differ, it should reuse one profile', (tester) async {
    await tester.pumpWidget(
      _host(DefaultMateoSurfaceEdgeFade(surfaceColor: _white, sides: const {.top}, child: const SizedBox())),
    );
    final first = tester
        .widget<BaseMateoEdgeFade>(find.byType(BaseMateoEdgeFade))
        .resolveBands(const Size(100, 200))
        .single
        .profile;
    await tester.pumpWidget(
      _host(DefaultMateoSurfaceEdgeFade(surfaceColor: _blue, sides: const {.top, .bottom}, child: const SizedBox())),
    );
    final bands = tester.widget<BaseMateoEdgeFade>(find.byType(BaseMateoEdgeFade)).resolveBands(const Size(500, 900));
    for (final band in bands) {
      expect(identical(first, band.profile), isTrue);
    }
  });

  for (final mask in [false, true]) {
    testWidgets(
      'when a ${mask ? 'transparent' : 'opaque'} surface resizes, it should update its fade and preserve the clear center',
      (tester) async {
        const key = ValueKey('capture');
        final fade = DefaultMateoSurfaceEdgeFade(
          surfaceColor: mask ? const Color(0x80FFFFFF) : _white,
          sides: const {.top, .bottom},
          child: const RepaintBoundary(child: ColoredBox(color: _black)),
        );
        for (final height in [200.0, 400.0]) {
          await tester.pumpWidget(
            _host(
              ColoredBox(color: _white, child: fade),
              captureKey: key,
              height: height,
            ),
          );
          final engine = tester.widget<BaseMateoEdgeFade>(find.byType(BaseMateoEdgeFade));
          expect(engine.color, mask ? isNull : _white);
          final sampleY = (height * .075).floor();
          final expected = (255 * (1 - _visibility((sampleY + .5) / (height * .15)))).round();
          expect((await _pixel(tester, key, 50, sampleY))[0], closeTo(expected, 2));
          expect((await _pixel(tester, key, 50, height.toInt() - 1 - sampleY))[0], closeTo(expected, 2));
          for (final fraction in [.15, .5, .849]) {
            expect(await _pixel(tester, key, 50, (height * fraction).floor()), [0, 0, 0, 255]);
          }
        }
      },
    );
  }

  testWidgets('when masking over a different background, it should reveal that background without tinting it', (
    tester,
  ) async {
    const key = ValueKey('capture');
    await tester.pumpWidget(
      _host(
        ColoredBox(
          color: _blue,
          child: DefaultMateoSurfaceEdgeFade(
            surfaceColor: const Color(0x00000000),
            sides: const {.top},
            child: const RepaintBoundary(child: ColoredBox(color: _white)),
          ),
        ),
        captureKey: key,
      ),
    );
    final pixel = await _pixel(tester, key, 50, 14);
    final expected = (255 * _visibility(14.5 / 30)).round();
    expect(pixel[0], closeTo(expected, 2));
    expect(pixel[1], closeTo(expected, 2));
    expect(pixel[2], 255);
    expect(pixel[3], 255);
    expect(await _pixel(tester, key, 50, 190), [255, 255, 255, 255]);
  });

  testWidgets('when the child is interactive, it should preserve layout hit testing and semantics', (tester) async {
    final semantics = tester.ensureSemantics();
    var taps = 0;
    const key = ValueKey('child');
    for (final color in [_white, const Color(0x00FFFFFF)]) {
      await tester.pumpWidget(
        Directionality(
          textDirection: .ltr,
          child: Center(
            child: IntrinsicWidth(
              child: IntrinsicHeight(
                child: DefaultMateoSurfaceEdgeFade(
                  surfaceColor: color,
                  sides: const {.top, .bottom},
                  child: Semantics(
                    label: 'Action',
                    button: true,
                    child: GestureDetector(
                      behavior: .opaque,
                      onTap: () => taps++,
                      child: const SizedBox(key: key, width: 70, height: 40),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byKey(key)), const Size(70, 40));
      expect(find.bySemanticsLabel('Action'), findsOneWidget);
      await tester.tap(find.byType(GestureDetector));
    }
    expect(taps, 2);
    semantics.dispose();
  });
}
