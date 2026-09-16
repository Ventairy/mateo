import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

void main() {
  group('MateoPalette', () {
    test('ships the documented Mateo accent and neutral scales', () {
      final palette = MateoPalette();

      expect(palette.accent.colors, const [
        Color(0xFFF9FBFE),
        Color(0xFFF2F4FB),
        Color(0xFFE5EAFA),
        Color(0xFFDAE1F7),
        Color(0xFFCBD7FC),
        Color(0xFFBECDFF),
        Color(0xFFADC0FF),
        Color(0xFF718CFC),
        Color(0xFF4A5CFF),
        Color(0xFF3F4CE7),
        Color(0xFF273392),
        Color(0xFF0C123E),
      ]);
      expect(palette.neutral.colors, const [
        Color(0xFFFCFCFC),
        Color(0xFFF5F5F5),
        Color(0xFFEBEBEB),
        Color(0xFFE1E1E1),
        Color(0xFFD7D7D7),
        Color(0xFFCECECE),
        Color(0xFFC1C1C1),
        Color(0xFF929292),
        Color(0xFF717171),
        Color(0xFF636363),
        Color(0xFF404040),
        Color(0xFF181818),
      ]);
    });

    test('ships Mateo vivid step-9 anchors', () {
      final palette = MateoPalette();

      expect(palette.green[9], const Color(0xFF00C950));
      expect(palette.amber[9], const Color(0xFFFFAA00));
      expect(palette.red[9], const Color(0xFFFB2C36));
      expect(palette.blue[9], const Color(0xFF2B7FFF));
      expect(palette.cyan[9], const Color(0xFF00C2E6));
      expect(palette.violet[9], const Color(0xFF8E51FF));
      expect(palette.teal[9], const Color(0xFF00C7B2));
      expect(palette.orange[9], const Color(0xFFFF6900));
      expect(palette.pink[9], const Color(0xFFF6339A));
      expect(palette.yellow[9], const Color(0xFFFFD000));
    });

    test('preserves a custom opaque seed exactly at accent step 9', () {
      const seeds = [
        Color(0xFFE53935),
        Color(0xFF00A86B),
        Color(0xFFFFD000),
        Color(0xFF8E51FF),
        Color(0xFFFFB8D1),
        Color(0xFF24163D),
      ];

      for (final seed in seeds) {
        expect(MateoPalette(accentColor: seed).accent[9], seed);
      }
    });

    test('keeps generated accent scales ordered by relative luminance', () {
      final palette = MateoPalette(accentColor: const Color(0xFF00A86B));

      for (var index = 1; index < palette.accent.colors.length; index++) {
        expect(
          palette.accent.colors[index - 1].computeLuminance(),
          greaterThan(palette.accent.colors[index].computeLuminance()),
        );
      }
    });

    test('when only the accent seed changes, it should keep Mateo neutrals', () {
      final defaultNeutral = MateoPalette().neutral;
      final customAccentNeutral = MateoPalette(
        accentColor: const Color(0xFFE53935),
      ).neutral;

      expect(customAccentNeutral.colors, defaultNeutral.colors);
    });

    test('ships achromatic neutrals', () {
      final neutral = MateoPalette().neutral;

      for (final color in neutral.colors) {
        expect(color.r, color.g);
        expect(color.g, color.b);
      }
    });

    test('rejects translucent accent seeds', () {
      expect(
        () => MateoPalette(accentColor: const Color(0x804A5CFF)),
        throwsArgumentError,
      );
    });

    test('when palettes are compared, it should use the accent seed', () {
      expect(MateoPalette(), MateoPalette());
      expect(
        MateoPalette(accentColor: const Color(0xFF00A86B)),
        isNot(MateoPalette()),
      );
      expect(
        MateoPalette(accentColor: const Color(0xFF00A86B)).hashCode,
        MateoPalette(accentColor: const Color(0xFF00A86B)).hashCode,
      );
    });
  });
}
