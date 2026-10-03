import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  final palette = MateoPalette(accentColor: const Color(0xFF4A5CFF));
  final shadowColor = palette.neutral[12];

  test('when levels match, it should have value equality', () {
    expect(MateoElevation(level: 1), MateoElevation(level: 1));
    expect(MateoElevation(level: 1).hashCode, MateoElevation(level: 1).hashCode);
    expect(MateoElevation(level: 1), isNot(MateoElevation(level: 2)));
  });

  test('when elevation is zero, it should remain flat', () {
    expect(MateoElevation(level: 0).toShadowList(palette: palette), isEmpty);
  });

  test('when elevation is one, it should match the floating treatment', () {
    expect(MateoElevation(level: 1).toShadowList(palette: palette), [
      BoxShadow(color: shadowColor.withValues(alpha: 0.1), blurRadius: 24),
    ]);
  });

  test('when elevation is two, it should match the toast treatment', () {
    expect(MateoElevation(level: 2).toShadowList(palette: palette), [
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
    expect(MateoElevation(level: 0.5).toShadowList(palette: palette), [
      BoxShadow(color: shadowColor.withValues(alpha: 0.055), blurRadius: 13.25),
    ]);
    expect(MateoElevation(level: 1.5).toShadowList(palette: palette), [
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

  test('when elevation rises, it should increase ambient opacity and blur monotonically', () {
    var previousOpacity = 0.0;
    var previousBlur = 0.0;
    for (var elevation = 0.1; elevation <= 2; elevation += 0.1) {
      final ambient = MateoElevation(level: elevation).toShadowList(palette: palette).first;
      expect(ambient.color.a, greaterThan(previousOpacity));
      expect(ambient.blurRadius, greaterThan(previousBlur));
      previousOpacity = ambient.color.a;
      previousBlur = ambient.blurRadius;
    }
  });

  test('when elevation is invalid, it should reject it in every build mode', () {
    for (final elevation in [double.nan, double.infinity, double.negativeInfinity, -0.1, 2.1]) {
      expect(
        () => MateoElevation(level: elevation),
        throwsArgumentError,
      );
    }
  });
}
