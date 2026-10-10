import { getMateoThemeStyle, type MateoThemeData } from '@mateo/web-react';
import { expect, it } from 'vitest';
import { commands } from 'vitest/browser';
import { render } from 'vitest-browser-react';
import {
  captureMateoGolden,
  compareMateoGoldenGroup,
  getMateoGoldenElement,
  mateoGoldenCustomTheme,
  mateoGoldenTheme,
  renderMateoGoldens,
} from '../../test/golden/mateo-golden.js';

function getMateoScrollbarRgb(color: string) {
  const sample = document.createElement('span');
  sample.style.color = color;
  return sample.style.color;
}

function MateoScrollbarSample({
  name,
  theme,
}: {
  readonly name: string;
  readonly theme?: MateoThemeData;
}) {
  return (
    <div
      data-testid={name}
      // biome-ignore lint/a11y/noNoninteractiveTabindex: Native scroll regions support keyboard scrolling.
      tabIndex={0}
      style={{
        ...(theme ? getMateoThemeStyle(theme) : {}),
        width: 240,
        height: 160,
        overflow: 'scroll',
      }}
    >
      <div style={{ width: 480, height: 480 }}>
        Scroll to explore more content.
      </div>
    </div>
  );
}

it('should paint neutral thumbs and transparent tracks when hovering native scrollbars', async () => {
  const result = await renderMateoGoldens([
    {
      name: 'scrollbar',
      width: 256,
      content: <MateoScrollbarSample name="scrollbar-viewport" />,
    },
  ]);
  const viewport = getMateoGoldenElement('scrollbar-viewport');
  expect(viewport.offsetWidth - viewport.clientWidth).toBe(12);
  expect(viewport.offsetHeight - viewport.clientHeight).toBe(12);
  expect(viewport.scrollHeight).toBeGreaterThan(viewport.clientHeight);
  expect(viewport.scrollWidth).toBeGreaterThan(viewport.clientWidth);
  expect(
    getComputedStyle(viewport, '::-webkit-scrollbar-thumb').backgroundColor,
  ).toBe(getMateoScrollbarRgb(mateoGoldenTheme.colorScheme.scrollbar.thumb));
  expect(
    getComputedStyle(viewport, '::-webkit-scrollbar-track').backgroundColor,
  ).toBe('rgba(0, 0, 0, 0)');
  await captureMateoGolden('rest', 'scrollbar');
  for (const axis of ['vertical', 'horizontal'] as const) {
    await commands.mateoScrollbarHover('scrollbar-viewport', axis);
    await captureMateoGolden(`${axis}-hover`, 'scrollbar');
  }
  await commands.mateoScrollKeyboard('scrollbar-viewport');
  await expect.poll(() => viewport.scrollTop).toBeGreaterThan(0);
  await result.unmount();
  await compareMateoGoldenGroup('native-scrollbars', 3);
});

it('should inherit scrollbar colors in native fields and preserve outside controls when styling theme roots', async () => {
  const result = await render(
    <>
      <MateoScrollbarSample name="outside-scrollbar" />
      <div style={getMateoThemeStyle(mateoGoldenTheme)}>
        <MateoScrollbarSample name="inherited-scrollbar" />
        <div style={getMateoThemeStyle(mateoGoldenCustomTheme)}>
          <textarea
            data-testid="scrollbar-textarea"
            aria-label="Scrollable notes"
            defaultValue={Array(30).fill('Scrollable notes').join('\n')}
          />
        </div>
      </div>
      <MateoScrollbarSample name="root-scrollbar" theme={mateoGoldenTheme} />
    </>,
  );
  const outside = getMateoGoldenElement('outside-scrollbar');
  const inherited = getMateoGoldenElement('inherited-scrollbar');
  const field = getMateoGoldenElement('scrollbar-textarea');
  expect(getComputedStyle(outside).scrollbarColor).toBe('auto');
  expect(
    getComputedStyle(outside, '::-webkit-scrollbar-thumb').backgroundColor,
  ).toBe('rgba(0, 0, 0, 0)');
  for (const element of [
    inherited,
    field,
    getMateoGoldenElement('root-scrollbar'),
  ]) {
    expect(
      getComputedStyle(element, '::-webkit-scrollbar-thumb').backgroundColor,
    ).toBe(getMateoScrollbarRgb(mateoGoldenTheme.colorScheme.scrollbar.thumb));
  }
  expect(field.scrollHeight).toBeGreaterThan(field.clientHeight);
  await commands.mateoForcedColors(true);
  expect(getComputedStyle(inherited).scrollbarColor).toBe(
    getComputedStyle(outside).scrollbarColor,
  );
  expect(
    getComputedStyle(inherited, '::-webkit-scrollbar-thumb').backgroundColor,
  ).toBe(
    getComputedStyle(outside, '::-webkit-scrollbar-thumb').backgroundColor,
  );
  await result.unmount();
});
