/**
 * Shared font family and letter spacing for Mateo text.
 *
 * @remarks
 * Use `getMateoThemeStyle` on your app-owned root to inherit these defaults.
 * Import `mateo-web-react/styles.css` once to load bundled Inter fonts. Components
 * and content own their font sizes, weights, and line heights; there is no global
 * type scale.
 */
export const mateoTypography = Object.freeze({
  /**
   * Inter with a sans-serif fallback.
   */
  fontFamily: 'Inter, sans-serif',
  /**
   * Fixed web letter spacing applied to inherited text.
   */
  letterSpacing: '-0.2px',
});
