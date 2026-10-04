/**
 * Colors for one button treatment in enabled and disabled states.
 *
 * @remarks
 * Instances are immutable. Use the corresponding group in
 * `theme.colorScheme.buttons` for theme-derived colors.
 */
export class MateoButtonColorScheme {
  /**
   * Surface color when the action is enabled.
   */
  readonly background: string;
  /**
   * Label and icon color when the action is enabled.
   */
  readonly foreground: string;
  /**
   * Surface color when the action is disabled.
   */
  readonly backgroundDisabled: string;
  /**
   * Label and icon color when the action is disabled.
   */
  readonly foregroundDisabled: string;

  /**
   * Creates an immutable group from the supplied color roles.
   *
   * @param colors - Complete roles for this treatment or group. Values are retained
   * as supplied; construction does not derive or validate colors.
   */
  constructor(
    colors: Pick<
      MateoButtonColorScheme,
      'background' | 'foreground' | 'backgroundDisabled' | 'foregroundDisabled'
    >,
  ) {
    this.background = colors.background;
    this.foreground = colors.foreground;
    this.backgroundDisabled = colors.backgroundDisabled;
    this.foregroundDisabled = colors.foregroundDisabled;
    Object.freeze(this);
  }
}
