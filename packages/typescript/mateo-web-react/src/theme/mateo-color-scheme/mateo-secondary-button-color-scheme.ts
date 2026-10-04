import type { MateoButtonColorScheme } from './mateo-button-color-scheme.js';

/**
 * Soft button treatments for supporting actions.
 *
 * @remarks
 * Instances are immutable. Use the corresponding group in
 * `theme.colorScheme.buttons` for theme-derived colors.
 */
export class MateoSecondaryButtonColorScheme {
  /**
   * Soft product accent treatment.
   */
  readonly accent: MateoButtonColorScheme;
  /**
   * Soft achromatic treatment.
   */
  readonly neutral: MateoButtonColorScheme;

  /**
   * Creates an immutable group from the supplied color roles.
   *
   * @param colors - Complete roles for this treatment or group. Values are retained
   * as supplied; construction does not derive or validate colors.
   */
  constructor(
    colors: Pick<MateoSecondaryButtonColorScheme, 'accent' | 'neutral'>,
  ) {
    this.accent = colors.accent;
    this.neutral = colors.neutral;
    Object.freeze(this);
  }
}
