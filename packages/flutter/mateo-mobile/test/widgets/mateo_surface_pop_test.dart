import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/mateo_surface_scope.dart';

import '../fixtures/surface_transform_targets.dart';
import '../fixtures/surface_transform_test_widgets.dart';

Widget host({
  MateoSurfaceAnimation? animation = const .pop(),
  bool reduced = false,
  bool ticker = true,
  Key? surfaceKey,
  Widget child = const Text('Welcome'),
  bool scrollable = false,
}) {
  final surface = scrollable
      ? MateoSurface.scrollable(
          key: surfaceKey,
          animation: animation,
          width: const .custom(200),
          height: const .custom(100),
          child: child,
        )
      : MateoSurface(
          key: surfaceKey,
          animation: animation,
          width: const .custom(200),
          height: const .custom(100),
          child: child,
        );
  return MateoTheme(
    data: surfaceTransformTheme,
    child: Directionality(
      textDirection: .ltr,
      child: MediaQuery(
        data: MediaQueryData(disableAnimations: reduced),
        child: TickerMode(
          enabled: ticker,
          child: Center(child: surface),
        ),
      ),
    ),
  );
}

Finder get popTransform => find.byType(ScaleTransition);
double scale(WidgetTester tester) => tester.widget<ScaleTransition>(popTransform.first).scale.value;

double opacity(WidgetTester tester) => tester.widget<FadeTransition>(find.byType(FadeTransition).first).opacity.value;

Transform paintedTransform(WidgetTester tester) => tester.widget<Transform>(
  find.descendant(of: popTransform.first, matching: find.byType(Transform)).first,
);

Future<Color> paintedCenter(WidgetTester tester, Finder capture) async => (await tester.runAsync(() async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(capture);
  final image = await boundary.toImage();
  try {
    final pixels = (await image.toByteData(format: .rawRgba))!;
    final position = (image.height ~/ 2 * image.width + image.width ~/ 2) * 4;
    return Color.fromARGB(
      pixels.getUint8(position + 3),
      pixels.getUint8(position),
      pixels.getUint8(position + 1),
      pixels.getUint8(position + 2),
    );
  } finally {
    image.dispose();
  }
}))!;

