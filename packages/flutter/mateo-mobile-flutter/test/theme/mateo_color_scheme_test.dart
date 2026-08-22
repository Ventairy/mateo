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
      expect(scheme.text.tertiary, palette.neutral[8]);
      expect(scheme.text.disabled, palette.neutral[9]);
      expect(scheme.text.inverse, scheme.inverse.onBackground);
      expect(scheme.text.profit, palette.green[10]);
      expect(
        scheme.selectionHighlight,
        palette.accent[9].withValues(alpha: .3),
      );
      expect(scheme.overlay.scrim, const Color(0x66000000));
      expect(scheme.scrollbar.thumb, palette.neutral[7]);
      expect(scheme.scrollbar.track, Colors.transparent);
      expect(scheme.controls.track, palette.neutral[6]);
      expect(scheme.controls.indicator, palette.accent[9]);
      expect(scheme.textField.quiet.text, scheme.text.primary);
      expect(scheme.textField.quiet.textDisabled, scheme.text.primary);
      expect(scheme.textField.quiet.placeholderResting, scheme.text.tertiary);
      expect(scheme.textField.quiet.placeholderDisabled, scheme.text.tertiary);
      expect(scheme.textField.quiet.caret, scheme.controls.caret);
      expect(
        scheme.textField.quiet.selectionHighlight,
        scheme.selectionHighlight,
      );
      expect(scheme.textField.quiet.characterCounterText, palette.neutral[9]);
      expect(
        scheme.textField.quiet.characterCounterTextReject,
        palette.red[10],
      );
      expect(scheme.textField.search.background, Colors.white);
      expect(scheme.textField.search.backgroundDisabled, palette.neutral[4]);
      expect(scheme.textField.search.shadow, Colors.black.withValues(alpha: 0.1));
      expect(scheme.textField.search.shadowDisabled, Colors.black.withValues(alpha: 0.1));
      expect(scheme.textField.search.text, scheme.text.primary);
      expect(scheme.textField.search.iconResting, palette.neutral[9]);
      expect(scheme.textField.search.iconFocused, scheme.text.primary);
      expect(scheme.textField.search.caret, scheme.controls.caret);
      expect(
        scheme.textField.search.selectionHighlight,
        palette.accent[9].withValues(alpha: 0.3),
      );
      expect(scheme.textArea.text, scheme.text.primary);
      expect(scheme.textArea.placeholderResting, scheme.text.tertiary);
      expect(scheme.textArea.caret, scheme.controls.caret);
    });

    test('keeps rest and pressed button colors identical', () {
      final buttons = [
        scheme.buttons.accent.primary,
        scheme.buttons.accent.secondary,
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
      expect(scheme.buttons.accent.primary.background, palette.accent[9]);
      expect(scheme.buttons.accent.primary.foreground, scheme.colors.neutral.onSolid);
      expect(scheme.buttons.success.foreground, palette.green[12]);
      expect(scheme.buttons.whatsapp.primary.foreground, palette.whatsapp[12]);
      expect(scheme.buttons.searchBar.foreground, scheme.text.primary);
      expect(scheme.buttonPanel.background, palette.neutral[1]);
      expect(scheme.buttonPanel.border, scheme.background);
      expect(scheme.buttonPanel.shadow, const Color(0x33000000));
      expect(scheme.toast.neutral.icon, palette.neutral[8]);
    });

    test('matches the Mateo map scheme', () {
      expect(scheme.map.landuse, palette.neutral[2]);
      expect(scheme.map.landuseBusiness, palette.neutral[2]);
      expect(scheme.map.locationRadius, palette.teal[9].withValues(alpha: .15));
    });

    test('uses a custom palette and accent foreground', () {
      final customPalette = MateoPalette(accentColor: const Color(0xFF00A86B));
      const onAccent = Color(0xFF102018);
      final custom = MateoColorScheme.light(
        palette: customPalette,
        onAccent: onAccent,
      );

      expect(custom.buttons.accent.primary.background, customPalette.accent[9]);
      expect(custom.buttons.accent.primary.foreground, onAccent);
      expect(custom.controls.indicatorForeground, onAccent);
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
    final customAccent = a.buttons.accent.copyWith(
      primary: a.buttons.accent.primary.copyWith(background: Colors.pink),
    );
    final customButtons = a.buttons.copyWith(accent: customAccent);
    final b = a.copyWith(
      background: Colors.black,
      colors: customColors,
      buttons: customButtons,
    );

    expect(b.background, Colors.black);
    expect(b.colors.neutral, customNeutral);
    expect(b.buttons.accent, customAccent);
    expect(b.buttons.accent.primary.background, Colors.pink);
    expect(b.text, a.text);
    expect(MateoColorScheme.lerp(a, b, 0), a);
    expect(
      MateoColorScheme.lerp(a, b, 0.5).buttons.accent.primary.background,
      Color.lerp(
        a.buttons.accent.primary.background,
        b.buttons.accent.primary.background,
        0.5,
      ),
    );
    expect(
      MateoButtonToneColorScheme.lerp(a.buttons.accent, b.buttons.accent, 0),
      a.buttons.accent,
    );
    expect(
      MateoButtonToneColorScheme.lerp(
        a.buttons.accent,
        b.buttons.accent,
        0.5,
      ).primary.background,
      Color.lerp(
        a.buttons.accent.primary.background,
        b.buttons.accent.primary.background,
        0.5,
      ),
    );
  });
}
