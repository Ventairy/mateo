import {
  MateoView,
  MateoViewHeader,
  MateoViewSurface,
} from 'mateo-web-react/react';
import { StrictMode } from 'react';
import { expect, it, vi } from 'vitest';
import { commands, page, server, userEvent } from 'vitest/browser';
import {
  getMateoGoldenElement,
  renderMateoGoldens,
  settleMateoGolden,
} from '../../../test/golden/mateo-golden.js';
import { MateoScrollbarSample } from '../../../test/golden/mateo-scrollbar-fixture.js';

async function _renderMateoScrollbar(rtl = false) {
  await renderMateoGoldens([
    {
      name: 'scrollbar',
      width: 300,
      height: 230,
      content: (
        <StrictMode>
          <MateoScrollbarSample rtl={rtl} />
        </StrictMode>
      ),
    },
  ]);
  await settleMateoGolden();
  return getMateoGoldenElement('viewport');
}
function _getMateoTrack(axis: 'vertical' | 'horizontal') {
  const element = document.querySelector<HTMLElement>(
    `[role="scrollbar"][aria-orientation="${axis}"]`,
  );
  if (!element) throw new Error('Missing scrollbar');
  return element;
}

it('should scroll each native axis with accessible controls when using the keyboard', async () => {
  const viewport = await _renderMateoScrollbar();
  const vertical = _getMateoTrack('vertical');
  expect(vertical.getAttribute('aria-controls')).toBe(viewport.id);
  expect(vertical.getAttribute('aria-label')).toBe('Messages');
  expect(viewport.clientWidth).toBe(viewport.offsetWidth);
  await page
    .getByRole('scrollbar')
    .nth(0)
    .click({ position: { x: 6, y: 5 } });
  await userEvent.keyboard('[ArrowDown]');
  expect(viewport.scrollTop).toBe(40);
  await userEvent.keyboard('[PageDown]');
  expect(viewport.scrollTop).toBe(184);
  await userEvent.keyboard('[End]');
  expect(vertical.getAttribute('aria-valuenow')).toBe('100');
  await userEvent.keyboard('[Home]');
  expect(viewport.scrollTop).toBe(0);
  await page
    .getByRole('scrollbar')
    .nth(1)
    .click({ position: { x: 5, y: 6 } });
  await userEvent.keyboard('[ArrowRight]');
  expect(viewport.scrollLeft).toBe(40);
});

// Touch-enabled WebKit does not arrow-scroll a plain focused div either.
// Keep this platform behavior separate from the custom controls above.
it.skipIf(server.browser === 'webkit')(
  'should preserve native viewport keyboard scrolling when the overlay is attached',
  async () => {
    const viewport = await _renderMateoScrollbar();
    await commands.mateoScrollKeyboard('viewport');
    await expect.poll(() => viewport.scrollTop).toBeGreaterThan(0);
  },
);

it('should update controls and restore native scrolling when content, target, and ownership change', async () => {
  const viewport = await _renderMateoScrollbar();
  await page.getByRole('button', { name: 'Resize' }).click();
  await expect
    .poll(() => getComputedStyle(_getMateoTrack('vertical')).display)
    .toBe('none');
  expect(_getMateoTrack('vertical').tabIndex).toBe(-1);
  await page.getByRole('button', { name: 'Resize' }).click();
  await expect
    .poll(() => getComputedStyle(_getMateoTrack('vertical')).display)
    .toBe('block');
  await page.getByRole('button', { name: 'Replace' }).click();
  const replacement = getMateoGoldenElement('viewport');
  expect(replacement).not.toBe(viewport);
  expect(viewport.hasAttribute('data-mateo-overlay-scrollbar')).toBe(false);
  expect(viewport.hasAttribute('id')).toBe(false);
  expect(_getMateoTrack('vertical').getAttribute('aria-controls')).toBe(
    replacement.id,
  );
  await page.getByRole('button', { name: 'Toggle' }).click();
  expect(replacement.hasAttribute('data-mateo-overlay-scrollbar')).toBe(false);
  expect(document.querySelector('[role="scrollbar"]')).toBeNull();
});

it('should use logical horizontal positions when scrolling a right-to-left viewport', async () => {
  const viewport = await _renderMateoScrollbar(true);
  expect(_getMateoTrack('vertical').getBoundingClientRect().left).toBe(
    viewport.getBoundingClientRect().left,
  );
  await page
    .getByRole('scrollbar')
    .nth(1)
    .click({ position: { x: 220, y: 6 } });
  await userEvent.keyboard('[ArrowLeft]');
  expect(viewport.scrollLeft).toBe(-40);
  await userEvent.keyboard('[End]');
  expect(viewport.scrollLeft).toBe(-240);
  expect(_getMateoTrack('horizontal').getAttribute('aria-valuenow')).toBe(
    '100',
  );
  viewport.dir = 'ltr';
  await settleMateoGolden();
  await userEvent.keyboard('[Home][ArrowRight]');
  expect(viewport.scrollLeft).toBe(40);
  await userEvent.keyboard('[End]');
  expect(viewport.scrollLeft).toBe(240);
});

