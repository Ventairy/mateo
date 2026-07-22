import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  group('MateoColorScheme.light', () {
    final palette = MateoPalette();
    final scheme = MateoColorScheme.light(palette: palette);

    test('matches the shared Mateo mobile tokens', () {
      expect(scheme.background, scheme.bottomSheet.background);
      expect(scheme.colors.neutral.solid, palette.neutral[12]);
      expect(scheme.colors.neutral.onSolid, scheme.text.inverse);
      expect(scheme.text.primary, palette.neutral[12]);
      expect(scheme.text.secondary, palette.neutral[10]);
      expect(scheme.text.tertiary, palette.neutral[9]);
      expect(scheme.text.disabled, palette.neutral[9]);
      expect(scheme.text.inverse, scheme.inverse.onBackground);
      expect(scheme.text.profit, palette.green[10]);
      expect(
        scheme.selectionHighlight,
        palette.primary[9].withValues(alpha: .3),
      );
      expect(scheme.overlay.scrim, const Color(0x66000000));
      expect(scheme.scrollbar.thumb, palette.neutral[7]);
      expect(scheme.scrollbar.track, Colors.transparent);
      expect(scheme.controls.track, palette.neutral[6]);
      expect(scheme.controls.indicator, palette.primary[9]);
    });

    test('keeps rest and pressed button colors identical', () {
      final buttons = [
        scheme.buttons.primary,
        scheme.buttons.secondary,
        scheme.buttons.tertiary,
        scheme.buttons.text,
        scheme.buttons.danger,
        scheme.buttons.success,
        scheme.buttons.whatsapp.primary,
        scheme.buttons.whatsapp.secondary,
        scheme.buttons.whatsapp.tertiary,
      ];

      for (final button in buttons) {
        expect(button.backgroundPressed, button.background);
      }
      expect(
        scheme.buttons.floating.backgroundPressed,
        scheme.buttons.floating.background,
      );
      expect(
        scheme.buttons.searchBar.backgroundPressed,
        scheme.buttons.searchBar.background,
      );
    });

    test('matches component-specific roles', () {
      expect(scheme.buttons.primary.background, palette.primary[9]);
      expect(scheme.buttons.primary.foreground, scheme.colors.neutral.onSolid);
      expect(scheme.buttons.success.foreground, palette.green[12]);
      expect(scheme.buttons.whatsapp.primary.foreground, palette.whatsapp[12]);
      expect(scheme.buttons.searchBar.foreground, scheme.text.primary);
      expect(scheme.toast.neutral.icon, palette.neutral[8]);
      expect(scheme.bottomSheet.handle, palette.neutral[6]);
    });

    test('matches the Mateo map scheme', () {
      expect(scheme.map.landuse, palette.neutral[3]);
      expect(scheme.map.landuseBusiness, palette.neutral[3]);
      expect(scheme.map.locationRadius, palette.teal[9].withValues(alpha: .15));
    });

    test('uses a custom palette and primary foreground', () {
      final customPalette = MateoPalette(primaryColor: const Color(0xFF00A86B));
      const onPrimary = Color(0xFF102018);
      final custom = MateoColorScheme.light(
        palette: customPalette,
        onPrimary: onPrimary,
      );

      expect(custom.buttons.primary.background, customPalette.primary[9]);
      expect(custom.buttons.primary.foreground, onPrimary);
      expect(custom.controls.indicatorForeground, onPrimary);
      expect(custom.text.primary, customPalette.neutral[12]);
    });
  });

  test('copyWith and lerp preserve the complete contract', () {
    final a = MateoColorScheme.light();
    const customNeutral = MateoColorVariantColorScheme(
      solid: Color(0xFF222222),
      onSolid: Color(0xFFF8F8F8),
    );
    final customColors = a.colors.copyWith(neutral: customNeutral);
    final b = a.copyWith(background: Colors.black, colors: customColors);

    expect(b.background, Colors.black);
    expect(b.colors.neutral, customNeutral);
    expect(b.text, a.text);
    expect(MateoColorScheme.lerp(a, b, 0), a);
    expect(MateoColorScheme.lerp(a, b, 1), b);
  });
}
