import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  Widget host(Widget child, {BoxConstraints constraints = const BoxConstraints(maxWidth: 300, maxHeight: 400)}) =>
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: MateoTheme(
            data: MateoThemeData.light(accentColor: const Color(0xFF123456), onAccent: const Color(0xFFFFFFFF)),
            child: ConstrainedBox(constraints: constraints, child: child),
          ),
        ),
      );

  test('sizing configurations have value equality and validate custom extents', () {
    expect(const MateoSurfaceWidth.fit(), const MateoSurfaceWidth.fit());
    expect(const MateoSurfaceHeight.fill(), const MateoSurfaceHeight.fill());
    expect(const MateoSurfaceWidth.custom(30), const MateoSurfaceWidth.custom(30));
    expect(const MateoSurfaceHeight.custom(30), const MateoSurfaceHeight.custom(30));
    expect(const MateoSurfaceWidth.custom(30), isNot(const MateoSurfaceWidth.custom(31)));
    expect(const MateoSurfaceHeight.fit(), isNot(const MateoSurfaceHeight.fill()));
    expect(const MateoSurfaceWidth.custom(30).hashCode, const MateoSurfaceWidth.custom(30).hashCode);
    expect(const MateoSurfaceHeight.custom(30).hashCode, const MateoSurfaceHeight.custom(30).hashCode);
    for (final value in [-1.0, double.infinity, double.negativeInfinity, double.nan]) {
      expect(() => MateoSurfaceWidth.custom(value), throwsAssertionError);
      expect(() => MateoSurfaceHeight.custom(value), throwsAssertionError);
    }
  });

  test('ordinary and scrollable constructors expose their intended defaults', () {
    const ordinary = MateoSurface(child: SizedBox());
    const scrollable = MateoSurface.scrollable(child: SizedBox());
    expect(ordinary.width, const MateoSurfaceWidth.fit());
    expect(ordinary.height, const MateoSurfaceHeight.fit());
    expect(scrollable.width, const MateoSurfaceWidth.fit());
    expect(scrollable.height, const MateoSurfaceHeight.fill());
  });

  testWidgets('changing dimensions and content size retains content state', (tester) async {
    final contentHeight = ValueNotifier<double>(30);
    addTearDown(contentHeight.dispose);
    Widget surface(MateoSurfaceHeight height) => host(
      MateoSurface(
        width: const .fit(),
        height: height,
        child: ValueListenableBuilder<double>(
          valueListenable: contentHeight,
          builder: (context, value, child) => SizedBox(width: 50, height: value),
        ),
      ),
    );
    await tester.pumpWidget(surface(const .fit()));
    final state = tester.state(find.byType(ValueListenableBuilder<double>));
    contentHeight.value = 70;
    await tester.pump();
    expect(tester.getSize(find.byType(MateoSurface)), const Size(50, 70));
    for (final height in <MateoSurfaceHeight>[const .fill(), const .custom(100), const .fit()]) {
      await tester.pumpWidget(surface(height));
      expect(tester.state(find.byType(ValueListenableBuilder<double>)), same(state));
    }
    expect(tester.getSize(find.byType(MateoSurface)), const Size(50, 70));
  });

  testWidgets('fit includes padding and alignment does not expand either axis', (tester) async {
    await tester.pumpWidget(
      host(
        const MateoSurface(alignment: Alignment.bottomRight, padding: .all(10), child: SizedBox(width: 50, height: 30)),
      ),
    );
    expect(tester.getSize(find.byType(MateoSurface)), const Size(70, 50));
  });

  testWidgets('fill and custom independently size total bounds and obey parent limits', (tester) async {
    for (final entry in <(MateoSurfaceWidth, MateoSurfaceHeight, Size)>[
      (const .fill(), const .fit(), const Size(300, 50)),
      (const .fit(), const .fill(), const Size(70, 400)),
      (const .custom(100), const .custom(90), const Size(100, 90)),
      (const .custom(500), const .custom(600), const Size(300, 400)),
      (const .custom(0), const .custom(0), Size.zero),
    ]) {
      await tester.pumpWidget(
        host(
          MateoSurface(
            width: entry.$1,
            height: entry.$2,
            padding: const .all(10),
            child: const SizedBox(width: 50, height: 30),
          ),
        ),
      );
      expect(tester.getSize(find.byType(MateoSurface)), entry.$3);
    }
    await tester.pumpWidget(
      host(
        const MateoSurface(child: SizedBox(width: 20, height: 10)),
        constraints: const BoxConstraints(minWidth: 100, maxWidth: 300, minHeight: 80, maxHeight: 400),
      ),
    );
    expect(tester.getSize(find.byType(MateoSurface)), const Size(100, 80));
    await tester.pumpWidget(
      host(
        const MateoSurface(width: .custom(10), height: .fit(), child: SizedBox()),
        constraints: const BoxConstraints.tightFor(width: 120, height: 90),
      ),
    );
    expect(tester.getSize(find.byType(MateoSurface)), const Size(120, 90));
    await tester.pumpWidget(host(const MateoSurface(child: SizedBox.expand())));
    expect(tester.getSize(find.byType(MateoSurface)), const Size(300, 400));
  });

  testWidgets('fill reports which unbounded axis needs a finite parent', (tester) async {
    for (final width in [true, false]) {
      final errors = <FlutterErrorDetails>[];
      final previous = FlutterError.onError;
      FlutterError.onError = errors.add;
      try {
        await tester.pumpWidget(
          host(
            UnconstrainedBox(
              child: MateoSurface(
                width: width ? const .fill() : const .fit(),
                height: width ? const .fit() : const .fill(),
                child: const SizedBox(width: 20, height: 10),
              ),
            ),
          ),
        );
      } finally {
        FlutterError.onError = previous;
      }
      expect(
        errors.first.exception,
        isA<FlutterError>().having(
          (error) => error.toString(),
          'message',
          contains('finite parent ${width ? 'width' : 'height'}'),
        ),
      );
      await tester.pumpWidget(const SizedBox());
    }
  });

  testWidgets('scrollable defaults fill height and custom height preserves its controller', (tester) async {
    Widget surface(MateoSurfaceHeight height) => host(
      MateoSurface.scrollable(height: height, child: const SizedBox(width: 80, height: 1000)),
    );
    await tester.pumpWidget(surface(const .fill()));
    expect(tester.getSize(find.byType(MateoSurface)), const Size(300, 400));
    final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!..jumpTo(120);
    final position = controller.position;
    await tester.pumpWidget(surface(const .custom(200)));
    expect(tester.getSize(find.byType(MateoSurface)), const Size(300, 200));
    expect(controller.position, same(position));
    expect(controller.offset, 120);
    await tester.pumpWidget(host(const MateoSurface.scrollable(height: .fit(), child: SizedBox())));
    expect(
      tester.takeException(),
      isA<FlutterError>().having((error) => error.toString(), 'message', contains('do not support height: .fit()')),
    );
  });
}
