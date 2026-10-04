'use client';

import type { CSSProperties, ReactNode } from 'react';
import { MateoViewContext } from './mateo-view-context.js';
import {
  type MateoViewPadding,
  mateoViewSpacing,
  resolveMateoViewPadding,
} from './mateo-view-padding.js';

/**
 * Composition and sizing for a bounded Mateo view.
 *
 * @remarks
 * The parent supplies a resolved height. The view fills that height and available
 * width unless `maxWidth` limits it. Compose a MateoViewSurface and optional
 * MateoViewHeader through the named slots.
 */
export interface MateoViewProps {
  /**
   * Main surface slot. Use MateoViewSurface, directly or through your own component,
   * to provide scrolling and header clearance.
   */
  readonly surface: ReactNode;
  /**
   * Stationary top overlay slot. Use MateoViewHeader, directly or through a wrapper.
   * Omit, or supply null or false, for a view without a header.
   */
  readonly header?: ReactNode;
  /**
   * Inherited logical spacing for the header and surface. Local padding replaces it.
   *
   * @defaultValue `12` pixels on the block axis and `20` pixels on the inline axis.
   */
  readonly padding?: MateoViewPadding;
  /**
   * Maximum total width in pixels; finite and nonnegative. Centers the complete
   * view, including its surface and header, and shrinks to fit smaller parents.
   *
   * @defaultValue No cap; the view fills its parent's width.
   */
  readonly maxWidth?: number;
}

/**
 * Composes a bounded scrolling surface with an optional stationary header.
 *
 * @remarks
 * Requires a parent with a resolved height. `maxWidth` centers and limits the
 * whole view; a header can have a smaller cap but cannot exceed the view width.
 * MateoViewSurface owns scrolling, fades, and clearance below the measured header.
 *
 * @throws TypeError - If maximum width or padding is not finite and nonnegative.
 *
 * @example
 * ```tsx
 * <MateoView
 *   maxWidth={1200}
 *   header={<MateoViewHeader maxWidth={960} principal={<h1>Messages</h1>} />}
 *   surface={<MateoViewSurface>{messages}</MateoViewSurface>}
 * />
 * ```
 */
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