it('should restore native controls when forced colors become active', async () => {
  const viewport = await _renderMateoScrollbar();
  await commands.mateoForcedColors(true);
  await expect
    .poll(() => viewport.hasAttribute('data-mateo-overlay-scrollbar'))
    .toBe(false);
  expect(getComputedStyle(_getMateoTrack('vertical')).display).toBe('none');
  expect(_getMateoTrack('vertical').tabIndex).toBe(-1);
  await commands.mateoForcedColors(false);
  await expect
    .poll(() => viewport.hasAttribute('data-mateo-overlay-scrollbar'))
    .toBe(true);
});

it('should keep header clearance and focus reveal when a surface extends behind its scrollbar', async () => {
  await renderMateoGoldens([
    {
      name: 'view',
      width: 500,
      height: 300,
      content: (
        <MateoView
          header={<MateoViewHeader principal={<span>Header</span>} />}
          surface={
            <MateoViewSurface extendBehindScrollbar>
              <div style={{ height: 500 }} />
              <button type="button" data-testid="last">
                Last action
              </button>
              <div style={{ height: 500 }} />
            </MateoViewSurface>
          }
        />
      ),
    },
  ]);
  const button = getMateoGoldenElement('last');
  button.focus();
  await settleMateoGolden();
  const viewport = button.closest('[data-mateo-overlay-scrollbar]');
  if (!(viewport instanceof HTMLElement))
    throw new Error('Missing surface viewport');
  expect(viewport.scrollTop).toBeGreaterThan(0);
  const bounds = button.getBoundingClientRect();
  expect(bounds.top).toBeGreaterThan(viewport.getBoundingClientRect().top + 30);
  expect(bounds.bottom).toBeLessThanOrEqual(
    viewport.getBoundingClientRect().bottom,
  );
  expect(viewport.clientWidth).toBe(viewport.offsetWidth);
});

it.each(['vertical', 'horizontal'] as const)(
  'should drag the %s thumb within its range and stop when released or cancelled',
  async (axis) => {
    const viewport = await _renderMateoScrollbar();
    const _getMateoPosition = () =>
      axis === 'vertical' ? viewport.scrollTop : viewport.scrollLeft;
    await commands.mateoScrollbarDrag(axis, 300);
    expect(_getMateoPosition()).toBe(axis === 'vertical' ? 480 : 240);
    const track = _getMateoTrack(axis);
    expect(track.hasAttribute('data-dragging')).toBe(true);
    await commands.mateoPointerUp();
    expect(track.hasAttribute('data-dragging')).toBe(false);
    viewport.scrollTo({ top: 0, left: 0, behavior: 'instant' });
    await settleMateoGolden();
    let pointerId = 0;
    track.addEventListener(
      'pointerdown',
      (event) => {
        pointerId = event.pointerId;
      },
      { once: true },
    );
    await commands.mateoScrollbarDrag(axis, 20);
    const dragged = _getMateoPosition();
    track.dispatchEvent(new PointerEvent('pointercancel', { pointerId }));
    expect(track.hasAttribute('data-dragging')).toBe(false);
    await commands.mateoPointerUp();
    expect(_getMateoPosition()).toBe(dragged);
  },
);

it('should page toward a track press when pressing outside the thumb', async () => {
  const viewport = await _renderMateoScrollbar();
  await page
    .getByRole('scrollbar')
    .nth(0)
    .click({ position: { x: 6, y: 140 } });
  expect(viewport.scrollTop).toBe(144);
  await page
    .getByRole('scrollbar')
    .nth(1)
    .click({ position: { x: 220, y: 6 } });
  expect(viewport.scrollLeft).toBe(216);
});

it('should preserve an active drag when its list rerenders', async () => {
  await _renderMateoScrollbar();
  await commands.mateoScrollbarDrag('vertical', 20);
  const track = _getMateoTrack('vertical');
  expect(track.hasAttribute('data-dragging')).toBe(true);
  page
    .getByRole('button', { name: 'Refresh' })
    .element()
    .dispatchEvent(new MouseEvent('click', { bubbles: true }));
  await settleMateoGolden();
  expect(track.hasAttribute('data-dragging')).toBe(true);
  await commands.mateoPointerUp();
});

it('should return focus to the viewport when its focused control loses overflow', async () => {
  const viewport = await _renderMateoScrollbar();
  _getMateoTrack('vertical').focus();
  const content = viewport.firstElementChild;
  if (!(content instanceof HTMLElement))
    throw new Error('Missing scrolling content');
  content.style.width = '100px';
  content.style.height = '100px';
  await expect.poll(() => document.activeElement).toBe(viewport);
});

it('should return focus when cross-axis overflow leaves a focused control without track space', async () => {
  const viewport = await _renderMateoScrollbar();
  const content = viewport.firstElementChild;
  if (!(content instanceof HTMLElement))
    throw new Error('Missing scrolling content');
  viewport.style.height = '12px';
  content.style.width = '100px';
  content.style.height = '100px';
  await settleMateoGolden();
  const vertical = _getMateoTrack('vertical');
  vertical.focus();
  expect(document.activeElement).toBe(vertical);
  content.style.width = '480px';
  await expect.poll(() => document.activeElement).toBe(viewport);
  expect(vertical.tabIndex).toBe(-1);
});

