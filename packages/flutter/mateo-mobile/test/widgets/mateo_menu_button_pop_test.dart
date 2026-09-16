import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/mateo_surface_scope.dart';

import '../fixtures/surface_transform_test_widgets.dart';

Widget button({double height = 60, MateoMenuWidth width = .fit}) => MateoMenuButton(
  animation: const .pop(),
  buttonPresentation: const .icon(icon: Text('⋯'), variant: .secondary),
  menuPresentation: .options(
    width: width,
    items: [
      MateoMenuOptionsPresentationItem(
        principal: SizedBox(width: 160, height: height, child: const Text('Details')),
      ),
    ],
  ),
  onItemPressed: (_) {},
);
Widget host(Widget child, {GlobalKey<NavigatorState>? navigator, TextDirection direction = .ltr}) => MateoApp(
  navigatorKey: navigator,
  theme: surfaceTransformTheme,
  home: Directionality(textDirection: direction, child: child),
);
void main() {
  test('when selecting pop, it should expose a const style variant', () {
    const animation = MateoMenuButtonAnimation.pop();
    expect(animation, isA<MateoMenuButtonAnimationPop>());
  });
  for (final direction in TextDirection.values) {
    for (final trailing in [true, false]) {
      for (final width in MateoMenuWidth.values) {
        testWidgets(
          'when a ${trailing ? 'trailing' : 'leading'} header opens in $direction with $width, it should open below and shift inward',
          (tester) async {
            final trigger = button(width: width);
            await tester.pumpWidget(
              host(
                MateoView(
                  header: MateoViewHeader(
                    principal: const Text('Title'),
                    leading: trailing ? null : trigger,
                    trailing: trailing ? trigger : null,
                  ),
                  surface: const MateoViewSurface(child: SizedBox.expand()),
                ),
                direction: direction,
              ),
            );
            await tester.pumpAndSettle();
            final anchor = tester.getRect(find.byType(MateoMenuButton));
            await tester.tap(find.byType(MateoButton));
            await tester.pumpAndSettle();
            final menu = tester.getRect(find.byType(MateoMenu));
            expect(menu.top, closeTo(anchor.bottom + 8, .001));
            expect(menu.left, greaterThanOrEqualTo(20));
            expect(menu.right, lessThanOrEqualTo(780));
            expect(menu.width, greaterThan(anchor.width));
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  }
  for (final scenario in [
    (name: 'upper trigger', offset: const Offset(350, 50), height: 60.0, side: 'bottom'),
    (name: 'lower trigger', offset: const Offset(350, 480), height: 60.0, side: 'top'),
    (name: 'blocked vertical space with room right', offset: const Offset(100, 200), height: 400.0, side: 'right'),
    (name: 'blocked vertical and right space', offset: const Offset(680, 270), height: 400.0, side: 'left'),
    (name: 'oversized menu', offset: const Offset(350, 270), height: 900.0, side: 'overflow'),
  ]) {
    testWidgets('when opening from ${scenario.name}, it should preserve the selected edge gap', (tester) async {
      await tester.pumpWidget(
        host(
          Stack(
            children: [
              Positioned(
                left: scenario.offset.dx,
                top: scenario.offset.dy,
                child: button(height: scenario.height),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final anchor = tester.getRect(find.byType(MateoMenuButton));
      await tester.tap(find.byType(MateoButton));
      await tester.pumpAndSettle();
      final menu = tester.getRect(find.byType(MateoMenu));
      switch (scenario.side) {
        case 'bottom':
          expect(menu.top, anchor.bottom + 8);
        case 'top':
          expect(menu.bottom, anchor.top - 8);
        case 'right':
          expect(menu.left, anchor.right + 8);
        default:
          expect(menu.right, anchor.left - 8);
      }
      if (scenario.side == 'overflow') {
        expect(menu.center.dy, anchor.center.dy);
        expect(menu.height, greaterThan(600));
      } else {
        expect(menu.top, greaterThanOrEqualTo(20));
        expect(menu.bottom, lessThanOrEqualTo(580));
      }
    });
  }
  for (final asynchronous in [false, true]) {
    testWidgets(
      'when selecting with ${asynchronous ? 'asynchronous' : 'synchronous'} work, it should close and deliver the exact item once',
      (tester) async {
        final pending = Completer<void>();
        var calls = 0;
        const item = MateoMenuOptionsPresentationItem(principal: Text('Select'));
        await tester.pumpWidget(
          host(
            Center(
              child: MateoMenuButton(
                animation: const .pop(),
                buttonPresentation: const .label(label: 'Options', variant: .secondary, width: .fit),
                menuPresentation: .options(items: const [item]),
                onItemPressed: (selected) {
                  expect(identical(selected, item), isTrue);
                  calls++;
                  if (asynchronous) return pending.future;
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byType(MateoButton));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Select'));
        await tester.pump();
        expect(find.byType(MateoMenu), findsOneWidget);
        expect(calls, 1);
        await tester.pumpAndSettle();
        expect(find.byType(MateoMenu), findsNothing);
        pending.complete();
        await tester.pumpAndSettle();
      },
    );
  }

  testWidgets('when the viewport narrows or keyboard opens, it should reposition against the new overlay bounds', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpWidget(host(Stack(children: [Positioned(left: 300, top: 270, child: button())])));
    await tester.pumpAndSettle();
    final anchor = tester.getRect(find.byType(MateoMenuButton));
    await tester.tap(find.byType(MateoButton));
    await tester.pumpAndSettle();
    tester.view.physicalSize = const Size(500, 600);
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byType(MateoMenu)).right, lessThanOrEqualTo(480));
    tester.view.viewInsets = const FakeViewPadding(bottom: 200);
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byType(MateoMenu)).bottom, anchor.top - 8);
  });

  testWidgets(
    'when pop is scoped over a nested surface with reduced motion, it should isolate the content and keep the trigger untransformed',
    (tester) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(
        disableAnimations: true,
      );
      addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
      await tester.pumpWidget(
        host(
          Center(
            child: MateoMenuButton(
              animation: const .pop(),
              buttonPresentation: const .icon(icon: Text('⋯'), variant: .secondary),
              menuPresentation: .options(
                items: const [
                  MateoMenuOptionsPresentationItem(
                    principal: MateoSurface(key: ValueKey('nested'), child: Text('Nested')),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final triggerScope = tester.widget<MateoSurfaceScope>(
        find.descendant(of: find.byType(MateoMenuButton), matching: find.byType(MateoSurfaceScope)).first,
      );
      expect(triggerScope.animation, const MateoSurfaceAnimation.none());
      await tester.tap(find.byType(MateoButton));
      await tester.pumpAndSettle();
      final context = tester.element(find.byKey(const ValueKey('nested')));
      expect(MateoSurfaceScope.of(context).animation, const MateoSurfaceAnimation.none());
      expect(tester.binding.hasScheduledFrame, isFalse);
    },
  );

  for (final dismissal in ['outside tap', 'Escape', 'Back']) {
    testWidgets('when dismissed by $dismissal, it should restore focus and remove the menu after fading', (
      tester,
    ) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      final navigator = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        host(
          Focus(
            focusNode: focus,
            autofocus: true,
            child: Center(child: button()),
          ),
          navigator: navigator,
        ),
      );
      await tester.pumpAndSettle();
      expect(focus.hasFocus, isTrue);
      await tester.tap(find.byType(MateoButton));
      await tester.pumpAndSettle();
      expect(focus.hasFocus, isFalse);
      switch (dismissal) {
        case 'outside tap':
          await tester.tapAt(const Offset(10, 10));
        case 'Escape':
          await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        case 'Back':
          await navigator.currentState!.maybePop();
      }
      await tester.pump();
      expect(find.byType(MateoMenu), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byType(MateoMenu), findsNothing);
      expect(focus.hasFocus, isTrue);
    });
  }

  for (final duringEntrance in [true, false]) {
    testWidgets(
      'when dismissed ${duringEntrance ? 'during' : 'after'} entrance, it should fade without restarting entrance and allow reopening after removal',
      (tester) async {
        final navigator = GlobalKey<NavigatorState>();
        await tester.pumpWidget(host(Center(child: button()), navigator: navigator));
        await tester.pumpAndSettle();
        final trigger = tester.widget<MateoButton>(find.byType(MateoButton));
        trigger.onPressed!();
        trigger.onPressed!();
        await tester.pump();
        await tester.pump(Duration(milliseconds: duringEntrance ? 50 : 400));
        expect(find.byType(MateoMenu), findsOneWidget);
        expect(find.byType(MateoButton), findsOneWidget);
        final scopes = tester.widgetList<MateoSurfaceScope>(find.byType(MateoSurfaceScope));
        expect(scopes.any((scope) => scope.animation is MateoSurfaceAnimationPop), isTrue);
        navigator.currentState!.pop();
        await tester.pump();
        final menuElement = tester.element(find.byType(MateoMenu));
        trigger.onPressed!();
        await tester.pump(const Duration(milliseconds: 60));
        expect(tester.element(find.byType(MateoMenu)), same(menuElement));
        final fade = tester.widget<FadeTransition>(
          find.ancestor(of: find.byType(MateoMenu), matching: find.byType(FadeTransition)).first,
        );
        expect(fade.opacity.value, closeTo(.5, .01));
        await tester.pumpAndSettle();
        expect(find.byType(MateoMenu), findsNothing);
        trigger.onPressed!();
        await tester.pumpAndSettle();
        expect(find.byType(MateoMenu), findsOneWidget);
      },
    );
  }
}
