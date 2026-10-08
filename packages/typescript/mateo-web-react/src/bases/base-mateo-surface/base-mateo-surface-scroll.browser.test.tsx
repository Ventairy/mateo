import { MateoView, MateoViewSurface } from 'mateo-web-react/react';
import { expect, it } from 'vitest';
import {
  getMateoGoldenElement,
  renderMateoGoldens,
  settleMateoGolden,
} from '../../../test/golden/mateo-golden.js';

function _getMateoScrollElements(id: string) {
  const foreground = getMateoGoldenElement(id);
  const viewport = foreground.closest<HTMLElement>('[tabindex="0"]');
  const owner = foreground.parentElement;
  const fade = viewport?.firstElementChild?.firstElementChild;
  if (!viewport || !owner || !(fade instanceof HTMLElement))
    throw new Error('Missing scroll boundary');
  return { viewport, owner, fade };
}

it('should keep the fade at the viewport edge when scrolling, resizing, and revealing focused content', async () => {
  await renderMateoGoldens([
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
  const { viewport, owner, fade } = _getMateoScrollElements(
    'boundary-foreground',
  );
  expect(fade.getBoundingClientRect().height).toBe(0);
  viewport.scrollTop = 120;
  await settleMateoGolden();
  expect(fade.getBoundingClientRect().height).toBeGreaterThan(0);
  expect(fade.getBoundingClientRect().top).toBe(
    viewport.getBoundingClientRect().top,
  );
  expect(getComputedStyle(owner).maskImage).toBe('none');
  const oldHeight = viewport.clientHeight;
  getMateoGoldenElement('native-boundary').style.height = '260px';
  await settleMateoGolden();
  expect(viewport.clientHeight).toBeGreaterThan(oldHeight);
  expect(fade.getBoundingClientRect().top).toBe(
    viewport.getBoundingClientRect().top,
  );
  getMateoGoldenElement('boundary-focus').focus({ preventScroll: true });
  await settleMateoGolden();
  expect(viewport.scrollTop).toBeGreaterThan(120);
  const action =
    getMateoGoldenElement('boundary-focus').getBoundingClientRect();
  expect(action.top).toBeGreaterThanOrEqual(
    fade.getBoundingClientRect().bottom,
  );
  expect(action.bottom).toBeLessThanOrEqual(
    viewport.getBoundingClientRect().bottom,
  );
  viewport.scrollTop = 0;
  await settleMateoGolden();
  expect(fade.getBoundingClientRect().height).toBe(0);
});

it('should keep each fade at its own viewport edge when nested viewports scroll', async () => {
  await renderMateoGoldens([
    {
      name: 'boundary-isolation',
      width: 400,
      height: 220,
      content: (
        <MateoView
          surface={
            <MateoViewSurface padding={0}>
              <div style={{ height: 100 }} />
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
  const outer = _getMateoScrollElements('outer-foreground');
  const inner = _getMateoScrollElements('nested-foreground');
  outer.viewport.scrollTop = 80;
  inner.viewport.scrollTop = 100;
  await settleMateoGolden();
  for (const { viewport, owner, fade } of [outer, inner]) {
    expect(fade.getBoundingClientRect().top).toBe(
      viewport.getBoundingClientRect().top,
    );
    expect(fade.getBoundingClientRect().height).toBeGreaterThan(0);
    expect(getComputedStyle(owner).maskImage).toBe('none');
  }
  inner.viewport.scrollTop = 0;
  await settleMateoGolden();
  expect(inner.fade.getBoundingClientRect().height).toBe(0);
  expect(outer.fade.getBoundingClientRect().height).toBeGreaterThan(0);
});
