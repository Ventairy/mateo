import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  group('MateoColorScale', () {
    final scale = MateoPalette().primary;

    test(
      'when used directly as a color, it should have the same channels as step 9',
      () {
        expect(scale, isSameColorAs(scale[9]));
      },
    );

    test('when reading step 0, it should reject the invalid design token', () {
      expect(() => scale[0], throwsRangeError);
    });

    test('when reading step 13, it should reject the invalid design token', () {
      expect(() => scale[13], throwsRangeError);
    });

    test(
      'when attempting to append to the exposed colors, it should preserve scale immutability',
      () {
        expect(() => scale.colors.add(scale[1]), throwsUnsupportedError);
      },
    );

    test(
      'when reading valid scale keys, it should expose steps 1 through 12',
      () {
        expect(
          scale.keys,
          orderedEquals(<int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]),
        );
      },
    );

    test('when two scales contain the same colors, they should be equal', () {
      final first = MateoPalette(primaryColor: const Color(0xFF0090FF)).primary;
      final second = MateoPalette(
        primaryColor: const Color(0xFF0090FF),
      ).primary;
      expect(first, second);
    });

    test('when two scales are equal, they should have equal hash codes', () {
      final first = MateoPalette(primaryColor: const Color(0xFF0090FF)).primary;
      final second = MateoPalette(
        primaryColor: const Color(0xFF0090FF),
      ).primary;
      expect(first.hashCode, second.hashCode);
    });
  });
}
