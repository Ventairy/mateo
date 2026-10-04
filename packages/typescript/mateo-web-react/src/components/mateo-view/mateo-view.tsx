'use client';

import type { ReactNode } from 'react';
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
}

export function MateoView({ surface, header, padding }: MateoViewProps) {
  const resolvedPadding = resolveMateoViewPadding(
    padding ?? mateoViewSpacing.padding,
  );
  return (
    <MateoViewContext value={{ header, padding: resolvedPadding }}>
      <div className="mateo:box-border mateo:h-full mateo:w-full mateo:min-h-[0px] mateo:min-w-[0px]">
        {surface}
      </div>
    </MateoViewContext>
  );
}
