import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import 'surface_transform_targets.dart';

final surfaceTransformTheme = MateoThemeData.light(
  accentColor: const Color(0xFF4A5CFF),
  onAccent: MateoPalette().white,
);

final Finder surfaceFlight = find.byWidgetPredicate(
  (widget) =>
      widget is ClipPath &&
      widget.clipper is ShapeBorderClipper &&
      widget.child is ColoredBox &&
      (widget.child! as ColoredBox).child is Stack,
  description: 'the filled surface transform animation flight',
);

MateoViewAnimation? viewAnimationFor(MateoSurfaceAnimation? animation) => switch (animation) {
  MateoSurfaceAnimationTransform(:final target, :final shape, :final contentEffects) => MateoViewAnimation.transform(
    target: target,
    shape: shape,
    contentEffects: contentEffects,
  ),
  MateoSurfaceAnimationNone() || MateoSurfaceAnimationPop() => null,
  null => null,
};

Widget surfaceTransformEndpoint({
  required Rect bounds,
  Key? key,
  MateoSurfaceAnimation? animation,
  Object id = 'details',
  bool view = false,
  bool scrollable = false,
  bool disabled = false,
  Color? color,
  MateoShape shape = const .rounded(radius: 24),
  MateoShape viewShape = const .rounded(radius: 24),
  MateoElevation? elevation,
  MateoEdgeEffect edgeEffect = const .none(),
  Widget child = const SizedBox(),
}) {
  animation ??= disabled
      ? const MateoSurfaceAnimation.none()
      : MateoSurfaceAnimation.transform(
          target: surfaceTransformTarget(id),
        );
  final Widget surface;
  if (view) {
    final viewAnimation = viewAnimationFor(animation);
    surface = MateoView(
      key: key,
      animation: viewAnimation,
      padding: .zero,
      surface: scrollable
          ? MateoViewSurface.scrollable(
              color: color,
              shape: viewShape,
              elevation: elevation,
              edgeEffect: edgeEffect,
              child: child,
            )
          : MateoViewSurface(
              color: color,
              shape: viewShape,
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

PageRoute<void> surfaceTransformRoute(
  Widget child, {
  Duration duration = Duration.zero,
  Duration? reverseDuration,
}) => PageRouteBuilder<void>(
  transitionDuration: duration,
  reverseTransitionDuration: reverseDuration ?? duration,
  pageBuilder: (context, animation, secondaryAnimation) => child,
);

Future<void> startSurfaceTransformAnimationFlight(
  WidgetTester tester,
  NavigatorState navigator,
  Widget destination, {
  Duration routeDuration = Duration.zero,
  Duration? routeReverseDuration,
  bool prepareOffstage = false,
}) async {
  // Navigation completes on pop, not on landing.
  final route = surfaceTransformRoute(
    destination,
    duration: routeDuration,
    reverseDuration: routeReverseDuration,
  );
  navigator.push<void>(route);
  if (prepareOffstage) route.offstage = true;
  await tester.pump();
  if (prepareOffstage) route.offstage = false;
  await tester.pump();
}

ShapeDecoration surfaceTransformAnimationFlightDecoration(WidgetTester tester) {
  final flight = tester.widget<ClipPath>(surfaceFlight);
  return ShapeDecoration(
    color: (flight.child! as ColoredBox).color,
    shape: (flight.clipper! as ShapeBorderClipper).shape,
  );
}

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
