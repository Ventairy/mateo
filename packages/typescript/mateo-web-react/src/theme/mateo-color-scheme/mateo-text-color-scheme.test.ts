// @vitest-environment node
import { describe, expect, it } from 'vitest';
import { createMateoTheme, MateoTextColorScheme } from '../../mateo.js';

describe('Mateo text colors', () => {
  it.each([
    ['the Mateo accent', '#4A5CFF'],
    ['a custom product accent', '#00A86B'],
  ])('should derive all text roles when using %s', (_name, accentColor) => {
    const theme = createMateoTheme({ accentColor, onAccent: '#FFFFFF' });
    expect(theme.colorScheme.text).toEqual({
      primary: theme.palette.neutral[12],
      secondary: theme.palette.neutral[10],
      tertiary: theme.palette.neutral[8],
      profit: theme.palette.green[9],
    });
    expect(theme.colorScheme.text).toBeInstanceOf(MateoTextColorScheme);
    expect(Object.isFrozen(theme.colorScheme.text)).toBe(true);
    expect(Reflect.set(theme.colorScheme.text, 'primary', '#FFFFFF')).toBe(
      false,
    );
    expect(theme.colorScheme.text.primary).toBe(theme.palette.neutral[12]);
  });

  it('should preserve supplied roles when constructing an immutable text group', () => {
    const colors = {
      primary: '#111111',
      secondary: '#555555',
      tertiary: '#999999',
      profit: '#008800',
    };
    const scheme = new MateoTextColorScheme(colors);
    colors.primary = '#FFFFFF';
    expect(scheme).toEqual({ ...colors, primary: '#111111' });
    expect(Object.isFrozen(scheme)).toBe(true);
  });
});
