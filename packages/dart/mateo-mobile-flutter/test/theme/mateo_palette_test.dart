import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  test('when using the default palette, it should match all authored foundation values', () {
    // Snapshot of design-system/foundation/color-palette.md, including all 144 steps.
    final expected = jsonDecode(File('test/theme/fixtures/palette.json').readAsStringSync()) as Map<String, dynamic>;
    final palette = MateoPalette();
    final actual = <String, MateoColorScale>{
      'accent': palette.accent,
      'neutral': palette.neutral,
      'green': palette.green,
      'amber': palette.amber,
      'red': palette.red,
      'blue': palette.blue,
      'cyan': palette.cyan,
      'violet': palette.violet,
      'teal': palette.teal,
      'orange': palette.orange,
      'pink': palette.pink,
      'yellow': palette.yellow,
    };
    expect(actual.keys, unorderedEquals(expected.keys));
    for (final entry in actual.entries) {
      expect(entry.value.colors.map((color) => color.toARGB32()), expected[entry.key], reason: entry.key);
    }
    expect(palette.white, const Color(0xFFFFFFFF));
    expect(palette.black, const Color(0xFF000000));
    expect(MateoPalette(accentColor: const Color(0xFF4A5CFF)), palette);
  });

  test('when generating custom accents, it should preserve seeds and fixed scales', () {
    final original = MateoPalette();
    for (final seed in const [
      Color(0xFFE53935),
      Color(0xFF00A86B),
      Color(0xFFFFD000),
      Color(0xFFFFB8D1),
      Color(0xFF24163D),
      Color(0xFF000000),
      Color(0xFFFFFFFF),
    ]) {
      final palette = MateoPalette(accentColor: seed);
      expect(palette.accent[9], seed);
      expect(palette.accent.colors, hasLength(12));
      expect(palette.white, original.white);
      expect(palette.black, original.black);
      expect(palette.neutral, original.neutral);
      expect(palette.green, original.green);
      expect(palette.amber, original.amber);
      expect(palette.red, original.red);
      expect(palette.blue, original.blue);
      expect(palette.cyan, original.cyan);
      expect(palette.violet, original.violet);
      expect(palette.teal, original.teal);
      expect(palette.orange, original.orange);
      expect(palette.pink, original.pink);
      expect(palette.yellow, original.yellow);

      for (final color in palette.accent.colors) {
        expect(color.a, 1);
        for (final channel in [color.r, color.g, color.b]) {
          expect(channel.isFinite, isTrue);
          expect(channel, inInclusiveRange(0, 1));
        }
      }
    }
  });

  test('when generating a vivid accent, it should preserve light-to-dark separation', () {
    final colors = MateoPalette(accentColor: const Color(0xFF00A86B)).accent.colors;
    for (var i = 1; i < colors.length; i++) {
      expect(colors[i - 1].computeLuminance(), greaterThan(colors[i].computeLuminance()));
    }
  });

  test('when indexing or mutating scales, it should enforce the immutable 12-step contract', () {
    final scale = MateoPalette().accent;
    expect(scale[1], scale.colors.first);
    expect(scale[12], scale.colors.last);
    for (final step in [-1, 0, 13]) {
      expect(() => scale[step], throwsRangeError);
    }
    expect(() => scale.colors[0] = MateoPalette().black, throwsUnsupportedError);
    expect(() => scale.colors.add(MateoPalette().black), throwsUnsupportedError);
    expect(scale, isA<Color>());
  });

  test('when using a scale as a color, it should use its step-9 anchor', () {
    final palette = MateoPalette();
    for (final scale in [
      palette.accent,
      palette.neutral,
      palette.green,
      palette.amber,
      palette.red,
      palette.blue,
      palette.cyan,
      palette.violet,
      palette.teal,
      palette.orange,
      palette.pink,
      palette.yellow,
    ]) {
      final box = ColoredBox(color: scale);
      expect(box.color.toARGB32(), scale[9].toARGB32());
      expect(box.color.computeLuminance(), scale[9].computeLuminance());
      expect(scale.withValues(alpha: 0.5), scale[9].withValues(alpha: 0.5));
    }
  });

  test('when using a precise custom accent directly, it should retain the seed channels', () {
    const seed = Color.from(alpha: 1, red: 0.123456, green: 0.654321, blue: 0.345678);
    final Color color = MateoPalette(accentColor: seed).accent;
    expect(color.r, seed.r);
    expect(color.g, seed.g);
    expect(color.b, seed.b);
    expect(color.a, seed.a);
    expect(color.colorSpace, seed.colorSpace);
  });

  test('when given a translucent accent, it should reject the seed', () {
    expect(() => MateoPalette(accentColor: const Color(0x804A5CFF)), throwsArgumentError);
    expect(() => MateoPalette(accentColor: const Color(0x004A5CFF)), throwsArgumentError);
  });

  test('when comparing palettes and scales, it should compare color values', () {
    final first = MateoPalette(accentColor: const Color(0xFF00A86B));
    final second = MateoPalette(accentColor: const Color(0xFF00A86B));
    expect(first, second);
    expect(first.hashCode, second.hashCode);
    expect(first.accent, second.accent);
    expect(first.accent.hashCode, second.accent.hashCode);
    expect(first, isNot(MateoPalette()));
    expect(first.accent, isNot(MateoPalette().accent));
  });
}
