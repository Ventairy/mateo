import type { CSSProperties, ReactNode, Ref } from 'react';
import { useLayoutEffect, useRef } from 'react';
import {
  getMateoBoundaryDepth,
  getMateoBoundaryMask,
} from './mateo-surface-boundary.js';

export interface BaseMateoSurfaceScrollOptions {
  readonly clearanceBlockStart: number;
  readonly header?: Readonly<{ content: ReactNode; ref: Ref<HTMLDivElement> }>;
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
  const { clearanceBlockStart, header, padding } = options;
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
      body.style.setProperty(
        '--mateo-mask-offset',
        `${position - clearanceBlockStart}px`,
      );
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
      if (
        !(event.target instanceof HTMLElement) ||
        !body.contains(event.target)
      )
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
    paddingBlockStart: padding.blockStart,
    paddingBlockEnd: padding.blockEnd,
    paddingInlineStart: padding.inlineStart,
    paddingInlineEnd: padding.inlineEnd,
  };
  return (
    <div
      ref={viewport}
      // biome-ignore lint/a11y/noNoninteractiveTabindex: A native scroll viewport must be reachable for keyboard scrolling.
      tabIndex={0}
      className="mateo:box-border mateo:flex mateo:flex-col mateo:h-full mateo:w-full mateo:min-h-[0px] mateo:min-w-[0px] mateo:overflow-y-auto mateo:overflow-x-hidden"
    >
      {header && (
        <div
          ref={header.ref}
          className="mateo:sticky mateo:top-[0px] mateo:z-[1] mateo:shrink-0 mateo:pointer-events-none"
        >
          {header.content}
        </div>
      )}
      <div
        ref={content}
        style={style}
        className="mateo:box-border mateo:flex mateo:flex-col mateo:flex-[1_0_auto] mateo:min-w-[0px] mateo:[overflow-wrap:anywhere] mateo:[mask-image:var(--mateo-boundary-mask)] mateo:[mask-size:100%_var(--mateo-viewport-height)] mateo:[mask-position:0_var(--mateo-mask-offset)] mateo:[mask-repeat:no-repeat]"
      >
        {children}
      </div>
    </div>
  );
}
