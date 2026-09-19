import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/surface_transform_targets.dart';

void main() {
  test('when targets have identical timing, it should still treat them as separate connections', () {
    final first = MateoSurfaceTransformTarget();
    final second = MateoSurfaceTransformTarget();
    expect(first, isNot(same(second)));
    expect(MateoSurfaceAnimation.transform(target: first), isNot(MateoSurfaceAnimation.transform(target: second)));
  });

  test('when route timing is requested, it should retain an omitted target duration', () {
    final target = MateoSurfaceTransformTarget(duration: null, curve: Curves.linear);
    final animation = MateoSurfaceAnimation.transform(target: target);
    expect(animation.duration, isNull);
    expect(animation.curve, Curves.linear);
  });

  test('when a target duration is negative, it should reject the configuration', () {
    expect(() => MateoSurfaceTransformTarget(duration: const Duration(milliseconds: -1)), throwsAssertionError);
  });

  test('when transform shapes differ, it should retain values and compare endpoint configuration', () {
    final animation = MateoSurfaceAnimation.transform(
      target: surfaceTransformTarget('details'),
      shape: const .rounded(radius: 42),
    );
    final equivalent = MateoSurfaceAnimationTransform(
      target: surfaceTransformTarget('details'),
      shape: const .rounded(radius: 42),
    );
    expect(animation, equivalent);
    expect(animation.hashCode, equivalent.hashCode);
    expect(equivalent.shape, const MateoSurfaceShape.rounded(radius: 42));
    expect(MateoSurfaceAnimationTransform(target: surfaceTransformTarget('details')).shape, isNull);
    for (final shape in <MateoSurfaceShape?>[null, const .none(), const .capsule(), const .rounded(radius: 24)]) {
      expect(
        animation,
        isNot(MateoSurfaceAnimation.transform(target: surfaceTransformTarget('details'), shape: shape)),
      );
    }
  });

  test('when typed effects have equal curves, it should compare by type and configuration', () {
    const fade = MateoSurfaceTransformAnimationContentEffect.crossfade(curve: Curves.linear);
    const scale = MateoSurfaceTransformAnimationContentEffect.scale(curve: Curves.linear);
    expect(fade, const MateoSurfaceTransformAnimationContentEffectCrossfade(curve: Curves.linear));
    expect(scale, const MateoSurfaceTransformAnimationContentEffectScale(curve: Curves.linear));
    expect(fade.hashCode, const MateoSurfaceTransformAnimationContentEffectCrossfade(curve: Curves.linear).hashCode);
    expect(scale.hashCode, const MateoSurfaceTransformAnimationContentEffectScale(curve: Curves.linear).hashCode);
    expect(fade, isNot(scale));
    expect(fade, isNot(const MateoSurfaceTransformAnimationContentEffect.crossfade()));
    expect(scale, isNot(const MateoSurfaceTransformAnimationContentEffect.scale(curve: Curves.easeIn)));
    expect(const MateoSurfaceTransformAnimationContentEffectCrossfade().curve, isNull);
    expect(const MateoSurfaceTransformAnimationContentEffectScale().curve, isNull);
  });

  test('surface constructors accept transform configuration', () {
    final surfaces = <MateoSurface>[
      .new(
        animation: .transform(
          target: surfaceTransformTarget('details'),
        ),
        child: const SizedBox(),
      ),
      .scrollable(
        animation: .transform(
          target: surfaceTransformTarget('details'),
        ),
        child: const SizedBox(),
      ),
    ];
    final viewSurfaces = <MateoViewSurface>[
      .new(
        animation: .transform(
          target: surfaceTransformTarget('details'),
        ),
        child: const SizedBox(),
      ),
      .scrollable(
        animation: .transform(
          target: surfaceTransformTarget('details'),
        ),
        child: const SizedBox(),
      ),
    ];
    for (final animation in [
      ...surfaces.map((surface) => surface.animation),
      ...viewSurfaces.map((surface) => surface.animation),
    ]) {
      final id = switch (animation) {
        null => null,
        MateoSurfaceAnimationNone() || MateoSurfaceAnimationPop() => null,
        MateoSurfaceAnimationTransform(:final target) => target,
      };
      expect(id, same(surfaceTransformTarget('details')));
      if (animation case MateoSurfaceAnimationTransform(:final duration, :final curve)) {
        expect(duration, const Duration(milliseconds: 230));
        expect(curve, Curves.easeOutCubic);
      }
    }
  });

  test('when transform settings differ, it should compare all configuration', () {
    final defaults = MateoSurfaceAnimationTransform(target: surfaceTransformTarget('details'));
    expect(defaults.contentEffects, <MateoSurfaceTransformAnimationContentEffect>[const .crossfade(), const .scale()]);
    final reordered = MateoSurfaceAnimationTransform(
      target: surfaceTransformTarget('details'),
      contentEffects: const [.scale(), .crossfade(), .scale()],
    );
    expect(defaults, isNot(reordered));
    final repeated = MateoSurfaceAnimationTransform(
      target: surfaceTransformTarget('details'),
      contentEffects: const [.crossfade(), .scale(), .crossfade()],
    );
    expect(defaults, repeated);
    expect(defaults.hashCode, repeated.hashCode);
    final custom = MateoSurfaceAnimation.transform(
      target: surfaceTransformTarget('details', duration: const Duration(milliseconds: 400), curve: Curves.linear),
      contentEffects: const [],
    );
    expect(custom.duration, const Duration(milliseconds: 400));
    expect(custom.curve, Curves.linear);
    for (final other in [
      MateoSurfaceAnimation.transform(
        target: surfaceTransformTarget('details', duration: Duration.zero),
      ),
      MateoSurfaceAnimation.transform(
        target: surfaceTransformTarget('details', curve: Curves.linear),
      ),
      MateoSurfaceAnimation.transform(target: surfaceTransformTarget('details'), contentEffects: const [.crossfade()]),
      custom,
    ]) {
      expect(defaults, isNot(other));
    }
  });

  test('variants compare by kind and transform identity', () {
    const none = MateoSurfaceAnimation.none();
    const anotherNone = MateoSurfaceAnimationNone();
    final transform = MateoSurfaceAnimation.transform(
      target: surfaceTransformTarget('details'),
    );
    final anotherTransform = MateoSurfaceAnimationTransform(target: surfaceTransformTarget('details'));
    expect(none, anotherNone);
    expect(none.hashCode, anotherNone.hashCode);
    expect(transform, anotherTransform);
    expect(transform.hashCode, anotherTransform.hashCode);
    expect(transform, isNot(none));
    expect(none, isNot(transform));
    expect(
      transform,
      isNot(
        MateoSurfaceAnimation.transform(
          target: surfaceTransformTarget('other'),
        ),
      ),
    );
  });
}
