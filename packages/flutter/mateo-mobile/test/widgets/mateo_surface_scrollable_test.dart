import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  const color = Color(0xFF123456);
  Widget host(Widget child) => Directionality(
    textDirection: .ltr,
    child: Center(child: child),
  );
  ScrollController controller(WidgetTester tester) =>
      tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!;

  testWidgets('when shape and bounds change while scrolled, it should retain its viewport and update clipping', (
    tester,
  ) async {
    Widget surface(MateoShape shape, double width) => host(
      MateoSurface.scrollable(
        color: color,
        width: .custom(width),
        height: const .custom(200),
        shape: shape,
        child: const SizedBox(height: 800),
      ),
    );
    await tester.pumpWidget(surface(const .none(), 200));
    final owned = controller(tester)..jumpTo(100);
    for (final (shape, width) in [
      (const MateoShape.capsule(), 300.0),
      (const MateoShape.none(), 160.0),
    ]) {
      await tester.pumpWidget(surface(shape, width));
      expect(controller(tester), same(owned));
      expect(owned.offset, 100);
      if (shape == const MateoShape.none()) {
        expect(find.byType(ClipPath), findsNothing);
        final clip = find.ancestor(of: find.byType(ColoredBox), matching: find.byType(ClipRect)).first;
        expect(tester.widget<ClipRect>(clip).clipBehavior, Clip.hardEdge);
        expect(tester.getSize(clip), Size(width, 200));
      } else {
        final clip = tester.widget<ClipPath>(find.byType(ClipPath).first);
        final path = clip.clipper!.getClip(Size(width, 200));
        expect(path.contains(const Offset(1, 1)), isFalse);
        expect(path.getBounds().width, closeTo(width, 1e-4));
        expect(path.getBounds().height, closeTo(200, 1e-4));
      }
    }
  });

  testWidgets('when short content has flexible space, it should fill the viewport without scrolling', (tester) async {
    await tester.pumpWidget(
      host(
        const SizedBox(
          height: 240,
          child: MateoSurface.scrollable(
            color: color,
            width: .custom(200),
            padding: .all(20),
            child: Column(
              children: [
                SizedBox(height: 20),
                Spacer(),
                SizedBox(key: ValueKey('bottom'), height: 20),
              ],
            ),
          ),
        ),
      ),
    );
    expect(tester.getSize(find.byType(MateoSurface)), const Size(200, 240));
    expect(
      tester.getBottomLeft(find.byKey(const ValueKey('bottom'))).dy,
      tester.getBottomLeft(find.byType(MateoSurface)).dy - 20,
    );
    expect(controller(tester).position.maxScrollExtent, 0);
    await tester.drag(find.byType(MateoSurface), const Offset(0, -100));
    await tester.pumpAndSettle();
    expect(controller(tester).offset, 0);
  });

  testWidgets('when content overflows, it should scroll padding while keeping the surface fixed', (tester) async {
    await tester.pumpWidget(
      host(
        const MateoSurface.scrollable(
          color: color,
          width: .custom(200),
          height: .custom(200),
          padding: .all(20),
          shape: .capsule(),
          child: SizedBox(key: ValueKey('content'), height: 600),
        ),
      ),
    );
    final bounds = tester.getRect(find.byType(MateoSurface));
    final contentTop = tester.getTopLeft(find.byKey(const ValueKey('content'))).dy;
    expect(controller(tester).position.maxScrollExtent, 440);
    await tester.drag(find.byType(MateoSurface), const Offset(0, -100));
    await tester.pumpAndSettle();
    expect(controller(tester).offset, greaterThan(0));
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('content'))).dy,
      closeTo(contentTop - controller(tester).offset, 0.01),
    );
    expect(tester.getRect(find.byType(MateoSurface)), bounds);
  });

  testWidgets('when rebuilt, it should preserve its controller and offset then dispose on removal', (tester) async {
    Widget surface(double padding) => host(
      MateoSurface.scrollable(
        color: color,
        width: const .custom(200),
        height: const .custom(200),
        padding: .all(padding),
        child: const SizedBox(height: 600),
      ),
    );
    await tester.pumpWidget(surface(10));
    final owned = controller(tester)..jumpTo(100);
    await tester.pumpWidget(surface(20));
    expect(controller(tester), same(owned));
    expect(owned.offset, 100);
    await tester.pumpWidget(const SizedBox());
    expect(owned.hasClients, isFalse);
    expect(() => owned.addListener(() {}), throwsFlutterError);
  });

  testWidgets('when multiple surfaces have a primary ancestor, it should keep their scrolling independent', (
    tester,
  ) async {
    final primary = ScrollController();
    await tester.pumpWidget(
      host(
        PrimaryScrollController(
          controller: primary,
          child: const Row(
            mainAxisSize: .min,
            children: [
              MateoSurface.scrollable(
                color: color,
                width: .custom(200),
                height: .custom(200),
                child: SizedBox(height: 600),
              ),
              MateoSurface.scrollable(
                color: color,
                width: .custom(200),
                height: .custom(200),
                child: SizedBox(height: 600),
              ),
            ],
          ),
        ),
      ),
    );
    final views = tester.widgetList<CustomScrollView>(find.byType(CustomScrollView)).toList();
    expect(primary.hasClients, isFalse);
    expect(views[0].controller, isNot(same(views[1].controller)));
    views[0].controller!.jumpTo(100);
    await tester.pump();
    expect(views[1].controller!.offset, 0);
    await tester.pumpWidget(const SizedBox());
    primary.dispose();
  });

  testWidgets('when content overflows, it should expose vertical scrolling semantics', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      host(
        const MateoSurface.scrollable(
          color: color,
          width: .custom(200),
          height: .custom(200),
          child: SizedBox(height: 600),
        ),
      ),
    );
    final actions = <SemanticsAction>{};
    bool collectActions(SemanticsNode node) {
      for (final action in SemanticsAction.values) {
        if (node.getSemanticsData().hasAction(action)) actions.add(action);
      }
      node.visitChildren(collectActions);
      return true;
    }

    collectActions(tester.getSemantics(find.byType(Scrollable)));
    expect(actions, contains(SemanticsAction.scrollUp));
    semantics.dispose();
  });

  testWidgets('when touching a rounded corner, it should keep clipped content from receiving taps', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      host(
        MateoSurface.scrollable(
          color: color,
          width: const .custom(200),
          height: const .custom(200),
          shape: const .capsule(),
          child: GestureDetector(behavior: .opaque, onTap: () => taps++, child: const SizedBox(height: 600)),
        ),
      ),
    );
    await tester.tapAt(tester.getTopLeft(find.byType(MateoSurface)) + const Offset(1, 1));
    expect(taps, 0);
    await tester.tap(find.byType(MateoSurface));
    expect(taps, 1);
  });
}
