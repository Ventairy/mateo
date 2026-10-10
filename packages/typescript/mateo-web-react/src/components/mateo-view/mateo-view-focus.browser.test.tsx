import {
  MateoPress,
  MateoView,
  MateoViewHeader,
  MateoViewSurface,
} from '@mateo/web-react/react';
import { type ReactNode, StrictMode } from 'react';
import { expect, it, vi } from 'vitest';
import { commands, server } from 'vitest/browser';
import {
  getMateoGoldenElement,
  renderMateoGoldens,
  settleMateoGolden,
} from '../../../test/golden/mateo-golden.js';

type MateoFocusControl =
  | 'custom press'
  | 'native press'
  | 'native button'
  | 'text input';

function _MateoFocusView({ children }: { readonly children: ReactNode }) {
  return (
    <MateoView
      header={<MateoViewHeader principal={<span>Header</span>} />}
      surface={
        <MateoViewSurface>
          <input aria-label="Before" data-testid="before" />
          <div style={{ height: 500 }} />
          {children}
          <input aria-label="After" data-testid="after" />
          <div style={{ height: 700 }} />
        </MateoViewSurface>
      }
    />
  );
}

async function _renderMateoFocusControl(
  kind: MateoFocusControl = 'native press',
  nested = false,
) {
  const activate = vi.fn();
  const label = <span style={{ display: 'block', height: 32 }}>Action</span>;
  const control =
    kind === 'native button' ? (
      <button type="button" data-testid="action" onClick={activate}>
        {label}
      </button>
    ) : kind === 'text input' ? (
      <input
        aria-label="Action"
        data-testid="action"
        style={{ height: 32 }}
        onClick={activate}
      />
    ) : kind === 'native press' ? (
      <MateoPress as="button" data-testid="action" onPressed={activate}>
        {label}
      </MateoPress>
    ) : (
      <MateoPress data-testid="action" onPressed={activate}>
        {label}
      </MateoPress>
    );
  const view = <_MateoFocusView>{control}</_MateoFocusView>;
  const result = await renderMateoGoldens([
    {
      name: 'focus',
      width: 600,
      height: 400,
      content: (
        <StrictMode>
          {nested ? (
            <_MateoFocusView>
              <div style={{ height: 300 }}>{view}</div>
            </_MateoFocusView>
          ) : (
            view
          )}
        </StrictMode>
      ),
    },
  ]);
  await settleMateoGolden();
  const action = getMateoGoldenElement('action');
  const viewport = action.closest<HTMLElement>(
    '[tabindex="0"].mateo\\:overflow-y-auto',
  );
  if (!viewport) throw new Error('Missing scroll viewport');
  await _placeMateoControlInFade(viewport, action);
  return { ...result, activate, action, viewport };
}

async function _placeMateoControlInFade(
  viewport: HTMLElement,
  action: HTMLElement,
) {
  viewport.scrollTop = 400;
  await settleMateoGolden();
  const clearTop = _mateoClearTop(viewport);
  viewport.scrollTop += action.getBoundingClientRect().top - (clearTop - 28);
  await settleMateoGolden();
}

function _mateoClearTop(viewport: HTMLElement) {
  return (
    viewport.getBoundingClientRect().top +
    Number.parseFloat(viewport.style.scrollPaddingBlockStart)
  );
}

for (const kind of [
  'custom press',
  'native press',
  'native button',
  'text input',
] as const) {
  it(`should activate once without moving when mouse pressing the center of a ${kind} in the header fade`, async () => {
    const { activate, action, viewport } = await _renderMateoFocusControl(kind);
    const position = viewport.scrollTop;
    const top = action.getBoundingClientRect().top;
    await commands.mateoPointerDown('action');
    const afterDown = viewport.scrollTop;
    await commands.mateoPointerUp();
    // WebKit on macOS intentionally does not focus ordinary buttons on click.
    if (kind !== 'native button' || server.browser !== 'webkit')
      expect(document.activeElement).toBe(action);
    expect.soft(afterDown).toBe(position);
    expect.soft(action.getBoundingClientRect().top).toBe(top);
    expect(activate).toHaveBeenCalledTimes(1);
  });

  it(`should preserve the target and activation when touch tapping a ${kind}`, async () => {
    const { activate, action, viewport } = await _renderMateoFocusControl(kind);
    const position = viewport.scrollTop;
    const events: string[] = [];
    for (const type of [
      'pointerdown',
      'pointerup',
      'mousedown',
      'focusin',
      'mouseup',
      'click',
    ]) {
      action.addEventListener(type, () => events.push(type));
    }
    await commands.mateoTouchTap('action');
    expect(viewport.scrollTop).toBe(position);
    expect(activate).toHaveBeenCalledTimes(1);
    if (kind === 'text input') {
      expect(document.activeElement).toBe(action);
      expect(events.indexOf('pointerup')).toBeLessThan(
        events.indexOf('mousedown'),
      );
      expect(events.indexOf('mousedown')).toBeLessThan(
        events.indexOf('focusin'),
      );
    }
  });
}

