import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart' show MorphNavigatorObserver;

import '../fixtures/app_test_navigator_observer.dart';
import '../fixtures/surface_transform_test_router.dart';
import '../fixtures/surface_transform_test_widgets.dart';

void main() {
  const sourceBounds = Rect.fromLTWH(20, 40, 144, 48);
  const destinationBounds = Rect.fromLTWH(260, 180, 240, 280);

  testWidgets('when an app rebuilds, it should retain its observer, navigator, and supplied observers', (tester) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    final events = AppTestNavigatorObserver();
    Widget app(String title) => MateoApp(
      title: title,
      theme: surfaceTransformTheme,
      navigatorKey: navigatorKey,
      navigatorObservers: [events],
      home: surfaceTransformEndpoint(bounds: sourceBounds),
    );
    await tester.pumpWidget(app('Before'));
    await tester.pumpAndSettle();
    final navigator = navigatorKey.currentState!;
    final observer = navigator.widget.observers.whereType<MateoNavigatorObserver>().single;
    expect(navigator.widget.observers, contains(events));
    await startSurfaceTransformAnimationFlight(tester, navigator, surfaceTransformEndpoint(bounds: destinationBounds));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pumpWidget(app('After'));
    expect(navigatorKey.currentState, same(navigator));
    expect(navigator.widget.observers.whereType<MorphNavigatorObserver>().single, same(observer));
    expect(navigator.canPop(), isTrue);
    expect(events.pushed, hasLength(2));
    await tester.pumpAndSettle();
    navigator.pop();
    await tester.pumpAndSettle();
    expect(events.popped, hasLength(1));
    expect(tester.takeException(), isNull);
  });

  for (final supplied in [MateoNavigatorObserver(), MorphNavigatorObserver()]) {
    testWidgets('when ${supplied.runtimeType} is supplied, it should avoid installing a duplicate', (tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MateoApp(
          theme: surfaceTransformTheme,
          navigatorKey: navigatorKey,
          navigatorObservers: [supplied],
          home: surfaceTransformEndpoint(bounds: sourceBounds),
        ),
      );
      await tester.pumpAndSettle();
      expect(navigatorKey.currentState!.widget.observers.whereType<MorphNavigatorObserver>().single, same(supplied));
      await startSurfaceTransformAnimationFlight(
        tester,
        navigatorKey.currentState!,
        surfaceTransformEndpoint(bounds: destinationBounds),
      );
      expect(surfaceFlight, findsOneWidget);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('when a router owns navigation, it should transform using its retained Mateo observer', (tester) async {
    final router = SurfaceTransformTestRouter(home: surfaceTransformEndpoint(bounds: sourceBounds));
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MateoApp.router(
        theme: surfaceTransformTheme,
        routerConfig: RouterConfig<Object>(routerDelegate: router),
      ),
    );
    await tester.pumpAndSettle();
    expect(router.navigatorKey.currentState!.widget.observers, [router.observer]);
    await startSurfaceTransformAnimationFlight(
      tester,
      router.navigatorKey.currentState!,
      surfaceTransformEndpoint(
        bounds: destinationBounds,
        view: true,
      ),
    );
    expect(surfaceFlight, findsOneWidget);
    await tester.pumpAndSettle();
    router.navigatorKey.currentState!.pop();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('when a nested navigator transforms a surface, it should use its own observer and overlay', (
    tester,
  ) async {
    final outerKey = GlobalKey<NavigatorState>();
    final nestedKey = GlobalKey<NavigatorState>();
    final nestedObserver = MateoNavigatorObserver();
    await tester.pumpWidget(
      MateoApp(
        theme: surfaceTransformTheme,
        navigatorKey: outerKey,
        home: Navigator(
          key: nestedKey,
          observers: [nestedObserver],
          onGenerateRoute: (settings) => surfaceTransformRoute(surfaceTransformEndpoint(bounds: sourceBounds)),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(outerKey.currentState!.widget.observers.single, isNot(same(nestedObserver)));
    await startSurfaceTransformAnimationFlight(
      tester,
      nestedKey.currentState!,
      surfaceTransformEndpoint(bounds: destinationBounds),
    );
    expect(surfaceFlight, findsOneWidget);
    expect(outerKey.currentState!.canPop(), isFalse);
    await tester.pumpAndSettle();
    nestedKey.currentState!.pop();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
