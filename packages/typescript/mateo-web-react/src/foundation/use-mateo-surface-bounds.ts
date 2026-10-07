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
    const style = getComputedStyle(node);
    const _updateMateoSurfaceBounds = (width: number, height: number) => {
      setBounds((previous) =>
        previous.width === width && previous.height === height
          ? previous
          : { width, height },
      );
    };
    const _measureMateoSurfaceBounds = (style: CSSStyleDeclaration) => {
      _updateMateoSurfaceBounds(
        Number.parseFloat(style.width) || node.offsetWidth,
        Number.parseFloat(style.height) || node.offsetHeight,
      );
    };
    _measureMateoSurfaceBounds(style);
    const observer = new ResizeObserver((entries) => {
      const sizes = entries?.[0]?.borderBoxSize;
      const size = sizes?.length === 1 ? sizes[0] : undefined;
      if (!size) {
        _measureMateoSurfaceBounds(getComputedStyle(node));
        return;
      }
      // Computed style stays live, including inherited writing-mode changes.
      // Native box sizes avoid synchronous layout reads during resize delivery.
      const writingMode = style.writingMode;
      const vertical =
        writingMode.startsWith('vertical') ||
        writingMode.startsWith('sideways');
      _updateMateoSurfaceBounds(
        vertical ? size.blockSize : size.inlineSize,
        vertical ? size.inlineSize : size.blockSize,
      );
    });
    observer.observe(node, { box: 'border-box' });
    return () => observer.disconnect();
  }, [active]);
  return { ref: mateoSurfaceRef, ...bounds };
}
