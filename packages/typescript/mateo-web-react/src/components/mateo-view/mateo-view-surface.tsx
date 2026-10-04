'use client';

import type { CSSProperties, ReactNode } from 'react';
import { BaseMateoSurface } from '../../bases/base-mateo-surface/base-mateo-surface.js';
import type { MateoShape } from '../../foundation/mateo-shape/mateo-shape.js';
import { useMateoSurfaceBounds } from '../../foundation/use-mateo-surface-bounds.js';
import { useMateoViewContext } from './mateo-view-context.js';
import {
  type MateoViewPadding,
  mateoViewSpacing,
  resolveMateoViewPadding,
} from './mateo-view-padding.js';

/** A view-filling background with automatic scrolling and header clearance. */
export interface MateoViewSurfaceProps {
  readonly children: ReactNode;
  readonly padding?: MateoViewPadding;
  readonly color?: CSSProperties['backgroundColor'];
  readonly shape?: MateoShape;
}

export function MateoViewSurface({
  children,
  padding,
  color,
  shape = 'none',
}: MateoViewSurfaceProps) {
  const view = useMateoViewContext();
  const hasHeader = view.header != null && view.header !== false;
  const header = useMateoSurfaceBounds<HTMLDivElement>(hasHeader, undefined);
  const resolvedPadding =
    padding === undefined
      ? {
          ...view.padding,
          blockStart: hasHeader
            ? mateoViewSpacing.contentGapPx
            : view.padding.blockStart,
        }
      : resolveMateoViewPadding(padding);
  return (
    <BaseMateoSurface
      width="fill"
      height="fill"
      padding={0}
      {...(color === undefined ? {} : { color })}
      shape={shape}
      scroll={{
        clearanceBlockStart: hasHeader ? header.height : 0,
        padding: resolvedPadding,
      }}
      overlay={
        hasHeader ? (
          <div
            ref={header.ref}
            className="mateo:absolute mateo:inset-x-[0px] mateo:top-[0px] mateo:z-[1] mateo:pointer-events-none"
          >
            {view.header}
          </div>
        ) : null
      }
    >
      {children}
    </BaseMateoSurface>
  );
}
