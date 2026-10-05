import {
  MateoButton,
  MateoIcon,
  MateoTheme,
  MateoView,
  MateoViewHeader,
  type MateoViewPadding,
  MateoViewSurface,
} from 'mateo-web-react/react';
import { StrictMode, useState } from 'react';
import { hydrateRoot } from 'react-dom/client';
import { renderToString } from 'react-dom/server';
import { expect, it } from 'vitest';
import { page } from 'vitest/browser';
import {
  captureMateoGolden,
  captureMateoGoldens,
  compareMateoGoldenGroup,
  getMateoGoldenElement,
  type MateoGoldenScenario,
  mateoGoldenTheme,
  renderMateoGoldens,
  settleMateoGolden,
} from '../../../test/golden/mateo-golden.js';

interface MateoGoldenViewOptions {
  readonly header?:
    | 'none'
    | 'principal'
    | 'leading'
    | 'trailing'
    | 'both'
    | 'wrapped';
  readonly short?: boolean;
  readonly padding?: MateoViewPadding;
  readonly viewMaxWidth?: number;
  readonly headerMaxWidth?: number;
  readonly rounded?: boolean;
  readonly customBackground?: boolean;
}
function onMateoGoldenViewPressed() {}

function MateoGoldenView({
  header = 'both',
  short = false,
  padding,
  viewMaxWidth,
  headerMaxWidth,
  rounded = false,
  customBackground = false,
}: MateoGoldenViewOptions) {
  return (
    <MateoView
      {...(viewMaxWidth === undefined ? {} : { maxWidth: viewMaxWidth })}
      {...(padding === undefined ? {} : { padding })}
      header={
        header === 'none' ? null : (
          <MateoViewHeader
            {...(headerMaxWidth === undefined
              ? {}
              : { maxWidth: headerMaxWidth })}
            principal={
              <h1
                style={{
                  margin: 0,
                  fontSize: 16,
                  overflow: 'hidden',
                  textOverflow: 'ellipsis',
                  whiteSpace: header === 'wrapped' ? 'normal' : 'nowrap',
                }}
              >
                {header === 'wrapped' ? (
                  <span style={{ display: 'block', maxWidth: 128 }}>
                    Messages for my community
                  </span>
                ) : (
                  'Messages'
                )}
              </h1>
            }
            {...(header === 'leading' ||
            header === 'both' ||
            header === 'wrapped'
              ? {
                  leading: (
                    <MateoButton
                      presentation={{
                        kind: 'icon',
                        label: 'Back',
                        icon: <MateoIcon icon="arrowLeft" />,
                        size: 'mini',
                        variant: 'tertiary',
                      }}
                      onPressed={onMateoGoldenViewPressed}
                    />
                  ),
                }
              : {})}
            {...(header === 'trailing' || header === 'both'
              ? {
                  trailing: (
                    <MateoButton
                      presentation={{
                        kind: 'label',
                        label: 'Compose',
                        size: 'mini',
                        variant: 'secondary',
                      }}
                      onPressed={onMateoGoldenViewPressed}
                    />
                  ),
                }
              : {})}
          />
        )
      }
      surface={
        <MateoViewSurface
          {...(padding === undefined ? {} : { padding })}
          {...(rounded
            ? ({ shape: { type: 'rounded', radius: 24 } } as const)
            : {})}
          {...(customBackground
            ? {
                color:
                  mateoGoldenTheme.colorScheme.buttons.secondary.neutral
                    .background,
              }
            : {})}
        >
          <input
            aria-label="Draft"
            defaultValue="Keep this draft"
            style={{
              boxSizing: 'border-box',
              maxWidth: '100%',
              font: 'inherit',
            }}
          />
          <div style={{ height: short ? 64 : 640, flexShrink: 0 }}>
            {Array.from(
              { length: short ? 1 : 16 },
              (_, index) => `Community message ${index + 1}`,
            ).map((message) => (
              <p key={message} style={{ margin: '12px 0' }}>
                {message}
              </p>
            ))}
          </div>
          <button type="button">Last action</button>
        </MateoViewSurface>
      }
    />
  );
}

