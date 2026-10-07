'use client';

import { type ComponentType, type CSSProperties, useId } from 'react';
import type { MateoIconProps } from '../../components/mateo-icon/mateo-icon.js';
import { useMateoIconContext } from '../../components/mateo-icon/mateo-icon-provider.js';

interface BaseMateoIconProps extends Omit<MateoIconProps, 'icon'> {
  readonly artwork: ComponentType<{ readonly idPrefix: string }>;
}

const mateoIconGeometry = {
  frameSize: 20,
  backgroundArtworkScale: 0.65,
} as const;

export function BaseMateoIcon({
  artwork: Artwork,
  size: explicitSize,
  color: explicitColor,
  backgroundColor,
  'aria-label': label,
  ref,
}: BaseMateoIconProps) {
  const scope = useMateoIconContext();
  const size = explicitSize ?? scope.size ?? mateoIconGeometry.frameSize;
  const color = explicitColor ?? scope.color;
  const idPrefix = `mateo-icon-${useId()}`;
  if (typeof size !== 'number' || !Number.isFinite(size) || size < 0) {
    throw new TypeError('MateoIcon size must be finite and nonnegative.');
  }
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
            <Artwork idPrefix={idPrefix} />
          </g>
        </>
      )}
    </svg>
  );
}
