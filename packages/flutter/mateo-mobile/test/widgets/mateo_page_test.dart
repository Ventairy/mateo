import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });
  group('MateoPage', () {
    _testWidgets(
      'when transition is omitted on Android, it should create a native Material route',
      (tester) async {
        final capture = await _captureRoute<int>(
          tester,
          platform: TargetPlatform.android,
          page: const MateoPage<int>(child: SizedBox()),
        );

        expect(capture.route, isA<PageRoute<int>>());
        expect(capture.route.settings, same(capture.page));
      },
    );

    _testWidgets(
      'when transition is omitted on iOS, it should create a native Cupertino route',
      (tester) async {
        final capture = await _captureRoute<int>(
          tester,
          platform: TargetPlatform.iOS,
          page: const MateoPage<int>(title: 'Job', child: SizedBox()),
        );

        expect(capture.route, isA<CupertinoRouteTransitionMixin<int>>());
        expect(capture.route.settings, same(capture.page));
        expect(
          (capture.route as CupertinoRouteTransitionMixin<int>).title,
          'Job',
        );
      },
    );

    _testWidgets(
      'when native iOS navigation is swiped from the edge, it should pop the page',
      (tester) async {
        await _pumpPushApp(
          tester,
          platform: TargetPlatform.iOS,
          page: const MateoPage<void>(
            child: ColoredBox(
              key: _destinationKey,
              color: CupertinoColors.systemBlue,
            ),
          ),
        );

        await tester.dragFrom(const Offset(1, 300), const Offset(700, 0));
        await tester.pumpAndSettle();

        expect(find.byKey(_destinationKey), findsNothing);
      },
    );

    _testWidgets(
      'when an explicit Mateo transition is used on iOS, it should not start an edge-swipe pop',
      (tester) async {
        for (final transition in [
          const MateoPageTransition.wash(),
          const MateoPageTransition.push(),
          const MateoPageTransition.slide(),
        ]) {
          await _pumpPushApp(
            tester,
            platform: TargetPlatform.iOS,
            page: MateoPage<void>(
              transition: transition,
              child: const ColoredBox(
                key: _destinationKey,
                color: CupertinoColors.systemBlue,
              ),
            ),
          );

          await tester.dragFrom(const Offset(1, 300), const Offset(700, 0));
          await tester.pumpAndSettle();

          expect(find.byKey(_destinationKey), findsOneWidget);
        }
      },
    );

    _testWidgets(
      'when Android predictive back updates push, it should track the gesture linearly',
      (tester) async {
        await _pumpPushTransitionApp(
          tester,
          direction: MateoPageTransitionDirection.left,
        );
        await tester.tap(find.byKey(_openKey));
        await tester.pumpAndSettle();

        await _sendBackGesture(
          tester,
          const MethodCall('startBackGesture', <String, Object>{
            'touchOffset': <double>[5, 300],
            'progress': 0.0,
            'swipeEdge': 0,
          }),
        );
        await _sendBackGesture(
          tester,
          const MethodCall('updateBackGestureProgress', <String, Object>{
            'touchOffset': <double>[200, 300],
            'progress': 0.25,
            'swipeEdge': 0,
          }),
        );
        await tester.pump();

        final sourceRect = tester.getRect(find.byKey(_sourceKey));
        final destinationRect = tester.getRect(find.byKey(_destinationKey));

        await _sendBackGesture(tester, const MethodCall('cancelBackGesture'));
        await tester.pumpAndSettle();

        expect(sourceRect.right, closeTo(200, 0.001));
        expect(destinationRect.left, closeTo(200, 0.001));
        expect(find.byKey(_destinationKey), findsOneWidget);
      },
    );

    _testWidgets(
      'when Android predictive back commits wash, it should pop the page',
      (tester) async {
        await _pumpPushApp(
          tester,
          platform: TargetPlatform.android,
          page: const MateoPage<void>(
            transition: MateoPageTransition.wash(),
            child: ColoredBox(key: _destinationKey, color: Colors.blue),
          ),
        );

        await _sendBackGesture(
          tester,
          const MethodCall('startBackGesture', <String, Object>{
            'touchOffset': <double>[5, 300],
            'progress': 0.0,
            'swipeEdge': 0,
          }),
        );
        await _sendBackGesture(
          tester,
          const MethodCall('updateBackGestureProgress', <String, Object>{
            'touchOffset': <double>[300, 300],
            'progress': 0.35,
            'swipeEdge': 0,
          }),
        );
        await tester.pump();
        await _sendBackGesture(tester, const MethodCall('commitBackGesture'));
        await tester.pumpAndSettle();

        expect(find.byKey(_destinationKey), findsNothing);
      },
    );

    _testWidgets(
      'when wash enters over a native route, it should keep the source stationary',
      (tester) async {
        await _pumpPushApp(
          tester,
          platform: TargetPlatform.android,
          settle: false,
          tapToPush: false,
          page: const MateoPage<void>(
            transition: MateoPageTransition.wash(),
            child: ColoredBox(color: Colors.blue),
          ),
        );
        await tester.pump(const Duration(milliseconds: 16));
        final earlyPosition = tester.getTopLeft(find.byKey(_openKey));

        await tester.pump(const Duration(milliseconds: 300));

        expect(tester.getTopLeft(find.byKey(_openKey)), earlyPosition);
      },
    );

    _testWidgets(
      'when wash opens and closes in every direction, it should preserve its edge origin',
      (tester) async {
        for (final direction in MateoPageTransitionDirection.values) {
          await _pumpPushApp(
            tester,
            platform: TargetPlatform.android,
            settle: false,
            page: MateoPage<void>(
              transition: MateoPageTransition.wash(direction: direction),
              child: const ColoredBox(key: _destinationKey, color: Colors.blue),
            ),
          );
          await tester.pump(const Duration(milliseconds: 100));

          _expectWashOrigin(tester, direction);

          await tester.pumpAndSettle();
          Navigator.of(tester.element(find.byKey(_destinationKey))).pop();
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 500));

          _expectWashOrigin(tester, direction);

          await tester.pumpAndSettle();
        }
      },
    );

    _testWidgets(
      'when push opens and closes, it should blend the source without exposing destination content',
      (tester) async {
        await _pumpPushTransitionApp(
          tester,
          direction: MateoPageTransitionDirection.left,
        );
        await tester.tap(find.byKey(_openKey));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        _expectPagesAttached(tester, MateoPageTransitionDirection.left);
        _expectEdgeBackedSourceFade(tester);

        await tester.pumpAndSettle();
        await tester.tap(find.byKey(_closeKey));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        _expectPagesAttached(tester, MateoPageTransitionDirection.left);
        _expectEdgeBackedSourceFade(tester);
      },
    );

    _testWidgets(
      'when a route without delegated motion covers push, it should stay still until it is popped',
      (tester) async {
        await _pumpPushApp(
          tester,
          platform: TargetPlatform.android,
          page: const MateoPage<void>(
            transition: MateoPageTransition.push(),
            child: ColoredBox(key: _destinationKey, color: Colors.blue),
          ),
        );
        final destination = find.byKey(_destinationKey);
        final navigator = Navigator.of(tester.element(destination));
        final coveringRoute = PageRouteBuilder<void>(
          opaque: false,
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) => const SizedBox(key: ValueKey('covering-route')),
        );

        navigator.push(coveringRoute);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(tester.getTopLeft(destination), Offset.zero);

        navigator.pop();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(tester.getTopLeft(destination), Offset.zero);

        await tester.pumpAndSettle();
        navigator.pop();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(tester.getTopLeft(destination).dy, greaterThan(0));
      },
    );

    _testWidgets(
      'when push blends pages, it should avoid translucent opacity and shader layers',
      (tester) async {
        await _pumpPushTransitionApp(
          tester,
          direction: MateoPageTransitionDirection.left,
        );
        await tester.tap(find.byKey(_openKey));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        final rootLayer = tester.binding.renderViews.single.debugLayer;

        expect(
          _findLayers<OpacityLayer>(
            rootLayer,
          ).where((layer) => (layer.alpha ?? 255) < 255),
          isEmpty,
        );
        expect(_findLayer<ColorFilterLayer>(rootLayer), isNull);
        expect(_findLayer<ShaderMaskLayer>(rootLayer), isNull);
      },
    );

    _testWidgets(
      'when push blends pages, it should avoid full-viewport snapshots',
      (tester) async {
        await _pumpPushTransitionApp(
          tester,
          direction: MateoPageTransitionDirection.left,
        );
        await tester.tap(find.byKey(_openKey));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.byType(SnapshotWidget), findsNothing);
      },
    );

    _testWidgets(
      'when push viewport changes mid-transition, it should keep both pages attached',
      (tester) async {
        await _pumpPushTransitionApp(
          tester,
          direction: MateoPageTransitionDirection.left,
        );
        await tester.tap(find.byKey(_openKey));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 120));

        await tester.binding.setSurfaceSize(const Size(600, 800));
        await tester.pump(const Duration(milliseconds: 16));

        _expectPagesAttached(tester, MateoPageTransitionDirection.left);
        expect(tester.takeException(), isNull);
      },
    );

    _testWidgets(
      'when push animates, it should avoid animation-driven widget rebuilds',
      (tester) async {
        await _pumpPushTransitionApp(
          tester,
          direction: MateoPageTransitionDirection.left,
        );
        await tester.tap(find.byKey(_openKey));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        final animatedAncestors = find.ancestor(
          of: find.byKey(_destinationKey),
          matching: find.byWidgetPredicate(
            (widget) => widget is AnimatedWidget && widget.runtimeType.toString() == '_MateoPushPageTransitionView',
          ),
        );

        expect(animatedAncestors, findsNothing);
      },
    );

    _testWidgets(
      'when Mateo transitions animate, they should retain both routed page rasters',
      (tester) async {
        for (final transition in [
          const MateoPageTransition.wash(),
          const MateoPageTransition.push(),
          const MateoPageTransition.slide(),
        ]) {
          var sourcePaintCount = 0;
          var destinationPaintCount = 0;
          await _pumpPushApp(
            tester,
            platform: TargetPlatform.android,
            settle: false,
            tapToPush: false,
            onSourcePaint: () => sourcePaintCount += 1,
            page: MateoPage<void>(
              transition: transition,
              child: _PaintCounter(
                onPaint: () => destinationPaintCount += 1,
                child: const ColoredBox(color: Colors.blue),
              ),
            ),
          );
          await tester.pump(const Duration(milliseconds: 16));
          await tester.pump(const Duration(milliseconds: 16));

          final retainedSourcePaintCount = sourcePaintCount;
          final retainedDestinationPaintCount = destinationPaintCount;
          expect(retainedSourcePaintCount, greaterThan(0));
          expect(retainedDestinationPaintCount, greaterThan(0));

          for (var frame = 0; frame < 10; frame++) {
            await tester.pump(const Duration(milliseconds: 16));
          }

          expect(sourcePaintCount, retainedSourcePaintCount);
          expect(destinationPaintCount, retainedDestinationPaintCount);
        }
      },
    );

    _testWidgets(
      'when wash opens, it should reveal a stationary snapshotted destination through a gradient',
      (tester) async {
        await _pumpPushApp(
          tester,
          platform: TargetPlatform.android,
          settle: false,
          page: const MateoPage<void>(
            transition: MateoPageTransition.wash(),
            child: ColoredBox(key: _destinationKey, color: Colors.blue),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));
        final earlyPosition = tester.getTopLeft(find.byKey(_destinationKey));
        await tester.pump(const Duration(milliseconds: 200));
        final laterPosition = tester.getTopLeft(find.byKey(_destinationKey));

        expect(find.byType(SnapshotWidget), findsOneWidget);
        expect(find.byType(ShaderMask), findsNothing);
        expect(
          find.ancestor(
            of: find.byKey(_destinationKey),
            matching: find.byType(SlideTransition),
          ),
          findsNothing,
        );
        expect(
          find.ancestor(
            of: find.byKey(_destinationKey),
            matching: find.byType(FadeTransition),
          ),
          findsNothing,
        );
        expect(earlyPosition, Offset.zero);
        expect(laterPosition, earlyPosition);
      },
    );

    _testWidgets(
      'when wash reveals a snapshot, it should crop painting to the active circle without a clip layer',
      (tester) async {
        await _pumpPushApp(
          tester,
          platform: TargetPlatform.android,
          settle: false,
          page: const MateoPage<void>(
            transition: MateoPageTransition.wash(),
            child: ColoredBox(key: _destinationKey, color: Colors.blue),
          ),
        );
        await tester.pump(const Duration(milliseconds: 16));

        final snapshot = find.byType(SnapshotWidget);
        final snapshotSize = tester.getSize(snapshot);
        final shaderLayer = _findLayer<ShaderMaskLayer>(
          tester.binding.renderViews.single.debugLayer,
        );
        final clipLayer = _findLayer<ClipRectLayer>(shaderLayer);

        expect(shaderLayer, isNotNull);
        expect(clipLayer, isNull);
        expect(shaderLayer!.maskRect!.width, lessThan(snapshotSize.width));
        expect(shaderLayer.maskRect!.height, lessThan(snapshotSize.height));
      },
    );

    _testWidgets(
      'when wash opens, it should keep the reveal moving beyond the midpoint',
      (tester) async {
        await _pumpPushApp(
          tester,
          platform: TargetPlatform.android,
          settle: false,
          page: const MateoPage<void>(
            transition: MateoPageTransition.wash(
              direction: MateoPageTransitionDirection.left,
            ),
            child: ColoredBox(key: _destinationKey, color: Colors.blue),
          ),
        );
        await tester.pump(const Duration(milliseconds: 300));

        final snapshotSize = tester.getSize(find.byType(SnapshotWidget));
        final midpointShaderLayer = _findLayer<ShaderMaskLayer>(
          tester.binding.renderViews.single.debugLayer,
        );
        final midpointActiveRect = midpointShaderLayer!.maskRect!;

        expect(midpointActiveRect, isNot(Offset.zero & snapshotSize));

        await tester.pump(const Duration(milliseconds: 200));
        final laterShaderLayer = _findLayer<ShaderMaskLayer>(
          tester.binding.renderViews.single.debugLayer,
        );
        final laterActiveRect = laterShaderLayer!.maskRect!;

        expect(laterActiveRect.width, greaterThan(midpointActiveRect.width));
      },
    );

    _testWidgets(
      'when snapshotting is disabled, it should clip live painting to the active circle',
      (tester) async {
        await _pumpPushApp(
          tester,
          platform: TargetPlatform.android,
          settle: false,
          page: const MateoPage<void>(
            transition: MateoPageTransition.wash(),
            allowSnapshotting: false,
            child: ColoredBox(key: _destinationKey, color: Colors.blue),
          ),
        );
        await tester.pump(const Duration(milliseconds: 16));

        final shaderLayer = _findLayer<ShaderMaskLayer>(
          tester.binding.renderViews.single.debugLayer,
        );
        final clipLayer = _findLayer<ClipRectLayer>(shaderLayer);

        expect(shaderLayer, isNotNull);
        expect(clipLayer, isNotNull);
        final clipRect = clipLayer!.clipRect!;
        expect(
          shaderLayer!.maskRect,
          clipRect,
          reason: 'Live painting should use the same bounded shader target.',
        );
      },
    );

    _testWidgets(
      'when wash contains a platform view, it should keep the native surface below the reveal',
      (tester) async {
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform_views,
          _handlePlatformViewCall,
        );
        addTearDown(() {
          tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
            SystemChannels.platform_views,
            null,
          );
        });
        await _pumpPushApp(
          tester,
          platform: TargetPlatform.android,
          settle: false,
          page: const MateoPage<void>(
            transition: MateoPageTransition.wash(),
            child: AndroidView(viewType: 'mateo-test-platform-view'),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));

        final snapshot = tester.widget<SnapshotWidget>(
          find.byType(SnapshotWidget),
        );

        expect(snapshot.mode, SnapshotMode.forced);
        expect(
          _findLayer<PlatformViewLayer>(
            tester.binding.renderViews.single.debugLayer,
          ),
          isNull,
        );
      },
    );

    _testWidgets(
      'when wash is popped, it should collapse over a stationary destination',
      (tester) async {
        await _pumpPushApp(
          tester,
          platform: TargetPlatform.android,
          page: const MateoPage<void>(
            transition: MateoPageTransition.wash(),
            child: ColoredBox(key: _destinationKey, color: Colors.blue),
          ),
        );

        Navigator.of(tester.element(find.byKey(_destinationKey))).pop();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        final earlyPosition = tester.getTopLeft(find.byKey(_destinationKey));
        await tester.pump(const Duration(milliseconds: 100));
        final laterPosition = tester.getTopLeft(find.byKey(_destinationKey));

        expect(find.byType(SnapshotWidget), findsOneWidget);
        expect(find.byType(ShaderMask), findsNothing);
        expect(earlyPosition, Offset.zero);
        expect(laterPosition, earlyPosition);

        await tester.pumpAndSettle();

        expect(find.byKey(_destinationKey), findsNothing);
      },
    );

    test(
      'when wash durations are omitted, they should default to 600 milliseconds',
      () {
        const transition = MateoPageTransition.wash();

        expect(transition.duration, const Duration(milliseconds: 600));
        expect(transition.reverseDuration, const Duration(milliseconds: 600));
      },
    );

    test(
      'when push durations are omitted, they should default to 600 milliseconds',
      () {
        const transition = MateoPageTransition.push();

        expect(transition.duration, const Duration(milliseconds: 600));
        expect(transition.reverseDuration, const Duration(milliseconds: 600));
      },
    );

    test('when slide settings are omitted, they should use the default direction and timing', () {
      const transition = MateoPageTransition.slide();

      expect(transition.direction, MateoPageTransitionDirection.up);
      expect(transition.duration, const Duration(milliseconds: 390));
      expect(transition.reverseDuration, const Duration(milliseconds: 200));
      const slide = transition as MateoPageTransitionSlide;
      expect(slide.openingCurve, isNot(slide.closingCurve));
      expect(slide.openingCurve.transform(.5), closeTo(0.888290707184, 1e-12));
      expect(slide.closingCurve.transform(.5), closeTo(0.62890625, 1e-12));
    });

    test('when slide curves approach their destination, they should settle without a hard stop', () {
      const transition = MateoPageTransition.slide();
      const slide = transition as MateoPageTransitionSlide;

      for (final curve in [slide.openingCurve, slide.closingCurve]) {
        var previous = curve.transform(0);
        for (var sample = 1; sample <= 1000; sample++) {
          final value = curve.transform(sample / 1000);
          expect(value, inInclusiveRange(previous, 1));
          previous = value;
        }

        const landingWindow = 0.01;
        final fullWindowTravel = 1 - curve.transform(1 - landingWindow);
        final halfWindowTravel = 1 - curve.transform(1 - landingWindow / 2);
        expect(halfWindowTravel / fullWindowTravel, lessThan(0.1));
      }
    });

    _testWidgets(
      'when push durations are configured, it should use them for push and pop',
      (tester) async {
        const duration = Duration(milliseconds: 480);
        const reverseDuration = Duration(milliseconds: 320);
        const transition = MateoPageTransition.push(
          duration: duration,
          reverseDuration: reverseDuration,
        );
        final capture = await _captureRoute<void>(
          tester,
          platform: TargetPlatform.android,
          page: const MateoPage<void>(
            transition: transition,
            child: SizedBox(),
          ),
        );

        expect(transition.duration, duration);
        expect(transition.reverseDuration, reverseDuration);
        expect(capture.route.transitionDuration, duration);
        expect(capture.route.reverseTransitionDuration, reverseDuration);
      },
    );

    _testWidgets(
      'when only wash duration is configured, it should use it for push and pop',
      (tester) async {
        const duration = Duration(milliseconds: 240);
        final capture = await _captureRoute<void>(
          tester,
          platform: TargetPlatform.android,
          page: const MateoPage<void>(
            transition: MateoPageTransition.wash(duration: duration),
            child: SizedBox(),
          ),
        );

        expect(capture.route.transitionDuration, duration);
        expect(capture.route.reverseTransitionDuration, duration);
      },
    );

    _testWidgets(
      'when reverse duration is configured, it should use it only for pop',
      (tester) async {
        const duration = Duration(milliseconds: 600);
        const reverseDuration = Duration(milliseconds: 240);
        const transition = MateoPageTransition.wash(
          duration: duration,
          reverseDuration: reverseDuration,
        );
        final capture = await _captureRoute<void>(
          tester,
          platform: TargetPlatform.android,
          page: const MateoPage<void>(
            transition: transition,
            child: SizedBox(),
          ),
        );

        expect(transition.duration, duration);
        expect(transition.reverseDuration, reverseDuration);
        expect(capture.route.transitionDuration, duration);
        expect(capture.route.reverseTransitionDuration, reverseDuration);
      },
    );

    _testWidgets(
      'when push duration is zero, it should preserve a nonzero reverse duration',
      (tester) async {
        const reverseDuration = Duration(milliseconds: 240);
        final capture = await _captureRoute<void>(
          tester,
          platform: TargetPlatform.android,
          page: const MateoPage<void>(
            transition: MateoPageTransition.wash(
              duration: Duration.zero,
              reverseDuration: reverseDuration,
            ),
            child: SizedBox(),
          ),
        );

        expect(capture.route.transitionDuration, Duration.zero);
        expect(capture.route.reverseTransitionDuration, reverseDuration);
      },
    );

    _testWidgets(
      'when reverse duration is zero, it should preserve a nonzero push duration',
      (tester) async {
        const duration = Duration(milliseconds: 600);
        final capture = await _captureRoute<void>(
          tester,
          platform: TargetPlatform.android,
          page: const MateoPage<void>(
            transition: MateoPageTransition.wash(
              duration: duration,
              reverseDuration: Duration.zero,
            ),
            child: SizedBox(),
          ),
        );

        expect(capture.route.transitionDuration, duration);
        expect(capture.route.reverseTransitionDuration, Duration.zero);
      },
    );

    test('when wash duration is negative, it should reject the transition', () {
      expect(
        () => const MateoPageTransitionsBuilder(
          transition: MateoPageTransition.wash(
            duration: Duration(milliseconds: -1),
          ),
        ).transitionDuration,
        throwsArgumentError,
      );
    });

    test(
      'when wash reverse duration is negative, it should reject the transition',
      () {
        expect(
          () => const MateoPageTransitionsBuilder(
            transition: MateoPageTransition.wash(
              reverseDuration: Duration(milliseconds: -1),
            ),
          ).transitionDuration,
          throwsArgumentError,
        );
      },
    );

    test('when push duration is negative, it should reject the transition', () {
      expect(
        () => const MateoPageTransitionsBuilder(
          transition: MateoPageTransition.push(
            duration: Duration(milliseconds: -1),
          ),
        ).transitionDuration,
        throwsArgumentError,
      );
    });

    test(
      'when push reverse duration is negative, it should reject the transition',
      () {
        expect(
          () => const MateoPageTransitionsBuilder(
            transition: MateoPageTransition.push(
              reverseDuration: Duration(milliseconds: -1),
            ),
          ).transitionDuration,
          throwsArgumentError,
        );
      },
    );

    test('when slide duration is negative, it should reject the transition', () {
      expect(
        () => const MateoPageTransitionsBuilder(
          transition: MateoPageTransition.slide(duration: Duration(milliseconds: -1)),
        ).transitionDuration,
        throwsArgumentError,
      );
    });

    test('when slide reverse duration is negative, it should reject the transition', () {
      expect(
        () => const MateoPageTransitionsBuilder(
          transition: MateoPageTransition.slide(reverseDuration: Duration(milliseconds: -1)),
        ).transitionDuration,
        throwsArgumentError,
      );
    });

    _testWidgets(
      'when reduced motion is enabled, it should show the wash destination immediately',
      (tester) async {
        PageRoute<void>? capturedRoute;

        await tester.pumpWidget(
          _PushApp(
            platform: TargetPlatform.android,
            disableAnimations: true,
            page: const MateoPage<void>(
              transition: MateoPageTransition.wash(),
              child: ColoredBox(key: _destinationKey, color: Colors.blue),
            ),
            onRouteCreated: (route) {
              capturedRoute = route;
            },
          ),
        );
        await tester.tap(find.byKey(_openKey));
        await tester.pump();

        expect(capturedRoute!.transitionDuration, Duration.zero);
        expect(capturedRoute!.reverseTransitionDuration, Duration.zero);
        expect(tester.getTopLeft(find.byKey(_destinationKey)), Offset.zero);
      },
    );

    _testWidgets(
      'when reduced motion is enabled, it should show the push destination immediately',
      (tester) async {
        PageRoute<void>? capturedRoute;

        await tester.pumpWidget(
          _PushApp(
            platform: TargetPlatform.android,
            disableAnimations: true,
            page: const MateoPage<void>(
              transition: MateoPageTransition.push(),
              child: ColoredBox(key: _destinationKey, color: Colors.blue),
            ),
            onRouteCreated: (route) {
              capturedRoute = route;
            },
          ),
        );
        await tester.tap(find.byKey(_openKey));
        await tester.pump();

        expect(capturedRoute!.transitionDuration, Duration.zero);
        expect(capturedRoute!.reverseTransitionDuration, Duration.zero);
        expect(tester.getTopLeft(find.byKey(_destinationKey)), Offset.zero);
      },
    );

    _testWidgets('when reduced motion is enabled, it should show the slide destination immediately', (tester) async {
      PageRoute<void>? capturedRoute;

      await tester.pumpWidget(
        _PushApp(
          platform: TargetPlatform.android,
          disableAnimations: true,
          page: const MateoPage<void>(
            transition: MateoPageTransition.slide(),
            child: ColoredBox(key: _destinationKey, color: Colors.blue),
          ),
          onRouteCreated: (route) {
            capturedRoute = route;
          },
        ),
      );
      await tester.tap(find.byKey(_openKey));
      await tester.pump();

      expect(capturedRoute!.transitionDuration, Duration.zero);
      expect(capturedRoute!.reverseTransitionDuration, Duration.zero);
      expect(tester.getTopLeft(find.byKey(_destinationKey)), Offset.zero);
    });

    _testWidgets(
      'when a page with the same key updates, it should display the latest child',
      (tester) async {
        final appKey = GlobalKey<_DeclarativePageAppState>();

        await tester.pumpWidget(_DeclarativePageApp(key: appKey));
        expect(find.text('First child'), findsOneWidget);

        appKey.currentState!.showSecondChild();
        await tester.pump();

        expect(find.text('First child'), findsNothing);
        expect(find.text('Second child'), findsOneWidget);
      },
    );

    _testWidgets(
      'when a same-key page updates wash settings, it should update the existing route',
      (tester) async {
        final appKey = GlobalKey<_DeclarativePageAppState>();

        await tester.pumpWidget(_DeclarativePageApp(key: appKey));
        final originalRoute = ModalRoute.of(tester.element(find.text('First child')))! as PageRoute<void>;

        appKey.currentState!.updateWashSettings();
        await tester.pump();

        final updatedRoute = ModalRoute.of(tester.element(find.text('First child')))! as PageRoute<void>;
        expect(updatedRoute, same(originalRoute));
        expect(
          updatedRoute.transitionDuration,
          const Duration(milliseconds: 240),
        );
        expect(
          updatedRoute.reverseTransitionDuration,
          const Duration(milliseconds: 120),
        );
        expect(updatedRoute.allowSnapshotting, isFalse);
      },
    );

    _testWidgets(
      'when a same-key page changes transition family, it should replace the route',
      (tester) async {
        final appKey = GlobalKey<_DeclarativePageAppState>();

        await tester.pumpWidget(_DeclarativePageApp(key: appKey));
        final originalRoute = ModalRoute.of(tester.element(find.text('First child')))! as PageRoute<void>;

        appKey.currentState!.usePushTransition();
        await tester.pumpAndSettle();

        final updatedRoute = ModalRoute.of(tester.element(find.text('First child')))! as PageRoute<void>;
        expect(updatedRoute, isNot(same(originalRoute)));
        expect(updatedRoute.transitionDuration, Duration.zero);
      },
    );

    _testWidgets(
      'when the typed page is popped with a result, it should complete with that result',
      (tester) async {
        int? result;

        await tester.pumpWidget(
          _ResultApp(
            onResult: (value) {
              result = value;
            },
          ),
        );
        await tester.tap(find.byKey(_openKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(_closeKey));
        await tester.pumpAndSettle();

        expect(result, 42);
      },
    );

    test(
      'when page metadata is provided, it should retain the configuration',
      () {
        const key = ValueKey('page');
        const arguments = {'jobId': 42};
        bool? didPop;
        Object? result;
        final page = MateoPage<int>(
          key: key,
          name: '/jobs/42',
          arguments: arguments,
          restorationId: 'job-page',
          canPop: false,
          onPopInvoked: (wasPopped, popResult) {
            didPop = wasPopped;
            result = popResult;
          },
          title: 'Job',
          maintainState: false,
          fullscreenDialog: true,
          allowSnapshotting: false,
          child: const SizedBox(),
        );

        page.onPopInvoked(true, 42);

        expect(page.key, key);
        expect(page.name, '/jobs/42');
        expect(page.arguments, arguments);
        expect(page.restorationId, 'job-page');
        expect(page.canPop, isFalse);
        expect(page.title, 'Job');
        expect(page.maintainState, isFalse);
        expect(page.fullscreenDialog, isTrue);
        expect(page.allowSnapshotting, isFalse);
        expect(didPop, isTrue);
        expect(result, 42);
      },
    );

    _testWidgets('when native Android navigation opens without a Material theme, it should animate and return', (
      tester,
    ) async {
      await _pumpPushApp(
        tester,
        platform: .android,
        page: const MateoPage<void>(child: SizedBox(key: _destinationKey)),
      );
      expect(find.byKey(_destinationKey), findsOneWidget);
      Navigator.of(tester.element(find.byKey(_destinationKey))).pop();
      await tester.pumpAndSettle();
      expect(find.byKey(_destinationKey), findsNothing);
      expect(tester.takeException(), isNull);
    });

    _testWidgets('when a page vetoes popping, it should retain its destination', (tester) async {
      await _pumpPushApp(
        tester,
        platform: .android,
        page: const MateoPage<void>(
          canPop: false,
          transition: .push(),
          child: SizedBox(key: _destinationKey),
        ),
      );
      final navigator = Navigator.of(tester.element(find.byKey(_destinationKey)));
      await navigator.maybePop();
      await tester.pumpAndSettle();
      expect(find.byKey(_destinationKey), findsOneWidget);
    });

    _testWidgets('when reduced motion turns on mid-route, it should finish presentation immediately', (tester) async {
      final reduced = ValueNotifier(false);
      addTearDown(reduced.dispose);
      PageRoute<void>? route;
      await tester.pumpWidget(
        _MateoTestApp(
          builder: (context, child) => ValueListenableBuilder<bool>(
            valueListenable: reduced,
            builder: (context, value, _) => MediaQuery(
              data: MediaQueryData(disableAnimations: value),
              child: child!,
            ),
          ),
          home: Builder(
            builder: (context) => _TestAction(
              key: _openKey,
              onPressed: () {
                route = const MateoPage<void>(
                  transition: .wash(),
                  child: SizedBox(key: _destinationKey),
                ).createRoute(context);
                Navigator.of(context).push(route!);
              },
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.tap(find.byKey(_openKey));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      reduced.value = true;
      await tester.pump();
      await tester.pump();
      expect(route!.transitionDuration, Duration.zero);
      expect(route!.animation!.isCompleted, isTrue);
      expect(tester.takeException(), isNull);
    });

    _testWidgets('when predictive back commits partway through push, it should continue from the dragged position', (
      tester,
    ) async {
      await _pumpPushApp(
        tester,
        platform: .android,
        page: const MateoPage<void>(
          transition: .push(),
          child: SizedBox(key: _destinationKey),
        ),
      );
      await _sendBackGesture(
        tester,
        const MethodCall('startBackGesture', <String, Object>{
          'touchOffset': <double>[5, 300],
          'progress': 0.0,
          'swipeEdge': 0,
        }),
      );
      await _sendBackGesture(
        tester,
        const MethodCall('updateBackGestureProgress', <String, Object>{
          'touchOffset': <double>[300, 300],
          'progress': 0.4,
          'swipeEdge': 0,
        }),
      );
      await tester.pump();
      final before = tester.getTopLeft(find.byKey(_destinationKey));
      await _sendBackGesture(tester, const MethodCall('commitBackGesture'));
      await tester.pump();
      expect(tester.getTopLeft(find.byKey(_destinationKey)), before);
      await tester.pumpAndSettle();
      expect(find.byKey(_destinationKey), findsNothing);
      expect(Navigator.of(tester.element(find.byKey(_openKey))).userGestureInProgress, isFalse);
    });

    _testWidgets('when a route is removed during predictive back, it should release the navigator gesture', (
      tester,
    ) async {
      PageRoute<void>? route;
      await _pumpPushApp(
        tester,
        platform: .android,
        page: const MateoPage<void>(
          transition: .push(),
          child: SizedBox(key: _destinationKey),
        ),
        onRouteCreated: (value) => route = value,
      );
      final navigator = route!.navigator!;
      await _sendBackGesture(
        tester,
        const MethodCall('startBackGesture', <String, Object>{
          'touchOffset': <double>[5, 300],
          'progress': 0.0,
          'swipeEdge': 0,
        }),
      );
      expect(navigator.userGestureInProgress, isTrue);
      navigator.removeRoute(route!);
      await tester.pumpAndSettle();
      expect(navigator.userGestureInProgress, isFalse);
      expect(tester.takeException(), isNull);
    });
  });
}

const _openKey = Key('open-page');
const _closeKey = Key('close-page');
const _sourceKey = Key('source');
const _destinationKey = Key('destination');

void _expectPagesAttached(
  WidgetTester tester,
  MateoPageTransitionDirection direction,
) {
  final sourceRect = tester.getRect(find.byKey(_sourceKey));
  final destinationRect = tester.getRect(find.byKey(_destinationKey));

  switch (direction) {
    case MateoPageTransitionDirection.up:
      expect(sourceRect.bottom, closeTo(destinationRect.top, 0.001));
      expect(sourceRect.top, lessThan(0));
    case MateoPageTransitionDirection.down:
      expect(sourceRect.top, closeTo(destinationRect.bottom, 0.001));
      expect(sourceRect.top, greaterThan(0));
    case MateoPageTransitionDirection.left:
      expect(sourceRect.right, closeTo(destinationRect.left, 0.001));
      expect(sourceRect.left, lessThan(0));
    case MateoPageTransitionDirection.right:
      expect(sourceRect.left, closeTo(destinationRect.right, 0.001));
      expect(sourceRect.left, greaterThan(0));
  }
}

void _expectEdgeBackedSourceFade(WidgetTester tester) {
  final sourceFilter = find.ancestor(
    of: find.byKey(_sourceKey),
    matching: find.byType(ColorFiltered),
  );
  final destinationFilter = find.ancestor(
    of: find.byKey(_destinationKey),
    matching: find.byType(ColorFiltered),
  );

  final destinationSnapshot = find.ancestor(
    of: find.byKey(_destinationKey),
    matching: find.byType(SnapshotWidget),
  );

  expect(sourceFilter, findsNothing);
  expect(destinationFilter, findsNothing);
  expect(destinationSnapshot, findsNothing);
}

void _expectWashOrigin(
  WidgetTester tester,
  MateoPageTransitionDirection direction,
) {
  final viewport = tester.getRect(find.byType(SnapshotWidget));
  final activeRect = _findLayer<ShaderMaskLayer>(
    tester.binding.renderViews.single.debugLayer,
  )!.maskRect!;

  switch (direction) {
    case MateoPageTransitionDirection.up:
      expect(activeRect.bottom, viewport.bottom);
      expect(activeRect.top, greaterThan(viewport.top));
    case MateoPageTransitionDirection.down:
      expect(activeRect.top, viewport.top);
      expect(activeRect.bottom, lessThan(viewport.bottom));
    case MateoPageTransitionDirection.left:
      expect(activeRect.right, viewport.right);
      expect(activeRect.left, greaterThan(viewport.left));
    case MateoPageTransitionDirection.right:
      expect(activeRect.left, viewport.left);
      expect(activeRect.right, lessThan(viewport.right));
  }
}

Future<void> _sendBackGesture(
  WidgetTester tester,
  MethodCall methodCall,
) async {
  final message = const StandardMethodCodec().encodeMethodCall(methodCall);
  await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
    'flutter/backgesture',
    message,
    (_) {},
  );
}

Future<Object?> _handlePlatformViewCall(MethodCall call) async {
  return switch (call.method) {
    'create' => 1,
    'resize' => const <String, double>{'width': 800, 'height': 600},
    'dispose' || 'offset' || 'setDirection' || 'clearFocus' || 'touch' => null,
    _ => null,
  };
}

T? _findLayer<T extends Layer>(Layer? layer) {
  if (layer is T) return layer;
  if (layer is! ContainerLayer) return null;

  var child = layer.firstChild;
  while (child != null) {
    final match = _findLayer<T>(child);
    if (match != null) return match;
    child = child.nextSibling;
  }
  return null;
}

Iterable<T> _findLayers<T extends Layer>(Layer? layer) sync* {
  if (layer is T) yield layer;
  if (layer is! ContainerLayer) return;

  var child = layer.firstChild;
  while (child != null) {
    yield* _findLayers<T>(child);
    child = child.nextSibling;
  }
}

Future<({MateoPage<T> page, PageRoute<T> route})> _captureRoute<T>(
  WidgetTester tester, {
  required TargetPlatform platform,
  required MateoPage<T> page,
}) async {
  PageRoute<T>? capturedRoute;

  await tester.pumpWidget(
    _MateoTestApp(
      platform: platform,
      home: Builder(
        builder: (context) {
          capturedRoute = page.createRoute(context);
          return const SizedBox();
        },
      ),
    ),
  );

  return (page: page, route: capturedRoute!);
}

Future<void> _pumpPushApp(
  WidgetTester tester, {
  required TargetPlatform platform,
  required MateoPage<void> page,
  bool settle = true,
  bool tapToPush = true,
  ValueChanged<PageRoute<void>>? onRouteCreated,
  VoidCallback? onSourcePaint,
}) async {
  await tester.binding.setSurfaceSize(const Size(800, 600));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    KeyedSubtree(
      key: UniqueKey(),
      child: _PushApp(
        platform: platform,
        page: page,
        onRouteCreated: onRouteCreated,
        onSourcePaint: onSourcePaint,
      ),
    ),
  );
  if (tapToPush) {
    await tester.tap(find.byKey(_openKey));
  } else {
    final context = tester.element(find.byKey(_openKey));
    final route = page.createRoute(context);
    onRouteCreated?.call(route);
    Navigator.of(context).push(route);
  }
  await tester.pump();
  if (settle) await tester.pumpAndSettle();
}

