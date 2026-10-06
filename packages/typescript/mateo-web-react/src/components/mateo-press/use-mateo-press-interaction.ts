'use client';

import type { KeyboardEvent, MouseEvent, PointerEvent } from 'react';
import { useEffect, useRef, useState } from 'react';
import { mateoPressDurations } from './mateo-press-appearance.js';
import { useMateoPressFeedback } from './use-mateo-press-feedback.js';

type MateoPressContact<MateoPressElement extends HTMLElement> =
  | { readonly pointerId: number; readonly element: MateoPressElement }
  | { readonly key: 'Enter' | ' ' };

/** Shared contact tracking; native controls retain browser keyboard activation. */
export function useMateoPressInteraction<MateoPressElement extends HTMLElement>(
  onPressed:
    | ((event: MouseEvent<MateoPressElement>) => void | Promise<void>)
    | undefined,
  activation: 'custom' | 'native' | 'link' = 'custom',
  animatePress = true,
) {
  if (onPressed !== undefined && typeof onPressed !== 'function') {
    throw new TypeError(
      'MateoPress onPressed must be a function or undefined.',
    );
  }
  const enabled = activation === 'link' || onPressed !== undefined;
  const native = activation !== 'custom';
  const {
    compressed,
    startMateoPressFeedback,
    releaseMateoPressFeedback,
    cancelMateoPressFeedback,
  } = useMateoPressFeedback(
    enabled && animatePress,
    mateoPressDurations.compressionMs,
  );
  const [hovered, setHovered] = useState(false);
  const [pointerFocused, setPointerFocused] = useState(false);
  const [pressed, setPressed] = useState(false);
  const [tracking, setTracking] = useState(false);
  const contact = useRef<MateoPressContact<MateoPressElement> | null>(null);
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

  function startMateoPress(event: PointerEvent<MateoPressElement>) {
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

  function _preserveMateoNativePressFocus(
    event: MouseEvent<MateoPressElement>,
  ) {
    // Pointer down already focused this action without scrolling. WebKit's
    // native mousedown default can otherwise blur a button into its focusable
    // ancestor, cancelling the press before its click arrives.
    if (
      activation === 'native' &&
      enabled &&
      event.button === 0 &&
      event.currentTarget.ownerDocument.activeElement === event.currentTarget
    ) {
      event.preventDefault();
    }
  }

  function enterMateoPress(event: PointerEvent<MateoPressElement>) {
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

  function leaveMateoPress(event: PointerEvent<MateoPressElement>) {
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

  function releaseMateoPress(event: PointerEvent<MateoPressElement>) {
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

  function keyDownMateoPress(event: KeyboardEvent<MateoPressElement>) {
    setPointerFocused(false);
    if (activation === 'link' && event.key !== 'Enter') return;
    if (!enabled || (event.key !== 'Enter' && event.key !== ' ')) return;
    if (!native || event.repeat) event.preventDefault();
    if (event.repeat || contact.current) return;
    contact.current = { key: event.key };
    cancelled.current = false;
    setPressed(true);
    startMateoPressFeedback();
    setTracking(true);
    if (!native && event.key === 'Enter') event.currentTarget.click();
  }

  function keyUpMateoPress(event: KeyboardEvent<MateoPressElement>) {
    const current = contact.current;
    if (!current || !('key' in current) || current.key !== event.key) return;
    if (!native) event.preventDefault();
    contact.current = null;
    setPressed(false);
    releaseMateoPressFeedback();
    setTracking(false);
    if (!native && enabled && event.key === ' ') event.currentTarget.click();
  }

  function activateMateoPress(event: MouseEvent<MateoPressElement>) {
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

  return {
    enabled,
    attributes: {
      'data-mateo-hovered': enabled && hovered ? '' : undefined,
      'data-mateo-pressed': enabled && pressed ? '' : undefined,
      'data-mateo-compressed': enabled && compressed ? '' : undefined,
      'data-mateo-pointer-focus': enabled && pointerFocused ? '' : undefined,
    },
    handlers: {
      onClick: activateMateoPress,
      onPointerDown: startMateoPress,
      onMouseDown: _preserveMateoNativePressFocus,
      onPointerEnter: enterMateoPress,
      onPointerLeave: leaveMateoPress,
      onPointerUp: releaseMateoPress,
      onPointerCancel: releaseMateoPress,
      onKeyDown: keyDownMateoPress,
      onKeyUp: keyUpMateoPress,
      onBlur: blurMateoPress,
    },
  };
}
