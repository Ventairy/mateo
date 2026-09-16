import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/src/bases/base_mateo_edge_fade/base_mateo_edge_fade.dart';
import 'package:mateo_mobile/src/bases/base_mateo_edge_fade/mateo_edge_fade_band.dart';
import 'package:mateo_mobile/src/bases/base_mateo_edge_fade/mateo_edge_fade_profile.dart';

part '_edge_fade_notifier.dart';
part '_edge_fade_recording_canvas.dart';

final _linear = MateoEdgeFadeProfile(stops: const [0, 1], visibility: const [0, 1]);
const _white = Color(0xFFFFFFFF);
const _black = Color(0xFF000000);
const _blue = Color(0xFF0000FF);

Widget _host(Widget child, {Key? captureKey, double height = 100}) => Directionality(
  textDirection: .ltr,
  child: Center(
    child: RepaintBoundary(
      key: captureKey,
      child: SizedBox(width: 100, height: height, child: child),
    ),
  ),
);

Future<List<int>> _pixel(WidgetTester tester, Key key, int x, int y) async => (await tester.runAsync(() async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(key));
  final image = await boundary.toImage();
  final bytes = (await image.toByteData(format: .rawRgba))!;
  final offset = (y * image.width + x) * 4;
  final result = List<int>.generate(4, (index) => bytes.getUint8(offset + index));
  image.dispose();
  return result;
}))!;

