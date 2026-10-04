import type { MateoButtonColorScheme } from './mateo-button-color-scheme.js';
import type { MateoPrimaryButtonColorScheme } from './mateo-primary-button-color-scheme.js';
import type { MateoSecondaryButtonColorScheme } from './mateo-secondary-button-color-scheme.js';

/** Immutable semantic color roles. */
export class MateoButtonsColorScheme {
  readonly primary: MateoPrimaryButtonColorScheme;
  readonly secondary: MateoSecondaryButtonColorScheme;
  readonly tertiary: MateoButtonColorScheme;

  constructor(
    colors: Pick<MateoButtonsColorScheme, 'primary' | 'secondary' | 'tertiary'>,
  ) {
    this.primary = colors.primary;
    this.secondary = colors.secondary;
    this.tertiary = colors.tertiary;
    Object.freeze(this);
  }
}
