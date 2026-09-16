import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

void main() {
  group('MateoColorScheme.light', () {
    final palette = MateoPalette();
    final scheme = MateoColorScheme.light(palette: palette);

    test('matches the shared Mateo mobile tokens', () {
      expect(scheme.background, scheme.sheet.background);
      expect(scheme.text.primary, palette.neutral[12]);
      expect(scheme.text.secondary, palette.neutral[10]);
      expect(scheme.text.tertiary, palette.neutral[8]);
      expect(scheme.text.profit, palette.green[9]);
      expect(scheme.overlay.scrim, const Color(0x66000000));
      expect(scheme.controls.track, palette.neutral[6]);
      expect(scheme.textField.floating.background, Colors.white);
      expect(scheme.textField.floating.backgroundDisabled, palette.neutral[4]);
      expect(scheme.textField.floating.text, scheme.text.primary);
      expect(scheme.textField.floating.textDisabled, palette.neutral[8]);
      expect(scheme.textField.floating.placeholderResting, palette.neutral[9]);
      expect(scheme.textField.floating.placeholderDisabled, palette.neutral[8]);
      expect(scheme.textField.floating.iconResting, palette.neutral[9]);
      expect(scheme.textField.floating.iconFocused, scheme.text.primary);
      expect(scheme.textField.floating.iconDisabled, palette.neutral[8]);
      expect(scheme.textField.floating.caret, palette.accent[9]);
      expect(
        scheme.textField.floating.selectionHighlight,
        palette.accent[9].withValues(alpha: 0.3),
      );
      expect(scheme.textField.filled.background, palette.neutral[3]);
      expect(scheme.textField.filled.backgroundDisabled, palette.neutral[4]);
      expect(scheme.textField.filled.text, scheme.text.primary);
      expect(scheme.textField.filled.textDisabled, palette.neutral[8]);
      expect(scheme.textField.filled.placeholderResting, palette.neutral[6]);
      expect(scheme.textField.filled.placeholderDisabled, palette.neutral[8]);
      expect(scheme.textField.filled.iconResting, palette.neutral[6]);
      expect(scheme.textField.filled.iconFocused, palette.neutral[6]);
      expect(scheme.textField.filled.iconDisabled, palette.neutral[8]);
      expect(scheme.textField.filled.caret, palette.accent[9]);
      expect(
        scheme.textField.filled.selectionHighlight,
        palette.accent[9].withValues(alpha: 0.3),
      );
      expect(scheme.characterCounter.text.foreground, palette.neutral[9]);
      expect(
        scheme.characterCounter.text.foregroundReject,
        palette.red[10],
      );
    });

    test('keeps rest and pressed button colors identical', () {
      final buttons = [
        scheme.buttons.primary.accent,
        scheme.buttons.secondary.accent,
        scheme.buttons.primary.neutral,
        scheme.buttons.secondary.neutral,
        scheme.buttons.tertiary.neutral,
      ];

      for (final button in buttons) {
        expect(button.backgroundPressed, button.background);
      }
    });

    test('matches component-specific roles', () {
      expect(scheme.buttons.primary.accent.background, palette.accent[9]);
      expect(scheme.buttons.primary.accent.foreground, Colors.white);
      expect(scheme.buttons.primary.neutral.background, palette.neutral[12]);
      expect(scheme.buttons.primary.neutral.backgroundPressed, palette.neutral[12]);
      expect(scheme.buttons.primary.neutral.foreground, palette.neutral[1]);
      expect(scheme.buttons.primary.neutral.backgroundDisabled, palette.neutral[5]);
      expect(scheme.buttons.primary.neutral.foregroundDisabled, palette.neutral[9]);
      expect(scheme.buttons.secondary.neutral.background, palette.neutral[2]);
      expect(scheme.buttons.secondary.neutral.backgroundPressed, palette.neutral[2]);
      expect(scheme.buttons.secondary.neutral.foreground, palette.neutral[12]);
      expect(scheme.buttons.secondary.neutral.backgroundDisabled, palette.neutral[5]);
      expect(scheme.buttons.secondary.neutral.foregroundDisabled, palette.neutral[9]);
      expect(scheme.toast.neutral.icon, palette.neutral[8]);
    });

    test('uses a custom palette and accent foreground', () {
      final customPalette = MateoPalette(accentColor: const Color(0xFF00A86B));
      const onAccent = Color(0xFF102018);
      final custom = MateoColorScheme.light(
        palette: customPalette,
        onAccent: onAccent,
      );

      expect(custom.buttons.primary.accent.background, customPalette.accent[9]);
      expect(custom.buttons.primary.accent.foreground, onAccent);
      expect(custom.text.primary, customPalette.neutral[12]);
      expect(custom.textField.floating.text, customPalette.neutral[12]);
      expect(custom.textField.floating.caret, customPalette.accent[9]);
      expect(custom.textField.filled.caret, customPalette.accent[9]);
    });
  });

  test('copyWith and lerp preserve the complete contract', () {
    final a = MateoColorScheme.light();
    final customAccent = a.buttons.primary.copyWith(
      accent: a.buttons.primary.accent.copyWith(background: Colors.pink),
    );
    final customNeutralTone = a.buttons.secondary.copyWith(
      neutral: a.buttons.secondary.neutral.copyWith(background: Colors.orange),
    );
    final customButtons = a.buttons.copyWith(
      primary: customAccent,
      secondary: customNeutralTone,
    );
    final b = a.copyWith(
      background: Colors.black,
      buttons: customButtons,
    );

    expect(b.background, Colors.black);
    expect(b.buttons.primary, customAccent);
    expect(b.buttons.primary.accent.background, Colors.pink);
    expect(b.buttons.secondary, customNeutralTone);
    expect(b.buttons.secondary.neutral.background, Colors.orange);
    expect(b.text, a.text);
    expect(b.textField, a.textField);
    expect(MateoColorScheme.lerp(a, b, 0), a);
    expect(a.buttons.copyWith(), a.buttons);
    expect(a.buttons.copyWith().hashCode, a.buttons.hashCode);
    expect(
      MateoColorScheme.lerp(a, b, 0.5).buttons.primary.accent.background,
      Color.lerp(
        a.buttons.primary.accent.background,
        b.buttons.primary.accent.background,
        0.5,
      ),
    );
    expect(
      MateoPrimaryButtonColorScheme.lerp(a.buttons.primary, b.buttons.primary, 0),
      a.buttons.primary,
    );
    expect(
      MateoPrimaryButtonColorScheme.lerp(
        a.buttons.primary,
        b.buttons.primary,
        0.5,
      ).accent.background,
      Color.lerp(
        a.buttons.primary.accent.background,
        b.buttons.primary.accent.background,
        0.5,
      ),
    );
    expect(
      MateoColorScheme.lerp(a, b, 0.5).buttons.secondary.neutral.background,
      Color.lerp(
        a.buttons.secondary.neutral.background,
        b.buttons.secondary.neutral.background,
        0.5,
      ),
    );
  });
}
