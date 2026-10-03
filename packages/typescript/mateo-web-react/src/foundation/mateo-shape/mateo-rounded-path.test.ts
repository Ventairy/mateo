// @vitest-environment node
import { readFileSync } from 'node:fs';
import { describe, expect, it } from 'vitest';
import { getMateoRoundedPath } from './mateo-rounded-path.js';

interface MateoRoundedReferenceElement {
  kind: 'M' | 'L' | 'C' | 'A' | 'Z';
  points?: readonly (readonly [number, number])[];
  radius?: number;
}
const mateoRoundedReference: {
  cases: {
    width: number;
    height: number;
    requestedRadius: number;
    origin: readonly [number, number];
    elements: MateoRoundedReferenceElement[];
  }[];
} = JSON.parse(
  readFileSync(
    new URL(
      '../../../../../../design-system/foundation/assets/rounded-shape/reference.json',
      import.meta.url,
    ),
    'utf8',
  ),
);

function getMateoPathTokens(path: string) {
  return path.split(/\s+/);
}

describe('canonical rounded outlines', () => {
  for (const fixture of mateoRoundedReference.cases) {
    it(`should match the reference outline when bounds are ${fixture.width} × ${fixture.height}, radius is ${fixture.requestedRadius}, and origin is ${fixture.origin.join(', ')}`, () => {
      const expected = fixture.elements
        .map((element) => {
          const points =
            element.points
              ?.map(
                ([x, y]) => `${x - fixture.origin[0]} ${y - fixture.origin[1]}`,
              )
              .join(' ') ?? '';
          return element.kind === 'A'
            ? `A ${element.radius} ${element.radius} 0 0 1 ${points}`
            : `${element.kind}${points ? ` ${points}` : ''}`;
        })
        .join(' ');
      const actual = getMateoPathTokens(
        getMateoRoundedPath(
          fixture.width,
          fixture.height,
          fixture.requestedRadius,
        ),
      );
      const wanted = getMateoPathTokens(expected);
      expect(actual).toHaveLength(wanted.length);
      for (const [index, token] of wanted.entries()) {
        if (/^[A-Z]$/.test(token)) expect(actual[index]).toBe(token);
        else expect(Number(actual[index])).toBeCloseTo(Number(token), 10);
      }
    });
  }
});

it('should fit capsule rounding to the shorter side when bounds change orientation', () => {
  expect(getMateoRoundedPath(300, 50, null)).toBe(
    getMateoRoundedPath(300, 50, 25),
  );
  expect(getMateoRoundedPath(50, 300, null)).toBe(
    getMateoRoundedPath(50, 300, 25),
  );
});

it.each([0, -1, NaN, Infinity])(
  'should return an empty outline when a dimension is %s',
  (resolveMateoSurfaceDimension) => {
    expect(getMateoRoundedPath(resolveMateoSurfaceDimension, 50, 24)).toBe('');
    expect(getMateoRoundedPath(50, resolveMateoSurfaceDimension, 24)).toBe('');
  },
);

it.each([-1, NaN, Infinity])(
  'should reject radius %s even when bounds are empty',
  (radius) => {
    expect(() => getMateoRoundedPath(0, 0, radius)).toThrow(
      'radius must be finite and nonnegative',
    );
  },
);
