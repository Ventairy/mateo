import { MateoView, MateoViewSurface } from '@mateo/web-react/react';
import { it } from 'vitest';
import { commands } from 'vitest/browser';
import {
  captureMateoGolden,
  compareMateoGoldenGroup,
  getMateoGoldenElement,
  mateoGoldenCustomTheme,
  renderMateoGoldens,
  settleMateoGolden,
} from '../../../test/golden/mateo-golden.js';
import { MateoScrollbarSample } from '../../../test/golden/mateo-scrollbar-fixture.js';

it('should show stationary overlay controls when axes overflow and when interacting', async () => {
  for (const axis of ['vertical', 'horizontal', 'both', 'none'] as const) {
    const result = await renderMateoGoldens([
      {
        name: 'scrollbar',
        width: 260,
        height: 180,
        content: <MateoScrollbarSample controls={false} axis={axis} />,
      },
    ]);
    await captureMateoGolden(axis, 'scrollbar');
    await result.unmount();
  }
  const result = await renderMateoGoldens([
    {
      name: 'scrollbar',
      width: 260,
      height: 180,
      content: <MateoScrollbarSample controls={false} />,
    },
  ]);
  await commands.mateoScrollbarHover('viewport', 'vertical');
  await captureMateoGolden('Hover', 'scrollbar');
  await commands.mateoScrollbarDrag('vertical', 40);
  await captureMateoGolden('Dragging', 'scrollbar');
  await commands.mateoPointerUp();
  await commands.mateoResetInput();
  getMateoGoldenElement('viewport').focus();
  await commands.mateoFocusKey('Tab');
  await captureMateoGolden('Keyboard focus', 'scrollbar');
  await result.unmount();
  await compareMateoGoldenGroup('overlay-scrollbar-states', 3);
});

it('should retain theme colors and direction when overlaying a surface or an ordinary list', async () => {
  const custom = await renderMateoGoldens(
    [
      {
        name: 'scrollbar',
        width: 260,
        height: 180,
        content: <MateoScrollbarSample controls={false} rtl />,
      },
    ],
    mateoGoldenCustomTheme,
  );
  await captureMateoGolden('RTL custom theme', 'scrollbar');
  await custom.unmount();
  for (const enabled of [false, true]) {
    const result = await renderMateoGoldens([
      {
        name: 'view',
        width: 320,
        height: 180,
        content: (
          <MateoView
            padding={0}
            surface={
              <MateoViewSurface extendBehindScrollbar={enabled}>
                <div
                  style={{
                    height: 500,
                    width: '100%',
                    background: mateoGoldenCustomTheme.colorScheme.accent,
                  }}
                >
                  Content at the edge
                </div>
              </MateoViewSurface>
            }
          />
        ),
      },
    ]);
    await settleMateoGolden();
    await captureMateoGolden(
      enabled ? 'Content behind overlay' : 'Native gutter',
      'view',
    );
    await result.unmount();
  }
  await compareMateoGoldenGroup('overlay-scrollbar-layouts', 3);
});
