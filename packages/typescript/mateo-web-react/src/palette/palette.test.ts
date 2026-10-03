// @vitest-environment node

import { readFileSync } from 'node:fs';
import { describe, expect, it } from 'vitest';
import { parseAccent, shadeToHex } from './color-utils.js';
import { createMateoPalette } from './palette.js';
import { accentLightnessFloor, accentRules, scaleNames } from './values.js';

const foundation = readFileSync(
  new URL(
    '../../../../../design-system/foundation/color-palette.md',
    import.meta.url,
  ),
  'utf8',
);
const flutter = JSON.parse(
  readFileSync(
    new URL(
      '../../../../dart/mateo-mobile-flutter/test/theme/fixtures/palette.json',
      import.meta.url,
    ),
    'utf8',
  ),
) as Record<string, number[]>;

describe('palette', () => {
  it('keeps handwritten accent coefficients aligned with the foundation', () => {
    const rows = [
      ...foundation.matchAll(
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
    expect(accentRules).toEqual(expected);
    expect(accentLightnessFloor).toBe(Number(rows[11]?.[2]));
  });

  it('matches every authored shade and the Flutter snapshot', () => {
    const palette = createMateoPalette();
    const sections = foundation.split(/^## /m).slice(1);
    for (const [index, name] of scaleNames.entries()) {
      const section =
        sections.find((text) => text.startsWith(`${index + 1}. `)) ?? '';
      const colors = [
        ...section.matchAll(/^\|\s*(\d+)\s*\|\s*\*?\*?`(#[\dA-F]{6})`/gm),
      ].map((match) => match[2]);
      expect(Object.values(palette[name]), name).toEqual(colors);
      expect(
        Object.values(palette[name]).map((color) =>
          Number.parseInt(`FF${color.slice(1)}`, 16),
        ),
        name,
      ).toEqual(flutter[name]);
    }
    expect(palette.white).toBe('#FFFFFF');
    expect(palette.black).toBe('#000000');
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
  ])('preserves %s and leaves fixed primitives unchanged', (accentColor) => {
    const palette = createMateoPalette({ accentColor });
    const original = createMateoPalette();
    expect(palette.accent[9]).toBe(accentColor);
    expect(Object.keys(palette.accent)).toHaveLength(12);
    for (const name of scaleNames.filter((name) => name !== 'accent')) {
      expect(palette[name]).toBe(original[name]);
    }
    expect(palette.white).toBe(original.white);
    expect(palette.black).toBe(original.black);
    for (const color of Object.values(palette.accent))
      expect(() => parseAccent(color)).not.toThrow();
  });

  it('keeps vivid shades in light-to-dark order', () => {
    const shades = Object.values(
      createMateoPalette({ accentColor: '#00A86B' }).accent,
    );
    const lightness = shades.map((shade) => parseAccent(shade).oklch.l);
    for (let index = 1; index < lightness.length; index++) {
      expect(lightness[index]).toBeLessThan(lightness[index - 1] ?? 0);
    }
  });

  it('reduces chroma while keeping lightness and hue for an out-of-gamut shade', () => {
    const mapped = parseAccent(shadeToHex(0.7, 0.4, 150)).oklch;
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
    'rejects invalid, unresolved, translucent, or out-of-gamut seed %s',
    (accentColor) => {
      expect(() => createMateoPalette({ accentColor })).toThrow(TypeError);
    },
  );

  it('freezes scales and palette, and has no out-of-range entries', () => {
    const palette = createMateoPalette({ accentColor: '#00A86B' });
    expect(Object.isFrozen(palette)).toBe(true);
    for (const name of scaleNames) {
      expect(Object.isFrozen(palette[name])).toBe(true);
      expect(Reflect.set(palette[name], '1', '#000000')).toBe(false);
      expect(Reflect.get(palette[name], '0')).toBeUndefined();
      expect(Reflect.get(palette[name], '13')).toBeUndefined();
    }
  });
});
