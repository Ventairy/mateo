import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  for (final view in [false, true]) {
    for (final scrollable in [false, true]) {
      testWidgets(
        'when rounded ${view ? 'view' : 'ordinary'} surfaces ${scrollable ? 'scroll' : 'resize'}, it should update clipping and hit testing',
        (tester) async {
          for (final (size, radius) in [
            (const Size(96, 96), 24.0),
            (const Size(180, 120), 32.0),
            (const Size(96, 96), 0.0),
          ]) {
            var taps = 0;
            final content = GestureDetector(
              behavior: .opaque,
              onTap: () => taps++,
              child: SizedBox(width: size.width, height: size.height),
            );
            final Widget surface;
            if (view) {
              surface = MateoView(
                padding: .zero,
                surface: scrollable
                    ? MateoViewSurface.scrollable(
                        color: const Color(0xFF123456),
                        shape: .rounded(radius: radius),
                        child: content,
                      )
                    : MateoViewSurface(
                        color: const Color(0xFF123456),
                        shape: .rounded(radius: radius),
                        child: content,
                      ),
              );
            } else {
              surface = scrollable
                  ? MateoSurface.scrollable(
                      color: const Color(0xFF123456),
                      shape: .rounded(radius: radius),
                      child: content,
                    )
                  : MateoSurface(
                      color: const Color(0xFF123456),
                      shape: .rounded(radius: radius),
                      child: content,
                    );
            }
            await tester.pumpWidget(
              Directionality(
                textDirection: .ltr,
                child: Center(
                  child: SizedBox(width: size.width, height: size.height, child: surface),
                ),
              ),
            );
            await tester.pumpAndSettle();
            final clipFinder = radius == 0 ? find.byType(ClipRect).first : find.byType(ClipPath).first;
            if (radius != 0) {
              final clip = tester.widget<ClipPath>(clipFinder);
              expect((clip.clipper! as ShapeBorderClipper).shape, MateoRoundedShapeBorder(radius: radius));
            }
            final origin = tester.getTopLeft(clipFinder);
            await tester.tapAt(origin + const Offset(1, 1));
            expect(taps, radius == 0 ? 1 : 0);
            await tester.tapAt(origin + size.center(Offset.zero));
            expect(taps, radius == 0 ? 2 : 1);
            expect(tester.takeException(), isNull);
          }
        },
      );
    }
  }
}