const mateoGoldenViewCases: readonly (MateoGoldenViewOptions & {
  readonly name: string;
  readonly width: number;
  readonly dir?: 'rtl';
})[] = [
  { name: 'wide', width: 656 },
  { name: 'narrow', width: 336 },
  { name: 'headerless', width: 336, header: 'none' },
  { name: 'principal-only', width: 336, header: 'principal' },
  { name: 'leading-only', width: 336, header: 'leading' },
  { name: 'trailing-only', width: 336, header: 'trailing' },
  { name: 'wrapped-header', width: 336, header: 'wrapped' },
  { name: 'short-content', width: 336, short: true },
  { name: 'headerless-short', width: 336, short: true, header: 'none' },
  { name: 'zero-padding', width: 336, padding: 0 },
  {
    name: 'logical-padding',
    width: 336,
    padding: { blockStart: 16, blockEnd: 24, inlineStart: 32, inlineEnd: 12 },
  },
  { name: 'width-caps', width: 672, viewMaxWidth: 480, headerMaxWidth: 360 },
  { name: 'inherited-cap', width: 656, viewMaxWidth: 480 },
  {
    name: 'larger-header-cap',
    width: 656,
    viewMaxWidth: 480,
    headerMaxWidth: 600,
  },
  { name: 'narrow-capped', width: 336, viewMaxWidth: 480 },
  { name: 'capped-short', width: 656, viewMaxWidth: 480, short: true },
  {
    name: 'capped-rounded-rtl',
    width: 656,
    viewMaxWidth: 480,
    rounded: true,
    customBackground: true,
    dir: 'rtl',
    padding: { inlineStart: 32, inlineEnd: 12, blockStart: 16, blockEnd: 24 },
  },
  { name: 'rtl', width: 336, dir: 'rtl' },
  {
    name: 'rounded-background',
    width: 336,
    rounded: true,
    customBackground: true,
  },
];

function getMateoGoldenViewGeometry(name: string) {
  const canvas = getMateoGoldenElement(name);
  const input = canvas.querySelector('input');
  const content = input?.parentElement;
  const viewport = content?.parentElement;
  if (!input || !content || !viewport) throw new Error('Missing view content');
  const header = viewport.querySelector('h1');
  const headerBox = header?.parentElement?.parentElement;
  return { canvas, input, content, viewport, header, headerBox };
}

it('should preserve header clearance and bounded content when composing view layouts', async () => {
  const scenarios = mateoGoldenViewCases.map(
    ({ name, width, dir, ...options }) => ({
      name,
      width,
      height: 416,
      ...(dir ? { dir } : {}),
      content: <MateoGoldenView {...options} />,
    }),
  );
  await renderMateoGoldens(scenarios);
  await settleMateoGolden();
  for (const {
    name,
    short,
    header: headerKind,
    padding,
    width,
    viewMaxWidth,
    headerMaxWidth,
  } of mateoGoldenViewCases) {
    const { input, content, viewport, header, headerBox } =
      getMateoGoldenViewGeometry(name);
    const top = input.getBoundingClientRect().top;
    const headerBottom =
      headerBox?.getBoundingClientRect().bottom ??
      viewport.getBoundingClientRect().top;
    const gap =
      padding === 0
        ? 0
        : typeof padding === 'object'
          ? (padding.blockStart ?? 0)
          : headerKind === 'none'
            ? 12
            : 20;
    expect(top - headerBottom).toBeCloseTo(gap, 0);
    if (short) {
      expect(viewport.scrollHeight).toBe(viewport.clientHeight);
      expect(content.getBoundingClientRect().bottom).toBeCloseTo(
        viewport.getBoundingClientRect().bottom,
        0,
      );
    }
    if (name === 'wide' || name === 'narrow') {
      if (!header) throw new Error('Missing principal heading');
      const heading = header.getBoundingClientRect();
      const bounds = viewport.getBoundingClientRect();
      expect(heading.left + heading.width / 2).toBeCloseTo(
        bounds.left + viewport.clientWidth / 2,
        0,
      );
    }
    const viewportBounds = viewport.getBoundingClientRect();
    const surface = viewport.parentElement;
    if (!surface) throw new Error('Missing view surface');
    expect(viewportBounds.width).toBe(width - 16);
    expect(surface.getBoundingClientRect().width).toBe(width - 16);
    // The content cap does not move the native scrollbar's owning viewport.
    expect(viewportBounds.right).toBe(surface.getBoundingClientRect().right);
    const availableWidth = viewport.clientWidth;
    const contentBounds = content.getBoundingClientRect();
    expect(contentBounds.width).toBe(
      Math.min(viewMaxWidth ?? availableWidth, availableWidth),
    );
    expect(contentBounds.left + contentBounds.width / 2).toBeCloseTo(
      viewportBounds.left + viewport.clientLeft + availableWidth / 2,
      0,
    );
    if (headerBox) {
      const bounds = headerBox.getBoundingClientRect();
      expect(bounds.width).toBe(
        Math.min(
          headerMaxWidth ?? availableWidth,
          viewMaxWidth ?? availableWidth,
          availableWidth,
        ),
      );
      expect(bounds.left + bounds.width / 2).toBeCloseTo(
        contentBounds.left + contentBounds.width / 2,
        0,
      );
    }
    if (name === 'capped-rounded-rtl') {
      await expect.element(surface).toHaveStyle({
        backgroundColor:
          mateoGoldenTheme.colorScheme.buttons.secondary.neutral.background,
      });
      expect(getComputedStyle(surface).clipPath).not.toBe('none');
      expect(getComputedStyle(content).paddingRight).toBe('32px');
      expect(getComputedStyle(content).paddingLeft).toBe('12px');
    }
  }
  await captureMateoGoldens(scenarios, 'view-layouts', 2);
});

