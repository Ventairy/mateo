import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/base_mateo_surface.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/mateo_surface_scope.dart';
import 'package:mateo_mobile/src/bases/base_mateo_view/base_mateo_view.dart';
import 'package:mateo_mobile/src/bases/base_mateo_view/mateo_view_scope.dart';

import '../fixtures/surface_transform_test_widgets.dart';

void main() {
  Widget host(Widget child) => MateoApp(theme: surfaceTransformTheme, home: child);

  testWidgets('when view padding is inherited or explicit, it should coordinate all slots in either direction', (
    tester,
  ) async {
    for (final direction in TextDirection.values) {
      for (final explicit in [null, const EdgeInsets.all(8)]) {
        await tester.pumpWidget(
          host(
            Directionality(
              textDirection: direction,
              child: MateoViewScope(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 20, 30, 40),
                child: MateoView(
                  padding: explicit,
                  header: const MateoViewHeader(principal: SizedBox(height: 10)),
                  footer: const MateoViewFooter(principal: SizedBox(height: 10)),
                  surface: const MateoViewSurface(child: SizedBox.expand()),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final padding = explicit ?? const EdgeInsetsDirectional.fromSTEB(10, 20, 30, 40).resolve(direction);
        final layout = tester.widget<MateoViewLayoutScope>(find.byType(MateoViewLayoutScope));
        expect(layout.padding, padding);
        final surface = tester.widget<BaseMateoSurface>(find.byType(BaseMateoSurface));
        expect(surface.padding, padding.copyWith(top: 20, bottom: 20));
        for (final slot in [MateoViewHeader, MateoViewFooter]) {
          final inset = tester.widget<Padding>(
            find.descendant(of: find.byType(slot), matching: find.byType(Padding)).first,
          );
          expect(inset.padding, slot == MateoViewHeader ? padding.copyWith(bottom: 0) : padding.copyWith(top: 0));
        }
      }
    }
  });

  testWidgets('when scope padding changes, it should retain scroll state and isolate nested view defaults', (
    tester,
  ) async {
    final padding = ValueNotifier<EdgeInsetsGeometry>(const EdgeInsets.all(24));
    addTearDown(padding.dispose);
    await tester.pumpWidget(
      host(
        ValueListenableBuilder<EdgeInsetsGeometry>(
          valueListenable: padding,
          builder: (context, value, child) => MateoViewScope(padding: value, child: child!),
          child: const MateoView(
            surface: MateoViewSurface.scrollable(
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: MateoView(surface: MateoViewSurface(child: Text('Nested'))),
                  ),
                  SizedBox(height: 1600),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final scroll = tester.state<ScrollableState>(find.byType(Scrollable));
    scroll.position.jumpTo(100);
    final nested = tester.element(find.text('Nested'));
    padding.value = const EdgeInsets.all(32);
    await tester.pumpAndSettle();
    expect(tester.state<ScrollableState>(find.byType(Scrollable)), same(scroll));
    expect(scroll.position.pixels, 100);
    expect(tester.element(find.text('Nested')), same(nested));
    final layouts = tester.widgetList<MateoViewLayoutScope>(find.byType(MateoViewLayoutScope)).toList();
    expect(layouts.first.padding, const EdgeInsets.all(32));
    expect(layouts.last.padding, const EdgeInsets.symmetric(horizontal: 20, vertical: 12));
  });

  testWidgets('when a surface has explicit styling, it should override scoped defaults and reset them for content', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        const MateoSurfaceScope(
          shape: MateoRoundedShapeBorder(radius: 40),
          animation: .pop(),
          child: MateoView(
            surface: MateoViewSurface(
              shape: .rounded(radius: 8),
              animation: .none(),
              padding: EdgeInsets.all(6),
              child: MateoSurface(child: Text('Nested')),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final surfaces = tester.widgetList<BaseMateoSurface>(find.byType(BaseMateoSurface)).toList();
    expect(surfaces.first.shape, const MateoRoundedShapeBorder(radius: 8));
    expect(surfaces.first.animation, const MateoSurfaceAnimation.none());
    expect(surfaces.first.padding, const EdgeInsets.all(6));
    expect(surfaces.last.shape, const MateoRoundedShapeBorder(radius: 0));
    expect(surfaces.last.animation, const MateoSurfaceAnimation.none());
  });
}
