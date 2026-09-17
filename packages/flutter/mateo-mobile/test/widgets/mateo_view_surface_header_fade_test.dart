import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_edge_fade/base_mateo_edge_fade.dart';
import 'package:mateo_mobile/src/bases/base_mateo_edge_fade/mateo_edge_fade_profile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/base_mateo_surface.dart';

final _theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
const ValueKey<String> _capture = ValueKey('capture');

Widget _host(Widget child) => MateoTheme(
  data: _theme,
  child: Directionality(
    textDirection: .ltr,
    child: Center(
      child: RepaintBoundary(
        key: _capture,
        child: SizedBox(width: 240, height: 400, child: child),
      ),
    ),
  ),
);

Future<List<int>> _pixel(WidgetTester tester, int x, int y) async => (await tester.runAsync(() async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(_capture));
  // Capture the frame already painted, even if a post-frame geometry signal
  // has requested another paint. Do not pump away first-frame regressions.
  final image = await (boundary.debugLayer! as OffsetLayer).toImage(Offset.zero & boundary.size);
  final bytes = (await image.toByteData(format: .rawRgba))!;
  final result = List<int>.generate(4, (i) => bytes.getUint8((y * image.width + x) * 4 + i));
  image.dispose();
  return result;
}))!;

double _q(double t) => 10 * math.pow(t, 3) * math.pow(1 - t, 2) + 5 * math.pow(t, 4) * (1 - t) + math.pow(t, 5);
double _sample(MateoEdgeFadeProfile p, double t) {
  for (var i = 1; i < p.stops.length; i++) {
    if (t <= p.stops[i]) {
      final u = (t - p.stops[i - 1]) / (p.stops[i] - p.stops[i - 1]);
      return p.visibility[i - 1] * (1 - u) + p.visibility[i] * u;
    }
  }
  return p.visibility.last;
}