it('should keep the header stationary and content focus visible when scrolling its surface', async () => {
  await renderMateoGoldens([
    { name: 'scroll', width: 336, height: 416, content: <MateoGoldenView /> },
  ]);
  await settleMateoGolden();
  const { viewport, header } = getMateoGoldenViewGeometry('scroll');
  const headerTop = header?.getBoundingClientRect().top;
  const maximum = viewport.scrollHeight - viewport.clientHeight;
  expect(maximum).toBeGreaterThan(0);
  for (const [name, fraction] of [
    ['scroll-top', 0],
    ['scroll-middle', 0.5],
    ['scroll-bottom', 1],
  ] as const) {
    viewport.scrollTop = maximum * fraction;
    await settleMateoGolden();
    expect(header?.getBoundingClientRect().top).toBe(headerTop);
    await captureMateoGolden(name, 'scroll');
  }
  viewport.scrollTop = 0;
  const lastAction = page
    .getByTestId('scroll')
    .getByRole('button', { name: 'Last action' });
  // Native focus scrolls the last control into the viewport's clear region.
  lastAction.element().focus();
  await settleMateoGolden();
  await expect.element(lastAction).toHaveFocus();
  expect(
    lastAction.element().getBoundingClientRect().bottom,
  ).toBeLessThanOrEqual(viewport.getBoundingClientRect().bottom);
  expect(
    lastAction.element().getBoundingClientRect().top,
  ).toBeGreaterThanOrEqual(
    header?.parentElement?.parentElement?.getBoundingClientRect().bottom ?? 0,
  );
  await captureMateoGolden('scroll-focused-last-action', 'scroll');
  await compareMateoGoldenGroup('view-scroll-states', 2);
});

function MateoGoldenResizingView() {
  const [expanded, setExpanded] = useState(false);
  return (
    <MateoView
      header={
        <MateoViewHeader
          leading={
            <button type="button" onClick={() => setExpanded(true)}>
              Expand
            </button>
          }
          principal={
            <h1
              style={{
                margin: 0,
                fontSize: 16,
                width: expanded ? 100 : undefined,
              }}
            >
              {expanded ? 'Messages for my community' : 'Messages'}
            </h1>
          }
        />
      }
      surface={
        <MateoViewSurface>
          <input aria-label="Draft" defaultValue="Keep this draft" />
          <p>Content follows the measured header.</p>
        </MateoViewSurface>
      }
    />
  );
}

it('should adjust clearance without losing draft state when the header grows', async () => {
  const scenarios: readonly MateoGoldenScenario[] = [
    {
      name: 'resized-header',
      width: 336,
      height: 416,
      content: <MateoGoldenResizingView />,
    },
  ];
  await renderMateoGoldens(scenarios);
  await settleMateoGolden();
  const before = getMateoGoldenViewGeometry('resized-header');
  const oldHeight = before.headerBox?.getBoundingClientRect().height ?? 0;
  await captureMateoGolden('original-header', 'resized-header');
  await page.getByRole('textbox', { name: 'Draft' }).fill('Preserved draft');
  await page.getByRole('button', { name: 'Expand' }).click();
  await settleMateoGolden();
  const after = getMateoGoldenViewGeometry('resized-header');
  expect(after.headerBox?.getBoundingClientRect().height).toBeGreaterThan(
    oldHeight,
  );
  expect(
    after.input.getBoundingClientRect().top -
      (after.headerBox?.getBoundingClientRect().bottom ?? 0),
  ).toBeCloseTo(20, 0);
  await expect
    .element(page.getByRole('textbox', { name: 'Draft' }))
    .toHaveValue('Preserved draft');
  await captureMateoGolden('resized-header');
  await compareMateoGoldenGroup('view-resized-header');
});

