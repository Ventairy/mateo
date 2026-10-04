'use client';

import { type CSSProperties, type Ref, useId } from 'react';
import {
  type MateoIconName,
  renderMateoIconArtwork,
} from './mateo-icon-artwork.js';
import { useMateoIconContext } from './mateo-icon-provider.js';

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

const mateoIconGeometry = {
  frameSize: 20,
  backgroundArtworkScale: 0.65,
} as const;

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
export function MateoIcon({
  icon,
  size: explicitSize,
  color: explicitColor,
  backgroundColor,
  'aria-label': label,
  ref,
}: MateoIconProps) {
  const scope = useMateoIconContext();
  const size = explicitSize ?? scope.size ?? mateoIconGeometry.frameSize;
  const color = explicitColor ?? scope.color;
  const idPrefix = `mateo-icon-${useId()}`;
  if (typeof size !== 'number' || !Number.isFinite(size) || size < 0) {
    throw new TypeError('MateoIcon size must be finite and nonnegative.');
  }
  const artwork = renderMateoIconArtwork(icon, idPrefix);
  const named = Boolean(label?.trim());
  const background = backgroundColor !== undefined;
  const inset =
    (mateoIconGeometry.frameSize *
      (1 - mateoIconGeometry.backgroundArtworkScale)) /
    2;
  const style: CSSProperties &
    Record<`--mateo-icon-${string}`, string | undefined> = {
    '--mateo-icon-size': `${size}px`,
    ...(color === undefined ? {} : { '--mateo-icon-color': color }),
    ...(background ? { '--mateo-icon-background': backgroundColor } : {}),
  };

  return (
    <svg
      ref={ref}
      viewBox={`0 0 ${mateoIconGeometry.frameSize} ${mateoIconGeometry.frameSize}`}
      width={size}
      height={size}
      fill="none"
      focusable="false"
      role={named ? 'img' : undefined}
      aria-label={named ? label : undefined}
      aria-hidden={named ? undefined : true}
      className="mateo:inline-block mateo:shrink-0 mateo:align-middle mateo:size-(--mateo-icon-size) mateo:text-(--mateo-icon-color,currentColor)"
      style={style}
    >
      {size > 0 && (
        <>
          {background && (
            <circle
              cx={mateoIconGeometry.frameSize / 2}
              cy={mateoIconGeometry.frameSize / 2}
              r={mateoIconGeometry.frameSize / 2}
              className="mateo:fill-(--mateo-icon-background)"
            />
          )}
          <g
            transform={
              background
                ? `translate(${inset} ${inset}) scale(${mateoIconGeometry.backgroundArtworkScale})`
                : undefined
            }
          >
            {artwork}
          </g>
        </>
      )}
    </svg>
  );
}
