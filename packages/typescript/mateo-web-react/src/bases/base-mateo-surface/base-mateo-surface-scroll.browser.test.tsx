import { MateoView, MateoViewSurface } from 'mateo-web-react/react';
import { expect, it, vi } from 'vitest';
import {
  getMateoGoldenElement,
  renderMateoGoldens,
  settleMateoGolden,
} from '../../../test/golden/mateo-golden.js';

async function _renderMateoScrollBoundary() {
  const result = await renderMateoGoldens([
    {
      name: 'native-boundary',
      width: 400,
      height: 220,
      content: (
        <MateoView
          surface={
            <MateoViewSurface padding={0}>
              <div data-testid="boundary-foreground" style={{ height: 640 }}>
                <button
                  type="button"
                  data-testid="boundary-focus"
                  style={{ marginTop: 520 }}
                >
                  Last action
                </button>
              </div>
            </MateoViewSurface>
          }
        />
      ),
    },
  ]);
  await settleMateoGolden();
  const foreground = getMateoGoldenElement('boundary-foreground');
  const viewport = foreground.closest<HTMLElement>('[tabindex="0"]');
  const owner = foreground.parentElement;
  if (!viewport || !owner) throw new Error('Missing scroll owner');
  return { result, viewport, owner };
}

it('should update native scroll masks without mutating owner style and release held effects at rest and on cleanup', async () => {
  const { result, viewport, owner } = await _renderMateoScrollBoundary();
  expect(getComputedStyle(owner).maskImage).toBe('none');
  expect(owner.getAnimations()).toHaveLength(0);
  viewport.scrollTop = 80;
  await settleMateoGolden();
  const held = owner.getAnimations()[0];
  const records: MutationRecord[] = [];
  const observer = new MutationObserver((changes) => records.push(...changes));
  observer.observe(owner, { attributes: true, attributeFilter: ['style'] });
  try {
    viewport.scrollTop = 120;
    await settleMateoGolden();
    expect(getComputedStyle(owner).maskPosition).toBe(
      `0px ${viewport.scrollTop}px`,
    );
    expect(records).toHaveLength(0);
    if (!held) throw new Error('Missing held mask effect');
    expect(owner.getAnimations()).toHaveLength(1);
    expect(owner.getAnimations()[0]).toBe(held);
    expect(held.playState).toBe('paused');
    expect(held.timeline).toBeNull();
    expect(held.currentTime).toBe(0);
    const oldHeight = viewport.clientHeight;
    getMateoGoldenElement('native-boundary').style.height = '260px';
    await settleMateoGolden();
    expect(viewport.clientHeight).toBeGreaterThan(oldHeight);
    expect(getComputedStyle(owner).maskSize).toBe(
      `100% ${viewport.clientHeight}px`,
    );
    getMateoGoldenElement('boundary-focus').focus({ preventScroll: true });
    await settleMateoGolden();
    expect(viewport.scrollTop).toBeGreaterThan(120);
    expect(getComputedStyle(owner).maskPosition).toBe(
      `0px ${viewport.scrollTop}px`,
    );
    expect(owner.getAnimations()).toHaveLength(1);
    expect(owner.getAnimations()[0]).toBe(held);
    expect(held.currentTime).toBe(0);
    expect(records).toHaveLength(0);
  } finally {
    observer.disconnect();
  }
  viewport.scrollTop = 0;
  await settleMateoGolden();
  if (!held) throw new Error('Missing held mask effect');
  expect(getComputedStyle(owner).maskImage).toBe('none');
  expect(owner.getAnimations()).toHaveLength(0);
  expect(held.playState).toBe('idle');
  viewport.scrollTop = 80;
  await settleMateoGolden();
  const returned = owner.getAnimations();
  expect(returned).toHaveLength(1);
  const returnedEffect = returned[0];
  if (!returnedEffect) throw new Error('Missing returned mask effect');
  expect(returnedEffect).not.toBe(held);
  await result.unmount();
  expect(returnedEffect.playState).toBe('idle');
  expect(document.getAnimations()).not.toContain(returnedEffect);
});

