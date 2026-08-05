import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  group('MateoPage', () {
    testWidgets(
      'when transition is omitted on Android, it should create a native Material route',
      (tester) async {
        final capture = await _captureRoute<int>(
          tester,
          platform: TargetPlatform.android,
          page: const MateoPage<int>(child: SizedBox()),
        );

        expect(capture.route, isA<MaterialRouteTransitionMixin<int>>());
        expect(capture.route.settings, same(capture.page));
      },
    );

    testWidgets(
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

    testWidgets(
      'when explicit route inputs stay unchanged, it should reuse its transition widgets',
      (tester) async {
        PageRoute<void>? route;
        await _pumpPushApp(
          tester,
          platform: TargetPlatform.android,
          settle: false,
          page: MateoPage<void>(
            transition: MateoPageTransition.push(),
            child: const SizedBox(key: _destinationKey),
          ),
          onRouteCreated: (createdRoute) => route = createdRoute,
        );
        final routeContext = tester.element(find.byType(MaterialApp));
        final animation = route!.animation!;
        final secondaryAnimation = route!.secondaryAnimation!;
        const child = SizedBox();

        final firstEntering = route!.buildTransitions(
          routeContext,
          animation,
          secondaryAnimation,
          child,
        );
        final secondEntering = route!.buildTransitions(
          routeContext,
          animation,
          secondaryAnimation,
          child,
        );
        final delegatedTransition = route!.delegatedTransition!;
        final firstOutgoing = delegatedTransition(
          routeContext,
          animation,
          secondaryAnimation,
          true,
          child,
        );
        final secondOutgoing = delegatedTransition(
          routeContext,
          animation,
          secondaryAnimation,
          true,
          child,
        );

        expect(secondEntering, same(firstEntering));
        expect(secondOutgoing, same(firstOutgoing));
      },
    );

    testWidgets(
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

    testWidgets(
      'when an explicit Mateo transition is used on iOS, it should not start an edge-swipe pop',
      (tester) async {
        for (final transition in [
          MateoPageTransition.wash(),
          MateoPageTransition.push(),
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

    testWidgets(
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

    testWidgets(
      'when Android predictive back commits wash, it should pop the page',
      (tester) async {
        await _pumpPushApp(
          tester,
          platform: TargetPlatform.android,
          page: MateoPage<void>(
            transition: MateoPageTransition.wash(),
            child: const ColoredBox(key: _destinationKey, color: Colors.blue),
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

    testWidgets(
      'when wash enters over a native route, it should keep the source stationary',
      (tester) async {
        await _pumpPushApp(
          tester,
          platform: TargetPlatform.android,
          settle: false,
          tapToPush: false,
          page: MateoPage<void>(
            transition: MateoPageTransition.wash(),
            child: const ColoredBox(color: Colors.blue),
          ),
        );
        await tester.pump(const Duration(milliseconds: 16));
        final earlyPosition = tester.getTopLeft(find.byKey(_openKey));
        final sourceRoute = ModalRoute.of(
          tester.element(find.byKey(_openKey)),
        )!;

        await tester.pump(const Duration(milliseconds: 300));

        expect(sourceRoute.secondaryAnimation!.isDismissed, isTrue);
        expect(tester.getTopLeft(find.byKey(_openKey)), earlyPosition);
      },
    );

    testWidgets(
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

    testWidgets(
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

    testWidgets(
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

    testWidgets(
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

    testWidgets(
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

    testWidgets(
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
            (widget) =>
                widget is AnimatedWidget &&
                widget.runtimeType.toString() == '_MateoPushPageTransitionView',
          ),
        );

        expect(animatedAncestors, findsNothing);
      },
    );

    testWidgets(
      'when Mateo transitions animate, they should retain both routed page rasters',
      (tester) async {
        for (final transition in [
          MateoPageTransition.wash(),
          MateoPageTransition.push(),
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

    testWidgets(
      'when wash opens, it should reveal a stationary snapshotted destination through a gradient',
      (tester) async {
        await _pumpPushApp(
          tester,
          platform: TargetPlatform.android,
          settle: false,
          page: MateoPage<void>(
            transition: MateoPageTransition.wash(),
            child: const ColoredBox(key: _destinationKey, color: Colors.blue),
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

    testWidgets(
      'when wash reveals a snapshot, it should crop painting to the active circle without a clip layer',
      (tester) async {
        await _pumpPushApp(
          tester,
          platform: TargetPlatform.android,
          settle: false,
          page: MateoPage<void>(
            transition: MateoPageTransition.wash(),
            child: const ColoredBox(key: _destinationKey, color: Colors.blue),
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

    testWidgets(
      'when wash opens, it should keep the reveal moving beyond the midpoint',
      (tester) async {
        await _pumpPushApp(
          tester,
          platform: TargetPlatform.android,
          settle: false,
          page: MateoPage<void>(
            transition: MateoPageTransition.wash(
              direction: MateoPageTransitionDirection.left,
            ),
            child: const ColoredBox(key: _destinationKey, color: Colors.blue),
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

    testWidgets(
      'when snapshotting is disabled, it should clip live painting to the active circle',
      (tester) async {
        await _pumpPushApp(
          tester,
          platform: TargetPlatform.android,
          settle: false,
          page: MateoPage<void>(
            transition: MateoPageTransition.wash(),
            allowSnapshotting: false,
            child: const ColoredBox(key: _destinationKey, color: Colors.blue),
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

    testWidgets(
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
          page: MateoPage<void>(
            transition: MateoPageTransition.wash(),
            child: const AndroidView(viewType: 'mateo-test-platform-view'),
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

    testWidgets(
      'when wash is popped, it should collapse over a stationary destination',
      (tester) async {
        await _pumpPushApp(
          tester,
          platform: TargetPlatform.android,
          page: MateoPage<void>(
            transition: MateoPageTransition.wash(),
            child: const ColoredBox(key: _destinationKey, color: Colors.blue),
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
        final transition = MateoPageTransition.wash();

        expect(transition.duration, const Duration(milliseconds: 600));
        expect(transition.reverseDuration, const Duration(milliseconds: 600));
      },
    );

    test(
      'when push durations are omitted, they should default to 600 milliseconds',
      () {
        final transition = MateoPageTransition.push();

        expect(transition.duration, const Duration(milliseconds: 600));
        expect(transition.reverseDuration, const Duration(milliseconds: 600));
      },
    );

    testWidgets(
      'when push durations are configured, it should use them for push and pop',
      (tester) async {
        const duration = Duration(milliseconds: 480);
        const reverseDuration = Duration(milliseconds: 320);
        final transition = MateoPageTransition.push(
          duration: duration,
          reverseDuration: reverseDuration,
        );
        final capture = await _captureRoute<void>(
          tester,
          platform: TargetPlatform.android,
          page: MateoPage<void>(
            transition: transition,
            child: const SizedBox(),
          ),
        );

        expect(transition.duration, duration);
        expect(transition.reverseDuration, reverseDuration);
        expect(capture.route.transitionDuration, duration);
        expect(capture.route.reverseTransitionDuration, reverseDuration);
      },
    );

    testWidgets(
      'when only wash duration is configured, it should use it for push and pop',
      (tester) async {
        const duration = Duration(milliseconds: 240);
        final capture = await _captureRoute<void>(
          tester,
          platform: TargetPlatform.android,
          page: MateoPage<void>(
            transition: MateoPageTransition.wash(duration: duration),
            child: const SizedBox(),
          ),
        );

        expect(capture.route.transitionDuration, duration);
        expect(capture.route.reverseTransitionDuration, duration);
      },
    );

    testWidgets(
      'when reverse duration is configured, it should use it only for pop',
      (tester) async {
        const duration = Duration(milliseconds: 600);
        const reverseDuration = Duration(milliseconds: 240);
        final transition = MateoPageTransition.wash(
          duration: duration,
          reverseDuration: reverseDuration,
        );
        final capture = await _captureRoute<void>(
          tester,
          platform: TargetPlatform.android,
          page: MateoPage<void>(
            transition: transition,
            child: const SizedBox(),
          ),
        );

        expect(transition.duration, duration);
        expect(transition.reverseDuration, reverseDuration);
        expect(capture.route.transitionDuration, duration);
        expect(capture.route.reverseTransitionDuration, reverseDuration);
      },
    );

    testWidgets(
      'when push duration is zero, it should preserve a nonzero reverse duration',
      (tester) async {
        const reverseDuration = Duration(milliseconds: 240);
        final capture = await _captureRoute<void>(
          tester,
          platform: TargetPlatform.android,
          page: MateoPage<void>(
            transition: MateoPageTransition.wash(
              duration: Duration.zero,
              reverseDuration: reverseDuration,
            ),
            child: const SizedBox(),
          ),
        );

        expect(capture.route.transitionDuration, Duration.zero);
        expect(capture.route.reverseTransitionDuration, reverseDuration);
      },
    );

    testWidgets(
      'when reverse duration is zero, it should preserve a nonzero push duration',
      (tester) async {
        const duration = Duration(milliseconds: 600);
        final capture = await _captureRoute<void>(
          tester,
          platform: TargetPlatform.android,
          page: MateoPage<void>(
            transition: MateoPageTransition.wash(
              duration: duration,
              reverseDuration: Duration.zero,
            ),
            child: const SizedBox(),
          ),
        );

        expect(capture.route.transitionDuration, duration);
        expect(capture.route.reverseTransitionDuration, Duration.zero);
      },
    );

    test('when wash duration is negative, it should reject the transition', () {
      expect(
        () => MateoPageTransition.wash(
          duration: const Duration(milliseconds: -1),
        ),
        throwsArgumentError,
      );
    });

    test(
      'when wash reverse duration is negative, it should reject the transition',
      () {
        expect(
          () => MateoPageTransition.wash(
            reverseDuration: const Duration(milliseconds: -1),
          ),
          throwsArgumentError,
        );
      },
    );

    test('when push duration is negative, it should reject the transition', () {
      expect(
        () => MateoPageTransition.push(
          duration: const Duration(milliseconds: -1),
        ),
        throwsArgumentError,
      );
    });

    test(
      'when push reverse duration is negative, it should reject the transition',
      () {
        expect(
          () => MateoPageTransition.push(
            reverseDuration: const Duration(milliseconds: -1),
          ),
          throwsArgumentError,
        );
      },
    );

    testWidgets(
      'when reduced motion is enabled, it should show the wash destination immediately',
      (tester) async {
        PageRoute<void>? capturedRoute;

        await tester.pumpWidget(
          _PushApp(
            platform: TargetPlatform.android,
            disableAnimations: true,
            page: MateoPage<void>(
              transition: MateoPageTransition.wash(),
              child: const ColoredBox(key: _destinationKey, color: Colors.blue),
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

    testWidgets(
      'when reduced motion is enabled, it should show the push destination immediately',
      (tester) async {
        PageRoute<void>? capturedRoute;

        await tester.pumpWidget(
          _PushApp(
            platform: TargetPlatform.android,
            disableAnimations: true,
            page: MateoPage<void>(
              transition: MateoPageTransition.push(),
              child: const ColoredBox(key: _destinationKey, color: Colors.blue),
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

    testWidgets(
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

    testWidgets(
      'when a same-key page updates wash settings, it should update the existing route',
      (tester) async {
        final appKey = GlobalKey<_DeclarativePageAppState>();

        await tester.pumpWidget(_DeclarativePageApp(key: appKey));
        final originalRoute =
            ModalRoute.of(tester.element(find.text('First child')))!
                as PageRoute<void>;

        appKey.currentState!.updateWashSettings();
        await tester.pump();

        final updatedRoute =
            ModalRoute.of(tester.element(find.text('First child')))!
                as PageRoute<void>;
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

    testWidgets(
      'when a same-key page changes transition family, it should replace the route',
      (tester) async {
        final appKey = GlobalKey<_DeclarativePageAppState>();

        await tester.pumpWidget(_DeclarativePageApp(key: appKey));
        final originalRoute =
            ModalRoute.of(tester.element(find.text('First child')))!
                as PageRoute<void>;

        appKey.currentState!.usePushTransition();
        await tester.pumpAndSettle();

        final updatedRoute =
            ModalRoute.of(tester.element(find.text('First child')))!
                as PageRoute<void>;
        expect(updatedRoute, isNot(same(originalRoute)));
        expect(updatedRoute.transitionDuration, Duration.zero);
      },
    );

    testWidgets(
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
      break;
    case MateoPageTransitionDirection.down:
      expect(sourceRect.top, closeTo(destinationRect.bottom, 0.001));
      expect(sourceRect.top, greaterThan(0));
      break;
    case MateoPageTransitionDirection.left:
      expect(sourceRect.right, closeTo(destinationRect.left, 0.001));
      expect(sourceRect.left, lessThan(0));
      break;
    case MateoPageTransitionDirection.right:
      expect(sourceRect.left, closeTo(destinationRect.right, 0.001));
      expect(sourceRect.left, greaterThan(0));
      break;
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
      break;
    case MateoPageTransitionDirection.down:
      expect(activeRect.top, viewport.top);
      expect(activeRect.bottom, lessThan(viewport.bottom));
      break;
    case MateoPageTransitionDirection.left:
      expect(activeRect.right, viewport.right);
      expect(activeRect.left, greaterThan(viewport.left));
      break;
    case MateoPageTransitionDirection.right:
      expect(activeRect.left, viewport.left);
      expect(activeRect.right, lessThan(viewport.right));
      break;
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

  Layer? child = layer.firstChild;
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

  Layer? child = layer.firstChild;
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
    MaterialApp(
      theme: ThemeData(platform: platform),
      home: Builder(
        builder: (context) {
          capturedRoute = page.createRoute(context) as PageRoute<T>;
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
    final route = page.createRoute(context) as PageRoute<void>;
    onRouteCreated?.call(route);
    unawaited(Navigator.of(context).push(route));
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
    return MaterialApp(
      theme: ThemeData(platform: platform),
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
            return Scaffold(
              body: TextButton(
                key: _openKey,
                onPressed: () {
                  final route = page.createRoute(context) as PageRoute<void>;
                  onRouteCreated?.call(route);
                  unawaited(Navigator.of(context).push(route));
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
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return ColoredBox(
            key: _sourceKey,
            color: Colors.orange,
            child: Center(
              child: TextButton(
                key: _openKey,
                onPressed: () {
                  unawaited(
                    Navigator.of(context).push(
                      MateoPage<void>(
                        transition: MateoPageTransition.push(
                          direction: direction,
                        ),
                        child: ColoredBox(
                          key: _destinationKey,
                          color: Colors.blue,
                          child: Center(
                            child: TextButton(
                              key: _closeKey,
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ),
                        ),
                      ).createRoute(context),
                    ),
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
  MateoPageTransition _transition = MateoPageTransition.wash(
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
      _transition = MateoPageTransition.wash(
        direction: MateoPageTransitionDirection.left,
        duration: const Duration(milliseconds: 240),
        reverseDuration: const Duration(milliseconds: 120),
      );
    });
  }

  void usePushTransition() {
    setState(() {
      _transition = MateoPageTransition.push(duration: Duration.zero);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return TextButton(
            key: _openKey,
            onPressed: () async {
              final page = MateoPage<int>(
                transition: MateoPageTransition.wash(duration: Duration.zero),
                child: Builder(
                  builder: (context) {
                    return TextButton(
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
