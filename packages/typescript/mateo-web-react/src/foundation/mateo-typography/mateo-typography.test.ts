// @vitest-environment node

import { expect, it } from 'vitest';
import { mateoTypography } from './mateo-typography.js';

it('should expose immutable shared text defaults when using Mateo typography', () => {
  expect(mateoTypography).toEqual({
    fontFamily: 'Inter, sans-serif',
    letterSpacing: '-0.2px',
  });
  expect(Object.isFrozen(mateoTypography)).toBe(true);
});
