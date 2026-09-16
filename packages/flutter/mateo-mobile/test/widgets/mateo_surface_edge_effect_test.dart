import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_edge_fade/base_mateo_edge_fade.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/base_mateo_surface.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/default_mateo_surface_edge_fade/default_mateo_surface_edge_fade.dart';

const _white = Color(0xFFFFFFFF);
const _black = Color(0xFF000000);
const ValueKey<String> _capture = ValueKey('capture');
final _theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);

Widget _host(Widget child) => MateoTheme(
  data: _theme,
  child: Directionality(
    textDirection: .ltr,
    child: Center(
      child: RepaintBoundary(key: _capture, child: child),
    ),
  ),
);

Widget _surface({
  required bool scrollable,
  MateoEdgeEffect? effect,
  Color? color = _white,
  double height = 200,
  EdgeInsets? padding,
  Alignment? alignment,
  Widget? child,
}) => scrollable
    ? MateoSurface.scrollable(
        color: color,
        width: const .custom(100),
        height: .custom(height),
        padding: padding,
        alignment: alignment,
        edgeEffect: effect ?? const .none(),
        child: child ?? const SizedBox(height: 1000, child: ColoredBox(color: _black)),
      )
    : MateoSurface(
        color: color,
        width: const .custom(100),
        height: .custom(height),
        padding: padding,
        alignment: alignment,
        edgeEffect: effect ?? const .none(),
        child: child ?? const ColoredBox(color: _black),
      );

Future<List<int>> _pixel(WidgetTester tester, int x, int y) async => (await tester.runAsync(() async {
  final image = await tester.renderObject<RenderRepaintBoundary>(find.byKey(_capture)).toImage();
  final bytes = (await image.toByteData(format: .rawRgba))!;
  final offset = (y * image.width + x) * 4;
  final result = List<int>.generate(4, (index) => bytes.getUint8(offset + index));
  image.dispose();
  return result;
}))!;

