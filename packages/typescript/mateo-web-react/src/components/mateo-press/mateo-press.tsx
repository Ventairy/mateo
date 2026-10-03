'use client';

import type {
  AriaAttributes,
  CSSProperties,
  KeyboardEvent,
  MouseEvent,
  PointerEvent,
  ReactNode,
  Ref,
} from 'react';
import { useEffect, useRef, useState } from 'react';
import { useMateoPressFeedback } from './use-mateo-press-feedback.js';

const mateoPressDurations = {
  compressionMs: 140,
  releaseMs: 180,
} as const;

const mateoPressDurationStyle: CSSProperties &
  Record<
    '--mateo-press-compression-duration' | '--mateo-press-release-duration',
    `${number}ms`
  > = {
  '--mateo-press-compression-duration': `${mateoPressDurations.compressionMs}ms`,
  '--mateo-press-release-duration': `${mateoPressDurations.releaseMs}ms`,
};

/**
 * MateoPress's bounded, non-oscillating spring profile, sampled every 1/64.
 * With t in [0,1], r(t) = (1 + 2πt) exp(-2πt) is critical damping.
 * Its response is already 82% complete halfway through the phase.
 * Over the second half, remove its remaining tail with the C3 smootherstep
 * S(s) = 35s⁴ - 84s⁵ + 70s⁶ - 20s⁷, s = max(0, 2t - 1).
 * Sample 1 - r(t)(1 - S(s)), rounded to seven decimal places.
 * The underlying curve lands with zero velocity, acceleration, and jerk;
 * CSS linear() closely approximates it without a per-frame JavaScript loop.
 * Scale and opacity share this profile in both directions.
 */
const mateoPressCurveClass =
  'mateo:[--mateo-press-curve:linear(0,0.004515,0.0169297,0.0357272,0.0596051,0.0874491,0.1183086,0.1513761,0.1859689,0.2215126,0.2575268,0.2936129,0.3294423,0.3647477,0.3993136,0.4329697,0.4655839,0.4970568,0.5273166,0.556315,0.5840233,0.6104292,0.635534,0.6593501,0.6818991,0.7032097,0.7233162,0.7422576,0.7600759,0.7768156,0.7925225,0.8072435,0.8210256,0.8339207,0.8460304,0.8575097,0.8685175,0.8791842,0.8895965,0.8997942,0.9097735,0.9194959,0.9288979,0.9379021,0.9464262,0.954392,0.9617318,0.9683932,0.974342,0.9795635,0.9840624,0.9878618,0.9910004,0.9935305,0.9955142,0.9970207,0.9981222,0.9988916,0.9993991,0.9997096,0.9998811,0.9999625,0.9999926,0.9999995,1)]';

/** Content and inner spacing forming one action; descendants must be noninteractive. */
export interface MateoPressProps extends AriaAttributes {
  readonly children: ReactNode;
  /** A completed activation. Omit to disable; asynchronous work is caller-owned. */
  readonly onPressed?: (
    event: MouseEvent<HTMLDivElement>,
  ) => void | Promise<void>;
  readonly ref?: Ref<HTMLDivElement>;
  readonly id?: string;
  readonly [attribute: `data-${string}`]: string | number | boolean | undefined;
}

type MateoPressContact =
  | { readonly pointerId: number; readonly element: HTMLDivElement }
  | { readonly key: 'Enter' | ' ' };

