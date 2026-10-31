import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  test('when equivalent configurations are created, they should have value equality', () {
    expect(const MateoPageTransition.wash(), const MateoPageTransition.wash());
    expect(const MateoPageTransition.wash(), isNot(const MateoPageTransition.push()));
    expect(const MateoPageTransition.slide(), const MateoPageTransition.slide());
    expect(const MateoPageTransition.slide(), isNot(const MateoPageTransition.push()));
    expect(
      const MateoPageTransition.push(duration: Duration(milliseconds: 80)).reverseDuration,
      const Duration(milliseconds: 80),
    );
  });

  test('when fade uses default timing, it should open gently and return sooner', () {
    const fade = MateoPageTransitionFade();
    expect(const MateoPageTransition.fade(), fade);
    expect(fade.duration, const Duration(milliseconds: 600));
    expect(fade.reverseDuration, const Duration(milliseconds: 300));
    expect(fade, isNot(const MateoPageTransition.fade(duration: Duration(milliseconds: 400))));
    expect(fade, isNot(const MateoPageTransition.fade(reverseDuration: Duration(milliseconds: 200))));
    expect(fade.hashCode, const MateoPageTransition.fade().hashCode);
    expect(fade, isNot(const MateoPageTransition.slide()));
    expect(const MateoPageTransition.slide(direction: .left), isNot(const MateoPageTransition.slide()));
    expect(const MateoPageTransition.push(direction: .left), isNot(const MateoPageTransition.push()));
    expect(const MateoPageTransition.wash(direction: .left), isNot(const MateoPageTransition.wash()));

    for (final curve in [fade.openingCurve, fade.closingCurve]) {
      var previous = curve.transform(0);
      expect(previous, 0);
      for (var sample = 1; sample <= 1000; sample++) {
        final opacity = curve.transform(sample / 1000);
        expect(opacity, inInclusiveRange(previous, 1));
        previous = opacity;
      }
      expect(previous, 1);
      // Soft onset and landing: halving either endpoint window should reduce
      // the opacity change much more than halving a linear fade would.
      expect(curve.transform(.005) / curve.transform(.01), lessThan(.15));
      expect((1 - curve.transform(.995)) / (1 - curve.transform(.99)), lessThan(.08));
    }
    expect(fade.openingCurve.transform(.1), greaterThan(.02));
    expect(fade.openingCurve.transform(.5), inInclusiveRange(.75, .8));
    expect(fade.openingCurve.transform(.6), greaterThan(.9));
    expect(fade.closingCurve.transform(.5), inInclusiveRange(.65, .7));
  });

  test('when fade timing is customized, it should validate and forward both durations', () {
    const builder = MateoPageTransitionsBuilder(
      transition: .fade(duration: Duration(milliseconds: 450), reverseDuration: Duration(milliseconds: 240)),
    );
    expect(builder.transitionDuration, const Duration(milliseconds: 450));
    expect(builder.reverseTransitionDuration, const Duration(milliseconds: 240));
    expect(
      const MateoPageTransition.fade(duration: Duration(milliseconds: 450)).reverseDuration,
      const Duration(milliseconds: 300),
    );
    for (final transition in [
      const MateoPageTransition.fade(duration: Duration(milliseconds: -1)),
      const MateoPageTransition.fade(reverseDuration: Duration(milliseconds: -1)),
    ]) {
      expect(() => MateoPageTransitionsBuilder(transition: transition).transitionDuration, throwsArgumentError);
    }
  });

  testWidgets('when routes share a fade builder, it should fade the whole destination over a stationary source', (
    tester,
  ) async {
    const builder = MateoPageTransitionsBuilder(transition: .fade());
    final pages = ValueNotifier<List<Page<void>>>([_TestPage(id: 'source', builder: builder)]);
    addTearDown(pages.dispose);
    await tester.pumpWidget(_app(pages));
    pages.value = [...pages.value, _TestPage(id: 'destination', builder: builder)];
    await tester.pump();
    expect(_fadeOpacity(tester, 'destination'), 0);
    await tester.pump(const Duration(milliseconds: 300));
    expect(_fadeOpacity(tester, 'destination'), inInclusiveRange(.75, .8));
    expect(_fadeOpacity(tester, 'source'), 1);
    expect(tester.getTopLeft(find.byKey(const ValueKey('source'))), Offset.zero);
    expect(tester.getTopLeft(find.byKey(const ValueKey('destination'))), Offset.zero);
    await tester.pumpAndSettle();
    expect(_fadeOpacity(tester, 'destination'), 1);
    Navigator.of(tester.element(find.byKey(const ValueKey('destination')))).pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    expect(_fadeOpacity(tester, 'destination'), inInclusiveRange(.3, .35));
    expect(_fadeOpacity(tester, 'source'), 1);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('destination')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('when a fade is reversed during entry, it should continue from the visible opacity', (tester) async {
    const builder = MateoPageTransitionsBuilder(transition: .fade());
    final pages = ValueNotifier<List<Page<void>>>([_TestPage(id: 'source', builder: builder)]);
    addTearDown(pages.dispose);
    await tester.pumpWidget(_app(pages));
    pages.value = [...pages.value, _TestPage(id: 'destination', builder: builder)];
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    final before = _fadeOpacity(tester, 'destination');
    Navigator.of(tester.element(find.byKey(const ValueKey('destination')))).pop();
    await tester.pump();
    expect(_fadeOpacity(tester, 'destination'), before);
    await tester.pump(const Duration(milliseconds: 30));
    expect(_fadeOpacity(tester, 'destination'), lessThan(before));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('when reduced motion changes during a fade, it should reveal the complete destination immediately', (
    tester,
  ) async {
    const builder = MateoPageTransitionsBuilder(transition: .fade());
    final pages = ValueNotifier<List<Page<void>>>([_TestPage(id: 'source', builder: builder)]);
    final reduced = ValueNotifier(false);
    addTearDown(pages.dispose);
    addTearDown(reduced.dispose);
    await tester.pumpWidget(_app(pages, reduced: reduced));
    pages.value = [...pages.value, _TestPage(id: 'destination', builder: builder)];
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(_fadeOpacity(tester, 'destination'), lessThan(.2));
    reduced.value = true;
    await tester.pump();
    expect(_fadeOpacity(tester, 'destination'), 1);
    await tester.pumpAndSettle();
  });

  for (final direction in MateoPageTransitionDirection.values) {
    testWidgets('when application routes share a $direction slide builder, it should move only the destination', (
      tester,
    ) async {
      final builder = MateoPageTransitionsBuilder(transition: .slide(direction: direction));
      final pages = ValueNotifier<List<Page<void>>>([_TestPage(id: 'source', builder: builder)]);
      addTearDown(pages.dispose);
      await tester.pumpWidget(_app(pages));
      pages.value = [...pages.value, _TestPage(id: 'destination', builder: builder)];
      await tester.pump();
      await tester.pump(builder.transitionDuration ~/ 2);

      final transition = builder.transition as MateoPageTransitionSlide;
      final source = tester.getRect(find.byKey(const ValueKey('source')));
      final destination = tester.getRect(find.byKey(const ValueKey('destination')));
      expect(source.topLeft, Offset.zero);
      expect(
        destination.topLeft,
        _slideOffset(
          direction: direction,
          size: source.size,
          remainingFraction: 1 - transition.openingCurve.transform(0.5),
        ),
      );

      await tester.pumpAndSettle();
      Navigator.of(tester.element(find.byKey(const ValueKey('destination')))).pop();
      await tester.pump();
      await tester.pump(builder.reverseTransitionDuration ~/ 2);

      expect(tester.getRect(find.byKey(const ValueKey('source'))).topLeft, Offset.zero);
      expect(
        tester.getRect(find.byKey(const ValueKey('destination'))).topLeft,
        _slideOffset(
          direction: direction,
          size: source.size,
          remainingFraction: transition.closingCurve.transform(0.5),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('source')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  for (final direction in MateoPageTransitionDirection.values) {
    testWidgets('when application routes share a $direction push builder, it should keep their pages attached', (
      tester,
    ) async {
      final builder = MateoPageTransitionsBuilder(transition: .push(direction: direction));
      final pages = ValueNotifier<List<Page<void>>>([_TestPage(id: 'source', builder: builder)]);
      addTearDown(pages.dispose);
      await tester.pumpWidget(_app(pages));
      pages.value = [...pages.value, _TestPage(id: 'destination', builder: builder)];
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      final source = tester.getRect(find.byKey(const ValueKey('source')));
      final destination = tester.getRect(find.byKey(const ValueKey('destination')));
      switch (direction) {
        case .up:
          expect(source.bottom, closeTo(destination.top, 0.01));
        case .down:
          expect(source.top, closeTo(destination.bottom, 0.01));
        case .left:
          expect(source.right, closeTo(destination.left, 0.01));
        case .right:
          expect(source.left, closeTo(destination.right, 0.01));
      }
      expect(source.topLeft, isNot(Offset.zero));
      await tester.pumpAndSettle();
      Navigator.of(tester.element(find.byKey(const ValueKey('destination')))).pop();
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('source')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('when wash interrupts its opening, it should retrace the current reveal without a jump', (tester) async {
    const builder = MateoPageTransitionsBuilder(transition: .wash());
    final pages = ValueNotifier<List<Page<void>>>([_TestPage(id: 'source', builder: builder)]);
    addTearDown(pages.dispose);
    await tester.pumpWidget(_app(pages));
    pages.value = [...pages.value, _TestPage(id: 'destination', builder: builder)];
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 240));
    final before = _mask(tester);
    Navigator.of(tester.element(find.byKey(const ValueKey('destination')))).pop();
    await tester.pump();
    expect(_mask(tester), before);
    await tester.pump(const Duration(milliseconds: 40));
    expect(_mask(tester).height, lessThanOrEqualTo(before.height));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('when slide interrupts its opening, it should return from its current position without a jump', (
    tester,
  ) async {
    const builder = MateoPageTransitionsBuilder(transition: .slide());
    final pages = ValueNotifier<List<Page<void>>>([_TestPage(id: 'source', builder: builder)]);
    addTearDown(pages.dispose);
    await tester.pumpWidget(_app(pages));
    pages.value = [...pages.value, _TestPage(id: 'destination', builder: builder)];
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    final before = tester.getRect(find.byKey(const ValueKey('destination')));
    Navigator.of(tester.element(find.byKey(const ValueKey('destination')))).pop();
    await tester.pump();
    expect(tester.getRect(find.byKey(const ValueKey('destination'))), before);
    await tester.pump(const Duration(milliseconds: 40));
    expect(tester.getTopLeft(find.byKey(const ValueKey('destination'))).dy, greaterThan(before.top));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  for (final transition in [
    const MateoPageTransition.fade(),
    const MateoPageTransition.push(),
    const MateoPageTransition.slide(),
    const MateoPageTransition.wash(),
  ]) {
    testWidgets(
      'when ${transition.runtimeType} predictive back cancels, it should keep the drag mapping until settled',
      (tester) async {
        final pages = ValueNotifier<List<Page<void>>>([
          _TestPage(
            id: 'source',
            builder: MateoPageTransitionsBuilder(transition: transition),
          ),
        ]);
        addTearDown(pages.dispose);
        await tester.pumpWidget(_app(pages));
        pages.value = [
          ...pages.value,
          _TestPage(
            id: 'destination',
            builder: MateoPageTransitionsBuilder(transition: transition),
          ),
        ];
        await tester.pumpAndSettle();
        final route = (ModalRoute.of(tester.element(find.byKey(const ValueKey('destination'))))! as PageRoute<void>)
          ..handleStartBackGesture(progress: 1)
          ..handleUpdateBackGestureProgress(progress: 0.63);
        await tester.pump();
        final before = _transitionAppearance(tester, transition);
        route.handleCancelBackGesture();
        await tester.pump();
        final after = _transitionAppearance(tester, transition);
        expect(after, before);
        await tester.pumpAndSettle();
        expect(route.isCurrent, isTrue);
        expect(route.popGestureInProgress, isFalse);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('when reduced motion changes during a custom transition, it should immediately reveal the content', (
    tester,
  ) async {
    const builder = MateoPageTransitionsBuilder(transition: .wash());
    final pages = ValueNotifier<List<Page<void>>>([_TestPage(id: 'source', builder: builder)]);
    final reduced = ValueNotifier(false);
    addTearDown(pages.dispose);
    addTearDown(reduced.dispose);
    await tester.pumpWidget(_app(pages, reduced: reduced));
    pages.value = [...pages.value, _TestPage(id: 'destination', builder: builder)];
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(_findMask(tester.binding.renderViews.single.debugLayer), isNotNull);
    reduced.value = true;
    await tester.pump();
    expect(_findMask(tester.binding.renderViews.single.debugLayer), isNull);
    expect(find.byKey(const ValueKey('destination')), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('when a same-key wash changes snapshot policy, it should preserve the route and update rendering', (
    tester,
  ) async {
    const builder = MateoPageTransitionsBuilder(transition: .wash());
    final pages = ValueNotifier<List<Page<void>>>([_TestPage(id: 'source', builder: builder)]);
    addTearDown(pages.dispose);
    await tester.pumpWidget(_app(pages));
    pages.value = [...pages.value, _TestPage(id: 'destination', builder: builder)];
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final route = ModalRoute.of(tester.element(find.byKey(const ValueKey('destination'))));
    pages.value = [pages.value.first, _TestPage(id: 'destination', builder: builder, allowSnapshotting: false)];
    await tester.pump();
    expect(ModalRoute.of(tester.element(find.byKey(const ValueKey('destination')))), same(route));
    final snapshots = tester.widgetList<SnapshotWidget>(find.byType(SnapshotWidget));
    expect(snapshots.last.controller.allowSnapshotting, isFalse);
    await tester.pumpAndSettle();
  });
}

Offset _slideOffset({
  required MateoPageTransitionDirection direction,
  required Size size,
  required double remainingFraction,
}) => switch (direction) {
  .up => Offset(0, size.height * remainingFraction),
  .down => Offset(0, -size.height * remainingFraction),
  .left => Offset(size.width * remainingFraction, 0),
  .right => Offset(-size.width * remainingFraction, 0),
};

final _theme = MateoThemeData.light(accentColor: const Color(0xFF7551FF), onAccent: const Color(0xFFFFFFFF));

Widget _app(ValueNotifier<List<Page<void>>> pages, {ValueNotifier<bool>? reduced}) => MateoApp(
  theme: _theme,
  home: ValueListenableBuilder<List<Page<void>>>(
    valueListenable: pages,
    builder: (context, value, child) => Navigator(
      pages: value,
      onDidRemovePage: (page) {
        pages.value = [...pages.value]..remove(page);
      },
    ),
  ),
  builder: reduced == null
      ? null
      : (context, child) => ValueListenableBuilder<bool>(
          valueListenable: reduced,
          builder: (context, value, _) => MediaQuery(
            data: MediaQueryData(disableAnimations: value),
            child: child!,
          ),
        ),
);

class _TestPage extends Page<void> {
  _TestPage({required this.id, required this.builder, this.allowSnapshotting = true}) : super(key: ValueKey(id));
  final String id;
  final MateoPageTransitionsBuilder builder;
  final bool allowSnapshotting;
  @override
  PageRoute<void> createRoute(BuildContext context) => _BuilderRoute(this);
}

class _BuilderRoute extends PageRoute<void> {
  _BuilderRoute(_TestPage page) : super(settings: page);
  _TestPage get page => settings as _TestPage;
  @override
  bool get maintainState => true;
  @override
  bool get allowSnapshotting => page.allowSnapshotting;
  @override
  Color? get barrierColor => null;
  @override
  String? get barrierLabel => null;
  @override
  Duration get transitionDuration => page.builder.transitionDuration;
  @override
  Duration get reverseTransitionDuration => page.builder.reverseTransitionDuration;
  @override
  DelegatedTransitionBuilder? get delegatedTransition => page.builder.delegatedTransition;
  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
      ColoredBox(
        key: ValueKey(page.id),
        color: page.id == 'source' ? _theme.colorScheme.background : _theme.colorScheme.accent,
      );
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => page.builder.buildTransitions(this, context, animation, secondaryAnimation, child);
}

Rect _mask(WidgetTester tester) => _findMask(tester.binding.renderViews.single.debugLayer)!.maskRect!;
ShaderMaskLayer? _findMask(Layer? layer) {
  if (layer is ShaderMaskLayer) return layer;
  if (layer is ContainerLayer) {
    var child = layer.firstChild;
    while (child != null) {
      final found = _findMask(child);
      if (found != null) return found;
      child = child.nextSibling;
    }
  }
  return null;
}

Object _transitionAppearance(WidgetTester tester, MateoPageTransition transition) => switch (transition) {
  MateoPageTransitionFade() => _fadeOpacity(tester, 'destination'),
  MateoPageTransitionWash() => _mask(tester),
  MateoPageTransitionPush() || MateoPageTransitionSlide() => tester.getRect(find.byKey(const ValueKey('destination'))),
};

double _fadeOpacity(WidgetTester tester, String id) => tester
    .widget<FadeTransition>(
      find.ancestor(of: find.byKey(ValueKey(id)), matching: find.byType(FadeTransition)).first,
    )
    .opacity
    .value;
