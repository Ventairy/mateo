import { createMateoTheme } from '@mateo/web-react';
import { MateoButton, MateoTheme } from '@mateo/web-react/react';
import type { MouseEvent } from 'react';
import { renderToStaticMarkup } from 'react-dom/server';
import { expect, it, vi } from 'vitest';
import { commands, page, userEvent } from 'vitest/browser';
import { renderMateoGoldens } from '../../../test/golden/mateo-golden.js';

// MateoPress owns the detailed native interaction contract. These cases guard
// MateoButton's forwarding and enabled link state at the public browser boundary.
for (const input of ['pointer', 'enter', 'modified', 'middle'] as const) {
  it(`should follow a button destination with ${input}`, async () => {
    const onPressed = vi.fn(() => new Promise<void>(() => {}));
    await renderMateoGoldens([
      {
        name: 'button-link-canvas',
        content: (
          <MateoButton
            as="a"
            href="about:blank#mateo-destination"
            target={
              input === 'modified' || input === 'middle' ? '_self' : '_blank'
            }
            rel="noopener"
            presentation={{ kind: 'label', label: 'Profile' }}
            data-testid="native-link"
            onPressed={onPressed}
          />
        ),
      },
    ]);
    expect(await commands.mateoFollowLink('native-link', input)).toBe(
      'about:blank#mateo-destination',
    );
    expect(onPressed).toHaveBeenCalledTimes(input === 'middle' ? 0 : 1);
  });
}

it('should let a callback cancel link navigation and leave Space for scrolling', async () => {
  const onPressed = vi.fn((event: MouseEvent<HTMLAnchorElement>) =>
    event.preventDefault(),
  );
  await renderMateoGoldens([
    {
      name: 'button-link-scroll',
      content: (
        <div
          data-testid="scroll-container"
          tabIndex={-1}
          style={{ height: 120, overflow: 'auto' }}
        >
          <MateoButton
            as="a"
            href="#profile"
            presentation={{ kind: 'label', label: 'Profile' }}
            data-testid="native-link"
            onPressed={onPressed}
          />
          <div style={{ height: 1000 }} />
        </div>
      ),
    },
  ]);
  const link = page.getByTestId('native-link').element();
  link.focus();
  await userEvent.keyboard('[Enter]');
  expect(onPressed).toHaveBeenCalledOnce();
  expect(window.location.hash).not.toBe('#profile');
  await userEvent.keyboard('[Space]');
  await expect
    .poll(() => page.getByTestId('scroll-container').element().scrollTop)
    .toBeGreaterThan(0);
  expect(onPressed).toHaveBeenCalledOnce();
});

it('should show and follow a styled button link without hydration or a callback', async () => {
  const markup = renderToStaticMarkup(
    <MateoTheme
      data={createMateoTheme({ accentColor: '#4A5CFF', onAccent: '#FFFFFF' })}
    >
      <MateoButton
        as="a"
        href="about:blank#mateo-destination"
        presentation={{ kind: 'label', label: 'Profile' }}
      />
    </MateoTheme>,
  );
  expect(await commands.mateoFollowStaticLink(markup)).toBe(
    'about:blank#mateo-destination',
  );
});
