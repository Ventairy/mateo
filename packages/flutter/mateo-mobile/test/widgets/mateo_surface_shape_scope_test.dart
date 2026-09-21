import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/mateo_surface_scope.dart';

import '../fixtures/surface_transform_test_widgets.dart';

void main() {
  testWidgets('when scoped shapes change, it should notify dependents and use only the closest scope', (tester) async {
    final values = <MateoRoundedShapeBorder?>[];
    final child = Builder(
      builder: (context) {
        values.add(MateoSurfaceScope.of(context).shape);
        return const SizedBox();
      },
    );
    await tester.pumpWidget(child);
    for (final shape in [const MateoRoundedShapeBorder(radius: 44), const MateoRoundedShapeBorder(radius: 44), null]) {
      await tester.pumpWidget(MateoSurfaceScope(shape: shape, child: child));
    }
    expect(values, [null, const MateoRoundedShapeBorder(radius: 44), null]);
    await tester.pumpWidget(
      MateoSurfaceScope(
        shape: const MateoRoundedShapeBorder(radius: 44),
        child: MateoSurfaceScope(child: child),
      ),
    );
    expect(values.last, isNull);
  });

  for (final viewSurface in [false, true]) {
    for (final scrollable in [false, true]) {
      testWidgets(
        'when ${scrollable ? 'scrollable' : 'ordinary'} ${viewSurface ? 'view' : 'standalone'} surface shapes are resolved, it should clip and preserve content state',
        (tester) async {
          final contentKey = GlobalKey();
          Element? previous;
          for (final configuration in <(MateoRoundedShapeBorder?, MateoShape?, double)>[
            (null, null, 0),
            (const MateoRoundedShapeBorder(radius: 44), null, 44),
            (const MateoRoundedShapeBorder(radius: 44), const .none(), 0),
            (const MateoRoundedShapeBorder(radius: 44), const .rounded(radius: 12), 12),
          ]) {
            var taps = 0;
            final child = StatefulBuilder(
              key: contentKey,
              builder: (context, setState) {
                expect(MateoSurfaceScope.of(context).shape, isNull);
                return GestureDetector(
                  behavior: .opaque,
                  onTap: () => taps++,
                  child: const SizedBox(height: 200, width: double.infinity),
                );
              },
            );
            await tester.pumpWidget(
              MateoTheme(
                data: surfaceTransformTheme,
                child: Directionality(
                  textDirection: .ltr,
                  child: Align(
                    alignment: .topLeft,
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: MateoSurfaceScope(
                        shape: configuration.$1,
                        child: !viewSurface
                            ? (scrollable
                                  ? MateoSurface.scrollable(
                                      shape: configuration.$2 == null
                                          ? null
                                          : MateoShape.rounded(radius: configuration.$3),
                                      child: child,
                                    )
                                  : MateoSurface(
                                      shape: configuration.$2 == null
                                          ? null
                                          : MateoShape.rounded(radius: configuration.$3),
                                      child: child,
                                    ))
                            : MateoView(
                                padding: .zero,
                                surface: scrollable
                                    ? MateoViewSurface.scrollable(shape: configuration.$2, child: child)
                                    : MateoViewSurface(shape: configuration.$2, child: child),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();
            final decoration = tester
                .widgetList<DecoratedBox>(find.byType(DecoratedBox))
                .map((box) => box.decoration)
                .whereType<ShapeDecoration>()
                .single;
            expect(decoration.shape, MateoRoundedShapeBorder(radius: configuration.$3));
            if (configuration.$3 != 0) {
              final clippers = tester
                  .widgetList<ClipPath>(find.byType(ClipPath))
                  .map((clip) => clip.clipper)
                  .whereType<ShapeBorderClipper>();
              expect(clippers.map((clipper) => clipper.shape), everyElement(decoration.shape));
            }
            await tester.tapAt(const Offset(1, 1));
            expect(taps, configuration.$3 == 0 ? 1 : 0);
            await tester.tapAt(const Offset(100, 100));
            expect(taps, configuration.$3 == 0 ? 2 : 1);
            if (previous != null) expect(contentKey.currentContext, same(previous));
            previous = contentKey.currentContext! as Element;
          }
        },
      );
    }
  }
}