void main() {
  test('when a profile is created, it should copy its data and compare by value', () {
    final stops = <double>[0, 1];
    final visibility = <double>[0, 1];
    final profile = MateoEdgeFadeProfile(stops: stops, visibility: visibility);
    stops[1] = 0.5;
    visibility[0] = 0.5;
    expect(profile, _linear);
    expect(profile.hashCode, _linear.hashCode);
    expect(() => profile.stops[0] = 1, throwsUnsupportedError);
    expect(() => profile.visibility.add(1), throwsUnsupportedError);
    // Profiles belong to their author; nonmonotonic visibility is valid.
    expect(MateoEdgeFadeProfile(stops: const [0, .4, 1], visibility: const [1, 0, .5]), isNotNull);
  });

  test('when fade inputs are invalid, it should reject them at their owner', () {
    for (final stops in <List<double>>[
      [],
      [0],
      [0, .5],
      [.1, 1],
      [0, 0, 1],
      [0, double.nan, 1],
      [0, 2, 1],
    ]) {
      expect(() => MateoEdgeFadeProfile(stops: stops, visibility: List.filled(stops.length, 1)), throwsArgumentError);
    }
    for (final visibility in <List<double>>[
      [0],
      [0, -1],
      [0, 2],
      [0, double.infinity],
      [double.nan, 1],
    ]) {
      expect(() => MateoEdgeFadeProfile(stops: const [0, 1], visibility: visibility), throwsArgumentError);
    }
    for (final extent in [-1.0, double.infinity, double.nan]) {
      expect(() => MateoEdgeFadeBand.top(extent: extent, profile: _linear), throwsArgumentError);
      expect(() => MateoEdgeFadeBand.bottom(extent: extent, profile: _linear), throwsArgumentError);
      expect(() => MateoEdgeFadeBand.left(extent: extent, profile: _linear), throwsArgumentError);
      expect(() => MateoEdgeFadeBand.right(extent: extent, profile: _linear), throwsArgumentError);
    }
  });

  testWidgets('when an overlay color is translucent, it should reject the color', (tester) async {
    await tester.pumpWidget(
      _host(
        BaseMateoEdgeFade.overlay(color: const Color(0x80FFFFFF), resolveBands: (_) => [], child: const SizedBox()),
      ),
    );
    expect(tester.takeException(), isArgumentError);
  });

  for (final mask in [false, true]) {
    testWidgets('when ${mask ? 'mask' : 'overlay'} bands face opposite edges, it should use independent profiles', (
      tester,
    ) async {
      const key = ValueKey('capture');
      final bands = <MateoEdgeFadeBand>[
        .top(extent: 40, profile: _linear),
        .bottom(
          extent: 40,
          profile: MateoEdgeFadeProfile(stops: const [0, 1], visibility: const [0, .5]),
        ),
      ];
      const content = RepaintBoundary(child: ColoredBox(color: _black));
      await tester.pumpWidget(
        _host(
          ColoredBox(
            color: _white,
            child: mask
                ? BaseMateoEdgeFade.mask(resolveBands: (_) => bands, child: content)
                : BaseMateoEdgeFade.overlay(color: _white, resolveBands: (_) => bands, child: content),
          ),
          captureKey: key,
        ),
      );
      expect((await _pixel(tester, key, 50, 19))[0], closeTo(131, 2));
      expect((await _pixel(tester, key, 50, 50))[0], 0);
      expect((await _pixel(tester, key, 50, 80))[0], closeTo(193, 2));
    });

    testWidgets('when ${mask ? 'mask' : 'overlay'} bands overlap, it should multiply visibility regardless of order', (
      tester,
    ) async {
      const key = ValueKey('capture');
      final bands = <MateoEdgeFadeBand>[.top(extent: 100, profile: _linear), .bottom(extent: 100, profile: _linear)];
      Future<List<int>> render(List<MateoEdgeFadeBand> values) async {
        const child = RepaintBoundary(child: ColoredBox(color: _black));
        await tester.pumpWidget(
          _host(
            ColoredBox(
              color: _white,
              child: mask
                  ? BaseMateoEdgeFade.mask(resolveBands: (_) => values, child: child)
                  : BaseMateoEdgeFade.overlay(color: _white, resolveBands: (_) => values, child: child),
            ),
            captureKey: key,
          ),
        );
        return _pixel(tester, key, 50, 50);
      }

      final forward = await render(bands);
      expect(forward[0], closeTo(191, 2));
      final reversed = await render(bands.reversed.toList());
      // Integer framebuffer blending may round differently by one channel step.
      for (var channel = 0; channel < 4; channel++) {
        expect(reversed[channel], closeTo(forward[channel], 1));
      }
    });
  }

  for (final mask in [false, true]) {
    testWidgets(
      'when horizontal ${mask ? 'mask' : 'overlay'} bands change, it should preserve direction extent and corner composition',
      (tester) async {
        const key = ValueKey('capture');
        final signal = ChangeNotifier();
        var bands = <MateoEdgeFadeBand>[.left(extent: 40, profile: _linear), .right(extent: 20, profile: _linear)];
        const content = RepaintBoundary(child: ColoredBox(color: _black));
        await tester.pumpWidget(
          _host(
            ColoredBox(
              color: _white,
              child: mask
                  ? BaseMateoEdgeFade.mask(repaint: signal, resolveBands: (_) => bands, child: content)
                  : BaseMateoEdgeFade.overlay(
                      color: _white,
                      repaint: signal,
                      resolveBands: (_) => bands,
                      child: content,
                    ),
            ),
            captureKey: key,
          ),
        );
        expect((await _pixel(tester, key, 19, 50))[0], closeTo(131, 2));
        expect((await _pixel(tester, key, 50, 50))[0], 0);
        expect((await _pixel(tester, key, 90, 50))[0], closeTo(134, 2));
        for (final band in <MateoEdgeFadeBand>[
          .left(extent: 200, profile: _linear),
          .right(extent: 200, profile: _linear),
        ]) {
          bands = [band];
          signal.notifyListeners();
          await tester.pump();
          expect((await _pixel(tester, key, 50, 50))[0], closeTo(191, 2));
        }
        bands = [.left(extent: 100, profile: _linear), .top(extent: 100, profile: _linear)];
        signal.notifyListeners();
        await tester.pump();
        expect((await _pixel(tester, key, 50, 50))[0], closeTo(190, 2));
        bands = [.left(extent: 0, profile: _linear), .right(extent: 0, profile: _linear)];
        signal.notifyListeners();
        await tester.pump();
        expect((await _pixel(tester, key, 50, 50))[0], 0);
        await tester.pumpWidget(const SizedBox());
        signal.dispose();
      },
    );
  }

  testWidgets('when a band exceeds its viewport, it should crop without rescaling the profile', (tester) async {
    const key = ValueKey('capture');
    for (final top in [true, false]) {
      await tester.pumpWidget(
        _host(
          BaseMateoEdgeFade.overlay(
            color: _white,
            resolveBands: (_) => [
              if (top) .top(extent: 200, profile: _linear) else .bottom(extent: 200, profile: _linear),
            ],
            child: const ColoredBox(color: _black),
          ),
          captureKey: key,
        ),
      );
      expect((await _pixel(tester, key, 50, 50))[0], closeTo(191, 2));
    }
  });

  testWidgets('when masking composited content, it should reveal the background and preserve siblings', (tester) async {
    const key = ValueKey('capture');
    await tester.pumpWidget(
      _host(
        Stack(
          fit: .expand,
          children: [
            const ColoredBox(color: _blue),
            BaseMateoEdgeFade.mask(
              resolveBands: (_) => [.top(extent: 100, profile: _linear)],
              child: const RepaintBoundary(child: ColoredBox(color: _white)),
            ),
            const Positioned(left: 0, top: 0, width: 10, height: 100, child: ColoredBox(color: _black)),
          ],
        ),
        captureKey: key,
      ),
    );
    final pixel = await _pixel(tester, key, 50, 50);
    expect(pixel[0], closeTo(129, 2));
    expect(pixel[1], closeTo(129, 2));
    expect(pixel[2], 255);
    expect(pixel[3], 255);
    expect(await _pixel(tester, key, 5, 50), [0, 0, 0, 255]);
  });

  testWidgets('when a child overflows, it should crop only the fade and leave content clipping to its host', (
    tester,
  ) async {
    const key = ValueKey('capture');
    final invisible = MateoEdgeFadeProfile(stops: const [0, 1], visibility: const [0, 0]);
    for (final mask in [false, true]) {
      const child = OverflowBox(
        maxWidth: 100,
        maxHeight: 100,
        child: SizedBox(width: 100, height: 100, child: ColoredBox(color: _blue)),
      );
      await tester.pumpWidget(
        _host(
          Stack(
            children: [
              Positioned(
                left: 20,
                top: 20,
                width: 60,
                height: 60,
                child: mask
                    ? BaseMateoEdgeFade.mask(
                        resolveBands: (_) => [.top(extent: 100, profile: invisible)],
                        child: child,
                      )
                    : BaseMateoEdgeFade.overlay(
                        color: _white,
                        resolveBands: (_) => [.top(extent: 100, profile: invisible)],
                        child: child,
                      ),
              ),
            ],
          ),
          captureKey: key,
        ),
      );
      expect(await _pixel(tester, key, 10, 10), [0, 0, 255, 255]);
      expect(await _pixel(tester, key, 50, 50), mask ? [0, 0, 0, 0] : [255, 255, 255, 255]);
    }
  });

  testWidgets('when bands are empty or zero, it should leave the child unchanged', (tester) async {
    const key = ValueKey('capture');
    for (final bands in <List<MateoEdgeFadeBand>>[
      [],
      [.top(extent: 0, profile: _linear)],
    ]) {
      await tester.pumpWidget(
        _host(
          BaseMateoEdgeFade.mask(
            resolveBands: (_) => bands,
            child: const ColoredBox(color: _blue),
          ),
          captureKey: key,
        ),
      );
      expect(await _pixel(tester, key, 50, 50), [0, 0, 255, 255]);
    }
    await tester.pumpWidget(
      _host(
        BaseMateoEdgeFade.mask(
          resolveBands: (_) => [.top(extent: 20, profile: _linear)],
          child: const SizedBox(),
        ),
        height: 0,
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'when the repaint signal changes, it should repaint without rebuilding or laying out the child and detach listeners',
    (tester) async {
      final first = _EdgeFadeNotifier();
      final second = _EdgeFadeNotifier();
      var builds = 0;
      var layouts = 0;
      var paints = 0;
      var extent = 20.0;
      final child = Builder(
        builder: (_) {
          builds++;
          return LayoutBuilder(
            builder: (_, _) {
              layouts++;
              return const ColoredBox(color: _black);
            },
          );
        },
      );
      List<MateoEdgeFadeBand> resolve(Size size) {
        paints++;
        return [.top(extent: extent, profile: _linear)];
      }

      Widget build(Listenable signal, {double height = 100}) => _host(
        BaseMateoEdgeFade.overlay(color: _white, resolveBands: resolve, repaint: signal, child: child),
        height: height,
      );
      await tester.pumpWidget(build(first));
      expect(first.isObserved, isTrue);
      final counts = (builds, layouts, paints);
      extent = 50;
      first.notifyListeners();
      await tester.pump();
      expect((builds, layouts), (counts.$1, counts.$2));
      expect(paints, counts.$3 + 1);
      await tester.pumpWidget(build(second));
      expect(first.isObserved, isFalse);
      expect(second.isObserved, isTrue);
      final afterReplacement = paints;
      first.notifyListeners();
      await tester.pump();
      expect(paints, afterReplacement);
      await tester.pumpWidget(const SizedBox());
      expect(second.isObserved, isFalse);
      first.dispose();
      second.dispose();
    },
  );

  testWidgets('when layout changes, it should resolve from its current local size', (tester) async {
    final sizes = <Size>[];
    for (final height in [100.0, 60.0]) {
      await tester.pumpWidget(
        _host(
          BaseMateoEdgeFade.overlay(
            color: _white,
            resolveBands: (size) {
              sizes.add(size);
              return [];
            },
            child: const SizedBox(),
          ),
          height: height,
        ),
      );
      expect(sizes.last, Size(100, height));
    }
  });

  testWidgets('when painting repeats, it should reuse shaders until their inputs change and discard inactive bands', (
    tester,
  ) async {
    var bands = <MateoEdgeFadeBand>[.top(extent: 20, profile: _linear)];
    await tester.pumpWidget(
      _host(BaseMateoEdgeFade.overlay(color: _white, resolveBands: (_) => bands, child: const SizedBox())),
    );
    final painter = tester
        .widget<CustomPaint>(find.descendant(of: find.byType(BaseMateoEdgeFade), matching: find.byType(CustomPaint)))
        .foregroundPainter!;
    final canvas = _EdgeFadeRecordingCanvas();
    painter.paint(canvas, const Size(100, 100));
    final shader = canvas.shaders.last;
    bands = [
      .top(
        extent: 20,
        profile: MateoEdgeFadeProfile(stops: const [0, 1], visibility: const [0, 1]),
      ),
    ];
    painter.paint(canvas, const Size(100, 100));
    expect(identical(shader, canvas.shaders.last), isTrue);
    painter.paint(canvas, const Size(120, 100));
    expect(identical(shader, canvas.shaders.last), isFalse);
    final resized = canvas.shaders.last;
    bands = [
      .top(
        extent: 20,
        profile: MateoEdgeFadeProfile(stops: const [0, 1], visibility: const [0, .5]),
      ),
    ];
    painter.paint(canvas, const Size(120, 100));
    expect(identical(resized, canvas.shaders.last), isFalse);
    final previous = canvas.shaders.last;
    bands = [];
    painter.paint(canvas, const Size(120, 100));
    bands = [
      .top(
        extent: 20,
        profile: MateoEdgeFadeProfile(stops: const [0, 1], visibility: const [0, .5]),
      ),
    ];
    painter.paint(canvas, const Size(120, 100));
    expect(identical(previous, canvas.shaders.last), isFalse);
  });

  testWidgets('when a faded child is interactive, it should preserve layout intrinsics hits and semantics', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var taps = 0;
    const key = ValueKey('child');
    for (final mask in [false, true]) {
      final child = Semantics(
        label: 'Action',
        button: true,
        child: GestureDetector(
          onTap: () => taps++,
          behavior: .opaque,
          child: const SizedBox(key: key, width: 70, height: 40),
        ),
      );
      await tester.pumpWidget(
        Directionality(
          textDirection: .ltr,
          child: Center(
            child: IntrinsicWidth(
              child: IntrinsicHeight(
                child: mask
                    ? BaseMateoEdgeFade.mask(
                        resolveBands: (_) => [.top(extent: 40, profile: _linear)],
                        child: child,
                      )
                    : BaseMateoEdgeFade.overlay(
                        color: _white,
                        resolveBands: (_) => [.top(extent: 40, profile: _linear)],
                        child: child,
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
