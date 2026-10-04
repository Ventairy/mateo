/**
 * Immutable shared text emphasis and money colors for a Mateo appearance.
 *
 * @remarks
 * Obtain this group from `theme.colorScheme.text` to use the current appearance.
 * These roles choose color only; typography remains with the component.
 */
export class MateoTextColorScheme {
  /** Highest-emphasis text color. */
  readonly primary: string;
  /** Supporting text color. */
  readonly secondary: string;
  /** Low-emphasis text color; unsuitable for normal body text on white. */
  readonly tertiary: string;
  /** Money or profit accent; unsuitable for normal body text on white. */
  readonly profit: string;

  /**
   * Creates an immutable group from all four supplied text colors.
   *
   * @param colors - Complete text roles to preserve unchanged.
   * @remarks
   * This constructor does not validate CSS colors or verify contrast.
   * Use `MateoColorScheme.light` to derive Mateo's light roles.
   */
  constructor(
    colors: Pick<
      MateoTextColorScheme,
      'primary' | 'secondary' | 'tertiary' | 'profit'
    >,
  ) {
    this.primary = colors.primary;
    this.secondary = colors.secondary;
    this.tertiary = colors.tertiary;
    this.profit = colors.profit;
    Object.freeze(this);
  }
}