void main() {
  for (final scrollable in [false, true]) {
    testWidgets(
      'when ${scrollable ? 'scrollable' : 'ordinary'} effects change, it should dispatch only selected edges',
      (tester) async {
        for (final effect in [
          const MateoEdgeEffect.none(),
          MateoEdgeEffect.fade(at: const []),
          MateoEdgeEffect.fade(at: const [.top]),
          MateoEdgeEffect.fade(at: const [.bottom]),
          MateoEdgeEffect.fade(),
        ]) {
          await tester.pumpWidget(_host(_surface(scrollable: scrollable, effect: effect)));
          final base = tester.widget<BaseMateoSurface>(find.byType(BaseMateoSurface));
          if (effect.at.isEmpty) {
            expect(base.edgeEffectBuilder, isNull);
            expect(find.byType(DefaultMateoSurfaceEdgeFade), findsNothing);
            expect(await _pixel(tester, 50, 0), [0, 0, 0, 255]);
          } else {
            expect(find.byType(DefaultMateoSurfaceEdgeFade), findsOneWidget);
            expect((await _pixel(tester, 50, 0))[0], effect.at.contains(MateoEdgeEffectSide.top) ? 255 : 0);
            expect((await _pixel(tester, 50, 199))[0], effect.at.contains(MateoEdgeEffectSide.bottom) ? 255 : 0);
          }
        }
      },
    );

    testWidgets(
      'when ${scrollable ? 'scrollable' : 'ordinary'} content resizes, it should size fades from the padded viewport',
      (tester) async {
        for (final height in [200.0, 400.0]) {
          await tester.pumpWidget(
            _host(
              _surface(
                scrollable: scrollable,
                height: height,
                effect: .fade(),
                padding: const .symmetric(horizontal: 10),
                alignment: .center,
                child: SizedBox(
                  width: 80,
                  height: scrollable ? 1000 : height,
                  child: const ColoredBox(color: _black),
                ),
              ),
            ),
          );
          final finder = find.byType(BaseMateoEdgeFade);
          final size = tester.getSize(finder);
          expect(size, Size(100, height));
          final bands = tester.widget<BaseMateoEdgeFade>(finder).resolveBands(size);
          expect(bands.map((band) => band.extent), [height * .15, height * .15]);
          expect((await _pixel(tester, 50, (height * .075).floor()))[0], closeTo(127, 9));
          expect(await _pixel(tester, 50, (height * .5).floor()), [0, 0, 0, 255]);
          expect(await _pixel(tester, 5, (height * .5).floor()), [255, 255, 255, 255]);
          if (scrollable) {
            final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!;
            final before = await _pixel(tester, 50, 14);
            controller.jumpTo(120);
            await tester.pumpAndSettle();
            expect(controller.offset, 120);
            expect(await _pixel(tester, 50, 14), before);
          }
        }
      },
    );

    testWidgets(
      'when ${scrollable ? 'scrollable' : 'ordinary'} wrappers change, it should retain child state and scroll position',
      (tester) async {
        State? original;
        ScrollController? controller;
        for (final (effect, color) in [
          (const MateoEdgeEffect.none(), _white),
          (MateoEdgeEffect.fade(), _white),
          (MateoEdgeEffect.fade(at: const [.bottom]), _white),
          (MateoEdgeEffect.fade(), const Color(0x80FFFFFF)),
          (MateoEdgeEffect.fade(), const Color(0x00000000)),
          (MateoEdgeEffect.fade(at: const []), _white),
          (MateoEdgeEffect.fade(), _white),
          (const MateoEdgeEffect.none(), _white),
        ]) {
          await tester.pumpWidget(
            _host(
              _surface(
                scrollable: scrollable,
                effect: effect,
                color: color,
                child: StatefulBuilder(builder: (context, setState) => const SizedBox(height: 1000)),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final state = tester.state(find.byType(StatefulBuilder));
          original ??= state;
          expect(identical(state, original), isTrue);
          if (scrollable) {
            final current = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!;
            if (controller == null) {
              controller = current..jumpTo(120);
              await tester.pumpAndSettle();
            }
            expect(identical(controller, current), isTrue);
            expect(current.offset, 120);
          }
          expect(tester.takeException(), isNull);
        }
      },
    );
  }

  testWidgets('when effects are omitted, it should leave both constructors without a builder', (tester) async {
    for (final surface in [const MateoSurface(child: SizedBox()), const MateoSurface.scrollable(child: SizedBox())]) {
      await tester.pumpWidget(_host(SizedBox(width: 100, height: 200, child: surface)));
      expect(tester.widget<BaseMateoSurface>(find.byType(BaseMateoSurface)).edgeEffectBuilder, isNull);
    }
  });

  testWidgets('when colors resolve, it should select overlay or mask and retain the surface background', (
    tester,
  ) async {
    for (final color in [null, _white, const Color(0x80FFFFFF), const Color(0x00000000)]) {
      await tester.pumpWidget(
        _host(
          ColoredBox(
            color: const Color(0xFF0000FF),
            child: _surface(scrollable: false, color: color, effect: .fade()),
          ),
        ),
      );
      final resolved = color ?? _theme.colorScheme.background;
      final engine = tester.widget<BaseMateoEdgeFade>(find.byType(BaseMateoEdgeFade));
      expect(engine.color, resolved.a == 1 ? resolved : isNull);
      final pixel = await _pixel(tester, 50, 0);
      expect(pixel[0], closeTo((resolved.r * resolved.a * 255).round(), 1));
      expect(pixel[2], closeTo(((resolved.b * resolved.a + 1 - resolved.a) * 255).round(), 1));
      expect(await _pixel(tester, 50, 100), [0, 0, 0, 255]);
    }
  });

  testWidgets('when fading intrinsic content, it should preserve layout hit testing and semantics', (tester) async {
    final semantics = tester.ensureSemantics();
    var taps = 0;
    for (final color in [_white, const Color(0x00000000)]) {
      for (final effect in [const MateoEdgeEffect.none(), MateoEdgeEffect.fade()]) {
        await tester.pumpWidget(
          _host(
            IntrinsicWidth(
              child: IntrinsicHeight(
                child: MateoSurface(
                  color: color,
                  edgeEffect: effect,
                  padding: const .all(10),
                  alignment: .center,
                  child: Semantics(
                    label: 'Action',
                    button: true,
                    child: GestureDetector(
                      behavior: .opaque,
                      onTap: () => taps++,
                      child: const SizedBox(width: 70, height: 40),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        expect(tester.getSize(find.byType(MateoSurface)), const Size(90, 60));
        expect(
          tester.getTopLeft(find.byType(GestureDetector)) - tester.getTopLeft(find.byType(MateoSurface)),
          const Offset(10, 10),
        );
        expect(find.bySemanticsLabel('Action'), findsOneWidget);
        await tester.tapAt(tester.getTopLeft(find.byType(GestureDetector)) + const Offset(2, 2));
      }
    }
    expect(taps, 4);
    semantics.dispose();
  });

  testWidgets('when fading rounded elevated content, it should preserve clipping and outer shadows', (tester) async {
    final originalShadows = <List<int>>[];
    for (final effect in [const MateoEdgeEffect.none(), MateoEdgeEffect.fade()]) {
      await tester.pumpWidget(
        _host(
          ColoredBox(
            color: _white,
            child: Padding(
              padding: const .all(40),
              child: MateoSurface(
                width: const .custom(100),
                height: const .custom(200),
                color: _white,
                shape: const .rounded(radius: 32),
                elevation: MateoElevation(level: 1),
                edgeEffect: effect,
                child: const ColoredBox(color: _black),
              ),
            ),
          ),
        ),
      );
      final clip = tester.widget<ClipPath>(find.byType(ClipPath));
      expect((clip.clipper! as ShapeBorderClipper).shape, const MateoRoundedShapeBorder(radius: 32));
      expect(await _pixel(tester, 40, 40), [255, 255, 255, 255]);
      final shadowPixels = [await _pixel(tester, 90, 242), await _pixel(tester, 90, 248)];
      if (effect.at.isEmpty) {
        originalShadows.addAll(shadowPixels);
      } else {
        expect(shadowPixels, originalShadows);
      }
      final decoration = tester.widget<DecoratedBox>(find.byType(DecoratedBox)).decoration as ShapeDecoration;
      expect(decoration.shadows, isNotEmpty);
      expect(find.descendant(of: find.byType(ClipPath), matching: find.byType(DecoratedBox)), findsNothing);
    }
  });

  testWidgets('when used by a view surface, it should keep the base effect builder absent', (tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 300,
          height: 400,
          child: MateoView(surface: MateoViewSurface(child: SizedBox())),
        ),
      ),
    );
    expect(tester.widget<BaseMateoSurface>(find.byType(BaseMateoSurface)).edgeEffectBuilder, isNull);
    expect(find.byType(BaseMateoEdgeFade), findsNothing);
  });
}
