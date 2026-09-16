import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/mateo_surface_scope.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

import '../fixtures/surface_transform_test_widgets.dart';

Widget host({
  MateoSurfaceAnimation? animation = const .pop(),
  bool reduced = false,
  bool ticker = true,
  Key? surfaceKey,
  Widget child = const Text('Welcome'),
  bool scrollable = false,
  bool view = false,
}) {
  final surface = view
      ? MateoView(
          surface: scrollable
              ? MateoViewSurface.scrollable(animation: animation, child: child)
              : MateoViewSurface(animation: animation, child: child),
        )
      : scrollable
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

Finder get popTransform => find.byType(Motion);
double scale(WidgetTester tester) {
  final motion = tester.widget<Motion>(popTransform.first);
  final surface = tester.renderObject(find.byKey(motion.child.key!));
  return surface.getTransformTo(tester.renderObject(popTransform.first)).entry(0, 0);
}

double opacity(WidgetTester tester) =>
    tester
            .renderObject(popTransform.first)
            .toDiagnosticsNode()
            .getProperties()
            .firstWhere((property) => property.name == 'opacity')
            .value!
        as double;

void main() {
  test('pop has const public configuration and value equality', () {
    const pop = MateoSurfaceAnimation.pop();
    expect(pop, const MateoSurfaceAnimationPop());
    expect(pop.hashCode, const MateoSurfaceAnimationPop().hashCode);
    expect(pop, isNot(const MateoSurfaceAnimation.none()));
    expect(pop.duration, const Duration(milliseconds: 400));
    expect(pop.curve, Curves.easeOutBack);
    const custom = MateoSurfaceAnimation.pop(duration: Duration(milliseconds: 200), curve: Curves.linear);
    const equal = MateoSurfaceAnimationPop(duration: Duration(milliseconds: 200), curve: Curves.linear);
    expect(custom, equal);
    expect(custom.hashCode, equal.hashCode);
    expect(custom, isNot(pop));
    expect(pop, isNot(const MateoSurfaceAnimation.pop(duration: Duration(milliseconds: 200))));
    expect(pop, isNot(const MateoSurfaceAnimation.pop(curve: Curves.linear)));
  });
  for (final view in [false, true]) {
    for (final scrollable in [false, true]) {
      testWidgets('pop animates view=$view scrollable=$scrollable without changing layout', (tester) async {
        await tester.pumpWidget(host(view: view, scrollable: scrollable));
        final size = tester.getSize(popTransform.first);
        expect(scale(tester), .85);
        expect(opacity(tester), 0);
        await tester.pump(const Duration(milliseconds: 60));
        expect(opacity(tester), closeTo(Curves.easeOutBack.transform(.15), 0.000001));
        await tester.pump(const Duration(milliseconds: 60));
        expect(opacity(tester), closeTo(Curves.easeOutBack.transform(.3), 0.000001));
        await tester.pump(const Duration(milliseconds: 120));
        expect(scale(tester), greaterThan(1));
        expect(opacity(tester), greaterThan(1));
        expect(tester.takeException(), isNull);
        expect(tester.getSize(popTransform.first), size);
        await tester.pump(const Duration(milliseconds: 160));
        expect(scale(tester), 1);
        await tester.pump(const Duration(milliseconds: 1));
        expect(tester.hasRunningAnimations, isFalse);
      });
    }
  }
  testWidgets('custom linear duration coordinates fade and scale', (tester) async {
    await tester.pumpWidget(
      host(
        animation: const .pop(duration: Duration(milliseconds: 200), curve: Curves.linear),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(opacity(tester), closeTo(.5, .000001));
    expect(scale(tester), closeTo(.925, .000001));
    await tester.pump(const Duration(milliseconds: 100));
    expect(opacity(tester), 1);
    expect(scale(tester), 1);
  });

  testWidgets('scope updates propagate configuration without restarting pop', (tester) async {
    Widget scoped(MateoSurfaceAnimation animation) =>
        MateoSurfaceScope(animation: animation, child: host(animation: null));
    await tester.pumpWidget(scoped(const .pop(duration: Duration(milliseconds: 400), curve: Curves.linear)));
    await tester.pump(const Duration(milliseconds: 100));
    expect(opacity(tester), closeTo(.25, .000001));
    await tester.pumpWidget(scoped(const .pop(duration: Duration(milliseconds: 200), curve: Curves.easeOut)));
    final effects = tester.widget<Motion>(popTransform.first).effects!;
    for (final effect in effects) {
      expect(effect.duration, const Duration(milliseconds: 200));
      expect(effect.curve, Curves.easeOut);
    }
    expect(opacity(tester), closeTo(Curves.easeOut.transform(.25), .000001));
    await tester.pumpAndSettle();
    expect(opacity(tester), 1);
    expect(scale(tester), 1);
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
    expect(scale(tester), .85);
    await tester.pumpWidget(const SizedBox());
    expect(tester.takeException(), isNull);
  });
  testWidgets('switching to pop plays and switching away cancels', (tester) async {
    await tester.pumpWidget(host(animation: const .none()));
    await tester.pumpWidget(host());
    expect(scale(tester), .85);
    expect(opacity(tester), 0);
    await tester.pump(const Duration(milliseconds: 60));
    expect(scale(tester), greaterThan(.85));
    await tester.pumpWidget(host(animation: const .none()));
    expect(popTransform, findsNothing);
    await tester.pump();
    expect(tester.binding.hasScheduledFrame, isFalse);
    await tester.pumpWidget(host());
    expect(scale(tester), .85);
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
    expect(scale(tester), .85);
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
    await tester.pumpAndSettle();
    final element = tester.element(find.text('Top'));
    final scrollState = tester.state<ScrollableState>(find.byType(Scrollable).first);
    scrollState.position.jumpTo(80);
    for (final animation in [
      const MateoSurfaceAnimation.none(),
      const MateoSurfaceAnimation.transform(id: 'surface'),
      const MateoSurfaceAnimation.pop(),
    ]) {
      await tester.pumpWidget(host(animation: animation, scrollable: true, child: content));
      expect(tester.element(find.text('Top')), same(element));
      expect(tester.state<ScrollableState>(find.byType(Scrollable).first), same(scrollState));
      expect(scrollState.position.pixels, 80);
    }
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
