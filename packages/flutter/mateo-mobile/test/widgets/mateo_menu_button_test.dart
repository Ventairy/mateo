import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_surface/base_mateo_surface.dart';

import '../fixtures/surface_transform_test_widgets.dart';

void main() {
  testWidgets('when activated, the trigger should transform into the menu and return without loading', (tester) async {
    final navigator = GlobalKey<NavigatorState>();
    Object? id;
    var calls = 0;
    for (final icon in [false, true, false]) {
      await tester.pumpWidget(
        MateoApp(
          theme: surfaceTransformTheme,
          navigatorKey: navigator,
          home: Center(
            child: MateoMenuButton(
              animation: const .transform(),
              buttonPresentation: icon
                  ? const .icon(icon: MateoIcon(.cross), variant: .primary)
                  : const .label(label: 'Options', variant: .secondary),
              menuPresentation: .options(
                items: const [MateoMenuOptionsPresentationItem(principal: Text('Menu item'))],
              ),
              onItemPressed: (_) {
                calls++;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final animation =
          tester.widget<BaseMateoSurface>(find.byType(BaseMateoSurface)).animation as MateoSurfaceAnimationTransform;
      id ??= animation.id;
      expect(animation.id, same(id));
      expect(animation.contentEffects, const <MateoSurfaceTransformAnimationContentEffect>[
        .crossfade(curve: Interval(0, 0.35, curve: Curves.easeOut)),
      ]);
      expect(animation.duration, const Duration(milliseconds: 170));
      expect(animation.curve, const Cubic(0.35, 1, 0.35, 1));
      expect(animation.curve.transform(0), 0);
      expect(animation.curve.transform(1), 1);
      var previous = 0.0;
      for (var sample = 1; sample <= 100; sample++) {
        final progress = animation.curve.transform(sample / 100);
        expect(progress, inInclusiveRange(previous, 1));
        previous = progress;
      }
      // The last tenth of the flight travels less than a tenth of a percent.
      expect(1 - animation.curve.transform(0.9), lessThan(0.001));
      final press = tester.widget<MateoPress>(find.byType(MateoPress));
      final child = tester.renderObject<RenderBox>(find.byWidget(press.child));
      final target = tester.renderObject<RenderBox>(find.byType(MateoPress));
      final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoPress)));
      await tester.pumpAndSettle();
      expect(child.getTransformTo(target).storage[0], lessThan(1));
      await gesture.up();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));
      expect(surfaceFlight, findsOneWidget);
      expect(find.byType(MateoLoadingIndicator), findsNothing);
      await tester.pumpAndSettle();
      expect(calls, 0);
      expect(find.text('Menu item'), findsOneWidget);
      final endpoints = tester.widgetList<BaseMateoSurface>(find.byType(BaseMateoSurface)).toList();
      final panelAnimation = endpoints.last.animation as MateoSurfaceAnimationTransform;
      expect(panelAnimation.id, same(animation.id));
      expect(panelAnimation.curve, animation.curve);
      expect(panelAnimation.duration, animation.duration);
      expect(
        (panelAnimation.contentEffects.single as MateoSurfaceTransformAnimationContentEffectCrossfade).curve,
        const Interval(0, 0.3, curve: Curves.easeOut),
      );
      navigator.currentState!.pop();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));
      expect(surfaceFlight, findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byType(MateoMenu), findsNothing);
      expect(surfaceFlight, findsNothing);
      expect(child.getTransformTo(target).storage[0], 1);
    }
  });
  testWidgets('separate triggers have distinct identities and isolate nested surfaces', (tester) async {
    Widget button() => MateoMenuButton(
      animation: const .transform(),
      buttonPresentation: const .label(
        label: 'Options',
        variant: .secondary,
        leadingIcon: MateoSurface(child: SizedBox(width: 12, height: 12)),
      ),
      menuPresentation: .options(items: const [MateoMenuOptionsPresentationItem()]),
    );
    await tester.pumpWidget(
      MateoApp(
        theme: surfaceTransformTheme,
        home: Column(children: [button(), button()]),
      ),
    );
    await tester.pumpAndSettle();
    final animations = tester
        .widgetList<BaseMateoSurface>(find.byType(BaseMateoSurface))
        .map((s) => s.animation)
        .toList();
    expect(animations, hasLength(4));
    expect(
      (animations[0] as MateoSurfaceAnimationTransform).id,
      isNot((animations[2] as MateoSurfaceAnimationTransform).id),
    );
    expect(animations[1], const MateoSurfaceAnimation.none());
    expect(animations[3], const MateoSurfaceAnimation.none());
    expect(tester.takeException(), isNull);
  });
}
