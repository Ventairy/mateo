import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  test('when equivalent configurations are created, they should have value equality', () {
    expect(const MateoPageTransition.wash(), const MateoPageTransition.wash());
    expect(const MateoPageTransition.wash(), isNot(const MateoPageTransition.push()));
    expect(
      const MateoPageTransition.push(duration: Duration(milliseconds: 80)).reverseDuration,
      const Duration(milliseconds: 80),
    );
  });

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

  for (final transition in [const MateoPageTransition.push(), const MateoPageTransition.wash()]) {
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
        final before = transition is MateoPageTransitionWash
            ? _mask(tester)
            : tester.getRect(find.byKey(const ValueKey('destination')));
        route.handleCancelBackGesture();
        await tester.pump();
        final after = transition is MateoPageTransitionWash
            ? _mask(tester)
            : tester.getRect(find.byKey(const ValueKey('destination')));
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
