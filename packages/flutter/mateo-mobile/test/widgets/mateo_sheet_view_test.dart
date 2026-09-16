import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_edge_fade/base_mateo_edge_fade.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/base_mateo_surface.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/mateo_surface_scope.dart';

import 'package:mateo_mobile/src/bases/base_mateo_view/base_mateo_view.dart';
import 'package:mateo_mobile/src/bases/base_mateo_view/mateo_view_scope.dart';

import '../fixtures/surface_transform_test_widgets.dart';

void main() {
  late BuildContext launcher;
  Future<void> host(WidgetTester tester) async {
    await tester.pumpWidget(
      MateoApp(
        theme: surfaceTransformTheme,
        home: Builder(
          builder: (context) {
            launcher = context;
            return const SizedBox.expand();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('reserves header space by default', () {
    const view = MateoSheetView(surface: MateoSheetViewSurface(child: SizedBox()));
    expect(view.reserveHeaderSpace, isTrue);
  });

  testWidgets(
    'when a sheet inherits view and surface defaults, it should keep its spacing and limit its shape to the surface',
    (tester) async {
      await tester.pumpWidget(
        MateoViewScope(
          padding: const EdgeInsets.all(60),
          child: MateoSurfaceScope(
            shape: const MateoRoundedShapeBorder(radius: 2),
            child: MateoApp(
              theme: surfaceTransformTheme,
              home: Builder(
                builder: (context) {
                  launcher = context;
                  return const SizedBox.expand();
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      unawaited(
        showMateoSheet<void>(
          context: launcher,
          view: const MateoSheetView(
            header: MateoSheetViewHeader(principal: MateoSurface(child: Text('Header'))),
            footer: MateoSheetViewFooter(principal: MateoSurface(child: Text('Footer'))),
            surface: MateoSheetViewSurface(child: SizedBox(height: 80)),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final layout = tester.widget<MateoViewLayoutScope>(find.byType(MateoViewLayoutScope));
      expect(layout.padding, const EdgeInsets.all(20));
      for (final slot in [MateoSheetViewHeader, MateoSheetViewFooter]) {
        final surface = tester.widget<BaseMateoSurface>(
          find.descendant(of: find.byType(slot), matching: find.byType(BaseMateoSurface)),
        );
        expect(surface.shape, const MateoRoundedShapeBorder(radius: 2));
      }
      final surface = tester.widget<BaseMateoSurface>(
        find.descendant(of: find.byType(MateoSheetViewSurface), matching: find.byType(BaseMateoSurface)),
      );
      expect(surface.shape, const MateoRoundedShapeBorder(radius: 44));
      expect(surface.padding, const EdgeInsets.symmetric(horizontal: 20));
    },
  );

  testWidgets(
    'when internal scopes surround sheet content, it should retain fixed styling and explicit child styling',
    (tester) async {
      const view = MateoSheetView(
        header: MateoSheetViewHeader(principal: Text('Header')),
        surface: MateoSheetViewSurface(
          child: MateoSurface(
            shape: .rounded(radius: 8),
            animation: .pop(),
            child: SizedBox(height: 80),
          ),
        ),
      );
      // Defaults around the Navigator remain visible inside its routes.
      await tester.pumpWidget(
        MateoSurfaceScope(
          shape: const MateoRoundedShapeBorder(radius: 2),
          animation: const .pop(),
          child: MateoApp(
            theme: surfaceTransformTheme,
            home: Builder(
              builder: (context) {
                launcher = context;
                return const SizedBox.expand();
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      unawaited(showMateoSheet<void>(context: launcher, view: view));
      await tester.pumpAndSettle();
      final surfaces = tester.widgetList<BaseMateoSurface>(find.byType(BaseMateoSurface)).toList();
      expect(surfaces.first.shape, const MateoRoundedShapeBorder(radius: 44));
      expect(surfaces.first.animation, const MateoSurfaceAnimation.none());
      expect(surfaces.first.padding, const EdgeInsets.symmetric(horizontal: 20));
      expect(surfaces.first.elevation, isNull);
      expect(surfaces.last.shape, const MateoRoundedShapeBorder(radius: 8));
      expect(surfaces.last.animation, const MateoSurfaceAnimation.pop());
    },
  );

  testWidgets('when header space is not reserved, content should use headerless spacing', (tester) async {
    for (final scrollable in [false, true]) {
      final reserveHeaderSpace = ValueNotifier(true);
      addTearDown(reserveHeaderSpace.dispose);
      await tester.pumpWidget(
        MateoApp(
          theme: surfaceTransformTheme,
          home: Center(
            child: SizedBox(
              width: 320,
              height: 400,
              child: ValueListenableBuilder<bool>(
                valueListenable: reserveHeaderSpace,
                builder: (context, reserveHeaderSpace, child) => MateoSheetView(
                  reserveHeaderSpace: reserveHeaderSpace,
                  header: const MateoSheetViewHeader(principal: SizedBox(height: 40)),
                  footer: const MateoSheetViewFooter(principal: SizedBox(height: 30)),
                  surface: scrollable
                      ? const MateoSheetViewSurface.scrollable(
                          child: SizedBox(key: ValueKey('content'), height: 800),
                        )
                      : const MateoSheetViewSurface(
                          child: SizedBox(key: ValueKey('content'), height: 80),
                        ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final reservedLayout = tester.widget<MateoViewLayoutScope>(find.byType(MateoViewLayoutScope));
      final reservedTop = reservedLayout.obstructionInsets.top;
      final reservedBottom = reservedLayout.obstructionInsets.bottom;
      final headerRect = tester.getRect(find.byType(MateoSheetViewHeader));
      final footerRect = tester.getRect(find.byType(MateoSheetViewFooter));
      final scrollController = scrollable
          ? tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller
          : null;
      scrollController?.jumpTo(40);
      await tester.pump();

      reserveHeaderSpace.value = false;
      await tester.pumpAndSettle();

      final unreservedLayout = tester.widget<MateoViewLayoutScope>(find.byType(MateoViewLayoutScope));
      expect(reservedTop, greaterThan(unreservedLayout.padding.top));
      expect(unreservedLayout.obstructionInsets.top, unreservedLayout.padding.top);
      expect(unreservedLayout.obstructionInsets.bottom, reservedBottom);
      expect(tester.getRect(find.byType(MateoSheetViewHeader)), headerRect);
      expect(tester.getRect(find.byType(MateoSheetViewFooter)), footerRect);
      if (scrollController == null) {
        expect(
          tester.getTopLeft(find.byKey(const ValueKey('content'))).dy,
          tester.getTopLeft(find.byType(MateoSheetViewSurface)).dy + unreservedLayout.padding.top,
        );
      } else {
        expect(tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller, same(scrollController));
        expect(scrollController.offset, 40);
      }
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    }
  });

  testWidgets('when header space is not reserved, a fitted sheet should size as though the header were absent', (
    tester,
  ) async {
    await host(tester);

    Future<double> sheetHeight({required bool includeHeader, required bool reserveHeaderSpace}) async {
      unawaited(
        showMateoSheet<void>(
          context: launcher,
          view: MateoSheetView(
            reserveHeaderSpace: reserveHeaderSpace,
            header: includeHeader ? const MateoSheetViewHeader(principal: SizedBox(height: 40)) : null,
            surface: const MateoSheetViewSurface(child: SizedBox(height: 80)),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final height = tester.getSize(find.byType(MateoSheetView)).height;
      Navigator.of(tester.element(find.byType(MateoSheetView))).pop();
      await tester.pumpAndSettle();
      return height;
    }

    final reserved = await sheetHeight(includeHeader: true, reserveHeaderSpace: true);
    final unreserved = await sheetHeight(includeHeader: true, reserveHeaderSpace: false);
    final headerless = await sheetHeight(includeHeader: false, reserveHeaderSpace: true);
    expect(reserved, greaterThan(unreserved));
    expect(unreserved, headerless);
  });

  testWidgets('when header space is not reserved, a top fade should retain the header protection depth', (
    tester,
  ) async {
    final reserveHeaderSpace = ValueNotifier(true);
    addTearDown(reserveHeaderSpace.dispose);
    await tester.pumpWidget(
      MateoApp(
        theme: surfaceTransformTheme,
        home: SizedBox(
          width: 320,
          height: 400,
          child: ValueListenableBuilder<bool>(
            valueListenable: reserveHeaderSpace,
            builder: (context, reserveHeaderSpace, child) => MateoSheetView(
              reserveHeaderSpace: reserveHeaderSpace,
              header: const MateoSheetViewHeader(principal: SizedBox(height: 40)),
              surface: MateoSheetViewSurface.scrollable(
                edgeEffect: .fade(at: [.top]),
                child: const SizedBox(height: 800),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final fadeFinder = find.byType(BaseMateoEdgeFade);
    final reservedBand = tester.widget<BaseMateoEdgeFade>(fadeFinder).resolveBands(tester.getSize(fadeFinder)).single;

    reserveHeaderSpace.value = false;
    await tester.pumpAndSettle();

    final unreservedBand = tester.widget<BaseMateoEdgeFade>(fadeFinder).resolveBands(tester.getSize(fadeFinder)).single;
    expect(unreservedBand.extent, reservedBand.extent);
    expect(unreservedBand.profile, same(reservedBand.profile));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'when sheet content specifies color alignment and fades, it should adapt to both fixed slots while scrolling',
    (tester) async {
      await host(tester);
      final color = surfaceTransformTheme.colorScheme.background;
      unawaited(
        showMateoSheet<void>(
          context: launcher,
          view: MateoSheetView(
            header: const MateoSheetViewHeader(principal: Text('Header')),
            footer: const MateoSheetViewFooter(principal: Text('Footer')),
            surface: MateoSheetViewSurface.scrollable(
              color: color,
              alignment: .topCenter,
              edgeEffect: .fade(at: const [.top, .bottom]),
              child: const SizedBox(height: 1600, child: Text('Content')),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final surface = tester.widget<BaseMateoSurface>(find.byType(BaseMateoSurface));
      expect(surface.color, color);
      expect(surface.alignment, Alignment.topCenter);
      final fade = tester.widget<BaseMateoEdgeFade>(find.byType(BaseMateoEdgeFade));
      final size = tester.getSize(find.byType(MateoSheetViewSurface));
      final initial = fade.resolveBands(size);
      expect(initial.length, 2);
      expect(initial.every((band) => band.extent > 0), isTrue);
      final scroll = tester.state<ScrollableState>(find.byType(Scrollable));
      scroll.position.jumpTo(100);
      await tester.pump();
      final scrolled = tester.widget<BaseMateoEdgeFade>(find.byType(BaseMateoEdgeFade)).resolveBands(size);
      expect(scrolled.first.extent, greaterThan(initial.first.extent));
      expect(scrolled.last.extent, initial.last.extent);
      expect(tester.takeException(), isNull);
    },
  );
}
