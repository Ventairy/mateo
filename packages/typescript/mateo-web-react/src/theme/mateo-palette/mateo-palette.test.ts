// @vitest-environment node

import { MateoDefaultPalette } from '@mateo/palette';
import { expect, it } from 'vitest';
import { createMateoPalette } from './mateo-palette.js';

it('should retain the shared palette API when consuming it through React', () => {
  expect(createMateoPalette()).toBe(MateoDefaultPalette);
  const custom = createMateoPalette({ accentColor: '#00A86B' });
  expect(custom.accent[9]).toBe('#00A86B');
  expect(custom.green).toBe(MateoDefaultPalette.green);
  expect(Object.isFrozen(custom)).toBe(true);
});
