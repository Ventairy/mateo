import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

const Key _captureKey = ValueKey('landing capture');
const _headerColor = Color(0xFFFF0000);
const _footerColor = Color(0xFF00FF00);
const _bodyColor = Color(0xFF0000FF);
final _theme = MateoThemeData.light(accentColor: const Color(0xFF7551FF), onAccent: const Color(0xFFFFFFFF));

void main() {
  for (final direction in MateoPageTransitionDirection.values) {
    testWidgets('when snapshot push $direction lands, its captured view should match live safe-area geometry', (
      tester,
    ) async {
      tester.view
        ..devicePixelRatio = 1
        ..physicalSize = const Size(400, 800)
        ..padding = const FakeViewPadding(top: 60, bottom: 34)
        ..viewPadding = const FakeViewPadding(top: 60, bottom: 34);
      addTearDown(tester.view.reset);
      final navigatorKey = GlobalKey<NavigatorState>();
      await _pumpHost(tester, navigatorKey: navigatorKey);
      await tester.pumpAndSettle();
      final navigator = navigatorKey.currentState!;
      navigator.push(
        MateoPage<void>(
          transition: .push(direction: direction),
          child: _view(),
        ).createRoute(navigator.context),
      );
      await tester.pump();
      for (var frame = 0; frame < 37; frame++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      await tester.pump(const Duration(milliseconds: 4));
      final captured = await _markerBounds(tester);
      await tester.pump(const Duration(milliseconds: 8));
      await tester.pumpAndSettle();
      final live = await _markerBounds(tester);
      _expectMatchingMarkers(captured, live);
      await tester.pumpWidget(const SizedBox());
    });
  }
  for (final direction in MateoPageTransitionDirection.values) {
    for (final cancel in [false, true]) {
      testWidgets(
        'when snapshot push $direction ${cancel ? 'is cancelled' : 'returns'}, it should land at the source view geometry',
        (tester) async {
          _configureView(tester);
          final navigatorKey = GlobalKey<NavigatorState>();
          await _pumpHost(tester, navigatorKey: navigatorKey, source: _view(source: true));
          await tester.pumpAndSettle();
          final navigator = navigatorKey.currentState!;
          navigator.push(
            MateoPage<void>(
              transition: .push(direction: direction),
              child: _view(),
            ).createRoute(navigator.context),
          );
          await tester.pump();
          if (cancel) {
            await _pumpDuration(tester, 200);
          } else {
            await tester.pumpAndSettle();
          }
          navigator.pop();
          await tester.pump();
          await _pumpDuration(tester, cancel ? 196 : 596);
          final captured = await _markerBounds(tester);
          await tester.pump(const Duration(milliseconds: 8));
          await tester.pumpAndSettle();
          _expectMatchingMarkers(captured, await _markerBounds(tester), source: true);
          await tester.pumpWidget(const SizedBox());
        },
      );
    }
  }
  testWidgets('when a captured push moves its safe header, taps and accessibility should follow its painted position', (
    tester,
  ) async {
    _configureView(tester);
    final semantics = tester.ensureSemantics();
    const Key headerKey = ValueKey('safe header action');
    var taps = 0;
    void onTap() => taps++;
    final navigatorKey = GlobalKey<NavigatorState>();
    await _pumpHost(tester, navigatorKey: navigatorKey);
    await tester.pumpAndSettle();
    final navigator = navigatorKey.currentState!;
    navigator.push(
      MateoPage<void>(
        transition: const .push(),
        child: _view(
          header: Semantics(
            key: headerKey,
            container: true,
            label: 'Safe header action',
            button: true,
            onTap: onTap,
            child: GestureDetector(
              excludeFromSemantics: true,
              behavior: .opaque,
              onTap: onTap,
              child: const SizedBox(width: 100, height: 24, child: ColoredBox(color: _headerColor)),
            ),
          ),
        ),
      ).createRoute(navigator.context),
    );
    await tester.pump();
    await _pumpDuration(tester, 300);
    final painted = (await _markerBounds(tester))[_headerColor]!;
    final interactive = tester.getRect(find.byKey(headerKey));
    final accessible = _globalSemanticBounds(tester.getSemantics(find.byKey(headerKey)));
    expect((painted.top - interactive.top).abs(), lessThanOrEqualTo(1));
    expect((painted.top - accessible.top).abs(), lessThanOrEqualTo(1));
    await tester.tapAt(painted.center);
    expect(taps, 1);
    semantics.dispose();
    await tester.pumpWidget(const SizedBox());
  });
  for (final scenario in ['insets', 'keyboard', 'pixel density', 'transformed navigator', 'live content']) {
    testWidgets('when push changes $scenario, it should keep captured and landed view geometry together', (
      tester,
    ) async {
      _configureView(tester);
      final navigatorKey = GlobalKey<NavigatorState>();
      await _pumpHost(tester, navigatorKey: navigatorKey, transformed: scenario == 'transformed navigator');
      await tester.pumpAndSettle();
      final navigator = navigatorKey.currentState!;
      navigator.push(
        MateoPage<void>(
          transition: const .push(),
          allowSnapshotting: scenario != 'live content',
          child: _view(),
        ).createRoute(navigator.context),
      );
      await tester.pump();
      await _pumpDuration(tester, 200);
      switch (scenario) {
        case 'insets':
          tester.view
            ..padding = const FakeViewPadding(top: 80, bottom: 48)
            ..viewPadding = const FakeViewPadding(top: 80, bottom: 48);
        case 'keyboard':
          tester.view
            ..padding = const FakeViewPadding(top: 60)
            ..viewInsets = const FakeViewPadding(bottom: 260);
        case 'pixel density':
          tester.view
            ..devicePixelRatio = 2
            ..physicalSize = const Size(800, 1600)
            ..padding = const FakeViewPadding(top: 120, bottom: 68)
            ..viewPadding = const FakeViewPadding(top: 120, bottom: 68);
        case 'transformed navigator':
        case 'live content':
          break;
      }
      await _pumpDuration(tester, 396);
      final captured = await _markerBounds(tester);
      await tester.pump(const Duration(milliseconds: 8));
      await tester.pumpAndSettle();
      _expectMatchingMarkers(captured, await _markerBounds(tester));
      await tester.pumpWidget(const SizedBox());
    });
  }
}

Future<Map<Color, Rect?>> _markerBounds(WidgetTester tester) async => (await tester.runAsync(() async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(_captureKey));
  final image = await boundary.toImage();
  try {
    final bytes = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
    final bounds = <Color, Rect?>{
      for (final color in [..._colors, ..._sourceColors]) color: null,
    };
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final offset = (y * image.width + x) * 4;
        final color = Color.fromARGB(
          bytes.getUint8(offset + 3),
          bytes.getUint8(offset),
          bytes.getUint8(offset + 1),
          bytes.getUint8(offset + 2),
        );
        if (!bounds.containsKey(color)) continue;
        final pixel = Rect.fromLTWH(x.toDouble(), y.toDouble(), 1, 1);
        bounds[color] = bounds[color]?.expandToInclude(pixel) ?? pixel;
      }
    }
    return bounds;
  } finally {
    image.dispose();
  }
}))!;

