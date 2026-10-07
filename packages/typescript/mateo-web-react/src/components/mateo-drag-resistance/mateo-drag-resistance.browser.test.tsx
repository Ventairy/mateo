import {
  MateoDragResistance,
  type MateoDragResistanceProps,
} from 'mateo-web-react/react';
import { StrictMode, useRef, useState } from 'react';
import { expect, it } from 'vitest';
import { commands, page } from 'vitest/browser';
import { render } from 'vitest-browser-react';
import {
  mateoGoldenTheme,
  renderMateoGoldens,
  settleMateoGolden,
} from '../../../test/golden/mateo-golden.js';

function _getMateoTranslation() {
  const element = page.getByTestId('drag').element();
  const translate = getComputedStyle(element).translate;
  if (translate === 'none') return [0, 0];
  const [x = 0, y = 0] = translate.split(' ').map(Number.parseFloat);
  return [x, y];
}

function _MateoResistanceSample({
  svg = false,
  resistance = 16,
}: {
  readonly svg?: boolean;
  readonly resistance?: MateoDragResistanceProps['resistance'];
}) {
  // biome-ignore lint/correctness/useHookAtTopLevel: Private React fixture follows Mateo naming.
  const ref = useRef<HTMLDivElement>(null);
  // biome-ignore lint/correctness/useHookAtTopLevel: Private React fixture follows Mateo naming.
  const svgRef = useRef<SVGGElement>(null);
  // biome-ignore lint/correctness/useHookAtTopLevel: Private React fixture follows Mateo naming.
  const [count, setCount] = useState(0);
  // biome-ignore lint/correctness/useHookAtTopLevel: Private React fixture follows Mateo naming.
  const [mounted, setMounted] = useState(true);
  return (
    <>
      <button type="button" onClick={() => setCount(count + 1)}>
        Rerender
      </button>
      <button type="button" onClick={() => setMounted(false)}>
        Remove
      </button>
      <output data-testid="renders">{count}</output>
      <output data-testid="ref-status">{ref.current?.tagName}</output>
      {mounted &&
        (svg ? (
          <svg
            width="200"
            height="180"
            viewBox="0 0 400 360"
            aria-label="Artwork"
          >
            <MateoDragResistance resistance={resistance}>
              <g
                ref={svgRef}
                data-testid="drag"
                style={{ touchAction: 'none' }}
                transform="translate(20 20)"
              >
                <rect
                  width="200"
                  height="180"
                  fill={mateoGoldenTheme.colorScheme.accent}
                />
              </g>
            </MateoDragResistance>
          </svg>
        ) : (
          <MateoDragResistance resistance={resistance}>
            <div
              ref={ref}
              data-testid="drag"
              style={{
                width: 160,
                height: 120,
                touchAction: 'none',
                transform: 'scale(0.9)',
                background: mateoGoldenTheme.colorScheme.accent,
              }}
            >
              <button type="button" onClick={() => setCount(count + 1)}>
                Child action
              </button>
            </div>
          </MateoDragResistance>
        ))}
    </>
  );
}

