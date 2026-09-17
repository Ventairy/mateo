import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  test('when transform shapes differ, it should retain const values and compare endpoint configuration', () {
    const animation = MateoSurfaceAnimation.transform(id: 'details', shape: .rounded(radius: 42));
    const equivalent = MateoSurfaceAnimationTransform(id: 'details', shape: .rounded(radius: 42));
    expect(animation, equivalent);
    expect(animation.hashCode, equivalent.hashCode);
    expect(equivalent.shape, const MateoSurfaceShape.rounded(radius: 42));
    expect(const MateoSurfaceAnimationTransform(id: 'details').shape, isNull);
    for (final shape in <MateoSurfaceShape?>[null, const .none(), const .capsule(), const .rounded(radius: 24)]) {
      expect(animation, isNot(MateoSurfaceAnimation.transform(id: 'details', shape: shape)));
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

  test('surface constructors accept const transform configuration', () {
    const surfaces = <MateoSurface>[
      .new(
        animation: .transform(id: 'details'),
        child: SizedBox(),
      ),
      .scrollable(
        animation: .transform(id: 'details'),
        child: SizedBox(),
      ),
    ];
    const viewSurfaces = <MateoViewSurface>[
      .new(
        animation: .transform(id: 'details'),
        child: SizedBox(),
      ),
      .scrollable(
        animation: .transform(id: 'details'),
        child: SizedBox(),
      ),
    ];
    for (final animation in [
      ...surfaces.map((surface) => surface.animation),
      ...viewSurfaces.map((surface) => surface.animation),
    ]) {
      final id = switch (animation) {
        null => null,
        MateoSurfaceAnimationNone() || MateoSurfaceAnimationPop() => null,
        MateoSurfaceAnimationTransform(:final id) => id,
      };
      expect(id, 'details');
      if (animation case MateoSurfaceAnimationTransform(:final duration, :final curve)) {
        expect(duration, const Duration(milliseconds: 230));
        expect(curve, Curves.easeOutCubic);
      }
    }
  });

  test('when transform settings differ, it should compare all configuration', () {
    const defaults = MateoSurfaceAnimationTransform(id: 'details');
    expect(defaults.contentEffects, const <MateoSurfaceTransformAnimationContentEffect>[.crossfade(), .scale()]);
    const reordered = MateoSurfaceAnimationTransform(
      id: 'details',
      contentEffects: [.scale(), .crossfade(), .scale()],
    );
    expect(defaults, isNot(reordered));
    const repeated = MateoSurfaceAnimationTransform(
      id: 'details',
      contentEffects: [.crossfade(), .scale(), .crossfade()],
    );
    expect(defaults, repeated);
    expect(defaults.hashCode, repeated.hashCode);
    const custom = MateoSurfaceAnimation.transform(
      id: 'details',
      duration: Duration(milliseconds: 400),
      curve: Curves.linear,
      contentEffects: [],
    );
    expect(custom.duration, const Duration(milliseconds: 400));
    expect(custom.curve, Curves.linear);
    for (final other in [
      const MateoSurfaceAnimation.transform(id: 'details', duration: Duration.zero),
      const MateoSurfaceAnimation.transform(id: 'details', curve: Curves.linear),
      const MateoSurfaceAnimation.transform(id: 'details', contentEffects: [.crossfade()]),
      custom,
    ]) {
      expect(defaults, isNot(other));
    }
  });

  test('variants compare by kind and transform identity', () {
    const none = MateoSurfaceAnimation.none();
    const anotherNone = MateoSurfaceAnimationNone();
    const transform = MateoSurfaceAnimation.transform(id: 'details');
    const anotherTransform = MateoSurfaceAnimationTransform(id: 'details');
    expect(none, anotherNone);
    expect(none.hashCode, anotherNone.hashCode);
    expect(transform, anotherTransform);
    expect(transform.hashCode, anotherTransform.hashCode);
    expect(transform, isNot(none));
    expect(none, isNot(transform));
    expect(transform, isNot(const MateoSurfaceAnimation.transform(id: 'other')));
  });
}
