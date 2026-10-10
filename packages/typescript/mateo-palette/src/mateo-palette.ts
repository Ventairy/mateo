import { getMateoShadeHex, parseMateoAccent } from './mateo-color-utils.js';
import * as mateoPaletteValues from './mateo-palette-values.js';

/** A one-based step in a Mateo color scale. */
export type MateoColorStep = 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12;
/**
 * Twelve immutable CSS colors indexed by {@link MateoColorStep}.
 *
 * @remarks
 * Step 9 is the anchor. A primitive step has no universal product meaning or
 * contrast guarantee; choose semantic roles for component foregrounds and backgrounds.
 */
export type MateoColorScale = Readonly<Record<MateoColorStep, string>>;
/** Mateo's fixed primitives and customizable product accent. */
export interface MateoPalette {
  /**
   * Pure white primitive, outside the numbered scales.
   */
  readonly white: string;
  /**
   * Pure black primitive, outside the numbered scales.
   */
  readonly black: string;
  /**
   * Product accent scale. Custom seeds occupy step 9.
   */
  readonly accent: MateoColorScale;
  /**
   * Fixed achromatic neutral scale, independent of the accent seed.
   */
  readonly neutral: MateoColorScale;
  /**
   * Authored green primitive scale. Component meaning belongs in semantic color roles.
   */
  readonly green: MateoColorScale;
  /**
   * Authored amber primitive scale. Component meaning belongs in semantic color roles.
   */
  readonly amber: MateoColorScale;
  /**
   * Authored red primitive scale. Component meaning belongs in semantic color roles.
   */
  readonly red: MateoColorScale;
  /**
   * Authored blue primitive scale. Component meaning belongs in semantic color roles.
   */
  readonly blue: MateoColorScale;
  /**
   * Authored cyan primitive scale. Component meaning belongs in semantic color roles.
   */
  readonly cyan: MateoColorScale;
  /**
   * Authored violet primitive scale. Component meaning belongs in semantic color roles.
   */
  readonly violet: MateoColorScale;
  /**
   * Authored teal primitive scale. Component meaning belongs in semantic color roles.
   */
  readonly teal: MateoColorScale;
  /**
   * Authored orange primitive scale. Component meaning belongs in semantic color roles.
   */
  readonly orange: MateoColorScale;
  /**
   * Authored pink primitive scale. Component meaning belongs in semantic color roles.
   */
  readonly pink: MateoColorScale;
  /**
   * Authored yellow primitive scale. Component meaning belongs in semantic color roles.
   */
  readonly yellow: MateoColorScale;
}
/** Only the product accent can replace an authored scale. */
export interface MateoPaletteOptions {
  /**
   * Concrete, fully opaque sRGB seed for the accent scale. Accepts hex, RGB, HSL,
   * or OKLCH colors; named colors and browser-dependent expressions are unsupported.
   *
   * @defaultValue `"#4A5CFF"`
   */
  readonly accentColor?: string;
}

/**
 * Mateo’s immutable authored palette for the light appearance.
 *
 * @remarks
 * Primitive steps have no universal product meaning or contrast guarantee.
 * Use semantic roles for interface foregrounds and backgrounds.
 *
 * @example
 * ```ts
 * const zooColor = MateoDefaultPalette.green[11];
 * ```
 */
export const MateoDefaultPalette: MateoPalette =
  mateoPaletteValues.mateoPalettePrimitives;

/**
 * Creates Mateo's primitive palette with an optional product accent seed.
 *
 * @remarks
 * Uses exact authored shades by default. Custom seeds are preserved at step 9;
 * the remaining accent shades are derived from Mateo's palette rules. All other
 * scales stay unchanged. Pale, muted, and very dark seeds need visual review.
 *
 * @param options - Accent customization; omit to use the authored Mateo palette.
 * @returns An immutable palette with twelve steps in each scale.
 * @throws TypeError - If the seed is unresolved, transparent, or outside sRGB.
 *
 * @example
 * ```ts
 * const palette = createMateoPalette({ accentColor: "#00A86B" });
 * const accent = palette.accent[9];
 * ```
 */
export function createMateoPalette({
  accentColor = MateoDefaultPalette.accent[9],
}: MateoPaletteOptions = {}): MateoPalette {
  const { input, oklch } = parseMateoAccent(accentColor);
  if (input.toUpperCase() === MateoDefaultPalette.accent[9])
    return MateoDefaultPalette;
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
  return Object.freeze({ ...MateoDefaultPalette, accent });
}

export { parseMateoColor } from './mateo-color-utils.js';
