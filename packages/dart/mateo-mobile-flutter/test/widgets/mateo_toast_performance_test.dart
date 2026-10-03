import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  testWidgets('toast motion keeps the fade widget and page paint stable', (tester) async {
    BuildContext? toastContext;
    var backgroundPaints = 0;
    await tester.pumpWidget(
      MateoApp(
        theme: MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white),
        home: Builder(
          builder: (context) {
            toastContext = context;
            return SizedBox.expand(child: CustomPaint(painter: _CountingPainter(() => backgroundPaints++)));
          },
        ),
      ),
    );
    final initialBackgroundPaints = backgroundPaints;
    showMateoToast(
      context: toastContext!,
      toast: const MateoToast(message: 'Changes saved', status: .success),
      duration: const .untilDismissed(),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final toast = find.byType(MateoToast);
    final fade = find.ancestor(of: toast, matching: find.byType(FadeTransition)).first;
    final fadeWidget = tester.widget<FadeTransition>(fade);
    for (var frame = 0; frame < 5; frame++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(identical(tester.widget<FadeTransition>(fade), fadeWidget), isTrue);
    expect(backgroundPaints, initialBackgroundPaints);
    await tester.pumpWidget(const SizedBox());
  });
}

class _CountingPainter extends CustomPainter {
  _CountingPainter(this.onPaint);

  final VoidCallback onPaint;

  @override
  void paint(Canvas canvas, Size size) => onPaint();

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
