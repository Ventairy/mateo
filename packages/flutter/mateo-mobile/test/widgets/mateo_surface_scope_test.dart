import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/base_mateo_surface.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/mateo_surface_scope.dart';

import '../fixtures/surface_transform_targets.dart';
import '../fixtures/surface_transform_test_widgets.dart';

Widget _surface({
  required bool view,
  required bool scrollable,
  MateoSurfaceAnimation? animation,
  Widget child = const SizedBox(),
}) {
  if (view) {
    return MateoView(
      surface: scrollable
          ? MateoViewSurface.scrollable(animation: animation, child: child)
          : MateoViewSurface(animation: animation, child: child),
    );
  }
  return scrollable
      ? MateoSurface.scrollable(animation: animation, child: child)
      : MateoSurface(animation: animation, child: child);
}

List<MateoSurfaceAnimation> _animations(WidgetTester tester) =>
    tester.widgetList<BaseMateoSurface>(find.byType(BaseMateoSurface)).map((surface) => surface.animation).toList();

void main() {
  final inherited = MateoSurfaceAnimation.transform(
    target: surfaceTransformTarget('inherited'),
  );
  final explicit = MateoSurfaceAnimation.transform(
    target: surfaceTransformTarget('explicit'),
  );
  const none = MateoSurfaceAnimation.none();

  testWidgets('lookup without a scope returns none', (tester) async {
    await tester.pumpWidget(
      Builder(
        builder: (context) {
          expect(MateoSurfaceScope.of(context).animation, none);
          return const SizedBox();
        },
      ),
    );
  });

  for (final view in [false, true]) {
    for (final scrollable in [false, true]) {
      for (final animation in <MateoSurfaceAnimation?>[null, none, explicit]) {
        testWidgets('view=$view scrollable=$scrollable explicit=$animation resolves and blocks inheritance', (
          tester,
        ) async {
          await tester.pumpWidget(
            MateoApp(
              theme: surfaceTransformTheme,
              home: MateoSurfaceScope(
                animation: inherited,
                child: _surface(
                  view: view,
                  scrollable: scrollable,
                  animation: animation,
                  child: const MateoSurface(child: SizedBox(width: 20, height: 20)),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(_animations(tester), [animation ?? inherited, none]);
          expect(tester.takeException(), isNull);
        });
      }
    }
  }

  testWidgets('an inner scope establishes a new animation below a boundary', (tester) async {
    await tester.pumpWidget(
      MateoApp(
        theme: surfaceTransformTheme,
        home: MateoSurfaceScope(
          animation: inherited,
          child: MateoSurface(
            child: MateoSurfaceScope(
              animation: explicit,
              child: const MateoSurface(child: SizedBox(width: 20, height: 20)),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(_animations(tester), [inherited, explicit]);
  });

  for (final presentation in <MateoButtonPresentation>[
    const .label(label: 'Options', variant: .secondary),
    const .icon(icon: MateoIcon(.cross), variant: .primary),
  ]) {
    testWidgets('scope reaches the outer surface of $presentation', (tester) async {
      await tester.pumpWidget(
        MateoApp(
          theme: surfaceTransformTheme,
          home: MateoSurfaceScope(
            animation: inherited,
            child: Center(
              child: MateoButton(presentation: presentation, onPressed: () {}),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(_animations(tester), [inherited]);
    });
  }

  testWidgets('scope updates and removal preserve a keyed surface child state', (tester) async {
    final surfaceKey = GlobalKey();
    final childKey = GlobalKey<EditableTextState>();
    final controller = TextEditingController(text: 'Retained');
    final focus = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focus.dispose);
    final surface = MateoSurface(
      key: surfaceKey,
      child: EditableText(
        key: childKey,
        controller: controller,
        focusNode: focus,
        style: const TextStyle(),
        cursorColor: surfaceTransformTheme.colorScheme.accent,
        backgroundCursorColor: surfaceTransformTheme.colorScheme.background,
      ),
    );
    EditableTextState? state;
    for (final animation in <MateoSurfaceAnimation?>[inherited, explicit, none, null]) {
      await tester.pumpWidget(
        MateoApp(
          theme: surfaceTransformTheme,
          home: animation == null ? surface : MateoSurfaceScope(animation: animation, child: surface),
        ),
      );
      await tester.pumpAndSettle();
      expect(_animations(tester), [animation ?? none]);
      state ??= childKey.currentState;
      expect(childKey.currentState, same(state));
      expect(controller.text, 'Retained');
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('inherited matching endpoints transform and complete handoff', (tester) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    Widget endpoint(Rect bounds, String label) => Stack(
      children: [
        Positioned.fromRect(
          rect: bounds,
          child: MateoSurfaceScope(
            animation: inherited,
            child: MateoSurface(child: Text(label)),
          ),
        ),
      ],
    );
    const begin = Rect.fromLTWH(20, 40, 144, 48);
    const end = Rect.fromLTWH(200, 160, 240, 280);
    await tester.pumpWidget(
      MateoApp(
        theme: surfaceTransformTheme,
        navigatorKey: navigatorKey,
        home: endpoint(begin, 'Source'),
      ),
    );
    await tester.pumpAndSettle();
    await startSurfaceTransformAnimationFlight(tester, navigatorKey.currentState!, endpoint(end, 'Destination'));
    expect(surfaceFlight, findsOneWidget);
    expect(tester.getRect(surfaceFlight), begin);
    await tester.pump(const Duration(milliseconds: 115));
    final bounds = tester.getRect(surfaceFlight);
    expect(bounds.left, greaterThan(begin.left));
    expect(bounds.left, lessThan(end.left));
    await tester.pumpAndSettle();
    expect(surfaceFlight, findsNothing);
    expect(find.text('Destination'), findsOneWidget);
    navigatorKey.currentState!.pop();
    await tester.pumpAndSettle();
    expect(surfaceFlight, findsNothing);
    expect(find.text('Source'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
