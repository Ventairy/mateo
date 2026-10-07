import { MateoSurface } from 'mateo-web-react/react';
import { createRef } from 'react';
import { expect, it, vi } from 'vitest';
import {
  getMateoGoldenElement,
  renderMateoGoldens,
  settleMateoGolden,
} from '../../../test/golden/mateo-golden.js';

it('should use delivered dimensions without layout reads when a shaped surface resizes', async () => {
  const ref = createRef<HTMLDivElement>();
  let reads = { computedStyle: 0, width: 0, height: 0 };
  const _getMateoComputedStyle = window.getComputedStyle;
  const styleSpy = vi
    .spyOn(window, 'getComputedStyle')
    .mockImplementation((element, pseudoElement) => {
      const style = _getMateoComputedStyle.call(window, element, pseudoElement);
      if (element !== ref.current) return style;
      reads.computedStyle++;
      return new Proxy(style, {
        get(target, property) {
          if (property === 'width') reads.width++;
          if (property === 'height') reads.height++;
          const value = Reflect.get(target, property, target);
          return typeof value === 'function' ? value.bind(target) : value;
        },
      });
    });
  try {
    await renderMateoGoldens([
      {
        name: 'surface-resize-work',
        width: 320,
        height: 260,
        content: (
          <div
            data-testid="surface-parent"
            style={{
              width: 200.5,
              height: 76.25,
              transform: 'scale(0.8)',
              transformOrigin: 'top left',
            }}
          >
            <MateoSurface
              ref={ref}
              width="fill"
              height="fill"
              padding="4px 8px"
              shape="capsule"
            >
              Surface
            </MateoSurface>
          </div>
        ),
      },
    ]);
    await settleMateoGolden();
    const surface = ref.current;
    if (!surface) throw new Error('Missing surface.');
    const path = surface.querySelector('path');
    if (!path) throw new Error('Missing surface outline.');
    const widthSpy = vi.spyOn(surface, 'offsetWidth', 'get');
    const heightSpy = vi.spyOn(surface, 'offsetHeight', 'get');
    reads = { computedStyle: 0, width: 0, height: 0 };
    try {
      const parent = getMateoGoldenElement('surface-parent');
      for (const { width, height, writingMode } of [
        { width: 240.5, height: 64.25, writingMode: 'horizontal-tb' },
        { width: 96.25, height: 160.5, writingMode: 'vertical-rl' },
        { width: 104.5, height: 104.5, writingMode: 'horizontal-tb' },
      ]) {
        const previous = path.getAttribute('d');
        parent.style.width = `${width}px`;
        parent.style.height = `${height}px`;
        parent.style.writingMode = writingMode;
        await expect.poll(() => path.getAttribute('d')).not.toBe(previous);
      }
      expect(reads).toEqual({ computedStyle: 0, width: 0, height: 0 });
      expect(widthSpy).not.toHaveBeenCalled();
      expect(heightSpy).not.toHaveBeenCalled();
    } finally {
      widthSpy.mockRestore();
      heightSpy.mockRestore();
    }
  } finally {
    styleSpy.mockRestore();
  }
});
