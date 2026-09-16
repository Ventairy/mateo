import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);

  test('when nested filled variants resolve, they should retain their authored color roles', () {
    final filled = theme.colorScheme.textInputs.filled;
    expect(MateoTextInputVariant.filled, same(MateoTextInputVariant.filled.neutral));
    expect(MateoTextInputVariant.filled.neutral.resolveColorScheme(theme.colorScheme.textInputs), same(filled.neutral));
    expect(MateoTextInputVariant.filled.base.resolveColorScheme(theme.colorScheme.textInputs), same(filled.base));
    final expectedBase = MateoTextInputColorScheme(
      background: theme.palette.white,
      text: filled.neutral.text,
      placeholder: filled.neutral.placeholder,
      icon: theme.palette.neutral[9],
      backgroundDisabled: filled.neutral.backgroundDisabled,
      textDisabled: theme.palette.neutral[9],
      placeholderDisabled: theme.palette.neutral[9],
      iconDisabled: theme.palette.neutral[9],
    );
    expect(filled.base, expectedBase);
    expect(filled.base.hashCode, expectedBase.hashCode);
    expect(filled.base, isNot(filled.neutral));
    final other = MateoThemeData.light(accentColor: const Color(0xFFCC4422), onAccent: theme.palette.black);
    expect(filled, other.colorScheme.textInputs.filled);
    expect(filled.hashCode, other.colorScheme.textInputs.filled.hashCode);
  });

  test('when search elevation is omitted, it should default to flat', () {
    const presentation = MateoTextInputPresentation.search(variant: .filled);
    expect(presentation.elevation, 0);
  });

  test('when filled is resolved, it should expose neutral enabled and disabled colors', () {
    final colors = theme.colorScheme.textInputs.filled.neutral;
    expect(colors.background, theme.palette.neutral[2]);
    expect(colors.text, theme.palette.black);
    expect(colors.placeholder, theme.palette.neutral[7]);
    expect(colors.icon, theme.palette.neutral[10]);
    expect(colors.backgroundDisabled, theme.palette.neutral[4]);
    expect(colors.textDisabled, theme.palette.neutral[10]);
    expect(colors.placeholderDisabled, theme.palette.neutral[10]);
    expect(colors.iconDisabled, theme.palette.neutral[10]);
    expect(MateoTextInputVariant.filled.resolveColorScheme(theme.colorScheme.textInputs), same(colors));
  });

  test('when search is configured, it should retain the selected variant', () {
    const presentation = MateoTextInputPresentation.search(variant: .filled);
    expect(presentation.variant, MateoTextInputVariant.filled);
  });

  test('when the accent changes, it should preserve text input colors and their hashes', () {
    final changed = theme.copyWith(accentColor: const Color(0xFFCC4422), onAccent: theme.palette.black);
    expect(changed.colorScheme.textInputs, theme.colorScheme.textInputs);
    expect(changed.colorScheme.textInputs.hashCode, theme.colorScheme.textInputs.hashCode);
    expect(changed.colorScheme.textInputs.filled.hashCode, theme.colorScheme.textInputs.filled.hashCode);
    expect(theme.copyWith(), theme);
    expect(theme.copyWith().hashCode, theme.hashCode);
  });

  final colors = theme.colorScheme.textInputs.filled.neutral;
  for (final changedRole in <String?>[
    null,
    'background',
    'text',
    'placeholder',
    'icon',
    'backgroundDisabled',
    'textDisabled',
    'placeholderDisabled',
    'iconDisabled',
  ]) {
    test(
      changedRole == null
          ? 'when all roles match, it should compare equally with the same hash'
          : 'when $changedRole changes, it should compare unequally',
      () {
        final compared = MateoTextInputColorScheme(
          background: changedRole == 'background' ? theme.palette.white : colors.background,
          text: changedRole == 'text' ? theme.palette.white : colors.text,
          placeholder: changedRole == 'placeholder' ? theme.palette.white : colors.placeholder,
          icon: changedRole == 'icon' ? theme.palette.white : colors.icon,
          backgroundDisabled: changedRole == 'backgroundDisabled' ? theme.palette.white : colors.backgroundDisabled,
          textDisabled: changedRole == 'textDisabled' ? theme.palette.white : colors.textDisabled,
          placeholderDisabled: changedRole == 'placeholderDisabled' ? theme.palette.white : colors.placeholderDisabled,
          iconDisabled: changedRole == 'iconDisabled' ? theme.palette.white : colors.iconDisabled,
        );
        expect(compared, changedRole == null ? equals(colors) : isNot(colors));
        if (changedRole == null) expect(compared.hashCode, colors.hashCode);
      },
    );
  }
}
