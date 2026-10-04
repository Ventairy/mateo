'use client';

import type { CSSProperties, ReactNode } from 'react';
import { MateoViewContext } from './mateo-view-context.js';
import {
  type MateoViewPadding,
  mateoViewSpacing,
  resolveMateoViewPadding,
} from './mateo-view-padding.js';

/** A parent-sized view with a stationary header and a scrolling content surface. */
export interface MateoViewProps {
  readonly surface: ReactNode;
  readonly header?: ReactNode;
  readonly padding?: MateoViewPadding;
  /** Maximum total width in pixels. Centers the view and bounds its surface and header. */
  readonly maxWidth?: number;
}

export function MateoView({
  surface,
  header,
  padding,
  maxWidth,
}: MateoViewProps) {
  if (maxWidth !== undefined && (!Number.isFinite(maxWidth) || maxWidth < 0)) {
    throw new TypeError('MateoView maxWidth must be finite and nonnegative.');
  }
  const resolvedPadding = resolveMateoViewPadding(
    padding ?? mateoViewSpacing.padding,
  );
  const style: CSSProperties & { readonly '--mateo-view-max-width': string } = {
    '--mateo-view-max-width': maxWidth === undefined ? 'none' : `${maxWidth}px`,
  };
  return (
    <MateoViewContext value={{ header, padding: resolvedPadding }}>
      <div
        style={style}
        className="mateo:box-border mateo:h-full mateo:w-full mateo:max-w-(--mateo-view-max-width) mateo:mx-auto mateo:min-h-[0px] mateo:min-w-[0px]"
      >
        {surface}
      </div>
    </MateoViewContext>
  );
}
