import {
  MateoDragResistance,
  type MateoDragResistanceReturnAnimation,
} from 'mateo-web-react/react';
import { Fragment } from 'react';
import { renderToStaticMarkup } from 'react-dom/server';
import { expect, it } from 'vitest';

it.each([-1, Infinity, NaN])(
  'should reject invalid resistance when receiving %s',
  (resistance) => {
    expect(() =>
      renderToStaticMarkup(
        <MateoDragResistance resistance={{ right: resistance }}>
          <div />
        </MateoDragResistance>,
      ),
    ).toThrow(TypeError);
  },
);

it('should require a native element when given a fragment', () => {
  expect(() =>
    renderToStaticMarkup(
      <MateoDragResistance>
        <Fragment key="unsupported">
          <div />
        </Fragment>
      </MateoDragResistance>,
    ),
  ).toThrow(TypeError);
});

it('should retain static content and native semantics when rendering without a browser', () => {
  const markup = renderToStaticMarkup(
    <MateoDragResistance>
      <section aria-label="Artwork">
        <a href="/details">Details</a>
      </section>
    </MateoDragResistance>,
  );
  expect(markup).toContain('aria-label="Artwork"');
  expect(markup).toContain('href="/details"');
  expect(markup).not.toContain('tabindex');
  expect(markup).not.toContain('role=');
});

const mateoInvalidResistance = (
  // @ts-expect-error Resistance uses directional limits in CSS pixels.
  <MateoDragResistance resistance="16px">
    <div />
  </MateoDragResistance>
);
const mateoInvalidDriven = (
  // @ts-expect-error The driven API is not supported.
  <MateoDragResistance dragOffset={{ x: 1, y: 0 }}>
    <g />
  </MateoDragResistance>
);
void mateoInvalidResistance;
void mateoInvalidDriven;

const mateoInvalidSide = (
  // @ts-expect-error Only physical screen sides are supported.
  <MateoDragResistance resistance={{ start: 16 }}>
    <div />
  </MateoDragResistance>
);
const mateoScalarResistance = (
  <MateoDragResistance resistance={16}>
    <div />
  </MateoDragResistance>
);
void mateoInvalidSide;
void mateoScalarResistance;

it.each([-1, Infinity, NaN])(
  'should reject invalid numeric shorthand when receiving %s',
  (resistance) => {
    expect(() =>
      renderToStaticMarkup(
        <MateoDragResistance resistance={resistance}>
          <div />
        </MateoDragResistance>,
      ),
    ).toThrow(TypeError);
  },
);

it.each([
  { name: 'negative duration', animation: { durationMs: -1 } },
  { name: 'infinite duration', animation: { durationMs: Infinity } },
  { name: 'NaN duration', animation: { durationMs: NaN } },
  { name: 'negative control point', animation: { curve: [-0.1, 0, 1, 1] } },
  { name: 'overshooting control point', animation: { curve: [0, 1.1, 1, 1] } },
  { name: 'infinite control point', animation: { curve: [0, 0, Infinity, 1] } },
  { name: 'NaN control point', animation: { curve: [0, NaN, 1, 1] } },
] satisfies readonly {
  name: string;
  animation: MateoDragResistanceReturnAnimation;
}[])('should reject return animation when receiving $name', ({ animation }) => {
  expect(() =>
    renderToStaticMarkup(
      <MateoDragResistance returnAnimation={animation}>
        <div />
      </MateoDragResistance>,
    ),
  ).toThrow(TypeError);
});

it.each([
  { name: 'null configuration', json: 'null' },
  { name: 'array configuration', json: '[]' },
  { name: 'string duration', json: '{"durationMs":"260"}' },
  { name: 'null duration', json: '{"durationMs":null}' },
  { name: 'short curve', json: '{"curve":[0,0,1]}' },
  { name: 'long curve', json: '{"curve":[0,0,1,1,1]}' },
  { name: 'string curve', json: '{"curve":"ease-out"}' },
  { name: 'null curve', json: '{"curve":null}' },
  { name: 'nonnumeric coordinate', json: '{"curve":[0,"0",1,1]}' },
])(
  'should reject invalid JavaScript return settings when receiving $name',
  ({ json }) => {
    // JSON represents JavaScript consumers whose inputs are not checked by TypeScript.
    const animation: MateoDragResistanceReturnAnimation = JSON.parse(json);
    expect(() =>
      renderToStaticMarkup(
        <MateoDragResistance returnAnimation={animation}>
          <div />
        </MateoDragResistance>,
      ),
    ).toThrow(TypeError);
  },
);
