'use client';

import type { ReactElement, ReactNode, Ref } from 'react';
import {
  cloneElement,
  isValidElement,
  useCallback,
  useEffect,
  useLayoutEffect,
  useRef,
  useState,
} from 'react';
import { createMateoDragResistance } from './mateo-drag-resistance-interaction.js';

interface MateoDragResistanceChildProps {
  readonly ref?: Ref<HTMLElement | SVGElement>;
  readonly className?: string;
  readonly children?: ReactNode;
}

/** Sets how far anchored content can yield in each screen direction. */
export interface MateoDragResistanceSides {
  /** Maximum upward movement in CSS pixels. Omitted or zero keeps this side fixed. */
  readonly top?: number;
  /** Maximum rightward movement in CSS pixels. Omitted or zero keeps this side fixed. */
  readonly right?: number;
  /** Maximum downward movement in CSS pixels. Omitted or zero keeps this side fixed. */
  readonly bottom?: number;
  /** Maximum leftward movement in CSS pixels. Omitted or zero keeps this side fixed. */
  readonly left?: number;
}

/** Controls how anchored content responds to a pull. */
export interface MateoDragResistanceProps {
  /**
   * Content to make responsive to a pull. Supply one native HTML or SVG element;
   * custom React components and fragments are unsupported. Keep its accessible
   * name and any actions on that element. Its ref and handlers are retained.
   */
  readonly children: ReactElement<MateoDragResistanceChildProps>;
  /**
   * How far content can yield, in screen CSS pixels. A number applies to every
   * side; an object sets each side separately, with omitted sides staying fixed.
   * Larger values allow more movement. For example, `{ right: 16 }` allows
   * only rightward movement. All values must be finite and nonnegative.
   * Horizontal and vertical limits apply independently during diagonal pulls.
   *
   * @defaultValue `6`
   */
  readonly resistance?: number | MateoDragResistanceSides;
}

/**
 * Lets people tug anchored content, such as decorative artwork, and feel it
 * resist further movement.
 *
 * @remarks
 * Use for playful feedback when pulling should leave the content anchored.
 * Content yields less as the pull grows, then returns to rest in 180 ms without
 * overshoot when released. Grabbing it during the return continues from its
 * current position. Reduced motion keeps it stationary.
 *
 * The child's layout, native scrolling, and interactive descendants are
 * preserved. For touch dragging on decorative artwork, opt out of scrolling
 * through the child's `touch-action` styling. Use a dedicated interaction when
 * dragging should scroll, dismiss, reorder, or perform another action.
 *
 * Existing transforms are retained. Do not animate or set the child's CSS
 * `translate` property while this component is mounted; use a nested element
 * for additional movement.
 *
 * @throws TypeError - If resistance is invalid or the child is not a native element.
 * @example
 * ```tsx
 * <MateoDragResistance resistance={{ right: 16 }}>
 *   <g>{artwork}</g>
 * </MateoDragResistance>
 * ```
 */
export function MateoDragResistance({
  children,
  resistance = 6,
}: MateoDragResistanceProps) {
  if (
    typeof resistance !== 'number' &&
    (!resistance || typeof resistance !== 'object' || Array.isArray(resistance))
  ) {
    throw new TypeError(
      'MateoDragResistance resistance needs a number or limits for each side.',
    );
  }
  const {
    top = 0,
    right = 0,
    bottom = 0,
    left = 0,
  } = typeof resistance === 'number'
    ? {
        top: resistance,
        right: resistance,
        bottom: resistance,
        left: resistance,
      }
    : resistance;
  if (
    [top, right, bottom, left].some(
      (limit) => !Number.isFinite(limit) || limit < 0,
    )
  ) {
    throw new TypeError(
      'MateoDragResistance limits must be finite and nonnegative.',
    );
  }
  if (!isValidElement(children) || typeof children.type !== 'string') {
    throw new TypeError(
      'MateoDragResistance needs one native HTML or SVG element.',
    );
  }
  const [element, setElement] = useState<HTMLElement | SVGElement | null>(null);
  const options = useRef({ resistance: { top, right, bottom, left } });
  const controller = useRef<ReturnType<
    typeof createMateoDragResistance
  > | null>(null);
  useLayoutEffect(() => {
    options.current = { resistance: { top, right, bottom, left } };
    controller.current?.update();
  }, [top, right, bottom, left]);
  const childRef = children.props.ref;
  const ref = useCallback(
    (node: HTMLElement | SVGElement | null) => {
      setElement(node);
      const cleanup =
        typeof childRef === 'function' ? childRef(node) : undefined;
      if (childRef && typeof childRef !== 'function') childRef.current = node;
      return () => {
        setElement(null);
        if (typeof cleanup === 'function') cleanup();
        else if (typeof childRef === 'function') childRef(null);
        else if (childRef) childRef.current = null;
      };
    },
    [childRef],
  );
  useEffect(() => {
    if (!element) return;
    const interaction = createMateoDragResistance(
      element,
      () => options.current,
    );
    controller.current = interaction;
    return () => {
      interaction.dispose();
      controller.current = null;
    };
  }, [element]);
  return cloneElement(children, {
    ref,
    className: [
      children.props.className,
      'mateo:cursor-grab mateo:data-[mateo-dragging]:cursor-grabbing mateo:motion-reduce:cursor-auto mateo:data-[mateo-resistance-disabled]:cursor-auto',
    ]
      .filter(Boolean)
      .join(' '),
  });
}
