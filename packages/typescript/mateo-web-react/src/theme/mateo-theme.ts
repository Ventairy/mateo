import type { CSSProperties } from 'react';
import { mateoTypography } from '../foundation/mateo-typography/mateo-typography.js';
import { MateoColorScheme } from './mateo-color-scheme/mateo-color-scheme.js';
import {
  createMateoPalette,
  type MateoPalette,
} from './mateo-palette/mateo-palette.js';

export { MateoColorScheme } from './mateo-color-scheme/mateo-color-scheme.js';

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
  return Object.freeze({
    appearance: 'light',
    palette,
    colorScheme: MateoColorScheme.light({
      palette,
      onAccent: options.onAccent,
    }),
  });
}

/** Inherited typography for an app-owned theme boundary. */
export type MateoThemeStyle = Readonly<
  Pick<CSSProperties, 'fontFamily' | 'letterSpacing'> & {
    '--mateo-font-family': string;
    '--mateo-letter-spacing': string;
  }
>;

/** Apply inherited typography to your existing root or nested element. */
export function getMateoThemeStyle(_theme: MateoThemeData): MateoThemeStyle {
  return Object.freeze({
    '--mateo-font-family': mateoTypography.fontFamily,
    '--mateo-letter-spacing': mateoTypography.letterSpacing,
    fontFamily: mateoTypography.fontFamily,
    letterSpacing: mateoTypography.letterSpacing,
  });
}