it('should retain existing resize observations when content is inserted, moved, and removed', async () => {
  const observe = vi.spyOn(ResizeObserver.prototype, 'observe');
  const unobserve = vi.spyOn(ResizeObserver.prototype, 'unobserve');
  try {
    const viewport = await _renderMateoScrollbar();
    const content = viewport.firstElementChild;
    if (!(content instanceof HTMLElement))
      throw new Error('Missing scrolling content');
    const _countMateoObservations = (element: Element) =>
      observe.mock.calls.filter(([observed]) => observed === element).length;
    const viewportObservations = _countMateoObservations(viewport);
    const contentObservations = _countMateoObservations(content);
    const inserted = document.createElement('div');
    const nested = document.createElement('span');
    inserted.append(nested);
    content.append(inserted);
    await settleMateoGolden();
    expect(_countMateoObservations(viewport)).toBe(viewportObservations);
    expect(_countMateoObservations(content)).toBe(contentObservations);
    expect(_countMateoObservations(inserted)).toBe(1);
    expect(_countMateoObservations(nested)).toBe(1);
    content.append(nested);
    await settleMateoGolden();
    expect(_countMateoObservations(nested)).toBe(1);
    expect(unobserve.mock.calls.some(([element]) => element === nested)).toBe(
      false,
    );
    inserted.remove();
    nested.remove();
    await settleMateoGolden();
    expect(unobserve.mock.calls.some(([element]) => element === inserted)).toBe(
      true,
    );
    expect(unobserve.mock.calls.some(([element]) => element === nested)).toBe(
      true,
    );
  } finally {
    observe.mockRestore();
    unobserve.mockRestore();
  }
});

it('should avoid layout reads when content changes only its opacity', async () => {
  const viewport = await _renderMateoScrollbar();
  // Resize delivery can enqueue its first update after the initial painted frame.
  await settleMateoGolden();
  const content = viewport.firstElementChild;
  if (!(content instanceof HTMLElement))
    throw new Error('Missing scrolling content');
  const readHeight = vi.spyOn(Element.prototype, 'scrollHeight', 'get');
  try {
    for (const opacity of ['0.8', '0.5', '1']) {
      content.style.opacity = opacity;
      await settleMateoGolden();
    }
    expect(
      readHeight.mock.contexts.filter((element) => element === viewport),
    ).toHaveLength(0);
  } finally {
    readHeight.mockRestore();
  }
});

it('should coalesce style parsing and retain added observations when a native scroll already schedules an update', async () => {
  const viewport = await _renderMateoScrollbar();
  await settleMateoGolden();
  const content = viewport.firstElementChild;
  if (!(content instanceof HTMLElement))
    throw new Error('Missing scrolling content');
  const added = document.createElement('div');
  const parseStyle = vi.spyOn(CSSStyleDeclaration.prototype, 'cssText', 'set');
  const observe = vi.spyOn(ResizeObserver.prototype, 'observe');
  try {
    const scrolled = new Promise<void>((resolve) => {
      viewport.addEventListener(
        'scroll',
        () => {
          content.style.width = '520px';
          content.style.height = '720px';
          content.append(added);
          resolve();
        },
        { once: true },
      );
    });
    viewport.scrollTop = 40;
    await scrolled;
    await settleMateoGolden();
    expect(parseStyle).not.toHaveBeenCalled();
    expect(observe.mock.calls.some(([element]) => element === added)).toBe(
      true,
    );
  } finally {
    parseStyle.mockRestore();
    observe.mockRestore();
  }
});

it('should update the native range when absolute content moves, transforms, resizes, and is removed', async () => {
  const viewport = await _renderMateoScrollbar();
  const content = viewport.firstElementChild;
  if (!(content instanceof HTMLElement))
    throw new Error('Missing scrolling content');
  content.style.height = '100px';
  content.style.width = '100px';
  viewport.style.position = 'relative';
  const positioned = document.createElement('div');
  positioned.style.cssText =
    'position: absolute; top: 300px; width: 120px; font-size: 16px;';
  positioned.textContent = 'Messages';
  viewport.append(positioned);
  const _expectMateoNativeRange = async () => {
    await settleMateoGolden();
    _getMateoTrack('vertical').focus();
    await userEvent.keyboard('[End]');
    expect(viewport.scrollTop).toBe(
      viewport.scrollHeight - viewport.clientHeight,
    );
  };
  await _expectMateoNativeRange();
  positioned.style.top = '500px';
  await _expectMateoNativeRange();
  positioned.style.transform = 'translateY(200px)';
  await _expectMateoNativeRange();
  positioned.textContent = 'Messages '.repeat(30);
  await _expectMateoNativeRange();
  positioned.style.fontSize = '36px';
  await _expectMateoNativeRange();
  positioned.remove();
  await expect.poll(() => document.activeElement).toBe(viewport);
  expect(_getMateoTrack('vertical').tabIndex).toBe(-1);
});