/** Adds hover, contact feedback, and button semantics to a custom action. */
export function MateoPress({
  children,
  onPressed,
  ref,
  id,
  ...attributes
}: MateoPressProps) {
  if (onPressed !== undefined && typeof onPressed !== 'function') {
    throw new TypeError(
      'MateoPress onPressed must be a function or undefined.',
    );
  }
  const enabled = onPressed !== undefined;
  const {
    compressed,
    startMateoPressFeedback,
    releaseMateoPressFeedback,
    cancelMateoPressFeedback,
  } = useMateoPressFeedback(enabled, mateoPressDurations.compressionMs);
  const [hovered, setHovered] = useState(false);
  const [pointerFocused, setPointerFocused] = useState(false);
  const [pressed, setPressed] = useState(false);
  const [tracking, setTracking] = useState(false);
  const contact = useRef<MateoPressContact | null>(null);
  const cancelled = useRef(false);

  useEffect(() => {
    if (!enabled) {
      contact.current = null;
      cancelled.current = true;
      setHovered(false);
      setPointerFocused(false);
      setPressed(false);
      setTracking(false);
      return;
    }
    if (!tracking) return;

    function cancelMateoPress() {
      cancelMateoPressFeedback();
      contact.current = null;
      cancelled.current = true;
      setPressed(false);
      setHovered(false);
      setTracking(false);
    }
    function finishMateoPress(event: globalThis.PointerEvent) {
      const current = contact.current;
      if (!current || !('pointerId' in current)) return;
      if (current.pointerId !== event.pointerId) return;
      cancelled.current =
        event.type === 'pointercancel' ||
        !(
          event.target instanceof Node && current.element.contains(event.target)
        );
      contact.current = null;
      cancelMateoPressFeedback();
      setPressed(false);
      setTracking(false);
    }
    // Track releases outside the wrapper without capturing or blocking scrolling.
    window.addEventListener('pointerup', finishMateoPress);
    window.addEventListener('pointercancel', finishMateoPress);
    window.addEventListener('blur', cancelMateoPress);
    window.addEventListener('scroll', cancelMateoPress, true);
    return () => {
      window.removeEventListener('pointerup', finishMateoPress);
      window.removeEventListener('pointercancel', finishMateoPress);
      window.removeEventListener('blur', cancelMateoPress);
      window.removeEventListener('scroll', cancelMateoPress, true);
    };
  }, [enabled, tracking, cancelMateoPressFeedback]);

  function startMateoPress(event: PointerEvent<HTMLDivElement>) {
    if (
      !enabled ||
      event.button !== 0 ||
      event.isPrimary === false ||
      contact.current
    )
      return;
    contact.current = {
      pointerId: event.pointerId,
      element: event.currentTarget,
    };
    cancelled.current = false;
    setHovered(event.pointerType === 'mouse');
    setPressed(true);
    startMateoPressFeedback();
    setTracking(true);
    setPointerFocused(true);
    // A generic layout wrapper needs the focus behavior supplied by native buttons.
    event.currentTarget.focus({ preventScroll: true });
  }

  function enterMateoPress(event: PointerEvent<HTMLDivElement>) {
    if (!enabled) return;
    setHovered(event.pointerType === 'mouse');
    const current = contact.current;
    if (
      current &&
      'pointerId' in current &&
      current.pointerId === event.pointerId
    ) {
      cancelled.current = false;
      setPressed(true);
      startMateoPressFeedback();
    }
  }

  function leaveMateoPress(event: PointerEvent<HTMLDivElement>) {
    setHovered(false);
    const current = contact.current;
    if (
      current &&
      'pointerId' in current &&
      current.pointerId === event.pointerId
    ) {
      cancelled.current = true;
      setPressed(false);
      cancelMateoPressFeedback();
    }
  }

  function releaseMateoPress(event: PointerEvent<HTMLDivElement>) {
    const current = contact.current;
    if (
      !current ||
      !('pointerId' in current) ||
      current.pointerId !== event.pointerId
    )
      return;
    cancelled.current = event.type === 'pointercancel';
    if (cancelled.current) cancelMateoPressFeedback();
    else releaseMateoPressFeedback();
    contact.current = null;
    setPressed(false);
    setTracking(false);
  }

  function keyDownMateoPress(event: KeyboardEvent<HTMLDivElement>) {
    setPointerFocused(false);
    if (!enabled || (event.key !== 'Enter' && event.key !== ' ')) return;
    event.preventDefault();
    if (event.repeat || contact.current) return;
    contact.current = { key: event.key };
    cancelled.current = false;
    setPressed(true);
    startMateoPressFeedback();
    setTracking(true);
    if (event.key === 'Enter') event.currentTarget.click();
  }

  function keyUpMateoPress(event: KeyboardEvent<HTMLDivElement>) {
    const current = contact.current;
    if (!current || !('key' in current) || current.key !== event.key) return;
    event.preventDefault();
    contact.current = null;
    setPressed(false);
    releaseMateoPressFeedback();
    setTracking(false);
    if (enabled && event.key === ' ') event.currentTarget.click();
  }

  function activateMateoPress(event: MouseEvent<HTMLDivElement>) {
    if (!onPressed || (event.detail > 0 && cancelled.current)) return;
    if (event.detail === 0) setPointerFocused(false);
    onPressed(event);
  }

  function blurMateoPress() {
    cancelMateoPressFeedback();
    contact.current = null;
    cancelled.current = true;
    setPressed(false);
    setHovered(false);
    setPointerFocused(false);
    setTracking(false);
  }

  const accessibleAttributes = Object.fromEntries(
    Object.entries(attributes).filter(
      ([name]) => name.startsWith('aria-') || name.startsWith('data-'),
    ),
  );
  return (
    // biome-ignore lint/a11y/useSemanticElements: Native buttons cannot contain arbitrary flow content such as MateoSurface.
    <div
      {...accessibleAttributes}
      ref={ref}
      id={id}
      role="button"
      tabIndex={enabled ? 0 : -1}
      aria-disabled={!enabled}
      data-mateo-hovered={enabled && hovered ? '' : undefined}
      data-mateo-pressed={enabled && pressed ? '' : undefined}
      data-mateo-compressed={enabled && compressed ? '' : undefined}
      data-mateo-pointer-focus={enabled && pointerFocused ? '' : undefined}
      className={[
        'mateo:group/mateo-press mateo:inline-grid mateo:box-border mateo:max-w-full mateo:w-fit',
        'mateo:[&:focus:not(:focus-visible)]:[outline:none]',
        'mateo:[&[data-mateo-pointer-focus]:focus]:[outline:none]',
        enabled ? 'mateo:cursor-pointer' : 'mateo:cursor-default',
      ].join(' ')}
      onClick={activateMateoPress}
      onPointerDown={startMateoPress}
      onPointerEnter={enterMateoPress}
      onPointerLeave={leaveMateoPress}
      onPointerUp={releaseMateoPress}
      onPointerCancel={releaseMateoPress}
      onKeyDown={keyDownMateoPress}
      onKeyUp={keyUpMateoPress}
      onBlur={blurMateoPress}
    >
      <div
        style={mateoPressDurationStyle}
        className={[
          'mateo:min-w-0 mateo:origin-center mateo:[transition-property:transform,opacity] mateo:[transition-duration:var(--mateo-press-release-duration)]',
          mateoPressCurveClass,
          'mateo:group-data-mateo-compressed/mateo-press:[transition-duration:var(--mateo-press-compression-duration)]',
          'mateo:[transition-timing-function:var(--mateo-press-curve)]',
          'mateo:group-data-mateo-hovered/mateo-press:opacity-[0.80]',
          'mateo:group-data-mateo-compressed/mateo-press:opacity-[0.80]',
          'mateo:motion-safe:group-data-mateo-compressed/mateo-press:[transform:scale(0.977)]',
          'mateo:motion-reduce:transform-none mateo:motion-reduce:transition-none',
        ].join(' ')}
      >
        {children}
      </div>
    </div>
  );
}
