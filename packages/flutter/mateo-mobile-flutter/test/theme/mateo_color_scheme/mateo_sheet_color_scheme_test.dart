import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

void main() {
  test('when customizing sheet colors, it should copy, compare, and interpolate through the theme', () {
    final original = MateoColorScheme.light();
    const sheet = MateoSheetColorScheme(background: Colors.pink);
    final custom = original.copyWith(sheet: sheet);
    expect(custom.sheet, sheet);
    expect(custom, isNot(original));
    expect(custom.copyWith(), custom);
    expect(custom.copyWith().hashCode, custom.hashCode);
    expect(MateoColorScheme.lerp(original, custom, 0), original);
    expect(MateoColorScheme.lerp(original, custom, 1).sheet.background.toARGB32(), sheet.background.toARGB32());
    expect(MateoColorScheme.lerp(original, custom, 0.5).sheet, MateoSheetColorScheme.lerp(original.sheet, sheet, 0.5));
  });

  group('MateoSheetColorScheme', () {
    final palette = MateoPalette();
    final scheme = MateoSheetColorScheme(background: palette.neutral[1]);

    test('when created, it should expose the supplied background color', () {
      expect(scheme.background, palette.neutral[1]);
    });

    test('when copied without overrides, it should preserve every role', () {
      expect(scheme.copyWith(), scheme);
    });

    test(
      'when copied with a background override, it should replace the background color',
      () {
        expect(
          scheme.copyWith(background: palette.accent[9]).background,
          palette.accent[9],
        );
      },
    );

    test('when interpolated halfway, it should blend every role', () {
      final target = MateoSheetColorScheme(
        background: palette.neutral[12],
      );

      expect(
        MateoSheetColorScheme.lerp(scheme, target, 0.5),
        MateoSheetColorScheme(
          background: Color.lerp(scheme.background, target.background, 0.5)!,
        ),
      );
    });

    test('when roles are equal, it should produce the same hash code', () {
      final equalScheme = MateoSheetColorScheme(
        background: palette.neutral[1],
      );

      expect(scheme.hashCode, equalScheme.hashCode);
    });
  });
}