void main() {
  test('pop has public configuration and value equality', () {
    const pop = MateoSurfaceAnimationPop();
    expect(pop, const MateoSurfaceAnimationPop());
    expect(pop.hashCode, const MateoSurfaceAnimationPop().hashCode);
    expect(pop, isNot(const MateoSurfaceAnimation.none()));
    expect(pop.duration, const Duration(milliseconds: 320));
    expect(pop.curve, Curves.easeOutBack);
    const custom = MateoSurfaceAnimationPop(duration: Duration(milliseconds: 200), curve: Curves.linear);
    const equal = MateoSurfaceAnimationPop(duration: Duration(milliseconds: 200), curve: Curves.linear);
    expect(custom, equal);
    expect(custom.hashCode, equal.hashCode);
    expect(custom, isNot(pop));
    expect(pop, isNot(const MateoSurfaceAnimation.pop(duration: Duration(milliseconds: 200))));
    expect(pop, isNot(const MateoSurfaceAnimation.pop(curve: Curves.linear)));
  });
  for (final scrollable in [false, true]) {
    testWidgets('pop animates scrollable=$scrollable without changing layout', (tester) async {
      await tester.pumpWidget(host(scrollable: scrollable));
      final size = tester.getSize(popTransform.first);
      expect(scale(tester), .75);
      expect(opacity(tester), 0);
      await tester.pump(const Duration(milliseconds: 60));
      expect(opacity(tester), closeTo(Curves.easeOutBack.transform(.1875).clamp(0, 1), 0.000001));
      await tester.pump(const Duration(milliseconds: 60));
      expect(opacity(tester), closeTo(Curves.easeOutBack.transform(.375).clamp(0, 1), 0.000001));
      await tester.pump(const Duration(milliseconds: 120));
      expect(scale(tester), greaterThan(1));
      expect(opacity(tester), 1);
      expect(tester.takeException(), isNull);
      expect(tester.getSize(popTransform.first), size);
      await tester.pump(const Duration(milliseconds: 160));
      expect(scale(tester), 1);
      await tester.pump(const Duration(milliseconds: 1));
      expect(tester.hasRunningAnimations, isFalse);
    });
  }
  testWidgets('custom linear duration coordinates fade and scale and ends filtering exactly on time', (tester) async {
    await tester.pumpWidget(
      host(
        animation: const .pop(duration: Duration(milliseconds: 200), curve: Curves.linear),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(opacity(tester), closeTo(.5, .000001));
    expect(scale(tester), closeTo(.875, .000001));
    expect(paintedTransform(tester).filterQuality, FilterQuality.low);
    await tester.pump(const Duration(milliseconds: 100));
    expect(opacity(tester), 1);
    expect(scale(tester), 1);
    expect(paintedTransform(tester).filterQuality, isNull);
    expect(tester.hasRunningAnimations, isFalse);
    expect(tester.binding.hasScheduledFrame, isFalse);
  });

  testWidgets('scope updates propagate configuration without restarting pop', (tester) async {
    Widget scoped(MateoSurfaceAnimation animation) =>
        MateoSurfaceScope(animation: animation, child: host(animation: null));
    await tester.pumpWidget(scoped(const .pop(duration: Duration(milliseconds: 400), curve: Curves.linear)));
    await tester.pump(const Duration(milliseconds: 100));
    expect(opacity(tester), closeTo(.25, .000001));
    await tester.pumpWidget(scoped(const .pop(duration: Duration(milliseconds: 200), curve: Curves.easeOut)));
    expect(opacity(tester), closeTo(Curves.easeOut.transform(.25), .000001));
    await tester.pump(const Duration(milliseconds: 100));
    expect(opacity(tester), closeTo(Curves.easeOut.transform(.625), .000001));
    expect(scale(tester), closeTo(.75 + .25 * Curves.easeOut.transform(.625), .000001));
    await tester.pump(const Duration(milliseconds: 100));
    expect(opacity(tester), 1);
    expect(scale(tester), 1);
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('rebuilds continue and remounts restart', (tester) async {
    await tester.pumpWidget(host());
    await tester.pump(const Duration(milliseconds: 60));
    final previous = scale(tester);
    await tester.pumpWidget(host(child: const Text('Changed')));
    expect(scale(tester), previous);
    await tester.pumpAndSettle();
    await tester.pumpWidget(host());
    expect(scale(tester), 1);
    await tester.pumpWidget(host(surfaceKey: const ValueKey('new')));
    expect(scale(tester), .75);
    await tester.pumpWidget(const SizedBox());
    expect(tester.takeException(), isNull);
  });
  testWidgets('switching to pop plays and switching away cancels', (tester) async {
    await tester.pumpWidget(host(animation: const .none()));
    await tester.pumpWidget(host());
    expect(scale(tester), .75);
    expect(opacity(tester), 0);
    await tester.pump(const Duration(milliseconds: 60));
    expect(scale(tester), greaterThan(.75));
    await tester.pumpWidget(host(animation: const .none()));
    expect(popTransform, findsNothing);
    await tester.pump();
    expect(tester.binding.hasScheduledFrame, isFalse);
    await tester.pumpWidget(host());
    expect(scale(tester), .75);
  });
  testWidgets('reduced motion settles immediately and never replays', (tester) async {
    await tester.pumpWidget(host(reduced: true));
    expect(scale(tester), 1);
    expect(opacity(tester), 1);
    await tester.pumpWidget(host());
    expect(scale(tester), 1);
    await tester.pumpWidget(host(surfaceKey: const ValueKey('new')));
    await tester.pump(const Duration(milliseconds: 60));
    await tester.pumpWidget(host(surfaceKey: const ValueKey('new'), reduced: true));
    expect(scale(tester), 1);
    expect(tester.hasRunningAnimations, isFalse);
  });
  testWidgets('muted ticker stops scheduling frames', (tester) async {
    await tester.pumpWidget(host(ticker: false));
    await tester.pump(const Duration(milliseconds: 400));
    expect(scale(tester), .75);
    expect(tester.binding.hasScheduledFrame, isFalse);
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();
    expect(scale(tester), 1);
  });
  testWidgets('scope supplies pop only to outer surface and explicit none wins', (tester) async {
    Widget scoped(MateoSurfaceAnimation? animation) => MateoSurfaceScope(
      animation: const .pop(),
      child: host(
        animation: animation,
        child: const MateoSurface(child: Text('Nested')),
      ),
    );
    await tester.pumpWidget(scoped(null));
    expect(popTransform, findsOneWidget);
    await tester.pumpWidget(scoped(const .none()));
    expect(popTransform, findsNothing);
  });
  testWidgets('scroll and child state survive wrapper changes', (tester) async {
    const content = Column(children: [Text('Top'), SizedBox(height: 500), Text('Bottom')]);
    await tester.pumpWidget(host(scrollable: true, child: content));
    final element = tester.element(find.text('Top'));
    final scrollState = tester.state<ScrollableState>(find.byType(Scrollable).first);
    scrollState.position.jumpTo(80);
    await tester.pumpAndSettle();
    expect(tester.element(find.text('Top')), same(element));
    expect(tester.state<ScrollableState>(find.byType(Scrollable).first), same(scrollState));
    expect(scrollState.position.pixels, 80);
    for (final animation in [
      const MateoSurfaceAnimation.none(),
      MateoSurfaceAnimation.transform(
        target: surfaceTransformTarget('surface'),
      ),
      const MateoSurfaceAnimation.pop(),
    ]) {
      await tester.pumpWidget(host(animation: animation, scrollable: true, child: content));
      expect(tester.element(find.text('Top')), same(element));
      expect(tester.state<ScrollableState>(find.byType(Scrollable).first), same(scrollState));
      expect(scrollState.position.pixels, 80);
    }
  });
  testWidgets('live descendants repaint through the filtered entrance', (tester) async {
    const captureKey = ValueKey('pop capture');
    final color = ValueNotifier(const Color(0xFFFF0000));
    addTearDown(color.dispose);
    await tester.pumpWidget(
      RepaintBoundary(
        key: captureKey,
        child: host(
          animation: const .pop(duration: Duration(milliseconds: 400), curve: Curves.linear),
          child: RepaintBoundary(
            child: ValueListenableBuilder<Color>(
              valueListenable: color,
              builder: (_, value, _) => ColoredBox(color: value, child: const SizedBox.expand()),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    final first = await paintedCenter(tester, find.byKey(captureKey));
    expect(first.r, greaterThan(first.b));
    color.value = const Color(0xFF0000FF);
    await tester.pump();
    final next = await paintedCenter(tester, find.byKey(captureKey));
    expect(next.b, greaterThan(next.r));
    expect(scale(tester), .875);
    expect(paintedTransform(tester).filterQuality, FilterQuality.low);
    await tester.pumpAndSettle();
  });
  testWidgets('reduced motion preserves child and scroll state when removing the temporary boundary', (tester) async {
    const content = Column(children: [Text('Top'), SizedBox(height: 500), Text('Bottom')]);
    await tester.pumpWidget(host(scrollable: true, child: content));
    final element = tester.element(find.text('Top'));
    final scrollState = tester.state<ScrollableState>(find.byType(Scrollable).first);
    scrollState.position.jumpTo(80);
    await tester.pump(const Duration(milliseconds: 60));
    await tester.pumpWidget(host(scrollable: true, reduced: true, child: content));
    expect(tester.element(find.text('Top')), same(element));
    expect(tester.state<ScrollableState>(find.byType(Scrollable).first), same(scrollState));
    expect(scrollState.position.pixels, 80);
    expect(scale(tester), 1);
    expect(paintedTransform(tester).filterQuality, isNull);
    expect(tester.hasRunningAnimations, isFalse);
  });
  testWidgets('semantics remain present and hit testing follows scale', (tester) async {
    final semantics = tester.ensureSemantics();
    var taps = 0;
    await tester.pumpWidget(
      host(
        child: GestureDetector(
          behavior: .opaque,
          onTap: () => taps++,
          child: Semantics(label: 'Surface action', child: const SizedBox.expand()),
        ),
      ),
    );
    expect(find.bySemanticsLabel('Surface action'), findsOneWidget);
    await tester.tapAt(tester.getCenter(popTransform.first));
    expect(taps, 1);
    final bounds = tester.getRect(popTransform.first);
    await tester.tapAt(Offset(bounds.left + 2, bounds.center.dy));
    expect(taps, 1);
    await tester.pumpAndSettle();
    semantics.dispose();
  });
}
