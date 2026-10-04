import { act, fireEvent, render, screen } from '@testing-library/react';
import { StrictMode, useState } from 'react';
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { createMateoTheme } from '../../theme/mateo-theme.js';
import { MateoTheme } from '../../theme/mateo-theme-context.js';
import { MateoSurface } from '../mateo-surface/mateo-surface.js';
import { MateoView } from './mateo-view.js';
import { MateoViewHeader } from './mateo-view-header.js';
import type { MateoViewPadding } from './mateo-view-padding.js';
import { MateoViewSurface } from './mateo-view-surface.js';

const mateoViewTestTheme = createMateoTheme({
  accentColor: '#4A5CFF',
  onAccent: '#FFF',
});
let mateoHeaderHeight = 48;
let mateoScrollHeight = 1000;
const mateoResizeCallbacks = new Set<() => void>();

beforeEach(() => {
  mateoHeaderHeight = 48;
  mateoScrollHeight = 1000;
  vi.spyOn(HTMLElement.prototype, 'offsetHeight', 'get').mockImplementation(
    function (this: HTMLElement) {
      return this.classList.contains('mateo:top-[0px]') ? mateoHeaderHeight : 0;
    },
  );
  vi.spyOn(HTMLElement.prototype, 'clientHeight', 'get').mockReturnValue(400);
  vi.spyOn(HTMLElement.prototype, 'scrollHeight', 'get').mockImplementation(
    () => mateoScrollHeight,
  );
  vi.stubGlobal(
    'ResizeObserver',
    class {
      constructor(private callback: () => void) {}
      observe() {
        mateoResizeCallbacks.add(this.callback);
      }
      disconnect() {
        mateoResizeCallbacks.delete(this.callback);
      }
    },
  );
});

afterEach(() => {
  vi.unstubAllGlobals();
  mateoResizeCallbacks.clear();
});

function resizeMateoView() {
  act(() => {
    for (const notify of mateoResizeCallbacks) notify();
  });
}

function MateoViewExample({
  header = true,
  padding,
  surfacePadding,
  headerPadding,
}: {
  readonly header?: boolean;
  readonly padding?: MateoViewPadding;
  readonly surfacePadding?: MateoViewPadding;
  readonly headerPadding?: MateoViewPadding;
}) {
  return (
    <MateoTheme data={mateoViewTestTheme}>
      <MateoView
        {...(padding === undefined ? {} : { padding })}
        header={
          header ? (
            <MateoViewHeader
              {...(headerPadding === undefined
                ? {}
                : { padding: headerPadding })}
              principal={<h1>Messages</h1>}
              leading={<button type="button">Back</button>}
            />
          ) : null
        }
        surface={
          <MateoViewSurface
            {...(surfacePadding === undefined
              ? {}
              : { padding: surfacePadding })}
          >
            <p>First message</p>
            <MateoSurface data-testid="card">A separate surface</MateoSurface>
          </MateoViewSurface>
        }
      />
    </MateoTheme>
  );
}

function getMateoViewContent() {
  const content = screen.getByText('First message').parentElement;
  if (!content) throw new Error('Missing content container.');
  return content;
}

it('should keep content below the measured header when using inherited view spacing', () => {
  render(<MateoViewExample />);
  expect(getMateoViewContent()).toHaveStyle({
    paddingBlockStart: '68px',
    paddingBlockEnd: '12px',
    paddingInlineStart: '20px',
    paddingInlineEnd: '20px',
  });
  expect(screen.getByRole('heading', { name: 'Messages' })).toHaveProperty(
    'tagName',
    'H1',
  );
  expect(screen.getByRole('button', { name: 'Back' })).toBeEnabled();
  expect(screen.getByTestId('card')).toHaveStyle({
    padding: '0px',
    width: 'fit-content',
    height: 'fit-content',
    backgroundColor: mateoViewTestTheme.colorScheme.background,
  });
});

it('should use the top view padding when no header is present', () => {
  const { rerender } = render(<MateoViewExample />);
  rerender(
    <MateoViewExample
      header={false}
      padding={{ blockStart: 9, blockEnd: 7, inlineStart: 24, inlineEnd: 32 }}
    />,
  );
  expect(getMateoViewContent()).toHaveStyle({
    paddingBlockStart: '9px',
    paddingBlockEnd: '7px',
    paddingInlineStart: '24px',
    paddingInlineEnd: '32px',
  });
  expect(screen.queryByRole('heading')).toBeNull();
});

