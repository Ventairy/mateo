import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

final surfaceTransformTheme = MateoThemeData.light(
  accentColor: const Color(0xFF4A5CFF),
  onAccent: MateoPalette().white,
);

final Finder surfaceFlight = find.byWidgetPredicate(
  (widget) =>
      widget is DecoratedBox &&
      widget.decoration is ShapeDecoration &&
      (widget.decoration as ShapeDecoration).color != null,
  description: 'the filled surface transform animation flight',
);

Widget surfaceTransformEndpoint({
  required Rect bounds,
  Key? key,
  MateoSurfaceAnimation? animation,
  Object id = 'details',
  bool view = false,
  bool scrollable = false,
  bool disabled = false,
  Color? color,
  MateoSurfaceShape shape = const .rounded(radius: 24),
  MateoViewSurfaceShape viewShape = const .rounded(radius: 24),
  MateoElevation? elevation,
  MateoEdgeEffect edgeEffect = const .none(),
  Widget child = const SizedBox(),
}) {
  animation ??= disabled ? const MateoSurfaceAnimation.none() : MateoSurfaceAnimation.transform(id: id);
  final Widget surface;
  if (view) {
    surface = MateoView(
      key: key,
      padding: .zero,
      surface: scrollable
          ? MateoViewSurface.scrollable(
              color: color,
              shape: viewShape,
              animation: animation,
              elevation: elevation,
              edgeEffect: edgeEffect,
              child: child,
            )
          : MateoViewSurface(
              color: color,
              shape: viewShape,
              animation: animation,
              elevation: elevation,
              edgeEffect: edgeEffect,
              child: child,
            ),
    );
  } else {
    surface = scrollable
        ? MateoSurface.scrollable(
            key: key,
            color: color,
            shape: shape,
            animation: animation,
            elevation: elevation,
            edgeEffect: edgeEffect,
            child: child,
          )
        : MateoSurface(
            key: key,
            color: color,
            shape: shape,
            animation: animation,
            elevation: elevation,
            edgeEffect: edgeEffect,
            child: child,
          );
  }
  return Stack(
    children: [Positioned.fromRect(rect: bounds, child: surface)],
  );
}

PageRoute<void> surfaceTransformRoute(Widget child, {Duration duration = Duration.zero}) => PageRouteBuilder<void>(
  transitionDuration: duration,
  reverseTransitionDuration: duration,
  pageBuilder: (context, animation, secondaryAnimation) => child,
);

Future<void> startSurfaceTransformAnimationFlight(
  WidgetTester tester,
  NavigatorState navigator,
  Widget destination, {
  Duration routeDuration = Duration.zero,
  bool prepareOffstage = false,
}) async {
  // Navigation completes on pop, not on landing.
  final route = surfaceTransformRoute(destination, duration: routeDuration);
  navigator.push<void>(route);
  if (prepareOffstage) route.offstage = true;
  await tester.pump();
  if (prepareOffstage) route.offstage = false;
  await tester.pump();
}

ShapeDecoration surfaceTransformAnimationFlightDecoration(WidgetTester tester) =>
    tester.widget<DecoratedBox>(surfaceFlight).decoration as ShapeDecoration;

void expectSurfaceOutline(Path actual, Path expected, {double tolerance = .03}) {
  expect(actual.computeMetrics().single.isClosed, isTrue);
  final bounds = expected.getBounds();
  expect(actual.getBounds(), rectMoreOrLessEquals(bounds, epsilon: tolerance));
  double radius(Path path, Offset direction) {
    var inside = 0.0;
    var outside = bounds.size.longestSide * 2;
    for (var i = 0; i < 24; i++) {
      final middle = (inside + outside) / 2;
      if (path.contains(bounds.center + direction * middle)) {
        inside = middle;
      } else {
        outside = middle;
      }
    }
    return (inside + outside) / 2;
  }

  for (var i = 0; i < 128; i++) {
    final angle = 2 * math.pi * i / 128;
    final direction = Offset(math.cos(angle), math.sin(angle));
    expect(radius(actual, direction), closeTo(radius(expected, direction), tolerance));
  }
}
