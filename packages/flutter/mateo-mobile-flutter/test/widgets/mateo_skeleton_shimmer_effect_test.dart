import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

final _colorScheme = MateoColorScheme.light();

void main() {
  group('MateoSkeletonShimmerEffect', () {
    test(
      'when color is null, the gradient middle color equals colorScheme.skeleton.shimmerGlow',
      () {
        const effect = MateoSkeletonShimmerEffect();
        final paint = effect.buildPaint(
          bounds: const Rect.fromLTWH(0, 0, 100, 50),
          t: 0,
          colorScheme: _colorScheme,
          style: const MateoSkeletonStyle(),
        );

        expect(paint.shader, isA<ui.Gradient>());
      },
    );

    test('when color is set, it should override the theme color', () {
      final effect = MateoSkeletonShimmerEffect(
        color: mateoTestColorScheme.buttons.danger.background,
      );
      final paint = effect.buildPaint(
        bounds: const Rect.fromLTWH(0, 0, 100, 50),
        t: 0,
        colorScheme: _colorScheme,
        style: const MateoSkeletonStyle(),
      );

      expect(paint.shader, isA<ui.Gradient>());
    });

    test('when angle is zero, the gradient is horizontal', () {
      const effect = MateoSkeletonShimmerEffect();
      final paint = effect.buildPaint(
        bounds: const Rect.fromLTWH(0, 0, 100, 50),
        t: 0,
        colorScheme: _colorScheme,
        style: const MateoSkeletonStyle(),
      );

      expect(paint.shader, isA<ui.Gradient>());
    });

    test('when angle is pi/2, the gradient is vertical', () {
      const effect = MateoSkeletonShimmerEffect(angle: math.pi / 2);
      final paint = effect.buildPaint(
        bounds: const Rect.fromLTWH(0, 0, 100, 50),
        t: 0,
        colorScheme: _colorScheme,
        style: const MateoSkeletonStyle(),
      );

      expect(paint.shader, isA<ui.Gradient>());
    });

    test('when bounds are empty, buildPaint should not throw', () {
      const effect = MateoSkeletonShimmerEffect();
      final paint = effect.buildPaint(
        bounds: Rect.zero,
        t: 0,
        colorScheme: _colorScheme,
        style: const MateoSkeletonStyle(),
      );

      expect(paint.shader, isA<ui.Gradient>());
    });

    test('when angle is zero, two equal effects should be equal', () {
      const a = MateoSkeletonShimmerEffect();
      const b = MateoSkeletonShimmerEffect();

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('when color differs, effects should not be equal', () {
      final a = MateoSkeletonShimmerEffect(
        color: mateoTestColorScheme.background,
      );
      final b = MateoSkeletonShimmerEffect(
        color: mateoTestColorScheme.text.primary,
      );

      expect(a, isNot(equals(b)));
    });

    test('when angle differs, effects should not be equal', () {
      const a = MateoSkeletonShimmerEffect(angle: 0);
      const b = MateoSkeletonShimmerEffect(angle: math.pi / 4);

      expect(a, isNot(equals(b)));
    });
  });
}
