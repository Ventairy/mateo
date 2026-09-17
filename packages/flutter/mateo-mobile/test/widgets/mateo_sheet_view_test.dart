import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_edge_fade/mateo_edge_fade_painter.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/base_mateo_surface.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/mateo_surface_scope.dart';

import 'package:mateo_mobile/src/bases/base_mateo_view/base_mateo_view.dart';
import 'package:mateo_mobile/src/bases/base_mateo_view/mateo_view_scope.dart';

import '../fixtures/surface_transform_test_widgets.dart';

final Finder _fadeFinder = find.byWidgetPredicate(
  (widget) => widget is CustomPaint && widget.foregroundPainter is MateoEdgeFadePainter,
);
MateoEdgeFadePainter _fade(WidgetTester tester) =>
    tester.widget<CustomPaint>(_fadeFinder).foregroundPainter! as MateoEdgeFadePainter;

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

  testWidgets('when sheet header sides change, principal fills the available region', (tester) async {
    for (final direction in TextDirection.values) {
      for (final sides in [
        (leading: false, trailing: false, start: 0.0, end: 0.0),
        (leading: true, trailing: false, start: 48.0, end: 0.0),
        (leading: false, trailing: true, start: 0.0, end: 88.0),
        (leading: true, trailing: true, start: 88.0, end: 88.0),
      ]) {
        await tester.pumpWidget(
          MateoTheme(
            data: surfaceTransformTheme,
            child: Directionality(
              textDirection: direction,
              child: Center(
                child: SizedBox(
                  width: 320,
                  child: MateoSheetView(
                    header: MateoSheetViewHeader(
                      presentation: .custom(
                        principal: const SizedBox(key: ValueKey('expanding-principal'), width: 10, height: 24),
                        leading: sides.leading ? const SizedBox(width: 32, height: 40) : null,
                        trailing: sides.trailing ? const SizedBox(width: 72, height: 32) : null,
                      ),
                    ),
                    surface: const MateoSheetViewSurface(child: SizedBox(height: 80)),
                  ),
                ),
              ),
            ),
          ),
        );
        final header = tester.getRect(find.byType(MateoSheetViewHeader));
        final principal = tester.getRect(find.byKey(const ValueKey('expanding-principal')));
        expect(principal.width, 280 - sides.start - sides.end);
        expect(principal.left, header.left + 20 + (direction == TextDirection.ltr ? sides.start : sides.end));
        expect(principal.height, 24);
        expect(tester.takeException(), isNull);
      }
    }
  });

  testWidgets('when sheet padding is explicit, it should replace defaults with or without reserved header space', (
    tester,
  ) async {
    for (final scrollable in [false, true]) {
      for (final reserveHeaderSpace in [false, true]) {
        for (final padding in [EdgeInsets.zero, const EdgeInsets.fromLTRB(7, 8, 9, 10)]) {
          await tester.pumpWidget(
            MateoTheme(
              data: surfaceTransformTheme,
              child: Directionality(
                textDirection: .ltr,
                child: MediaQuery(
                  data: const MediaQueryData(size: Size(800, 600)),
                  child: Align(
                    alignment: .topLeft,
                    child: SizedBox(
                      width: 320,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 400),
                        child: MateoSheetView(
                          reserveHeaderSpace: reserveHeaderSpace,
                          header: const MateoSheetViewHeader(presentation: .custom(principal: SizedBox(height: 40))),
                          footer: const MateoSheetViewFooter(principal: SizedBox(height: 30)),
                          surface: scrollable
                              ? MateoSheetViewSurface.scrollable(
                                  padding: padding,
                                  child: const SizedBox(key: ValueKey('padded-content'), height: 800),
                                )
                              : MateoSheetViewSurface(
                                  padding: padding,
                                  child: const SizedBox(key: ValueKey('padded-content'), height: 80),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final surface = tester.getRect(find.byType(MateoSheetViewSurface));
          final header = tester.getRect(find.byType(MateoSheetViewHeader));
          expect(
            tester.getTopLeft(find.byKey(const ValueKey('padded-content'))),
            Offset(surface.left + padding.left, (reserveHeaderSpace ? header.bottom : surface.top) + padding.top),
          );
          if (scrollable) {
            final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!;
            controller.jumpTo(controller.position.maxScrollExtent);
            await tester.pump();
          }
          expect(
            tester.getBottomLeft(find.byKey(const ValueKey('padded-content'))).dy,
            tester.getTopLeft(find.byType(MateoSheetViewFooter)).dy - padding.bottom,
          );
          await tester.pumpWidget(const SizedBox());
        }
      }
    }
  });

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
            header: MateoSheetViewHeader(
              presentation: .custom(principal: MateoSurface(child: Text('Header'))),
            ),
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
        find.descendant(of: find.byType(MateoSheetViewSurface), matching: find.byType(BaseMateoSurface)).first,
      );
      expect(surface.shape, const MateoRoundedShapeBorder(radius: 44));
      expect(surface.padding, const EdgeInsets.all(20));
    },
  );

  testWidgets(
    'when internal scopes surround sheet content, it should retain fixed styling and explicit child styling',
    (tester) async {
      const view = MateoSheetView(
        header: MateoSheetViewHeader(presentation: .custom(principal: Text('Header'))),
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
      expect(surfaces.first.padding, const EdgeInsets.all(20));
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
                  header: const MateoSheetViewHeader(presentation: .custom(principal: SizedBox(height: 40))),
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
      final reservedTop = reservedLayout.obstruction.layoutInsets.top;
      final reservedBottom = reservedLayout.obstruction.layoutInsets.bottom;
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
      expect(unreservedLayout.obstruction.layoutInsets.top, 0);
      expect(unreservedLayout.obstruction.layoutInsets.bottom, reservedBottom);
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
            header: includeHeader
                ? const MateoSheetViewHeader(presentation: .custom(principal: SizedBox(height: 40)))
                : null,
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
              header: const MateoSheetViewHeader(presentation: .custom(principal: SizedBox(height: 40))),
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
    final fadeFinder = _fadeFinder;
    final reservedBand = _fade(tester).resolveBands(tester.getSize(fadeFinder)).single;

    reserveHeaderSpace.value = false;
    await tester.pumpAndSettle();

    final unreservedBand = _fade(tester).resolveBands(tester.getSize(fadeFinder)).single;
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
            header: const MateoSheetViewHeader(presentation: .custom(principal: Text('Header'))),
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
      final fade = _fade(tester);
      final size = tester.getSize(find.byType(MateoSheetViewSurface));
      final initial = fade.resolveBands(size);
      expect(initial.length, 2);
      expect(initial.every((band) => band.extent > 0), isTrue);
      final scroll = tester.state<ScrollableState>(find.byType(Scrollable));
      scroll.position.jumpTo(100);
      await tester.pump();
      final scrolled = _fade(tester).resolveBands(size);
      expect(scrolled.first.extent, greaterThan(initial.first.extent));
      expect(scrolled.last.extent, initial.last.extent);
      expect(tester.takeException(), isNull);
    },
  );
}
