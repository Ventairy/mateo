import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

RenderObject _findSkeletonRenderObject(WidgetTester tester) {
  return tester.renderObject(
    find.byWidgetPredicate(
      (widget) =>
          widget.runtimeType.toString() == '_MateoSkeletonRenderObjectWidget',
    ),
  );
}

MaterialApp _app({required Widget child, Key? key}) {
  return MaterialApp(
    key: key,
    theme: MateoTheme.light(),
    home: Scaffold(body: child),
  );
}

void main() {
  group('MateoSkeleton', () {
    testWidgets('when enabled is false, it should render the child unchanged', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(child: const MateoSkeleton(enabled: false, child: Text('Hello'))),
      );

      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets(
      'when no style is provided, it should not create an animation controller',
      (tester) async {
        await tester.pumpWidget(
          _app(child: const MateoSkeleton(child: Text('Hello'))),
        );

        expect(find.text('Hello'), findsOneWidget);
      },
    );

    testWidgets(
      'when style.effect is a MateoSkeletonShimmerEffect, it should create an animation controller',
      (tester) async {
        await tester.pumpWidget(
          _app(
            child: const MateoSkeleton(
              style: MateoSkeletonStyle(effect: MateoSkeletonShimmerEffect()),
              child: Text('Hello'),
            ),
          ),
        );

        expect(find.text('Hello'), findsOneWidget);
      },
    );

    testWidgets(
      'when style.effect is a MateoSkeletonFadeEffect, it should create an animation controller',
      (tester) async {
        await tester.pumpWidget(
          _app(
            child: const MateoSkeleton(
              style: MateoSkeletonStyle(effect: MateoSkeletonFadeEffect()),
              child: Text('Hello'),
            ),
          ),
        );

        expect(find.text('Hello'), findsOneWidget);
      },
    );

    testWidgets(
      'when the platform disables animations with style.effect, it should not schedule shimmer frames',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: MateoTheme.light(),
            home: const MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: Scaffold(
                body: MateoSkeleton(
                  style: MateoSkeletonStyle(
                    effect: MateoSkeletonShimmerEffect(),
                  ),
                  child: Text('Hello'),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(tester.binding.hasScheduledFrame, isFalse);
      },
    );

    testWidgets(
      'when skeletonizing a child, it should isolate repaint work inside a render boundary',
      (tester) async {
        await tester.pumpWidget(
          _app(child: const MateoSkeleton(child: Text('Hello'))),
        );

        final renderObject = _findSkeletonRenderObject(tester);

        expect(renderObject.isRepaintBoundary, isTrue);
      },
    );

    testWidgets(
      'when skeletonizing a child, the render object should require compositing',
      (tester) async {
        await tester.pumpWidget(
          _app(child: const MateoSkeleton(child: Text('Hello'))),
        );

        final renderObject = _findSkeletonRenderObject(tester);

        expect(renderObject.needsCompositing, isTrue);
      },
    );

    testWidgets(
      'when the widget rebuilds with style.effect toggled, it should update the render object',
      (tester) async {
        await tester.pumpWidget(
          _app(
            child: const MateoSkeleton(
              style: MateoSkeletonStyle(effect: MateoSkeletonShimmerEffect()),
              child: Text('Hello'),
            ),
          ),
        );
        final renderObject = _findSkeletonRenderObject(tester) as dynamic;
        expect(renderObject.effect, isA<MateoSkeletonShimmerEffect>());

        await tester.pumpWidget(
          _app(child: const MateoSkeleton(child: Text('Hello'))),
        );
        expect(renderObject.effect, isNull);
      },
    );

    testWidgets(
      'when the widget rebuilds with style.effect toggled off then on, the render object persists',
      (tester) async {
        await tester.pumpWidget(
          _app(
            child: const MateoSkeleton(
              style: MateoSkeletonStyle(effect: MateoSkeletonShimmerEffect()),
              child: Text('Hello'),
            ),
          ),
        );
        final renderObject = _findSkeletonRenderObject(tester) as dynamic;
        expect(renderObject.effect, isA<MateoSkeletonShimmerEffect>());

        await tester.pumpWidget(
          _app(child: const MateoSkeleton(child: Text('Hello'))),
        );
        expect(renderObject.effect, isNull);

        await tester.pumpWidget(
          _app(
            child: const MateoSkeleton(
              style: MateoSkeletonStyle(effect: MateoSkeletonShimmerEffect()),
              child: Text('Hello'),
            ),
          ),
        );
        expect(renderObject.effect, isA<MateoSkeletonShimmerEffect>());
      },
    );
  });

  group('_RenderMateoSkeleton getter/setter', () {
    testWidgets(
      'when the render object is created with no style, it should return correct defaults',
      (tester) async {
        await tester.pumpWidget(
          _app(child: const MateoSkeleton(child: Text('Hello'))),
        );
        final ro = _findSkeletonRenderObject(tester) as dynamic;

        expect(ro.colorScheme.skeleton.bone, isNot(isNull));
        expect(ro.colorScheme.skeleton.shimmerGlow, isNot(isNull));
        expect(ro.effect, isNull);
        expect(ro.textRadius, isNull);
        expect(ro.boneColor, equals(ro.colorScheme.skeleton.bone));
        expect(ro.effectAnimation, isNull);
      },
    );

    testWidgets(
      'when the render object is created with a style.effect set, it should report effect non-null',
      (tester) async {
        await tester.pumpWidget(
          _app(
            child: const MateoSkeleton(
              style: MateoSkeletonStyle(effect: MateoSkeletonShimmerEffect()),
              child: Text('Hello'),
            ),
          ),
        );
        final ro = _findSkeletonRenderObject(tester) as dynamic;

        expect(ro.effect, isA<MateoSkeletonShimmerEffect>());
      },
    );

    testWidgets(
      'when didUpdateWidget fires with changed style.effect, it should invoke syncAnimationController',
      (tester) async {
        await tester.pumpWidget(
          _app(child: const MateoSkeleton(child: Text('Hello'))),
        );
        final ro = _findSkeletonRenderObject(tester) as dynamic;
        expect(ro.effect, isNull);

        await tester.pumpWidget(
          _app(
            child: const MateoSkeleton(
              style: MateoSkeletonStyle(effect: MateoSkeletonShimmerEffect()),
              child: Text('Hello'),
            ),
          ),
        );
        expect(ro.effect, isA<MateoSkeletonShimmerEffect>());
      },
    );

    testWidgets(
      'when style.effect toggles via widget rebuild, setter markNeedsPaint should not throw',
      (tester) async {
        await tester.pumpWidget(
          _app(child: const MateoSkeleton(child: Text('Hello'))),
        );

        await tester.pumpWidget(
          _app(
            child: const MateoSkeleton(
              style: MateoSkeletonStyle(effect: MateoSkeletonShimmerEffect()),
              child: Text('Hello'),
            ),
          ),
        );
        await tester.pump();

        expect(tester.takeException(), isNull);
      },
    );
  });

  group('MateoSkeleton canvas interception', () {
    testWidgets(
      'when skeletonizing a deep widget tree with layers, it should render without error',
      (tester) async {
        await tester.pumpWidget(
          _app(
            child: MateoSkeleton(
              child: Column(
                children: [
                  Text('Header'),
                  SizedBox(height: 8),
                  Row(children: [Icon(Icons.star), Text('Rating')]),
                  SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: ColoredBox(
                      color: mateoTestColorScheme.toast.info.icon,
                      child: SizedBox(width: 100, height: 100),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when skeletonizing Transform widgets, it should render without error',
      (tester) async {
        await tester.pumpWidget(
          _app(
            child: MateoSkeleton(
              child: Transform.scale(
                scale: 0.8,
                child: const Text('Scaled text'),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when skeletonizing a CircleAvatar, it should render without error',
      (tester) async {
        await tester.pumpWidget(
          _app(
            child: const MateoSkeleton(child: CircleAvatar(child: Text('AB'))),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when skeletonizing a RotatedBox, it should render without error',
      (tester) async {
        await tester.pumpWidget(
          _app(
            child: const MateoSkeleton(
              child: RotatedBox(quarterTurns: 1, child: Text('Rotated')),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when skeletonizing an Opacity wrapper, it should render without error',
      (tester) async {
        await tester.pumpWidget(
          _app(
            child: const MateoSkeleton(
              child: Opacity(opacity: 0.5, child: Text('Faded')),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when skeletonizing a ClipPath widget, it should render without error',
      (tester) async {
        await tester.pumpWidget(
          _app(
            child: MateoSkeleton(
              child: ClipPath(
                clipper: _TestClipper(),
                child: ColoredBox(
                  color: mateoTestColorScheme.toast.info.icon,
                  child: SizedBox(width: 100, height: 100),
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when skeletonizing an OverflowBox, it should render without error',
      (tester) async {
        await tester.pumpWidget(
          _app(
            child: const MateoSkeleton(
              child: OverflowBox(
                minWidth: 50,
                maxWidth: 200,
                minHeight: 50,
                maxHeight: 200,
                child: Text('Overflow'),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when skeletonizing a leaf container with color, it should intercept drawRect as a bone',
      (tester) async {
        await tester.pumpWidget(
          _app(
            child: MateoSkeleton(
              child: SizedBox(
                width: 50,
                height: 50,
                child: ColoredBox(color: mateoTestColorScheme.toast.info.icon),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when skeletonizing a container with rounded corners, it should intercept drawRRect',
      (tester) async {
        await tester.pumpWidget(
          _app(
            child: MateoSkeleton(
              child: SizedBox(
                width: 50,
                height: 50,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: mateoTestColorScheme.toast.info.icon,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when skeletonizing a PhysicalModel, it should intercept drawDRRect',
      (tester) async {
        await tester.pumpWidget(
          _app(
            child: MateoSkeleton(
              child: SizedBox(
                width: 50,
                height: 50,
                child: PhysicalModel(
                  color: mateoTestColorScheme.toast.info.icon,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: SizedBox.shrink(),
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when skeletonizing an Align with a leaf child, it should intercept leaf draw calls',
      (tester) async {
        await tester.pumpWidget(
          _app(
            child: MateoSkeleton(
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: ColoredBox(
                    color: mateoTestColorScheme.buttons.success.background,
                  ),
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );
  });

  group('MateoSkeleton theme colors', () {
    testWidgets(
      'when the theme provides custom skeleton colors, the render object should use them',
      (tester) async {
        final customColorScheme = MateoColorScheme.light().copyWith(
          skeleton: MateoSkeletonColorScheme(
            bone: mateoTestColorScheme.inverse.background,
            shimmerGlow: mateoTestColorScheme.colors.neutral.solid,
            skeletonText: mateoTestColorScheme.skeleton.skeletonText,
            skeletonTextGlow: mateoTestColorScheme.skeleton.bone,
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: mateoTestColorScheme.buttons.primary.background,
              ),
              extensions: [
                MateoThemeData(
                  colorScheme: customColorScheme,
                  palette: MateoPalette(),
                ),
              ],
            ),
            home: const Scaffold(body: MateoSkeleton(child: Text('Hello'))),
          ),
        );

        final ro = _findSkeletonRenderObject(tester) as dynamic;
        expect(
          ro.colorScheme.skeleton.bone,
          equals(mateoTestColorScheme.inverse.background),
        );
        expect(
          ro.colorScheme.skeleton.shimmerGlow,
          equals(mateoTestColorScheme.colors.neutral.solid),
        );
      },
    );

    testWidgets(
      'when the theme provides custom skeletonShimmerGlow, the colorScheme object should carry it',
      (tester) async {
        final customColorScheme = MateoColorScheme.light().copyWith(
          skeleton: MateoSkeletonColorScheme(
            bone: mateoTestColorScheme.skeleton.bone,
            shimmerGlow: mateoTestColorScheme.text.secondary,
            skeletonText: mateoTestColorScheme.skeleton.skeletonText,
            skeletonTextGlow: mateoTestColorScheme.skeleton.bone,
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: mateoTestColorScheme.buttons.primary.background,
              ),
              extensions: [
                MateoThemeData(
                  colorScheme: customColorScheme,
                  palette: MateoPalette(),
                ),
              ],
            ),
            home: const Scaffold(body: MateoSkeleton(child: Text('Hello'))),
          ),
        );

        final ro = _findSkeletonRenderObject(tester) as dynamic;
        expect(
          ro.colorScheme.skeleton.shimmerGlow,
          equals(mateoTestColorScheme.text.secondary),
        );
      },
    );
  });

  group('WidgetExtension', () {
    testWidgets('when .skeleton() is called, it should wrap in MateoSkeleton', (
      tester,
    ) async {
      await tester.pumpWidget(_app(child: const Text('Hello').skeleton()));

      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets(
      'when .skeleton(enabled: false) is called, it should pass through the child',
      (tester) async {
        await tester.pumpWidget(
          _app(child: const Text('Hello').skeleton(enabled: false)),
        );

        expect(find.text('Hello'), findsOneWidget);
      },
    );
  });
}

class _TestClipper extends CustomClipper<Path> {
  const _TestClipper();

  @override
  Path getClip(Size size) =>
      Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height));

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