Future<void> _pumpPushTransitionApp(
  WidgetTester tester, {
  required MateoPageTransitionDirection direction,
}) async {
  await tester.binding.setSurfaceSize(const Size(800, 600));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    KeyedSubtree(
      key: UniqueKey(),
      child: _PushTransitionApp(direction: direction),
    ),
  );
}

class _PushApp extends StatelessWidget {
  const _PushApp({
    required this.platform,
    required this.page,
    this.disableAnimations = false,
    this.onRouteCreated,
    this.onSourcePaint,
  });

  final TargetPlatform platform;
  final MateoPage<void> page;
  final bool disableAnimations;
  final ValueChanged<PageRoute<void>>? onRouteCreated;
  final VoidCallback? onSourcePaint;

  @override
  Widget build(BuildContext context) {
    return _MateoTestApp(
      platform: platform,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(disableAnimations: disableAnimations),
        child: child!,
      ),
      home: _PaintCounter(
        onPaint: onSourcePaint ?? _noop,
        child: Builder(
          builder: (context) {
            return _TestSurface(
              body: _TestAction(
                key: _openKey,
                onPressed: () {
                  final route = page.createRoute(context);
                  onRouteCreated?.call(route);
                  Navigator.of(context).push(route);
                },
                child: const Text('Open'),
              ),
            );
          },
        ),
      ),
    );
  }
}