it('should keep native scroll, resize, and focus masks current when native effect support is unavailable', async () => {
  vi.stubGlobal('KeyframeEffect', undefined);
  try {
    const { result, viewport, owner } = await _renderMateoScrollBoundary();
    viewport.scrollTop = 120;
    await settleMateoGolden();
    expect(getComputedStyle(owner).maskImage).toContain('linear-gradient');
    expect(getComputedStyle(owner).maskPosition).toBe(
      `0px ${viewport.scrollTop}px`,
    );
    const oldHeight = viewport.clientHeight;
    getMateoGoldenElement('native-boundary').style.height = '260px';
    await settleMateoGolden();
    expect(viewport.clientHeight).toBeGreaterThan(oldHeight);
    expect(getComputedStyle(owner).maskSize).toBe(
      `100% ${viewport.clientHeight}px`,
    );
    getMateoGoldenElement('boundary-focus').focus({ preventScroll: true });
    await settleMateoGolden();
    expect(viewport.scrollTop).toBeGreaterThan(120);
    expect(getComputedStyle(owner).maskPosition).toBe(
      `0px ${viewport.scrollTop}px`,
    );
    expect(owner.getAnimations()).toHaveLength(0);
    await result.unmount();
  } finally {
    vi.unstubAllGlobals();
  }
});

it('should release a rejected native effect and keep subsequent scroll states current through its fallback', async () => {
  const { result, viewport, owner } = await _renderMateoScrollBoundary();
  viewport.scrollTop = 80;
  await settleMateoGolden();
  const held = owner.getAnimations()[0];
  expect(owner.getAnimations()).toHaveLength(1);
  if (!held) throw new Error('Missing held mask effect');
  const rejection = vi
    .spyOn(KeyframeEffect.prototype, 'setKeyframes')
    .mockImplementationOnce(() => {
      throw new Error('Native effect update rejected');
    });
  try {
    for (const position of [120, 200]) {
      viewport.scrollTop = position;
      await settleMateoGolden();
      expect(getComputedStyle(owner).maskImage).toContain('linear-gradient');
      expect(getComputedStyle(owner).maskPosition).toBe(
        `0px ${viewport.scrollTop}px`,
      );
      expect(owner.getAnimations()).toHaveLength(0);
    }
    expect(rejection).toHaveBeenCalledOnce();
    expect(held.playState).toBe('idle');
    await result.unmount();
  } finally {
    rejection.mockRestore();
  }
});

it('should keep scroll-owned mask metadata with each owner when nested viewports scroll', async () => {
  await renderMateoGoldens([
    {
      name: 'boundary-isolation',
      width: 400,
      height: 220,
      content: (
        <MateoView
          surface={
            <MateoViewSurface padding={0}>
              <div style={{ height: 300 }} />
              <div style={{ height: 160 }}>
                <MateoView
                  surface={
                    <MateoViewSurface padding={0}>
                      <div
                        data-testid="nested-foreground"
                        style={{ height: 500 }}
                      >
                        Inner content
                      </div>
                    </MateoViewSurface>
                  }
                />
              </div>
              <div data-testid="outer-foreground" style={{ height: 500 }}>
                Outer content
              </div>
            </MateoViewSurface>
          }
        />
      ),
    },
  ]);
  await settleMateoGolden();
  for (const [id, position] of [
    ['outer-foreground', 100],
    ['nested-foreground', 80],
  ] as const) {
    const foreground = getMateoGoldenElement(id);
    const viewport = foreground.closest<HTMLElement>('[tabindex="0"]');
    const owner = foreground.parentElement;
    if (!viewport || !owner) throw new Error('Missing scroll owner');
    viewport.scrollTop = position;
    await settleMateoGolden();
    const metadata = getComputedStyle(owner);
    expect(metadata.maskImage).toContain('linear-gradient');
    expect(metadata.maskPosition).toBe(`0px ${viewport.scrollTop}px`);
    expect(metadata.maskSize).toBe(`100% ${viewport.clientHeight}px`);
    const child = getComputedStyle(foreground);
    expect(child.maskImage).toBe('none');
    expect(child.getPropertyValue('--mateo-boundary-mask')).toBe('none');
    expect(child.getPropertyValue('--mateo-mask-offset')).toBe('0px');
    expect(child.getPropertyValue('--mateo-viewport-height')).toBe('0px');
  }
});