const List<Color> _colors = [_headerColor, _footerColor, _bodyColor];
const List<Color> _sourceColors = [Color(0xFF00FFFF), Color(0xFFFF00FF), Color(0xFFFFFF00)];

Widget _view({bool source = false, Widget? header}) {
  final colors = source ? _sourceColors : _colors;
  Widget marker(Color color) => SizedBox(width: 100, height: 24, child: ColoredBox(color: color));
  return MateoView(
    padding: .zero,
    header: MateoViewHeader(leading: header ?? marker(colors[0])),
    footer: MateoViewFooter(leading: marker(colors[1])),
    surface: MateoViewSurface(child: Center(child: marker(colors[2]))),
  );
}

void _configureView(WidgetTester tester) {
  tester.view
    ..devicePixelRatio = 1
    ..physicalSize = const Size(400, 800)
    ..padding = const FakeViewPadding(top: 60, bottom: 34)
    ..viewPadding = const FakeViewPadding(top: 60, bottom: 34);
  addTearDown(tester.view.reset);
}

Future<void> _pumpHost(
  WidgetTester tester, {
  required GlobalKey<NavigatorState> navigatorKey,
  Widget source = const ColoredBox(color: Color(0xFFEEEEEE)),
  bool transformed = false,
}) => tester.pumpWidget(
  MateoApp(
    theme: _theme,
    builder: (_, child) => RepaintBoundary(key: _captureKey, child: child),
    home: Builder(
      builder: (context) {
        final navigator = Navigator(
          key: navigatorKey,
          onGenerateRoute: (_) => MateoPage<void>(child: source).createRoute(context),
        );
        return transformed
            ? Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 20),
                child: Transform.scale(scale: 0.9, child: navigator),
              )
            : navigator;
      },
    ),
  ),
);

Future<void> _pumpDuration(WidgetTester tester, int milliseconds) async {
  for (var frame = 0; frame < milliseconds ~/ 16; frame++) {
    await tester.pump(const Duration(milliseconds: 16));
  }
  final remainder = milliseconds % 16;
  if (remainder > 0) await tester.pump(Duration(milliseconds: remainder));
}

void _expectMatchingMarkers(Map<Color, Rect?> captured, Map<Color, Rect?> live, {bool source = false}) {
  for (final color in source ? _sourceColors : _colors) {
    expect(captured[color], isNotNull, reason: 'The captured page must contain its $color marker.');
    expect(live[color], isNotNull);
    final before = captured[color]!;
    final after = live[color]!;
    expect((before.top - after.top).abs(), lessThanOrEqualTo(1), reason: '$color top: $before -> $after');
    expect((before.left - after.left).abs(), lessThanOrEqualTo(1), reason: '$color left: $before -> $after');
    expect((before.width - after.width).abs(), lessThanOrEqualTo(1));
    expect((before.height - after.height).abs(), lessThanOrEqualTo(1));
  }
}

Rect _globalSemanticBounds(SemanticsNode node) {
  var transform = Matrix4.identity();
  SemanticsNode? current = node;
  while (current != null) {
    if (current.transform != null) transform = current.transform!.clone()..multiply(transform);
    current = current.parent;
  }
  return MatrixUtils.transformRect(transform, node.rect);
}
