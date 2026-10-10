import { getMateoThemeStyle } from '@mateo/web-react';
import {
  MateoView,
  MateoViewHeader,
  MateoViewSurface,
} from '@mateo/web-react/react';
import type { CSSProperties } from 'react';
import { expect, it } from 'vitest';
import { commands, page } from 'vitest/browser';
import { render } from 'vitest-browser-react';
import {
  captureMateoGolden,
  compareMateoGoldenGroup,
  getMateoGoldenElement,
  MateoGoldenGrid,
  type MateoGoldenScenario,
  mateoGoldenTheme,
  renderMateoGoldens,
  settleMateoGolden,
} from '../../../test/golden/mateo-golden.js';

function _createMateoSurfaceColorScenarios(
  color: string,
): readonly MateoGoldenScenario[] {
  const style: CSSProperties & {
    '--mateo-test-surface': string;
  } = {
    height: 260,
    background: `repeating-linear-gradient(45deg, ${mateoGoldenTheme.palette.accent[3]} 0 20px, ${mateoGoldenTheme.palette.neutral[3]} 20px 40px)`,
    '--mateo-test-surface': color,
  };
  return [
    {
      name: 'changing-surface',
      width: 320,
      content: (
        <div style={style}>
          <MateoView
            header={<MateoViewHeader principal="Updates" />}
            surface={
              <MateoViewSurface color="var(--mateo-test-surface)" padding={0}>
                <div style={{ height: 700 }}>
                  <input aria-label="Draft" defaultValue="My draft" />
                  {Array.from(
                    { length: 12 },
                    (_, index) => `Community update ${index + 1}`,
                  ).map((message) => (
                    <p key={message}>{message}</p>
                  ))}
                </div>
              </MateoViewSurface>
            }
          />
        </div>
      ),
    },
  ];
}

it('should preserve scroll and draft state when a CSS surface color changes between opaque and translucent', async () => {
  const result = await renderMateoGoldens(
    _createMateoSurfaceColorScenarios(mateoGoldenTheme.palette.white),
  );
  const viewport =
    getMateoGoldenElement('changing-surface').querySelector<HTMLElement>(
      '[tabindex="0"]',
    );
  if (!viewport) throw new Error('Missing changing surface viewport');
  await page.getByRole('textbox', { name: 'Draft' }).fill('Keep my draft');
  viewport.scrollTop = 120;
  for (const [name, color] of [
    ['Opaque CSS variable', mateoGoldenTheme.palette.white],
    [
      'Translucent CSS variable',
      `color-mix(in srgb, ${mateoGoldenTheme.palette.white} 55%, transparent)`,
    ],
    ['Opaque custom color', mateoGoldenTheme.palette.accent[2]],
  ] as const) {
    await result.rerender(
      <MateoGoldenGrid scenarios={_createMateoSurfaceColorScenarios(color)} />,
    );
    await settleMateoGolden();
    expect(viewport.scrollTop).toBe(120);
    await expect(page.getByRole('textbox', { name: 'Draft' })).toHaveValue(
      'Keep my draft',
    );
    await captureMateoGolden(name, 'changing-surface');
  }
  await compareMateoGoldenGroup('changing-surface-colors', 3);
});

it('should keep the fade anchored and bottom content visible when scroll event delivery lags behind native scrolling', async () => {
  await renderMateoGoldens([
    {
      name: 'busy-scroll',
      width: 320,
      height: 400,
      content: (
        <MateoView
          header={<MateoViewHeader principal="Updates" />}
          surface={
            <MateoViewSurface padding={0} extendBehindScrollbar>
              <div
                style={{
                  height: 2000,
                  background: mateoGoldenTheme.palette.accent[9],
                }}
              />
            </MateoViewSurface>
          }
        />
      ),
    },
  ]);
  const viewport =
    getMateoGoldenElement('busy-scroll').querySelector<HTMLElement>(
      '[tabindex="0"]',
    );
  if (!viewport) throw new Error('Missing busy scroll viewport');
  const captures: { name: string; image: string }[] = [];
  for (const [name, delta] of [
    ['Upward before scroll event delivery', -180],
    ['Downward before scroll event delivery', 180],
  ] as const) {
    viewport.scrollTop = 500;
    await settleMateoGolden();
    const capture = await commands.mateoCapturePendingScroll(
      'busy-scroll',
      delta,
    );
    expect(capture.after - capture.before).toBe(delta);
    captures.push({ name, image: capture.image });
  }
  const result = await render(
    <div
      data-testid="busy-scroll-captures"
      className="mateo-golden-grid mateo-golden-group"
      style={{
        ...getMateoThemeStyle(mateoGoldenTheme),
        color: mateoGoldenTheme.colorScheme.text.primary,
        gridTemplateColumns: 'repeat(2, max-content)',
      }}
    >
      {captures.map(({ name, image }) => (
        <figure className="mateo-golden-case" key={name}>
          <figcaption>{name}</figcaption>
          <img src={`data:image/png;base64,${image}`} alt={name} />
        </figure>
      ))}
    </div>,
  );
  try {
    await settleMateoGolden();
    await expect(page.getByTestId('busy-scroll-captures')).toMatchScreenshot(
      'busy-native-scroll',
    );
  } finally {
    await result.unmount();
  }
});

it('should paint the supplied translucent color at the boundary with and without a stationary header', async () => {
  await renderMateoGoldens(
    ['headered', 'headerless'].map((name) => ({
      name,
      width: 320,
      height: 260,
      content: (
        <div
          style={{
            height: '100%',
            background: `repeating-linear-gradient(135deg, ${mateoGoldenTheme.palette.accent[4]} 0 24px, ${mateoGoldenTheme.palette.neutral[6]} 24px 48px)`,
          }}
        >
          <MateoView
            header={
              name === 'headered' ? (
                <MateoViewHeader
                  principal={
                    <h2 style={{ margin: 0, fontSize: 18 }}>
                      Community updates
                    </h2>
                  }
                />
              ) : null
            }
            surface={
              <MateoViewSurface
                color={`color-mix(in srgb, ${mateoGoldenTheme.palette.white} 55%, transparent)`}
                shape={{ type: 'rounded', radius: 20 }}
                extendBehindScrollbar
              >
                {Array.from(
                  { length: 8 },
                  (_, index) => `Community update ${index + 1}`,
                ).map((message, index) => (
                  <p
                    key={message}
                    style={{
                      margin: '0 0 12px',
                      padding: 12,
                      minHeight: 64,
                      background:
                        index % 2 === 0
                          ? mateoGoldenTheme.palette.accent[3]
                          : mateoGoldenTheme.palette.neutral[3],
                    }}
                  >
                    {message}
                    <br />
                    Content continues beneath the boundary.
                  </p>
                ))}
              </MateoViewSurface>
            }
          />
        </div>
      ),
    })),
  );
  for (const name of ['headered', 'headerless']) {
    const viewport = getMateoGoldenElement(name).querySelector<HTMLElement>(
      '[data-mateo-overlay-scrollbar]',
    );
    if (!viewport) throw new Error('Missing translucent scroll viewport');
    for (const [pose, position] of [
      ['start', 0],
      ['middle', 120],
      ['end', viewport.scrollHeight],
    ] as const) {
      viewport.scrollTop = position;
      await settleMateoGolden();
      await captureMateoGolden(`${name}-${pose}`, name);
    }
  }
  await compareMateoGoldenGroup('translucent-scroll-masks', 3);
});
