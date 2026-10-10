import { MateoView, MateoViewSurface } from '@mateo/web-react/react';
import { expect, it } from 'vitest';
import { commands } from 'vitest/browser';
import {
  getMateoGoldenElement,
  renderMateoGoldens,
  settleMateoGolden,
} from '../../../test/golden/mateo-golden.js';

for (const overscroll of ['native', 'clamp'] as const) {
  it(`should ${overscroll === 'clamp' ? 'keep boundary wheel input inside the view' : 'allow native scroll chaining'} when overscroll is ${overscroll}`, async () => {
    await renderMateoGoldens([
      {
        name: 'overscroll',
        width: 500,
        height: 300,
        content: (
          <div
            data-testid="outer-scroll"
            style={{ height: 300, overflowY: 'auto' }}
          >
            <div style={{ height: 60 }} />
            <div style={{ height: 240 }}>
              <MateoView
                surface={
                  <MateoViewSurface overscrollBehavior={overscroll} padding={0}>
                    <div style={{ height: 900 }} />
                    <div data-testid="wheel-target" style={{ height: 40 }}>
                      End
                    </div>
                  </MateoViewSurface>
                }
              />
            </div>
            <div style={{ height: 600 }} />
          </div>
        ),
      },
    ]);
    await settleMateoGolden();
    const outer = getMateoGoldenElement('outer-scroll');
    const target = getMateoGoldenElement('wheel-target');
    const inner = target.closest<HTMLElement>(
      '[tabindex="0"].mateo\\:overflow-y-auto',
    );
    if (!inner) throw new Error('Missing native view viewport');
    outer.scrollTop = 60;
    inner.scrollTop = inner.scrollHeight - inner.clientHeight;
    await settleMateoGolden();
    await commands.mateoWheel('wheel-target', 180);
    if (overscroll === 'clamp') expect(outer.scrollTop).toBe(60);
    else expect(outer.scrollTop).toBeGreaterThan(60);
    const maximum = inner.scrollHeight - inner.clientHeight;
    expect(inner.scrollTop).toBe(maximum);
    await commands.mateoWheel('wheel-target', -80);
    expect(inner.scrollTop).toBeLessThan(maximum);
  });
}
