// @vitest-environment node
import { describe, expect, it } from 'vitest';
import {
  lerpMateoRoundedShape,
  type MateoRoundedShapeEndpoint,
} from '../../mateo.js';

const mateoPill: MateoRoundedShapeEndpoint = {
  width: 200,
  height: 56,
  shape: 'capsule',
};

it.each([
  [0, 200, 56],
  [0.25, 164, 92],
  [0.5, 128, 128],
  [0.75, 92, 164],
  [1, 56, 200],
])(
  'should produce bounds %s, %s × %s when pills exchange orientation',
  (progress, width, height) => {
    expect(
      lerpMateoRoundedShape({
        begin: mateoPill,
        end: { width: 56, height: 200, shape: 'capsule' },
        progress,
      }),
    ).toEqual({ width, height, shape: { type: 'rounded', radius: 28 } });
  },
);

it('should blend visible radii when a requested radius exceeds its endpoint bounds', () => {
  const begin: MateoRoundedShapeEndpoint = {
    width: 96,
    height: 96,
    shape: { type: 'rounded', radius: 999 },
  };
  const end: MateoRoundedShapeEndpoint = {
    width: 96,
    height: 96,
    shape: 'none',
  };
  for (const [progress, radius] of [
    [0, 48],
    [0.5, 24],
    [1, 0],
    [1.3, 0],
  ] as const) {
    expect(lerpMateoRoundedShape({ begin, end, progress })).toEqual({
      width: 96,
      height: 96,
      shape: { type: 'rounded', radius },
    });
  }
});

it('should return exact resolved endpoints when progress is zero or one', () => {
  const begin: MateoRoundedShapeEndpoint = {
    width: 123.456789012345,
    height: 17.234567890123,
    shape: 'capsule',
  };
  const end: MateoRoundedShapeEndpoint = {
    width: 987.654321098765,
    height: 65.432109876543,
    shape: { type: 'rounded', radius: Math.PI },
  };
  expect(lerpMateoRoundedShape({ begin, end, progress: 0 })).toEqual({
    width: begin.width,
    height: begin.height,
    shape: { type: 'rounded', radius: begin.height / 2 },
  });
  expect(lerpMateoRoundedShape({ begin, end, progress: 1 })).toEqual(end);
});

it('should remain stationary when resolved endpoints agree even at extreme progress', () => {
  for (const progress of [-1e308, 0.5, 1e308]) {
    expect(
      lerpMateoRoundedShape({
        begin: { width: 96, height: 96, shape: 'capsule' },
        end: { width: 96, height: 96, shape: { type: 'rounded', radius: 999 } },
        progress,
      }),
    ).toEqual({
      width: 96,
      height: 96,
      shape: { type: 'rounded', radius: 48 },
    });
  }
  expect(
    lerpMateoRoundedShape({
      begin: { width: 1, height: 100, shape: 'none' },
      end: { width: 2, height: 100, shape: 'none' },
      progress: 1e100,
    }),
  ).toEqual({
    width: 1e100,
    height: 100,
    shape: { type: 'rounded', radius: 0 },
  });
});

it.each([
  [-0.1, 90, 0],
  [1.1, 210, 22],
  [1.5, 250, 30],
  [2, 300, 40],
])(
  'should extrapolate to %s, width %s and radius %s when progress passes an endpoint',
  (progress, width, radius) => {
    const frame = lerpMateoRoundedShape({
      begin: { width: 100, height: 100, shape: 'none' },
      end: { width: 200, height: 200, shape: { type: 'rounded', radius: 20 } },
      progress,
    });
    expect(frame.width).toBeCloseTo(width, 10);
    expect(frame.height).toBeCloseTo(width, 10);
    expect(frame.shape.radius).toBeCloseTo(radius, 10);
  },
);

it('should fit extrapolated rounding when the radius reaches the current bounds', () => {
  expect(
    lerpMateoRoundedShape({
      begin: { width: 100, height: 40, shape: 'none' },
      end: { width: 100, height: 40, shape: { type: 'rounded', radius: 20 } },
      progress: 100,
    }),
  ).toEqual({ width: 100, height: 40, shape: { type: 'rounded', radius: 20 } });
});

it('should retrace the same frame when endpoint order and progress are reversed', () => {
  const begin: MateoRoundedShapeEndpoint = {
    width: 300,
    height: 50,
    shape: 'capsule',
  };
  const end: MateoRoundedShapeEndpoint = {
    width: 96,
    height: 96,
    shape: { type: 'rounded', radius: 10 },
  };
  const expected = {
    width: 249,
    height: 61.5,
    shape: { type: 'rounded', radius: 21.25 },
  };
  expect(lerpMateoRoundedShape({ begin, end, progress: 0.25 })).toEqual(
    expected,
  );
  expect(
    lerpMateoRoundedShape({ begin: end, end: begin, progress: 0.75 }),
  ).toEqual(expected);
});

