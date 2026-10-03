// @vitest-environment node
import { expect, it } from 'vitest';
import { getMateoShapeRadius } from './mateo-shape.js';

it('should resolve supported treatments when a component receives a shape', () => {
  expect(getMateoShapeRadius('none')).toBe(0);
  expect(getMateoShapeRadius('capsule')).toBeNull();
  expect(getMateoShapeRadius({ type: 'rounded', radius: 24 })).toBe(24);
  expect(getMateoShapeRadius({ type: 'rounded', radius: 0 })).toBe(0);
});
it.each([-1, NaN, Infinity])(
  'should reject rounded radius %s when supplied by a consumer',
  (radius) => {
    expect(() => getMateoShapeRadius({ type: 'rounded', radius })).toThrow(
      'finite, nonnegative radius',
    );
  },
);
