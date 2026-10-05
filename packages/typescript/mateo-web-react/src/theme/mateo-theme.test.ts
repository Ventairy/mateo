// @vitest-environment node

import { describe, expect, it } from 'vitest';
import { createMateoTheme, getMateoThemeStyle } from './mateo-theme.js';

describe('light theme', () => {
  it('should derive light roles and preserve transparent foregrounds when creating a theme', () => {
    const theme = createMateoTheme({
      accentColor: '#00A86B',
      onAccent: 'rgba(255, 255, 255, 0.8)',
    });
    expect(theme.appearance).toBe('light');
    expect(theme.colorScheme).toMatchObject({
      background: theme.palette.white,
      accent: theme.palette.accent[9],
      onAccent: 'rgba(255, 255, 255, 0.8)',
    });
    expect(Object.isFrozen(theme)).toBe(true);
    expect(Object.isFrozen(theme.colorScheme)).toBe(true);
  });

  it('should require both concrete colors when called from JavaScript', () => {
    expect(() => Reflect.apply(createMateoTheme, null, [{}])).toThrow(
      TypeError,
    );
    expect(() =>
      Reflect.apply(createMateoTheme, null, [{ accentColor: '#4A5CFF' }]),
    ).toThrow(TypeError);
    expect(() =>
      createMateoTheme({ accentColor: '#4A5CFF', onAccent: 'var(--text)' }),
    ).toThrow(TypeError);
  });
});

it('should provide inherited typography and selection colors when applying a theme', () => {
  const theme = createMateoTheme({ accentColor: '#4A5CFF', onAccent: '#FFF' });
  const style = getMateoThemeStyle(theme);
  expect(Object.isFrozen(style)).toBe(true);
  expect(style).toEqual({
    fontFamily: 'Inter, sans-serif',
    letterSpacing: '-0.2px',
    '--mateo-font-family': 'Inter, sans-serif',
    '--mateo-letter-spacing': '-0.2px',
    '--mateo-selection-background': theme.colorScheme.selection.background,
    '--mateo-selection-foreground': theme.colorScheme.selection.foreground,
  });
});
