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
   * Semantic background, accent, and button roles derived from the palette.
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
 * Typography declarations and CSS variables for an app-owned theme element.
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
  }
>;

/**
 * Returns typography styles to apply to an existing root or nested element.
 *
 * @remarks
 * Import `mateo-web-react/styles.css` once to load package styles and bundled Inter
 * fonts. {@link MateoThemeData} carries colors; this object applies shared
 * typography without choosing text sizes or adding a DOM wrapper.
 *
 * @param _theme - The theme used by the surrounding interface. Typography is
 * currently shared by all themes.
 * @returns An immutable object suitable for a React element's `style` prop.
 *
 * @example
 * ```tsx
 * <main style={getMateoThemeStyle(theme)}>{content}</main>
 * ```
 */
export function getMateoThemeStyle(_theme: MateoThemeData): MateoThemeStyle {
  return Object.freeze({
    '--mateo-font-family': mateoTypography.fontFamily,
    '--mateo-letter-spacing': mateoTypography.letterSpacing,
    fontFamily: mateoTypography.fontFamily,
    letterSpacing: mateoTypography.letterSpacing,
  });
}
