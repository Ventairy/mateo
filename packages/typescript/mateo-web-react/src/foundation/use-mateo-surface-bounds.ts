import {
  type Ref,
  useCallback,
  useLayoutEffect,
  useRef,
  useState,
} from 'react';

/** Measure layout dimensions, independent of CSS transforms on the surface. */
export function useMateoSurfaceBounds<
  MateoSurfaceElement extends HTMLElement = HTMLDivElement,
>(active: boolean, forwardedRef: Ref<MateoSurfaceElement> | undefined) {
  const element = useRef<MateoSurfaceElement | null>(null);
  const [bounds, setBounds] = useState({ width: 0, height: 0 });
  const mateoSurfaceRef = useCallback(
    (node: MateoSurfaceElement | null) => {
      element.current = node;
      if (!node) return;
      const cleanup =
        typeof forwardedRef === 'function' ? forwardedRef(node) : undefined;
      if (forwardedRef && typeof forwardedRef !== 'function')
        forwardedRef.current = node;
      return () => {
        element.current = null;
        if (typeof cleanup === 'function') cleanup();
        else if (typeof forwardedRef === 'function') forwardedRef(null);
        else if (forwardedRef) forwardedRef.current = null;
      };
    },
    [forwardedRef],
  );
  useLayoutEffect(() => {
    const node = element.current;
    if (!active || !node) return;
    const measureMateoSurfaceBounds = () => {
      const style = getComputedStyle(node);
      const width = Number.parseFloat(style.width) || node.offsetWidth;
      const height = Number.parseFloat(style.height) || node.offsetHeight;
      setBounds((previous) =>
        previous.width === width && previous.height === height
          ? previous
          : { width, height },
      );
    };
    measureMateoSurfaceBounds();
    const observer = new ResizeObserver(measureMateoSurfaceBounds);
    observer.observe(node, { box: 'border-box' });
    return () => observer.disconnect();
  }, [active]);
  return { ref: mateoSurfaceRef, ...bounds };
}
