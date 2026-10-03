import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/app_test_counter.dart';
import '../fixtures/layout_counter.dart';
import '../fixtures/paint_counter.dart';

List<PictureLayer> _pictures(ContainerLayer container, {Layer? exclude}) {
  final pictures = <PictureLayer>[];
  var child = container.firstChild;
  while (child != null) {
    if (!identical(child, exclude)) {
      if (child is PictureLayer) {
        pictures.add(child);
      } else if (child is ContainerLayer) {
        pictures.addAll(_pictures(child, exclude: exclude));
      }
    }
    child = child.nextSibling;
  }
  return pictures;
}

Future<Color> _paintedColor(WidgetTester tester, Finder capture, Offset position) async =>
    (await tester.runAsync(() async {
      final image = await tester.renderObject<RenderRepaintBoundary>(capture).toImage();
      try {
        final pixels = (await image.toByteData(format: .rawRgba))!;
        final offset = (position.dy.floor() * image.width + position.dx.floor()) * 4;
        return Color.fromARGB(
          pixels.getUint8(offset + 3),
          pixels.getUint8(offset),
          pixels.getUint8(offset + 1),
          pixels.getUint8(offset + 2),
        );
      } finally {
        image.dispose();
      }
    }))!;

void main() {
  testWidgets('when viewport dimensions change without scrolling, retained surfaces should refresh cache eligibility', (
    tester,
  ) async {
    const cardKey = ValueKey<String>('resized viewport surface');
    final viewportExtent = ValueNotifier<double>(200);
    addTearDown(viewportExtent.dispose);
    await tester.pumpWidget(
      Directionality(
        textDirection: .ltr,
        child: Center(
          child: ValueListenableBuilder(
            valueListenable: viewportExtent,
            builder: (_, extent, child) => MateoSurface.scrollable(
              color: const Color(0xFFFFFFFF),
              width: const .custom(200),
              height: .custom(extent),
              child: child!,
            ),
            child: const Column(
              children: [
                SizedBox(height: 500),
                MateoSurface(
                  key: cardKey,
                  color: Color(0xFFFFFFFF),
                  width: .custom(100),
                  height: .custom(40),
                  child: SizedBox.expand(),
                ),
                SizedBox(height: 1200),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!;
    var scrollNotifications = 0;
    controller.addListener(() => scrollNotifications++);
    final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(cardKey));
    final recordings = _pictures(boundary.debugLayer!);
    expect(recordings, isNotEmpty);
    expect(recordings.every((picture) => picture.willChangeHint), isTrue);
    viewportExtent.value = 400;
    await tester.pumpAndSettle();
    expect(tester.renderObject(find.byKey(cardKey)), same(boundary));
    expect(_pictures(boundary.debugLayer!), orderedEquals(recordings));
    expect(recordings.every((picture) => !picture.willChangeHint), isTrue);
    viewportExtent.value = 200;
    await tester.pumpAndSettle();
    expect(recordings.every((picture) => picture.willChangeHint), isTrue);
    expect(controller.offset, 0);
    expect(scrollNotifications, 0);
  });

  testWidgets('when scroll content or viewport length changes, it should preserve child state and scroll position', (
    tester,
  ) async {
    const cardKey = ValueKey<String>('resizing scroll card');
    final dimensions = ValueNotifier((content: 500.0, viewport: 200.0));
    addTearDown(dimensions.dispose);
    await tester.pumpWidget(
      Directionality(
        textDirection: .ltr,
        child: Center(
          child: ValueListenableBuilder(
            valueListenable: dimensions,
            builder: (_, dimensions, child) => MateoSurface.scrollable(
              color: const Color(0xFFFFFFFF),
              width: const .custom(200),
              height: .custom(dimensions.viewport),
              child: Column(
                children: [
                  child!,
                  SizedBox(height: dimensions.content - 80),
                ],
              ),
            ),
            child: const MateoSurface(
              key: cardKey,
              color: Color(0xFFFFFFFF),
              width: .fill(),
              height: .custom(80),
              child: AppTestCounter(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final counterState = tester.state(find.byType(AppTestCounter));
    final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!;
    expect(tester.renderObject(find.byKey(cardKey)).isRepaintBoundary, isFalse);
    await tester.tap(find.text('Count: 0'));
    await tester.pump();
    dimensions.value = (content: 900, viewport: 200);
    await tester.pumpAndSettle();
    expect(tester.renderObject(find.byKey(cardKey)).isRepaintBoundary, isTrue);
    expect(tester.state(find.byType(AppTestCounter)), same(counterState));
    controller.jumpTo(200);
    await tester.pump();
    for (final viewport in [400.0, 200.0]) {
      dimensions.value = (content: 900, viewport: viewport);
      await tester.pumpAndSettle();
      expect(tester.renderObject(find.byKey(cardKey)).isRepaintBoundary, viewport == 200);
      expect(controller.offset, 200);
      expect(tester.state(find.byType(AppTestCounter)), same(counterState));
    }
    dimensions.value = (content: 300, viewport: 200);
    await tester.pumpAndSettle();
    expect(tester.renderObject(find.byKey(cardKey)).isRepaintBoundary, isFalse);
    expect(controller.offset, 100);
    expect(tester.state(find.byType(AppTestCounter)), same(counterState));
    controller.jumpTo(0);
    await tester.pump();
    await tester.tap(find.text('Count: 1'));
    await tester.pump();
    expect(find.text('Count: 2'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('when eager cards leave the viewport, they should release bitmap caches and preserve child policies', (
    tester,
  ) async {
    const cardKey = ValueKey<String>('retained card');
    const independentKey = ValueKey<String>('independent content');
    await tester.pumpWidget(
      Directionality(
        textDirection: .ltr,
        child: Center(
          child: MateoSurface.scrollable(
            color: const Color(0xFFFFFFFF),
            height: const .custom(200),
            width: const .custom(200),
            child: Column(
              children: [
                MateoSurface(
                  key: cardKey,
                  color: const Color(0xFFFFFFFF),
                  child: Column(
                    children: [
                      CustomPaint(
                        willChange: true,
                        painter: PaintCounter(onPaint: () {}, color: const Color(0xFF123456)),
                        child: const SizedBox(width: 40, height: 40),
                      ),
                      const RepaintBoundary(
                        key: independentKey,
                        child: ColoredBox(color: Color(0xFF654321), child: SizedBox(width: 40, height: 40)),
                      ),
                      const ColoredBox(color: Color(0xFFABCDEF), child: SizedBox(width: 40, height: 40)),
                    ],
                  ),
                ),
                const SizedBox(height: 1200),
              ],
            ),
          ),
        ),
      ),
    );
    final card = tester.renderObject<RenderRepaintBoundary>(find.byKey(cardKey)).debugLayer!;
    final independent = tester.renderObject<RenderRepaintBoundary>(find.byKey(independentKey)).debugLayer!;
    final recordings = _pictures(card, exclude: independent);
    // The explicit child splits this card's recording around a composited
    // boundary; the policy must cover both sides and the surface decoration.
    expect(recordings.length, greaterThanOrEqualTo(3));
    final initialHints = {for (final picture in recordings) picture: picture.willChangeHint};
    expect(initialHints.values, containsAll([true, false]));
    final independentPictures = _pictures(independent);
    expect(independentPictures, isNotEmpty);
    expect(independentPictures.every((picture) => !picture.willChangeHint), isTrue);
    final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!..jumpTo(700);
    await tester.pump();
    expect(recordings.every((picture) => picture.willChangeHint), isTrue);
    expect(independentPictures.every((picture) => !picture.willChangeHint), isTrue);
    controller.jumpTo(0);
    await tester.pump();
    for (final entry in initialHints.entries) {
      expect(entry.key.willChangeHint, entry.value);
    }
    expect(independentPictures.every((picture) => !picture.willChangeHint), isTrue);
  });

  testWidgets('when a keyed surface enters and leaves scroll content, it should retain its unkeyed child state', (
    tester,
  ) async {
    final scrollable = ValueNotifier(true);
    addTearDown(scrollable.dispose);
    final nestedSurfaceKey = GlobalKey();
    final nestedSurface = MateoSurface(
      key: nestedSurfaceKey,
      color: const Color(0xFFFFFFFF),
      height: const .custom(80),
      width: const .fill(),
      child: const AppTestCounter(),
    );
    await tester.pumpWidget(
      Directionality(
        textDirection: .ltr,
        child: Center(
          child: ValueListenableBuilder(
            valueListenable: scrollable,
            builder: (_, scrollable, child) => scrollable
                ? MateoSurface.scrollable(
                    color: const Color(0xFFFFFFFF),
                    width: const .custom(200),
                    height: const .custom(200),
                    child: Column(children: [child!, const SizedBox(height: 1200)]),
                  )
                : MateoSurface(
                    color: const Color(0xFFFFFFFF),
                    width: const .custom(200),
                    height: const .custom(200),
                    child: child!,
                  ),
            child: nestedSurface,
          ),
        ),
      ),
    );
    final counterState = tester.state(find.byType(AppTestCounter));
    expect(tester.renderObject(find.byKey(nestedSurfaceKey)).isRepaintBoundary, isTrue);
    await tester.tap(find.text('Count: 0'));
    await tester.pump();
    var count = 1;
    for (final enabled in [false, true, false]) {
      scrollable.value = enabled;
      await tester.pump();
      expect(tester.renderObject(find.byKey(nestedSurfaceKey)).isRepaintBoundary, enabled);
      expect(tester.state(find.byType(AppTestCounter)), same(counterState));
      expect(find.text('Count: $count'), findsOneWidget);
      await tester.tap(find.text('Count: $count'));
      await tester.pump();
      count++;
      expect(find.text('Count: $count'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets(
    'when scroll cards contain nested surfaces, it should retain each card and still repaint changed content',
    (
      tester,
    ) async {
      const firstColor = Color(0xFF123456);
      const nextColor = Color(0xFF654321);
      const captureKey = ValueKey<String>('nested surface capture');
      const cardKey = ValueKey<String>('scroll card');
      const controlKey = ValueKey<String>('nested control');
      final color = ValueNotifier(firstColor);
      addTearDown(color.dispose);
      var paints = 0;
      await tester.pumpWidget(
        Directionality(
          textDirection: .ltr,
          child: Center(
            child: RepaintBoundary(
              key: captureKey,
              child: MateoSurface.scrollable(
                color: const Color(0xFFFFFFFF),
                width: const .custom(200),
                height: const .custom(200),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    MateoSurface(
                      key: cardKey,
                      color: const Color(0xFFFFFFFF),
                      width: const .custom(160),
                      height: const .custom(120),
                      padding: const .all(20),
                      child: MateoSurface(
                        key: controlKey,
                        color: const Color(0xFFFFFFFF),
                        child: ValueListenableBuilder(
                          valueListenable: color,
                          builder: (_, color, _) => CustomPaint(
                            painter: PaintCounter(onPaint: () => paints++, color: color),
                            child: const SizedBox.expand(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 1200),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      expect(tester.renderObject(find.byKey(cardKey)).isRepaintBoundary, isTrue);
      expect(tester.renderObject(find.byKey(controlKey)).isRepaintBoundary, isFalse);
      final capture = find.byKey(captureKey);
      final sample = tester.getCenter(find.byKey(controlKey)) - tester.getTopLeft(capture);
      expect(await _paintedColor(tester, capture, sample), firstColor);
      final initialPaints = paints;
      color.value = nextColor;
      await tester.pump();
      expect(paints, initialPaints + 1);
      expect(await _paintedColor(tester, capture, sample), nextColor);
    },
  );

  testWidgets('when a surface scrolls, it should retain its content paint and still show content changes', (
    tester,
  ) async {
    final color = ValueNotifier(const Color(0xFF123456));
    addTearDown(color.dispose);
    var paints = 0;
    await tester.pumpWidget(
      Directionality(
        textDirection: .ltr,
        child: Center(
          child: MateoSurface.scrollable(
            color: const Color(0xFFFFFFFF),
            height: const .custom(200),
            width: const .custom(200),
            child: ValueListenableBuilder(
              valueListenable: color,
              builder: (_, color, _) => CustomPaint(
                painter: PaintCounter(onPaint: () => paints++, color: color),
                child: const SizedBox(height: 1200),
              ),
            ),
          ),
        ),
      ),
    );
    final initialPaints = paints;
    final controller = tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!;
    for (var frame = 1; frame <= 10; frame++) {
      controller.jumpTo(frame * 20);
      await tester.pump();
    }
    expect(controller.offset, 200);
    expect(paints, initialPaints);
    color.value = const Color(0xFF654321);
    await tester.pump();
    expect(paints, initialPaints + 1);
  });

  testWidgets('when only the surface color changes, it should reuse the content layout', (tester) async {
    final color = ValueNotifier(const Color(0xFF123456));
    addTearDown(color.dispose);
    var layouts = 0;
    await tester.pumpWidget(
      Directionality(
        textDirection: .ltr,
        child: Center(
          child: LayoutCounter(
            onLayout: () => layouts++,
            child: ValueListenableBuilder(
              valueListenable: color,
              builder: (_, color, child) => MateoSurface(color: color, child: child!),
              child: const SizedBox(width: 80, height: 40),
            ),
          ),
        ),
      ),
    );
    final initialLayouts = layouts;
    for (var frame = 0; frame < 10; frame++) {
      color.value = Color(0xFF123460 + frame);
      await tester.pump();
    }
    expect(layouts, initialLayouts);
    expect(tester.getSize(find.byType(MateoSurface)), const Size(80, 40));
  });

  testWidgets('when surface padding changes, it should still update the content layout', (tester) async {
    final padding = ValueNotifier(EdgeInsets.zero);
    addTearDown(padding.dispose);
    await tester.pumpWidget(
      Directionality(
        textDirection: .ltr,
        child: Center(
          child: ValueListenableBuilder(
            valueListenable: padding,
            builder: (_, padding, child) => MateoSurface(
              color: const Color(0xFF123456),
              padding: padding,
              child: child!,
            ),
            child: const SizedBox(width: 80, height: 40),
          ),
        ),
      ),
    );
    padding.value = const EdgeInsets.all(12);
    await tester.pump();
    expect(tester.getSize(find.byType(MateoSurface)), const Size(104, 64));
  });
}
