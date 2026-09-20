import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/bases/base_mateo_page_route/base_mateo_page_route.dart';

const ValueKey<String> _pageKey = .new('page');

void main() {
  for (final platform in [TargetPlatform.iOS, TargetPlatform.android]) {
    for (final transition in <MateoPageTransition?>[null, const .wash(), const .push()]) {
      _testWidgets('$platform $transition suppresses push and pop above a sheet', (tester) async {
        debugDefaultTargetPlatformOverride = platform;
        final navigator = await _openSheet(tester);
        final sheetElement = tester.element(find.byType(MateoSheetView));
        final route = MateoPage<void>(
          transition: transition,
          child: const SizedBox.expand(key: _pageKey),
        ).createRoute(navigator.context) as BaseMateoPageRoute<void>;
        navigator.push(route);
        await tester.pump();
        expect(route.isPrimaryVisualMotionDisabled, isTrue);
        expect(route.transitionDuration, const Duration(milliseconds: 320));
        expect(route.reverseTransitionDuration, const Duration(milliseconds: 320));
        expect(route.animation!.value, 0);
        _expectSettled(tester);
        await tester.pumpAndSettle();
        navigator.pop();
        await tester.pump();

        expect(tester.element(find.byType(MateoSheetView)), same(sheetElement));
        _expectSettled(tester);
        await tester.pumpAndSettle();
        expect(find.byKey(_pageKey), findsNothing);
      });
    }

    for (final sheet in [false, true]) {
      _testWidgets('$platform suppresses motion only above a sheet, fullscreen=$sheet', (tester) async {
        debugDefaultTargetPlatformOverride = platform;
        final navigator = await _openSheet(tester);
        if (!sheet) {
          navigator.pop();
          await tester.pumpAndSettle();
        }
        final route = MateoPage<void>(
          fullscreenDialog: sheet,
          child: const SizedBox.expand(key: _pageKey),
        ).createRoute(navigator.context) as BaseMateoPageRoute<void>;
        navigator.push(route);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 80));
        expect(route.isPrimaryVisualMotionDisabled, sheet);
        if (sheet) _expectSettled(tester);
        await tester.pumpAndSettle();
        navigator.pop();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 80));
        if (sheet) _expectSettled(tester);
        await tester.pumpAndSettle();
      });
    }

    _testWidgets('$platform retains secondary motion above a suppressed page', (tester) async {
      debugDefaultTargetPlatformOverride = platform;
      final navigator = await _openSheet(tester);
      final route = const MateoPage<void>(child: SizedBox.expand(key: _pageKey)).createRoute(navigator.context);
      navigator.push(route);
      await tester.pumpAndSettle();
      navigator.push(const MateoPage<void>(child: SizedBox.expand()).createRoute(navigator.context));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(route.secondaryAnimation!.value, greaterThan(0));
      expect(route.secondaryAnimation!.value, lessThan(1));
      final fades = tester.widgetList<FadeTransition>(
        find.ancestor(of: find.byKey(_pageKey), matching: find.byType(FadeTransition)),
      );
      expect(
        tester.getTopLeft(find.byKey(_pageKey)) != Offset.zero || fades.any((fade) => fade.opacity.value < 1),
        isTrue,
      );
      await tester.pumpAndSettle();
      navigator.pop();
      await tester.pumpAndSettle();
      _expectSettled(tester);
    });

    for (final commit in [false, true]) {
      _testWidgets('$platform suppressed Back gesture commit=$commit', (tester) async {
        debugDefaultTargetPlatformOverride = platform;
        final navigator = await _openSheet(tester);
        final route = const MateoPage<void>(child: SizedBox.expand(key: _pageKey)).createRoute(navigator.context);
        navigator.push(route);
        await tester.pumpAndSettle();
        if (platform == TargetPlatform.iOS) {
          final gesture = await tester.startGesture(const Offset(1, 250));
          await gesture.moveBy(const Offset(140, 0));
          await tester.pump();
          _expectSettled(tester);
          await gesture.moveBy(Offset(commit ? 600 : -130, 0));
          await tester.pump(const Duration(milliseconds: 300));
          await gesture.up();
        } else {
          await _back(tester, 'startBackGesture', 0);
          await _back(tester, 'updateBackGestureProgress', 0.35);
          await tester.pump();
          expect(route.animation!.value, closeTo(0.65, 0.01));
          _expectSettled(tester);
          await _back(tester, commit ? 'commitBackGesture' : 'cancelBackGesture');
        }
        await tester.pumpAndSettle();
        expect(find.byKey(_pageKey), commit ? findsNothing : findsOneWidget);
        expect(navigator.userGestureInProgress, isFalse);
      });
    }

    _testWidgets('$platform respects a pop veto above a sheet', (tester) async {
      debugDefaultTargetPlatformOverride = platform;
      final navigator = await _openSheet(tester);
      final route = const MateoPage<void>(
        child: PopScope(canPop: false, child: SizedBox.expand(key: _pageKey)),
      ).createRoute(navigator.context);
      navigator.push(route);
      await tester.pumpAndSettle();
      expect(route.popGestureEnabled, isFalse);
      await navigator.maybePop();
      await tester.pumpAndSettle();
      expect(route.isCurrent, isTrue);
    });
  }
}

void _expectSettled(WidgetTester tester) {
  expect(tester.getRect(find.byKey(_pageKey)), const Rect.fromLTWH(0, 0, 800, 600));
  for (final fade in tester.widgetList<FadeTransition>(
    find.ancestor(of: find.byKey(_pageKey), matching: find.byType(FadeTransition)),
  )) {
    expect(fade.opacity.value, 1);
  }
}

Future<NavigatorState> _openSheet(WidgetTester tester) async {
  final key = GlobalKey<NavigatorState>();
  await tester.pumpWidget(
    MateoApp(
      navigatorKey: key,
      theme: MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: const Color(0xFFFFFFFF)),
      home: const Text('Home'),
    ),
  );
  unawaited(
    showMateoSheet<void>(
      context: tester.element(find.text('Home')),
      view: const MateoSheetView(
        surface: MateoSheetViewSurface(child: SizedBox(height: 180, child: Text('Sheet'))),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return key.currentState!;
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

void _testWidgets(String description, WidgetTesterCallback callback) {
  testWidgets(description, (tester) async {
    try {
      await callback(tester);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });
}
