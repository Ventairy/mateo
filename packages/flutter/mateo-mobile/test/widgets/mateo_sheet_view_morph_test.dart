import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/foundation/mateo_sheet_to_view_transition/mateo_sheet_to_view_transition.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

import '../fixtures/surface_transform_targets.dart';
import '../fixtures/surface_transform_test_widgets.dart';

void main() {
  for (final returning in [false, true]) {
    _test('intermediate golden returning=$returning', (tester) async {
      debugDefaultTargetPlatformOverride = .iOS;
      final navigator = await _sheet(tester);
      _push(navigator);
      if (returning) {
        await tester.pumpAndSettle();
        navigator.pop();
      }
      await _start(tester);
      await tester.pump(kSheetToViewTransformAnimation.duration! ~/ 2);
      expect(surfaceFlight, findsOneWidget);
      await expectLater(
        find.byKey(const ValueKey('capture')),
        matchesGoldenFile('goldens/ci/sheet_view_morph_${returning ? "pop" : "push"}.png'),
      );
      await tester.pumpAndSettle();
    });
  }

  for (final intermediate in [false, true]) {
    _test('destination header and footer handoff intermediate=$intermediate', (tester) async {
      debugDefaultTargetPlatformOverride = .iOS;
      final navigator = await _sheet(tester);
      _push(navigator, withSlots: true);
      ui.Image? firstFrame;
      if (!intermediate) {
        // Snapshot the submitted frame before post-frame flight capture changes
        // the retained layer tree in preparation for the following frame.
        tester.binding.addPostFrameCallback((_) {
          firstFrame = tester.renderObject<RenderRepaintBoundary>(find.byKey(const ValueKey('capture'))).toImageSync();
        });
      }
      await tester.pump();
      if (intermediate) {
        await _start(tester);
        await tester.pump(kSheetToViewTransformAnimation.duration! ~/ 2);
      }
      await expectLater(
        firstFrame ?? find.byKey(const ValueKey('capture')),
        matchesGoldenFile('goldens/ci/sheet_view_slots_${intermediate ? "midpoint" : "first_frame"}.png'),
      );
      firstFrame?.dispose();
      await tester.pumpAndSettle();
      expect(find.text('Close'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      navigator.pop();
      await tester.pumpAndSettle();
      expect(find.text('Sheet'), findsOneWidget);
    });
  }

  _test('autofocus keyboard layout stays continuous through the automatic handoff', (tester) async {
    final navigator = await _sheet(tester);
    const titleColor = Color(0xFF00FF00);
    const bodyColor = Color(0xFF0000FF);
    const footerColor = Color(0xFFFF0000);
    _push(
      navigator,
      header: const MateoViewHeader(
        principal: SizedBox(
          width: 120,
          height: 20,
          child: ColoredBox(color: titleColor),
        ),
      ),
      footer: const MateoViewFooter(
        principal: SizedBox(
          width: 200,
          height: 40,
          child: ColoredBox(color: footerColor),
        ),
      ),
      child: const Column(
        children: [
          SizedBox.square(
            dimension: 40,
            child: ColoredBox(color: bodyColor),
          ),
          MateoTextInput(
            placeholder: 'Autofocus field',
            presentation: .search(variant: .filled),
          ),
        ],
      ),
    );
    await _start(tester);
    await tester.pump(const Duration(milliseconds: 16));

    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pump(const Duration(milliseconds: 16));
    final midpointAdvance = kSheetToViewTransformAnimation.duration! ~/ 2;
    await tester.pump(midpointAdvance);
    expect(await _renderedColorBounds(tester, titleColor), isNotNull);
    expect(await _renderedColorBounds(tester, bodyColor), isNotNull);

    final remaining = kSheetToViewTransformAnimation.duration! - midpointAdvance - const Duration(milliseconds: 49);
    await tester.pump(remaining);
    final flightTitle = await _renderedColorBounds(tester, titleColor);
    final flightBody = await _renderedColorBounds(tester, bodyColor);
    final flightFooter = await _renderedColorBounds(tester, footerColor);
    await tester.pumpAndSettle();
    final settledTitle = await _renderedColorBounds(tester, titleColor);
    final settledBody = await _renderedColorBounds(tester, bodyColor);
    final settledFooter = await _renderedColorBounds(tester, footerColor);

    expect(flightTitle, isNotNull);
    expect(flightBody, isNotNull);
    expect(settledTitle, isNotNull);
    expect(settledBody, isNotNull);
    expect(flightFooter, isNotNull);
    expect(settledFooter, isNotNull);
    expect((flightFooter!.top - settledFooter!.top).abs(), lessThanOrEqualTo(2));
  });

  _test('the page behind the sheet remains painted after a page round trip', (tester) async {
    final navigator = await _sheet(
      tester,
      home: const MateoView(
        surface: MateoViewSurface(
          color: Color(0xFF2468AC),
          child: Center(child: Text('Home')),
        ),
      ),
    );
    Future<List<int>> backgroundPixels() async {
      final image = await tester.renderObject<RenderRepaintBoundary>(find.byKey(const ValueKey('capture'))).toImage();
      final bytes = await image.toByteData();
      final pixels = bytes!.buffer.asUint8List().take(image.width * 300 * 4).toList();
      image.dispose();
      return pixels;
    }

    final before = (await tester.runAsync(backgroundPixels))!;
    _push(navigator);
    await tester.pumpAndSettle();
    navigator.pop();
    await tester.pumpAndSettle();
    expect(await tester.runAsync(backgroundPixels), before);
  });

  _test('a sheet above a morphed page uses ordinary sheet presentation', (tester) async {
    final navigator = await _sheet(tester);
    _push(navigator);
    await tester.pumpAndSettle();
    unawaited(
      showMateoSheet<void>(
        context: navigator.context,
        view: const MateoSheetView(surface: MateoSheetViewSurface(child: Text('Next'))),
      ),
    );
    await _start(tester);
    expect(surfaceFlight, findsNothing);
    await tester.pumpAndSettle();
  });

  _test('independent nested Navigators do not share automatic endpoints', (tester) async {
    final left = GlobalKey<NavigatorState>();
    final right = GlobalKey<NavigatorState>();
    final leftObserver = MateoNavigatorObserver();
    final rightObserver = MateoNavigatorObserver();
    await tester.pumpWidget(
      MateoApp(
        theme: surfaceTransformTheme,
        home: Row(
          children: [
            Expanded(
              child: Navigator(
                key: left,
                observers: [leftObserver],
                onGenerateRoute: (_) => PageRouteBuilder<void>(pageBuilder: (_, _, _) => const Text('Left')),
              ),
            ),
            Expanded(
              child: Navigator(
                key: right,
                observers: [rightObserver],
                onGenerateRoute: (_) => PageRouteBuilder<void>(pageBuilder: (_, _, _) => const Text('Right')),
              ),
            ),
          ],
        ),
      ),
    );
    unawaited(
      showMateoSheet<void>(
        context: tester.element(find.text('Left')),
        view: const MateoSheetView(surface: MateoSheetViewSurface(child: Text('Sheet'))),
      ),
    );
    await tester.pumpAndSettle();
    _push(right.currentState!);
    await _start(tester);
    expect(surfaceFlight, findsNothing);
    await tester.pumpAndSettle();
    _push(left.currentState!);
    await _start(tester);
    expect(surfaceFlight, findsOneWidget);
    await tester.pumpAndSettle();
  });

  _test('rapid return releases the flight', (tester) async {
    final navigator = await _sheet(tester);
    _push(navigator);
    await _start(tester);
    await tester.pump(const Duration(milliseconds: 70));
    navigator.pop();
    await tester.pumpAndSettle();
    expect(surfaceFlight, findsNothing);
    expect(find.text('Sheet'), findsOneWidget);
  });

  _test('pop veto retains the destination', (tester) async {
    final navigator = await _sheet(tester);
    final route = const MateoPage<void>(
      child: PopScope(
        canPop: false,
        child: MateoView(surface: MateoViewSurface(child: Text('Destination'))),
      ),
    ).createRoute(navigator.context);
    navigator.push(route);
    await tester.pumpAndSettle();
    await navigator.maybePop();
    await tester.pumpAndSettle();
    expect(route.isCurrent, isTrue);
    expect(route.popGestureEnabled, isFalse);
    expect(surfaceFlight, findsNothing);
  });

  for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
    for (final fullscreen in [false, true]) {
      _test('$platform morphs with fullscreen=$fullscreen and a shared route clock', (tester) async {
        debugDefaultTargetPlatformOverride = platform;
        final navigator = await _sheet(tester);
        final sheet = tester.element(find.byType(MateoSheetView));
        final bounds = tester.getRect(find.byType(MateoSheetViewSurface));
        final route = _push(navigator, fullscreen: fullscreen);
        await _start(tester);
        expect(route.transitionDuration, kSheetToViewTransformAnimation.duration);
        expect(surfaceFlight, findsOneWidget);
        expect(tester.getRect(surfaceFlight), bounds);
        await tester.pump(kSheetToViewTransformAnimation.duration! ~/ 2);
        expect(tester.getRect(surfaceFlight).height, greaterThan(bounds.height));
        expect(route.overlayEntries.first.opaque, isFalse);
        expect(find.text('Home'), findsOneWidget);
        await tester.pumpAndSettle();
        expect(route.overlayEntries.first.opaque, isTrue);
        expect(find.text('Home'), findsNothing);
        navigator.pop();
        await _start(tester);
        expect(surfaceFlight, findsOneWidget);
        await tester.pumpAndSettle();
        expect(tester.element(find.byType(MateoSheetView)), same(sheet));
        expect(tester.getRect(find.byType(MateoSheetViewSurface)), bounds);
      });
    }
    for (final commit in [false, true]) {
      _test('$platform route-driven Back commit=$commit', (tester) async {
        debugDefaultTargetPlatformOverride = platform;
        final navigator = await _sheet(tester);
        final route = _push(navigator);
        await tester.pumpAndSettle();
        if (platform == TargetPlatform.iOS) {
          final gesture = await tester.startGesture(const Offset(1, 250));
          await gesture.moveBy(const Offset(140, 0));
          await tester.pump();
          await tester.pump();
          await gesture.moveBy(Offset(commit ? 300 : -130, 0));
          await tester.pump(const Duration(milliseconds: 300));
          await gesture.up();
        } else {
          await _back(tester, 'startBackGesture', 0);
          await _back(tester, 'updateBackGestureProgress', 0.35);
          await tester.pump();
          await tester.pump();
          await _back(tester, commit ? 'commitBackGesture' : 'cancelBackGesture');
        }
        await tester.pumpAndSettle();
        expect(route.isCurrent, !commit);
        expect(surfaceFlight, findsNothing);
        expect(navigator.userGestureInProgress, isFalse);
        expect(find.text(commit ? 'Sheet' : 'Destination'), findsOneWidget);
      });
    }
  }

  for (final motion in <MateoViewAnimation?>[
    null,
    MateoViewAnimation.transform(
      target: surfaceTransformTarget('explicit'),
    ),
  ]) {
    _test('automatic target precedes ${motion.runtimeType}', (tester) async {
      final navigator = await _sheet(tester);
      _push(navigator, animation: motion);
      await _start(tester);
      expect(surfaceFlight, findsOneWidget);
      await tester.pumpAndSettle();
      final morph = tester.widget<Morph>(find.ancestor(of: find.text('Destination'), matching: find.byType(Morph)));
      expect(morph.targets.length, motion == null ? 1 : 3);
      final target = morph.targets.first;
      expect(target.watchDestination, isTrue);
      if (motion != null) {
        expect(morph.targets.last.watchDestination, isFalse);
      }
      tester.element(find.byType(MateoViewSurface)).markNeedsBuild();
      await tester.pump();
      expect(
        tester.widget<Morph>(find.ancestor(of: find.text('Destination'), matching: find.byType(Morph))).targets.first,
        same(target),
      );
    });
  }

  for (final operation in ['sheet', 'page', 'replace']) {
    _test('$operation does not use the automatic relationship', (tester) async {
      final navigator = await _sheet(tester);
      if (operation == 'sheet') {
        unawaited(
          showMateoSheet<void>(
            context: navigator.context,
            view: const MateoSheetView(surface: MateoSheetViewSurface(child: Text('Next'))),
          ),
        );
      } else if (operation == 'replace') {
        navigator.pushReplacement<void, void>(
          const MateoPage<void>(
            child: MateoView(surface: MateoViewSurface(child: Text('Next'))),
          ).createRoute(navigator.context),
        );
      } else {
        _push(navigator);
        await tester.pumpAndSettle();
        _push(navigator);
      }
      await _start(tester);
      expect(surfaceFlight, findsNothing);
      await tester.pumpAndSettle();
    });
  }

  _test('plain Morph observer does not enable automatic matching', (tester) async {
    final navigator = await _sheet(tester, observer: MorphNavigatorObserver());
    _push(navigator);
    await _start(tester);
    expect(surfaceFlight, findsNothing);
    await tester.pumpAndSettle();
  });

  _test('reduced motion completes without a flight', (tester) async {
    final navigator = await _sheet(tester, reducedMotion: true);
    _push(navigator);
    await _start(tester);
    expect(surfaceFlight, findsNothing);
    await tester.pumpAndSettle();
    navigator.pop();
    await tester.pumpAndSettle();
    expect(find.text('Sheet'), findsOneWidget);
  });

  _test('page-to-page falls back to the explicit target', (tester) async {
    final navigator = await _sheet(tester);
    navigator.pop();
    await tester.pumpAndSettle();
    _push(
      navigator,
      animation: .transform(
        target: surfaceTransformTarget('details'),
      ),
    );
    await tester.pumpAndSettle();
    _push(
      navigator,
      animation: .transform(
        target: surfaceTransformTarget('details'),
      ),
    );
    await _start(tester);
    expect(surfaceFlight, findsOneWidget);
    await tester.pumpAndSettle();
  });

  _test('return retains scroll position and fixed slots', (tester) async {
    final navigator = await _sheet(tester, scrollable: true);
    await tester.drag(find.text('Sheet'), const Offset(0, -180));
    await tester.pumpAndSettle();
    final scroll = tester.state<ScrollableState>(find.byType(Scrollable));
    final offset = scroll.position.pixels;
    expect(offset, greaterThan(0));
    _push(navigator);
    await _start(tester);
    expect(surfaceFlight, findsOneWidget);
    await tester.pumpAndSettle();
    navigator.pop();
    await tester.pumpAndSettle();
    expect(tester.state<ScrollableState>(find.byType(Scrollable)), same(scroll));
    expect(scroll.position.pixels, offset);
    expect(find.text('Footer'), findsOneWidget);
    expect(find.text('Header'), findsOneWidget);
    expect(find.text('Overlay'), findsOneWidget);
  });
}

PageRoute<void> _push(
  NavigatorState navigator, {
  MateoViewAnimation? animation,
  bool fullscreen = false,
  bool withSlots = false,
  MateoViewHeader? header,
  MateoViewFooter? footer,
  Widget child = const Center(child: Text('Destination')),
}) {
  final route = MateoPage<void>(
    fullscreenDialog: fullscreen,
    child: MateoView(
      animation: animation,
      header: header ?? (withSlots ? const MateoViewHeader(leading: Text('Close')) : null),
      footer: footer ?? (withSlots ? const MateoViewFooter(principal: Text('Save')) : null),
      surface: MateoViewSurface(child: child),
    ),
  ).createRoute(navigator.context);
  navigator.push(route);
  return route;
}

Future<Rect?> _renderedColorBounds(WidgetTester tester, Color color) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const ValueKey('capture')),
  );
  final argb = color.toARGB32();
  return tester.runAsync<Rect?>(() async {
    final image = await boundary.toImage();
    final bytes = (await image.toByteData(format: .rawRgba))!;
    final red = (argb >> 16) & 0xff;
    final green = (argb >> 8) & 0xff;
    final blue = argb & 0xff;
    final alpha = (argb >> 24) & 0xff;
    int? left;
    int? top;
    int? right;
    int? bottom;
    for (var y = 0; y < image.height; y += 1) {
      for (var x = 0; x < image.width; x += 1) {
        final offset = (y * image.width + x) * 4;
        if ((bytes.getUint8(offset) - red).abs() > 32 ||
            (bytes.getUint8(offset + 1) - green).abs() > 32 ||
            (bytes.getUint8(offset + 2) - blue).abs() > 32 ||
            (bytes.getUint8(offset + 3) - alpha).abs() > 32) {
          continue;
        }
        left = left == null ? x : math.min(left, x);
        top = top == null ? y : math.min(top, y);
        right = right == null ? x : math.max(right, x);
        bottom = bottom == null ? y : math.max(bottom, y);
      }
    }
    image.dispose();
    if (left == null) return null;
    return Rect.fromLTRB(
      left.toDouble(),
      top!.toDouble(),
      (right! + 1).toDouble(),
      (bottom! + 1).toDouble(),
    );
  });
}