it('should scale the frame uniformly when all endpoint lengths are doubled', () => {
  expect(
    lerpMateoRoundedShape({
      begin: { width: 600, height: 100, shape: 'capsule' },
      end: { width: 192, height: 192, shape: { type: 'rounded', radius: 20 } },
      progress: 0.25,
    }),
  ).toEqual({
    width: 498,
    height: 123,
    shape: { type: 'rounded', radius: 42.5 },
  });
});

it('should continue from fitted visible rounding when an overshooting transition is redirected', () => {
  const visible = lerpMateoRoundedShape({
    begin: { width: 48, height: 48, shape: 'capsule' },
    end: { width: 320, height: 640, shape: { type: 'rounded', radius: 32 } },
    progress: -0.05,
  });
  expect(visible.width).toBeCloseTo(34.4, 10);
  expect(visible.height).toBeCloseTo(18.4, 10);
  expect(visible.shape.radius).toBeCloseTo(9.2, 10);
  const end: MateoRoundedShapeEndpoint = {
    width: 400,
    height: 800,
    shape: { type: 'rounded', radius: 24 },
  };
  expect(lerpMateoRoundedShape({ begin: visible, end, progress: 0 })).toEqual(
    visible,
  );
  const midway = lerpMateoRoundedShape({ begin: visible, end, progress: 0.5 });
  expect(midway.width).toBeCloseTo(217.2, 10);
  expect(midway.height).toBeCloseTo(409.2, 10);
  expect(midway.shape.radius).toBeCloseTo(16.6, 10);
});

it('should leave caller geometry unchanged when returning an interpolated frame', () => {
  const begin = Object.freeze({ ...mateoPill });
  const end = Object.freeze({
    width: 320,
    height: 180,
    shape: Object.freeze({ type: 'rounded' as const, radius: 24 }),
  });
  expect(lerpMateoRoundedShape({ begin, end, progress: 0.5 })).toEqual({
    width: 260,
    height: 118,
    shape: { type: 'rounded', radius: 26 },
  });
  expect(begin).toEqual({ width: 200, height: 56, shape: 'capsule' });
  expect(end).toEqual({
    width: 320,
    height: 180,
    shape: { type: 'rounded', radius: 24 },
  });
});

describe('invalid JavaScript inputs', () => {
  it.each([
    ['zero width', { width: 0 }],
    ['negative height', { height: -1 }],
    ['nonfinite width', { width: Infinity }],
    ['NaN height', { height: NaN }],
    ['missing width', { width: undefined }],
    ['string width', { width: '200' }],
    ['negative radius', { shape: { type: 'rounded', radius: -1 } }],
    ['nonfinite radius', { shape: { type: 'rounded', radius: Infinity } }],
    ['NaN radius', { shape: { type: 'rounded', radius: NaN } }],
    ['missing radius', { shape: { type: 'rounded' } }],
    ['unknown shape', { shape: 'pill' }],
    ['null shape', { shape: null }],
  ])(
    'should reject both endpoints when an endpoint has %s',
    (_name, invalid) => {
      const endpoint = { ...mateoPill, ...invalid };
      for (const options of [
        { begin: endpoint, end: mateoPill, progress: 1 },
        { begin: mateoPill, end: endpoint, progress: 0 },
      ]) {
        expect(() =>
          Reflect.apply(lerpMateoRoundedShape, undefined, [options]),
        ).toThrow(TypeError);
      }
    },
  );

  it.each([NaN, Infinity, -Infinity])(
    'should reject progress %s when it is nonfinite',
    (progress) => {
      expect(() =>
        lerpMateoRoundedShape({ begin: mateoPill, end: mateoPill, progress }),
      ).toThrow(TypeError);
    },
  );

  it.each([
    ['zero dimension', 200, 100, 2],
    ['negative dimension', 200, 100, 3],
    ['overflow', 1, 1e308, 1e308],
  ])(
    'should reject the frame when extrapolation produces %s',
    (_name, beginWidth, endWidth, progress) => {
      expect(() =>
        lerpMateoRoundedShape({
          begin: { ...mateoPill, width: beginWidth },
          end: { ...mateoPill, width: endWidth },
          progress,
        }),
      ).toThrow(TypeError);
    },
  );
});
