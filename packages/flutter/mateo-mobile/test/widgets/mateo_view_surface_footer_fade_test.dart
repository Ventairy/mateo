import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_edge_fade/mateo_edge_fade_painter.dart';
import 'package:mateo_mobile/src/bases/base_mateo_edge_fade/mateo_edge_fade_profile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/base_mateo_surface.dart';
import 'package:mateo_mobile/src/bases/base_mateo_view/base_mateo_view.dart';

final Finder _fadeFinder = find.byWidgetPredicate(
  (widget) => widget is CustomPaint && widget.foregroundPainter is MateoEdgeFadePainter,
);
MateoEdgeFadePainter _fade(WidgetTester tester) =>
    tester.widget<CustomPaint>(_fadeFinder).foregroundPainter! as MateoEdgeFadePainter;

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
  testWidgets('when a footer changes geometry or presence, it should end the fade at its corrected top', (
    tester,
  ) async {
    for (final (present, height, safeBottom, keyboard) in [
      (true, 40.0, 0.0, 0.0),
      (true, 80.0, 24.0, 0.0),
      (true, 80.0, 0.0, 120.0),
      (false, 80.0, 0.0, 0.0),
      (true, 0.0, 0.0, 0.0),
      (true, 40.0, 0.0, 0.0),
    ]) {
      await tester.pumpWidget(
        _host(
          MediaQuery(
            data: MediaQueryData(
              padding: .only(bottom: safeBottom),
              viewInsets: .only(bottom: keyboard),
            ),
            child: MateoView(
              padding: EdgeInsets.zero,
              header: const MateoViewHeader(principal: SizedBox(height: 40)),
              footer: present ? MateoViewFooter(principal: SizedBox(height: height)) : null,
              surface: MateoViewSurface(edgeEffect: .fade(), child: const SizedBox()),
            ),
          ),
        ),
      );
      final finder = _fadeFinder;
      final engine = _fade(tester);
      final bands = engine.resolveBands(tester.getSize(finder));
      final view = MateoViewLayoutScope.maybeOf(tester.element(finder))!;
      expect(view.footer == null, !present);
      expect(bands.first.extent, 60);
      final bottom = bands.last;
      expect(bottom.edge, AxisDirection.down);
      expect(bottom.extent, present ? view.footer!.height - view.footer!.topOffset : 60);
      if (present) {
        final clearance = tester
            .widget<BaseMateoSurface>(find.byType(BaseMateoSurface))
            .obstruction!
            .layoutInsets
            .bottom;
        expect(clearance, bottom.extent + view.footer!.bottomInset);
        expect(view.footer!.bottomInset, keyboard);
        final profile = bottom.profile;
        expect(profile.stops.length, 33);
        expect(profile.visibility.first, 0);
        expect(profile.visibility.last, 1);
        expect(profile.visibility[16], .5);
        for (var i = 0; i <= 1000; i++) {
          final t = i / 1000;
          final expected = t * t * t * (10 + t * (-15 + 6 * t));
          expect((_sample(profile, t) - expected).abs(), lessThan(.000705));
        }
      }
      await tester.pump();
      expect(tester.takeException(), isNull);
    }
  });

  for (final opaque in [true, false]) {
    testWidgets(
      'when the bottom inset changes with opaque $opaque, it should position the footer fade without stretching it',
      (
        tester,
      ) async {
        for (final inset in [100.0, 160.0, 0.0]) {
          await tester.pumpWidget(
            _host(
              MediaQuery(
                data: MediaQueryData(viewInsets: .only(bottom: inset)),
                child: MateoView(
                  padding: .zero,
                  footer: const MateoViewFooter(principal: SizedBox(height: 80)),
                  surface: MateoViewSurface.scrollable(
                    color: opaque ? const Color(0xFFFFFFFF) : const Color(0x00000000),
                    edgeEffect: .fade(at: const [.bottom]),
                    child: const SizedBox(height: 1000, child: ColoredBox(color: Color(0xFF000000))),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect((await _pixel(tester, 120, (360 - inset).toInt()))[opaque ? 0 : 3], closeTo(opaque ? 130 : 125, 4));
          expect((await _pixel(tester, 120, (319 - inset).toInt()))[opaque ? 0 : 3], opaque ? 0 : 255);
        }
      },
    );
  }

  testWidgets('when a footer lays out independently, it should repaint the current fade without rebuilding it', (
    tester,
  ) async {
    final height = ValueNotifier<double>(40);
    addTearDown(height.dispose);
    await tester.pumpWidget(
      _host(
        MateoView(
          padding: EdgeInsets.zero,
          footer: MateoViewFooter(
            principal: ValueListenableBuilder<double>(
              valueListenable: height,
              builder: (context, value, child) => SizedBox(height: value),
            ),
          ),
          surface: MateoViewSurface.scrollable(
            color: const Color(0xFFFFFFFF),
            edgeEffect: .fade(at: const [.bottom]),
            child: const SizedBox(height: 1000, child: ColoredBox(color: Color(0xFF000000))),
          ),
        ),
      ),
    );
    final finder = _fadeFinder;
    final engine = _fade(tester);
    expect(engine.resolveBands(tester.getSize(finder)).single.extent, 40);
    final before = (await _pixel(tester, 120, 360))[0];
    expect(before, lessThan(3));
    height.value = 80;
    await tester.pump();
    expect(identical(engine, _fade(tester)), isTrue);
    expect(engine.resolveBands(tester.getSize(finder)).single.extent, 80);
    expect((await _pixel(tester, 120, 360))[0], closeTo(130, 4));
    expect((await _pixel(tester, 120, 319))[0], 0);
    expect(tester.takeException(), isNull);
  });
}
