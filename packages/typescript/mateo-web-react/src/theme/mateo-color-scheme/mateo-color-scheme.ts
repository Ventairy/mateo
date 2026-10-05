import { parseMateoColor } from '../mateo-palette/mateo-color-utils.js';
import type { MateoPalette } from '../mateo-palette/mateo-palette.js';
import type { MateoButtonsColorScheme } from './mateo-buttons-color-scheme.js';
import { createMateoLightColorSchemeRoles } from './mateo-light-color-scheme.js';
import type { MateoScrollbarColorScheme } from './mateo-scrollbar-color-scheme.js';
import type { MateoSelectionColorScheme } from './mateo-selection-color-scheme.js';
import type { MateoTextColorScheme } from './mateo-text-color-scheme.js';

/** Immutable shared and component colors for a Mateo appearance. */
export class MateoColorScheme {
  /**
   * Default surface background for this appearance.
   */
  readonly background: string;
  /**
   * Product accent color for emphasized interface elements.
   */
  readonly accent: string;
  /**
   * Caller-selected foreground for content on the accent.
   */
  readonly onAccent: string;
  /** Colors for native scrollbar thumbs. */
  readonly scrollbar: MateoScrollbarColorScheme;
  /** Colors for selected text. */
  readonly selection: MateoSelectionColorScheme;
  /**
   * Enabled and disabled colors grouped by button treatment.
   */
  readonly buttons: MateoButtonsColorScheme;
  /** Shared text emphasis and money colors for this appearance. */
  readonly text: MateoTextColorScheme;

  /**
   * Derives the immutable light color scheme from a primitive palette.
   *
   * @param options - Palette and concrete foreground to retain on the accent.
   * @returns Semantic roles for light surfaces, button treatments, and text.
   * @throws TypeError - If `onAccent` is not a resolvable concrete CSS color.
   *
   * @remarks
   * Accepts concrete hex, RGB, HSL, or OKLCH foregrounds; alpha is allowed.
   * Verify contrast against the supplied accent; this factory does not
   * automatically choose or correct that color.
   */
  static light(options: {
    /** Primitive palette from which light roles are derived. */
    readonly palette: MateoPalette;
    /** Concrete foreground retained for content on the accent. */
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
      | 'background'
      | 'accent'
      | 'onAccent'
      | 'selection'
      | 'scrollbar'
      | 'buttons'
      | 'text'
    >,
  ) {
    this.background = colors.background;
    this.accent = colors.accent;
    this.onAccent = colors.onAccent;
    this.selection = colors.selection;
    this.scrollbar = colors.scrollbar;
    this.buttons = colors.buttons;
    this.text = colors.text;
    Object.freeze(this);
  }
}
