import {
  lerpMateoRoundedShape,
  type MateoRoundedShapeEndpoint,
} from 'mateo-web-react';
import { type MateoShape, MateoSurface } from 'mateo-web-react/react';
import { expect, it } from 'vitest';
import {
  captureMateoGolden,
  captureMateoGoldens,
  compareMateoGoldenGroup,
  getMateoGoldenElement,
  mateoGoldenTheme,
  renderMateoGoldens,
  settleMateoGolden,
} from '../../../test/golden/mateo-golden.js';

const mateoGoldenSurfaceShapes = [
  { name: 'rectangle', shape: 'none', width: 200, height: 96 },
  {
    name: 'rounded-wide',
    shape: { type: 'rounded', radius: 24 },
    width: 200,
    height: 96,
  },
  {
    name: 'rounded-tall',
    shape: { type: 'rounded', radius: 24 },
    width: 96,
    height: 160,
  },
  { name: 'capsule-wide', shape: 'capsule', width: 200, height: 64 },
  { name: 'capsule-tall', shape: 'capsule', width: 64, height: 160 },
  { name: 'circle', shape: 'capsule', width: 96, height: 96 },
] as const satisfies readonly {
  name: string;
  shape: MateoShape;
  width: number;
  height: number;
}[];

it('should share the outline between background and overflowing content when rendering supported shapes', async () => {
  const scenarios = mateoGoldenSurfaceShapes.map(
    ({ name, shape, width, height }) => ({
      name,
      content: (
        <MateoSurface
          width={width}
          height={height}
          shape={shape}
          color={mateoGoldenTheme.colorScheme.accent}
        >
          <div
            style={{
              width: width + 40,
              height: height / 2,
              background:
                mateoGoldenTheme.colorScheme.buttons.secondary.neutral
                  .background,
            }}
          />
        </MateoSurface>
      ),
    }),
  );
  await renderMateoGoldens(scenarios);
  await captureMateoGoldens(scenarios, 'surface-shapes');
});

it('should resolve content size and logical padding when fitting or filling a parent', async () => {
  const scenarios = [
    {
      name: 'fit',
      content: (
        <MateoSurface padding={16} color={mateoGoldenTheme.colorScheme.accent}>
          <span>Content-sized surface</span>
        </MateoSurface>
      ),
    },
    {
      name: 'fill',
      width: 256,
      height: 128,
      content: (
        <MateoSurface
          width="fill"
          height="fill"
          shape={{ type: 'rounded', radius: 24 }}
          padding={16}
          color={mateoGoldenTheme.colorScheme.accent}
        >
          Parent-sized surface
        </MateoSurface>
      ),
    },
    {
      name: 'logical-padding',
      dir: 'rtl' as const,
      content: (
        <MateoSurface
          padding="8px 12px"
          paddingBlock={24}
          paddingInline={32}
          color={mateoGoldenTheme.colorScheme.accent}
        >
          Logical padding
        </MateoSurface>
      ),
    },
    {
      name: 'theme-background',
      content: <MateoSurface padding={16}>Inherited background</MateoSurface>,
    },
  ];
  await renderMateoGoldens(scenarios);
  await settleMateoGolden();
  const surface = getMateoGoldenElement('fill').firstElementChild;
  expect(surface?.getBoundingClientRect().width).toBe(240);
  expect(surface?.getBoundingClientRect().height).toBe(112);
  await captureMateoGoldens(scenarios, 'surface-sizing');
});

it('should adapt its clipping outline when its parent changes dimensions', async () => {
  const createMateoResizeScenario = (width: number, height: number) => [
    {
      name: 'resized-parent',
      width,
      height,
      content: (
        <MateoSurface
          width="fill"
          height="fill"
          shape="capsule"
          color={mateoGoldenTheme.colorScheme.accent}
        >
          <div
            style={{
              height: '50%',
              width: '150%',
              background:
                mateoGoldenTheme.colorScheme.buttons.secondary.neutral
                  .background,
            }}
          />
        </MateoSurface>
      ),
    },
  ];
  const initial = await renderMateoGoldens(createMateoResizeScenario(256, 80));
  await settleMateoGolden();
  const before =
    getMateoGoldenElement(
      'resized-parent',
    ).firstElementChild?.getBoundingClientRect();
  await captureMateoGolden('wide-parent', 'resized-parent');
  const { MateoGoldenGrid } = await import(
    '../../../test/golden/mateo-golden.js'
  );
  await initial.rerender(
    <MateoGoldenGrid scenarios={createMateoResizeScenario(112, 176)} />,
  );
  await settleMateoGolden();
  const after =
    getMateoGoldenElement(
      'resized-parent',
    ).firstElementChild?.getBoundingClientRect();
  expect(before?.width).toBe(240);
  expect(after?.width).toBe(96);
  expect(after?.height).toBe(160);
  await captureMateoGolden('resized-parent');
  const parent = getMateoGoldenElement('resized-parent');
  parent.style.width = '112.25px';
  parent.style.height = '176.5px';
  parent.style.writingMode = 'vertical-rl';
  parent.style.transform = 'scale(0.8)';
  parent.style.transformOrigin = 'top left';
  await captureMateoGolden('vertical-fractional-scaled', 'resized-parent');
  await compareMateoGoldenGroup('surface-resize');
});

it('should preserve Mateo outlines and clipping when rendering interpolated rounded shape frames', async () => {
  const movements = [
    {
      name: 'pill orientation',
      begin: { width: 200, height: 56, shape: 'capsule' },
      end: { width: 56, height: 200, shape: 'capsule' },
      progress: [0, 0.5, 1],
    },
    {
      name: 'rounding loss',
      begin: { width: 96, height: 96, shape: { type: 'rounded', radius: 999 } },
      end: { width: 96, height: 96, shape: 'none' },
      progress: [0, 0.5, 1],
    },
    {
      name: 'size overshoot',
      begin: { width: 100, height: 100, shape: 'none' },
      end: { width: 200, height: 200, shape: { type: 'rounded', radius: 20 } },
      progress: [0, 1, 1.5],
    },
  ] as const satisfies readonly {
    name: string;
    begin: MateoRoundedShapeEndpoint;
    end: MateoRoundedShapeEndpoint;
    progress: readonly number[];
  }[];
  const scenarios = movements.flatMap(({ name, begin, end, progress }) =>
    progress.map((value) => {
      const frame = lerpMateoRoundedShape({ begin, end, progress: value });
      return {
        name: `${name} — ${value}`,
        content: (
          <MateoSurface {...frame} color={mateoGoldenTheme.colorScheme.accent}>
            <div
              style={{
                width: frame.width + 40,
                height: frame.height / 2,
                background:
                  mateoGoldenTheme.colorScheme.buttons.secondary.neutral
                    .background,
              }}
            />
          </MateoSurface>
        ),
      };
    }),
  );
  await renderMateoGoldens(scenarios);
  await captureMateoGoldens(scenarios, 'surface-rounded-interpolation');
});
