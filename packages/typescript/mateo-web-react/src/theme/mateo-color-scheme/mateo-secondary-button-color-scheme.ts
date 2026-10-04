import type { MateoButtonColorScheme } from './mateo-button-color-scheme.js';

/** Immutable semantic color roles. */
export class MateoSecondaryButtonColorScheme {
  readonly accent: MateoButtonColorScheme;
  readonly neutral: MateoButtonColorScheme;

  constructor(
    colors: Pick<MateoSecondaryButtonColorScheme, 'accent' | 'neutral'>,
  ) {
    this.accent = colors.accent;
    this.neutral = colors.neutral;
    Object.freeze(this);
  }
}
