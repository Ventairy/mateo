import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);

  test('when equivalent themes are created, their component schemes should compare equally', () {
    final copy = theme.copyWith();
    expect(copy, theme);
    expect(copy.hashCode, theme.hashCode);
    expect(copy.colorScheme.buttons, theme.colorScheme.buttons);
    expect(copy.colorScheme.menus, theme.colorScheme.menus);
    expect(copy.colorScheme.menus.hashCode, theme.colorScheme.menus.hashCode);
    expect(MateoColorScheme.dark(palette: theme.palette, onAccent: theme.colorScheme.onAccent), theme.colorScheme);
  });

  test('when resolving sheets, it should expose black scrim at 20 percent opacity', () {
    final sheet = theme.colorScheme.sheet;
    expect(sheet.scrim, const Color(0x33000000));
    final equivalent = MateoSheetColorScheme(scrim: sheet.scrim);
    expect(equivalent, sheet);
    expect(equivalent.hashCode, sheet.hashCode);
    expect(MateoSheetColorScheme(scrim: theme.palette.black), isNot(sheet));
    expect(theme.copyWith().colorScheme.sheet, sheet);
  });

  test('when resolving skeletons, it should expose the neutral bone color', () {
    final skeleton = theme.colorScheme.skeleton;
    expect(skeleton.bone, theme.palette.neutral[3]);
    final equivalent = MateoSkeletonColorScheme(bone: skeleton.bone);
    expect(equivalent, skeleton);
    expect(equivalent.hashCode, skeleton.hashCode);
    expect(MateoSkeletonColorScheme(bone: theme.palette.white), isNot(skeleton));
    expect(theme.copyWith().colorScheme.skeleton, skeleton);
  });

  test('when resolving options menus, it should expose their panel and content color roles', () {
    final menus = theme.colorScheme.menus;
    final options = menus.options;
    expect(options.background, theme.palette.black);
    expect(options.leading, theme.palette.white);
    expect(options.principal, theme.palette.white);
    expect(options.supporting, theme.palette.neutral[7]);
    final equivalent = MateoOptionsMenuColorScheme(
      background: options.background,
      leading: options.leading,
      principal: options.principal,
      supporting: options.supporting,
    );
    expect(equivalent, options);
    expect(equivalent.hashCode, options.hashCode);
    for (var role = 0; role < 4; role++) {
      expect(
        MateoOptionsMenuColorScheme(
          background: role == 0 ? theme.palette.white : options.background,
          leading: role == 1 ? theme.palette.black : options.leading,
          principal: role == 2 ? theme.palette.black : options.principal,
          supporting: role == 3 ? MateoPalette().white : options.supporting,
        ),
        isNot(options),
      );
    }
  });

  test('when the accent changes, it should update component colors together', () {
    final changed = theme.copyWith(accentColor: const Color(0xFFCC4422), onAccent: MateoPalette().black);
    final colors = changed.colorScheme;
    expect(colors, isNot(theme.colorScheme));
    expect(colors.buttons.primary.accent.background, colors.accent);
    expect(colors.buttons.primary.accent.foreground, colors.onAccent);
    expect(colors.buttons.secondary.accent.background, changed.palette.accent[2]);
    expect(colors.buttons.secondary.accent.foreground, changed.palette.accent[11]);
    expect(colors.buttons.primary.neutral, theme.colorScheme.buttons.primary.neutral);
  });

  test('when a variant resolves, it should reuse its theme treatment and unavailable roles', () {
    final colors = theme.colorScheme.buttons;
    for (final (variant, expected) in [
      (MateoButtonVariant.primary, colors.primary.accent),
      (MateoButtonVariant.primary.neutral, colors.primary.neutral),
      (MateoButtonVariant.primary.base, colors.primary.base),
      (MateoButtonVariant.secondary, colors.secondary.accent),
      (MateoButtonVariant.secondary.neutral, colors.secondary.neutral),
      (MateoButtonVariant.tertiary, colors.tertiary),
    ]) {
      expect(identical(variant.resolveColorScheme(colors), expected), isTrue);
      expect(expected.foregroundDisabled, theme.palette.neutral[9]);
    }
    expect(colors.primary.neutral.backgroundDisabled, theme.palette.neutral[5]);
    expect(colors.primary.accent.backgroundDisabled, theme.palette.neutral[4]);
    expect(colors.tertiary.background.a, 0);
    expect(colors.tertiary.backgroundDisabled.a, 0);
  });
}
