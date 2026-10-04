import type { CSSProperties, ReactNode } from 'react';
import { useLayoutEffect, useRef } from 'react';
import {
  getMateoBoundaryDepth,
  getMateoBoundaryMask,
} from './mateo-surface-boundary.js';

export interface BaseMateoSurfaceScrollOptions {
  readonly clearanceBlockStart: number;
  readonly padding: Readonly<{
    blockStart: number;
    blockEnd: number;
    inlineStart: number;
    inlineEnd: number;
  }>;
}

/** Scroll mechanics are internal; the owning component chooses content spacing. */
export function BaseMateoSurfaceScroll({
  children,
  options,
}: {
  readonly children: ReactNode;
  readonly options: BaseMateoSurfaceScrollOptions;
}) {
  const viewport = useRef<HTMLDivElement>(null);
  const content = useRef<HTMLDivElement>(null);
  const { clearanceBlockStart, padding } = options;
  useLayoutEffect(() => {
    const node = viewport.current;
    const body = content.current;
    if (!node || !body) return;
    const updateMateoScrollBoundary = () => {
      const height = node.clientHeight;
      const maximum = Math.max(0, node.scrollHeight - height);
      const position = Math.max(0, Math.min(maximum, node.scrollTop));
      const depths = getMateoBoundaryDepth(
        height,
        position,
        maximum - position,
        clearanceBlockStart,
        padding.blockStart,
      );
      // Anchor the mask to the viewport, not to the moving content. Masking
      // content alone leaves native scrollbars and the fixed header untouched,
      // and reveals the true background even when the surface is translucent.
      body.style.setProperty(
        '--mateo-boundary-mask',
        getMateoBoundaryMask(height, depths.top, depths.bottom),
      );
      body.style.setProperty('--mateo-scroll-position', `${position}px`);
      body.style.setProperty('--mateo-viewport-height', `${height}px`);
      node.style.scrollPaddingBlockStart = `${depths.clearTop}px`;
      node.style.scrollPaddingBlockEnd = `${depths.clearBottom}px`;
    };
    updateMateoScrollBoundary();
    const observer = new ResizeObserver(updateMateoScrollBoundary);
    observer.observe(node);
    observer.observe(body);
    node.addEventListener('scroll', updateMateoScrollBoundary, {
      passive: true,
    });
    const revealMateoFocusedContent = (event: FocusEvent) => {
      if (!(event.target instanceof HTMLElement) || event.target === node)
        return;
      const target = event.target.getBoundingClientRect();
      const bounds = node.getBoundingClientRect();
      const top =
        bounds.top + Number.parseFloat(node.style.scrollPaddingBlockStart);
      const bottom =
        bounds.bottom - Number.parseFloat(node.style.scrollPaddingBlockEnd);
      if (target.top < top) node.scrollTop += target.top - top;
      else if (target.bottom > bottom) node.scrollTop += target.bottom - bottom;
      updateMateoScrollBoundary();
    };
    node.addEventListener('focusin', revealMateoFocusedContent);
    return () => {
      observer.disconnect();
      node.removeEventListener('scroll', updateMateoScrollBoundary);
      node.removeEventListener('focusin', revealMateoFocusedContent);
    };
  }, [clearanceBlockStart, padding.blockStart]);

  const style: CSSProperties = {
    paddingBlockStart: clearanceBlockStart + padding.blockStart,
    paddingBlockEnd: padding.blockEnd,
    paddingInlineStart: padding.inlineStart,
    paddingInlineEnd: padding.inlineEnd,
  };
  return (
    <div
      ref={viewport}
      // biome-ignore lint/a11y/noNoninteractiveTabindex: A native scroll viewport must be reachable for keyboard scrolling.
      tabIndex={0}
      className="mateo:box-border mateo:h-full mateo:w-full mateo:min-h-[0px] mateo:min-w-[0px] mateo:overflow-y-auto mateo:overflow-x-hidden"
    >
      <div
        ref={content}
        style={style}
        className="mateo:box-border mateo:flex mateo:flex-col mateo:min-h-full mateo:min-w-[0px] mateo:[overflow-wrap:anywhere] mateo:[mask-image:var(--mateo-boundary-mask)] mateo:[mask-size:100%_var(--mateo-viewport-height)] mateo:[mask-position:0_var(--mateo-scroll-position)] mateo:[mask-repeat:no-repeat]"
      >
        {children}
      </div>
    </div>
  );
}
