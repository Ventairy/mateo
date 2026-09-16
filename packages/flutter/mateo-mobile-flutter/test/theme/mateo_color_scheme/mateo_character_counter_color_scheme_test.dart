import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

void main() {
  group('MateoCharacterCounterVariantColorScheme', () {
    const colors = MateoCharacterCounterVariantColorScheme(
      background: Color(0xFF000001),
      backgroundDisabled: Color(0xFF000002),
      foreground: Color(0xFF000003),
      foregroundDisabled: Color(0xFF000004),
      foregroundReject: Color(0xFF000005),
    );

    test('when created, it should expose every supplied role', () {
      expect(
        (
          colors.background,
          colors.backgroundDisabled,
          colors.foreground,
          colors.foregroundDisabled,
          colors.foregroundReject,
        ),
        const (
          Color(0xFF000001),
          Color(0xFF000002),
          Color(0xFF000003),
          Color(0xFF000004),
          Color(0xFF000005),
        ),
      );
    });

    test('when copied without overrides, it should preserve every role', () {
      expect(colors.copyWith(), colors);
    });

    test('when interpolated to a changed scheme, it should reach the changed endpoint', () {
      final target = colors.copyWith(foreground: Colors.white);

      expect(MateoCharacterCounterVariantColorScheme.lerp(colors, target, 1), target);
    });
  });

  group('MateoCharacterCounterColorScheme', () {
    final colors = MateoColorScheme.light().characterCounter;

    test('when copied without overrides, it should preserve both variants', () {
      expect(colors.copyWith(), colors);
    });

    test('when interpolated, it should interpolate both variants', () {
      final target = colors.copyWith(
        floating: colors.floating.copyWith(foreground: Colors.white),
        text: colors.text.copyWith(foreground: Colors.white),
      );

      expect(
        (
          MateoCharacterCounterColorScheme.lerp(colors, target, 0),
          MateoCharacterCounterColorScheme.lerp(colors, target, 1),
        ),
        (colors, target),
      );
    });
  });
}
