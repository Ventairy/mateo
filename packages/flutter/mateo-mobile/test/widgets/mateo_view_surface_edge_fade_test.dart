import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_edge_fade/base_mateo_edge_fade.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/base_mateo_surface.dart';

final _theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);

Widget _host({required MateoViewSurface surface, double height = 400, double headerHeight = 30}) => MateoTheme(
  data: _theme,
  child: Directionality(
    textDirection: .ltr,
    child: Center(
      child: SizedBox(
        width: 240,
        height: height,
        child: MateoView(
          header: MateoViewHeader(principal: SizedBox(height: headerHeight)),
          footer: const MateoViewFooter(principal: SizedBox(height: 30)),
          surface: surface,
        ),
      ),
    ),
  ),
);

MateoViewSurface _surface({required bool scrollable, required MateoEdgeEffect effect, Color? color, Widget? child}) =>
    scrollable
    ? MateoViewSurface.scrollable(color: color, edgeEffect: effect, child: child ?? const SizedBox(height: 1200))
    : MateoViewSurface(color: color, edgeEffect: effect, child: child ?? const SizedBox());

void main() {
  for (final scrollable in [false, true]) {
    testWidgets(
      'when ${scrollable ? 'scrollable' : 'ordinary'} effects are selected, it should dispatch only requested bands',
      (tester) async {
        for (final effect in [
          const MateoEdgeEffect.none(),
          MateoEdgeEffect.fade(at: const []),
          MateoEdgeEffect.fade(at: const [.top]),
          MateoEdgeEffect.fade(at: const [.bottom]),
          MateoEdgeEffect.fade(),
        ]) {
          await tester.pumpWidget(
            _host(
              surface: _surface(scrollable: scrollable, effect: effect),
            ),
          );
          await tester.pumpAndSettle();
          final base = tester.widget<BaseMateoSurface>(find.byType(BaseMateoSurface));
          if (effect.at.isEmpty) {
            expect(base.edgeEffectBuilder, isNull);

            expect(find.byType(BaseMateoEdgeFade), findsNothing);
          } else {
            final engine = tester.widget<BaseMateoEdgeFade>(find.byType(BaseMateoEdgeFade));
            expect(engine.resolveBands(tester.getSize(find.byType(BaseMateoEdgeFade))).map((band) => band.edge), [
              if (effect.at.contains(MateoEdgeEffectSide.top)) AxisDirection.up,
              if (effect.at.contains(MateoEdgeEffectSide.bottom)) AxisDirection.down,
            ]);
            for (final control in [find.byType(MateoViewHeader), find.byType(MateoViewFooter)]) {
              expect(find.descendant(of: find.byType(BaseMateoEdgeFade), matching: control), findsNothing);
            }
          }
        }
      },
    );

    testWidgets(
      'when ${scrollable ? 'scrollable' : 'ordinary'} view geometry changes, it should size each fade from its fixed control',
      (tester) async {
        for (final (height, headerHeight) in [(400.0, 30.0), (400.0, 60.0), (500.0, 60.0)]) {
          await tester.pumpWidget(
            _host(
              height: height,
              headerHeight: headerHeight,
              surface: _surface(scrollable: scrollable, effect: .fade()),
            ),
          );
          await tester.pumpAndSettle();
          if (scrollable) {
            tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!.jumpTo(0);
            await tester.pumpAndSettle();
          }
          final finder = find.byType(BaseMateoEdgeFade);
          final size = tester.getSize(finder);
          expect(size, Size(240, height));
          final bands = tester.widget<BaseMateoEdgeFade>(finder).resolveBands(size);
          expect(bands.map((band) => band.extent), [
            tester.widget<BaseMateoSurface>(find.byType(BaseMateoSurface)).obstructionInsets!().top + 20,
            42, // The 30-pixel footer and its inherited bottom padding.
          ]);
          if (scrollable) {
            final bounds = tester.getRect(finder);
            tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!.jumpTo(100);
            await tester.pumpAndSettle();
            expect(tester.getRect(finder), bounds);
            final scrolled = tester.widget<BaseMateoEdgeFade>(finder).resolveBands(size);
            expect(scrolled.first.extent, closeTo((bands.first.extent - 20) / .55, 1e-10));
            expect(scrolled.first.profile, same(bands.first.profile));
            expect(scrolled.last.extent, bands.last.extent);
          }
        }
      },
    );

    testWidgets(
      'when ${scrollable ? 'scrollable' : 'ordinary'} effects and opacity change, it should preserve child and scroll state',
      (tester) async {
        State? original;
        ScrollController? controller;
        for (final (effect, color) in [
          (const MateoEdgeEffect.none(), const Color(0xFFFFFFFF)),
          (MateoEdgeEffect.fade(), const Color(0xFFFFFFFF)),
          (MateoEdgeEffect.fade(at: const [.bottom]), const Color(0xFFFFFFFF)),
          (MateoEdgeEffect.fade(), const Color(0x80FFFFFF)),
          (MateoEdgeEffect.fade(), const Color(0x00000000)),
          (MateoEdgeEffect.fade(at: const []), const Color(0xFFFFFFFF)),
          (MateoEdgeEffect.fade(), const Color(0xFFFFFFFF)),
          (const MateoEdgeEffect.none(), const Color(0xFFFFFFFF)),
        ]) {
          await tester.pumpWidget(
            _host(
              surface: _surface(
                scrollable: scrollable,
                effect: effect,
                color: color,
                child: StatefulBuilder(builder: (context, setState) => const SizedBox(height: 1200)),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final current = tester.state(find.byType(StatefulBuilder));
          original ??= current;
          expect(identical(current, original), isTrue);
          if (scrollable) {
            final currentController = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!;
            if (controller == null) {
              controller = currentController..jumpTo(100);
              await tester.pumpAndSettle();
            }
            expect(identical(currentController, controller), isTrue);
            expect(currentController.offset, 100);
          }
          expect(tester.takeException(), isNull);
        }
      },
    );

    testWidgets(
      'when ${scrollable ? 'scrollable' : 'ordinary'} surface colors resolve, it should choose the matching rendering path',
      (tester) async {
        for (final color in [null, const Color(0xFF123456), const Color(0x80123456), const Color(0x00000000)]) {
          await tester.pumpWidget(
            _host(
              surface: _surface(scrollable: scrollable, effect: .fade(), color: color),
            ),
          );
          final resolved = color ?? _theme.colorScheme.background;

          final engine = tester.widget<BaseMateoEdgeFade>(find.byType(BaseMateoEdgeFade));
          expect(engine.color, resolved.a == 1 ? resolved : isNull);
        }
      },
    );
  }

  testWidgets('when effects are omitted, it should preserve both constructors default behavior', (tester) async {
    for (final surface in [
      const MateoViewSurface(child: SizedBox()),
      const MateoViewSurface.scrollable(child: SizedBox()),
    ]) {
      await tester.pumpWidget(_host(surface: surface));
      expect(surface.edgeEffect, const MateoEdgeEffect.none());
      expect(tester.widget<BaseMateoSurface>(find.byType(BaseMateoSurface)).edgeEffectBuilder, isNull);
      expect(find.byType(BaseMateoEdgeFade), findsNothing);
    }
  });
}