for (const svg of [false, true]) {
  it(`should damp each axis and return without overshoot when dragging ${svg ? 'scaled SVG' : 'HTML'} content`, async () => {
    await commands.mateoGroupViewport(1000, 1000);
    await renderMateoGoldens([
      {
        name: 'sample',
        width: 900,
        height: 900,
        content: (
          <StrictMode>
            <div style={{ padding: 300 }}>
              <_MateoResistanceSample svg={svg} />
            </div>
          </StrictMode>
        ),
      },
    ]);
    await settleMateoGolden();
    const start = await commands.mateoDragPointer('drag', 96, -96);
    expect(_getMateoTranslation()[1]).toBeCloseTo(svg ? -16 : -8, 1);
    expect(_getMateoTranslation()[0]).toBeCloseTo(svg ? 16 : 8, 1);
    await commands.mateoMovePointer(start.x + 288, start.y - 288);
    expect(_getMateoTranslation()[0]).toBeCloseTo(svg ? 24 : 12, 1);
    expect(_getMateoTranslation()[1]).toBeCloseTo(svg ? -24 : -12, 1);
    await commands.mateoMovePointer(start.x - 96, start.y + 96);
    expect(_getMateoTranslation()[0]).toBeCloseTo(svg ? -16 : -8, 1);
    expect(_getMateoTranslation()[1]).toBeCloseTo(svg ? 16 : 8, 1);
    const target = page.getByTestId('drag').element();
    const samples: number[][] = [];
    let sampling = true;
    function _sampleMateoReturn() {
      samples.push(_getMateoTranslation());
      if (sampling) requestAnimationFrame(_sampleMateoReturn);
    }
    requestAnimationFrame(_sampleMateoReturn);
    await commands.mateoPointerUp();
    await expect.poll(() => _getMateoTranslation()).toEqual([0, 0]);
    sampling = false;
    expect(samples.length).toBeGreaterThan(1);
    for (const sample of samples) {
      expect(sample[0]).toBeLessThanOrEqual(0);
      expect(sample[1]).toBeGreaterThanOrEqual(0);
    }
    expect(getComputedStyle(target).willChange).toBe('auto');
    if (svg) expect(target.getAttribute('transform')).toBe('translate(20 20)');
    else expect(getComputedStyle(target).transform).not.toBe('none');
  });
}

it('should preserve the held offset and child ref when the owner rerenders', async () => {
  await render(<_MateoResistanceSample />);
  const start = await commands.mateoDragPointer('drag', 96, 0);
  expect(_getMateoTranslation()[0]).toBeCloseTo(8, 4);
  // Invoke the owner's native action without ending the captured pointer.
  const rerender = page
    .getByRole('button', { name: 'Rerender', exact: true })
    .element();
  if (!(rerender instanceof HTMLElement))
    throw new Error('Missing rerender action');
  rerender.click();
  await expect.element(page.getByTestId('renders')).toHaveTextContent('1');
  await expect.element(page.getByTestId('ref-status')).toHaveTextContent('DIV');
  expect(_getMateoTranslation()[0]).toBeCloseTo(8, 4);
  await commands.mateoMovePointer(start.x + 192, start.y);
  expect(_getMateoTranslation()[0]).toBeGreaterThan(8);
  await commands.mateoPointerUp();
  await expect.poll(() => _getMateoTranslation()[0]).toBe(0);
});

it('should clear motion and preserve native child activation when reduced motion changes', async () => {
  await render(<_MateoResistanceSample />);
  await commands.mateoDragPointer('drag', 96, 0);
  await commands.mateoReducedMotion();
  await expect.poll(() => _getMateoTranslation()[0]).toBe(0);
  await commands.mateoPointerUp();
  await page.getByRole('button', { name: 'Child action' }).click();
  await expect.element(page.getByTestId('renders')).toHaveTextContent('1');
  await commands.mateoDragPointer('drag', 96, 0);
  expect(_getMateoTranslation()).toEqual([0, 0]);
  await commands.mateoPointerUp();
});

it('should restore content and release capture when unmounted during a drag', async () => {
  await render(<_MateoResistanceSample />);
  const start = await commands.mateoDragPointer('drag', 96, 0);
  const target = page.getByTestId('drag').element();
  const remove = page.getByRole('button', { name: 'Remove' }).element();
  if (!(remove instanceof HTMLElement))
    throw new Error('Missing remove action');
  remove.click();
  await expect.element(page.getByTestId('drag')).not.toBeInTheDocument();
  expect(target.style.translate).toBe('');
  await commands.mateoMovePointer(start.x + 150, start.y);
  await commands.mateoPointerUp();
  expect(target.style.translate).toBe('');
});

