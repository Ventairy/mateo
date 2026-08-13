import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  group('MateoBottomSheetColorScheme', () {
    final palette = MateoPalette();
    final scheme = MateoBottomSheetColorScheme(background: palette.neutral[1]);

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
          scheme.copyWith(background: palette.primary[9]).background,
          palette.primary[9],
        );
      },
    );

    test('when interpolated halfway, it should blend every role', () {
      final target = MateoBottomSheetColorScheme(
        background: palette.neutral[12],
      );

      expect(
        MateoBottomSheetColorScheme.lerp(scheme, target, 0.5),
        MateoBottomSheetColorScheme(
          background: Color.lerp(scheme.background, target.background, 0.5)!,
        ),
      );
    });

    test('when roles are equal, it should produce the same hash code', () {
      final equalScheme = MateoBottomSheetColorScheme(
        background: palette.neutral[1],
      );

      expect(scheme.hashCode, equalScheme.hashCode);
    });
  });
}
