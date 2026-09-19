import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/base_mateo_surface.dart';
import 'package:mateo_mobile/src/components/mateo_menu/overlay/show_mateo_menu.dart';

import '../fixtures/surface_transform_targets.dart';
import '../fixtures/surface_transform_test_widgets.dart';

void main() {
  late BuildContext anchor;
  late StateSetter update;
  late GlobalKey<NavigatorState> navigator;
  late MateoNavigatorObserver observer;
  var anchorTop = 100.0;
  var anchorPresent = true;
  const item = MateoMenuOptionsPresentationItem(principal: Text('Select'));
  MateoMenu menu({
    FutureOr<void> Function(MateoMenuOptionsPresentationItem)? onPressed,
    MateoMenuWidth width = .fit,
    double? height,
  }) => MateoMenu(
    presentation: .options(
      width: width,
      items: height == null
          ? [item]
          : [MateoMenuOptionsPresentationItem(principal: SizedBox(width: 100, height: height))],
    ),
    onItemPressed: onPressed,
  );
  Future<void> host(
    WidgetTester tester, {
    TextDirection direction = .ltr,
    bool reducedMotion = false,
  }) async {
    navigator = GlobalKey<NavigatorState>();
    observer = MateoNavigatorObserver();
    anchorTop = 100;
    anchorPresent = true;
    await tester.pumpWidget(
      MateoTheme(
        data: surfaceTransformTheme,
        child: Directionality(
          textDirection: direction,
          child: MediaQuery(
            data: MediaQueryData(
              size: const Size(800, 600),
              disableAnimations: reducedMotion,
            ),
            child: Navigator(
              key: navigator,
              observers: [observer],
              onGenerateRoute: (_) => PageRouteBuilder<void>(
                pageBuilder: (context, _, _) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      update = setState;
                      return Stack(
                        children: [
                          if (anchorPresent)
                            Positioned(
                              left: 100,
                              top: anchorTop,
                              child: KeyedSubtree(
                                child: Builder(
                                  builder: (context) {
                                    anchor = context;
                                    return const SizedBox(width: 80, height: 40);
                                  },
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final reducedMotion in [false, true]) {
    testWidgets(
      'when an exit builder is supplied with reduced motion $reducedMotion, it should preserve entrance and finish after removal',
      (tester) async {
        await host(tester, reducedMotion: reducedMotion);
        var completed = false;
        var builds = 0;
        const fadeKey = ValueKey('custom exit');
        final result = showMateoMenu(
          anchorContext: anchor,
          surfaceAnimation: const .pop(),
          placement: (anchor, size, bounds) => anchor.bottomLeft,
          menu: menu(),
          exitTransition: (
            duration: const Duration(milliseconds: 200),
            builder: (context, animation, child) {
              builds++;
              return FadeTransition(key: fadeKey, opacity: animation, child: child);
            },
          ),
        ).then((_) => completed = true);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));
        final element = tester.element(find.byType(MateoMenu));
        final route = ModalRoute.of(element)!;
        expect(route.transitionDuration, Duration.zero);
        expect(route.reverseTransitionDuration, Duration(milliseconds: reducedMotion ? 0 : 200));
        if (reducedMotion) {
          expect(builds, 0);
        } else {
          expect(tester.widget<FadeTransition>(find.byKey(fadeKey)).opacity.value, 1);
        }
        navigator.currentState!.pop();
        await tester.pump();
        if (!reducedMotion) {
          expect(completed, isFalse);
          await tester.pump(const Duration(milliseconds: 100));
          expect(tester.element(find.byType(MateoMenu)), same(element));
          expect(tester.widget<FadeTransition>(find.byKey(fadeKey)).opacity.value, closeTo(.5, .01));
          expect(completed, isFalse);
        } else {
          expect(find.byType(MateoMenu), findsNothing);
        }
        await tester.pumpAndSettle();
        await result;
        expect(completed, isTrue);
        expect(find.byType(MateoMenu), findsNothing);
      },
    );
  }

  test('when a button animation is const, it should select the transform style', () {
    const animation = MateoMenuButtonAnimation.transform();
    expect(animation, isA<MateoMenuButtonAnimationTransform>());
  });

  testWidgets('when a surface animation is supplied, it should own route timing and panel configuration', (
    tester,
  ) async {
    await host(tester);
    final transformId = Object();
    final suppliedSurfaceAnimation = MateoSurfaceAnimation.transform(
      target: surfaceTransformTarget(transformId, duration: const Duration(milliseconds: 400), curve: Curves.linear),
      contentEffects: const [.crossfade()],
    );
    unawaited(
      showMateoMenu(
        anchorContext: anchor,
        surfaceAnimation: suppliedSurfaceAnimation,
        placement: (anchor, size, bounds) => anchor.bottomCenter - Alignment.bottomCenter.alongSize(size),
        menu: menu(),
      ),
    );
    await tester.pumpAndSettle();
    final panel = tester.widget<BaseMateoSurface>(find.byType(BaseMateoSurface));
    final surfaceAnimation = panel.animation as MateoSurfaceAnimationTransform;
    expect(surfaceAnimation.target, same((suppliedSurfaceAnimation as MateoSurfaceAnimationTransform).target));
    expect(surfaceAnimation, same(suppliedSurfaceAnimation));
    final route = ModalRoute.of(tester.element(find.byType(MateoMenu)))!;
    expect(route.transitionDuration, suppliedSurfaceAnimation.duration);
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
    expect(find.byType(MateoMenu), findsNothing);
  });

  testWidgets('when selecting, it should dismiss before delivering the exact item once', (tester) async {
    await host(tester);
    final received = <MateoMenuOptionsPresentationItem>[];
    final pending = Completer<void>();
    final result = showMateoMenu(
      surfaceAnimation: const .none(),
      placement: (anchor, size, bounds) => anchor.bottomCenter - Alignment.bottomCenter.alongSize(size),

      anchorContext: anchor,
      menu: menu(
        onPressed: (selected) {
          expect(navigator.currentState!.canPop(), isFalse);
          received.add(selected);
          return pending.future;
        },
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byType(MateoMenu)).bottomCenter, const Offset(140, 140));
    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle();
    expect(await result, same(item));
    expect(received, [item]);
    expect(find.byType(MateoMenu), findsNothing);
    pending.complete();
  });

  for (final dismissal in ['outside', 'back', 'escape', 'programmatic']) {
    testWidgets('when dismissed by $dismissal, it should return no selection', (tester) async {
      await host(tester);
      final result = showMateoMenu(
        surfaceAnimation: const .none(),
        placement: (anchor, size, bounds) => anchor.bottomCenter - Alignment.bottomCenter.alongSize(size),

        anchorContext: anchor,
        menu: menu(),
      );
      await tester.pumpAndSettle();
      if (dismissal == 'outside') {
        await tester.tapAt(const Offset(5, 5));
      } else if (dismissal == 'back') {
        await navigator.currentState!.maybePop();
      } else if (dismissal == 'escape') {
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      } else {
        navigator.currentState!.pop();
      }
      await tester.pumpAndSettle();
      expect(await result, isNull);
      expect(find.byType(MateoMenu), findsNothing);
    });
  }

  for (final direction in TextDirection.values) {
    testWidgets('when opening in $direction, it should honor caller placement even beyond screen bounds', (
      tester,
    ) async {
      await host(tester, direction: direction);
      update(() => anchorTop = 250);
      await tester.pump();
      unawaited(
        showMateoMenu(
          surfaceAnimation: const .none(),
          placement: (anchor, size, bounds) => anchor.bottomCenter - Alignment.bottomCenter.alongSize(size),
          anchorContext: anchor,
          menu: menu(),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.getBottomRight(find.byType(MateoMenu)).dy, 290);
      expect(tester.getRect(find.byType(MateoMenu)).bottomCenter.dx, 140);
      navigator.currentState!.pop();
      await tester.pumpAndSettle();
      update(() => anchorTop = 20);
      await tester.pump();
      unawaited(
        showMateoMenu(
          surfaceAnimation: const .none(),
          placement: (anchor, size, bounds) => anchor.bottomCenter - Alignment.bottomCenter.alongSize(size),
          anchorContext: anchor,
          menu: menu(),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.getRect(find.byType(MateoMenu)).bottomCenter, const Offset(140, 60));
      expect(tester.getRect(find.byType(MateoMenu)).top, lessThan(20));
    });
  }

  testWidgets('when an anchor moves or is removed, it should retain its captured position until dismissed', (
    tester,
  ) async {
    await host(tester);
    final result = showMateoMenu(
      surfaceAnimation: const .none(),
      placement: (anchor, size, bounds) => anchor.bottomCenter - Alignment.bottomCenter.alongSize(size),

      anchorContext: anchor,
      menu: menu(onPressed: (_) {}),
    );
    await tester.pumpAndSettle();
    update(() => anchorTop = 220);
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byType(MateoMenu)).bottomCenter, const Offset(140, 140));
    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle();
    expect(await result, item);
    unawaited(
      showMateoMenu(
        surfaceAnimation: const .none(),
        placement: (anchor, size, bounds) => anchor.bottomCenter - Alignment.bottomCenter.alongSize(size),

        anchorContext: anchor,
        menu: menu(),
      ),
    );
    await tester.pumpAndSettle();
    final captured = tester.getRect(find.byType(MateoMenu));
    update(() => anchorPresent = false);
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byType(MateoMenu)), captured);
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
    expect(find.byType(MateoMenu), findsNothing);
  });

  testWidgets('when filling or exceeding the viewport, it should cap width but retain natural height', (tester) async {
    await host(tester);
    unawaited(
      showMateoMenu(
        surfaceAnimation: const .none(),
        placement: (anchor, size, bounds) => anchor.bottomCenter - Alignment.bottomCenter.alongSize(size),

        anchorContext: anchor,
        menu: menu(width: .fill, height: 900),
      ),
    );
    await tester.pumpAndSettle();
    final rect = tester.getRect(find.byType(MateoMenu));
    expect(rect.bottomCenter, const Offset(140, 140));
    expect(rect.width, 760);
    expect(rect.top, lessThan(0));
    expect(rect.height, greaterThan(900));
    expect(tester.takeException(), isNull);
  });

  testWidgets('when viewport insets change, it should reposition within the available area', (tester) async {
    await host(tester);
    unawaited(
      showMateoMenu(
        surfaceAnimation: const .none(),
        placement: (anchor, size, bounds) => bounds.bottomLeft - Offset(0, size.height),

        anchorContext: anchor,
        menu: menu(width: .fill),
      ),
    );
    await tester.pumpAndSettle();
    final initial = tester.getRect(find.byType(MateoMenu));
    expect(initial.width, 760);
    // Rebuild only the inherited media surrounding the existing navigator.
    await tester.pumpWidget(
      MateoTheme(
        data: surfaceTransformTheme,
        child: Directionality(
          textDirection: .ltr,
          child: MediaQuery(
            data: const MediaQueryData(
              size: Size(800, 600),
              padding: EdgeInsets.only(left: 40),
              viewInsets: EdgeInsets.only(bottom: 300),
            ),
            child: Navigator(
              key: navigator,
              observers: [observer],
              onGenerateRoute: (_) => PageRouteBuilder<void>(pageBuilder: (_, _, _) => const SizedBox()),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final moved = tester.getRect(find.byType(MateoMenu));
    expect(moved.left, 60);
    expect(moved.width, 720);
    expect(moved.bottom, lessThanOrEqualTo(280));
  });

  testWidgets('when the route closes, it should restore the previously focused control', (tester) async {
    await host(tester);
    final focus = FocusNode();
    final focusAnchorKey = GlobalKey();
    addTearDown(focus.dispose);
    navigator.currentState!.push(
      PageRouteBuilder<void>(
        pageBuilder: (context, _, _) {
          return KeyedSubtree(
            key: focusAnchorKey,

            child: Focus(focusNode: focus, autofocus: true, child: const SizedBox.expand()),
          );
        },
      ),
    );
    await tester.pumpAndSettle();
    expect(focus.hasFocus, isTrue);
    unawaited(
      showMateoMenu(
        surfaceAnimation: const .none(),
        placement: (anchor, size, bounds) => anchor.bottomCenter - Alignment.bottomCenter.alongSize(size),

        anchorContext: focusAnchorKey.currentContext!,
        menu: menu(),
      ),
    );
    await tester.pumpAndSettle();
    expect(focus.hasFocus, isFalse);
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
    expect(focus.hasFocus, isTrue);
  });

  testWidgets('when opened inside a nested navigator, it should use the nearest navigator', (tester) async {
    await host(tester);
    final nested = GlobalKey<NavigatorState>();
    final nestedObserver = MateoNavigatorObserver();
    final nestedAnchorKey = GlobalKey();
    navigator.currentState!.push(
      PageRouteBuilder<void>(
        pageBuilder: (_, _, _) => Navigator(
          key: nested,
          observers: [nestedObserver],
          onGenerateRoute: (_) => PageRouteBuilder<void>(
            pageBuilder: (context, _, _) {
              return KeyedSubtree(
                key: nestedAnchorKey,

                child: const SizedBox.expand(),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    unawaited(
      showMateoMenu(
        surfaceAnimation: const .none(),
        placement: (anchor, size, bounds) => anchor.bottomCenter - Alignment.bottomCenter.alongSize(size),

        anchorContext: nestedAnchorKey.currentContext!,
        menu: menu(),
      ),
    );
    await tester.pumpAndSettle();
    expect(nested.currentState!.canPop(), isTrue);
    nested.currentState!.pop();
    await tester.pumpAndSettle();
    expect(find.byType(MateoMenu), findsNothing);
  });

  testWidgets('when no handler exists, it should keep disabled options open and preserve the theme', (tester) async {
    await host(tester);
    unawaited(
      showMateoMenu(
        surfaceAnimation: const .none(),
        placement: (anchor, size, bounds) => anchor.bottomCenter - Alignment.bottomCenter.alongSize(size),

        anchorContext: anchor,
        menu: menu(),
      ),
    );
    await tester.pumpAndSettle();
    expect(MateoTheme.of(tester.element(find.byType(MateoMenu))), surfaceTransformTheme);
    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle();
    expect(find.byType(MateoMenu), findsOneWidget);
  });
}
