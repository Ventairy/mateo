// @vitest-environment node
import { expect, it } from 'vitest';
import { createMateoTheme, MateoSelectionColorScheme } from '../../mateo.js';

it('should expose immutable selection colors when creating a theme', () => {
  const theme = createMateoTheme({ accentColor: '#4A5CFF', onAccent: '#FFF' });
  expect(theme.colorScheme.selection).toBeInstanceOf(MateoSelectionColorScheme);
  expect(Object.isFrozen(theme.colorScheme.selection)).toBe(true);
});

it('should preserve supplied colors when constructing a selection group', () => {
  const colors = { background: '#EEF', foreground: '#113' };
  const selection = new MateoSelectionColorScheme(colors);
  colors.background = '#FFF';
  expect(selection).toEqual({ background: '#EEF', foreground: '#113' });
  expect(Reflect.set(selection, 'foreground', '#000')).toBe(false);
});
