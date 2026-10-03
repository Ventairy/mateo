import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/base_mateo_surface.dart';

import '../fixtures/obstruction_insets_source.dart';
import '../fixtures/surface_transform_test_widgets.dart';

void main() {
  testWidgets('when a retained surface obstruction changes, it should paint current clearance in the same scene', (
    tester,
  ) async {
    final translation = ValueNotifier<double>(0);
    addTearDown(translation.dispose);
    final obstruction = ObstructionInsetsSource(const EdgeInsets.only(top: 20));
    addTearDown(obstruction.dispose);
    final color = surfaceTransformTheme.palette.neutral[10];
    await tester.pumpWidget(
      Directionality(
        textDirection: .ltr,
        child: MateoTheme(
          data: surfaceTransformTheme,
          child: RepaintBoundary(
            key: const ValueKey('capture'),
            child: ValueListenableBuilder<double>(
              valueListenable: translation,
              builder: (_, offset, child) => Transform.translate(offset: Offset(0, offset), child: child),
              child: RepaintBoundary(
                child: BaseMateoSurface(
                  width: const .fill(),
                  height: const .fill(),
                  padding: .zero,
                  obstruction: obstruction,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                        width: double.infinity,
                        child: ColoredBox(color: color),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final errors = <double>[];
    for (final value in [60.0, 100.0, 30.0, 0.0, 45.0]) {
      obstruction.insets.value = EdgeInsets.only(top: value);
      translation.value += 5;
      await tester.pump();
      final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(const ValueKey('capture')));
      await tester.runAsync(() async {
        final image = await boundary.toImage();
        try {
          final bytes = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
          int? top;
          for (var y = 0; y < image.height; y++) {
            final index = (y * image.width + image.width ~/ 2) * 4;
            final rgb = bytes.getUint8(index) << 16 | bytes.getUint8(index + 1) << 8 | bytes.getUint8(index + 2);
            if (rgb == (color.toARGB32() & 0xffffff)) {
              top = y;
              break;
            }
          }
          expect(top, isNotNull);
          errors.add(top! - translation.value - value);
        } finally {
          image.dispose();
        }
      });
    }
    await tester.pumpAndSettle();
    expect(tester.binding.hasScheduledFrame, isFalse);
    await tester.pumpWidget(const SizedBox());
    expect(errors, everyElement(0));
  });
}