Future<NavigatorState> _sheet(
  WidgetTester tester, {
  NavigatorObserver? observer,
  bool reducedMotion = false,
  bool scrollable = false,
  Widget home = const Text('Home'),
}) async {
  tester.view
    ..devicePixelRatio = 1
    ..physicalSize = const Size(400, 800);
  addTearDown(tester.view.reset);
  final navigator = GlobalKey<NavigatorState>();
  await tester.pumpWidget(
    MateoApp(
      navigatorKey: navigator,
      navigatorObservers: [?observer],
      theme: surfaceTransformTheme,
      builder: (context, child) => RepaintBoundary(
        key: const ValueKey('capture'),
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: reducedMotion),
          child: child!,
        ),
      ),
      home: home,
    ),
  );
  unawaited(
    showMateoSheet<void>(
      context: tester.element(find.text('Home')),
      maxExtent: 380,
      view: MateoSheetView(
        header: const MateoSheetViewHeader(presentation: .custom(principal: Text('Header'))),
        footer: const MateoSheetViewFooter(principal: Text('Footer')),
        overlay: const Align(alignment: .centerRight, child: Text('Overlay')),
        surface: scrollable
            ? const MateoSheetViewSurface.scrollable(
                child: Column(children: [Text('Sheet'), SizedBox(height: 1400), Text('End')]),
              )
            : const MateoSheetViewSurface(child: SizedBox(height: 140, child: Text('Sheet'))),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return navigator.currentState!;
}

Future<void> _start(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
  await tester.pump();
}

void _test(String name, WidgetTesterCallback callback) {
  testWidgets(name, (tester) async {
    try {
      await callback(tester);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });
}

Future<void> _back(WidgetTester tester, String method, [double? progress]) async {
  await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
    'flutter/backgesture',
    const StandardMethodCodec().encodeMethodCall(
      MethodCall(
        method,
        progress == null
            ? null
            : <String, Object>{
                'touchOffset': <double>[5, 250],
                'progress': progress,
                'swipeEdge': 0,
              },
      ),
    ),
    (_) {},
  );
}
