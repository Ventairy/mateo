import type { CSSProperties } from 'react';
import { mateoTypography } from '../foundation/mateo-typography/mateo-typography.js';
import { MateoColorScheme } from './mateo-color-scheme/mateo-color-scheme.js';
import {
  createMateoPalette,
  type MateoPalette,
} from './mateo-palette/mateo-palette.js';

export { MateoColorScheme } from './mateo-color-scheme/mateo-color-scheme.js';

/**
 * A complete light theme shared by Mateo components.
 *
 * @remarks
 * Create with {@link createMateoTheme}. The theme and its generated color groups
 * are immutable; supply a new theme to change the appearance.
 */
export interface MateoThemeData {
  /**
   * Supported appearance. Mateo currently provides light appearance only.
   */
  readonly appearance: 'light';
  /**
   * Primitive scales for custom compositions. Prefer semantic roles for component colors.
   */
  readonly palette: MateoPalette;
  /**
   * Semantic roles derived from the palette.
   */
  readonly colorScheme: MateoColorScheme;
}
/**
 * Product-owned accent and foreground used by {@link createMateoTheme}.
 */
export interface MateoThemeOptions {
  /**
   * Product accent seed. Accepts concrete hex, RGB, HSL, or OKLCH colors; must be
   * fully opaque and within sRGB.
   */
  readonly accentColor: string;
  /**
   * Foreground used over the accent. Accepts concrete hex, RGB, HSL, or OKLCH
   * colors; alpha is allowed.
   *
   * @remarks
   * Preserved as supplied. Choose and verify its contrast against the accent; Mateo
   * does not automatically select a foreground.
   */
  readonly onAccent: string;
}

/**
 * Creates an immutable light theme from a product accent and its foreground.
 *
 * @param options - Concrete colors to use for the product accent and text on it.
 * @returns The palette and semantic color scheme for the light appearance.
 * @throws TypeError - If either color cannot be resolved, or the accent is
 * transparent or outside sRGB. CSS variables and `currentColor` are not seeds.
 *
 * @example
 * ```ts
 * const theme = createMateoTheme({
 *   accentColor: "#4A5CFF",
 *   onAccent: "#FFFFFF",
 * });
 * ```
 */
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

/**
 * Typography and selection CSS variables for an app-owned theme element.
 *
 * @remarks
 * Apply the complete object returned by {@link getMateoThemeStyle} to an element
 * that contains your interface. Font size and weight remain content-owned.
 */
export type MateoThemeStyle = Readonly<
  Pick<CSSProperties, 'fontFamily' | 'letterSpacing'> & {
    /**
     * Font-family variable shared by Mateo typography.
     */
    '--mateo-font-family': string;
    /**
     * Letter-spacing variable shared by Mateo typography.
     */
    '--mateo-letter-spacing': string;
    /** Text-selection background inherited by all text within this element. */
    '--mateo-selection-background': string;
    /** Dark accent foreground inherited by selected text within this element. */
    '--mateo-selection-foreground': string;
  }
>;

/**
 * Returns typography and text-selection styles for an existing root or nested element.
 *
 * @remarks
 * Import `mateo-web-react/styles.css` once to load package styles and bundled Inter
 * fonts. Selected text uses a dark accent foreground over a opaque pale accent highlight.
 * Nested styled roots use their own theme; apply this object to portal roots too.
 * Forced-colors mode retains native selection colors. Typography is inherited
 * without choosing text sizes or adding a DOM wrapper.
 *
 * @param theme - Theme supplying selection colors; typography is shared by all themes.
 * @returns An immutable object suitable for a React element's `style` prop.
 *
 * @example
 * ```tsx
 * <main style={getMateoThemeStyle(theme)}>{content}</main>
 * ```
 */
export function getMateoThemeStyle(theme: MateoThemeData): MateoThemeStyle {
  return Object.freeze({
    '--mateo-selection-background': theme.colorScheme.selection.background,
    '--mateo-selection-foreground': theme.colorScheme.selection.foreground,
    '--mateo-font-family': mateoTypography.fontFamily,
    '--mateo-letter-spacing': mateoTypography.letterSpacing,
    fontFamily: mateoTypography.fontFamily,
    letterSpacing: mateoTypography.letterSpacing,
  });
}
