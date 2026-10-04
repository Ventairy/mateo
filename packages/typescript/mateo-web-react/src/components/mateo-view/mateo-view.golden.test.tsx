import {
  MateoButton,
  MateoIcon,
  MateoView,
  MateoViewHeader,
  type MateoViewPadding,
  MateoViewSurface,
} from 'mateo-web-react/react';
import { useState } from 'react';
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
  { name: 'width-caps', width: 656, viewMaxWidth: 480, headerMaxWidth: 360 },
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
        bounds.left + bounds.width / 2,
        0,
      );
    }
    if (name === 'width-caps') {
      expect(viewport.getBoundingClientRect().width).toBe(480);
      expect(headerBox?.getBoundingClientRect().width).toBe(360);
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
