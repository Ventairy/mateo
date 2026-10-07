import {
  MateoView,
  MateoViewHeader,
  MateoViewSurface,
} from 'mateo-web-react/react';
import { it } from 'vitest';
import {
  captureMateoGolden,
  compareMateoGoldenGroup,
  getMateoGoldenElement,
  mateoGoldenTheme,
  renderMateoGoldens,
  settleMateoGolden,
} from '../../../test/golden/mateo-golden.js';

it('should reveal the true background through translucent masks with and without a stationary header', async () => {
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
