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
  /**
   * Scrollable content, placed below the header and centered within the view’s
   * maximum width, including its padding.
   */
  readonly children: ReactNode;
  /**
   * Lets content fill the viewport beneath an internally managed overlay scrollbar.
   * Native scrollbars remain available without JavaScript and in forced colors.
   *
   * @defaultValue `false`
   */
  readonly extendBehindScrollbar?: boolean;
  /**
   * Local content spacing; replaces inherited spacing but retains header clearance.
   *
   * @defaultValue View spacing, with a `20` pixel top gap below a present header.
   */
  readonly padding?: MateoViewPadding;
  /**
   * Surface background override, including CSS variables.
   *
   * @defaultValue The nearest theme's background color.
   */
  readonly color?: CSSProperties['backgroundColor'];
  /**
   * Outline shared by the background and content boundary.
   *
   * @defaultValue `"none"`
   */
  readonly shape?: MateoShape;
}

/**
 * Fills its view with a background, scrolling content, and an unmasked header.
 *
 * @remarks
 * Requires MateoView and MateoTheme ancestors. Content starts below the header
 * and adjusts when that header wraps or changes height. Explicit padding
 * can remove the gap, but never the header clearance. Native vertical scrolling
 * and viewport fades keep the stationary header visible; focused content can
 * scroll into the clear region.
 *
 * @throws Error - If a required view or theme ancestor is absent.
 * @throws TypeError - If padding or the rounded shape radius is invalid.
 *
 * @example
 * ```tsx
 * <MateoViewSurface padding={{ inlineStart: 24, inlineEnd: 24 }}>
 *   {messages}
 * </MateoViewSurface>
 * ```
 */
export function MateoViewSurface({
  children,
  padding,
  color,
  shape = 'none',
  extendBehindScrollbar = false,
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
        extendBehindScrollbar,
        clearanceBlockStart: hasHeader ? header.height : 0,
        padding: resolvedPadding,
        ...(view.maxWidth === undefined
          ? {}
          : { contentMaxWidth: view.maxWidth }),
        ...(hasHeader
          ? { header: { content: view.header, ref: header.ref } }
          : {}),
      }}
      overlay={null}
    >
      {children}
    </BaseMateoSurface>
  );
}
