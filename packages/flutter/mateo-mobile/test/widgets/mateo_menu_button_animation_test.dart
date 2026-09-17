import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/base_mateo_surface.dart';

import '../fixtures/surface_transform_test_widgets.dart';

void main() {
  test('when constructed as const, transform should own the timing and each endpoint content treatment', () {
    const animation = MateoMenuButtonAnimationTransform();
    expect(identical(animation, const MateoMenuButtonAnimation.transform()), isTrue);
    expect(animation.duration, const Duration(milliseconds: 230));
    expect(animation.curve, const Cubic(.35, 1, .35, 1));
    expect(animation.buttonContentEffects, const <MateoSurfaceTransformAnimationContentEffect>[
      .crossfade(curve: Interval(0, .35, curve: Curves.easeOut)),
    ]);
    expect(animation.menuContentEffects, const <MateoSurfaceTransformAnimationContentEffect>[
      .crossfade(curve: Interval(0, .3, curve: Curves.easeOut)),
    ]);
  });

  test('when constructed as const, pop should own separate entrance and exit timing', () {
    const animation = MateoMenuButtonAnimationPop();
    expect(identical(animation, const MateoMenuButtonAnimation.pop()), isTrue);
    expect(animation.duration, const Duration(milliseconds: 400));
    expect(animation.curve, Curves.easeOutBack);
    expect(animation.exitDuration, const Duration(milliseconds: 210));
    expect(animation.exitCurve, Curves.easeInCubic);
  });

  for (final animation in const <MateoMenuButtonAnimation>[.transform(), .pop()]) {
    testWidgets('when opening with ${animation.runtimeType}, it should forward configuration to surfaces and route', (
      tester,
    ) async {
      final navigator = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MateoApp(
          navigatorKey: navigator,
          theme: surfaceTransformTheme,
          home: Center(
            child: MateoMenuButton(
              animation: animation,
              buttonPresentation: const .label(label: 'Options', variant: .secondary, width: .fit),
              menuPresentation: .options(items: const [MateoMenuOptionsPresentationItem(principal: Text('Details'))]),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final trigger = tester.widget<BaseMateoSurface>(find.byType(BaseMateoSurface)).animation;
      if (animation case MateoMenuButtonAnimationTransform()) {
        final transform = trigger as MateoSurfaceAnimationTransform;
        expect(transform.duration, animation.duration);
        expect(transform.curve, animation.curve);
        expect(identical(transform.contentEffects, animation.buttonContentEffects), isTrue);
      } else {
        expect(trigger, const MateoSurfaceAnimation.none());
      }
      await tester.tap(find.byType(MateoButton));
      await tester.pumpAndSettle();
      final menu = find.byType(MateoMenu);
      final surface = tester
          .widget<BaseMateoSurface>(find.descendant(of: menu, matching: find.byType(BaseMateoSurface)))
          .animation;
      final route = ModalRoute.of(tester.element(menu))!;
      switch (animation) {
        case MateoMenuButtonAnimationTransform():
          final transform = surface as MateoSurfaceAnimationTransform;
          expect(transform.duration, animation.duration);
          expect(transform.curve, animation.curve);
          expect(identical(transform.contentEffects, animation.menuContentEffects), isTrue);
          expect(route.transitionDuration, animation.duration);
          expect(route.reverseTransitionDuration, animation.duration);
        case MateoMenuButtonAnimationPop():
          final pop = surface as MateoSurfaceAnimationPop;
          expect(pop.duration, animation.duration);
          expect(pop.curve, animation.curve);
          expect(route.transitionDuration, Duration.zero);
          expect(route.reverseTransitionDuration, animation.exitDuration);
      }
      final settledBounds = tester.getRect(menu);
      navigator.currentState!.pop();
      await tester.pump();
      if (animation case MateoMenuButtonAnimationPop()) {
        await tester.pump(animation.exitDuration ~/ 2);
        final fade = tester.widget<FadeTransition>(
          find.ancestor(of: menu, matching: find.byType(FadeTransition)).first,
        );
        expect(fade.opacity.value, closeTo(animation.exitCurve.transform(.5), .001));
        final scale = tester.widget<ScaleTransition>(
          find.ancestor(of: menu, matching: find.byType(ScaleTransition)).first,
        );
        final expectedScale = .95 + .05 * fade.opacity.value;
        expect(scale.scale.value, closeTo(expectedScale, .001));
        final exitingBounds = tester.getRect(menu);
        expect(exitingBounds.center.dx, closeTo(settledBounds.center.dx, .001));
        expect(exitingBounds.center.dy, closeTo(settledBounds.center.dy, .001));
        expect(exitingBounds.width, closeTo(settledBounds.width * expectedScale, .001));
      }
      await tester.pumpAndSettle();
      expect(menu, findsNothing);
    });
  }
}
