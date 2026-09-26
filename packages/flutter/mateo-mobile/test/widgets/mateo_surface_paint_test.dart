import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

const ValueKey<String> _captureKey = ValueKey('surface paint capture');
const _background = Color(0xFFFFFFFF);
const _firstColor = Color(0xFF123456);
const _nextColor = Color(0xFF654321);

Future<Color> _pixel(WidgetTester tester, Offset position) async => (await tester.runAsync(() async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(_captureKey));
  final image = await boundary.toImage();
  try {
    final pixels = (await image.toByteData(format: .rawRgba))!;
    final index = (position.dy.floor() * image.width + position.dx.floor()) * 4;
    return Color.fromARGB(
      pixels.getUint8(index + 3),
      pixels.getUint8(index),
      pixels.getUint8(index + 1),
      pixels.getUint8(index + 2),
    );
  } finally {
    image.dispose();
  }
}))!;

void main() {
  testWidgets('when a surface moves and resizes, it should keep its fill and shadow at the current bounds', (
    tester,
  ) async {
    final previousDebugShadows = debugDisableShadows;
    debugDisableShadows = false;
    try {
      final theme = MateoThemeData.light(accentColor: _firstColor, onAccent: _background);
      for (final (bounds, color) in [
        (const Rect.fromLTWH(24, 36, 120, 60), _firstColor),
        (const Rect.fromLTWH(120, 90, 120, 60), _firstColor),
        (const Rect.fromLTWH(120, 90, 60, 120), _firstColor),
        (const Rect.fromLTWH(120, 90, 60, 120), _nextColor),
      ]) {
        await tester.pumpWidget(
          Directionality(
            textDirection: .ltr,
            child: MateoTheme(
              data: theme,
              child: Center(
                child: RepaintBoundary(
                  key: _captureKey,
                  child: SizedBox(
                    width: 300,
                    height: 260,
                    child: ColoredBox(
                      color: _background,
                      child: Stack(
                        children: [
                          Positioned.fromRect(
                            rect: bounds,
                            child: MateoSurface(
                              color: color,
                              shape: const .capsule(),
                              elevation: MateoElevation(level: 1),
                              child: const SizedBox.expand(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        expect(await _pixel(tester, bounds.center), color);
        expect(await _pixel(tester, bounds.topLeft + const Offset(1, 1)), isNot(color));
        expect(await _pixel(tester, bounds.bottomCenter + const Offset(0, 4)), isNot(_background));
        expect(await _pixel(tester, const Offset(2, 258)), _background);
      }
    } finally {
      debugDisableShadows = previousDebugShadows;
    }
  });
}
