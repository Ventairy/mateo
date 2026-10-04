import type { MateoButtonColorScheme } from './mateo-button-color-scheme.js';
import type { MateoPrimaryButtonColorScheme } from './mateo-primary-button-color-scheme.js';
import type { MateoSecondaryButtonColorScheme } from './mateo-secondary-button-color-scheme.js';

/**
 * Grouped colors for button treatments.
 *
 * @remarks
 * Instances are immutable. Use the corresponding group in
 * `theme.colorScheme.buttons` for theme-derived colors.
 */
export class MateoButtonsColorScheme {
  /**
   * Filled treatments for prominent actions.
   */
  readonly primary: MateoPrimaryButtonColorScheme;
  /**
   * Soft treatments for supporting actions.
   */
  readonly secondary: MateoSecondaryButtonColorScheme;
  /**
   * Transparent treatment for low-emphasis actions.
   */
  readonly tertiary: MateoButtonColorScheme;

  /**
   * Creates an immutable group from the supplied color roles.
   *
   * @param colors - Complete roles for this treatment or group. Values are retained
   * as supplied; construction does not derive or validate colors.
   */
  constructor(
    colors: Pick<MateoButtonsColorScheme, 'primary' | 'secondary' | 'tertiary'>,
  ) {
    this.primary = colors.primary;
    this.secondary = colors.secondary;
    this.tertiary = colors.tertiary;
    Object.freeze(this);
  }
}
