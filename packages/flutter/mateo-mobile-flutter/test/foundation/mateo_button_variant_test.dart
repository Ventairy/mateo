import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

void main() {
  test('when tertiary neutral is defined, it should preserve the shared foreground and transparent surfaces', () {
    final palette = MateoPalette(accentColor: Colors.blue);
    final group = MateoColorScheme.light(palette: palette).buttons.tertiary;
    final colors = group.neutral;
    expect(colors.background, Colors.transparent);
    expect(colors.backgroundPressed, Colors.transparent);
    expect(colors.backgroundDisabled, Colors.transparent);
    expect(colors.foreground, palette.neutral[12]);
    expect(colors.foregroundDisabled, palette.neutral[9]);
    expect(group.copyWith(), group);
    expect(group.copyWith().hashCode, group.hashCode);
    expect(MateoTertiaryButtonColorScheme(neutral: colors), group);
    final other = group.copyWith(neutral: colors.copyWith(foreground: Colors.orange));
    expect(other, isNot(group));
    expect(
      MateoTertiaryButtonColorScheme.lerp(group, other, 0.5).neutral.foreground,
      Color.lerp(colors.foreground, Colors.orange, 0.5),
    );
  });

  test('when a bare group is selected, it should equal its explicit default', () {
    for (final (group, explicit) in <(MateoButtonVariant, MateoButtonVariant)>[
      (MateoButtonVariant.primary, MateoButtonVariant.primary.accent),
      (MateoButtonVariant.tertiary, MateoButtonVariant.tertiary.neutral),
      (MateoButtonVariant.secondary, MateoButtonVariant.secondary.accent),
    ]) {
      expect(group, same(explicit));
      expect(group.hashCode, explicit.hashCode);
      expect(
        Widget.canUpdate(
          MateoButtonPresentation.label(label: 'Action', variant: group),
          MateoButtonPresentation.label(label: 'Action', variant: explicit),
        ),
        isTrue,
      );
    }
  });

  test('when a preset is resolved, it should select its authored theme entry', () {
    final theme = MateoColorScheme.light();
    final selections = [
      (MateoButtonVariant.tertiary, theme.buttons.tertiary.neutral),
      (MateoButtonVariant.primary.accent, theme.buttons.primary.accent),
      (MateoButtonVariant.primary.neutral, theme.buttons.primary.neutral),
      (MateoButtonVariant.primary.base, theme.buttons.primary.base),
      (MateoButtonVariant.secondary.accent, theme.buttons.secondary.accent),
      (MateoButtonVariant.secondary.neutral, theme.buttons.secondary.neutral),
    ];
    expect(selections.map((entry) => entry.$1).toSet(), hasLength(6));
    for (final (variant, expected) in selections) {
      expect(variant.colorScheme(theme), same(expected));
    }
    expect(theme.buttons.primary.base.background, Colors.white);
  });

  test('when bare variants are used in const presentations, it should retain canonical values', () {
    const presentations = [
      MateoButtonPresentation.label(label: 'Action', variant: MateoButtonVariant.primary),
      MateoButtonPresentation.label(label: 'Action', variant: MateoButtonVariant.secondary),
      MateoButtonPresentation.label(label: 'Action', variant: MateoButtonVariant.tertiary),
    ];
    expect(
      presentations.map((presentation) => presentation.variant),
      [
        MateoButtonVariant.primary,
        MateoButtonVariant.secondary,
        MateoButtonVariant.tertiary,
      ],
    );
    for (final presentation in presentations) {
      expect(
        Widget.canUpdate(
          presentation,
          MateoButtonPresentation.label(label: 'Action', variant: presentation.variant),
        ),
        isTrue,
      );
    }
    expect(MateoButtonVariant.primary.base, same(MateoButtonVariant.primary.base));
    expect(MateoButtonVariant.secondary.neutral, same(MateoButtonVariant.secondary.neutral));
  });

  test('when elevation is omitted or fractional, presentations retain the authored value', () {
    final label = MateoButtonPresentation.label(label: 'Action', variant: MateoButtonVariant.primary.base);
    final icon = MateoButtonPresentation.icon(
      variant: MateoButtonVariant.primary.base,
      elevation: 1.5,
      iconBuilder: _icon,
    );
    expect(label.elevation, 0);
    expect(icon.elevation, 1.5);
  });

  test('when tertiary colors change, it should copy interpolate and resolve the complete override', () {
    final base = MateoColorScheme.light();
    final target = base.copyWith(
      buttons: base.buttons.copyWith(
        tertiary: base.buttons.tertiary.copyWith(
          neutral: base.buttons.tertiary.neutral.copyWith(foreground: Colors.blue),
        ),
      ),
    );
    expect(target.buttons.tertiary.neutral.foreground, Colors.blue);
    expect(target.buttons.primary, base.buttons.primary);
    expect(target.copyWith(), target);
    expect(target.copyWith().hashCode, target.hashCode);
    final midpoint = MateoColorScheme.lerp(base, target, 0.5);
    expect(
      MateoButtonVariant.tertiary.colorScheme(midpoint).foreground,
      Color.lerp(base.buttons.tertiary.neutral.foreground, Colors.blue, 0.5),
    );
  });
}

Widget _icon(MateoIconButtonIconState state) => const SizedBox.shrink();
