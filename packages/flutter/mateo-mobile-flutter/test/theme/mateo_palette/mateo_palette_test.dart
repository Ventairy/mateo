import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

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
        Color(0xFFFBFCFD),
        Color(0xFFF4F5F7),
        Color(0xFFEAEBEF),
        Color(0xFFE0E1E5),
        Color(0xFFD6D7DC),
        Color(0xFFCCCDD3),
        Color(0xFFBFC1C6),
        Color(0xFF909297),
        Color(0xFF707175),
        Color(0xFF626367),
        Color(0xFF3E4043),
        Color(0xFF17181B),
      ]);
    });

    test('ships Mateo vivid step-9 anchors', () {
      final palette = MateoPalette();

      expect(palette.green[9], const Color(0xFF00D757));
      expect(palette.amber[9], const Color(0xFFFFAA00));
      expect(palette.red[9], const Color(0xFFFB2C36));
      expect(palette.blue[9], const Color(0xFF2B7FFF));
      expect(palette.cyan[9], const Color(0xFF00C2E6));
      expect(palette.violet[9], const Color(0xFF8E51FF));
      expect(palette.teal[9], const Color(0xFF00C7B2));
      expect(palette.orange[9], const Color(0xFFFF6900));
      expect(palette.pink[9], const Color(0xFFF6339A));
      expect(palette.yellow[9], const Color(0xFFFFD000));
      expect(palette.whatsapp[9], const Color(0xFF25D366));
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

    test('creates untinted neutrals from an achromatic seed', () {
      final neutral = MateoPalette(
        accentColor: const Color(0xFF555555),
      ).neutral;

      for (final color in neutral.colors) {
        expect(color.r, closeTo(color.g, 0.0001));
        expect(color.g, closeTo(color.b, 0.0001));
      }
    });

    test('rejects translucent accent seeds', () {
      expect(
        () => MateoPalette(accentColor: const Color(0x804A5CFF)),
        throwsArgumentError,
      );
    });

    test('compares palettes by their accent seed', () {
      expect(MateoPalette(), MateoPalette());
      expect(
        MateoPalette(accentColor: const Color(0xFF00A86B)),
        isNot(MateoPalette()),
      );
    });
  });
}
