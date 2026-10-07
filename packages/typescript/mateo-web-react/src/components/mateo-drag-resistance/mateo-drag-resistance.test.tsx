import { MateoDragResistance } from 'mateo-web-react/react';
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
