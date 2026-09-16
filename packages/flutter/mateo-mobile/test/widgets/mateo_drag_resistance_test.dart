import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/content_paint_counter.dart';

const ValueKey<String> _childKey = ValueKey('content');
const _child = SizedBox(key: _childKey, width: 120, height: 80);

Widget _app(Widget child, {bool reduced = false}) => Directionality(
  textDirection: .ltr,
  child: MediaQuery(
    data: MediaQueryData(disableAnimations: reduced),
    child: Center(child: child),
  ),
);

Offset _position(WidgetTester tester) => tester.getTopLeft(find.byKey(_childKey));

void main() {
  test('when configuring physical limits, it should provide validated value equality', () {
    expect(
      const MateoDragResistanceConfig.all(6),
      const MateoDragResistanceConfig.symmetric(vertical: 6, horizontal: 6),
    );
    expect(const MateoDragResistanceConfig.only(top: 4).bottom, 0);
    // Exercise the zero defaults of the constructor itself.
    // ignore: use_named_constants
    expect(MateoDragResistanceConfig.zero, const MateoDragResistanceConfig.only());
    expect(const MateoDragResistanceConfig.all(6).hashCode, const MateoDragResistanceConfig.all(6).hashCode);
    for (final value in [-1.0, double.nan, double.infinity, double.negativeInfinity]) {
      expect(() => MateoDragResistanceConfig.all(value), throwsAssertionError);
      expect(() => MateoDragResistanceConfig.symmetric(vertical: value), throwsAssertionError);
      expect(() => MateoDragResistanceConfig.symmetric(horizontal: value), throwsAssertionError);
      expect(() => MateoDragResistanceConfig.only(top: value), throwsAssertionError);
      expect(() => MateoDragResistanceConfig.only(right: value), throwsAssertionError);
      expect(() => MateoDragResistanceConfig.only(bottom: value), throwsAssertionError);
      expect(() => MateoDragResistanceConfig.only(left: value), throwsAssertionError);
    }
  });

  testWidgets('when dragging in asymmetric directions, it should resist total travel with the authored curve', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(const MateoDragResistance(resistance: .only(top: 8, right: 6, left: 4), child: _child)),
    );
    final origin = _position(tester);
    final gesture = await tester.startGesture(tester.getCenter(find.byKey(_childKey)));
    var previous = 0.0;
    for (final sample in <double, double>{24: 1.2, 48: 2, 96: 3, 192: 4, 384: 4.8}.entries) {
      await gesture.moveBy(Offset(sample.key - previous, 0));
      await tester.pump();
      expect((_position(tester) - origin).dx, closeTo(sample.value, 1e-8));
      previous = sample.key;
    }
    await gesture.moveBy(const Offset(-480, -96));
    await tester.pump();
    expect(_position(tester) - origin, const Offset(-2, -4));
    await gesture.moveBy(const Offset(96, 192));
    await tester.pump();
    expect(_position(tester), origin);
    await gesture.moveBy(const Offset(100000, 0));
    await tester.pump();
    expect((_position(tester) - origin).dx, allOf(greaterThan(5.99), lessThan(6)));
    await gesture.cancel();
    await tester.pumpAndSettle();
  });

  for (final cancel in [false, true]) {
    testWidgets('when a pointer ends with cancel=$cancel, it should settle with the authored curve', (tester) async {
      await tester.pumpWidget(_app(const MateoDragResistance(child: _child)));
      final origin = _position(tester);
      final gesture = await tester.startGesture(tester.getCenter(find.byKey(_childKey)));
      await gesture.moveBy(const Offset(96, 0));
      await tester.pump();
      if (cancel) {
        await gesture.cancel();
      } else {
        await gesture.up();
      }
      await tester.pump();
      expect((_position(tester) - origin).dx, 3);
      await tester.pump(const Duration(milliseconds: 90));
      expect((_position(tester) - origin).dx, closeTo(0.2851984041612381, 1e-8));
      await tester.pump(const Duration(milliseconds: 90));
      expect(_position(tester), origin);
    });
  }

  for (final direction in <String, Offset>{
    'up': const Offset(0, -96),
    'right': const Offset(96, 0),
    'down': const Offset(0, 96),
    'left': const Offset(-96, 0),
    'diagonally': const Offset(96, -96),
  }.entries) {
    testWidgets('when returning ${direction.key}, it should land smoothly without overshoot or a late acceleration', (
      tester,
    ) async {
      Future<void> pump(Offset? offset) =>
          tester.pumpWidget(_app(MateoDragResistance.driven(dragOffset: offset, child: _child)));
      await pump(.zero);
      final origin = _position(tester);
      await pump(direction.value);
      final released = _position(tester) - origin;
      await pump(null);
      var previous = 1.0;
      var previousStep = 1.0;
      for (var ms = 1; ms <= 180; ms++) {
        await tester.pump(const Duration(milliseconds: 1));
        final offset = _position(tester) - origin;
        final remaining = released.dx != 0 ? offset.dx / released.dx : offset.dy / released.dy;
        expect(remaining, inInclusiveRange(0.0, previous + 1e-12));
        if (released.dx != 0 && released.dy != 0) {
          expect(offset.dx / released.dx, closeTo(offset.dy / released.dy, 1e-10));
        }
        final step = previous - remaining;
        if (ms >= 25) expect(step, lessThanOrEqualTo(previousStep + 1e-12));
        if (ms == 108) expect(remaining, closeTo(0.05, 1e-10));
        if (ms == 150) expect(remaining, closeTo(0.0054854663545539, 1e-10));
        if (ms == 179) expect(remaining, lessThan(0.00000002));
        previous = remaining;
        previousStep = step;
      }
      expect(_position(tester), origin);
      await tester.pump(const Duration(milliseconds: 60));
      expect(_position(tester), origin);
    });
  }

  testWidgets('when re-grabbed during return, it should preserve its position and ignore other pointers', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const MateoDragResistance(child: _child)));
    final origin = _position(tester);
    final first = await tester.startGesture(tester.getCenter(find.byKey(_childKey)), pointer: 1);
    final second = await tester.startGesture(tester.getCenter(find.byKey(_childKey)), pointer: 2);
    await first.moveBy(const Offset(96, 0));
    await second.moveBy(const Offset(-96, 0));
    await second.up();
    await tester.pump();
    expect((_position(tester) - origin).dx, 3);
    await first.up();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));
    final grabbed = _position(tester);
    final next = await tester.startGesture(tester.getCenter(find.byKey(_childKey)), pointer: 3);
    await tester.pump(const Duration(milliseconds: 60));
    expect(_position(tester), grabbed);
    await next.moveBy(const Offset(1, 0));
    await tester.pump();
    expect(_position(tester).dx, greaterThan(grabbed.dx));
    expect(_position(tester).dx - grabbed.dx, lessThan(0.1));
    await next.cancel();
    await tester.pumpAndSettle();
    expect(_position(tester), origin);
  });

  testWidgets('when driven offsets change, it should track zero immediately and settle on null', (tester) async {
    Future<void> pump(Offset? offset) =>
        tester.pumpWidget(_app(MateoDragResistance.driven(dragOffset: offset, child: _child)));
    await pump(.zero);
    final origin = _position(tester);
    expect(find.byType(Listener), findsNothing);
    await pump(const Offset(96, -96));
    expect(_position(tester) - origin, const Offset(3, -3));
    await pump(.zero);
    expect(_position(tester), origin);
    await pump(const Offset(96, 0));
    await pump(null);
    expect((_position(tester) - origin).dx, 3);
    await tester.pump(const Duration(milliseconds: 60));
    expect((_position(tester) - origin).dx, allOf(greaterThan(0), lessThan(3)));
    await pump(const Offset(-96, 0));
    expect((_position(tester) - origin).dx, -3);
    await tester.pump(const Duration(milliseconds: 180));
    expect((_position(tester) - origin).dx, -3);
    await pump(null);
    await tester.pumpAndSettle();
    expect(_position(tester), origin);
  });

  testWidgets('when limits change, it should recalculate dragging and bound the return', (tester) async {
    Future<void> pump(MateoDragResistanceConfig resistance) =>
        tester.pumpWidget(_app(MateoDragResistance(resistance: resistance, child: _child)));
    await pump(const .all(6));
    final origin = _position(tester);
    final gesture = await tester.startGesture(tester.getCenter(find.byKey(_childKey)));
    await gesture.moveBy(const Offset(96, 0));
    await pump(const .all(8));
    expect((_position(tester) - origin).dx, 4);
    await gesture.up();
    await tester.pump();
    await pump(const .all(2));
    expect((_position(tester) - origin).dx, 2);
    await tester.pump(const Duration(milliseconds: 60));
    expect((_position(tester) - origin).dx, allOf(greaterThan(0), lessThan(2)));
    await pump(const .all(8));
    await tester.pumpAndSettle();
    expect(_position(tester), origin);
  });

  for (final driven in [false, true]) {
    testWidgets('when disabled or reducing motion in driven=$driven, it should preserve child state', (tester) async {
      final key = GlobalKey();
      final child = StatefulBuilder(key: key, builder: (context, setState) => const SizedBox(width: 120, height: 80));
      Future<void> pump({bool reduced = false, MateoDragResistanceConfig resistance = const .all(6)}) =>
          tester.pumpWidget(
            _app(
              driven
                  ? MateoDragResistance.driven(resistance: resistance, dragOffset: const Offset(96, 0), child: child)
                  : MateoDragResistance(resistance: resistance, child: child),
              reduced: reduced,
            ),
          );
      await pump();
      final element = key.currentContext;
      final renderObject = key.currentContext!.findRenderObject();
      final gesture = await tester.startGesture(tester.getCenter(find.byKey(key)));
      await gesture.moveBy(const Offset(96, 0));
      await tester.pump();
      await pump(reduced: true);
      expect(key.currentContext, same(element));
      expect(key.currentContext!.findRenderObject(), same(renderObject));
      expect(tester.getTopLeft(find.byKey(key)), const Offset(340, 260));
      await gesture.up();
      await pump(resistance: .zero);
      expect(key.currentContext, same(element));
      expect(tester.getTopLeft(find.byKey(key)), const Offset(340, 260));
      await pump();
      expect(key.currentContext, same(element));
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('when translated, it should preserve layout and paint while moving hit tests and semantics', (
    tester,
  ) async {
    final painter = ContentPaintCounter();
    var layouts = 0;
    var taps = 0;
    final semantics = tester.ensureSemantics();
    final child = LayoutBuilder(
      builder: (context, constraints) {
        layouts++;
        return GestureDetector(
          onTap: () => taps++,
          child: Semantics(
            label: 'Resisted content',
            child: CustomPaint(key: _childKey, size: const Size(120, 80), painter: painter),
          ),
        );
      },
    );
    Future<void> pump(Offset? offset) =>
        tester.pumpWidget(_app(MateoDragResistance.driven(dragOffset: offset, child: child)));
    await pump(.zero);
    final origin = _position(tester);
    final initialPaints = painter.paints;
    final initialLayouts = layouts;
    await pump(const Offset(96, 0));
    expect(painter.paints, initialPaints);
    expect(layouts, initialLayouts);
    expect(_position(tester) - origin, const Offset(3, 0));
    final box = tester.renderObject<RenderBox>(find.byKey(_childKey));
    expect(box.globalToLocal(origin + const Offset(3, 0)), Offset.zero);
    await tester.tapAt(origin + const Offset(122, 40));
    expect(taps, 1);
    final node = tester.getSemantics(find.byKey(_childKey));
    final transforms = <Matrix4>[];
    SemanticsNode? current = node;
    while (current != null) {
      if (current.transform != null) transforms.add(current.transform!);
      current = current.parent;
    }
    final combined = Matrix4.identity();
    transforms.reversed.forEach(combined.multiply);
    expect(
      MatrixUtils.transformPoint(combined, .zero).dx,
      closeTo((origin.dx + 3) * tester.view.devicePixelRatio, 1e-8),
    );
    await pump(null);
    await tester.pumpAndSettle();
    expect(painter.paints, initialPaints);
    expect(layouts, initialLayouts);
    semantics.dispose();
  });

  testWidgets('when driven offsets are non-finite, it should reject them even while disabled', (tester) async {
    await tester.pumpWidget(_app(const MateoDragResistance.driven(dragOffset: null, resistance: .zero, child: _child)));
    await tester.pumpWidget(
      _app(const MateoDragResistance.driven(dragOffset: Offset(double.nan, 0), resistance: .zero, child: _child)),
    );
    expect(tester.takeException(), isAssertionError);
  });

  testWidgets('when reduced motion starts during return, it should clear translation and preserve content', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const MateoDragResistance.driven(dragOffset: Offset(96, 0), child: _child)));
    final element = tester.element(find.byKey(_childKey));
    await tester.pumpWidget(_app(const MateoDragResistance.driven(dragOffset: null, child: _child)));
    await tester.pump(const Duration(milliseconds: 60));
    await tester.pumpWidget(_app(const MateoDragResistance.driven(dragOffset: null, child: _child), reduced: true));
    expect(tester.element(find.byKey(_childKey)), same(element));
    expect(_position(tester), const Offset(340, 260));
    await tester.pumpAndSettle();
    expect(_position(tester), const Offset(340, 260));
  });

  testWidgets('when observing pointers automatically, it should preserve child taps and drag callbacks', (
    tester,
  ) async {
    var taps = 0;
    var dragged = 0.0;
    await tester.pumpWidget(
      _app(
        MateoDragResistance(
          resistance: const .symmetric(horizontal: 6),
          child: GestureDetector(
            onTap: () => taps++,
            onHorizontalDragUpdate: (details) => dragged += details.delta.dx,
            behavior: .opaque,
            child: _child,
          ),
        ),
      ),
    );
    await tester.tap(find.byType(GestureDetector));
    expect(taps, 1);
    final origin = _position(tester);
    final gesture = await tester.startGesture(tester.getCenter(find.byKey(_childKey)));
    await gesture.moveBy(const Offset(1, 0));
    await tester.pump();
    expect(_position(tester).dx, greaterThan(origin.dx));
    await gesture.moveBy(const Offset(40, 0));
    await gesture.moveBy(const Offset(40, 0));
    await tester.pump();
    expect(dragged, greaterThan(0));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(_position(tester), origin);
    expect(taps, 1);
  });

  testWidgets('when disposed during return, it should remove animation resources', (tester) async {
    await tester.pumpWidget(_app(const MateoDragResistance.driven(dragOffset: Offset(96, 0), child: _child)));
    await tester.pumpWidget(_app(const MateoDragResistance.driven(dragOffset: null, child: _child)));
    await tester.pump(const Duration(milliseconds: 30));
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
