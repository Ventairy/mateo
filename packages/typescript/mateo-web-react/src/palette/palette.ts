import { parseAccent, shadeToHex } from './color-utils.js';
import * as values from './values.js';

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

const defaultPalette: MateoPalette = Object.freeze({
  white: values.white,
  black: values.black,
  accent: values.accent,
  neutral: values.neutral,
  green: values.green,
  amber: values.amber,
  red: values.red,
  blue: values.blue,
  cyan: values.cyan,
  violet: values.violet,
  teal: values.teal,
  orange: values.orange,
  pink: values.pink,
  yellow: values.yellow,
});

/**
 * Create Mateo's palette with an optional opaque sRGB accent.
 * Uses exact authored shades by default. Custom seeds are preserved at step 9;
 * pale, muted, and very dark seeds need visual review.
 */
export function createMateoPalette({
  accentColor = values.accent[9],
}: MateoPaletteOptions = {}): MateoPalette {
  const { input, oklch } = parseAccent(accentColor);
  if (input.toUpperCase() === values.accent[9]) return defaultPalette;
  const shades = values.accentRules.map((rule, index) => {
    if (index === 8) return input;
    const l =
      index < 8
        ? oklch.l + (1 - oklch.l) * rule.lightness
        : values.accentLightnessFloor +
          (oklch.l - values.accentLightnessFloor) * rule.lightness;
    return shadeToHex(l, oklch.c * rule.chroma, oklch.h ?? 0);
  });
  // Every key is generated from the twelve validated foundation rules.
  const accent = Object.freeze(
    Object.fromEntries(shades.map((color, index) => [index + 1, color])),
  ) as MateoColorScale;
  return Object.freeze({ ...defaultPalette, accent });
}
