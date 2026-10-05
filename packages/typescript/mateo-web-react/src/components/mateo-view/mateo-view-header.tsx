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
  /**
   * Controls before the principal content in reading order. Direction is inherited.
   */
  readonly leading?: ReactNode;
  /**
   * Primary heading or content. Supply your own semantic element, such as an h1.
   * Centered within the header when both side slots are present.
   */
  readonly principal?: ReactNode;
  /**
   * Controls after the principal content in reading order.
   */
  readonly trailing?: ReactNode;
  /**
   * Local logical spacing; replaces inherited header spacing.
   *
   * @defaultValue View padding with the block-end inset removed.
   */
  readonly padding?: MateoViewPadding;
  /**
   * Maximum total width in pixels, including padding; finite and nonnegative.
   * Centers the header within the view. Cannot exceed the view's content cap
   * or available width.
   *
   * @defaultValue No local cap; follows the view’s maximum content width.
   */
  readonly maxWidth?: number;
}

/**
 * Renders directional controls around the principal content in a view header.
 *
 * @remarks
 * Requires a MateoView ancestor. The view surface holds it at the top while
 * content scrolls underneath. Side controls keep their natural widths; when both
 * are present the principal slot balances against the wider side. Content owns
 * heading semantics, accessible names, and its own interactions.
 *
 * @throws Error - If there is no MateoView ancestor.
 * @throws TypeError - If maximum width or padding is not finite and nonnegative.
 *
 * @example
 * ```tsx
 * <MateoViewHeader
 *   leading={<button type="button">Back</button>}
 *   principal={<h1>Messages</h1>}
 *   maxWidth={960}
 * />
 * ```
 */
export function MateoViewHeader({
  leading,
  principal,
  trailing,
  padding,
  maxWidth,
}: MateoViewHeaderProps) {
  const view = useMateoViewContext();
  if (maxWidth !== undefined && (!Number.isFinite(maxWidth) || maxWidth < 0)) {
    throw new TypeError(
      'MateoViewHeader maxWidth must be finite and nonnegative.',
    );
  }
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
  const resolvedMaxWidth =
    maxWidth === undefined
      ? view.maxWidth
      : Math.min(maxWidth, view.maxWidth ?? Number.POSITIVE_INFINITY);
  const style: CSSProperties = {
    paddingBlockStart: resolvedPadding.blockStart,
    paddingBlockEnd: resolvedPadding.blockEnd,
    paddingInlineStart: resolvedPadding.inlineStart,
    paddingInlineEnd: resolvedPadding.inlineEnd,
    ...{
      '--mateo-header-max-width':
        resolvedMaxWidth === undefined ? 'none' : `${resolvedMaxWidth}px`,
      '--mateo-header-gap': `${mateoViewSpacing.headerSlotGapPx}px`,
      '--mateo-principal-start': `${centered ? sideWidth - start.width : 0}px`,
      '--mateo-principal-end': `${centered ? sideWidth - end.width : 0}px`,
    },
  };
  return (
    <div
      style={style}
      className="mateo:box-border mateo:flex mateo:w-full mateo:max-w-(--mateo-header-max-width) mateo:mx-auto mateo:min-w-[0px] mateo:items-center mateo:justify-between mateo:gap-(--mateo-header-gap) mateo:pointer-events-none mateo:text-[16px] mateo:font-[600]"
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
