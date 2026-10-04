import type { MateoButtonColorScheme } from './mateo-button-color-scheme.js';

/**
 * Filled button treatments for prominent actions.
 *
 * @remarks
 * Instances are immutable. Use the corresponding group in
 * `theme.colorScheme.buttons` for theme-derived colors.
 */
export class MateoPrimaryButtonColorScheme {
  /**
   * Product accent treatment for the main action.
   */
  readonly accent: MateoButtonColorScheme;
  /**
   * Success treatment for an action with a positive outcome.
   */
  readonly success: MateoButtonColorScheme;
  /**
   * Warning treatment for an action requiring attention.
   */
  readonly warning: MateoButtonColorScheme;
  /**
   * Strong achromatic treatment.
   */
  readonly neutral: MateoButtonColorScheme;
  /**
   * White treatment with a dark foreground.
   */
  readonly base: MateoButtonColorScheme;

  /**
   * Creates an immutable group from the supplied color roles.
   *
   * @param colors - Complete roles for this treatment or group. Values are retained
   * as supplied; construction does not derive or validate colors.
   */
  constructor(
    colors: Pick<
      MateoPrimaryButtonColorScheme,
      'accent' | 'success' | 'warning' | 'neutral' | 'base'
    >,
  ) {
    this.accent = colors.accent;
    this.success = colors.success;
    this.warning = colors.warning;
    this.neutral = colors.neutral;
    this.base = colors.base;
    Object.freeze(this);
  }
}