it('should retain header clearance when explicit surface padding removes every gap', () => {
  const { rerender } = render(<MateoViewExample surfacePadding={0} />);
  expect(getMateoViewContent()).toHaveStyle({
    paddingBlockStart: '48px',
    paddingBlockEnd: '0px',
    paddingInlineStart: '0px',
    paddingInlineEnd: '0px',
  });
  rerender(
    <MateoViewExample surfacePadding={{ blockStart: 8, inlineEnd: 6 }} />,
  );
  expect(getMateoViewContent()).toHaveStyle({
    paddingBlockStart: '56px',
    paddingBlockEnd: '0px',
    paddingInlineStart: '0px',
    paddingInlineEnd: '6px',
  });
});

it('should replace inherited header padding when a local value is supplied', () => {
  render(
    <MateoViewExample
      padding={30}
      headerPadding={{ inlineStart: 4, blockEnd: 5 }}
    />,
  );
  const header = screen.getByRole('heading').parentElement?.parentElement;
  expect(header).toHaveStyle({
    paddingInlineStart: '4px',
    paddingInlineEnd: '0px',
    paddingBlockStart: '0px',
    paddingBlockEnd: '5px',
  });
});

function MateoStatefulViewContent() {
  const [value, setValue] = useState('Draft');
  return (
    <input
      aria-label="Message"
      value={value}
      onChange={(event) => setValue(event.target.value)}
    />
  );
}

it('should update header clearance without resetting content state when its measured height changes', () => {
  const { unmount } = render(
    <StrictMode>
      <MateoTheme data={mateoViewTestTheme}>
        <MateoView
          header={<MateoViewHeader principal="Messages" />}
          surface={
            <MateoViewSurface>
              <MateoStatefulViewContent />
            </MateoViewSurface>
          }
        />
      </MateoTheme>
    </StrictMode>,
  );
  const input = screen.getByRole('textbox', { name: 'Message' });
  fireEvent.change(input, { target: { value: 'Keep this draft' } });
  mateoHeaderHeight = 92;
  resizeMateoView();
  expect(input.parentElement).toHaveStyle({ paddingBlockStart: '112px' });
  expect(input).toHaveValue('Keep this draft');
  unmount();
  expect(mateoResizeCallbacks.size).toBe(0);
});

it('should anchor fades to the viewport and keep scrollbars outside the mask when content scrolls', () => {
  render(<MateoViewExample />);
  const content = getMateoViewContent();
  const viewport = content.parentElement;
  if (!viewport) throw new Error('Missing scroll viewport.');
  expect(viewport).toHaveAttribute('tabindex', '0');
  expect(viewport.style.maskImage).toBe('');
  const restingMask = content.style.getPropertyValue('--mateo-boundary-mask');
  expect(restingMask).toContain('linear-gradient');
  viewport.scrollTop = 100;
  fireEvent.scroll(viewport);
  expect(content.style.getPropertyValue('--mateo-scroll-position')).toBe(
    '100px',
  );
  expect(content.style.getPropertyValue('--mateo-boundary-mask')).not.toBe(
    restingMask,
  );
  expect(
    screen.getByRole('button', { name: 'Back' }).closest<HTMLElement>('[style]')
      ?.style.maskImage,
  ).toBe('');
  viewport.scrollTop = 600;
  fireEvent.scroll(viewport);
  expect(content.style.getPropertyValue('--mateo-boundary-mask')).toContain(
    '#000 400px',
  );
});

it('should remove overflow fades when content becomes shorter than the viewport', () => {
  render(<MateoViewExample header={false} />);
  mateoScrollHeight = 400;
  resizeMateoView();
  expect(
    getMateoViewContent().style.getPropertyValue('--mateo-boundary-mask'),
  ).toBe('none');
});

describe.each(['view', 'header', 'surface'] as const)('%s padding', (owner) => {
  it.each([-1, NaN, Infinity])(
    'should reject invalid padding %s when rendering',
    (value) => {
      const props =
        owner === 'view'
          ? { padding: value }
          : owner === 'header'
            ? { headerPadding: value }
            : { surfacePadding: value };
      expect(() => render(<MateoViewExample {...props} />)).toThrow(
        'finite and nonnegative',
      );
    },
  );
});

it('should require view ownership when rendering a view surface or header', () => {
  expect(() => render(<MateoViewHeader principal="Messages" />)).toThrow(
    'MateoView ancestor',
  );
  expect(() => render(<MateoViewSurface>Content</MateoViewSurface>)).toThrow(
    'MateoView ancestor',
  );
});