it.skipIf(server.browser !== 'chromium')(
  'should preserve focus and activation when pressing with a pen',
  async () => {
    const { activate, action, viewport } = await _renderMateoFocusControl();
    const position = viewport.scrollTop;
    await commands.mateoPenClick('action');
    expect(document.activeElement).toBe(action);
    expect(viewport.scrollTop).toBe(position);
    expect(activate).toHaveBeenCalledTimes(1);
  },
);

for (const key of ['Tab', 'Shift+Tab'] as const) {
  it(`should reveal the action when navigating with ${key} after a pointer interaction`, async () => {
    const { action, viewport } = await _renderMateoFocusControl('text input');
    await commands.mateoPointerDown('action');
    await commands.mateoPointerUp();
    getMateoGoldenElement(key === 'Tab' ? 'before' : 'after').focus({
      preventScroll: true,
    });
    await _placeMateoControlInFade(viewport, action);
    await commands.mateoFocusKey(key);
    expect(document.activeElement).toBe(action);
    expect(action.getBoundingClientRect().top).toBeGreaterThanOrEqual(
      _mateoClearTop(viewport) - 1,
    );
  });
}

it('should reveal validation focus when a pressed control focuses a different field before release', async () => {
  const { action, viewport } = await _renderMateoFocusControl('native button');
  const field = getMateoGoldenElement('before');
  action.addEventListener(
    'pointerdown',
    (event) => {
      event.preventDefault();
      field.focus({ preventScroll: true });
    },
    { once: true },
  );
  await commands.mateoPointerDown('action');
  await commands.mateoPointerUp();
  expect(viewport.scrollTop).toBeLessThan(100);
});

it('should reveal the same control when programmatically refocusing after a completed pointer interaction', async () => {
  const { action, viewport } = await _renderMateoFocusControl('text input');
  await commands.mateoTouchTap('action');
  action.blur();
  action.focus({ preventScroll: true });
  expect(action.getBoundingClientRect().top).toBeGreaterThanOrEqual(
    _mateoClearTop(viewport) - 1,
  );
});

for (const end of ['pointerup', 'pointercancel', 'blur', 'keydown'] as const) {
  it(`should reveal programmatic focus when an unfocused pointer contact ends with ${end}`, async () => {
    const { action, viewport } = await _renderMateoFocusControl('text input');
    action.addEventListener('mousedown', (event) => event.preventDefault(), {
      once: true,
    });
    await commands.mateoPointerDown('action');
    expect(document.activeElement).not.toBe(action);
    if (end === 'pointerup') await commands.mateoPointerUp();
    else if (end === 'blur') window.dispatchEvent(new Event('blur'));
    else if (end === 'keydown')
      action.dispatchEvent(
        new KeyboardEvent('keydown', { key: 'Escape', bubbles: true }),
      );
    else
      action.dispatchEvent(
        new PointerEvent('pointercancel', { pointerId: 1, bubbles: true }),
      );
    action.focus({ preventScroll: true });
    expect(action.getBoundingClientRect().top).toBeGreaterThanOrEqual(
      _mateoClearTop(viewport) - 1,
    );
    await commands.mateoPointerUp();
  });
}

it('should keep both scroll owners stationary when pressing a nested action', async () => {
  const { action, viewport, activate } = await _renderMateoFocusControl(
    'native press',
    true,
  );
  const outer = viewport.parentElement?.closest<HTMLElement>(
    '[tabindex="0"].mateo\\:overflow-y-auto',
  );
  if (!outer) throw new Error('Missing outer viewport');
  await _placeMateoControlInFade(outer, action);
  const positions = [outer.scrollTop, viewport.scrollTop];
  await commands.mateoPointerDown('action');
  await commands.mateoPointerUp();
  expect([outer.scrollTop, viewport.scrollTop]).toEqual(positions);
  expect(activate).toHaveBeenCalledTimes(1);
  action.blur();
  action.focus({ preventScroll: true });
  expect(action.getBoundingClientRect().top).toBeGreaterThanOrEqual(
    Math.max(_mateoClearTop(outer), _mateoClearTop(viewport)) - 1,
  );
});
