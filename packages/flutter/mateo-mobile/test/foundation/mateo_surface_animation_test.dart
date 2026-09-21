import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/surface_transform_targets.dart';

void main() {
  test('when targets have identical timing, it should still treat them as separate connections', () {
    final first = MateoTransformTarget();
    final second = MateoTransformTarget();
    expect(first, isNot(same(second)));
    expect(MateoSurfaceAnimation.transform(target: first), isNot(MateoSurfaceAnimation.transform(target: second)));
  });

  test('when timing is omitted, it should use automatic timing in both directions', () {
    final target = MateoTransformTarget(curve: Curves.linear);
    final animation = MateoSurfaceAnimation.transform(target: target) as MateoSurfaceAnimationTransform;
    expect(animation.duration, const MateoTransformDuration.auto());
    expect(animation.reverseDuration, const MateoTransformDuration.auto());
    expect(animation.curve, Curves.linear);
    expect(animation.reverseCurve, Curves.linear);
  });

  test('when reverse timing is omitted, it should retain the forward configuration', () {
    final duration = MateoTransformDuration.custom(duration: const Duration(milliseconds: 400));
    final target = MateoTransformTarget(duration: duration, curve: Curves.easeIn);
    final surface = MateoSurfaceAnimation.transform(target: target) as MateoSurfaceAnimationTransform;
    final view = MateoViewAnimation.transform(target: target) as MateoViewAnimationTransform;
    expect(surface.duration, duration);
    expect(surface.reverseDuration, duration);
    expect(surface.curve, Curves.easeIn);
    expect(surface.reverseCurve, Curves.easeIn);
    expect(view.duration, duration);
    expect(view.reverseDuration, duration);
    expect(view.curve, Curves.easeIn);
    expect(view.reverseCurve, Curves.easeIn);
  });

  test('when reverse timing is supplied, it should retain independent configuration', () {
    final duration = MateoTransformDuration.custom(duration: const Duration(milliseconds: 400));
    final reverseDuration = MateoTransformDuration.custom(duration: const Duration(milliseconds: 180));
    final target = MateoTransformTarget(
      duration: duration,
      reverseDuration: reverseDuration,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
    expect(target.duration, duration);
    expect(target.reverseDuration, reverseDuration);
    expect(target.curve, Curves.easeOut);
    expect(target.reverseCurve, Curves.easeIn);
  });

  test('when a custom duration is negative, it should reject the configuration', () {
    expect(
      () => MateoTransformDuration.custom(duration: const Duration(milliseconds: -1)),
      throwsAssertionError,
    );
  });

  test('duration policies compare by kind and custom value', () {
    const automatic = MateoTransformDuration.auto();
    final custom = MateoTransformDuration.custom(
      duration: const Duration(milliseconds: 230),
    );
    expect(automatic, const MateoTransformDurationAuto());
    expect(automatic.value, isNull);
    expect(
      custom,
      MateoTransformDurationCustom(duration: const Duration(milliseconds: 230)),
    );
    expect(custom.value, const Duration(milliseconds: 230));
    expect(
      MateoTransformDuration.custom(duration: const Duration(milliseconds: 230)),
      isNot(MateoTransformDuration.custom(duration: const Duration(milliseconds: 180))),
    );
    expect(
      const MateoTransformDuration.auto(),
      isNot(MateoTransformDuration.custom(duration: const Duration(milliseconds: 230))),
    );
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
    expect(equivalent.shape, const MateoShape.rounded(radius: 42));
    expect(MateoSurfaceAnimationTransform(target: surfaceTransformTarget('details')).shape, isNull);
    for (final shape in <MateoShape?>[null, const .none(), const .capsule(), const .rounded(radius: 24)]) {
      expect(
        animation,
        isNot(MateoSurfaceAnimation.transform(target: surfaceTransformTarget('details'), shape: shape)),
      );
    }
  });

  test('when typed effects have equal curves, it should compare by type and configuration', () {
    const fade = MateoTransformAnimationContentEffect.crossfade(curve: Curves.linear);
    const scale = MateoTransformAnimationContentEffect.scale(curve: Curves.linear);
    expect(fade, const MateoTransformAnimationContentEffectCrossfade(curve: Curves.linear));
    expect(scale, const MateoTransformAnimationContentEffectScale(curve: Curves.linear));
    expect(fade.hashCode, const MateoTransformAnimationContentEffectCrossfade(curve: Curves.linear).hashCode);
    expect(scale.hashCode, const MateoTransformAnimationContentEffectScale(curve: Curves.linear).hashCode);
    expect(fade, isNot(scale));
    expect(fade, isNot(const MateoTransformAnimationContentEffect.crossfade()));
    expect(scale, isNot(const MateoTransformAnimationContentEffect.scale(curve: Curves.easeIn)));
    expect(const MateoTransformAnimationContentEffectCrossfade().curve, isNull);
    expect(const MateoTransformAnimationContentEffectScale().curve, isNull);
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
    final views = <MateoView>[
      .new(
        animation: .transform(
          target: surfaceTransformTarget('details'),
        ),
        surface: const MateoViewSurface(child: SizedBox()),
      ),
      .new(
        animation: .transform(
          target: surfaceTransformTarget('details'),
        ),
        surface: const MateoViewSurface.scrollable(child: SizedBox()),
      ),
    ];
    for (final target in [
      ...surfaces.map((surface) => (surface.animation! as MateoSurfaceAnimationTransform).target),
      ...views.map(
        (view) => (view.animation! as MateoViewAnimationTransform).target,
      ),
    ]) {
      final id = target;
      expect(id, same(surfaceTransformTarget('details')));
      expect(
        target.duration,
        MateoTransformDuration.custom(duration: const Duration(milliseconds: 230)),
      );
      expect(target.reverseDuration, target.duration);
      expect(target.curve, Curves.easeOutCubic);
      expect(target.reverseCurve, target.curve);
    }
  });

  test('when transform settings differ, it should compare all configuration', () {
    final defaults = MateoSurfaceAnimationTransform(target: surfaceTransformTarget('details'));
    expect(defaults.contentEffects, <MateoTransformAnimationContentEffect>[const .crossfade(), const .scale()]);
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
      target: surfaceTransformTarget(
        'details',
        duration: const Duration(milliseconds: 400),
        curve: Curves.linear,
      ),
      contentEffects: const [],
    ) as MateoSurfaceAnimationTransform;
    expect(
      custom.duration,
      MateoTransformDuration.custom(duration: const Duration(milliseconds: 400)),
    );
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
