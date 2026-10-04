'use client';

import type { CSSProperties, ReactNode } from 'react';
import { useMateoSurfaceBounds } from '../../foundation/use-mateo-surface-bounds.js';
import { useMateoViewContext } from './mateo-view-context.js';
import {
  type MateoViewPadding,
  mateoViewSpacing,
  resolveMateoViewPadding,
} from './mateo-view-padding.js';

/** Directional side controls surrounding the view's principal content. */
export interface MateoViewHeaderProps {
  readonly leading?: ReactNode;
  readonly principal?: ReactNode;
  readonly trailing?: ReactNode;
  readonly padding?: MateoViewPadding;
}

export function MateoViewHeader({
  leading,
  principal,
  trailing,
  padding,
}: MateoViewHeaderProps) {
  const view = useMateoViewContext();
  const resolvedPadding =
    padding === undefined
      ? { ...view.padding, blockEnd: 0 }
      : resolveMateoViewPadding(padding);
  const hasLeading = leading != null && leading !== false;
  const hasTrailing = trailing != null && trailing !== false;
  const hasPrincipal = principal != null && principal !== false;
  const centered = hasLeading && hasTrailing;
  const start = useMateoSurfaceBounds<HTMLDivElement>(centered, undefined);
  const end = useMateoSurfaceBounds<HTMLDivElement>(centered, undefined);
  const sideWidth = Math.max(start.width, end.width);
  const style: CSSProperties = {
    paddingBlockStart: resolvedPadding.blockStart,
    paddingBlockEnd: resolvedPadding.blockEnd,
    paddingInlineStart: resolvedPadding.inlineStart,
    paddingInlineEnd: resolvedPadding.inlineEnd,
    ...{
      '--mateo-header-gap': `${mateoViewSpacing.headerSlotGapPx}px`,
      '--mateo-principal-start': `${centered ? sideWidth - start.width : 0}px`,
      '--mateo-principal-end': `${centered ? sideWidth - end.width : 0}px`,
    },
  };
  return (
    <div
      style={style}
      className="mateo:box-border mateo:flex mateo:w-full mateo:min-w-[0px] mateo:items-center mateo:justify-between mateo:gap-(--mateo-header-gap) mateo:pointer-events-none mateo:text-[16px] mateo:font-[600]"
    >
      {hasLeading && (
        <div
          ref={start.ref}
          className="mateo:shrink-0 mateo:max-w-[calc(50%-var(--mateo-header-gap))] mateo:pointer-events-auto"
        >
          {leading}
        </div>
      )}
      {hasPrincipal && (
        <div
          className={[
            'mateo:min-w-[0px] mateo:flex-1 mateo:ms-(--mateo-principal-start) mateo:me-(--mateo-principal-end) mateo:pointer-events-auto',
            centered ? 'mateo:text-center' : '',
          ]
            .filter(Boolean)
            .join(' ')}
        >
          {principal}
        </div>
      )}
      {hasTrailing && (
        <div
          ref={end.ref}
          className="mateo:shrink-0 mateo:max-w-[calc(50%-var(--mateo-header-gap))] mateo:pointer-events-auto"
        >
          {trailing}
        </div>
      )}
    </div>
  );
}
