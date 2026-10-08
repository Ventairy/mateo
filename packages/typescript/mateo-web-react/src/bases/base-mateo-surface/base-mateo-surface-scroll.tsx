import type { CSSProperties, ReactNode, Ref } from 'react';
import { useLayoutEffect, useRef } from 'react';
import { MateoScrollbar } from '../../components/mateo-scrollbar/mateo-scrollbar.js';
import {
  getMateoBoundaryDepth,
  getMateoBoundaryOverlay,
} from './mateo-surface-boundary.js';

export interface BaseMateoSurfaceScrollOptions {
  readonly clearanceBlockStart: number;
  readonly extendBehindScrollbar?: boolean;
  readonly clampOverscroll?: boolean;
  readonly contentMaxWidth?: number;
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
  surfaceColor,
}: {
  readonly children: ReactNode;
  readonly options: BaseMateoSurfaceScrollOptions;
  readonly surfaceColor: string;
}) {
  const viewport = useRef<HTMLDivElement>(null);
  const content = useRef<HTMLDivElement>(null);
  const boundary = useRef<HTMLDivElement>(null);
  const { clearanceBlockStart, header, padding } = options;
  useLayoutEffect(() => {
    const node = viewport.current;
    const body = content.current;
    const fade = boundary.current;
    if (!node || !body || !fade) return;
    const ownerDocument = node.ownerDocument;
    const ownerWindow = ownerDocument.defaultView;
    let previousTop: number | undefined;
    const updateMateoScrollBoundary = () => {
      const height = node.clientHeight;
      const maximum = Math.max(0, node.scrollHeight - height);
      const position = Math.max(0, Math.min(maximum, node.scrollTop));
      const depths = getMateoBoundaryDepth(
        height,
        position,
        clearanceBlockStart,
        padding.blockStart,
      );
      if (previousTop !== depths.top) {
        // Native sticky positioning owns the origin. A delayed scroll event
        // can delay depth adjustment, but cannot displace or truncate content.
        fade.style.backgroundImage = getMateoBoundaryOverlay(
          depths.top,
          surfaceColor,
        );
        fade.style.height = `${depths.top}px`;
        previousTop = depths.top;
      }
      const clearance = `${depths.clearTop}px`;
      if (node.style.scrollPaddingBlockStart !== clearance)
        node.style.scrollPaddingBlockStart = clearance;
      if (node.style.scrollPaddingBlockEnd !== '0px')
        node.style.scrollPaddingBlockEnd = '0px';
    };
    updateMateoScrollBoundary();
    const observer = new ResizeObserver(updateMateoScrollBoundary);
    observer.observe(node);
    observer.observe(body);
    node.addEventListener('scroll', updateMateoScrollBoundary, {
      passive: true,
    });
    // Keep intent local to this viewport. The event path also covers presses on
    // noninteractive children of a control, without treating sibling focus (for
    // example a validation error) as pointer focus.
    let mateoPointerPath: readonly EventTarget[] = [];
    const _clearMateoPointerFocus = () => {
      mateoPointerPath = [];
    };
    const _captureMateoPointerFocus = (event: MouseEvent) => {
      mateoPointerPath =
        event.button === 0 &&
        !(event instanceof PointerEvent && !event.isPrimary) &&
        event.target instanceof Node &&
        body.contains(event.target)
          ? event.composedPath()
          : [];
    };
    const pointerListeners = new AbortController();
    const capture = { capture: true, signal: pointerListeners.signal };
    ownerDocument.addEventListener(
      'pointerdown',
      _captureMateoPointerFocus,
      capture,
    );
    // Touch can focus through compatibility mousedown after pointerup. Capture
    // that new focus opportunity instead of retaining a completed touch contact.
    ownerDocument.addEventListener(
      'mousedown',
      _captureMateoPointerFocus,
      capture,
    );
    for (const type of [
      'pointerup',
      'pointercancel',
      'mouseup',
      'click',
      'keydown',
      'dragstart',
    ]) {
      ownerDocument.addEventListener(type, _clearMateoPointerFocus, capture);
    }
    ownerWindow?.addEventListener('blur', _clearMateoPointerFocus, capture);
    const revealMateoFocusedContent = (event: FocusEvent) => {
      if (
        !(event.target instanceof HTMLElement) ||
        !body.contains(event.target)
      )
        return;
      const pointerFocused = mateoPointerPath.includes(event.target);
      _clearMateoPointerFocus();
      if (pointerFocused) return;
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
      pointerListeners.abort();
      observer.disconnect();
      node.removeEventListener('scroll', updateMateoScrollBoundary);
      node.removeEventListener('focusin', revealMateoFocusedContent);
    };
  }, [clearanceBlockStart, padding.blockStart, surfaceColor]);

  const style: CSSProperties & {
    readonly '--mateo-scroll-content-max-width': string;
  } = {
    '--mateo-scroll-content-max-width':
      options.contentMaxWidth === undefined
        ? 'none'
        : `${options.contentMaxWidth}px`,
    paddingBlockStart: padding.blockStart,
    paddingBlockEnd: padding.blockEnd,
    paddingInlineStart: padding.inlineStart,
    paddingInlineEnd: padding.inlineEnd,
  };
  return (
    <>
      <div
        ref={viewport}
        data-mateo-scrollbar-presentation={
          options.extendBehindScrollbar ? 'overlay' : undefined
        }
        // biome-ignore lint/a11y/noNoninteractiveTabindex: A native scroll viewport must be reachable for keyboard scrolling.
        tabIndex={0}
        className={[
          'mateo:box-border mateo:flex mateo:flex-col mateo:h-full mateo:w-full mateo:min-h-[0px] mateo:min-w-[0px] mateo:overflow-y-auto mateo:overflow-x-hidden',
          options.clampOverscroll ? 'mateo:overscroll-y-none' : '',
        ]
          .filter(Boolean)
          .join(' ')}
      >
        <div
          aria-hidden="true"
          className="mateo:sticky mateo:top-[0px] mateo:z-[1] mateo:h-[0px] mateo:shrink-0 mateo:pointer-events-none"
        >
          <div
            ref={boundary}
            className="mateo:absolute mateo:inset-x-[0px] mateo:top-[0px] mateo:pointer-events-none"
          />
        </div>
        {header && (
          <div
            ref={header.ref}
            className="mateo:sticky mateo:top-[0px] mateo:z-[2] mateo:shrink-0 mateo:pointer-events-none"
          >
            {header.content}
          </div>
        )}
        <div
          ref={content}
          style={style}
          className="mateo:relative mateo:z-[0] mateo:isolate mateo:box-border mateo:flex mateo:flex-col mateo:flex-[1_0_auto] mateo:w-full mateo:max-w-(--mateo-scroll-content-max-width) mateo:mx-auto mateo:min-w-[0px] mateo:[overflow-wrap:anywhere]"
        >
          {children}
        </div>
      </div>
      {options.extendBehindScrollbar && <MateoScrollbar scrollRef={viewport} />}
    </>
  );
}
