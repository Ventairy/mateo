import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);

  test('when requesting dark appearance, it should resolve to the same light data', () {
    final dark = MateoThemeData.dark(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
    expect(dark, theme);
    expect(dark.hashCode, theme.hashCode);
    expect(dark.brightness, Brightness.light);
    expect(
      MateoColorScheme.dark(palette: theme.palette, onAccent: theme.colorScheme.onAccent),
      theme.colorScheme,
    );
    expect(dark.copyWith(onAccent: MateoPalette().black), theme.copyWith(onAccent: MateoPalette().black));
    expect(
      () => MateoThemeData.dark(accentColor: const Color(0x804A5CFF), onAccent: MateoPalette().white),
      throwsArgumentError,
    );
  });

  test('when deriving a light scheme, it should retain the shared semantic mappings', () {
    final colors = theme.colorScheme;
    expect(colors.background, MateoPalette().white);
    expect(colors.accent, theme.palette.accent[9]);
    expect(colors.onAccent, MateoPalette().white);
    expect(colors.text.primary, theme.palette.neutral[12]);
    expect(colors.text.secondary, theme.palette.neutral[10]);
    expect(colors.text.tertiary, theme.palette.neutral[8]);
    expect(colors.text.profit, theme.palette.green[9]);
    expect(colors.inverse.background, theme.palette.neutral[12]);
    expect(colors.inverse.onBackground, MateoPalette().white);
    expect(colors.inverse.accent, theme.palette.accent[3]);
  });

  test('when replacing the accent, it should derive a matching palette and scheme', () {
    final changed = theme.copyWith(accentColor: const Color(0xFF00A86B));
    expect(changed.palette.accent[9], const Color(0xFF00A86B));
    expect(changed.colorScheme.accent, changed.palette.accent[9]);
    expect(changed.colorScheme.inverse.accent, changed.palette.accent[3]);
    expect(changed.colorScheme.onAccent, theme.colorScheme.onAccent);
    expect(changed.colorScheme.text, theme.colorScheme.text);
    expect(theme.palette.accent[9], const Color(0xFF4A5CFF));
  });

  test('when replacing onAccent, it should preserve the exact input and palette', () {
    final changed = theme.copyWith(onAccent: const Color(0x80123456));
    expect(changed.colorScheme.onAccent, const Color(0x80123456));
    expect(changed.palette, theme.palette);
    expect(changed, isNot(theme));
  });

  test('when copying identical inputs, it should preserve value equality and hashes', () {
    final copy = theme.copyWith();
    expect(copy, theme);
    expect(copy.hashCode, theme.hashCode);
    expect(copy.colorScheme, theme.colorScheme);
    expect(copy.colorScheme.hashCode, theme.colorScheme.hashCode);
    expect(copy.colorScheme.text.hashCode, theme.colorScheme.text.hashCode);
    expect(copy.colorScheme.inverse, theme.colorScheme.inverse);
    expect(copy.colorScheme.inverse.hashCode, theme.colorScheme.inverse.hashCode);
  });

  test('when a copied accent is translucent, it should reject the inconsistent configuration', () {
    expect(() => theme.copyWith(accentColor: const Color(0x804A5CFF)), throwsArgumentError);
  });

  test('when retaining text colors, it should identify their actual contrast limits', () {
    double contrast(Color foreground) => 1.05 / (foreground.computeLuminance() + 0.05);
    expect(contrast(theme.colorScheme.text.primary), greaterThanOrEqualTo(4.5));
    expect(contrast(theme.colorScheme.text.secondary), greaterThanOrEqualTo(4.5));
    expect(contrast(theme.colorScheme.text.tertiary), lessThan(4.5));
    expect(contrast(theme.colorScheme.text.profit), lessThan(4.5));
  });
}
