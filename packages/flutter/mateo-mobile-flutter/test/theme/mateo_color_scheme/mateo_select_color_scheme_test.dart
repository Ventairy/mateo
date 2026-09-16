import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

void main() {
  test('when select colors are grouped, it should preserve and interpolate both presentations', () {
    final scheme = MateoColorScheme.light(palette: MateoPalette()).select;
    expect(scheme.ghost.background, Colors.transparent);
    expect(scheme.ghost.title, scheme.neutral.title);
    expect(scheme.copyWith(), scheme);
    expect(scheme.copyWith().hashCode, scheme.hashCode);
    final swapped = scheme.copyWith(neutral: scheme.ghost, ghost: scheme.neutral);
    expect(MateoSelectColorScheme.lerp(scheme, swapped, 0), scheme);
    expect(MateoSelectColorScheme.lerp(scheme, swapped, 1), swapped);
    final midpoint = MateoSelectColorScheme.lerp(scheme, swapped, 0.5);
    expect(midpoint.neutral, MateoSelectVariantColorScheme.lerp(scheme.neutral, scheme.ghost, 0.5));
    expect(midpoint.ghost, MateoSelectVariantColorScheme.lerp(scheme.ghost, scheme.neutral, 0.5));
  });
  group('MateoSelectVariantColorScheme', () {
    final palette = MateoPalette();
    final scheme = MateoColorScheme.light(palette: palette).select.neutral;

    test('when the light scheme is created, it should map every role to the Mateo palette', () {
      expect(scheme.background, palette.neutral[2]);
      expect(scheme.title, palette.neutral[12]);
      expect(scheme.icon, palette.neutral[12]);
      expect(scheme.chevron, palette.neutral[12]);
    });

    test('when copied without overrides, it should preserve every role', () {
      expect(scheme.copyWith(), scheme);
      expect(scheme.copyWith().hashCode, scheme.hashCode);
    });

    test('when copied with overrides, it should replace only those roles', () {
      const replacement = Color(0xFF123456);
      final result = scheme.copyWith(icon: replacement, chevron: replacement);

      expect(result.background, scheme.background);
      expect(result.title, scheme.title);
      expect(result.icon, replacement);
      expect(result.chevron, replacement);
    });

    test('when interpolated, it should blend every role', () {
      final targetPalette = MateoPalette(accentColor: const Color(0xFF00A86B));
      final target = scheme.copyWith(
        background: targetPalette.accent[2],
        title: targetPalette.accent[12],
        icon: targetPalette.accent[8],
        chevron: targetPalette.accent[11],
      );

      expect(MateoSelectVariantColorScheme.lerp(scheme, target, 0), scheme);
      expect(MateoSelectVariantColorScheme.lerp(scheme, target, 1), target);
      expect(
        MateoSelectVariantColorScheme.lerp(scheme, target, 0.5),
        MateoSelectVariantColorScheme(
          background: Color.lerp(scheme.background, target.background, 0.5)!,
          title: Color.lerp(scheme.title, target.title, 0.5)!,
          icon: Color.lerp(scheme.icon, target.icon, 0.5)!,
          chevron: Color.lerp(scheme.chevron, target.chevron, 0.5)!,
        ),
      );
    });
  });
}
