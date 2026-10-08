import type { CSSProperties, Ref } from 'react';

/**
 * Controls the appearance and accessible name of an individually imported icon.
 *
 * @remarks
 * Import icons from `mateo-web-react/icons` so bundlers can omit unused artwork.
 * Icons inherit size and color from MateoIconProvider unless explicitly overridden.
 * Without a nonempty `aria-label`, artwork is decorative and hidden from assistive
 * technology. The interactive parent owns its action name, focus, and state.
 * A circular background insets the artwork without changing the total size.
 */
export interface MateoNamedIconProps {
  /**
   * Total square size in pixels, including an optional background. Must be finite
   * and nonnegative. Overrides the nearest icon provider.
   *
   * @defaultValue Provider size, or `20` when no size is inherited.
   */
  readonly size?: number;
  /**
   * Foreground override; otherwise uses provider color, then surrounding text color.
   */
  readonly color?: CSSProperties['color'];
  /** Circular background; preserves the chosen or inherited foreground. */
  readonly backgroundColor?: CSSProperties['backgroundColor'];
  /** Localized image name. Omit for decorative icons or icons beside a label. */
  readonly 'aria-label'?: string;
  /**
   * Ref to the root SVG element; the icon itself is not focusable.
   */
  readonly ref?: Ref<SVGSVGElement>;
}
