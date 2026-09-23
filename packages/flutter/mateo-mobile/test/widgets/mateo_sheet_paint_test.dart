import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/surface_transform_test_widgets.dart';

class _PaintCounter extends CustomPainter {
  int paints = 0;

  @override
  void paint(Canvas canvas, Size size) {
    paints += 1;
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xff888888));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void main() {
  testWidgets('moving and covering a sheet does not repaint unchanged content', (tester) async {
    late BuildContext launcher;
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

    final painter = _PaintCounter();
    unawaited(
      showMateoSheet<void>(
        context: launcher,
        view: MateoSheetView(
          surface: MateoSheetViewSurface(
            child: CustomPaint(size: const Size(220, 180), painter: painter),
          ),
        ),
      ),
    );
    await tester.pump();
    final firstSheet = find.byType(MateoSheetView).first;
    final initialTop = tester.getTopLeft(firstSheet).dy;
    final initialPaints = painter.paints;
    expect(initialPaints, greaterThan(0));
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pump(const Duration(milliseconds: 16));
    expect(tester.getTopLeft(firstSheet).dy, lessThan(initialTop));
    expect(painter.paints, initialPaints);

    await tester.pumpAndSettle();
    expect(painter.paints, initialPaints);
    unawaited(
      showMateoSheet<void>(
        context: launcher,
        view: const MateoSheetView(
          surface: MateoSheetViewSurface(child: SizedBox(height: 100)),
        ),
      ),
    );
    await tester.pump();
    final paintsBeforeCover = painter.paints;
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pump(const Duration(milliseconds: 16));
    expect(painter.paints, paintsBeforeCover);
    await tester.pumpAndSettle();
    expect(painter.paints, paintsBeforeCover);
  });
}
