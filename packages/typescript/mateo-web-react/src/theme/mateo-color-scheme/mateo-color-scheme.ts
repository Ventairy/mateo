import { parseMateoColor } from '../mateo-palette/mateo-color-utils.js';
import type { MateoPalette } from '../mateo-palette/mateo-palette.js';
import type { MateoButtonsColorScheme } from './mateo-buttons-color-scheme.js';
import { createMateoLightColorSchemeRoles } from './mateo-light-color-scheme.js';

/** Immutable shared and component colors for a Mateo appearance. */
export class MateoColorScheme {
  readonly background: string;
  readonly accent: string;
  readonly onAccent: string;
  readonly buttons: MateoButtonsColorScheme;

  /** Derive the light roles, preserving the supplied concrete accent foreground. */
  static light(options: {
    readonly palette: MateoPalette;
    readonly onAccent: string;
  }): MateoColorScheme {
    const foreground = parseMateoColor(options.onAccent, 'onAccent');
    return new MateoColorScheme(
      createMateoLightColorSchemeRoles(options.palette, foreground.input),
    );
  }

  private constructor(
    colors: Pick<
      MateoColorScheme,
      'background' | 'accent' | 'onAccent' | 'buttons'
    >,
  ) {
    this.background = colors.background;
    this.accent = colors.accent;
    this.onAccent = colors.onAccent;
    this.buttons = colors.buttons;
    Object.freeze(this);
  }
}
