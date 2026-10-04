// @vitest-environment node
import { describe, expect, it } from 'vitest';
import { createMateoTheme } from '../mateo-theme.js';

const mateoButtonColorTheme = createMateoTheme({
  accentColor: '#4A5CFF',
  onAccent: '#FFFFFF',
});
const mateoButtonPalette = mateoButtonColorTheme.palette;
const mateoButtonColorCases = [
  [
    'primary-accent',
    mateoButtonColorTheme.colorScheme.buttons.primary.accent,
    mateoButtonPalette.accent[9],
    '#FFFFFF',
    mateoButtonPalette.neutral[4],
  ],
  [
    'primary-success',
    mateoButtonColorTheme.colorScheme.buttons.primary.success,
    mateoButtonPalette.green[9],
    mateoButtonPalette.white,
    mateoButtonPalette.neutral[4],
  ],
  [
    'primary-warning',
    mateoButtonColorTheme.colorScheme.buttons.primary.warning,
    mateoButtonPalette.amber[9],
    mateoButtonPalette.white,
    mateoButtonPalette.neutral[4],
  ],
  [
    'primary-neutral',
    mateoButtonColorTheme.colorScheme.buttons.primary.neutral,
    mateoButtonPalette.neutral[12],
    mateoButtonPalette.neutral[1],
    mateoButtonPalette.neutral[5],
  ],
  [
    'primary-base',
    mateoButtonColorTheme.colorScheme.buttons.primary.base,
    mateoButtonPalette.white,
    mateoButtonPalette.black,
    mateoButtonPalette.neutral[4],
  ],
  [
    'secondary-accent',
    mateoButtonColorTheme.colorScheme.buttons.secondary.accent,
    mateoButtonPalette.accent[2],
    mateoButtonPalette.accent[9],
    mateoButtonPalette.neutral[4],
  ],
  [
    'secondary-neutral',
    mateoButtonColorTheme.colorScheme.buttons.secondary.neutral,
    mateoButtonPalette.neutral[2],
    mateoButtonPalette.neutral[12],
    mateoButtonPalette.neutral[5],
  ],
  [
    'tertiary-neutral',
    mateoButtonColorTheme.colorScheme.buttons.tertiary,
    'transparent',
    mateoButtonPalette.neutral[12],
    'transparent',
  ],
] as const;

describe('Mateo button colors', () => {
  it.each(mateoButtonColorCases)(
    'should preserve the complete treatment when resolving %s',
    (_name, colors, background, foreground, backgroundDisabled) => {
      expect(colors).toEqual({
        background,
        foreground,
        backgroundDisabled,
        foregroundDisabled: mateoButtonPalette.neutral[9],
      });
      expect(Object.isFrozen(colors)).toBe(true);
    },
  );
  it('should freeze treatment groups when creating the theme', () => {
    const colors = mateoButtonColorTheme.colorScheme.buttons;
    expect(Object.isFrozen(colors)).toBe(true);
    expect(Object.isFrozen(colors.primary)).toBe(true);
    expect(Object.isFrozen(colors.secondary)).toBe(true);
  });
});
