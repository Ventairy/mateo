'use client';

import {
  type CSSProperties,
  type RefObject,
  useId,
  useLayoutEffect,
  useRef,
} from 'react';
import { mateoScrollbarDimensions } from '../../theme/mateo-scrollbar.js';
import { useMateoTheme } from '../../theme/mateo-theme-context.js';
import { attachMateoScrollbar } from './mateo-scrollbar-controller.js';

/** Stationary controls for a native scrolling element. */
export interface MateoScrollbarProps {
  /**
   * Native viewport controlled by this scrollbar. Place both as siblings in a
   * positioned wrapper matching the viewport bounds. Replacing the target must
   * also render this component again. A null target retains native scrollbars.
   */
  readonly scrollRef: RefObject<HTMLElement | null>;
  /** Contextual name for the scrolling region; otherwise inherited from its viewport. */
  readonly 'aria-label'?: string;
  /** IDs naming the scrolling region; takes precedence over aria-label. */
  readonly 'aria-labelledby'?: string;
}

/**
 * Overlays native scrolling with always-visible controls for overflowing axes.
 *
 * @remarks
 * Requires a MateoTheme ancestor. Content extends behind the controls. The
 * viewport keeps its native wheel, touch, and keyboard scrolling; each control
 * also supports keyboard scrolling and thumb dragging. Native scrollbars remain
 * available before hydration, in forced colors, and after unmounting.
 * Only one MateoScrollbar may control a viewport at a time.
 *
 * @throws Error - If the theme is missing or another controller owns the viewport.
 *
 * @example
 * ```tsx
 * <div className="relative">
 *   <div ref={scrollRef} tabIndex={0} className="h-80 overflow-auto">{items}</div>
 *   <MateoScrollbar scrollRef={scrollRef} aria-label="Messages" />
 * </div>
 * ```
 */
export function MateoScrollbar({
  scrollRef,
  'aria-label': label,
  'aria-labelledby': labelledBy,
}: MateoScrollbarProps) {
  const theme = useMateoTheme();
  const vertical = useRef<HTMLDivElement>(null);
  const horizontal = useRef<HTMLDivElement>(null);
  const id = useId();
  const controller = useRef<{
    readonly target: HTMLElement;
    readonly label: string | undefined;
    readonly labelledBy: string | undefined;
    readonly release: () => void;
  } | null>(null);
  // Check refs after commits without restarting a stable viewport's gestures.
  useLayoutEffect(() => {
    const target = scrollRef.current;
    const current = controller.current;
    if (
      current?.target === target &&
      current?.label === label &&
      current?.labelledBy === labelledBy
    )
      return;
    current?.release();
    controller.current = null;
    const y = vertical.current;
    const x = horizontal.current;
    if (!target || !y || !x) return;
    const release = attachMateoScrollbar(target, y, x, id, label, labelledBy);
    if (release) controller.current = { target, label, labelledBy, release };
  });
  useLayoutEffect(
    () => () => {
      controller.current?.release();
      controller.current = null;
    },
    [],
  );
  const style: CSSProperties &
    Record<
      | '--mateo-scrollbar-size'
      | '--mateo-scrollbar-inset'
      | '--mateo-scrollbar-thumb'
      | '--mateo-scrollbar-thumb-hover'
      | '--mateo-scrollbar-focus',
      string
    > = {
    '--mateo-scrollbar-size': `${mateoScrollbarDimensions.sizePx}px`,
    '--mateo-scrollbar-inset': `${mateoScrollbarDimensions.insetPx}px`,
    '--mateo-scrollbar-thumb': theme.colorScheme.scrollbar.thumb,
    '--mateo-scrollbar-thumb-hover': theme.colorScheme.scrollbar.thumbHover,
    '--mateo-scrollbar-focus': theme.colorScheme.accent,
  };
  const shared =
    'mateo:absolute mateo:box-border mateo:pointer-events-auto mateo:touch-none mateo:select-none mateo:[display:var(--mateo-scrollbar-display,none)] mateo:focus-visible:outline-solid mateo:focus-visible:outline-[2px] mateo:focus-visible:outline-offset-[-2px] mateo:focus-visible:outline-(--mateo-scrollbar-focus) mateo:forced-colors:hidden mateo:group/mateo-scrollbar';
  const thumb =
    'mateo:absolute mateo:box-border mateo:rounded-[calc(var(--mateo-scrollbar-size)/2)] mateo:border-solid mateo:border-transparent mateo:border-(length:--mateo-scrollbar-inset) mateo:bg-(--mateo-scrollbar-thumb) mateo:bg-clip-padding mateo:group-hover/mateo-scrollbar:bg-(--mateo-scrollbar-thumb-hover) mateo:group-data-dragging/mateo-scrollbar:bg-(--mateo-scrollbar-thumb-hover)';
  return (
    <div
      style={style}
      className="mateo:absolute mateo:inset-[0px] mateo:z-[2] mateo:pointer-events-none"
    >
      <div
        ref={vertical}
        role="scrollbar"
        aria-orientation="vertical"
        aria-controls={id}
        aria-valuemin={0}
        aria-valuemax={100}
        aria-valuenow={0}
        tabIndex={-1}
        className={`${shared} mateo:top-[0px] mateo:end-[0px] mateo:w-(--mateo-scrollbar-size) mateo:h-(--mateo-scrollbar-track)`}
      >
        <div
          className={`${thumb} mateo:top-[0px] mateo:left-[0px] mateo:w-full mateo:h-(--mateo-scrollbar-length) mateo:[transform:translateY(var(--mateo-scrollbar-position))]`}
        />
      </div>
      <div
        ref={horizontal}
        role="scrollbar"
        aria-orientation="horizontal"
        aria-controls={id}
        aria-valuemin={0}
        aria-valuemax={100}
        aria-valuenow={0}
        tabIndex={-1}
        className={`${shared} mateo:bottom-[0px] mateo:start-[0px] mateo:h-(--mateo-scrollbar-size) mateo:w-(--mateo-scrollbar-track)`}
      >
        <div
          className={`${thumb} mateo:top-[0px] mateo:left-[0px] mateo:h-full mateo:w-(--mateo-scrollbar-length) mateo:[transform:translateX(var(--mateo-scrollbar-position))]`}
        />
      </div>
    </div>
  );
}
