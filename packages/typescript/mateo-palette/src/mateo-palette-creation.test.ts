// @vitest-environment node

import { readFileSync } from 'node:fs';
import { describe, expect, it } from 'vitest';
import { getMateoShadeHex, parseMateoAccent } from './mateo-color-utils.js';
import { createMateoPalette, MateoDefaultPalette } from './mateo-palette.js';
import * as mateoPaletteValues from './mateo-palette-values.js';

const mateoPaletteFoundation = readFileSync(
  new URL(
    '../../../../design-system/foundation/color-palette.md',
    import.meta.url,
  ),
  'utf8',
);
describe('palette', () => {
  it('should match the foundation when using handwritten accent coefficients', () => {
    const rows = [
      ...mateoPaletteFoundation.matchAll(
        /^\|\s*(\d+)\s*\|\s*`(L9[^`]*|0\.21[^`]*)`\s*\|\s*`(C9[^`]*)`/gm,
      ),
    ];
    expect(rows).toHaveLength(12);
    const expected = rows.map((row) => ({
      lightness:
        Number(row[1]) === 9
          ? 1
          : Number(row[2]?.match(/× ([\d.]+)/)?.[1] ?? 0),
      chroma:
        Number(row[1]) === 9 ? 1 : Number(row[3]?.match(/× ([\d.]+)/)?.[1]),
    }));
    expect(mateoPaletteValues.accentRules).toEqual(expected);
    expect(mateoPaletteValues.accentLightnessFloor).toBe(Number(rows[11]?.[2]));
  });

  it('should use shared authored primitives when creating the default palette', () => {
    const palette = createMateoPalette();
    expect(palette).toBe(MateoDefaultPalette);
    expect(createMateoPalette({ accentColor: '#4a5cff' })).toBe(palette);
  });

  it.each([
    '#00A86B',
    '#0a6',
    '#00A86BFF',
    'rgb(0 168 107)',
    'rgba(0, 168, 107, 1)',
    'hsl(158 100% 33%)',
    'hsla(158, 100%, 33%, 1)',
    'oklch(65% 0.1 150)',
    '#000000',
    '#FFFFFF',
    '#FFB8D1',
    '#24163D',
  ])(
    'should preserve %s and fixed primitives when customizing the accent',
    (accentColor) => {
      const palette = createMateoPalette({ accentColor });
      const original = createMateoPalette();
      expect(palette.accent[9]).toBe(accentColor);
      expect(Object.keys(palette.accent)).toHaveLength(12);
      for (const name of mateoPaletteValues.scaleNames.filter(
        (name) => name !== 'accent',
      )) {
        expect(palette[name]).toBe(original[name]);
      }
      expect(palette.white).toBe(original.white);
      expect(palette.black).toBe(original.black);
      for (const color of Object.values(palette.accent))
        expect(() => parseMateoAccent(color)).not.toThrow();
    },
  );

  it('should keep shades in light-to-dark order when using a vivid accent', () => {
    const shades = Object.values(
      createMateoPalette({ accentColor: '#00A86B' }).accent,
    );
    const lightness = shades.map((shade) => parseMateoAccent(shade).oklch.l);
    for (let index = 1; index < lightness.length; index++) {
      expect(lightness[index]).toBeLessThan(lightness[index - 1] ?? 0);
    }
  });

  it('should preserve lightness and hue when mapping an out-of-gamut shade', () => {
    const mapped = parseMateoAccent(getMateoShadeHex(0.7, 0.4, 150)).oklch;
    expect(mapped.l).toBeCloseTo(0.7, 2);
    expect(mapped.h).toBeCloseTo(150, 0);
    expect(mapped.c).toBeLessThan(0.4);
  });

  it.each([
    '',
    'red',
    'currentColor',
    'var(--brand)',
    'rgb(from red r g b)',
    'rgb(none 0 0)',
    'oklch(70% none 90)',
    '#nope',
    '#1234',
    '#00000000',
    'rgba(0, 168, 107, 0.5)',
    'hsl(158 100% 33% / 50%)',
    'oklch(65% 0.1 150 / .5)',
    'oklch(70% 0.4 150)',
    'rgb(999 0 0)',
    'rgb(1e999 0 0)',
  ])(
    'should reject %s when the seed is invalid, unresolved, translucent, or out of gamut',
    (accentColor) => {
      expect(() => createMateoPalette({ accentColor })).toThrow(TypeError);
    },
  );

  it('should freeze valid scales when creating a custom palette', () => {
    const palette = createMateoPalette({ accentColor: '#00A86B' });
    expect(Object.isFrozen(palette)).toBe(true);
    for (const name of mateoPaletteValues.scaleNames) {
      expect(Object.isFrozen(palette[name])).toBe(true);
      expect(Reflect.set(palette[name], '1', '#000000')).toBe(false);
      expect(Reflect.get(palette[name], '0')).toBeUndefined();
      expect(Reflect.get(palette[name], '13')).toBeUndefined();
    }
  });
});