it.each([
  { name: 'numeric zero', resistance: 0 },
  { name: 'an empty side configuration', resistance: {} },
])(
  'should leave content stationary when resistance is $name',
  async ({ resistance }) => {
    await render(<_MateoResistanceSample resistance={resistance} />);
    await commands.mateoDragPointer('drag', 96, 96);
    expect(_getMateoTranslation()).toEqual([0, 0]);
    await commands.mateoPointerUp();
  },
);

it.each([
  { side: 'top', x: 0, y: -96, offset: [0, -8] },
  { side: 'right', x: 96, y: 0, offset: [8, 0] },
  { side: 'bottom', x: 0, y: 96, offset: [0, 8] },
  { side: 'left', x: -96, y: 0, offset: [-8, 0] },
] as const)(
  'should yield only toward $side when the other sides are omitted',
  async ({ side, x, y, offset }) => {
    await commands.mateoGroupViewport(1000, 1000);
    await render(
      <div style={{ padding: 300 }}>
        <_MateoResistanceSample resistance={{ [side]: 16 }} />
      </div>,
    );
    const start = await commands.mateoDragPointer('drag', x, y);
    expect(_getMateoTranslation()).toEqual(offset);
    await commands.mateoMovePointer(start.x - x, start.y - y);
    expect(_getMateoTranslation()).toEqual([0, 0]);
    await commands.mateoMovePointer(start.x + (y || x), start.y + (x || y));
    const perpendicular = x ? 1 : 0;
    expect(_getMateoTranslation()[perpendicular]).toBe(0);
    await commands.mateoPointerUp();
    await expect.poll(_getMateoTranslation).toEqual([0, 0]);
  },
);

it('should use different limits after reversing an asymmetric diagonal pull', async () => {
  await commands.mateoGroupViewport(1000, 1000);
  await render(
    <div style={{ padding: 300 }}>
      <_MateoResistanceSample
        resistance={{ top: 24, right: 16, bottom: 0, left: 8 }}
      />
    </div>,
  );
  const start = await commands.mateoDragPointer('drag', 96, -96);
  expect(_getMateoTranslation()).toEqual([8, -12]);
  await commands.mateoMovePointer(start.x - 96, start.y + 96);
  expect(_getMateoTranslation()).toEqual([-4, 0]);
  await commands.mateoPointerUp();
  await expect.poll(_getMateoTranslation).toEqual([0, 0]);
});

it.each([
  { side: 'left', direction: -1 },
  { side: 'right', direction: 1 },
])(
  'should resume from the grabbed position when interrupting a return from the $side',
  async ({ direction }) => {
    await commands.mateoGroupViewport(1000, 1000);
    await render(
      <div style={{ padding: 300 }}>
        <_MateoResistanceSample resistance={{ left: 8, right: 16 }} />
      </div>,
    );
    await commands.mateoDragPointer('drag', direction * 96, 0);
    await commands.mateoPointerUp();
    const target = page.getByTestId('drag').element();
    let grabbed = 0;
    target.addEventListener(
      'pointerdown',
      () => {
        grabbed = _getMateoTranslation()[0] ?? 0;
      },
      { once: true },
    );
    await commands.mateoPointerDown('drag');
    expect(grabbed * direction).toBeGreaterThan(0);
    expect(_getMateoTranslation()[0]).toBe(grabbed);
    await new Promise((resolve) => setTimeout(resolve, 200));
    expect(_getMateoTranslation()[0]).toBe(grabbed);
    await commands.mateoPointerUp();
    await expect.poll(() => _getMateoTranslation()[0]).toBe(0);
  },
);

it('should settle when the window loses focus during a captured drag', async () => {
  await render(<_MateoResistanceSample />);
  await commands.mateoDragPointer('drag', 96, 0);
  window.dispatchEvent(new Event('blur'));
  await expect.poll(() => _getMateoTranslation()[0]).toBe(0);
  await commands.mateoPointerUp();
});
