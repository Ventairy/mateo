import type { MateoButtonColorScheme } from './mateo-button-color-scheme.js';

/** Immutable semantic color roles. */
export class MateoPrimaryButtonColorScheme {
  readonly accent: MateoButtonColorScheme;
  readonly success: MateoButtonColorScheme;
  readonly warning: MateoButtonColorScheme;
  readonly neutral: MateoButtonColorScheme;
  readonly base: MateoButtonColorScheme;

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
