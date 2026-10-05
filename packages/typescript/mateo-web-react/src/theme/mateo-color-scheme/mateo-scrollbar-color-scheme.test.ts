// @vitest-environment node
import { expect, it } from 'vitest';
import { createMateoTheme, MateoScrollbarColorScheme } from '../../mateo.js';

it.each(['#4A5CFF', '#00A86B'])(
  'should use neutral thumb colors when creating a light theme with accent %s',
  (accentColor) => {
    const theme = createMateoTheme({ accentColor, onAccent: '#FFF' });
    expect(theme.colorScheme.scrollbar).toBeInstanceOf(
      MateoScrollbarColorScheme,
    );
    expect(theme.colorScheme.scrollbar).toEqual({
      thumb: theme.palette.neutral[4],
      thumbHover: theme.palette.neutral[6],
    });
    expect(Object.isFrozen(theme.colorScheme.scrollbar)).toBe(true);
  },
);

it('should preserve supplied colors when constructing an immutable scrollbar group', () => {
  const colors = { thumb: '#DDD', thumbHover: '#BBB' };
  const scrollbar = new MateoScrollbarColorScheme(colors);
  colors.thumb = '#000';
  expect(scrollbar).toEqual({ thumb: '#DDD', thumbHover: '#BBB' });
  expect(Reflect.set(scrollbar, 'thumbHover', '#000')).toBe(false);
});