function MateoGoldenChangingWidthView() {
  const [maxWidth, setMaxWidth] = useState<number | undefined>(480);
  return (
    <MateoView
      {...(maxWidth === undefined ? {} : { maxWidth })}
      header={
        <MateoViewHeader
          principal={
            <h1 style={{ margin: 0 }}>
              <button
                type="button"
                onClick={() => setMaxWidth(maxWidth === 480 ? 360 : undefined)}
              >
                Change width
              </button>
            </h1>
          }
        />
      }
      surface={
        <MateoViewSurface>
          <input aria-label="Draft" defaultValue="Keep this draft" />
          <div style={{ height: 640, flexShrink: 0 }}>Messages</div>
          <button type="button">Last action</button>
        </MateoViewSurface>
      }
    />
  );
}

it('should preserve scrolling and draft state when changing or removing the content cap', async () => {
  await renderMateoGoldens([
    {
      name: 'changing-cap',
      width: 672,
      height: 416,
      content: <MateoGoldenChangingWidthView />,
    },
  ]);
  await settleMateoGolden();
  await page.getByRole('textbox', { name: 'Draft' }).fill('Preserved draft');
  for (const cap of [480, 360, undefined]) {
    const { content, viewport, headerBox } =
      getMateoGoldenViewGeometry('changing-cap');
    const width = Math.min(cap ?? viewport.clientWidth, viewport.clientWidth);
    expect(content.getBoundingClientRect().width).toBe(width);
    expect(headerBox?.getBoundingClientRect().width).toBe(width);
    expect(viewport.getBoundingClientRect().width).toBe(656);
    viewport.scrollTop = 120;
    await settleMateoGolden();
    const headerTop = headerBox?.getBoundingClientRect().top;
    if (cap !== undefined) {
      // Dispatch the cap change without the browser automation's scroll-into-view.
      const changeWidth = page
        .getByRole('button', { name: 'Change width' })
        .element();
      if (!(changeWidth instanceof HTMLButtonElement))
        throw new Error('Missing width control');
      changeWidth.click();
      await settleMateoGolden();
      expect(viewport.scrollTop).toBe(120);
      expect(headerBox?.getBoundingClientRect().top).toBe(headerTop);
    }
    await expect
      .element(page.getByRole('textbox', { name: 'Draft' }))
      .toHaveValue('Preserved draft');
  }
  const { viewport, headerBox } = getMateoGoldenViewGeometry('changing-cap');
  page.getByRole('button', { name: 'Last action' }).element().focus();
  await settleMateoGolden();
  const last = page
    .getByRole('button', { name: 'Last action' })
    .element()
    .getBoundingClientRect();
  expect(last.top).toBeGreaterThanOrEqual(
    headerBox?.getBoundingClientRect().bottom ?? 0,
  );
  expect(last.bottom).toBeLessThanOrEqual(
    viewport.getBoundingClientRect().bottom,
  );
});

it('should retain content bounds and header clearance when hydrating a capped view', async () => {
  const view = (
    <StrictMode>
      <MateoTheme data={mateoGoldenTheme}>
        <MateoGoldenView viewMaxWidth={480} header="wrapped" />
      </MateoTheme>
    </StrictMode>
  );
  await renderMateoGoldens([
    {
      name: 'hydrated-cap',
      width: 672,
      height: 416,
      content: (
        <div
          data-testid="hydrate-root"
          style={{ height: '100%' }}
          // biome-ignore lint/security/noDangerouslySetInnerHtml: Hydration fixture uses only React-rendered local markup.
          dangerouslySetInnerHTML={{ __html: renderToString(view) }}
        />
      ),
    },
  ]);
  await settleMateoGolden();
  const before = getMateoGoldenViewGeometry('hydrated-cap');
  const contentBounds = before.content.getBoundingClientRect();
  const inputTop = before.input.getBoundingClientRect().top;
  const errors: unknown[] = [];
  const root = hydrateRoot(page.getByTestId('hydrate-root').element(), view, {
    onRecoverableError: (error) => errors.push(error),
  });
  try {
    await settleMateoGolden();
    const after = getMateoGoldenViewGeometry('hydrated-cap');
    expect(errors).toEqual([]);
    expect(after.viewport.getBoundingClientRect().width).toBe(656);
    expect(after.content.getBoundingClientRect().width).toBe(
      contentBounds.width,
    );
    expect(after.content.getBoundingClientRect().left).toBe(contentBounds.left);
    expect(after.input.getBoundingClientRect().top).toBe(inputTop);
    expect(
      inputTop - (after.headerBox?.getBoundingClientRect().bottom ?? 0),
    ).toBeCloseTo(20, 0);
  } finally {
    root.unmount();
  }
});
