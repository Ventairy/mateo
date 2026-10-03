import { getMateoShadeHex, parseMateoAccent } from './mateo-color-utils.js';
import * as mateoPaletteValues from './mateo-palette-values.js';

/** A one-based step in a Mateo color scale. */
export type MateoColorStep = 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12;
/** Twelve immutable CSS colors, with the anchor at step 9. */
export type MateoColorScale = Readonly<Record<MateoColorStep, string>>;
/** Mateo's fixed primitives and customizable product accent. */
export interface MateoPalette {
  readonly white: string;
  readonly black: string;
  readonly accent: MateoColorScale;
  readonly neutral: MateoColorScale;
  readonly green: MateoColorScale;
  readonly amber: MateoColorScale;
  readonly red: MateoColorScale;
  readonly blue: MateoColorScale;
  readonly cyan: MateoColorScale;
  readonly violet: MateoColorScale;
  readonly teal: MateoColorScale;
  readonly orange: MateoColorScale;
  readonly pink: MateoColorScale;
  readonly yellow: MateoColorScale;
}
/** Only the product accent can replace an authored scale. */
export interface MateoPaletteOptions {
  readonly accentColor?: string;
}

const defaultMateoPalette: MateoPalette = Object.freeze({
  white: mateoPaletteValues.white,
  black: mateoPaletteValues.black,
  accent: mateoPaletteValues.accent,
  neutral: mateoPaletteValues.neutral,
  green: mateoPaletteValues.green,
  amber: mateoPaletteValues.amber,
  red: mateoPaletteValues.red,
  blue: mateoPaletteValues.blue,
  cyan: mateoPaletteValues.cyan,
  violet: mateoPaletteValues.violet,
  teal: mateoPaletteValues.teal,
  orange: mateoPaletteValues.orange,
  pink: mateoPaletteValues.pink,
  yellow: mateoPaletteValues.yellow,
});

/**
 * Create Mateo's palette with an optional opaque sRGB accent.
 * Uses exact authored shades by default. Custom seeds are preserved at step 9;
 * pale, muted, and very dark seeds need visual review.
 */
export function createMateoPalette({
  accentColor = mateoPaletteValues.accent[9],
}: MateoPaletteOptions = {}): MateoPalette {
  const { input, oklch } = parseMateoAccent(accentColor);
  if (input.toUpperCase() === mateoPaletteValues.accent[9])
    return defaultMateoPalette;
  const shades = mateoPaletteValues.accentRules.map((rule, index) => {
    if (index === 8) return input;
    const l =
      index < 8
        ? oklch.l + (1 - oklch.l) * rule.lightness
        : mateoPaletteValues.accentLightnessFloor +
          (oklch.l - mateoPaletteValues.accentLightnessFloor) * rule.lightness;
    return getMateoShadeHex(l, oklch.c * rule.chroma, oklch.h ?? 0);
  });
  // Every key is generated from the twelve validated foundation rules.
  const accent = Object.freeze(
    Object.fromEntries(shades.map((color, index) => [index + 1, color])),
  ) as MateoColorScale;
  return Object.freeze({ ...defaultMateoPalette, accent });
}
