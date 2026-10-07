import {
  createMateoTheme,
  getMateoThemeStyle,
  type MateoThemeData,
  mateoTypography,
} from 'mateo-web-react';
import { MateoTheme } from 'mateo-web-react/react';
import type { ReactNode } from 'react';
import { expect } from 'vitest';
import { commands, page } from 'vitest/browser';
import { render } from 'vitest-browser-react';

export const mateoGoldenTheme = createMateoTheme({
  accentColor: '#4A5CFF',
  onAccent: '#FFF',
});
export const mateoGoldenCustomTheme = createMateoTheme({
  accentColor: '#00865A',
  onAccent: '#FFF',
});

export interface MateoGoldenScenario {
  readonly name: string;
  readonly content: ReactNode;
  readonly width?: number;
  readonly height?: number;
  readonly dir?: 'ltr' | 'rtl';
}

export function MateoGoldenGrid({
  scenarios,
  theme = mateoGoldenTheme,
}: {
  readonly scenarios: readonly MateoGoldenScenario[];
  readonly theme?: MateoThemeData;
}) {
  return (
    <MateoTheme data={theme}>
      <div
        className="mateo-golden-grid"
        style={{
          ...getMateoThemeStyle(theme),
          color: theme.colorScheme.text.primary,
        }}
      >
        {scenarios.map(({ name, content, width, height, dir }) => (
          <figure className="mateo-golden-case" key={name}>
            <figcaption>{name}</figcaption>
            <div
              data-testid={name}
              className="mateo-golden-canvas"
              dir={dir}
              style={{
                width,
                height,
                background: theme.colorScheme.background,
              }}
            >
              {content}
            </div>
          </figure>
        ))}
      </div>
    </MateoTheme>
  );
}

export async function renderMateoGoldens(
  scenarios: readonly MateoGoldenScenario[],
  theme?: MateoThemeData,
) {
  return render(
    <MateoGoldenGrid
      scenarios={scenarios}
      {...(theme === undefined ? {} : { theme })}
    />,
  );
}

export async function settleMateoGolden() {
  await document.fonts.ready;
  // Composite faces leave unneeded character resources unloaded after layout.
  const inter = Array.from(document.fonts).find(
    (face) =>
      face.family === 'Inter' &&
      face.style === 'normal' &&
      face.status === 'loaded',
  );
  expect(inter?.status).toBe('loaded');
  for (const text of document.querySelectorAll(
    '.mateo-golden-canvas, .mateo-golden-case figcaption, .mateo-golden-canvas button, .mateo-golden-canvas input',
  )) {
    expect(getComputedStyle(text).fontFamily).toBe(mateoTypography.fontFamily);
  }
  await Promise.all(Array.from(document.images, (image) => image.decode()));
  // Let React commits and ResizeObserver-driven bounds reach the next painted frame.
  await new Promise<void>((resolve) =>
    requestAnimationFrame(() => requestAnimationFrame(() => resolve())),
  );
  // A state change can cancel one transition and start another in the same frame.
  for (;;) {
    const progressing = document
      .getAnimations()
      .filter(
        (animation) => animation.playState === 'running' || animation.pending,
      );
    if (progressing.length === 0) break;
    await Promise.allSettled(
      progressing.map((animation) =>
        animation.pending ? animation.ready : animation.finished,
      ),
    );
    await new Promise<void>((resolve) =>
      requestAnimationFrame(() => resolve()),
    );
  }
}

const mateoGoldenCaptures: { name: string; image: string }[] = [];

export function resetMateoGoldenCaptures() {
  mateoGoldenCaptures.length = 0;
}

// Freeze real rendered states before releasing input or resizing the next case.
export async function captureMateoGolden(name: string, testId = name) {
  const canvas = page.getByTestId(testId);
  canvas.element().scrollIntoView({ block: 'nearest' });
  await settleMateoGolden();
  mateoGoldenCaptures.push({
    name,
    image: await commands.mateoCaptureScenario(testId),
  });
}

export async function compareMateoGoldenGroup(name: string, columns = 3) {
  const captures = mateoGoldenCaptures.splice(0);
  expect(captures.length).toBeGreaterThan(0);
  const result = await render(
    <div
      data-testid="mateo-golden-group"
      className="mateo-golden-grid mateo-golden-group"
      style={{
        ...getMateoThemeStyle(mateoGoldenTheme),
        color: mateoGoldenTheme.colorScheme.text.primary,
        gridTemplateColumns: `repeat(${Math.min(columns, captures.length)}, max-content)`,
      }}
    >
      {captures.map((capture) => (
        <figure className="mateo-golden-case" key={capture.name}>
          <figcaption>{capture.name}</figcaption>
          <img
            src={`data:image/png;base64,${capture.image}`}
            alt={capture.name}
          />
        </figure>
      ))}
    </div>,
  );
  try {
    await settleMateoGolden();
    const bounds = page
      .getByTestId('mateo-golden-group')
      .element()
      .getBoundingClientRect();
    // Enlarge only the frozen contact sheet, preserving the live case viewport.
    await commands.mateoGroupViewport(
      Math.max(1280, Math.ceil(bounds.width)),
      Math.max(900, Math.ceil(bounds.height)),
    );
    await expect(page.getByTestId('mateo-golden-group')).toMatchScreenshot(
      name,
    );
  } finally {
    await result.unmount();
    await commands.mateoGroupViewport(1280, 900);
  }
}

export async function captureMateoGoldens(
  scenarios: readonly MateoGoldenScenario[],
  groupName: string,
  columns = 3,
) {
  for (const { name } of scenarios) await captureMateoGolden(name);
  await compareMateoGoldenGroup(groupName, columns);
}

export function getMateoGoldenElement(name: string) {
  const element = page.getByTestId(name).element();
  if (!(element instanceof HTMLElement))
    throw new Error(`Missing golden canvas: ${name}`);
  return element;
}
