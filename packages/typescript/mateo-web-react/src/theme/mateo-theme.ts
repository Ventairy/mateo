import type { CSSProperties } from 'react';
import { mateoTypography } from '../foundation/mateo-typography/mateo-typography.js';
import { parseMateoColor } from './mateo-palette/mateo-color-utils.js';
import {
  createMateoPalette,
  type MateoPalette,
} from './mateo-palette/mateo-palette.js';
import * as mateoPaletteValues from './mateo-palette/mateo-palette-values.js';

/** Shared color roles for the current Mateo appearance. */
export interface MateoColorScheme {
  readonly background: string;
  readonly accent: string;
  readonly onAccent: string;
}
/** One consistent appearance, primitive palette, and derived color scheme. */
export interface MateoThemeData {
  readonly appearance: 'light';
  readonly palette: MateoPalette;
  readonly colorScheme: MateoColorScheme;
}
/** Choose the product accent and its foreground together. */
export interface MateoThemeOptions {
  readonly accentColor: string;
  readonly onAccent: string;
}

/** Create the light appearance, preserving the supplied accent foreground. */
export function createMateoTheme(options: MateoThemeOptions): MateoThemeData {
  if (typeof options?.accentColor !== 'string') {
    throw new TypeError('createMateoTheme requires accentColor and onAccent.');
  }
  const palette = createMateoPalette({ accentColor: options.accentColor });
  const foreground = parseMateoColor(options.onAccent, 'onAccent');
  return Object.freeze({
    appearance: 'light',
    palette,
    colorScheme: Object.freeze({
      background: palette.white,
      accent: palette.accent[9],
      onAccent: foreground.input,
    }),
  });
}

/** Inherited text defaults and CSS variables for an app-owned theme boundary. */
export type MateoThemeStyle = CSSProperties & {
  readonly [name: `--mateo-${string}`]: string;
};

/** Apply palette, roles, and inherited typography to your existing root or nested element. */
export function getMateoThemeStyle(theme: MateoThemeData): MateoThemeStyle {
  const style: Record<`--mateo-${string}`, string> = {
    '--mateo-palette-white': theme.palette.white,
    '--mateo-palette-black': theme.palette.black,
  };
  for (const name of mateoPaletteValues.scaleNames) {
    for (const [step, color] of Object.entries(theme.palette[name])) {
      style[`--mateo-palette-${name}-${step}`] = color;
    }
  }
  style['--mateo-color-background'] = theme.colorScheme.background;
  style['--mateo-color-accent'] = theme.colorScheme.accent;
  style['--mateo-color-on-accent'] = theme.colorScheme.onAccent;
  style['--mateo-font-family'] = mateoTypography.fontFamily;
  style['--mateo-letter-spacing'] = mateoTypography.letterSpacing;
  return Object.freeze({
    ...style,
    fontFamily: mateoTypography.fontFamily,
    letterSpacing: mateoTypography.letterSpacing,
  });
}
