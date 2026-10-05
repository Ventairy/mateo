import { useCallback, useEffect, useRef, useState } from 'react';

/** Keeps brief contacts compressed until press-in has had time to finish painting. */
export function useMateoPressFeedback(
  enabled: boolean,
  compressionDurationMs: number,
) {
  const [compressed, setCompressed] = useState(false);
  const frame = useRef<number | null>(null);
  const timer = useRef<number | null>(null);
  const releaseRequested = useRef(false);

  const clearMateoPressTimeline = useCallback(() => {
    if (frame.current !== null) window.cancelAnimationFrame(frame.current);
    if (timer.current !== null) window.clearTimeout(timer.current);
    frame.current = null;
    timer.current = null;
    releaseRequested.current = false;
  }, []);

  const cancelMateoPressFeedback = useCallback(() => {
    clearMateoPressTimeline();
    setCompressed(false);
  }, [clearMateoPressTimeline]);

  const startMateoPressFeedback = useCallback(() => {
    if (!enabled) return;
    clearMateoPressTimeline();
    setCompressed(true);
    if (window.matchMedia?.('(prefers-reduced-motion: reduce)').matches) return;
    // Two frames let the committed compressed target paint before measuring its
    // transition. Even down/up in one event batch receives complete feedback.
    frame.current = window.requestAnimationFrame(() => {
      frame.current = window.requestAnimationFrame(() => {
        frame.current = null;
        timer.current = window.setTimeout(() => {
          timer.current = null;
          if (releaseRequested.current) setCompressed(false);
        }, compressionDurationMs);
      });
    });
  }, [enabled, clearMateoPressTimeline, compressionDurationMs]);

  const releaseMateoPressFeedback = useCallback(() => {
    releaseRequested.current = true;
    if (frame.current === null && timer.current === null) setCompressed(false);
  }, []);

  useEffect(() => {
    if (!enabled) cancelMateoPressFeedback();
  }, [enabled, cancelMateoPressFeedback]);

  useEffect(() => {
    const preference = window.matchMedia?.('(prefers-reduced-motion: reduce)');
    function updateMateoPressMotion() {
      if (preference?.matches) cancelMateoPressFeedback();
    }
    preference?.addEventListener('change', updateMateoPressMotion);
    return () => {
      preference?.removeEventListener('change', updateMateoPressMotion);
      clearMateoPressTimeline();
    };
  }, [cancelMateoPressFeedback, clearMateoPressTimeline]);

  return {
    compressed: enabled && compressed,
    startMateoPressFeedback,
    releaseMateoPressFeedback,
    cancelMateoPressFeedback,
  };
}
