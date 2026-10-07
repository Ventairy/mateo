'use client';

import type { CSSProperties, Ref } from 'react';
import { BaseMateoIcon } from '../../bases/base-mateo-icon/base-mateo-icon.js';
import {
  getMateoIconArtwork,
  type MateoIconName,
} from './mateo-icon-artwork.js';

/** A catalog image. Its interactive parent owns action labels and states. */
export interface MateoIconProps {
  /**
   * Artwork name from the Mateo icon catalog.
   */
  readonly icon: MateoIconName;
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

/**
 * Renders Mateo catalog artwork as an optically sized SVG.
 *
 * @remarks
 * Inherits size and color from MateoIconProvider unless explicitly overridden.
 * Without a nonempty `aria-label`, the icon is decorative and hidden from
 * assistive technology. A named icon exposes image semantics. An interactive
 * parent owns its action name, focus, and state. An optional circular background
 * insets the artwork without changing the total size or chosen foreground.
 *
 * @throws TypeError - If the size is invalid or the icon name is unknown.
 *
 * @example
 * ```tsx
 * <MateoIcon icon="checkmark" aria-label="Complete" />
 * ```
 */
export function MateoIcon({ icon, ...props }: MateoIconProps) {
  return <BaseMateoIcon {...props} artwork={getMateoIconArtwork(icon)} />;
}
