import { MateoPress } from '@mateo/web-react/react';
import { renderToStaticMarkup } from 'react-dom/server';
import { expect, it, vi } from 'vitest';
import { commands, page, userEvent } from 'vitest/browser';
import { renderMateoGoldens } from '../../../test/golden/mateo-golden.js';

for (const input of ['pointer', 'enter', 'modified', 'middle'] as const) {
  it(`should follow the native destination when activating a link with ${input}`, async () => {
    const onPressed = vi.fn(() => new Promise<void>(() => {}));
    await renderMateoGoldens([
      {
        name: 'native-link-canvas',
        content: (
          <MateoPress
            as="a"
            href="about:blank#mateo-destination"
            target={
              input === 'modified' || input === 'middle' ? '_self' : '_blank'
            }
            data-testid="native-link"
            onPressed={onPressed}
          >
            Profile
          </MateoPress>
        ),
      },
    ]);
    expect(await commands.mateoFollowLink('native-link', input)).toBe(
      'about:blank#mateo-destination',
    );
    expect(onPressed).toHaveBeenCalledTimes(input === 'middle' ? 0 : 1);
  });
}

it('should keep Space available for scrolling when a native link has keyboard focus', async () => {
  const onPressed = vi.fn();
  await renderMateoGoldens([
    {
      name: 'space-scroll',
      content: (
        <div
          data-testid="scroll-container"
          tabIndex={-1}
          style={{ height: 120, overflow: 'auto' }}
        >
          <MateoPress
            as="a"
            href="#profile"
            data-testid="native-link"
            onPressed={onPressed}
          >
            Profile
          </MateoPress>
          <div style={{ height: 1000 }} />
        </div>
      ),
    },
  ]);
  await page.getByTestId('native-link').element().focus();
  await userEvent.keyboard('[Space]');
  await expect
    .poll(() => page.getByTestId('scroll-container').element().scrollTop)
    .toBeGreaterThan(0);
  expect(onPressed).not.toHaveBeenCalled();
});

it('should navigate without hydration when the server renders a native link', async () => {
  const markup = renderToStaticMarkup(
    <MateoPress as="a" href="about:blank#mateo-destination">
      Profile
    </MateoPress>,
  );
  expect(await commands.mateoFollowStaticLink(markup)).toBe(
    'about:blank#mateo-destination',
  );
});