void _noop() {}

class _PushTransitionApp extends StatelessWidget {
  const _PushTransitionApp({required this.direction});

  final MateoPageTransitionDirection direction;

  @override
  Widget build(BuildContext context) {
    return _MateoTestApp(
      home: Builder(
        builder: (context) {
          return ColoredBox(
            key: _sourceKey,
            color: Colors.orange,
            child: Center(
              child: _TestAction(
                key: _openKey,
                onPressed: () {
                  Navigator.of(context).push(
                    MateoPage<void>(
                      transition: MateoPageTransition.push(
                        direction: direction,
                      ),
                      child: ColoredBox(
                        key: _destinationKey,
                        color: Colors.blue,
                        child: Center(
                          child: _TestAction(
                            key: _closeKey,
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close'),
                          ),
                        ),
                      ),
                    ).createRoute(context),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DeclarativePageApp extends StatefulWidget {
  const _DeclarativePageApp({super.key});

  @override
  State<_DeclarativePageApp> createState() => _DeclarativePageAppState();
}

class _DeclarativePageAppState extends State<_DeclarativePageApp> {
  var _showsSecondChild = false;
  var _allowSnapshotting = true;
  MateoPageTransition _transition = const MateoPageTransition.wash(
    duration: Duration.zero,
  );

  void showSecondChild() {
    setState(() {
      _showsSecondChild = true;
    });
  }

  void updateWashSettings() {
    setState(() {
      _allowSnapshotting = false;
      _transition = const MateoPageTransition.wash(
        direction: MateoPageTransitionDirection.left,
        duration: Duration(milliseconds: 240),
        reverseDuration: Duration(milliseconds: 120),
      );
    });
  }

  void usePushTransition() {
    setState(() {
      _transition = const MateoPageTransition.push(duration: Duration.zero);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _MateoTestApp(
      home: Navigator(
        pages: [
          MateoPage<void>(
            key: const ValueKey('detail'),
            transition: _transition,
            allowSnapshotting: _allowSnapshotting,
            child: Center(
              child: Text(_showsSecondChild ? 'Second child' : 'First child'),
            ),
          ),
        ],
        onDidRemovePage: (_) {},
      ),
    );
  }
}

class _ResultApp extends StatelessWidget {
  const _ResultApp({required this.onResult});

  final ValueChanged<int?> onResult;

  @override
  Widget build(BuildContext context) {
    return _MateoTestApp(
      home: Builder(
        builder: (context) {
          return _TestAction(
            key: _openKey,
            onPressed: () async {
              final page = MateoPage<int>(
                transition: const MateoPageTransition.wash(duration: Duration.zero),
                child: Builder(
                  builder: (context) {
                    return _TestAction(
                      key: _closeKey,
                      onPressed: () => Navigator.of(context).pop(42),
                      child: const Text('Close'),
                    );
                  },
                ),
              );
              final result = await Navigator.of(
                context,
              ).push(page.createRoute(context));
              onResult(result);
            },
            child: const Text('Open'),
          );
        },
      ),
    );
  }
}

class _PaintCounter extends SingleChildRenderObjectWidget {
  const _PaintCounter({required this.onPaint, required super.child});

  final VoidCallback onPaint;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderPaintCounter(onPaint);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderPaintCounter renderObject,
  ) {
    renderObject.onPaint = onPaint;
  }
}

class _RenderPaintCounter extends RenderProxyBox {
  _RenderPaintCounter(this.onPaint);

  VoidCallback onPaint;

  @override
  void paint(PaintingContext context, Offset offset) {
    onPaint();
    super.paint(context, offset);
  }
}

class _MateoTestApp extends StatelessWidget {
  const _MateoTestApp({required this.home, this.platform = TargetPlatform.android, this.builder});
  final Widget home;
  final TargetPlatform platform;
  final TransitionBuilder? builder;
  @override
  Widget build(BuildContext context) {
    debugDefaultTargetPlatformOverride = platform;
    return MateoApp(theme: _theme, home: home, builder: builder);
  }
}

final _theme = MateoThemeData.light(accentColor: const Color(0xFF7551FF), onAccent: const Color(0xFFFFFFFF));

class _TestSurface extends StatelessWidget {
  const _TestSurface({required this.body});
  final Widget body;
  @override
  Widget build(BuildContext context) => ColoredBox(color: _theme.colorScheme.background, child: body);
}

class _TestAction extends StatelessWidget {
  const _TestAction({required this.onPressed, required this.child, super.key});
  final VoidCallback onPressed;
  final Widget child;
  @override
  Widget build(BuildContext context) =>
      GestureDetector(behavior: HitTestBehavior.opaque, onTap: onPressed, child: child);
}

void _testWidgets(String description, WidgetTesterCallback callback) {
  testWidgets(description, (tester) async {
    try {
      await callback(tester);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });
}
