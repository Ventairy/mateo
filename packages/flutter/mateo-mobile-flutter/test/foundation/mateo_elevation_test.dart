import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/src/foundation/mateo_elevation.dart';
import 'package:mateo_mobile_old/src/theme/mateo_palette/mateo_palette.dart';

void main() {
  final palette = MateoPalette();
  final shadowColor = palette.neutral[12];

  test('when elevation is zero, it should remain flat', () {
    expect(MateoElevation.toShadows(elevation: 0, palette: palette), isEmpty);
  });

  test('when elevation is one, it should match the floating treatment', () {
    expect(MateoElevation.toShadows(elevation: 1, palette: palette), [
      BoxShadow(color: shadowColor.withValues(alpha: 0.1), blurRadius: 24),
    ]);
  });

  test('when elevation is two, it should match the toast treatment', () {
    expect(MateoElevation.toShadows(elevation: 2, palette: palette), [
      BoxShadow(
        color: shadowColor.withValues(alpha: 0.16),
        blurRadius: 38,
        spreadRadius: -8,
        offset: const Offset(0, 18),
      ),
      BoxShadow(
        color: shadowColor.withValues(alpha: 0.08),
        blurRadius: 12,
        spreadRadius: 4,
        offset: const Offset(0, 6),
      ),
    ]);
  });

  test('when elevation is fractional, it should follow the fitted formula', () {
    expect(MateoElevation.toShadows(elevation: 0.5, palette: palette), [
      BoxShadow(color: shadowColor.withValues(alpha: 0.055), blurRadius: 13.25),
    ]);
    expect(MateoElevation.toShadows(elevation: 1.5, palette: palette), [
      BoxShadow(
        color: shadowColor.withValues(alpha: 0.135),
        blurRadius: 32.25,
        spreadRadius: -4,
        offset: const Offset(0, 9),
      ),
      BoxShadow(
        color: shadowColor.withValues(alpha: 0.04),
        blurRadius: 6,
        spreadRadius: 2,
        offset: const Offset(0, 3),
      ),
    ]);
  });

  test('when elevation rises, ambient opacity and blur should rise monotonically', () {
    var previousOpacity = 0.0;
    var previousBlur = 0.0;
    for (var elevation = 0.1; elevation <= 2; elevation += 0.1) {
      final ambient = MateoElevation.toShadows(elevation: elevation, palette: palette).first;
      expect(ambient.color.a, greaterThan(previousOpacity));
      expect(ambient.blurRadius, greaterThan(previousBlur));
      previousOpacity = ambient.color.a;
      previousBlur = ambient.blurRadius;
    }
  });

  test('when elevation is invalid, it should reject it in every build mode', () {
    for (final elevation in [double.nan, double.infinity, double.negativeInfinity, -0.1, 2.1]) {
      expect(
        () => MateoElevation.toShadows(elevation: elevation, palette: palette),
        throwsArgumentError,
      );
    }
  });
}
