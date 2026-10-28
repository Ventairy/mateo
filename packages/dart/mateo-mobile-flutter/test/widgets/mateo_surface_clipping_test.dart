import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  final palette = MateoPalette();
  final theme = MateoThemeData.light(accentColor: palette.green[9], onAccent: palette.white);
  const captureKey = ValueKey('surface_clipping_capture');

  Widget host(MateoSurface surface) => Directionality(
    textDirection: .ltr,
    child: MateoTheme(
      data: theme,
      child: Center(
        child: RepaintBoundary(
          key: captureKey,
          child: SizedBox.square(
            dimension: 160,
            child: ColoredBox(
              color: theme.colorScheme.background,
              child: Center(child: surface),
            ),
          ),
        ),
      ),
    ),
  );

  Future<Color> readPixel(WidgetTester tester, {Offset point = const Offset(80, 25)}) async {
    final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(captureKey));
    final pixel = await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 1);
      final data = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
      image.dispose();
      final offset = (point.dy.toInt() * 160 + point.dx.toInt()) * 4;
      return Color.fromARGB(
        data.getUint8(offset + 3),
        data.getUint8(offset),
        data.getUint8(offset + 1),
        data.getUint8(offset + 2),
      );
    });
    return pixel!;
  }

  for (final scrollable in [false, true]) {
    for (final shape in [const MateoShape.none(), const MateoShape.rounded(radius: 24)]) {
      MateoSurface surface({required Widget child, Clip? clipBehavior}) => scrollable
          ? MateoSurface.scrollable(
              width: const .custom(80),
              height: const .custom(80),
              shape: shape,
              clipBehavior: clipBehavior,
              child: child,
            )
          : MateoSurface(
              width: const .custom(80),
              height: const .custom(80),
              shape: shape,
              clipBehavior: clipBehavior,
              child: child,
            );

      for (final clipBehavior in [null, Clip.none]) {
        testWidgets('scrollable $scrollable, shape $shape, clipping $clipBehavior controls visible overflow', (
          tester,
        ) async {
          await tester.pumpWidget(
            host(
              surface(
                clipBehavior: clipBehavior,
                child: Transform.translate(
                  offset: const Offset(0, -30),
                  child: SizedBox.square(dimension: 80, child: ColoredBox(color: theme.colorScheme.accent)),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(
            (await readPixel(tester)).toARGB32(),
            (clipBehavior == Clip.none ? theme.colorScheme.accent : theme.colorScheme.background).toARGB32(),
          );
        });
      }

      testWidgets(
        'changing clipping retains child state and scroll position for scrollable $scrollable and shape $shape',
        (tester) async {
          late StateSetter rebuild;
          Clip? clipping;
          const childKey = ValueKey('surface_clipping_stateful_child');
          await tester.pumpWidget(
            StatefulBuilder(
              builder: (context, setState) {
                rebuild = setState;
                return host(
                  surface(
                    clipBehavior: clipping,
                    child: StatefulBuilder(
                      key: childKey,
                      builder: (context, setState) => const SizedBox(width: 80, height: 600),
                    ),
                  ),
                );
              },
            ),
          );
          final childState = tester.state(find.byKey(childKey));
          final scrollController = scrollable
              ? tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!
              : null;
          scrollController?.jumpTo(40);
          for (final nextClip in [Clip.none, Clip.hardEdge, Clip.antiAlias, Clip.antiAliasWithSaveLayer, null]) {
            rebuild(() => clipping = nextClip);
            await tester.pumpAndSettle();
            expect(
              {
                'state': tester.state(find.byKey(childKey)),
                'offset': scrollController?.offset,
                'controller': scrollable
                    ? tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller
                    : null,
              },
              {'state': same(childState), 'offset': scrollable ? 40.0 : null, 'controller': same(scrollController)},
            );
          }
        },
      );
    }
  }

  testWidgets('disabling content clipping keeps the background shaped', (tester) async {
    await tester.pumpWidget(
      host(
        MateoSurface(
          width: const .custom(80),
          height: const .custom(80),
          shape: const .capsule(),
          clipBehavior: .none,
          color: theme.colorScheme.accent,
          child: const SizedBox.shrink(),
        ),
      ),
    );
    expect(
      (
        corner: (await readPixel(tester, point: const Offset(41, 41))).toARGB32(),
        center: (await readPixel(tester, point: const Offset(80, 80))).toARGB32(),
      ),
      (corner: theme.colorScheme.background.toARGB32(), center: theme.colorScheme.accent.toARGB32()),
    );
  });

  testWidgets('omitted clipping preserves rectangular and shaped defaults', (tester) async {
    final defaults = <Clip>[];
    for (final shape in [const MateoShape.none(), const MateoShape.rounded(radius: 24)]) {
      await tester.pumpWidget(host(MateoSurface(shape: shape, child: const SizedBox.square(dimension: 80))));
      if (shape == const MateoShape.none()) {
        defaults.add(tester.widget<ClipRect>(find.byType(ClipRect).first).clipBehavior);
      } else {
        defaults.add(tester.widget<ClipPath>(find.byType(ClipPath).first).clipBehavior);
      }
    }
    expect(defaults, [Clip.hardEdge, Clip.antiAlias]);
  });
}
