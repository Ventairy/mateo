import {
  MateoView,
  MateoViewHeader,
  MateoViewSurface,
} from 'mateo-web-react/react';
import { StrictMode } from 'react';
import { expect, it } from 'vitest';
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
