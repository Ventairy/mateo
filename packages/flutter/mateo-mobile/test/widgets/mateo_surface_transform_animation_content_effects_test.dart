import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

import '../fixtures/surface_transform_targets.dart';
import '../fixtures/surface_transform_test_widgets.dart';

List<Positioned> layers(WidgetTester tester) => tester
    .widgetList<Positioned>(
      find.descendant(of: surfaceFlight, matching: find.byType(Positioned)),
    )
    .toList();

void main() {
  testWidgets('when only effect settings change, it should retain the mounted transform target and child state', (
    tester,
  ) async {
    final animation = ValueNotifier<MateoSurfaceAnimation>(
      .transform(
        target: surfaceTransformTarget('stable'),
      ),
    );
    addTearDown(animation.dispose);
    final childKey = GlobalKey();
    await tester.pumpWidget(
      MateoApp(
        theme: surfaceTransformTheme,
        home: ValueListenableBuilder<MateoSurfaceAnimation>(
          valueListenable: animation,
          builder: (context, value, child) => surfaceTransformEndpoint(
            bounds: const Rect.fromLTWH(20, 40, 160, 64),
            animation: value,
            child: child!,
          ),
          child: StatefulBuilder(key: childKey, builder: (context, setState) => const Text('Stable')),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final target = tester.widget<Morph>(find.byType(Morph)).targets.first;
    final childState = childKey.currentState;
    animation.value = .transform(
      target: surfaceTransformTarget('stable'),
      contentEffects: [const .crossfade(curve: Curves.easeIn)],
    );
    await tester.pumpAndSettle();
    expect(tester.widget<Morph>(find.byType(Morph)).targets.first, same(target));
    expect(childKey.currentState, same(childState));
    expect(surfaceFlight, findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final curve in [Curves.easeOutBack, Curves.easeInBack]) {
    testWidgets('when scale overshoots with $curve, it should preserve valid scale without changing surface geometry', (
      tester,
    ) async {
      final navigator = GlobalKey<NavigatorState>();
      final animation = MateoSurfaceAnimation.transform(
        target: surfaceTransformTarget('overshoot', duration: const Duration(milliseconds: 1000), curve: Curves.linear),
        contentEffects: [
          const .crossfade(),
          .scale(curve: curve),
        ],
      );
      const source = Rect.fromLTWH(20, 40, 400, 20);
      const destination = Rect.fromLTWH(20, 40, 20, 400);
      await tester.pumpWidget(
        MateoApp(
          theme: surfaceTransformTheme,
          navigatorKey: navigator,
          home: surfaceTransformEndpoint(bounds: source, animation: animation),
        ),
      );
      await tester.pumpAndSettle();
      await startSurfaceTransformAnimationFlight(
        tester,
        navigator.currentState!,
        surfaceTransformEndpoint(bounds: destination, animation: animation),
      );
      final milliseconds = curve == Curves.easeOutBack ? 600 : 300;
      await tester.pump(Duration(milliseconds: milliseconds));
      final progress = milliseconds / 1000;
      final scaleProgress = curve.transform(progress);
      final contentLayers = layers(tester);
      final sourceScale = (1 + (.05 - 1) * scaleProgress).clamp(0.0, double.infinity);
      final destinationScale = (.05 + (1 - .05) * scaleProgress).clamp(0.0, double.infinity);
      expect(contentLayers.first.width, closeTo(400 * sourceScale, 1e-6));
      expect(contentLayers.first.height, closeTo(20 * sourceScale, 1e-6));
      expect(contentLayers.last.width, closeTo(20 * destinationScale, 1e-6));
      expect(contentLayers.last.height, closeTo(400 * destinationScale, 1e-6));
      expect(tester.getRect(surfaceFlight), rectMoreOrLessEquals(Rect.lerp(source, destination, progress)!));
      expect(tester.takeException(), isNull);
      await tester.pumpAndSettle();
      expect(surfaceFlight, findsNothing);
    });
  }

  for (final retarget in [false, true]) {
    testWidgets(
      'when effects use independent curves with retarget $retarget, it should sample their actual visible state',
      (tester) async {
        final navigator = GlobalKey<NavigatorState>();
        final animation = MateoSurfaceAnimation.transform(
          target: surfaceTransformTarget(
            'independent',
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutCubic,
          ),
          contentEffects: const [
            .scale(curve: Curves.easeInCubic),
            .crossfade(curve: Curves.linear),
          ],
        );
        Widget endpoint(Rect bounds) => surfaceTransformEndpoint(bounds: bounds, animation: animation);
        const sourceBounds = Rect.fromLTWH(20, 40, 160, 64);
        const destinationBounds = Rect.fromLTWH(40, 60, 240, 280);
        await tester.pumpWidget(
          MateoApp(theme: surfaceTransformTheme, navigatorKey: navigator, home: endpoint(sourceBounds)),
        );
        await tester.pumpAndSettle();
        await startSurfaceTransformAnimationFlight(tester, navigator.currentState!, endpoint(destinationBounds));
        var elapsedMilliseconds = 0;
        for (final milliseconds in [100, 200, 200]) {
          await tester.pump(Duration(milliseconds: milliseconds));
          elapsedMilliseconds += milliseconds;
          final elapsed = elapsedMilliseconds / 1000;
          final frame = Rect.lerp(sourceBounds, destinationBounds, Curves.easeOutCubic.transform(elapsed))!;
          final scaleProgress = Curves.easeInCubic.transform(elapsed);
          expect(tester.getRect(surfaceFlight), rectMoreOrLessEquals(frame));
          final contentLayers = layers(tester);
          for (var index = 0; index < 2; index++) {
            final layer = contentLayers[index];
            final endpointSize = index == 0 ? sourceBounds.size : destinationBounds.size;
            final scale = index == 0 ? 1 + .5 * scaleProgress : (64 / 280) + (1 - 64 / 280) * scaleProgress;
            final expected = endpointSize * scale;
            expect(layer.width, closeTo(expected.width, 1e-6));
            expect(layer.height, closeTo(expected.height, 1e-6));
            expect(layer.left! + layer.width! / 2, closeTo(frame.width / 2, 1e-6));
            expect(layer.top! + layer.height! / 2, closeTo(frame.height / 2, 1e-6));
            expect((layer.child as Opacity).opacity, closeTo(index == 0 ? 1 - elapsed : elapsed, 1e-6));
          }
        }
        List<(double?, double?, double?, double?, double)> composition() => [
          for (final layer in layers(tester))
            (layer.left, layer.top, layer.width, layer.height, (layer.child as Opacity).opacity),
        ];
        final before = composition();
        if (retarget) {
          await startSurfaceTransformAnimationFlight(
            tester,
            navigator.currentState!,
            endpoint(const Rect.fromLTWH(80, 100, 320, 180)),
          );
        } else {
          navigator.currentState!.pop();
          await tester.pump();
          await tester.pump();
        }
        expect(composition(), before);
        await tester.pumpAndSettle();
        expect(surfaceFlight, findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final interrupt in [false, true]) {
    testWidgets(
      'when endpoint curves differ and interruption is $interrupt, it should use the source flight configuration',
      (tester) async {
        final navigator = GlobalKey<NavigatorState>();
        final trigger = MateoSurfaceAnimation.transform(
          target: surfaceTransformTarget('owned', duration: const Duration(milliseconds: 1000)),
          contentEffects: const [.crossfade(curve: Curves.linear)],
        );
        final panel = MateoSurfaceAnimation.transform(
          target: surfaceTransformTarget('owned', duration: const Duration(milliseconds: 1000)),
          contentEffects: const [.crossfade(curve: Interval(0, .35, curve: Curves.easeOut))],
        );
        await tester.pumpWidget(
          MateoApp(
            theme: surfaceTransformTheme,
            navigatorKey: navigator,
            home: surfaceTransformEndpoint(bounds: const Rect.fromLTWH(20, 40, 160, 64), animation: trigger),
          ),
        );
        await tester.pumpAndSettle();
        await startSurfaceTransformAnimationFlight(
          tester,
          navigator.currentState!,
          surfaceTransformEndpoint(bounds: const Rect.fromLTWH(40, 60, 240, 280), animation: panel),
        );
        await tester.pump(const Duration(milliseconds: 500));
        expect((layers(tester).first.child as Opacity).opacity, closeTo(.5, 1e-6));
        if (!interrupt) await tester.pumpAndSettle();
        navigator.currentState!.pop();
        await tester.pump();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        if (interrupt) {
          expect((layers(tester).first.child as Opacity).opacity, closeTo(.6, 1e-6));
        } else {
          expect(
            (layers(tester).first.child as Opacity).opacity,
            closeTo(1 - const Interval(0, .35, curve: Curves.easeOut).transform(.1), 1e-6),
          );
          await tester.pump(const Duration(milliseconds: 250));
          expect(layers(tester), hasLength(1));
          expect(layers(tester).single.width, closeTo(160, 1e-6));
        }
        await tester.pumpAndSettle();
        expect(surfaceFlight, findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final scale in [false, true]) {
    testWidgets('when conflicting ${scale ? 'scale' : 'crossfade'} effects are resolved, it should reject them', (
      tester,
    ) async {
      await tester.pumpWidget(
        MateoApp(
          theme: surfaceTransformTheme,
          home: surfaceTransformEndpoint(
            bounds: const Rect.fromLTWH(20, 40, 160, 64),
            animation: MateoSurfaceAnimation.transform(
              target: surfaceTransformTarget('conflict'),
              contentEffects: scale
                  ? [const .scale(), const .scale(curve: Curves.linear)]
                  : [const .crossfade(), const .crossfade(curve: Curves.linear)],
            ),
          ),
        ),
      );
      expect(tester.takeException(), isArgumentError);
    });
  }

  testWidgets('when identical effects repeat, it should render a single pair of content layers', (tester) async {
    final navigator = GlobalKey<NavigatorState>();
    final animation = MateoSurfaceAnimation.transform(
      target: surfaceTransformTarget('duplicates'),
      contentEffects: const [.crossfade(), .scale(), .crossfade(), .scale()],
    );
    Widget endpoint(double width) =>
        surfaceTransformEndpoint(bounds: Rect.fromLTWH(20, 40, width, 80), animation: animation);
    await tester.pumpWidget(MateoApp(theme: surfaceTransformTheme, navigatorKey: navigator, home: endpoint(160)));
    await tester.pumpAndSettle();
    await startSurfaceTransformAnimationFlight(tester, navigator.currentState!, endpoint(240));
    await tester.pump(const Duration(milliseconds: 80));
    expect(layers(tester), hasLength(2));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  for (final scale in [false, true]) {
    for (final crossfade in [false, true]) {
      final effects = <MateoTransformAnimationContentEffect>[
        if (scale) const .scale(),
        if (crossfade) const .crossfade(),
      ];
      for (final reverse in [false, true]) {
        testWidgets(
          'when scale is $scale and crossfade is $crossfade with reversal $reverse, it should preserve flight content',
          (tester) async {
            final navigator = GlobalKey<NavigatorState>();
            final animation = MateoSurfaceAnimation.transform(
              target: surfaceTransformTarget(
                'effects',
                duration: const Duration(milliseconds: 1000),
                curve: Curves.linear,
              ),
              contentEffects: effects,
            );
            Widget endpoint(Rect bounds) => surfaceTransformEndpoint(
              bounds: bounds,
              animation: animation,
              child: const Text('Content'),
            );
            await tester.pumpWidget(
              MateoApp(
                theme: surfaceTransformTheme,
                navigatorKey: navigator,
                home: endpoint(const Rect.fromLTWH(20, 40, 160, 64)),
              ),
            );
            await tester.pumpAndSettle();
            await startSurfaceTransformAnimationFlight(
              tester,
              navigator.currentState!,
              endpoint(const Rect.fromLTWH(40, 60, 240, 280)),
            );
            await tester.pump(const Duration(milliseconds: 499));
            void check(double progress) {
              final contentLayers = layers(tester);
              expect(contentLayers, hasLength(crossfade ? 2 : 1));
              final sourceVisible = progress < .5;
              for (var i = 0; i < contentLayers.length; i++) {
                final layer = contentLayers[i];
                final source = crossfade ? i == 0 : sourceVisible;
                final size = source ? const Size(160, 64) : const Size(240, 280);
                expect(
                  (layer.child as Opacity).opacity,
                  closeTo(crossfade ? (source ? 1 - progress : progress) : 1, 1e-6),
                );
                if (!scale) {
                  expect(layer.width, closeTo(size.width, 1e-6));
                  expect(layer.height, closeTo(size.height, 1e-6));
                } else {
                  expect(layer.width! / layer.height!, closeTo(size.aspectRatio, 1e-6));
                }
                final flightSize = tester.getSize(surfaceFlight);
                expect(layer.left! + layer.width! / 2, closeTo(flightSize.width / 2, 1e-6));
                expect(layer.top! + layer.height! / 2, closeTo(flightSize.height / 2, 1e-6));
              }
              expect(find.descendant(of: surfaceFlight, matching: find.byType(ClipPath)), findsOneWidget);
              expect(
                tester.getRect(surfaceFlight),
                rectMoreOrLessEquals(
                  Rect.lerp(
                    const Rect.fromLTWH(20, 40, 160, 64),
                    const Rect.fromLTWH(40, 60, 240, 280),
                    progress,
                  )!,
                ),
              );
            }

            check(.499);
            await tester.pump(const Duration(milliseconds: 1));
            check(.5);
            await tester.pump(const Duration(milliseconds: 1));
            check(.501);
            List<(double?, double?, double?, double?, double)> composition() => [
              for (final layer in layers(tester))
                (layer.left, layer.top, layer.width, layer.height, (layer.child as Opacity).opacity),
            ];
            final before = composition();
            if (reverse) {
              navigator.currentState!.pop();
              await tester.pump();
              await tester.pump();
            } else {
              await startSurfaceTransformAnimationFlight(
                tester,
                navigator.currentState!,
                endpoint(const Rect.fromLTWH(80, 100, 320, 180)),
              );
            }
            expect(composition(), before);
            await tester.pump(const Duration(milliseconds: 100));
            expect(tester.takeException(), isNull);
            await tester.pumpAndSettle();
            expect(surfaceFlight, findsNothing);
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  }
  testWidgets('when content has an ancestor scale, it should retain its painted dimensions without flight scaling', (
    tester,
  ) async {
    final navigator = GlobalKey<NavigatorState>();
    final animation = MateoSurfaceAnimation.transform(
      target: surfaceTransformTarget('scaled'),
      contentEffects: const [.crossfade()],
    );
    await tester.pumpWidget(
      MateoApp(
        theme: surfaceTransformTheme,
        navigatorKey: navigator,
        home: Transform.scale(
          scaleX: 1.5,
          scaleY: .75,
          alignment: .topLeft,
          child: surfaceTransformEndpoint(bounds: const Rect.fromLTWH(20, 40, 160, 64), animation: animation),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await startSurfaceTransformAnimationFlight(
      tester,
      navigator.currentState!,
      surfaceTransformEndpoint(
        bounds: const Rect.fromLTWH(40, 60, 320, 280),
        animation: animation,
      ),
    );
    await tester.pump(const Duration(milliseconds: 80));
    final contentLayers = layers(tester);
    expect(contentLayers.first.width, closeTo(240, 1e-6));
    expect(contentLayers.first.height, closeTo(48, 1e-6));
    expect(contentLayers.last.width, 320);
    expect(contentLayers.last.height, 280);
    await tester.pumpAndSettle();
    navigator.currentState!.pop();
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));
    expect(layers(tester).last.width, closeTo(240, 1e-6));
    expect(layers(tester).last.height, closeTo(48, 1e-6));
    await tester.pumpAndSettle();
    expect(surfaceFlight, findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('when eased progress crosses the midpoint, it should switch content before half the elapsed duration', (
    tester,
  ) async {
    final navigator = GlobalKey<NavigatorState>();
    final animation = MateoSurfaceAnimation.transform(
      target: surfaceTransformTarget('eased'),
      contentEffects: const [],
    );
    Widget endpoint(Size size) => surfaceTransformEndpoint(
      bounds: Offset.zero & size,
      animation: animation,
    );
    await tester.pumpWidget(
      MateoApp(theme: surfaceTransformTheme, navigatorKey: navigator, home: endpoint(const Size(160, 64))),
    );
    await tester.pumpAndSettle();
    await startSurfaceTransformAnimationFlight(tester, navigator.currentState!, endpoint(const Size(240, 280)));
    await tester.pump(const Duration(milliseconds: 80));
    expect(Curves.easeOutCubic.transform(80 / 230), greaterThan(.5));
    expect(layers(tester).single.width, 240);
    expect(layers(tester).single.height, 280);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('when transform duration is zero, it should complete without a remaining flight', (tester) async {
    final navigator = GlobalKey<NavigatorState>();
    final animation = MateoSurfaceAnimation.transform(
      target: surfaceTransformTarget('zero', duration: Duration.zero),
    );
    Widget endpoint(double width) => surfaceTransformEndpoint(
      bounds: Rect.fromLTWH(20, 40, width, 80),
      animation: animation,
    );
    await tester.pumpWidget(MateoApp(theme: surfaceTransformTheme, navigatorKey: navigator, home: endpoint(160)));
    await tester.pumpAndSettle();
    await startSurfaceTransformAnimationFlight(tester, navigator.currentState!, endpoint(240));
    await tester.pumpAndSettle();
    expect(surfaceFlight, findsNothing);
    expect(tester.takeException(), isNull);
  });
}