void main() {
  testWidgets('when top padding is custom or zero, it should size the fade and grow smoothly while scrolling', (
    tester,
  ) async {
    for (final topPadding in [0.0, 8.0, 32.0]) {
      await tester.pumpWidget(
        _host(
          MateoView(
            padding: EdgeInsets.zero,
            header: const MateoViewHeader(padding: EdgeInsets.zero, principal: SizedBox(height: 80)),
            surface: MateoViewSurface.scrollable(
              padding: EdgeInsets.only(top: topPadding),
              edgeEffect: .fade(at: const [.top]),
              child: const SizedBox(height: 800),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      double extent() => tester
          .widget<BaseMateoEdgeFade>(find.byType(BaseMateoEdgeFade))
          .resolveBands(const Size(240, 400))
          .single
          .extent;
      final resting = extent();
      expect(resting, 80 + topPadding);
      final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!;
      final distance = topPadding == 0 ? 20.0 : topPadding;
      controller.jumpTo(distance / 2);
      await tester.pump();
      final intermediate = extent();
      expect(intermediate.isFinite, isTrue);
      expect(intermediate, greaterThan(resting));
      controller.jumpTo(distance);
      await tester.pump();
      expect(extent(), greaterThan(intermediate));
      expect(extent(), closeTo(80 / .55, .001));
      controller.jumpTo(0);
      await tester.pump();
      expect(extent(), resting);
      await tester.pumpWidget(const SizedBox());
    }
  });

  testWidgets('when sampling header profiles, it should preserve anchors monotonicity and interpolation accuracy', (
    tester,
  ) async {
    for (final h in [0.0, 1.0, 40.0, 180.0, 500.0]) {
      final d = h + 20;
      await tester.pumpWidget(
        _host(
          MateoView(
            padding: EdgeInsets.zero,
            header: MateoViewHeader(
              padding: EdgeInsets.zero,
              principal: SizedBox(height: h),
            ),
            surface: MateoViewSurface(
              color: const Color(0xFFFFFFFF),
              edgeEffect: .fade(at: const [.top]),
              child: const SizedBox(),
            ),
          ),
        ),
      );
      final engine = tester.widget<BaseMateoEdgeFade>(find.byType(BaseMateoEdgeFade));
      final band = engine.resolveBands(const Size(240, 400)).single;
      final p = band.profile;
      expect(band.extent, d);
      expect(p.stops.length, 33);
      expect(p.visibility.first, 0);
      expect(p.visibility.last, 1);
      expect(p.stops[16], .5);
      expect(p.visibility[16], .078125);
      for (var i = 1; i < 33; i++) {
        expect(p.stops[i], greaterThan(p.stops[i - 1]));
        expect(p.visibility[i], greaterThanOrEqualTo(p.visibility[i - 1]));
      }
      for (var i = 0; i <= 5000; i++) {
        final y = d * i / 5000;
        final q = _q(y / d);
        final expected = .25 * math.pow(q, 3) + .75 * math.pow(q, 4);
        expect((_sample(p, y / d) - expected).abs(), lessThan(.002));
      }
      expect(identical(p, engine.resolveBands(const Size(240, 500)).single.profile), isTrue);
    }
  });

  testWidgets('when a header lays out independently, it should update the fade in the next painted frame', (
    tester,
  ) async {
    final height = ValueNotifier<double>(40);
    addTearDown(height.dispose);
    await tester.pumpWidget(
      _host(
        MateoView(
          padding: EdgeInsets.zero,
          header: MateoViewHeader(
            principal: ValueListenableBuilder<double>(
              valueListenable: height,
              builder: (context, value, child) => SizedBox(height: value),
            ),
          ),
          surface: MateoViewSurface.scrollable(
            color: const Color(0xFFFFFFFF),
            edgeEffect: .fade(at: const [.top]),
            child: const SizedBox(height: 1000, child: ColoredBox(color: Color(0xFF000000))),
          ),
        ),
      ),
    );
    final finder = find.byType(BaseMateoEdgeFade);
    final engine = tester.widget<BaseMateoEdgeFade>(finder);
    expect(engine.resolveBands(tester.getSize(finder)).single.extent, 60);
    tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!.jumpTo(200);
    await tester.pump();
    expect((await _pixel(tester, 120, 50))[0], closeTo(128, 3));
    height.value = 80;
    await tester.pump();
    expect(identical(engine, tester.widget<BaseMateoEdgeFade>(finder)), isTrue);
    expect(engine.resolveBands(tester.getSize(finder)).single.extent, closeTo(80 / .55, 1e-10));
    expect((await _pixel(tester, 120, 50))[0], closeTo(253, 3));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'when headers appear disappear or change safe areas, it should resolve current contextual and default depths',
    (tester) async {
      for (final (present, safeTop, scale) in [
        (true, 0.0, 1.0),
        (true, 24.0, 1.0),
        (true, 24.0, 2.0),
        (false, 24.0, 2.0),
        (true, 0.0, 1.0),
      ]) {
        await tester.pumpWidget(
          _host(
            MediaQuery(
              data: MediaQueryData(
                padding: .only(top: safeTop),
                textScaler: .linear(scale),
              ),
              child: MateoView(
                padding: const .only(top: 8),
                header: present ? const MateoViewHeader(principal: Text('Title\nSubtitle')) : null,
                surface: MateoViewSurface(edgeEffect: .fade(), child: const SizedBox()),
              ),
            ),
          ),
        );
        final finder = find.byType(BaseMateoEdgeFade);
        final bands = tester.widget<BaseMateoEdgeFade>(finder).resolveBands(tester.getSize(finder));
        final inset = tester.widget<BaseMateoSurface>(find.byType(BaseMateoSurface)).obstruction!.layoutInsets.top;
        expect(bands.first.extent, present ? inset + 20 : 60);
        expect(bands.last.extent, 60);
        if (present) {
          expect(inset, greaterThan(safeTop));
          expect(bands.first.profile.visibility.first, 0);
        }
        await tester.pump();
        expect(tester.takeException(), isNull);
      }
    },
  );

  testWidgets('when scrolling through the header gap, it should extend and retract without rebuilding content', (
    tester,
  ) async {
    var builds = 0;
    var layouts = 0;
    await tester.pumpWidget(
      _host(
        MateoView(
          padding: EdgeInsets.zero,
          header: const MateoViewHeader(principal: SizedBox(height: 80)),
          surface: MateoViewSurface.scrollable(
            color: const Color(0xFFFFFFFF),
            edgeEffect: .fade(at: const [.top]),
            child: Builder(
              builder: (_) {
                builds++;
                return _LayoutCounter(
                  onLayout: () => layouts++,
                  child: const SizedBox(height: 1000, child: ColoredBox(color: Color(0xFF000000))),
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!;
    final engine = tester.widget<BaseMateoEdgeFade>(find.byType(BaseMateoEdgeFade));
    final initialBuilds = builds;
    final initialLayouts = layouts;
    for (final (offset, depth) in [
      (0.0, 100.0),
      (5.0, 119.8863636364),
      (10.0, 134.0909090909),
      (15.0, 142.6136363636),
      (20.0, 145.4545454545),
      (80.0, 145.4545454545),
      (10.0, 134.0909090909),
      (0.0, 100.0),
      (-10.0, 100.0),
    ]) {
      controller.jumpTo(offset);
      await tester.pump();
      final band = engine.resolveBands(const Size(240, 400)).single;
      expect(band.extent, closeTo(depth, 1e-8));
      final expected = (255 * (1 - _sample(band.profile, (110.5 / depth).clamp(0, 1)))).round();
      expect((await _pixel(tester, 120, 110))[0], closeTo(expected, 3));
      expect(builds, initialBuilds);
      expect(layouts, initialLayouts);
      expect(tester.widget<BaseMateoEdgeFade>(find.byType(BaseMateoEdgeFade)), same(engine));
    }
    await tester.pumpWidget(const SizedBox());
    expect(tester.takeException(), isNull);
  });

  testWidgets('when content becomes short, it should paint the compact fade in the correction frame', (tester) async {
    final height = ValueNotifier<double>(1000);
    addTearDown(height.dispose);
    await tester.pumpWidget(
      _host(
        MateoView(
          padding: EdgeInsets.zero,
          header: const MateoViewHeader(principal: SizedBox(height: 80)),
          surface: MateoViewSurface.scrollable(
            color: const Color(0xFFFFFFFF),
            edgeEffect: .fade(at: const [.top]),
            child: ValueListenableBuilder<double>(
              valueListenable: height,
              builder: (_, value, _) => SizedBox(
                height: value,
                child: const ColoredBox(color: Color(0xFF000000)),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!;
    final engine = tester.widget<BaseMateoEdgeFade>(find.byType(BaseMateoEdgeFade));
    controller.jumpTo(20);
    await tester.pump();
    expect((await _pixel(tester, 120, 110))[0], greaterThan(10));
    height.value = 100;
    await tester.pump();
    expect(controller.position.maxScrollExtent, 0);
    expect(engine.resolveBands(const Size(240, 400)).single.extent, 100);
    expect((await _pixel(tester, 120, 110))[0], 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('when a nested list scrolls in an ordinary surface, it should keep the header compact', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _host(
        MateoView(
          padding: EdgeInsets.zero,
          header: const MateoViewHeader(principal: SizedBox(height: 80)),
          surface: MateoViewSurface(
            edgeEffect: .fade(at: const [.top]),
            child: ListView(controller: controller, children: const [SizedBox(height: 1000)]),
          ),
        ),
      ),
    );
    controller.jumpTo(100);
    await tester.pump();
    final engine = tester.widget<BaseMateoEdgeFade>(find.byType(BaseMateoEdgeFade));
    expect(engine.resolveBands(const Size(240, 400)).single.extent, 100);
  });

  testWidgets('when restoring a scroll position, it should paint its extension immediately', (tester) async {
    final bucket = PageStorageBucket();
    Widget host({required bool present}) => _host(
      PageStorage(
        bucket: bucket,
        child: present
            ? MateoView(
                padding: EdgeInsets.zero,
                header: const MateoViewHeader(principal: SizedBox(height: 80)),
                surface: MateoViewSurface.scrollable(
                  key: const PageStorageKey('scrolling-surface'),
                  color: const Color(0xFFFFFFFF),
                  edgeEffect: .fade(at: const [.top]),
                  child: const SizedBox(height: 1000, child: ColoredBox(color: Color(0xFF000000))),
                ),
              )
            : const SizedBox(),
      ),
    );
    await tester.pumpWidget(host(present: true));
    await tester.pumpAndSettle();
    tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!.jumpTo(10);
    await tester.pump();
    final expectedPixel = await _pixel(tester, 120, 110);
    await tester.pumpWidget(host(present: false));
    await tester.pumpWidget(host(present: true));
    final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!;
    expect(controller.offset, 10);
    final engine = tester.widget<BaseMateoEdgeFade>(find.byType(BaseMateoEdgeFade));
    expect(engine.resolveBands(const Size(240, 400)).single.extent, closeTo(134.0909090909, 1e-8));
    expect(await _pixel(tester, 120, 110), expectedPixel);
    expect(tester.takeException(), isNull);
  });

  test('when fully extended beneath title colors, it should retain ordinary text contrast', () {
    final foreground = _theme.colorScheme.text.primary;
    for (final underlying in [
      const Color(0xFF000000),
      const Color(0xFFFFFFFF),
      const Color(0xFFFF0000),
      const Color(0xFF0000FF),
    ]) {
      final background = Color.alphaBlend(
        _theme.colorScheme.background.withValues(
          alpha: 1 - (.25 * math.pow(_q(.55), 3) + .75 * math.pow(_q(.55), 4)),
        ),
        underlying,
      );
      final a = foreground.computeLuminance();
      final b = background.computeLuminance();
      expect((math.max(a, b) + .05) / (math.min(a, b) + .05), greaterThanOrEqualTo(4.5));
    }
  });
}

class _LayoutCounter extends SingleChildRenderObjectWidget {
  const _LayoutCounter({required this.onLayout, required super.child});
  final VoidCallback onLayout;
  @override
  RenderObject createRenderObject(BuildContext context) => _LayoutCounterRenderBox(onLayout);
}

class _LayoutCounterRenderBox extends RenderProxyBox {
  _LayoutCounterRenderBox(this.onLayout);
  final VoidCallback onLayout;
  @override
  void performLayout() {
    onLayout();
    super.performLayout();
  }
}
