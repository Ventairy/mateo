import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

const ValueKey<String> _captureKey = ValueKey('interrupted transition capture');
const ValueKey<String> _markerKey = ValueKey('moving source marker');
const _markerLabel = 'Moving source marker';
const ({Color first, Color second}) _markerColors = (first: Color(0xFF00FF00), second: Color(0xFFFFFF00));
const _viewportSize = Size(400, 600);
final _theme = MateoThemeData.light(accentColor: const Color(0xFF7551FF), onAccent: const Color(0xFFFFFFFF));

void main() {
  for (final direction in MateoPageTransitionDirection.values) {
    testWidgets(
      'when an unfinished ${direction.name} push is covered and returned to, it should keep source pixels and accessibility bounds together',
      (tester) async {
        final previousPlatform = debugDefaultTargetPlatformOverride;
        debugDefaultTargetPlatformOverride = .android;
        final semantics = tester.ensureSemantics();
        tester.view
          ..devicePixelRatio = 1
          ..physicalSize = _viewportSize;
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);

        try {
          final navigatorKey = GlobalKey<NavigatorState>();
          await tester.pumpWidget(
            MateoApp(
              theme: _theme,
              builder: (_, child) => RepaintBoundary(key: _captureKey, child: child),
              home: Builder(
                builder: (context) => Navigator(
                  key: navigatorKey,
                  onGenerateRoute: (_) => MateoPage<void>(
                    transition: .push(direction: direction),
                    child: ColoredBox(color: _theme.colorScheme.background),
                  ).createRoute(context),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final navigator = navigatorKey.currentState!;
          final enteringRoute = MateoPage<void>(
            transition: .push(direction: direction),
            child: _markedPage(direction),
          ).createRoute(navigator.context);
          navigator.push(enteringRoute);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 300));
          expect(enteringRoute.animation!.isAnimating, isTrue);
          expect(enteringRoute.animation!.value, lessThan(1));
          final initialMarkerBounds = tester.getRect(find.byKey(_markerKey));
          await _expectMarkerPixelsAndSemantics(tester, semanticsAttached: true);
          await tester.pump(const Duration(milliseconds: 60));
          expect(enteringRoute.animation!.isAnimating, isTrue);
          expect(tester.getRect(find.byKey(_markerKey)), isNot(initialMarkerBounds));
          await _expectMarkerPixelsAndSemantics(tester, semanticsAttached: true);

          final coveringRoute = MateoPage<void>(
            transition: .push(direction: direction),
            // A transparent edge keeps the source pattern clear beneath the
            // entering page's edge wash while its opaque center covers it.
            child: const Padding(
              padding: EdgeInsets.all(1),
              child: ColoredBox(color: Color(0xFF000000)),
            ),
          ).createRoute(navigator.context);
          navigator.push(coveringRoute);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 120));

          expect(enteringRoute.animation!.isAnimating, isTrue);
          expect(enteringRoute.animation!.value, lessThan(1));
          expect(enteringRoute.secondaryAnimation!.isAnimating, isTrue);
          expect(coveringRoute.animation!.status, AnimationStatus.forward);
          expect(tester.getRect(find.byKey(_markerKey)), isNot(initialMarkerBounds));
          await _expectMarkerPixelsAndSemantics(tester, semanticsAttached: false);

          navigator.pop();
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 60));

          expect(enteringRoute.animation!.isAnimating, isTrue);
          expect(enteringRoute.animation!.value, lessThan(1));
          expect(enteringRoute.secondaryAnimation!.isAnimating, isTrue);
          expect(coveringRoute.animation!.status, AnimationStatus.reverse);
          expect(enteringRoute.isCurrent, isTrue);
          // The covering route's barrier retains its accessibility scope until
          // the reverse transition finishes, even after B becomes current.
          await _expectMarkerPixelsAndSemantics(tester, semanticsAttached: false);
          await tester.pumpAndSettle();
          expect(enteringRoute.isCurrent, isTrue);
          await _expectMarkerPixelsAndSemantics(tester, semanticsAttached: true);
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox());
        } finally {
          semantics.dispose();
          debugDefaultTargetPlatformOverride = previousPlatform;
        }
      },
    );
  }
}

Widget _markedPage(MateoPageTransitionDirection direction) {
  final markerPosition = switch (direction) {
    .up => const Offset(40, 40),
    .down => const Offset(40, 512),
    .left => const Offset(40, 240),
    .right => const Offset(296, 240),
  };
  return ColoredBox(
    color: _theme.colorScheme.accent,
    child: Stack(
      children: [
        Positioned(
          left: markerPosition.dx,
          top: markerPosition.dy,
          child: Semantics(
            container: true,
            label: _markerLabel,
            child: SizedBox(
              key: _markerKey,
              width: 64,
              height: 48,
              child: Row(
                crossAxisAlignment: .stretch,
                children: [
                  Expanded(child: ColoredBox(color: _markerColors.first)),
                  Expanded(child: ColoredBox(color: _markerColors.second)),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Future<void> _expectMarkerPixelsAndSemantics(WidgetTester tester, {required bool semanticsAttached}) async {
  final markerBounds = tester.getRect(find.byKey(_markerKey));
  expect(markerBounds.left, greaterThanOrEqualTo(0));
  expect(markerBounds.top, greaterThanOrEqualTo(0));
  expect(markerBounds.right, lessThanOrEqualTo(_viewportSize.width));
  expect(markerBounds.bottom, lessThanOrEqualTo(_viewportSize.height));

  final colors = await tester.runAsync(() async {
    final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(_captureKey));
    final image = await boundary.toImage();
    try {
      final bytes = (await image.toByteData(format: .rawRgba))!;
      Color sample(double horizontalFraction) {
        final position = Offset(
          markerBounds.left + markerBounds.width * horizontalFraction,
          markerBounds.center.dy,
        );
        final pixelOffset = (position.dy.floor() * image.width + position.dx.floor()) * 4;
        return Color.fromARGB(
          bytes.getUint8(pixelOffset + 3),
          bytes.getUint8(pixelOffset),
          bytes.getUint8(pixelOffset + 1),
          bytes.getUint8(pixelOffset + 2),
        );
      }

      return (first: sample(0.25), second: sample(0.75));
    } finally {
      image.dispose();
    }
  });
  expect(colors, _markerColors);

  final semanticNode = tester.getSemantics(find.bySemanticsLabel(_markerLabel));
  expect(semanticNode.attached, semanticsAttached);
  if (!semanticsAttached) return;
  final semanticBounds = _globalSemanticBounds(semanticNode);
  expect(semanticBounds.left, closeTo(markerBounds.left, 1e-8));
  expect(semanticBounds.top, closeTo(markerBounds.top, 1e-8));
  expect(semanticBounds.size, markerBounds.size);
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
